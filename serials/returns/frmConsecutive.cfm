<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	07/12/2007
	Function: 		This page displays the form for entering quantity for the "Consecutive Order 2" function
	Template:		frmConsecutive.cfm
	Task:			serials_returns_consec_qty
--->
	<cfset objRAHEAD = createObject("component", "admin.assets.cfcs.RAHEAD")>
	<cfset objRADET = createObject("component", "admin.assets.cfcs.RADET")>
	<cfset objSerialsReturns = createObject("component", "admin.assets.cfcs.SerialsReturns")>

	<cfset stRecord = objSerialsReturns.getDataRecord()>

	<!--- Get a structure of the Receipt header --->
	<cfset strHeader = objRAHEAD.getRecord(stRecord.RMAUNIQ)>
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "RMAUNIQ", stRecord.RMAUNIQ, True)>
	<cfset structInsert(SearchRecord, "LINENUM", stRecord.LINENUM, True)>
	<!--- Get a query of the Receipt detail --->
	<cfset qryDetail = objRADET.searchRecords(SearchRecord, "query")>

</cfsilent>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

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
		Enter the <i>total</i> quantity of serial numbers that you want to number consecutively (including the one that you scanned), then click "Continue".
	</td>
</tr>
<tr><td>&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	<form action="index.cfm?task=#URL.ForwardTask#" method="Post" name="detailform">

	<tr>
		<td valign="top" class="textmain" width="40%"><b>Quantity:</b></td>
		<td valign="top" class="textmain">
			<input name="ConsecutiveQuantity" value="" size="10" maxlength="50">
		</td>
	</tr>

	<tr><td>&nbsp;</td></tr>
	<tr>
	<td valign="top" colspan="2" align="center">
		<table cellpadding="4" cellspacing="0" border="0" width="50%" align="center">
		<tr>
			<!--- "CONTINUE" BUTTON --->
			<td align="center">
				<input type="submit" name="ButtonClicked" value="Continue">
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
document.detailform['ConsecutiveQuantity'].focus(); document.detailform['ConsecutiveQuantity'].select();
-->
</script>