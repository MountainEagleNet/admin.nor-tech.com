<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	10/11/2006
	Function: 		This page displays a list of items for a chosen order
	Template:		lstOrderItems.cfm
	Task:			serials_orders_items_list
--->
	<cfset objOEORDH = createObject("component", "admin.assets.cfcs.OEORDH")>
	<cfset objOEORDD = createObject("component", "admin.assets.cfcs.OEORDD")>
	<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>
	<cfset objBackOrder = createObject("component", "admin.assets.cfcs.BackOrder")>

	<!--- Get a structure of the Order header --->
	<cfset strHeader = objOEORDH.getRecord(URL.ORDUNIQ)>

	<!--- Get a query of the Order lines --->	
	<cfset qryDetail = objOEORDD.getSerializedLines(URL.ORDUNIQ)>

</cfsilent>

<script language="javascript">
	function confirmReportBackorders() {
		var msg = "Are you done scanning all serial numbers for this order?  If you proceed, all remaining items that you did not scan will be marked as backordered.";
		if(confirm(msg)) { return true; }
		else { return false; }
	}
</script>

<!---
<!--- If not all items for this order have been posted, find the first non-posted one and go directly to frmSerials --->
<cfset FirstUnpostedLINENUM= objSerialsShipments.getFirstUnpostedItem(URL.ORDUNIQ)>
<cfif FirstUnpostedLINENUM IS NOT "">
	<cflocation url="index.cfm?task=serials_shipments_serials_edit&ORDUNIQ=#urlEncodedFormat(URL.ORDUNIQ)#&LINENUM=#urlEncodedFormat(FirstUnpostedLINENUM)#">
</cfif>
--->

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">Order Item List</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objSerialsShipments.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<!--- link back --->
<tr>
	<td class="textsmall" align="right">
		<a href="index.cfm?task=serials_orders_enter">
			Back to Order Number Entry Page
		</a>
	</td>
</tr>

<!--- "START SCAN" link --->
<!--- If not all items for this order have been posted, find the first non-posted one and go directly to frmSerials --->
<cfset FirstUnpostedLINENUM= objSerialsShipments.getFirstUnpostedItem(URL.ORDUNIQ)>
<cfif FirstUnpostedLINENUM IS NOT "">
	<tr>
		<td class="textmain" align="right">
			<a href="index.cfm?task=serials_shipments_serials_edit&ORDUNIQ=#urlEncodedFormat(URL.ORDUNIQ)#&LINENUM=#urlEncodedFormat(FirstUnpostedLINENUM)#">
				START SCAN
			</a>
		</td>
	</tr>
</cfif>

<cfset AdminUserID = objSerialsShipments.getSessionValue("adminuserid")>

