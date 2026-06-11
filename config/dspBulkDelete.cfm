<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	10/27/2008
	Function: 		Delete Component - Response Page
	Template:		dspBulkDelete.cfm
	Task:			config_setup_bulkdelete_dsp
--->
	
<cfset objConfigComponents = createObject("component", "admin.assets.cfcs.config.ConfigComponents")>
<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>
<cfset objComponentCategories = createObject("component", "admin.assets.cfcs.config.ComponentCategories")>

<cfset strBulkDelete = objConfigComponents.getDataRecord()>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="1" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle" colspan="3">
		Delete System Component
	</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain" colspan="3"><font color="FF0000">#objConfigComponents.getMessage()#</font></td>
</tr>

<tr><td>&nbsp;</td></tr>

<!--- Systems Deleted From --->
<cfif strBulkDelete.qrySystemsDeleted.RecordCount GT 0>
    <tr>
        <td valign="top" class="subpagetitle" colspan="3">
            <font color="FF0000"><em>Deleted</em></font>
        </td>
    </tr>
    <tr>
        <td valign="top" class="textmain" colspan="3">
            The component was deleted from the following 
            <cfif strBulkDelete.qrySystemsDeleted.RecordCount EQ 1>
                system:
            <cfelse>
                #strBulkDelete.qrySystemsDeleted.RecordCount# systems for the categories listed:
            </cfif>
       </td>
    </tr>
    <tr>
        <td height="18" bgcolor="006633" class="productTitle" width="10%"><font color="FFFFFF">&nbsp;</font></td>
        <td height="18" bgcolor="006633" class="productTitle" width="45%"><font color="FFFFFF">System</font></td>
        <td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Category</font></td>
    </tr>
    <cfloop query="strBulkDelete.qrySystemsDeleted">
    	<cfset strConfigSystem = objConfigSystems.getRecord(strBulkDelete.qrySystemsDeleted.ConfigSystemID)>
    	<cfset strComponentCategory = objComponentCategories.getRecord(strBulkDelete.qrySystemsDeleted.ComponentCategoryID)>
        <tr>
            <td>&nbsp;</td>
            <td valign="top" class="textmain">#strConfigSystem.Name#</td>
            <td valign="top" class="textmain">#strComponentCategory.Name#</td>
        </tr>
    </cfloop>
    <tr><td>&nbsp;</td></tr>
</cfif>

<!--- Systems NOT Deleted From --->
<cfif strBulkDelete.qrySystemsNotDeleted.RecordCount GT 0>
    <tr>
        <td valign="top" class="subpagetitle" colspan="3">
            <font color="FF0000"><em>Not Deleted</em></font>
        </td>
    </tr>
    <tr>
        <td valign="top" class="textmain" colspan="3">
            The component was not deleted from the following 
            <cfif strBulkDelete.qrySystemsNotDeleted.RecordCount EQ 1>
                system,
            <cfelse>
                #strBulkDelete.qrySystemsNotDeleted.RecordCount# systems,
            </cfif>
            since it is entered as the default component for the category listed:
       </td>
    </tr>
    <tr>
        <td height="18" bgcolor="006633" class="productTitle" width="10%"><font color="FFFFFF">&nbsp;</font></td>
        <td height="18" bgcolor="006633" class="productTitle" width="45%"><font color="FFFFFF">System</font></td>
        <td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Category</font></td>
    </tr>
    <cfloop query="strBulkDelete.qrySystemsNotDeleted">
    	<cfset strConfigSystem = objConfigSystems.getRecord(strBulkDelete.qrySystemsNotDeleted.ConfigSystemID)>
    	<cfset strComponentCategory = objComponentCategories.getRecord(strBulkDelete.qrySystemsNotDeleted.ComponentCategoryID)>
        <tr>
            <td>&nbsp;</td>
            <td valign="top" class="textmain">#strConfigSystem.Name#</td>
            <td valign="top" class="textmain">#strComponentCategory.Name#</td>
        </tr>
    </cfloop>
</cfif>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr><!--- Instructions --->
	<td valign="top" class="textmain" colspan="3">
		Delete another component by <a href="index.cfm?task=config_setup_bulkdelete_frm">clicking here</a>.
	</td>
</tr>
<tr><td>&nbsp;</td></tr>

</table>
</cfoutput>