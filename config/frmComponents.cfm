<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/08/2006
	Function: 		This page displays a form for assigning components to a system
	Template:		frmComponents.cfm	
	Task:			config_setup_components_edit
--->

<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>
<cfset objConfigComponentCategories = createObject("component", "admin.assets.cfcs.config.ConfigComponentCategories")>
<cfset objConfigComponents = createObject("component", "admin.assets.cfcs.config.ConfigComponents")>
<cfset objAdditionalWarranty = createObject("component", "admin.assets.cfcs.config.AdditionalWarranty")>


<cfif isDefined("URL.Validation")>
	<cfset stRecord = objConfigComponents.getDataRecord()>
	<cfset stErrors = objConfigComponents.getErrorRecord()>
	<cfset Variables.ConfigSystemID = stRecord.ConfigSystemID>
	<cfset Variables.ConfigComponentCategoryID = stRecord.ConfigComponentCategoryID>
<cfelse>
	<cfset Variables.ConfigSystemID = URL.ConfigSystemID>
	<cfset Variables.ConfigComponentCategoryID = URL.ConfigComponentCategoryID>
	<cfset stRecord = objConfigSystems.getRecord(Variables.ConfigSystemID, "struct")>
	<cfset stErrors = structNew()>
</cfif>	

<cfset SearchRecord = structNew()>
<cfset structInsert(SearchRecord, "ConfigComponentCategoryID", Variables.ConfigComponentCategoryID, True)>
<cfset qryConfigComponentCategories = objConfigComponentCategories.searchRecords(SearchRecord, "query")>

<cfif qryConfigComponentCategories.IsAdditionalWarranty EQ 1>
    <cflocation url="index.cfm?task=config_setup_warranty_edit&ConfigSystemID=#urlEncodedFormat(Variables.ConfigSystemID)#&ConfigComponentCategoryID=#urlEncodedFormat(Variables.ConfigComponentCategoryID)#&RequestTimeout=6000">
</cfif>

<cfset qryAllConfigComponents = objConfigComponents.listRecordsForParent("ConfigComponentCategoryID", Variables.ConfigComponentCategoryID)>

<cfset isMaintainedByDefault = objConfigSystems.isMaintainedByDefault(Variables.ConfigSystemID)>

<cfoutput>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">Component Selection</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objConfigComponents.getMessage()#</font></td>
</tr>

<cfif qryAllConfigComponents.RecordCount GT 0>
	<cfif NOT isMaintainedByDefault>
        <tr>
            <td valign="top" class="textmain">
                <font color="FF0000">Warning:</font> Unchecking any component below will remove that component from this system, and will remove (delete) any previously entered markup percentages, fixed prices, etc.  Please use caution!
            </td>
        </tr>
    <cfelse>
        <tr>
            <td valign="top" class="textmain">
                An "X" to the left of a component indicates that component is used on this category.
            </td>
        </tr>
    </cfif>
</cfif>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<td>	
		<table cellpadding="2" cellspacing="0" width="100%" border="0">
			<tr>
				<td valign="middle" class="textmain" width="25%"><b>System Name:</b></td>
				<td valign="top" class="textmain">#stRecord.Name#</td>
			</tr>
			<tr>
				<td valign="middle" class="textmain"><b>Category Name:</b></td>
				<td valign="top" class="textmain">#qryConfigComponentCategories.CategoryName#</td>
			</tr>
		</table>
	</td>
</tr>


<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	<form action="index.cfm?task=config_setup_components_save&RequestTimeout=6000" method="Post" name="detailform">
	<input type="hidden" name="ConfigSystemID" value="#stRecord.ConfigSystemID#">
	<input type="hidden" name="ConfigComponentCategoryID" value="#Variables.ConfigComponentCategoryID#">
	<input type="hidden" name="Name" value='#stRecord.Name#'>
	<cfset TabValue = 1>
	
	<!--- LIST HEADINGS --->
	<tr>
		<td height="18" bgcolor="006633" class="productTitle" colspan="4"><font color="FFFFFF">Components</font></td>
	</tr>
	
	<!--- DATA --->
	<cfif qryConfigComponentCategories.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="4" class="productTitle"><font color="FF0000">There are no Component Categories defined for this system.</font></td>
		</tr>
	</cfif>

	<cfloop query="qryConfigComponentCategories">
		<cfset CURRENTConfigComponentCategoryID = qryConfigComponentCategories.ConfigComponentCategoryID>
        <cfset qryItems = objConfigComponents.getConfigurableItems(qryConfigComponentCategories.CATEGORY)>

        <!--- "NO COMPONENTS FOUND FOR THIS CATEGORY" VALIDATION ERROR MESSAGE --->
        <cfif qryItems.RecordCount EQ 0>
            <tr>
                <td align="center" colspan="4" class="textsmall"><font color="FF0000">There are no Components in ACCPAC that are listed as 'Configurable' for category '#qryConfigComponentCategories.CategoryName#'.</font></td>
            </tr>
        </cfif>

        <cfloop query="qryItems">
            <cfset FieldName = "COMP|" & CURRENTConfigComponentCategoryID & "|" & qryItems.ITEMNO>
            <cfset ComponentIsAssigned = 0>
            <cfif structKeyExists(stRecord,FieldName)>
                <cfset ComponentIsAssigned = 1>
            <cfelse>
                <cfset SearchRecord = structNew()>
                <cfset structInsert(SearchRecord, "ConfigComponentCategoryID", CURRENTConfigComponentCategoryID, True)>
                <cfset structInsert(SearchRecord, "ITEMNO", qryItems.ITEMNO, True)>
                <cfset qryConfigComponents = objConfigComponents.searchRecords(SearchRecord, "query")>
                <cfif qryConfigComponents.RecordCount NEQ 0>
                    <cfset ComponentIsAssigned = 1>
                </cfif>
            </cfif>
                    
            <tr<cfif qryItems.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
                <td class="textsmall" width="1%" valign="middle">&nbsp;</td>
                <td class="textsmall" width="4%" valign="middle">
                    <cfif ComponentIsAssigned><font color="0000FF"><b>X</b></font><cfelse>&nbsp;</cfif>
                </td>
                <td class="textsmall" valign="middle">
                    #qryItems.DESC#
                </td>
                <td class="textsmall" valign="middle">
                   #trim(qryItems.ITEMNO)#
                </td>
            </tr>
        </cfloop>
    
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