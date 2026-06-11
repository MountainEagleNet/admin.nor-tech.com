<cfset objOrders = createObject("component", "admin.assets.cfcs.orders.Orders")>
<cfset objOEVIA = createObject("component", "admin.assets.cfcs.OEVIA")>
<cfset objOECOINI = createObject("component", "admin.assets.cfcs.OECOINI")>

<cfset qInvoiceMain = objOrders.getInvoiceMain(form.iid)>
<cfset qInvoiceDetails = objOrders.getInvoiceDetails(form.iid)>

<cfset ShippingMethod = objOEVIA.getShippingMethod(qInvoiceMain.SHIPVIA)>

<cfif findNoCase("FED EX", ShippingMethod) NEQ 0>
	<cfset TrackingNumber = objOECOINI.getFEDEXTrackingNumber(qInvoiceMain.INVUNIQ)>
	<cfset TrackingURL = objOECOINI.getTrackingURL(ShippingMethod, TrackingNumber)>
<cfelse>
	<cfset TrackingNumber = objOECOINI.getUPSTrackingNumber(qInvoiceMain.INVUNIQ)>
	<cfset TrackingURL = objOECOINI.getTrackingURL(ShippingMethod, TrackingNumber)>
</cfif>

<cfset Subtotal = 0>
<cfset ShippingHandling = 0>

<cfsavecontent variable="variables.body">
<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<tr>
<td class="textsmall" colspan="2">&nbsp;</td>
</tr>

<tr>
<td class="textsmall" colspan="2" align="right">
	#qInvoiceMain.Customer#<br>
	#qInvoiceMain.InvNumber#<br>
</td>
</tr>

<tr>
<td class="textsmall" align="left" valign="top">
	#qInvoiceMain.BilName#<br>
	#qInvoiceMain.BilAddr1#<br>
	<cfif len(qInvoiceMain.BilAddr2)>#qInvoiceMain.BilAddr2#<br></cfif>
	<cfif len(qInvoiceMain.BilAddr3)>#qInvoiceMain.BilAddr3#<br></cfif>
	<cfif len(qInvoiceMain.BilAddr4)>#qInvoiceMain.BilAddr4#<br></cfif>
	#qInvoiceMain.BilCity#, #qInvoiceMain.BilState# #qInvoiceMain.BilZip#<br>
</td>
<td class="textsmall" align="left" valign="top">
	#qInvoiceMain.ShpName#<br>
	#qInvoiceMain.ShpAddr1#<br>
	<cfif len(qInvoiceMain.ShpAddr2)>#qInvoiceMain.ShpAddr2#<br></cfif>
	<cfif len(qInvoiceMain.ShpAddr3)>#qInvoiceMain.ShpAddr3#<br></cfif>
	<cfif len(qInvoiceMain.ShpAddr4)>#qInvoiceMain.ShpAddr4#<br></cfif>
	#qInvoiceMain.ShpCity#, #qInvoiceMain.ShpState# #qInvoiceMain.ShpZip#<br>
</td>
</tr>

<tr>
<td class="textsmall" colspan="2">&nbsp;</td>
</tr>

<tr>
<td class="textsmall" colspan="2">
	<table width="80%" border="0" align="center" cellpadding="3" cellspacing="1">
	<tr>
	<td class="textsmall" align="left">#qInvoiceMain.ViaDesc#</td>
	<td class="textsmall" align="left">#objOrders.DateFix(qInvoiceMain.InvDate)#</td>
	<td class="textsmall" align="left">NCTI</td>
	<td class="textsmall" align="left">#qInvoiceMain.OrdNumber#</td>
	</tr>

	<tr>
	<td class="textsmall" align="left">#qInvoiceMain.PONumber#</td>
	<td class="textsmall" align="left">#objOrders.DateFix(qInvoiceMain.OrdDate)#</td>
	<td class="textsmall" align="left">#qInvoiceMain.Terms#</td>
	<td class="textsmall" align="left">#qInvoiceMain.SalesPer1#</td>
	</tr>
	</table>
</td>
</tr>

<tr>
<td class="textsmall" colspan="2">&nbsp;</td>
</tr>

