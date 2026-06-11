<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	01/12/2010
	Function: 		This page displays a form for assigning depot warranty to a system
	Template:		frmWarranty.cfm	
	Task:			config_setup_warranty_edit
--->

<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>
<cfset objConfigComponentCategories = createObject("component", "admin.assets.cfcs.config.ConfigComponentCategories")>
<cfset objConfigWarranty = createObject("component", "admin.assets.cfcs.config.ConfigWarranty")>
<cfset objAdditionalWarranty = createObject("component", "admin.assets.cfcs.config.AdditionalWarranty")>

<cfif isDefined("URL.Validation")>
	<cfset stRecord = objConfigWarranty.getDataRecord()>
	<cfset stErrors = objConfigWarranty.getErrorRecord()>
	<cfset Variables.ConfigSystemID = stRecord.ConfigSystemID>
	<cfset Variables.ConfigComponentCategoryID = stRecord.ConfigComponentCategoryID>
<cfelse>
	<cfset Variables.ConfigSystemID = URL.ConfigSystemID>
	<cfset Variables.ConfigComponentCategoryID = URL.ConfigComponentCategoryID>
	<cfset stRecord = objConfigSystems.getRecord(Variables.ConfigSystemID, "struct")>
	<cfset stErrors = structNew()>
</cfif>	

<cfset strConfigComponentCategory = objConfigComponentCategories.getRecord(Variables.ConfigComponentCategoryID, "struct")>

<cfset qryAdditionalWarranty = objAdditionalWarranty.listRecords()>

<cfset isMaintainedByDefault = objConfigSystems.isMaintainedByDefault(Variables.ConfigSystemID)>

<cfoutput>

<!---
strConfigComponentCategory:<cfdump var="#strConfigComponentCategory#">
--->

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">Component Selection</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objConfigWarranty.getMessage()#</font></td>
</tr>

<cfif isMaintainedByDefault>
	<tr>
		<td valign="top" class="textmain">
			An "X" to the left of a warranty indicates that warranty is used on this system.
		</td>
	</tr>
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
				<td valign="top" class="textmain">#strConfigComponentCategory.CategoryName#</td>
			</tr>
		</table>
	</td>
</tr>


<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	<form action="index.cfm?task=config_setup_warranty_save&RequestTimeout=6000" method="Post" name="detailform">
	<input type="hidden" name="ConfigSystemID" value="#stRecord.ConfigSystemID#">
	<input type="hidden" name="ConfigComponentCategoryID" value="#Variables.ConfigComponentCategoryID#">
	<input type="hidden" name="Name" value='#stRecord.Name#'>
	<cfset TabValue = 1>
	
	<!--- LIST HEADINGS --->
	<tr>
		<td height="18" bgcolor="006633" class="productTitle" colspan="3"><font color="FFFFFF">Depot Warranties</font></td>
	</tr>
	
    <cfif qryAdditionalWarranty.RecordCount EQ 0>
        <tr>
            <td align="center" colspan="3" class="textsmall"><font color="FF0000">There are no Depot Warranties entered.</font></td>
        </tr>
    </cfif>

	<!--- "PLEASE PICK AT LEAST ONE WARRANTY..." VALIDATION ERROR MESSAGE --->
    <cfif structKeyExists(stErrors, "PickOne")>
        <tr>
            <td valign="top" class="textmain" colspan="4"><font color="FF0000">&raquo; #stErrors.PickOne#</font></td>
        </tr>
    </cfif>

    <cfloop query="qryAdditionalWarranty">
        <cfset FieldName = "DEPOT|" & qryAdditionalWarranty.AdditionalWarrantyID>
        <cfset WarrantyIsAssigned = 0>
        <cfif structKeyExists(stRecord,FieldName)>
            <cfset WarrantyIsAssigned = 1>
        <cfelse>
            <cfset SearchRecord = structNew()>
            <cfset structInsert(SearchRecord, "ConfigComponentCategoryID", strConfigComponentCategory.ConfigComponentCategoryID, True)>
            <cfset structInsert(SearchRecord, "AdditionalWarrantyID", qryAdditionalWarranty.AdditionalWarrantyID, True)>
            <cfset qryConfigWarranty = objConfigWarranty.searchRecords(SearchRecord, "query")>
            <cfif qryConfigWarranty.RecordCount NEQ 0>
                <cfset WarrantyIsAssigned = 1>
            </cfif>
        </cfif>
                
        <tr<cfif qryAdditionalWarranty.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
            <td class="textsmall" width="1%" valign="middle">&nbsp;</td>
            <td class="textsmall" width="4%" valign="middle">
                <cfif NOT isMaintainedByDefault>
                    <input type="checkbox" name="DEPOT|#qryAdditionalWarranty.AdditionalWarrantyID#" value="1" tabindex="#TabValue#"
                        <cfif WarrantyIsAssigned>
                            checked
                        </cfif>
                    >
                    <cfset TabValue = TabValue + 1>
                <cfelseif WarrantyIsAssigned>
                    <font color="0000FF"><b>X</b></font>
                <cfelse>
                    &nbsp;
                </cfif>
            </td>
            <td class="textsmall" valign="middle">
                #qryAdditionalWarranty.Name# (#qryAdditionalWarranty.PercentMarkUp#% markup)
            </td>
        </tr>
    </cfloop>

	<tr>
		<td valign="top" colspan="3" align="center">
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