<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	10/30/2006
	Function: 		This page displays the form for correcting a serial number
	Template:		frmCorrectSerial.cfm
	Task:			serials_shipments_correct_edit
--->
	<cfset objOEORDH = createObject("component", "admin.assets.cfcs.OEORDH")>
	<cfset objOEORDD = createObject("component", "admin.assets.cfcs.OEORDD")>
	<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>

	<!--- Search for a Serial Number --->
	<cfif isDefined("FORM.SerialNumberToSearch")>
		<cfif trim(FORM.SerialNumberToSearch) IS "">
			<cflocation url="index.cfm?task=serials_shipments_serials_view&ORDUNIQ=#urlEncodedFormat(FORM.ORDUNIQ)#&LINENUM=#urlEncodedFormat(FORM.LINENUM)#&SearchError=SNBlank">
		<cfelse>
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "ORDUNIQ", FORM.ORDUNIQ, True)>
			<cfset structInsert(SearchRecord, "ORDLINENUM", FORM.LINENUM, True)>
			<cfset structInsert(SearchRecord, "SerialNumber", FORM.SerialNumberToSearch, True)>
			<cfset qrySerialsShipments = objSerialsShipments.searchRecords(SearchRecord, "query", "SerialNumber", 0)>
			<cfif qrySerialsShipments.RecordCount EQ 0>
				<cflocation url="index.cfm?task=serials_shipments_serials_view&ORDUNIQ=#urlEncodedFormat(FORM.ORDUNIQ)#&LINENUM=#urlEncodedFormat(FORM.LINENUM)#&SearchError=SNNotFound&SerialNumberToSearch=#urlEncodedFormat(FORM.SerialNumberToSearch)#">
			<cfelseif qrySerialsShipments.RecordCount GT 1>
				<cflocation url="index.cfm?task=serials_shipments_serials_view&ORDUNIQ=#urlEncodedFormat(FORM.ORDUNIQ)#&LINENUM=#urlEncodedFormat(FORM.LINENUM)#&SearchError=SNMultipleFound&SerialNumberToSearch=#urlEncodedFormat(FORM.SerialNumberToSearch)#">
			<cfelse>
				<cfset stRecord = objSerialsShipments.getRecord(qrySerialsShipments.SerialsShipmentsID)>
			</cfif>
		</cfif>

	<cfelse>
	
		<cfset stRecord = objSerialsShipments.getRecord(URL.SerialsShipmentsID)>
		
	</cfif>

	<!--- Get a structure of the Order header --->
	<cfset strHeader = objOEORDH.getRecord(stRecord.ORDUNIQ)>
	
	<!--- Get a query of the Order detail --->
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "ORDUNIQ", stRecord.ORDUNIQ, True)>
	<cfset structInsert(SearchRecord, "LINENUM", stRecord.ORDLINENUM, True)>
	<cfset qryDetail = objOEORDD.searchRecords(SearchRecord, "query")>

	<!--- Determine the amount remaining to ship --->
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "ORDUNIQ", stRecord.ORDUNIQ, True)>
	<cfset structInsert(SearchRecord, "ORDLINENUM", stRecord.ORDLINENUM, True)>
	<cfset structInsert(SearchRecord, "Posted", 1, True)>
	<cfset qrySerialsShipmentsAttached = objSerialsShipments.searchRecords(SearchRecord, "query")>
	
	<cfif NOT isNumeric(qryDetail.QTYORDERED)><cfset qryDetail.QTYORDERED = 0></cfif>
	<cfif NOT isNumeric(qryDetail.QTYSHPTODT)><cfset qryDetail.QTYSHPTODT = 0></cfif>
	<cfset RemainingQuantity = int((qryDetail.QTYORDERED + qryDetail.QTYSHPTODT) - qrySerialsShipmentsAttached.RecordCount)>

</cfsilent>

<script language="JavaScript" type="text/JavaScript">
<!--
	function disableButton() {
	  document.detailform.ButtonClicked[1].disabled = true;
	  document.getElementById("Posting").style.visibility = "visible";					
	  window.document.detailform.submit();
	}
	function confirmDelete() {
		var msg = "This function will DELETE this serial number, and reverse the entry that was made in the master list of serial numbers and serial number audit trail.  Are you sure you want to continue?";
		if(confirm(msg)) { 
//			document.detailform.Delete.disabled = true;
			document.getElementById("Deleting").style.visibility = "visible";		
		    window.document.detailform.submit();
		}
		else { return false; }
	}

//-->
</script>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<td valign="top" class="textmain" style="font-size:16px"><font color="FF0000"><b>Correct/Delete Serial Number</b></font></td>
</tr>

<tr>
<td valign="top" class="textmain">
	<!--- ORDER INFORMATION --->
	<cfinclude template="headerInfo.cfm">
	<!--- DETAIL INFORMATION --->
	<cfinclude template="detailInfo.cfm">
</td>
</tr>
<tr><td>&nbsp;</td></tr>

<tr>
	<td valign="top" class="textmain">
		This form allows you to fix a serial number that was entered incorrectly.<br><br>
		You may delete this serial number by clicking "Delete", change the serial number by entering a new one and clicking "Continue", or make no changes (cancel the operation) by clicking "Back".<br><br>&nbsp;
	</td>
</tr>


<tr>
<td valign="top" class="textmain">
	<form action="index.cfm?task=serials_shipments_correct_act" method="Post" name="detailform">
	<input type="hidden" name="SerialsShipmentsID" value="#stRecord.SerialsShipmentsID#">
	<input type="hidden" name="ORDUNIQ" value="#stRecord.ORDUNIQ#">
	<input type="hidden" name="ORDLINENUM" value="#stRecord.ORDLINENUM#">
	<input type="hidden" name="OldSerialNumber" value="#stRecord.SerialNumber#">

	<cfset TabValue = 1>
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	<tr>
		<td width="30%" class="textmain" align="left"><strong>Old Serial Number:</strong></td>
		<td class="textmain" align="left">#stRecord.SerialNumber#</td>
	</tr>
	<tr>
		<td class="textmain" align="left"><strong>New Serial Number:</strong></td>
		<td class="textmain" align="left">
			<input name="NewSerialNumber" size="40" maxlength="50" tabindex="#TabValue#">
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
		<!--- "DELETE" BUTTON --->
		<td align="right">
			<input type="submit" name="DeleteButton" value="Delete" onclick="return confirmDelete()">
		</td>
		<!--- "CONTINUE" BUTTON --->
		<td align="right">
			<input type="submit" name="ButtonClicked" value="&nbsp;Continue -&raquo;" tabindex="#TabValue#"  onclick="return disableButton()">
		</td>
	</tr>
	<tr id="Posting" style="visibility:hidden;">
		<td valign="top" colspan="3" align="center" class="textmain">
			<font color="FF0000">Correcting Serial Number - Please Wait</font>
		</td>
	</tr>
	<tr id="Deleting" style="visibility:hidden;">
		<td valign="top" colspan="3" align="center" class="textmain">
			<font color="FF0000">Deleting Serial Number - Please Wait</font>
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
document.detailform['NewSerialNumber'].focus();document.detailform['NewSerialNumber'].select()
-->
</script>