<!--- "REPORT BACKORDERS" link --->
<!--- Have this link appear only if the order is a comp build, at least one serial number has been scanned and posted 
	  (or it's Me, Larry Hanson, or Rob Bauer logged in), the order is not complete, and it has not been invoiced. --->
<cfset SearchRecord = structNew()>
<cfset structInsert(SearchRecord, "ORDUNIQ", URL.ORDUNIQ, True)>
<cfset structInsert(SearchRecord, "Posted", 1, True)>
<cfset qrySerialsShipments = objSerialsShipments.searchRecords(SearchRecord, "query")>
<cfset ShowTheLink = 0>
<cfif objBackOrder.isCompBuild(URL.ORDUNIQ) AND 
	  objBackOrder.orderIsNotComplete(URL.ORDUNIQ) AND 
	  objBackOrder.orderIsNotAttached(URL.ORDUNIQ)>
	<cfif qrySerialsShipments.RecordCount GT 0 OR
		   AdminUserID IS "7EBCFD4D-423B-5784-96BD9CB11DAE423D" OR 
		   AdminUserID IS "A1BC260D-423B-5784-9507BCDD828728D0" OR 
		   AdminUserID IS "9D4FDAB0-423B-5784-992C3FE93956C7FC" OR 
		   AdminUserID IS "9D5287EE-423B-5784-90506247A8FB252C">
		<cfset ShowTheLink = 1>
	</cfif>
</cfif>
<cfif ShowTheLink EQ 1>
	<tr>
		<td class="textmain" align="right">
			<a href="index.cfm?task=serials_shipments_report_backorders&ORDUNIQ=#urlEncodedFormat(URL.ORDUNIQ)#&RequestTimeout=6000" onClick="return confirmReportBackorders()">
				REPORT BACKORDERS
			</a>
		</td>
	</tr>
</cfif>

<!--- "APPLY ITEMS FROM RECEIPT" link --->
<cfif FirstUnpostedLINENUM IS NOT "">
	<tr>
		<td class="textsmall" align="right">
			<a href="index.cfm?task=serials_shipments_apply_edit&ORDUNIQ=#urlEncodedFormat(URL.ORDUNIQ)#&RequestTimeout=6000">
				Apply Items from Receipt
			</a>
		</td>
	</tr>
</cfif>

<!--- "COPY SERIAL NUMBERS FROM ANOTHER ORDER" link (only for me, Larry Hanson, or Rob Bauer)  --->
<cfif FirstUnpostedLINENUM IS NOT "" AND
	  (AdminUserID IS "7EBCFD4D-423B-5784-96BD9CB11DAE423D" OR 
	   AdminUserID IS "A1BC260D-423B-5784-9507BCDD828728D0" OR 
	   AdminUserID IS "9D4FDAB0-423B-5784-992C3FE93956C7FC" OR 
	   AdminUserID IS "9D5287EE-423B-5784-90506247A8FB252C")>
	<tr>
		<td class="textsmall" align="right">
			<a href="index.cfm?task=serials_shipments_orderapply_edit&ORDUNIQ=#urlEncodedFormat(URL.ORDUNIQ)#&RequestTimeout=6000">
				Copy Serial Numbers from Another Order
			</a>
		</td>
	</tr>
</cfif>

<tr>
<td valign="top" class="textmain">
	<!--- ORDER HEADER INFORMATION --->
	<cfinclude template="headerInfo.cfm">

	<table cellpadding="0" cellspacing="0" width="100%" border="0">
	<tr><td>&nbsp;</td></tr>
	
	<!--- LIST HEADINGS --->
	<tr>
		<td height="18" bgcolor="006633" class="productTitle" width="22%"><font color="FFFFFF">Item</font></td>
		<td height="18" bgcolor="006633" class="productTitle" width="8%"><font color="FFFFFF">&nbsp;</font></td>
		<td height="18" bgcolor="006633" class="productTitle" width="43%"><font color="FFFFFF">Description</font></td>
		<td height="18" bgcolor="006633" class="productTitle" width="7%" align="center"><font color="FFFFFF">Qty</font></td>
		<td height="18" bgcolor="006633" class="productTitle">&nbsp;</td>
	</tr>

	<!--- LIST DATA --->	
	<cfif qryDetail.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="5" class="productTitle"><font color="FF0000">This Order has no serialized items.</font></td>
		</tr>
	</cfif>
	
	<cfloop query="qryDetail">
		<cfset OrderQuantity = qryDetail.QTYORDERED + qryDetail.QTYSHPTODT>
		<cfset PostedFlag = objSerialsShipments.getPostedFlagAlternate(qryDetail.ORDUNIQ, qryDetail.LINENUM, OrderQuantity)>
	
		<tr<cfif qryDetail.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>

			<td class="textsmall" align="left" valign="top">
				<cfif PostedFlag IS NOT "Serial Numbers Posted">
					<a href="index.cfm?task=serials_shipments_serials_edit&ORDUNIQ=#urlEncodedFormat(qryDetail.ORDUNIQ)#&LINENUM=#urlEncodedFormat(qryDetail.LINENUM)#&RequestTimeout=6000">
						#qryDetail.ITEM#
					</a>
				<cfelse>
					<a href="index.cfm?task=serials_shipments_serials_view&ORDUNIQ=#urlEncodedFormat(qryDetail.ORDUNIQ)#&LINENUM=#urlEncodedFormat(qryDetail.LINENUM)#&RequestTimeout=6000">
						#qryDetail.ITEM#
					</a>
				</cfif>
			</td>

			<!--- Link to Part Number History Report --->
			<td class="textsmall" align="center" valign="top">
				<a href="serials/reports/index.cfm?task=serials_reports_part_disp&ITEMNO=#urlEncodedFormat(qryDetail.ITEM)#&BeginDate=NONE&EndDate=NONE&TransactionType=&Consolidate=0" target="_blank">
					[history]
				</a>
			</td>
			
			<td class="textsmall" align="left" valign="top">#qryDetail.DESC#</td>
<!---		<td class="textsmall" align="center">#int(qryDetail.ORIGQTY)#</td>	--->
			<td class="textsmall" align="center" valign="top">#int(OrderQuantity)#</td>
			<td class="textsmall" align="left" valign="top">
				<cfif PostedFlag IS NOT "No Serial Numbers"<!---AND PostedFlag IS NOT "Serial Numbers Posted"--->>
					<a href="index.cfm?task=serials_shipments_serials_view&ORDUNIQ=#urlEncodedFormat(qryDetail.ORDUNIQ)#&LINENUM=#urlEncodedFormat(qryDetail.LINENUM)#">
						#PostedFlag#
					</a>
				<cfelse>
					#PostedFlag#
				</cfif>
			</td>
		</tr>
	</cfloop>
	</table>
</td>
</tr>

</table>
</cfoutput>