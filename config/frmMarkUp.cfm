<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/12/2006
	Function: 		This page displays a form for entering markup percentages and fixed prices
	Template:		frmMarkUp.cfm	
	Task:			config_setup_markup_edit
--->

<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>
<cfset objConfigComponentCategories = createObject("component", "admin.assets.cfcs.config.ConfigComponentCategories")>
<cfset objConfigComponents = createObject("component", "admin.assets.cfcs.config.ConfigComponents")>
<cfset objConfigComponentsResellers = createObject("component", "admin.assets.cfcs.config.ConfigComponentsResellers")>
<cfset objConfigWarranty = createObject("component", "admin.assets.cfcs.config.ConfigWarranty")>

<cfif isDefined("URL.Validation")>
	<cfset stRecord = objConfigComponents.getDataRecord()>
	<cfset stErrors = objConfigComponents.getErrorRecord()>
	<cfset Variables.ConfigSystemID = stRecord.ConfigSystemID>
<cfelse>
	<cfset Variables.ConfigSystemID = URL.ConfigSystemID>
	<cfset stRecord = objConfigSystems.getRecord(Variables.ConfigSystemID, "struct")>
	<cfset stErrors = structNew()>
</cfif>	

<cfset qryConfigComponentCategories = objConfigComponentCategories.listRecordsForParent("ConfigSystemID", Variables.ConfigSystemID, "CategorySortOrder")>
<cfset isMaintainedByDefault = objConfigSystems.isMaintainedByDefault(Variables.ConfigSystemID)>

<script language="javascript">
	function openWindow(url_string, width, height)	{
		var options = "scrollbars=1,resizable=1,height="+height+",width="+width;
		new_window = window.open(url_string, "newwin", options );
		return false;
	}	
</script>

<cfoutput>

<!---<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">--->
<table width="575" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle" colspan="2">Default Component Selection Page</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain" colspan="2"><font color="FF0000">#objConfigComponents.getMessage()#</font></td>
</tr>

<tr><!--- Help --->
	<td valign="top" class="textmain" colspan="2">
  		An "X" to the left of a component indicates that component is the default component for that category.
	</td>
</tr>

<!--- spacer --->
<tr><td class="textsmall" colspan="2">&nbsp;</td></tr>

<tr>
	<td colspan="2">	
		<table cellpadding="2" cellspacing="0" width="100%" border="0">
			<tr>
				<td valign="middle" class="textmain" width="20%"><b>System Name:</b></td>
				<td valign="top" class="textmain">#stRecord.Name#</td>
			</tr>
		</table>
	</td>
</tr>

