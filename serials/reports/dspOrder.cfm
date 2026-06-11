<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/11/2006
	Function: 		Sales Order Number Report
	Template:		dspOrder.cfm
	Task:			serials_reports_order_disp
--->
	<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>
	<cfset objOEORDH = createObject("component", "admin.assets.cfcs.OEORDH")>
	<cfset objOEORDD = createObject("component", "admin.assets.cfcs.OEORDD")>
	<cfset objOESHIH = createObject("component", "admin.assets.cfcs.OESHIH")>
	<cfset objOEINVH = createObject("component", "admin.assets.cfcs.OEINVH")>

	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "ORDNUMBER", URL.ORDNUMBER, True)>
	<cfset qrySerialsShipments = objSerialsShipments.searchRecords(SearchRecord, "query", "SerialNumber, PostedDate", 1)>

	<cfset qryOEORDH = objOEORDH.searchRecords(SearchRecord, "query")>

</cfsilent>

<cfoutput>
<table width="900" border="0" align="center" cellpadding="3" cellspacing="1">
<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<td width="50%" valign="top">
		<table cellpadding="1" cellspacing="0" width="100%" border="0">
		<tr>
			<td colspan="2" valign="top" class="textmain" style="font-size:16px"><font color="0033CC">
				<b>Sales Order Number Report</b></font>
			</td>
		</tr>
		<tr>
			<td class="textmain" width="30%"><b>Order Number:</b></td>
			<td class="textmain">#URL.ORDNUMBER#</td>
		</tr>
		</table>
	</td>
	<td valign="top">
		<table cellpadding="1" cellspacing="0" width="100%" border="0">
		<tr>
			<td class="textmain" width="30%"><b>Date of Report:</b></td>
			<td class="textmain">#dateFormat(now(), 'mm/dd/yyyy')# at #timeFormat(now(), 'h:mm tt')#</td>
		</tr>
		<tr>
			<td class="textmain"><b>Order Date:</b></td>
			<td class="textmain">#objOEORDH.formatDate(qryOEORDH.ORDDATE)#</td>
		</tr>
		<tr>
			<td class="textmain"><b>Customer:</b></td>
			<td class="textmain">#qryOEORDH.CUSTOMER#, #qryOEORDH.BILNAME#</td>
		</tr>
		</table>
	</td>
</tr>
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain" colspan="2">
	<table cellpadding="0" cellspacing="0" width="100%" border="0">
	
	<!--- LIST HEADINGS --->
	<tr>
		<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Serial Number</font></td>
		<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Invoice Number</font></td>
		<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Invoice Date</font></td>
		<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Item Number</font></td>
		<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Description</font></td>
		<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Ship To</font></td>
	</tr>

	<!--- LIST DATA --->	
	<cfif qrySerialsShipments.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="2" class="productTitle"><font color="FF0000">The order number entered has no invoices.</font></td>
		</tr>
	</cfif>
	
	<cfloop query="qrySerialsShipments">

<!---
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "SHIUNIQ", qrySerialsShipments.SHIUNIQ, True)>
		<cfset qryOESHIH = objOESHIH.searchRecords(SearchRecord, "query")>
		<cfset structInsert(SearchRecord, "LINENUM", qrySerialsShipments.LINENUM, True)>
		<cfset qryOESHID = objOESHID.searchRecords(SearchRecord, "query")>
