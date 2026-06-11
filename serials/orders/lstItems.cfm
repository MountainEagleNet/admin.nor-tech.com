<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/26/2006
	Function: 		This page displays a list of items for a chosen shipment
	Template:		lstItems.cfm
	Task:			serials_shipments_items_list
--->
	<cfset objOEORDH = createObject("component", "admin.assets.cfcs.OEORDH")>
	<cfset objOESHIH = createObject("component", "admin.assets.cfcs.OESHIH")>
	<cfset objOESHID = createObject("component", "admin.assets.cfcs.OESHID")>
	<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>

	<!--- Get a structure of the Shipment header --->
	<cfset strHeader = objOESHIH.getRecord(URL.SHIUNIQ)>
	
	<!--- Get a query of the Shipment lines --->	
<!---<cfset qryDetail = objOESHID.listRecordsForParent("SHIUNIQ", URL.SHIUNIQ)>--->
	<cfset qryDetail = objOESHID.getSerializedLines(URL.SHIUNIQ)>

	<!--- Get a query of the Order --->
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "ORDNUMBER", strHeader.ORDNUMBER, True)>
	<cfset qryOrder = objOEORDH.searchRecords(SearchRecord, "query")>

	<!--- Get a query of shipments for this order --->
	<cfset qryShipments = objOESHIH.listRecordsForParent("ORDNUMBER", qryOrder.ORDNUMBER)>

</cfsilent>

<!---
<cfdump var="#strHeader#">
<cfdump var="#qryDetail#">
<cfdump var="#qryOrder#">
--->

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">Invoice Item List</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objSerialsShipments.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<!--- link back --->
<tr>
	<td class="textsmall" align="right">
		<cfif qryShipments.RecordCount GT 1>
			<a href="index.cfm?task=serials_shipments_list&ORDUNIQ=#urlEncodedFormat(qryOrder.ORDUNIQ)#&ORDNUMBER=#urlEncodedFormat(qryOrder.ORDNUMBER)#">
				Back to Invoices List
			</a>
		<cfelse>
			<a href="index.cfm?task=serials_orders_enter">
				Back to Order Number Entry Page
			</a>
		</cfif>
	</td>
</tr>



<tr>
<td valign="top" class="textmain">

	<!--- ORDER INFORMATION --->
	<cfinclude template="orderInfo.cfm">
	<!--- SHIPMENT HEADER INFORMATION --->
	<cfinclude template="headerInfo.cfm">
	<tr><td>&nbsp;</td></tr>

	<table cellpadding="0" cellspacing="0" width="100%" border="0">
	
	<!--- LIST HEADINGS --->
	<tr>
		<td height="18" bgcolor="006633" class="productTitle" width="22%" ><font color="FFFFFF">Item</font></td>
		<td height="18" bgcolor="006633" class="productTitle" width="50%" ><font color="FFFFFF">Description</font></td>
		<td height="18" bgcolor="006633" class="productTitle" width="7%" align="center"><font color="FFFFFF">Qty</font></td>
		<td height="18" bgcolor="006633" class="productTitle">&nbsp;</td>
	</tr>

	<!--- LIST DATA --->	
	<cfif qryDetail.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="4" class="productTitle"><font color="FF0000">This Invoice has no serialized items.</font></td>
		</tr>
	</cfif>
	
	<cfloop query="qryDetail">
		<cfset PostedFlag = objSerialsShipments.getPostedFlag(qryDetail.SHIUNIQ, qryDetail.LINENUM)>
	
		<tr<cfif qryDetail.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>

			<td class="textsmall" align="left">
				<cfif PostedFlag IS NOT "Serial Numbers Posted" AND qryDetail.QTYSHIPPED GT 0>
					<a href="index.cfm?task=serials_shipments_serials_edit&SHIUNIQ=#urlEncodedFormat(qryDetail.SHIUNIQ)#&LINENUM=#urlEncodedFormat(qryDetail.LINENUM)#">
						#qryDetail.ITEM#
					</a>
				<cfelse>
					<a href="index.cfm?task=serials_shipments_serials_view&SHIUNIQ=#urlEncodedFormat(qryDetail.SHIUNIQ)#&LINENUM=#urlEncodedFormat(qryDetail.LINENUM)#">
						#qryDetail.ITEM#
					</a>
				</cfif>
			</td>
			<td class="textsmall" align="left">#qryDetail.DESC#</td>
			<td class="textsmall" align="center">#int(qryDetail.QTYSHIPPED)#</td>
			<td class="textsmall" align="left">#PostedFlag#</td>
		</tr>
	</cfloop>
	</table>
</td>
</tr>

</table>
</cfoutput>