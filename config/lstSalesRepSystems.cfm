<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	09/20/2006
	Function: 		This page displays a list of Sales Rep's Systems for the administrator to import
	Template:		lstSalesRepSystems.cfm
	Task:			config_setup_salesrepsystems_list
--->
	<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>

	<!--- Sales Reps' Systems --->
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "DefaultSystem", 0, True)>
	<cfset qryConfigSystems = objConfigSystems.searchRecords(SearchRecord, "query", "FirstName, LastName, TypeSortOrder, Name")>

</cfsilent>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">Sales Reps' Systems List</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objConfigSystems.getMessage()#</font></td>
</tr>

<tr><!--- Instructions --->
	<td valign="top" class="textmain">
		Default Systems can be created from individual sales reps' systems using this interface.<br>
		Select the sales reps' systems you want to import by checking the "Import System" checkboxes and clicking "Import".
	</td>
</tr>


<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<!--- "Back to Your System List" link --->
	<td align="right" class="textmain">
		<a href="index.cfm?task=config_setup_systems_list&DefaultSystems=1">	
			Back to Default System List
		</a>
	</td>
</tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="0" cellspacing="0" width="100%" border="0">
	<form action="index.cfm?task=config_setup_salesrepsystems_copy&RequestTimeout=6000" method="Post" name="detailform">
	<cfset TabValue = 1>

	<!--- LIST HEADINGS --->
	<tr>
		<td height="18" bgcolor="006633" class="productTitle" width="25%"><font color="FFFFFF">Sales Rep</font></td>
		<td height="18" bgcolor="006633" class="productTitle" width="25%"><font color="FFFFFF">Type</font></td>
		<td height="18" bgcolor="006633" class="productTitle" width="25%"><font color="FFFFFF">System Name</font></td>
		<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Import System?</font></td>
	</tr>

	<!--- LIST DATA --->	
	<cfif qryConfigSystems.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="4" class="productTitle"><font color="FF0000">Sorry, there are no Sales Rep Systems defined.</font></td>
		</tr>
	</cfif>
	
	<cfloop query="qryConfigSystems">
		<tr<cfif qryConfigSystems.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>

			<td class="textsmall">#qryConfigSystems.FirstName# #qryConfigSystems.LastName#</td>
			<td class="textsmall">#qryConfigSystems.Type#</td>
			<td class="textsmall">#qryConfigSystems.Name#</td>
			<td class="textsmall" align="center">
				<input type="checkbox" name="SYSTEM|#qryConfigSystems.ConfigSystemID#" value="1" tabindex="#TabValue#">
				<cfset TabValue = TabValue + 1>
			</td>
		</tr>
	</cfloop>

	<tr>
		<td valign="top" colspan="4" align="center">
			<table cellpadding="4" cellspacing="0" border="0" width="60%">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td align="right"><!--- "IMPORT" BUTTON --->
					<input type="submit" name="ButtonClicked" value="Import" tabindex="#TabValue#">
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