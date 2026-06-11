<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/26/2007
	Function: 		Receipts Report
	Template:		dspReceipts.cfm
	Task:			serials_reports_dspReceipts
--->
<cfset objBackOrderReceipts = createObject("component", "admin.assets.cfcs.BackOrderReceipts")>
<cfset objBackOrder = createObject("component", "admin.assets.cfcs.BackOrder")>
<cfset objOEORDH = createObject("component", "admin.assets.cfcs.OEORDH")>
<cfset objOEORDD = createObject("component", "admin.assets.cfcs.OEORDD")>

<cfset qryBackOrderReceipts = objBackOrderReceipts.getReceiptsForToday()>

<cfoutput>
<table width="750" border="0" cellpadding="0" cellspacing="0">
	<tr><td class="textsmall">&nbsp;</td></tr>
	<tr>
		<td colspan="7">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td class="textmain" style="font-size:16px; color:0033CC" height="18" width="50%">
						<strong>Nor-Tech Receipts Report </strong>
					</td>
					<td class="textmain" height="18" style="font-size:14;" align="right">
						<strong>Report Date: #dateFormat(now(), 'mmmm d, yyyy')#</strong>
					</td>
				</tr>
			</table>								
		</td>
	</tr>
	<tr><td class="textsmall">&nbsp;</td></tr>

	<!--- Header --->
	<tr>
		<td class="productTitle" height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF">Part Number</td>
		<td class="productTitle" height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" align="center">Order<br>Number</td>
		<td class="productTitle" height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" align="center">Number<br>Systems</td>
		<td class="productTitle" height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" align="center">Customer<br>Account</td>
		<td class="productTitle" height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" align="center">Backorder<br>Amount</td>
		<td class="productTitle" height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" align="center">Quantity<br>Received</td>
		<td class="productTitle" height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" align="center">Date Received</td>
	</tr>
	
	<!--- Data --->
	<cfloop query="qryBackOrderReceipts">
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ORDNUMBER", qryBackOrderReceipts.ORDNUMBER, True)>
		<cfset qryOEORDH = objOEORDH.searchRecords(SearchRecord, "query")>
		<cfif isDefined("qryOEORDH.CUSTOMER")>
			<cfset CustomerAccountNumber = qryOEORDH.CUSTOMER>
		<cfelse>
			<cfset CustomerAccountNumber = "[Unknown]">
		</cfif>
		<cfset qryOEORDD = objOEORDD.listRecordsForParent("ORDUNIQ", qryOEORDH.ORDUNIQ)>
		<cfset NumberOfSystems = "">
		<cfset ThisIsAC_COMP_PARTS = 0>
		<cfloop query="qryOEORDD">
			<cfif objBackOrder.isABuildItem(qryOEORDD.ITEM)>
				<cfset NumberOfSystems = qryOEORDD.QTYORDERED + qryOEORDD.QTYSHPTODT>
			</cfif>
			<cfif trim(qryOEORDD.ITEM) IS "AC-COMP-PARTS">
				<cfset ThisIsAC_COMP_PARTS = 1>
			</cfif>
		</cfloop>
	
		<cfif NOT ThisIsAC_COMP_PARTS>
			<cfif NOT objBackOrder.isSoftwareExcludedItem(qryBackOrderReceipts.ITEMNO)>
				<cfif objBackOrder.orderIsNotAttached(qryOEORDH.ORDUNIQ)>
					<tr<cfif qryBackOrderReceipts.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
						<!--- PART NUMBER --->
						<td class="textsmall" valign="top">#qryBackOrderReceipts.ITEMNO#</td>
			
						<!--- ORDER NUMBER --->
						<td class="textsmall" valign="top" align="center">#qryBackOrderReceipts.ORDNUMBER#</td>
			
						<!--- NUMBER OF SYSTEMS --->
						<td class="textsmall" valign="top" align="center">#NumberOfSystems#</td>
			
						<!--- CUSTOMER ACCOUNT NUMBER --->
						<td class="textsmall" valign="top" align="center">
							#CustomerAccountNumber#
						</td>
			
						<!--- BACKORDER AMOUNT	 --->
						<cfif NOT isNumeric(qryBackOrderReceipts.QuantitySNs)>
							<cfset qryBackOrderReceipts.QuantitySNs = 0>
						</cfif>
						<cfset CurrentBackorderQuantity = qryBackOrderReceipts.OrderQuantity - qryBackOrderReceipts.QuantitySNs>
						<td class="textsmall" valign="top" align="center">#CurrentBackorderQuantity#</td>
			
						<!--- QUANTITY RECEIVED	 --->
						<td class="textsmall" valign="top" align="center">#qryBackOrderReceipts.QuantityReceivedRemaining#</td>
			
						<!--- DATE RECEIVED --->
						<td class="textsmall" valign="top" align="center">#dateFormat(qryBackOrderReceipts.DateReceived, 'm/d/yyyy')#</td>
					</tr>
				</cfif>
			</cfif>
		</cfif>
	</cfloop>
	
</table>
</cfoutput>