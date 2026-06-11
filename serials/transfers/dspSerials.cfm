<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/05/2006
	Function: 		This page displays serial numbers in view-only format
	Template:		dspSerials.cfm
	Task:			serials_transfers_serials_view
--->
	<cfset objICTREH = createObject("component", "admin.assets.cfcs.ICTREH")>
	<cfset objICTRED = createObject("component", "admin.assets.cfcs.ICTRED")>
	<cfset objSerialsTransfers = createObject("component", "admin.assets.cfcs.SerialsTransfers")>

	<!--- Get a structure of the Transfer header --->
	<cfset strHeader = objICTREH.getRecord(URL.TRANFENSEQ)>
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "TRANFENSEQ", URL.TRANFENSEQ, True)>
	<cfset structInsert(SearchRecord, "LINENO", URL.LINENO, True)>
	<!--- Get a query of the Transfer detail --->
	<cfset qryDetail = objICTRED.searchRecords(SearchRecord, "query")>
	<!--- Get a query of the serial numbers entered --->
	<cfset qrySerialsTransfers = objSerialsTransfers.searchRecords(SearchRecord, "query")>
</cfsilent>

<script language="javascript">
	window.onload = init;
	function init() {
		var ref = document.getElementById("LinkBack");
		ref.focus();
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
	<td valign="top" class="textmain"><font color="FF0000">#objSerialsTransfers.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<!--- link back --->
<tr>
	<td class="textsmall" align="right">
		<a href="index.cfm?task=serials_transfers_items_list&TRANFENSEQ=#urlEncodedFormat(URL.TRANFENSEQ)#" id="LinkBack">
			<font style="background-color:FFFFCC; text-decoration:underline">Back to Transfer Item List</font>
		</a>
	</td>
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
	<table cellpadding="2" cellspacing="0" width="100%" border="0">

	<form action="index.cfm?task=serials_transfers_serials_delete" method="Post" name="detailform">
	<input type="hidden" name="TRANFENSEQ" value="#URL.TRANFENSEQ#">
	<input type="hidden" name="LINENO" value="#URL.LINENO#">
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
	
	<cfloop query="qrySerialsTransfers">
		<tr>
			<td valign="top" class="textmain" width="20%">&nbsp;</td>
			<td valign="top" class="textmain">#qrySerialsTransfers.SerialNumber#</td>
		</tr>
	</cfloop>
	</table>
</td>
</tr>
<tr><td>&nbsp;</td></tr>
</table>
</cfoutput>