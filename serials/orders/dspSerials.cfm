<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/26/2006
	Edit Date: 		10/12/2006
	Function: 		This page displays serial numbers in view-only format
	Template:		dspSerials.cfm
	Task:			serials_shipments_serials_view
--->
	<cfset objOEORDH = createObject("component", "admin.assets.cfcs.OEORDH")>
	<cfset objOEORDD = createObject("component", "admin.assets.cfcs.OEORDD")>
	<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>
	<cfset objBackOrder = createObject("component", "admin.assets.cfcs.BackOrder")>

	<!--- Get a structure of the Order header --->
	<cfset strHeader = objOEORDH.getRecord(URL.ORDUNIQ)>
	
	<!--- Get a query of the Order detail --->
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "ORDUNIQ", URL.ORDUNIQ, True)>
	<cfset structInsert(SearchRecord, "LINENUM", URL.LINENUM, True)>
	<cfset qryDetail = objOEORDD.searchRecords(SearchRecord, "query")>
	
	<!--- Get a query of the serial numbers entered --->
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "ORDUNIQ", URL.ORDUNIQ, True)>
	<cfset structInsert(SearchRecord, "ORDLINENUM", URL.LINENUM, True)>
<!---<cfset structInsert(SearchRecord, "AttachedToInvoice", 1, True)>--->
	<cfset structInsert(SearchRecord, "Posted", 1, True)>
	<cfset qrySerialsShipments = objSerialsShipments.searchRecords(SearchRecord, "query")>
	
	<!--- Determine the amount remaining to ship --->
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "ORDUNIQ", URL.ORDUNIQ, True)>
	<cfset structInsert(SearchRecord, "ORDLINENUM", URL.LINENUM, True)>
	<cfset structInsert(SearchRecord, "Posted", 1, True)>
<!---<cfset structInsert(SearchRecord, "AttachedToInvoice", 1, True)>--->
	<cfset qrySerialsShipmentsAttached = objSerialsShipments.searchRecords(SearchRecord, "query")>
<!---<cfset RemainingQuantity = int(qryDetail.ORIGQTY - qrySerialsShipmentsAttached.RecordCount)>--->
	<cfif NOT isNumeric(qryDetail.QTYORDERED)><cfset qryDetail.QTYORDERED = 0></cfif>
	<cfif NOT isNumeric(qryDetail.QTYSHPTODT)><cfset qryDetail.QTYSHPTODT = 0></cfif>
	<cfset RemainingQuantity = int((qryDetail.QTYORDERED + qryDetail.QTYSHPTODT) - qrySerialsShipmentsAttached.RecordCount)>

</cfsilent>


<script language="javascript">
	window.onload = init;
	function init() {
		var ref = document.getElementById("LinkBack");
		ref.focus();
	}
	function confirmDelete() {
		var msg = "This function will DELETE all serial numbers posted for this item, and reverse all entries that were made in the master list of serial numbers and serial number audit trail.  It will essentially allow you to start over with this item.  Are you sure you want to continue?";
		if(confirm(msg)) { 
			document.detailform.ButtonClicked.disabled = true;
			document.getElementById("Posting").style.visibility = "visible";		
		    window.document.detailform.submit();
		}
		else { return false; }
	}
	function confirmReportBackorders() {
		var msg = "Are you done scanning all serial numbers for this order?  If you proceed, all remaining items that you did not scan will be marked as backordered.";
		if(confirm(msg)) { return true; }
		else { return false; }
	}	
</script>

<cfoutput>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objSerialsShipments.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<!--- link back --->
<tr>
	<td class="textsmall" align="right">
		<a href="index.cfm?task=serials_orders_items_list&ORDUNIQ=#urlEncodedFormat(URL.ORDUNIQ)#" id="LinkBack">
			<font style="background-color:FFFFCC; text-decoration:underline">Back to Order Item List</font>
		</a>
	</td>
</tr>

<!--- "REPORT BACKORDERS" link --->
<!--- Have this link appear only if the order is a comp build, at least one serial number has been scanned and posted,
 	  the order is not complete, and it has not been invoiced. --->
<cfset SearchRecord = structNew()>
<cfset structInsert(SearchRecord, "ORDUNIQ", URL.ORDUNIQ, True)>
<cfset structInsert(SearchRecord, "Posted", 1, True)>
<cfset qrySerialsShipmentsLink = objSerialsShipments.searchRecords(SearchRecord, "query")>
<cfif objBackOrder.isCompBuild(URL.ORDUNIQ) AND 
	  qrySerialsShipmentsLink.RecordCount GT 0 AND
	  objBackOrder.orderIsNotComplete(URL.ORDUNIQ) AND 
	  objBackOrder.orderIsNotAttached(URL.ORDUNIQ)>
	<tr>
		<td class="textmain" align="right">
			<a href="index.cfm?task=serials_shipments_report_backorders&ORDUNIQ=#urlEncodedFormat(URL.ORDUNIQ)#&RequestTimeout=6000" onClick="return confirmReportBackorders()">
				REPORT BACKORDERS
			</a>
		</td>
	</tr>
