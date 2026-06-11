<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/31/2007
	Function: 		Add/Edit a Part
	Template:		frmServerOptionSelection.cfm	
--->
<cfset objServerOptionSelections = createObject("component", "admin.assets.cfcs.config.ServerOptionSelections")>

<cfif isDefined("URL.Validation")>
	<cfset stRecord = objServerOptionSelections.getDataRecord()>
	<cfset stErrors = objServerOptionSelections.getErrorRecord()>
<cfelseif NOT isDefined("URL.ServerOptionSelectionID")>
	<cfset stRecord = objServerOptionSelections.newRecord()>
    <cfset structInsert(stRecord, "ServerOptionID", URL.ServerOptionID, True)>
	<cfset stErrors = structNew()>
<cfelse>
	<cfset stRecord = objServerOptionSelections.getRecord(URL.ServerOptionSelectionID)>
	<cfset stErrors = structNew()>
</cfif>
<!---
stRecord:<cfdump var="#stRecord#">
--->

<cfoutput>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">
		Edit/New Server Option Selection
	</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objServerOptionSelections.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="4" width="100%" border="0">
	<form action="index.cfm?task=server_options_selections_save&RequestTimeout=6000" method="Post" name="detailform">
	<input type="hidden" name="ServerOptionSelectionID" value="#stRecord.ServerOptionSelectionID#">
	<input type="hidden" name="ServerOptionID" value="#stRecord.ServerOptionID#">
	<cfset TabValue = 1>


	<tr>
		<td valign="middle" class="textmain" width="30%"><b>Server Option:</b></td>
		<td valign="top" class="textmain">
        	#objServerOptionSelections.getServerOptionName(stRecord.ServerOptionID)#
		</td>
	</tr>

	<!--- Name --->
	<cfif structKeyExists(stErrors, "Name")>
		<tr>
			<td>&nbsp;</td>
			<td valign="bottom" class="textmain"><font color="FF0000">&raquo; #stErrors.Name#</font></td>
		</tr>
	</cfif>
	<tr>
		<td valign="middle" class="textmain"><b>Selection Name:</b> *</td>
		<td valign="top" class="textmain">
			<input name="Name" size="35" maxlength="50" tabindex="#TabValue#" value="#stRecord.Name#" 
				<cfif structKeyExists(stErrors, "Name")>style="border:1px solid red;"</cfif>
			>
			<cfset TabValue = TabValue + 1>
		</td>
	</tr>

	<!--- SortOrder --->
	<cfif structKeyExists(stErrors, "SortOrder")>
		<tr>
			<td>&nbsp;</td>
			<td valign="bottom" class="textmain"><font color="FF0000">&raquo; #stErrors.SortOrder#</font></td>
		</tr>
	</cfif>
	<tr>
		<td valign="middle" class="textmain"><b>Sort Order:</b></td>
		<td valign="top" class="textmain">
			<input name="SortOrder" size="35" maxlength="50" tabindex="#TabValue#" value="#stRecord.SortOrder#" 
				<cfif structKeyExists(stErrors, "SortOrder")>style="border:1px solid red;"</cfif>
			>
			<cfset TabValue = TabValue + 1>
		</td>
	</tr>
	
	<tr>
	<td valign="top" colspan="2" align="center">
		<table cellpadding="4" cellspacing="0" border="0" width="80%">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center"><!--- "SAVE" BUTTON --->
				<input type="submit" name="ButtonClicked" value="Save" tabindex="#TabValue#">
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

<cfif structKeyExists(stErrors, "Name")>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['Name'].focus(); document.detailform['Name'].select()
	-->
	</script>
<cfelse>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['Name'].focus();
	-->
	</script>
</cfif>	