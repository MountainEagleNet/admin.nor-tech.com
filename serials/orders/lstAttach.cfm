<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	10/11/2006
	Function: 		This page displays a list of items for a chosen order
	Template:		lstAttach.cfm
	Task:			serials_attach_list
--->
	<cfset objOEORDH = createObject("component", "admin.assets.cfcs.OEORDH")>
	<cfset objOEORDD = createObject("component", "admin.assets.cfcs.OEORDD")>
	<cfset objOEINVH = createObject("component", "admin.assets.cfcs.OEINVH")>
	<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>

	<!--- Get a structure of the Order header --->
	<cfset strHeader = objOEORDH.getRecord(URL.ORDUNIQ)>

	<!--- Get a query of the Order lines --->	
	<cfset qryDetail = objOEORDD.getSerializedLines(URL.ORDUNIQ)>

</cfsilent>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">Order List to Attach</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objSerialsShipments.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<!--- link back --->
<tr>
	<td class="textsmall" align="right">
		<a href="index.cfm?task=serials_attach_order_enter">
			Back to Order Number Entry Page
		</a>
	</td>
</tr>

<!--- Reprint Serial Number List --->

<!--- Query of all Invoices for this Order --->
<cfset SearchRecord = structNew()>
<cfset structInsert(SearchRecord, "ORDNUMBER", strHeader.ORDNUMBER, True)>
<cfset qryInvoices = objOEINVH.searchRecords(SearchRecord, "query")>

<!---
<cfset SearchRecord = structNew()>
<cfset structInsert(SearchRecord, "ORDUNIQ", strHeader.ORDUNIQ, True)>
<cfset qrySerialsShipmentsALL = objSerialsShipments.searchRecords(SearchRecord, "query", "INVUNIQ")>
<cfset TheyAreAllAttached = 1>
<cfloop query="qrySerialsShipmentsALL">
	<cfif qrySerialsShipmentsALL.AttachedToInvoice EQ 0>
		<cfset TheyAreAllAttached = 0>
		<cfbreak>
	</cfif>
</cfloop>
<cfif qrySerialsShipmentsALL.RecordCount GE 1 AND TheyAreAllAttached>
	<cfset qryInvoices = queryNew("INVUNIQ,INVNUMBER")>
	<cfset INVUNIQSaved = "">
	<cfloop query="qrySerialsShipmentsALL">
		<cfif qrySerialsShipmentsALL.INVUNIQ IS NOT INVUNIQSaved>
			<cfset INVUNIQSaved = qrySerialsShipmentsALL.INVUNIQ>
			<cfset queryAddRow(qryInvoices)>
			<cfset querySetCell(qryInvoices, "INVUNIQ", qrySerialsShipmentsALL.INVUNIQ)>
			<cfset strOEINVH = objOEINVH.getRecord(qrySerialsShipmentsALL.INVUNIQ)>
			<cfset querySetCell(qryInvoices, "INVNUMBER", strOEINVH.INVNUMBER)>
		</cfif>
	</cfloop>
--->
	
<cfloop query="qryInvoices">
	<!--- If this invoice already has serial numbers attached, show the reprint link --->
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "ORDUNIQ", URL.ORDUNIQ, True)>
	<cfset structInsert(SearchRecord, "INVUNIQ", qryInvoices.INVUNIQ, True)>
	<cfset structInsert(SearchRecord, "AttachedToInvoice", 1, True)>
	<cfset qrySerialsShipmentsAttached = objSerialsShipments.searchRecords(SearchRecord, "query")>
	<cfif qrySerialsShipmentsAttached.RecordCount GT 0>
		<tr>
			<td class="textsmall" align="right">
<!---			<a href="serials/orders/index.cfm?task=serials_attach_print&ORDUNIQ=#urlEncodedFormat(strHeader.ORDUNIQ)#&INVUNIQ=#urlEncodedFormat(qryInvoices.INVUNIQ)#" target="_blank">	--->
				<a href="serials/orders/index.cfm?task=serials_attach_reprint&ORDUNIQ=#urlEncodedFormat(strHeader.ORDUNIQ)#&INVUNIQ=#urlEncodedFormat(qryInvoices.INVUNIQ)#" target="_blank">
					Reprint Serial Number List for Invoice Number '#qryInvoices.INVNUMBER#' 
				</a>
			</td>
		</tr>
	</cfif>
</cfloop>

<!---
</cfif>
--->

<tr>
<td valign="top" class="textmain">
	<!--- ORDER HEADER INFORMATION --->
	<cfinclude template="headerInfo.cfm">
	<tr><td>&nbsp;</td></tr>

	<table cellpadding="0" cellspacing="0" width="100%" border="0">
	
	<!--- LIST HEADINGS --->
	<tr>
		<td height="18" bgcolor="006633" class="productTitle" width="22%" ><font color="FFFFFF">Item</font></td>
		<td height="18" bgcolor="006633" class="productTitle" width="45%" ><font color="FFFFFF">Description</font></td>
		<td height="18" bgcolor="006633" class="productTitle" width="10%" align="center"><font color="FFFFFF">#chr(35)# Serial Numbers</font></td>
		<td height="18" bgcolor="006633" class="productTitle" align="center"><font color="FFFFFF">Serial Number<br>List</font></td>
	</tr>

	<!--- LIST DATA --->	
	<cfif qryDetail.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="4" class="productTitle"><font color="FF0000">This Order has no serialized items.</font></td>
		</tr>
	</cfif>
	
	<cfset FoundAtLeastOne = 0>
	<cfloop query="qryDetail">
	
		<!--- Get a query of the serial numbers entered --->
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ORDUNIQ", qryDetail.ORDUNIQ, True)>
		<cfset structInsert(SearchRecord, "ORDLINENUM", qryDetail.LINENUM, True)>
		<cfset structInsert(SearchRecord, "AttachedToInvoice", 0, True)>
		<cfset qrySerialsShipments = objSerialsShipments.searchRecords(SearchRecord, "query")>
		<cfif qrySerialsShipments.RecordCount GT 0>
			<cfset FoundAtLeastOne = 1>
			<tr<cfif qryDetail.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
				<td class="textsmall" align="left" valign="top">#qryDetail.ITEM#</td>
				<td class="textsmall" align="left" valign="top">#qryDetail.DESC#</td>
				<td class="textsmall" align="center" valign="top">#qrySerialsShipments.RecordCount#</td>
				<td class="textsmall" align="center" valign="top">
					<cfloop query="qrySerialsShipments">
						#qrySerialsShipments.SerialNumber#<br>
					</cfloop>
				</td>
			</tr>
		</cfif>
	</cfloop>
	<cfif NOT FoundAtLeastOne>
		<tr>
			<td class="textmain" align="center" valign="top" colspan="4">
				<font color="FF0000">There are no serial numbers waiting to be attached on any of the lines of this order</font>
			</td>
		</tr>
	</cfif>

	<form action="index.cfm?task=serials_attach_act&RequestTimeout=6000" method="Post" name="detailform">
	<input type="hidden" name="ORDUNIQ" value="#URL.ORDUNIQ#">
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td valign="top" align="center" colspan="4">
			<table cellpadding="4" cellspacing="0" border="0" width="80%">
				<tr>
					<td width="50%" align="center"><!--- "QUIT" BUTTON --->
						<input type="submit" name="ButtonClicked" value="Quit">
					</td>
					<td align="center"><!--- "ATTACH INVOICE" BUTTON --->
						<cfif FoundAtLeastOne>
							<input type="submit" name="ButtonClicked" value="Attach Invoice">
						</cfif>
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