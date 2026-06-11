<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/22/2006
	Function: 		This page displays the password form
	Template:		frmPassword.cfm
	Task:			serials_receipts_password
--->
	<cfset objPORCPH1 = createObject("component", "admin.assets.cfcs.PORCPH1")>
	<cfset objPORCPL = createObject("component", "admin.assets.cfcs.PORCPL")>
	<cfset objSerialsReceipts = createObject("component", "admin.assets.cfcs.SerialsReceipts")>

	<cfset stRecord = objSerialsReceipts.getDataRecord()>

	<!--- Get a structure of the Receipt header --->
	<cfset strHeader = objPORCPH1.getRecord(stRecord.RCPHSEQ)>
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "RCPHSEQ", stRecord.RCPHSEQ, True)>
	<cfset structInsert(SearchRecord, "RCPLREV", stRecord.RCPLREV, True)>
	<!--- Get a query of the Receipt detail --->
	<cfset qryDetail = objPORCPL.searchRecords(SearchRecord, "query")>

</cfsilent>

<script language="JavaScript" type="text/JavaScript">
<!--
function disableButton() {
  document.detailform.ButtonClicked[1].disabled = true;
  document.getElementById("Posting").style.visibility = "visible";					
  window.document.detailform.submit();
}
//-->
</script>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<td valign="top" class="textmain" style="font-size:16px"><font color="FF0000"><b>Password Required</b></font></td>
</tr>

<tr>
<td valign="top" class="textmain">
	<!--- HEADER INFORMATION --->
	<cfinclude template="headerInfo.cfm">
	
	<!--- DETAIL INFORMATION --->
	<cfinclude template="detailInfo.cfm">
</td>
</tr>
<tr><td>&nbsp;</td></tr>

<tr>
	<td valign="top" class="textmain">
	Please enter the password to continue.<br> 
	</td>
</tr>


<tr>
<td valign="top" class="textmain">
	<form action="index.cfm?task=serials_receipts_password_act" method="Post" name="detailform">
	<input type="hidden" name="RCPHSEQ" value="#stRecord.RCPHSEQ#">
	<input type="hidden" name="RCPLREV" value="#stRecord.RCPLREV#">
	<cfset TabValue = 1>
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	<tr>
		<td width="15%" class="textmain" align="left">
			<strong>Password:</strong>
		</td>
		<td class="textmain" align="left">
			<input type="password" name="Password" size="20" maxlength="50" tabindex="#TabValue#">
			<cfset TabValue = TabValue + 1>
		</td>
	</tr>
	</table>
	
	<table cellpadding="4" cellspacing="0" border="0" width="80%" align="center">
	<tr><td>&nbsp;</td></tr>
	<tr>
		<!--- "BACK" BUTTON --->
		<td align="left">
			<input type="submit" name="ButtonClicked" value="&laquo;- Back&nbsp;">
		</td>
		<!--- "CONTINUE" BUTTON --->
		<td align="right">
			<input type="submit" name="ButtonClicked" value="&nbsp;Continue -&raquo;" tabindex="#TabValue#" onclick="return disableButton()">
		</td>
	</tr>
	<tr id="Posting" style="visibility:hidden;">
		<td valign="top" colspan="2" align="center" class="textmain">
			<font color="FF0000">Posting Serial Numbers - Please Wait</font>
		</td>
	</tr>
	</table>
	</form>
</td>
</tr>

</table>
</cfoutput>

<script language="JavaScript" type="text/JavaScript">
<!--
document.detailform['Password'].focus();document.detailform['Password'].select()
-->
</script>