--->		

		<!--- Get the invoice --->
		<cfif trim(qrySerialsShipments.INVUNIQ) IS "">
			<cfset InvoiceNumber = "[Unknown]">
			<cfset InvoiceDate = "[Unknown]">
		<cfelse>
			<cfset strSearch = structNew()>
			<cfset structInsert(strSearch, "INVUNIQ", qrySerialsShipments.INVUNIQ, True)>
			<cfset qryOEINVH = objOEINVH.searchRecords(strSearch, "query")>
			<cfif qryOEINVH.RecordCount NEQ 0>
				<cfset InvoiceNumber = qryOEINVH.INVNUMBER>
				<cfset InvoiceDate = objOEINVH.formatDate(qryOEINVH.INVDATE)>
			<cfelse>	<!--- Should never happen --->
				<cfset InvoiceNumber = "[Unknown]">
				<cfset InvoiceDate = "[Unknown]">
			</cfif>
		</cfif>

		<!--- Get the shipment header --->
		<cfif NOT isDefined("qryOEINVH.SHINUMBER") OR trim(qryOEINVH.SHINUMBER) IS "">
			<cfset ShipToAddress = "[Unknown]">
		<cfelse>
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "SHINUMBER", qryOEINVH.SHINUMBER, True)>
			<cfset qryOESHIH = objOESHIH.searchRecords(SearchRecord, "query")>
			<cfif qryOESHIH.RecordCount EQ 0>
				<cfset ShipToAddress = "[Unknown]">
			<cfelse>
				<cfset ShipToAddress = qryOESHIH.SHPNAME & "<br>">
				<cfif trim(qryOESHIH.SHPADDR1) IS NOT "">
					<cfset ShipToAddress = ShipToAddress & qryOESHIH.SHPADDR1 & "<br>">
				</cfif>
				<cfif trim(qryOESHIH.SHPADDR2) IS NOT "">
					<cfset ShipToAddress = ShipToAddress & qryOESHIH.SHPADDR2 & "<br>">
				</cfif>
				<cfif trim(qryOESHIH.SHPADDR3) IS NOT "">
					<cfset ShipToAddress = ShipToAddress & qryOESHIH.SHPADDR3 & "<br>">
				</cfif>
				<cfif trim(qryOESHIH.SHPADDR4) IS NOT "">
					<cfset ShipToAddress = ShipToAddress & qryOESHIH.SHPADDR4 & "<br>">
				</cfif>
				<cfset ShipToAddress = ShipToAddress & qryOESHIH.SHPCITY & qryOESHIH.SHPSTATE & qryOESHIH.SHPZIP>
			</cfif>
		</cfif>

		<!--- Get the order line --->
		<cfif trim(qrySerialsShipments.ORDUNIQ) IS "" AND trim(qrySerialsShipments.ORDLINENUM) IS "">
			<cfset ItemNumber = "[Unknown]">
			<cfset ItemDescription = "[Unknown]">
		<cfelse>
			<cfset strSearch = structNew()>
			<cfset structInsert(strSearch, "ORDUNIQ", qrySerialsShipments.ORDUNIQ, True)>
			<cfset structInsert(strSearch, "LINENUM", qrySerialsShipments.ORDLINENUM, True)>
			<cfset qryOEORDD = objOEORDD.searchRecords(strSearch, "query")>
			<cfif qryOEORDD.RecordCount NEQ 0>
				<cfset ItemNumber = qryOEORDD.ITEM>
				<cfset ItemDescription = qryOEORDD.DESC>
			<cfelse>	<!--- Should never happen --->
				<cfset ItemNumber = "[Unknown]">
				<cfset ItemDescription = "[Unknown]">
			</cfif>
		</cfif>
		
		<tr <cfif qrySerialsShipments.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
			<td class="textsmall" align="left" valign="top">#qrySerialsShipments.SerialNumber#</td>
			<td class="textsmall" align="left" valign="top">#InvoiceNumber#</td>
			<td class="textsmall" align="left" valign="top">#InvoiceDate#</td>
			<td class="textsmall" align="left" valign="top">#ItemNumber#</td>
			<td class="textsmall" align="left" valign="top">#ItemDescription#</td>
			<td class="textsmall" align="left" valign="top">#ShipToAddress#
<!---			
				#qryOESHIH.SHPNAME#<br>
				<cfif trim(qryOESHIH.SHPADDR1) IS NOT "">#qryOESHIH.SHPADDR1#<br></cfif>
				<cfif trim(qryOESHIH.SHPADDR2) IS NOT "">#qryOESHIH.SHPADDR2#<br></cfif>
				<cfif trim(qryOESHIH.SHPADDR3) IS NOT "">#qryOESHIH.SHPADDR3#<br></cfif>
				<cfif trim(qryOESHIH.SHPADDR4) IS NOT "">#qryOESHIH.SHPADDR4#<br></cfif>
				#qryOESHIH.SHPCITY# #qryOESHIH.SHPSTATE# #qryOESHIH.SHPZIP#
--->				
			</td>
		</tr>
	</cfloop>

	</table>
</td>
</tr>


</table>
</cfoutput>