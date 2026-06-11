<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/19/2006
	Function: 		This page displays a form for assigning resellers to a system
	Template:		frmAssignResellers.cfm
	Task:			config_setup_resellers_edit
--->
<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>
<cfset objResellerSystems = createObject("component", "admin.assets.cfcs.config.ResellerSystems")>
<cfset objConfigComponentsResellers = createObject("component", "admin.assets.cfcs.config.ConfigComponentsResellers")>

<cfif isDefined("URL.Validation")>
	<cfset stRecord = objConfigSystems.getDataRecord()>
	<cfset stErrors = objConfigSystems.getErrorRecord()>
<cfelse>
	<cfset stRecord = objConfigSystems.getRecord(URL.ConfigSystemID)>
	<cfset stErrors = structNew()>
</cfif>

<cfset qryResellers = objConfigComponentsResellers.listResellersForSalesRep()>

<cfoutput>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">Assign Resellers</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objConfigSystems.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="2" width="100%" border="0">
	<form action="index.cfm?task=config_setup_resellers_save&RequestTimeout=6000" method="Post" name="detailform">
	<input type="hidden" name="ConfigSystemID" value="#stRecord.ConfigSystemID#">
	<input type="hidden" name="AssignAllResellers" value="AsChecked">Assign this system only to the resellers that are checked below:

	<!--- LIST HEADINGS --->
	<tr>
		<td height="18" bgcolor="006633" class="productTitle" colspan="2"><font color="FFFFFF">Resellers</font></td>
	</tr>
	
	<!--- DATA --->
	<cfif qryResellers.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="2" class="productTitle"><font color="FF0000">You have no Resellers defined.</font></td>
		</tr>
	</cfif>

	<cfloop query="qryResellers">
		<cfset ResellerIsAssigned = 0>
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ConfigSystemID", stRecord.ConfigSystemID, True)>
		<cfset structInsert(SearchRecord, "CustomerID", qryResellers.CustomerID, True)>
		<cfset qryResellerSystems = objResellerSystems.searchRecords(SearchRecord, "query")>
		<cfif qryResellerSystems.RecordCount NEQ 0>
			<cfset ResellerIsAssigned = 1>
		</cfif>
	
		<tr<cfif qryResellers.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
			<td class="textsmall" width="10%" align="center">
				<cfif ResellerIsAssigned>
					X
					<input type="hidden" name="RESELLER_#qryResellers.CustomerID#" value="1">
				<cfelse>
					&nbsp;
				</cfif>
			</td>
			<td class="textsmall">
				#qryResellers.Company#
			</td>
		</tr>
	</cfloop>

	<tr>
	<td valign="top" colspan="2" align="center">
		<table cellpadding="4" cellspacing="0" border="0" width="60%">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="right"><!--- "CONTINUE" BUTTON --->
				<input type="submit" name="ButtonClicked" value="&nbsp;Continue -&raquo;">
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