</cfif>

<td valign="top" class="textmain">
	<!--- ORDER INFORMATION --->
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

		<form action="index.cfm?task=serials_shipments_correct_edit" method="Post" name="detailform">
		<input type="hidden" name="ORDUNIQ" value="#URL.ORDUNIQ#">
		<input type="hidden" name="LINENUM" value="#URL.LINENUM#">
			<tr>
				<td valign="top" class="textmain" colspan="3">
					To search for a serial number in the list below, enter the serial number<br>
					(or part of it) in the box below and click "Search".
				</td>
			</tr>
			<tr>
				<!--- SERIAL NUMBER SEARCH --->
				<td colspan="3">
					<input name="SerialNumberToSearch" 
						<cfif isDefined("URL.SerialNumberToSearch")>
							value="#URL.SerialNumberToSearch#"
						</cfif>
					size="40" maxlength="50">
					<input type="submit" name="SearchButton" value="Search">
				</td>
			</tr>
			<cfif isDefined("URL.SearchError")>
				<tr>
					<td class="textmain" align="left" colspan="3">
						<font color="FF0000">
							<cfif trim(URL.SearchError) IS "SNBlank">
								Please enter a Serial Number before clicking "Search".
							<cfelseif URL.SearchError IS "SNNotFound">
								The Serial Number you entered was not found in the list below.
							<cfelseif URL.SearchError IS "SNMultipleFound">
								More than one match was found in the list below for the serial number you entered.
							</cfif>
						</font>
					</td>
				</tr>
			</cfif>
		</form>
	

		<form action="index.cfm?task=serials_shipments_serials_delete&RequestTimeout=6000" method="Post" name="detailform">
		<input type="hidden" name="ORDUNIQ" value="#URL.ORDUNIQ#">
		<input type="hidden" name="LINENUM" value="#URL.LINENUM#">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<!--- "DELETE ALL" BUTTON --->
				<td colspan="3">
					<input type="submit" name="ButtonClicked" value="Delete All" onclick="return confirmDelete()">
				</td>
			</tr>
			<tr id="Posting" style="visibility:hidden;">
				<td valign="top" colspan="3" align="center" class="textmain">
					<font color="FF0000">Deleting Serial Numbers - Please Wait</font>
				</td>
			</tr>
		</form>
	
		<tr>
			<td valign="top" class="textmain" colspan="3"><b>Serial Numbers:</b></td>
		</tr>
	
		<cfif qrySerialsShipments.RecordCount EQ 0>
			<tr>
				<td valign="top" class="textmain" width="20%">&nbsp;</td>
				<td valign="top" class="textmain" colspan="2"><font color="FF0000">None Entered</font></td>
			</tr>
		</cfif>
		
		<cfloop query="qrySerialsShipments">
			<tr>
				<td valign="top" class="textmain" width="20%">&nbsp;</td>
				<td valign="top" class="textmain">
					<a href="index.cfm?task=serials_shipments_correct_edit&SerialsShipmentsID=#urlEncodedFormat(qrySerialsShipments.SerialsShipmentsID)#">
						#qrySerialsShipments.SerialNumber#
					</a>
				</td>
				
				<!--- Link to Serial Number History Report --->
				<td valign="top" class="textmain">
					<a href="serials/reports/index.cfm?task=serials_reports_history_disp&SerialNumber=#urlEncodedFormat(qrySerialsShipments.SerialNumber)#&ITEMNO=#urlEncodedFormat(qryDetail.ITEM)#&BeginDate=NONE&EndDate=NONE&TransactionType=&Consolidate=0" target="_blank">[history]</a>

					<!--- Show this link only for Ron Barth and Rob Bauer --->
					<cfif objSerialsShipments.getSessionValue("adminuserid") IS "7EBCFD4D-423B-5784-96BD9CB11DAE423D" OR
						  objSerialsShipments.getSessionValue("adminuserid") IS "9D5287EE-423B-5784-90506247A8FB252C">
					    &nbsp;&nbsp;
						<a href="index.cfm?task=serials_shipments_correct_act&SerialsShipmentsID=#urlEncodedFormat(qrySerialsShipments.SerialsShipmentsID)#&ORDUNIQ=#urlEncodedFormat(URL.ORDUNIQ)#&ORDLINENUM=#urlEncodedFormat(URL.LINENUM)#&ManualDeletion=yes" onclick="return confirm('*** WARNING ***  You are about to delete this Serial Number.  Are you sure you want to continue?')"><font color="FF0000">[DELETE]</font></a>
					</cfif>
					
				</td>				
			</tr>
		</cfloop>
		</table>
	</td>
	</tr>
<cfelse>
	<tr>
		<td valign="top" class="textmain">
			All serial numbers have been sucessfully posted for all items of this Order.<br>
			Click the above <a href="index.cfm?task=serials_orders_items_list&ORDUNIQ=#urlEncodedFormat(URL.ORDUNIQ)#">link</a> to review individual items and their serial numbers.
		</td>
	</tr>
</cfif>
	
</table>
</cfoutput>