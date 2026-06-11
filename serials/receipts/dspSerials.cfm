<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/24/2006
	Function: 		This page displays serial numbers in view-only format
	Template:		dspSerials.cfm
	Task:			serials_receipts_serials_view
--->
	<cfset objPORCPH1 = createObject("component", "admin.assets.cfcs.PORCPH1")>
	<cfset objPORCPL = createObject("component", "admin.assets.cfcs.PORCPL")>
	<cfset objSerialsReceipts = createObject("component", "admin.assets.cfcs.SerialsReceipts")>

	<!--- Get a structure of the Receipt header --->
	<cfset strHeader = objPORCPH1.getRecord(URL.RCPHSEQ)>
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "RCPHSEQ", URL.RCPHSEQ, True)>
	<cfset structInsert(SearchRecord, "RCPLREV", URL.RCPLREV, True)>
	<!--- Get a query of the Receipt detail --->
	<cfset qryDetail = objPORCPL.searchRecords(SearchRecord, "query")>
	<!--- Get a query of the serial numbers entered --->
	<cfset qrySerialsReceipts = objSerialsReceipts.searchRecords(SearchRecord, "query", "SortOrder")>
</cfsilent>

<script language="javascript">
	window.onload = init;
	function init() {
		var ref = document.getElementById("LinkBack");
		ref.focus();
	}
	function confirmPrint() {
		var msg = "You are about to print bar code labels for all serial numbers for this receipt.  Are you sure you want to continue?";
		if(confirm(msg)) { return true; }
		else { return false; }
	}
	function confirmDelete() {
		var msg = "You are about to DELETE all serial numbers posted for this item, and reverse all entries that were made in the master list of serial numbers and serial number audit trail.  It will essentially allow you to start over with this item.  Are you sure you want to continue?";
		if(confirm(msg)) { 
			document.detailform2.DeleteAll.disabled = true;
			document.getElementById("Posting").style.visibility = "visible";		
		    window.document.detailform2.submit();
		}
		else { return false; }
	}
</script>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objSerialsReceipts.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<!--- link back --->
<tr>
	<td class="textsmall" align="right">
		<a href="index.cfm?task=serials_receipts_items_list&RCPHSEQ=#urlEncodedFormat(URL.RCPHSEQ)#" id="LinkBack">
			<font style="background-color:FFFFCC; text-decoration:underline">Back to Receipt Item List</font>
		</a>
	</td>
</tr>

<tr>
<td valign="top" class="textmain">
	<!--- HEADER INFORMATION --->
	<cfinclude template="headerInfo.cfm">
	
	<!--- DETAIL INFORMATION --->
	<cfif NOT isDefined("URL.PostingAll")>
		<cfinclude template="detailInfo.cfm">
	</cfif>
</td>
</tr>
<tr><td>&nbsp;</td></tr>

<cfif NOT isDefined("URL.PostingAll")>
	<tr>
	<td valign="top" class="textmain">
		<table cellpadding="2" cellspacing="0" width="100%" border="0">
	
		<form action="index.cfm?task=serials_receipts_serials_reprint&RequestTimeout=6000" method="Post" name="detailform">
		<input type="hidden" name="RCPHSEQ" value="#URL.RCPHSEQ#">
		<input type="hidden" name="RCPLREV" value="#URL.RCPLREV#">
			<tr>
				<td valign="top" class="textmain" colspan="2">
					<b>Bar Code Labels Printed for these items?</b>&nbsp;&nbsp;#yesNoFormat(qrySerialsReceipts.BarCodesPrinted)#
						<br><input type="submit" name="ButtonClicked" value="Print Bar Code Labels" onclick="return confirmPrint()">
				</td>
			</tr>
		</form>

		<form action="index.cfm?task=serials_receipts_serials_delete&RequestTimeout=6000" method="Post" name="detailform2">
		<input type="hidden" name="RCPHSEQ" value="#URL.RCPHSEQ#">
		<input type="hidden" name="RCPLREV" value="#URL.RCPLREV#">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<!--- "DELETE ALL" BUTTON --->
				<td colspan="2">
					<input type="submit" name="DeleteAll" value="Delete All" onclick="return confirmDelete()">
				</td>
			</tr>
			<tr id="Posting" style="visibility:hidden;">
				<td valign="top" colspan="2" align="center" class="textmain">
					<font color="FF0000">Deleting Serial Numbers - Please Wait</font>
				</td>
			</tr>
		</form>
		
		<tr>
			<td valign="top" class="textmain" colspan="2"><b>Serial Numbers:</b></td>
		</tr>
		
		<cfloop query="qrySerialsReceipts">
			<tr>
				<td valign="top" class="textmain" width="20%">&nbsp;</td>
				<td valign="top" class="textmain">#qrySerialsReceipts.SerialNumber#</td>
			</tr>
		</cfloop>
		</table>
	</td>
	</tr>
<cfelse>
	<tr>
		<td valign="top" class="textmain">
			All serial numbers have been sucessfully posted for all items of this Receipt.<br>
			Click the above <a href="index.cfm?task=serials_receipts_items_list&RCPHSEQ=#urlEncodedFormat(URL.RCPHSEQ)#">link</a> to review individual items and their serial numbers.
		</td>
	</tr>
</cfif>
<tr><td>&nbsp;</td></tr>
</table>
</cfoutput>