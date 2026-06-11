<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	10/05/2006
	Function: 		This page displays the form for adding serial number boxes
	Template:		frmAdd.cfm
	Task:			serials_counts_serials_add
--->
	<cfset objSerialsCounts = createObject("component", "admin.assets.cfcs.SerialsCounts")>

	<cfset stRecord = objSerialsCounts.getDataRecord()>
</cfsilent>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<!--- HEADER INFORMATION --->
	<cfinclude template="headerInfo.cfm">
</td>
</tr>
<tr><td>&nbsp;</td></tr>

<tr>
	<td valign="top" class="textmain">
	Enter the number of additional input fields you would like to add,<br>
	then click "Add".  To add none, simply enter "0" in the box.
	</td>
</tr>
<tr><td>&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	<form action="index.cfm?task=serials_counts_serials_edit" method="Post" name="detailform">

	<tr>
		<td valign="top" class="textmain" width="40%"><b>Number of Fields to Add:</b></td>
		<td valign="top" class="textmain">
			<input name="NumberToAdd" value="1" size="10" maxlength="50">
		</td>
	</tr>

	<tr><td>&nbsp;</td></tr>
	<tr>
	<td valign="top" colspan="2" align="center">
		<table cellpadding="4" cellspacing="0" border="0" width="50%" align="center">
		<tr>
			<!--- "ADD" BUTTON --->
			<td align="center">
				<input type="submit" name="ButtonClicked" value="Add">
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

<script language="JavaScript" type="text/JavaScript">
<!--
document.detailform['NumberToAdd'].focus(); document.detailform['NumberToAdd'].select();
-->
</script>