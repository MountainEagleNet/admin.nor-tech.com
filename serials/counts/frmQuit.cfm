<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/06/2007
	Function: 		This page displays the "quit" page
	Template:		frmQuit.cfm
	Task:			serials_counts_quit
--->
	<cfset objSerialsCounts = createObject("component", "admin.assets.cfcs.SerialsCounts")>
	<cfset stRecord = objSerialsCounts.getDataRecord()>
</cfsilent>

<script language="JavaScript" type="text/JavaScript">
<!--
function quitButton() {
	disableAllButtons();
	document.detailform.WhichButton.value = "Quit";
	window.document.detailform.submit();
}
function continueButton() {
	disableAllButtons();
	document.detailform.WhichButton.value = "Continue";
	window.document.detailform.submit();
}
function disableAllButtons() {
	document.detailform.ButtonClicked[0].disabled = true;
	document.detailform.ButtonClicked[1].disabled = true;
	return true;
}
//-->
</script>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<td valign="top" class="textmain" style="font-size:16px"><font color="0033CC"><b>Quantity Matches Serial Numbers on File</b></font></td>
</tr>

<tr>
<td valign="top" class="textmain">
	<!--- HEADER INFORMATION --->
	<cfinclude template="headerInfo.cfm">
</td>
</tr>
<tr><td>&nbsp;</td></tr>

<tr>
	<td valign="top" class="textmain">
	The quantity that you entered (#stRecord.Quantity#) matches the number of serial numbers that are currently on file for this item and location.<br><br>
	You may quit the process by clicking the "Quit" button, or click "Continue" to scan serial numbers and complete the count.
	</td>
</tr>
<tr><td>&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<form action="index.cfm?task=serials_counts_quit_act" method="Post" name="detailform">
	<input type="hidden" name="WhichButton" value="">
	<table cellpadding="4" cellspacing="0" border="0" width="80%" align="center">
	<tr>
		<!--- "QUIT" BUTTON --->
		<td align="left">
			<input type="submit" name="ButtonClicked" value="Quit" onclick="return quitButton()">
		</td>
		<!--- "CONTINUE" BUTTON --->
		<td align="right">
			<input type="submit" name="ButtonClicked" value="&nbsp;Continue -&raquo;" onclick="return continueButton()">
		</td>
	</tr>
	</table>
	</form>
</td>
</tr>

</table>
</cfoutput>