<tr>
<td valign="top" class="textmain" colspan="2">
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	<form action="index.cfm?task=config_setup_markup_save&RequestTimeout=6000" method="Post" name="detailform">
	<input type="hidden" name="ConfigSystemID" value="#stRecord.ConfigSystemID#">
	<input type="hidden" name="Name" value='#stRecord.Name#'>
	<cfset TabValue = 1>
	
	<!--- LIST HEADINGS --->
	<tr>
		<td height="18" bgcolor="006633" class="productTitle" colspan="4"><font color="FFFFFF">Category / Component</font></td>
	</tr>
	
	<!--- DATA --->
	<cfif qryConfigComponentCategories.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="4" class="productTitle"><font color="FF0000">There are no Component Categories defined for this system.</font></td>
		</tr>
	</cfif>

	<!--- CATEGORIES --->
	<cfloop query="qryConfigComponentCategories">
    	<cfif qryConfigComponentCategories.CategoryName IS NOT "EnergyStar" AND 
			 (qryConfigComponentCategories.CategoryName IS NOT "Power Supply" OR 
			  NOT objConfigSystems.isPowerSupplyAutoSelect(Variables.ConfigSystemID))>
            
            <cfset CURRENTConfigComponentCategoryID = qryConfigComponentCategories.ConfigComponentCategoryID>
    
            <cfif qryConfigComponentCategories.isAdditionalWarranty IS NOT "1">        
                <tr style="background-color:##e5e5e6">
                    <td class="textmain" colspan="2">#qryConfigComponentCategories.CategoryName#</td>
        
        
                    <!--- DEFAULT QUANTITY --->
                    <cfset FieldName = "DEFQTY|" & CURRENTConfigComponentCategoryID>
                    <cfset FieldValue = qryConfigComponentCategories.DefaultQuantity>
                    <cfif structKeyExists(stRecord, FieldName)>
                        <cfset FieldValue = stRecord[FieldName]>
                    </cfif>
                    <cfif FieldValue IS "0">
                        <cfset FieldValue = 1>
                    </cfif>
                    <td class="textmain" align="right">
                        Default Quantity: #FieldValue#
                    </td>
                    
                    <!--- MAXIMUM QUANTITY --->
                    <cfset FieldName = "MAXQTY|" & CURRENTConfigComponentCategoryID>
                    <cfset FieldValue = qryConfigComponentCategories.MaximumQuantity>
                    <cfif structKeyExists(stRecord, FieldName)>
                        <cfset FieldValue = stRecord[FieldName]>
                    </cfif>
                    <cfif FieldValue IS "0">
                        <cfset FieldValue = 1>
                    </cfif>
                    <td class="textmain" align="right">
                        Maximum Quantity: #FieldValue#
                    </td>
                    
                </tr>          
                
                <cfset qryConfigComponents = objConfigComponents.listRecordsForParent("ConfigComponentCategoryID", CURRENTConfigComponentCategoryID, "ITEMNO")>
        
                <!--- "NO COMPONENTS FOUND FOR THIS CATEGORY" VALIDATION ERROR MESSAGE --->
                <cfif qryConfigComponents.RecordCount EQ 0>
                    <tr>
                        <td align="center" colspan="4" class="textsmall"><font color="FF0000">There no Components for category '#qryConfigComponentCategories.CategoryName#'.</font></td>
                    </tr>
                </cfif>
        
        
                <!--- COMPONENTS --->
                <cfloop query="qryConfigComponents">
                    <cfset CURRENTConfigComponentID = qryConfigComponents.ConfigComponentID>
                    <tr>
                        <td class="textsmall" width="10%">&nbsp;</td>
                        
                        <!--- DEFAULT COMPONENT RADIO BUTTON --->
                        <cfset FieldName = "DEFCOMP_" & CURRENTConfigComponentCategoryID>
                        <cfset ThisOneIsChecked = 0>
                        <cfif structKeyExists(stRecord, FieldName) AND stRecord[FieldName] IS qryConfigComponents.ConfigComponentID>
                            <cfset ThisOneIsChecked = 1>
                        <cfelseif isBoolean(qryConfigComponents.DefaultComponent) AND qryConfigComponents.DefaultComponent>
                            <cfset ThisOneIsChecked = 1>
                        <cfelseif qryConfigComponents.RecordCount EQ 1>
                            <cfset ThisOneIsChecked = 1>
                        </cfif>
                        <td class="textsmall" width="1%" valign="middle">
                            <cfif ThisOneIsChecked>
                                <font color="0000FF"><b>X</b></font> 
							<cfelse>
								&nbsp;
                            </cfif>                    
                        </td>
                        
                        <td colspan="2" class="textsmall" valign="middle">
                            <cfif trim(qryConfigComponents.ITEMNO) IS "[NONE]">
                                None
                            <cfelse>
                                #objConfigComponents.getItemDescription(qryConfigComponents.ITEMNO)#
                            </cfif>
                        </td>
                    </tr>
                </cfloop>
            
            <!--- DEPOT WARRANTY --->
            <cfelse>
                <tr style="background-color:##e5e5e6">
                    <td class="textmain" colspan="4">#qryConfigComponentCategories.CategoryName#</td>
                </tr>
               <cfset qryConfigWarranty = objConfigWarranty.listRecordsForParent("ConfigComponentCategoryID", CURRENTConfigComponentCategoryID, "SortOrder")>
        
                <!--- "NO COMPONENTS FOUND FOR THIS CATEGORY" VALIDATION ERROR MESSAGE --->
                <cfif qryConfigWarranty.RecordCount EQ 0>
                    <tr>
                        <td align="center" colspan="4" class="textsmall"><font color="FF0000">There no Warranties for category '#qryConfigComponentCategories.CategoryName#'.</font></td>
                    </tr>
                </cfif>
                <!--- COMPONENTS --->
                <cfloop query="qryConfigWarranty">
                    <tr>
                        <td class="textsmall" width="10%">&nbsp;</td>
                        
                        <!--- DEFAULT COMPONENT RADIO BUTTON --->
                        <cfset FieldName = "DEFCOMP_" & CURRENTConfigComponentCategoryID>
                        <cfset ThisOneIsChecked = 0>
                        <cfif structKeyExists(stRecord, FieldName) AND stRecord[FieldName] IS qryConfigWarranty.ConfigWarrantyID>
                            <cfset ThisOneIsChecked = 1>
                        <cfelseif isBoolean(qryConfigWarranty.DefaultComponent) AND qryConfigWarranty.DefaultComponent>
                            <cfset ThisOneIsChecked = 1>
                        <cfelseif qryConfigWarranty.RecordCount EQ 1>
                            <cfset ThisOneIsChecked = 1>
                        </cfif>
                        <td class="textsmall" width="1%" valign="middle">
                            <cfif ThisOneIsChecked>
                                <font color="0000FF"><b>X</b></font>
							<cfelse>
								&nbsp;
                            </cfif>                    
                        </td>
                        
                        <td colspan="2" class="textsmall" valign="middle">
                            #qryConfigWarranty.Name# (#qryConfigWarranty.PercentMarkup#% Markup)
                        </td>
                    </tr>
                </cfloop>
            </cfif>
        </cfif>
	</cfloop>

	<tr>
		<td valign="top" colspan="4" align="center">
			<table cellpadding="4" cellspacing="0" border="0" width="60%">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td align="right"><!--- "CONTINUE" BUTTON --->
					<input type="submit" name="ButtonClicked" value="&nbsp;Continue -&raquo;" tabindex="#TabValue#">
				</td>
			</tr>
			</table>
		</td>
	</tr>

	</form>
	</table>
</td>
</tr>
</table>
</cfoutput>