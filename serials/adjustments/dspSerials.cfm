<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/03/2006
	Function: 		This page displays serial numbers in view-only format
	Template:		dspSerials.cfm
	Task:			serials_adjustments_serials_view
--->
	<cfset objICADEH = createObject("component", "admin.assets.cfcs.ICADEH")>
	<cfset objICADED = createObject("component", "admin.assets.cfcs.ICADED")>
	<cfset objSerialsAdjustments = createObject("component", "admin.assets.cfcs.SerialsAdjustments")>

	<!--- Get a structure of the Adjustment header --->
	<cfset strHeader = objICADEH.getRecord(URL.ADJENSEQ)>
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "ADJENSEQ", URL.ADJENSEQ, True)>
	<cfset structInsert(SearchRecord, "LINENO", URL.LINENO, True)>
	<!--- Get a query of the Adjustment detail --->
	<cfset qryDetail = objICADED.searchRecords(SearchRecord, "query")>
	<!--- Get a query of the serial numbers entered --->
	<cfset qrySerialsAdjustments = objSerialsAdjustments.searchRecords(SearchRecord, "query", "SortOrder")>
</cfsilent>

<script language="javascript">
	window.onload = init;
	function init() {
		var ref = document.getElementById("LinkBack");
		ref.focus();
	}
	function confirmPrint() {
		var msg = "You are about to print bar code labels for all serial numbers for this adjustment.  Are you sure you want to continue?";
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
	function confirmApplySerialNumbers() {
		var msg = "Are you sure you want to copy these serial numbers to every other line on this adjustment?";
		if(confirm(msg)) { return true; }
		else { return false; }
	}
</script>

<cfoutput>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objSerialsAdjustments.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<!--- link back --->
<tr>
	<td class="textsmall" align="right">
		<a href="index.cfm?task=serials_adjustments_items_list&ADJENSEQ=#urlEncodedFormat(URL.ADJENSEQ)#" id="LinkBack">
			<font style="background-color:FFFFCC; text-decoration:underline">Back to Adjustment Item List</font>
		</a>
	</td>
</tr>

<!--- COPY SERIAL NUMBERS TO OTHER LINES --->
<tr>
	<td class="textsmall" align="right">
		<a href="index.cfm?task=serials_adjustments_serials_copy&ADJENSEQ=#urlEncodedFormat(URL.ADJENSEQ)#&LINENO=#urlEncodedFormat(URL.LINENO)#&RequestTimeout=6000" onClick="return confirmApplySerialNumbers()">
			Apply Serial Numbers to Other Lines
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

	<cfif qryDetail.TRANSTYPE EQ 1 OR qryDetail.TRANSTYPE EQ 3 OR qryDetail.TRANSTYPE EQ 5><!--- Increase --->
		<form action="index.cfm?task=serials_adjustments_serials_reprint&RequestTimeout=6000" method="Post" name="detailform">
		<input type="hidden" name="ADJENSEQ" value="#URL.ADJENSEQ#">
		<input type="hidden" name="LINENO" value="#URL.LINENO#">
		<tr>
			<td valign="top" class="textmain" colspan="2">
				<b>Bar Code Labels Printed for these items?</b>&nbsp;&nbsp;#yesNoFormat(qrySerialsAdjustments.BarCodesPrinted)#<br>
				<input type="submit" name="ButtonClicked" value="Print Bar Code Labels" onclick="return confirmPrint()">
			</td>
		</tr>
		</form>
	</cfif>

	<form action="index.cfm?task=serials_adjustments_serials_delete" method="Post" name="detailform">
	<input type="hidden" name="ADJENSEQ" value="#URL.ADJENSEQ#">
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
	
	<cfloop query="qrySerialsAdjustments">
		<tr>
			<td valign="top" class="textmain" width="20%">&nbsp;</td>
			<td valign="top" class="textmain">#qrySerialsAdjustments.SerialNumber#</td>
		</tr>
	</cfloop>
	</table>
</td>
</tr>
<tr><td>&nbsp;</td></tr>
</table>
</cfoutput>