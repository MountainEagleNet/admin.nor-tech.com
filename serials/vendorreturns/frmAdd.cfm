<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/16/2006
	Function: 		This page displays the form for adding serial number boxes
	Template:		frmAdd.cfm
	Task:			serials_returnsvendor_serials_add
--->
	<cfset objPORETH1 = createObject("component", "admin.assets.cfcs.PORETH1")>
	<cfset objPORETL = createObject("component", "admin.assets.cfcs.PORETL")>
	<cfset objSerialsVendorReturns = createObject("component", "admin.assets.cfcs.SerialsVendorReturns")>

	<cfset stRecord = objSerialsVendorReturns.getDataRecord()>

	<!--- Get a structure of the Vendor Return header --->
	<cfset strHeader = objPORETH1.getRecord(stRecord.RETHSEQ)>
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "RETHSEQ", stRecord.RETHSEQ, True)>
	<cfset structInsert(SearchRecord, "RETLREV", stRecord.RETLREV, True)>
	<!--- Get a query of the Vendor Return detail --->
	<cfset qryDetail = objPORETL.searchRecords(SearchRecord, "query")>

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
	Enter the number of additional input fields you would like to add,<br>
	then click "Add".  To add none, simply enter "0" in the box.
	</td>
</tr>
<tr><td>&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	<form action="index.cfm?task=serials_returnsvendor_serials_edit" method="Post" name="detailform">

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