<tr>
<td class="textsmall" colspan="2">
	<table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
	<cfloop query="qInvoiceDetails">
		<tr>
		<td class="textsmall" valign="top">#Round(qInvoiceDetails.QtyOrdered)#</td>
		<td class="textsmall" valign="top">#Round(qInvoiceDetails.QtyShipped)#</td>
		<td class="textsmall" valign="top">#Round(qInvoiceDetails.QtyBackOrd)#</td>
		<td class="textsmall" valign="top">#qInvoiceDetails.Item#</td>
		<td class="textsmall" valign="top">#qInvoiceDetails.Desc#</td>
		<td class="textsmall" align="right" valign="top"><cfif trim(qInvoiceDetails.Desc) NEQ "SHIPPING & HANDLING">#DollarFormat(qInvoiceDetails.ItemPrice)# EA<cfelse>&nbsp;</cfif></td>
		<td class="textsmall" align="right" valign="top"><cfif trim(qInvoiceDetails.Desc) NEQ "SHIPPING & HANDLING">#DollarFormat(qInvoiceDetails.TotalPriceForLine)#<cfelse>#DollarFormat(qInvoiceDetails.ExtInvMisc)#</cfif></td>
		</tr>

		<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>
		<cfset SerialNumberList = objSerialsShipments.getSerialNumberList(qInvoiceDetails.INVUNIQ, qInvoiceDetails.LINENUM)>
		<cfif trim(SerialNumberList) IS NOT "">
			<tr>
			<td class="textsmall" colspan="4">&nbsp;</td>
			<td class="textsmall" colspan="3">#SerialNumberList#</td>
			</tr>
		</cfif>

		<cfif trim(qInvoiceDetails.Desc) IS NOT "SHIPPING & HANDLING" AND trim(qInvoiceDetails.Desc) IS NOT "Shipping">
			<cfset Subtotal = Subtotal + qInvoiceDetails.TotalPriceForLine>
		<cfelse>
			<cfset ShippingHandling = ShippingHandling + qInvoiceDetails.ExtInvMisc>
		</cfif>
	</cfloop>
	
	<tr>
	<td colspan="7" class="textsmall" align="right">&nbsp;</td>
	</tr>

	<tr>
	<td class="textsmall" colspan="7">
		<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
		<tr>
		<td class="textsmall" colspan="2">SHIPPING INFORMATION:</td>
		</tr>
		
		<tr>
		<td class="textsmall" width="23%">CARRIER:</td>
		<td class="textsmall">#ShippingMethod#</td>
		</tr>
		
		<tr>
		<td class="textsmall">DATE:</td>
		<td class="textsmall">#dateFormat(objOrders.DateFix(qInvoiceMain.ShipDate), 'MMMM DD, YYYY')#</td>
		</tr>
		
		<tr>
		<td class="textsmall">TRACKING NUMBER:</td>
		<td class="textsmall"><cfif TrackingNumber IS "">N/A<cfelse>#TrackingNumber#</cfif></td>
		</tr>
		
		<cfif TrackingNumber IS "" OR TrackingURL IS "">
			<tr>
			<td class="textsmall" colspan="2"><i>Contact your Nor-Tech sales rep for tracking information</i></td>
			</tr>
		</cfif>
		</table>
	</td>
	</tr>
				
	<cfset AmountDue = Subtotal + ShippingHandling>
	<tr>
	<td colspan="7" class="textsmall" align="right">&nbsp;</td>
	</tr>
	
	<tr>
	<td colspan="6" class="textsmall" align="right"><strong>SUBTOTAL</strong><br></td>
	<td class="textsmall" align="right">#DollarFormat(VARIABLES.Subtotal)#<br></td>
	</tr>
	
	<tr>
	<td colspan="6" class="textsmall" align="right"><strong>SHIPPING AND HANDLING</strong><br></td>
	<td class="textsmall" align="right">#DollarFormat(VARIABLES.ShippingHandling)#<br></td>
	</tr>
	
	<tr>
	<td colspan="6" class="textsmall" align="right"><strong>AMOUNT DUE</strong><br></td>
	<td class="textsmall" align="right">#DollarFormat(VARIABLES.AmountDue)#<br></td>
	</tr>
	</table>
</td>
</tr>

<tr>
<td class="textsmall" colspan="2">&nbsp;</td>
</tr>

<tr>
<td class="textsmall" colspan="2">&nbsp;</td>
</tr>

<tr>
<td class="textsmall" colspan="2">&nbsp;</td>
</tr>

<tr>
<td class="textsmall" colspan="2">&nbsp;</td>
</tr>

<tr>
<td class="textsmall" colspan="2">&nbsp;</td>
</tr>
</table>
</cfoutput>
</cfsavecontent>

<cfmail subject="Nor-Tech Customer Invoice #qInvoiceMain.InvNumber#" to="#form.email#" from="#SESSION.EmailAddress#" type="HTML">#variables.body#</cfmail>

<cflocation url="index.cfm?task=admin_orders_dspOrderDetail&iid=#form.iid#&sent=1&email=#urlEncodedFormat(form.email)#">