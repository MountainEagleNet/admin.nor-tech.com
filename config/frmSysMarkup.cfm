<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/26/2006
	Function: 		This page displays a form for the sales rep to enter Default Markup Percentages
	Template:		frmSysMarkup.cfm
	Task:			config_setup_sysmarkup_edit
--->
<cfset objsalesrep = createObject("component", "admin.assets.cfcs.SalesRep")>

<cfif isDefined("URL.Validation")>
	<cfset stRecord = objsalesrep.getDataRecord()>
	<cfset stErrors = objsalesrep.getErrorRecord()>
<cfelse>
	<cfset stRecord = objsalesrep.getRecordAsStruct(URLDecode(SESSION.salesrepid))>
	<cfset stErrors = structNew()>
</cfif>

<script language="javascript">
	function openWindow(url_string, width, height)	{
		var options = "scrollbars=1,resizable=1,height="+height+",width="+width;
		new_window = window.open(url_string, "newwin", options );
		return false;
	}	
</script>

<!--- Default all percentages to 10 --->
<cfif stRecord.MarkupPctWorkstations IS "">
	<cfset structInsert(stRecord, "MarkupPctWorkstations", 10, True)>
	<cfset objsalesrep.updateMarkupPercentages(stRecord)>
</cfif>
<cfif stRecord.MarkupPctNotebooks IS "">
	<cfset structInsert(stRecord, "MarkupPctNotebooks", 10, True)>
	<cfset objsalesrep.updateMarkupPercentages(stRecord)>
</cfif>
<cfif stRecord.MarkupPctServers IS "">
	<cfset structInsert(stRecord, "MarkupPctServers", 10, True)>
	<cfset objsalesrep.updateMarkupPercentages(stRecord)>
</cfif>

<cfoutput>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">Default Markup Percentages</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objsalesrep.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="1" cellspacing="0" width="100%" border="0">
		<tr>
			<td width="20%" class="textmain" align="left"><b>Sales Rep:</b></td>
			<td class="textmain" align="left">#stRecord.repname#</td>
		</tr>
	</table>
</td>
</tr>
<tr><td>&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	<form action="index.cfm?task=config_setup_sysmarkup_save" method="Post" name="detailform">
	<input type="hidden" name="ID" value="#stRecord.ID#">
	<input type="hidden" name="repname" value="#stRecord.repname#">
	<cfset TabValue = 1>

	<tr>
		<td class="textmain" align="left" colspan="3"><b>Markup Percentages</b></td>
	</tr>
	
	<!--- MarkupPctWorkstations --->
	<cfif structKeyExists(stErrors, "MarkupPctWorkstations")>
		<tr>
			<td colspan="2">&nbsp;</td>
			<td valign="top" class="textmain"><font color="FF0000">&raquo; #stErrors.MarkupPctWorkstations#</font></td>
		</tr>
	</cfif>
	<tr>
		<td valign="middle" class="textmain" width="5%">
		<td valign="middle" class="textmain" width="20%"><b>Workstations:</b></td>
		<td valign="top" class="textmain">
			<input name="MarkupPctWorkstations" size="5" maxlength="50" tabindex="#TabValue#"
				<cfif trim(stRecord.MarkupPctWorkstations) IS "">
					value="10"
				<cfelse>
					value="#stRecord.MarkupPctWorkstations#" 
				</cfif>
				<cfif structKeyExists(stErrors, "MarkupPctWorkstations")>style="border:1px solid red;"</cfif>
			>%
			<cfset TabValue = TabValue + 1>
			&nbsp;&nbsp; (For Example: 10 = 10% markup)
			&nbsp;&nbsp;<a  href="javascript:void(0)" onclick="openWindow('config/markupHelp.cfm',450,300)" class="textmain">Help</a>
		</td>
	</tr>
	
	<!--- MarkupPctNotebooks --->
	<cfif structKeyExists(stErrors, "MarkupPctNotebooks")>
		<tr>
			<td colspan="2">&nbsp;</td>
			<td valign="top" class="textmain"><font color="FF0000">&raquo; #stErrors.MarkupPctNotebooks#</font></td>
		</tr>
	</cfif>
	<tr>
		<td valign="middle" class="textmain">
		<td valign="middle" class="textmain"><b>Notebooks:</b></td>
		<td valign="top" class="textmain">
			<input name="MarkupPctNotebooks" size="5" maxlength="50" tabindex="#TabValue#"
				<cfif trim(stRecord.MarkupPctNotebooks) IS "">
					value="10"
				<cfelse>
					value="#stRecord.MarkupPctNotebooks#" 
				</cfif>
				<cfif structKeyExists(stErrors, "MarkupPctNotebooks")>style="border:1px solid red;"</cfif>
			>%
			<cfset TabValue = TabValue + 1>
			&nbsp;&nbsp; (For Example: 10.5 = 10.5% markup)
			&nbsp;&nbsp;<a  href="javascript:void(0)" onclick="openWindow('config/markupHelp.cfm',450,300)" class="textmain">Help</a>
		</td>
	</tr>

	<!--- MarkupPctServers --->
	<cfif structKeyExists(stErrors, "MarkupPctServers")>
		<tr>
			<td colspan="2">&nbsp;</td>
			<td valign="top" class="textmain"><font color="FF0000">&raquo; #stErrors.MarkupPctServers#</font></td>
		</tr>
	</cfif>
	<tr>
		<td valign="middle" class="textmain">
		<td valign="middle" class="textmain"><b>Servers:</b></td>
		<td valign="top" class="textmain">
			<input name="MarkupPctServers" size="5" maxlength="50" tabindex="#TabValue#"
				<cfif trim(stRecord.MarkupPctServers) IS "">
					value="10"
				<cfelse>
					value="#stRecord.MarkupPctServers#" 
				</cfif>
				<cfif structKeyExists(stErrors, "MarkupPctServers")>style="border:1px solid red;"</cfif>
			>%
			<cfset TabValue = TabValue + 1>
			&nbsp;&nbsp; (For Example: 20 = 20% markup)
			&nbsp;&nbsp;<a  href="javascript:void(0)" onclick="openWindow('config/markupHelp.cfm',450,300)" class="textmain">Help</a>
		</td>
	</tr>

	<tr>
	<td valign="top" colspan="3" align="center">
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

<cfif NOT isDefined("URL.Validation")>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['MarkupPctWorkstations'].focus();
	-->
	</script>
</cfif>	