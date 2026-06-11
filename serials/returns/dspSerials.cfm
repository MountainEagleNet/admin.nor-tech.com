<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/28/2006
	Function: 		This page displays serial numbers in view-only format
	Template:		dspSerials.cfm
	Task:			serials_returns_serials_view
--->
	<cfset objRAHEAD = createObject("component", "admin.assets.cfcs.RAHEAD")>
	<cfset objRADET = createObject("component", "admin.assets.cfcs.RADET")>
	<cfset objSerialsReturns = createObject("component", "admin.assets.cfcs.SerialsReturns")>

	<!--- Get a structure of the Return header --->
	<cfset strHeader = objRAHEAD.getRecord(URL.RMAUNIQ)>
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "RMAUNIQ", URL.RMAUNIQ, True)>
	<cfset structInsert(SearchRecord, "LINENUM", URL.LINENUM, True)>
	<!--- Get a query of the Return detail --->
	<cfset qryDetail = objRADET.searchRecords(SearchRecord, "query")>
	<!--- Get a query of the serial numbers entered --->
	<cfset qrySerialsReturns = objSerialsReturns.searchRecords(SearchRecord, "query")>
</cfsilent>

<script language="javascript">
	window.onload = init;
	function init() {
		var ref = document.getElementById("LinkBack");
		ref.focus();
	}
	function confirmPrint() {
		var msg = "You are about to print bar code labels for all serial numbers for this return.  Are you sure you want to continue?";
		if(confirm(msg)) { return true; }
		else { return false; }
	}
	function confirmReceive() {
		var msg = "Are you sure?";
		if(confirm(msg)) { return true; }
		else { return false; }
	}
	function confirmDelete() {
		var msg = "You are about to DELETE all serial numbers posted for this item, and reverse all entries that were made in the master list of serial numbers and serial number audit trail.  It will essentially allow you to start over with this item.  Are you sure you want to continue?";
		if(confirm(msg)) { 
			document.detailform.ButtonClicked.disabled = true;
			document.getElementById("Posting").style.visibility = "visible";		
		    window.document.detailform.submit();
		}
		else { return false; }
	}
</script>

<cfoutput>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objSerialsReturns.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<!--- link back --->
<tr>
	<td class="textsmall" align="right">
		<a href="index.cfm?task=serials_returns_items_list&RMAUNIQ=#urlEncodedFormat(URL.RMAUNIQ)#&RMAAction=#URL.RMAAction#" id="LinkBack">
			<font style="background-color:FFFFCC; text-decoration:underline">Back to Return Item List</font>
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
	
		<form action="index.cfm?task=serials_returns_serials_reprint&RequestTimeout=6000" method="Post" name="detailform">
		<input type="hidden" name="RMAUNIQ" value="#URL.RMAUNIQ#">
		<input type="hidden" name="LINENUM" value="#URL.LINENUM#">
		<input type="hidden" name="RMAAction" value="#URL.RMAAction#">
			<tr>
				<td valign="top" class="textmain" colspan="2">
					<b>Bar Code Labels Printed for these items?</b>&nbsp;&nbsp;
					<cfif isBoolean(qrySerialsReturns.BarCodesPrinted)>
						#yesNoFormat(qrySerialsReturns.BarCodesPrinted)#
					<cfelse>
						No
					</cfif>
					<br><input type="submit" name="ButtonClicked" value="Print Bar Code Labels" onclick="return confirmPrint()">
				</td>
			</tr>
		</form>
	
		<form action="index.cfm?task=serials_returns_serials_delete" method="Post" name="detailform">
		<input type="hidden" name="RMAUNIQ" value="#URL.RMAUNIQ#">
		<input type="hidden" name="LINENUM" value="#URL.LINENUM#">
		<input type="hidden" name="RMAAction" value="#URL.RMAAction#">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<!--- "DELETE ALL" BUTTON --->
				<td colspan="2">
					<input type="submit" name="ButtonClicked" value="Delete All" onclick="return confirmDelete()">
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
	
		<cfif qrySerialsReturns.RecordCount EQ 0>
			<tr>
				<td valign="top" class="textmain" width="20%">&nbsp;</td>
				<td valign="top" class="textmain"><font color="FF0000">None Entered</font></td>
			</tr>
		</cfif>
		
		<cfloop query="qrySerialsReturns">
			<tr>
				<td valign="top" class="textmain" width="20%">&nbsp;</td>
				<td valign="top" class="textmain">#qrySerialsReturns.SerialNumber#</td>
			</tr>
		</cfloop>
		</table>
	</td>
	</tr>
<cfelse>
	<tr>
		<td valign="top" class="textmain">
			All serial numbers have been sucessfully 
			<cfif URL.RMAAction IS "Authorization">
				saved
			<cfelse>
				posted
			</cfif>
			for all items of this RMA.<br>
			Click the above 
			<a href="index.cfm?task=serials_returns_items_list&RMAUNIQ=#urlEncodedFormat(URL.RMAUNIQ)#&RMAAction=#URL.RMAAction#">
				link
			</a> 
			to review individual items and their serial numbers.
		</td>
	</tr>
	<cfif URL.RMAAction IS "Authorization">
		<form action="index.cfm?task=serials_returns_serials_receive" method="Post" name="detailform">
		<input type="hidden" name="RMAUNIQ" value="#URL.RMAUNIQ#">
		<input type="hidden" name="LINENUM" value="#URL.LINENUM#">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td valign="top" class="textmain">
					Click the button below mark all serial numbers for this RMA as received.
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<!--- "RECEIVE ALL" BUTTON --->
				<td colspan="2">
					<input type="submit" name="ButtonClicked" value="Receive All" onclick="return confirmReceive()">
				</td>
			</tr>
		</form>
	</cfif>
</cfif>

</table>
</cfoutput>