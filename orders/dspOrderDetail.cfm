<!---
Coded By: Alternative Systems, Inc - Ron Barth
Create Date: 05/21/2010
Edit Date: 
Function: This page displays a customer's order detail, in nor-tech invoice format
dspOrderDetails.cfm
--->

	<cfset objOrders = createObject("component", "admin.assets.cfcs.orders.Orders")>
    <cfset objOEVIA = createObject("component", "admin.assets.cfcs.OEVIA")>
    <cfset objOECOINI = createObject("component", "admin.assets.cfcs.OECOINI")>
    
    <cfset qInvoiceMain = objOrders.getInvoiceMain(URL.iid)>
    <cfset qInvoiceDetails = objOrders.getInvoiceDetails(URL.iid)>
    
    <!--- Get Shipper Name / Method from ACCPAC table OEVIA --->
    <cfset ShippingMethod = objOEVIA.getShippingMethod(qInvoiceMain.SHIPVIA)>
    
    
    
    
    <!--- RAB 10/18/2012 --->
<!---        
    <cfset TrackingNumber = objOECOINI.getTrackingNumber(qInvoiceMain.INVUNIQ)>
    <cfset TrackingURL = objOECOINI.getTrackingURL(ShippingMethod, TrackingNumber)>
--->
    <!--- FED EX --->
	<cfif findNoCase("FED EX", ShippingMethod) NEQ 0>
		<cfset TrackingNumber = objOECOINI.getFEDEXTrackingNumber(qInvoiceMain.INVUNIQ)>
        <cfset TrackingURL = objOECOINI.getTrackingURL(ShippingMethod, TrackingNumber)>
        
    <!--- UPS --->
    <cfelse>
		<!--- RAB 11/01/2012 --->
<!---	<cfset TrackingNumber = objOECOINI.getTrackingNumber(qInvoiceMain.INVUNIQ)>	--->
		<cfset TrackingNumber = objOECOINI.getUPSTrackingNumber(qInvoiceMain.INVUNIQ)>
        
        <cfset TrackingURL = objOECOINI.getTrackingURL(ShippingMethod, TrackingNumber)>
    </cfif>



    <cfset Subtotal = 0>
    <cfset ShippingHandling = 0>

<cfoutput>
	<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
	<!--- spacer --->
	<tr>
		<td class="textsmall" colspan="2">&nbsp;</td>
	</tr>
	<!--- links --->
	<tr>
		<td class="textsmall" colspan="2" align="right">
			<cfif TrackingURL IS NOT "">
				<a href="#TrackingURL#" target="_blank">Track Shipment</a><br>
			</cfif>
<!---
			<a href="index.cfm?task=cust_orders_print&iid=#URL.iID#" target="_blank">Print Order</a><br>
			<a href="index.cfm?task=cust_orders_rma&iid=#URL.iID#">Request RMA</a><br>
--->            
		</td>
	</tr>
	<!--- header --->
	<tr>
		<td class="textsmall" colspan="2" align="right">
			#qInvoiceMain.Customer#<br>
			#qInvoiceMain.InvNumber#<br>
		</td>
	</tr>
	<!--- shipping and billing --->
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
	<!--- spacer --->
	<tr>
		<td class="textsmall" colspan="2">&nbsp;
				
		</td>
	</tr>
	<!--- main invoice detail --->
	<!--- order/invoice information --->
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
	<!--- spacer --->
	<tr>
		<td class="textsmall" colspan="2">&nbsp;
				
		</td>
	</tr>
	<!--- shipping and billing --->
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
					<td class="textsmall" align="right" valign="top">
						<cfif trim(qInvoiceDetails.Desc) NEQ "SHIPPING & HANDLING">
							#DollarFormat(qInvoiceDetails.ItemPrice)# EA
						<cfelse>
							&nbsp;
						</cfif>					
					</td>
					<td class="textsmall" align="right" valign="top">
						<cfif trim(qInvoiceDetails.Desc) NEQ "SHIPPING & HANDLING">
							#DollarFormat(qInvoiceDetails.TotalPriceForLine)#
						<cfelse>
							#DollarFormat(qInvoiceDetails.ExtInvMisc)#
						</cfif>
					</td>
				</tr>
				
				<!--- SERIAL NUMBERS --->
<!---                
				<cfif qInvoiceMain.INVDATE LT APPLICATION.SerialInstallDate 
					  <!--- vvv  10/18/06: temporarily added to show sales reps new serial number info   vvv --->
					  AND qInvoiceMain.Customer IS NOT "O003"
					>
					<cfset SerialNumberList = objOrders.getComment(qInvoiceDetails.INVUNIQ, qInvoiceDetails.DETAILNUM)>
				<cfelse>
--->                
					<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>
					<cfset SerialNumberList = objSerialsShipments.getSerialNumberList(qInvoiceDetails.INVUNIQ, qInvoiceDetails.LINENUM)>
<!---
				</cfif>
--->
				<cfif trim(SerialNumberList) IS NOT "">
					<tr>
						<td class="textsmall" colspan="4">&nbsp;</td>
						<td class="textsmall" colspan="3">#SerialNumberList#</td>
					</tr>
				</cfif>
				
				<!--- handle totalling --->
				<cfif trim(qInvoiceDetails.Desc) IS NOT "SHIPPING & HANDLING" AND trim(qInvoiceDetails.Desc) IS NOT "Shipping">
					<cfset Subtotal = Subtotal + qInvoiceDetails.TotalPriceForLine>
				<cfelse>
					<cfset ShippingHandling = ShippingHandling + qInvoiceDetails.ExtInvMisc>
				</cfif>
			</cfloop>
			<!--- spacer --->
			<tr>
				<td colspan="7" class="textsmall" align="right">&nbsp;
					
				</td>
			</tr>

			<!--- STARSHIP SHIPPING INFORMATION --->
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
							<td class="textsmall">
								<cfif TrackingNumber IS "">
									N/A
								<cfelse>
									<cfif TrackingURL IS NOT "">
										<a href="#TrackingURL#" target="_blank">#TrackingNumber#</a>
									<cfelse>
										#TrackingNumber#
									</cfif>
								</cfif>
							</td>
						</tr>
						<cfif TrackingNumber IS "" OR TrackingURL IS "">
							<tr>
								<td class="textsmall" colspan="2">
									<i>Contact your Nor-Tech sales rep for tracking information</i>
								</td>
							</tr>
						</cfif>
					</table>
				</td>
			</tr>
			
			
			<!--- totals --->
			<cfset AmountDue = Subtotal + ShippingHandling>
			<!--- spacer --->
			<tr>
				<td colspan="7" class="textsmall" align="right">&nbsp;
					
				</td>
			</tr>
			<!--- display totals --->
			<tr>
				<td colspan="6" class="textsmall" align="right">
					<strong>SUBTOTAL</strong><br>
				</td>
				<td class="textsmall" align="right">
					#DollarFormat(VARIABLES.Subtotal)#<br>
				</td>
			</tr>
			<tr>
				<td colspan="6" class="textsmall" align="right">
					<strong>SHIPPING AND HANDLING</strong><br>
				</td>
				<td class="textsmall" align="right">
					#DollarFormat(VARIABLES.ShippingHandling)#<br>
				</td>
			</tr>
			<tr>
				<td colspan="6" class="textsmall" align="right">
					<strong>AMOUNT DUE</strong><br>
				</td>
				<td class="textsmall" align="right">
					#DollarFormat(VARIABLES.AmountDue)#<br>
				</td>
			</tr>
			</table>
		</td>
	</tr>
	
	<tr>
	<td class="textsmall" colspan="2">&nbsp;</td>
	</tr>
	
	<cfparam name="url.sent" default="0"/>
	<cfparam name="url.email" default=""/>
	<cfif trim(url.email) is ""><cfset url.email = objOrders.getCustomerEmail(qInvoiceMain.Customer)></cfif>
	<cfif url.sent eq 0>	
		<form name="frm" action="index.cfm" method="post">
		<input type="hidden" name="task" value="admin_orders_actEmail"/>
		<input type="hidden" name="AcctNo" value="#qInvoiceMain.Customer#"/>
		<input type="hidden" name="iid" value="#URL.iid#"/>
		<tr>
		<td class="textsmall" colspan="2" align="center">
			<table cellpadding="2" cellspacing="0" border="0">
			<tr>
			<td align="left" class="textsmall" ><b>Send a copy of this invoice to #qInvoiceMain.BilName# at:</b></td>
			</tr>
			<tr>
			<td align="left">
				<input type="text" name="email" size="40" value="#url.email#"/> 
				<input type="submit" value="Send"/>
			</td>
			</tr>
			</table>
		</td>
		</tr>
		</form>
	<cfelse>
		<tr>
		<td class="textsmall" colspan="2" align="center"><font color="red"><i>A copy of this invoice was successfully emailed to #url.email#</i></font></td>
		</tr>
	</cfif>
	
	<!--- padding for short invoices --->
	<!--- spacer --->
	<tr>
		<td class="textsmall" colspan="2">&nbsp;</td>
	</tr>
	<!--- spacer --->
	<tr>
		<td class="textsmall" colspan="2">&nbsp;</td>
	</tr>
	<!--- spacer --->
	<tr>
		<td class="textsmall" colspan="2">&nbsp;</td>
	</tr>
	<!--- spacer --->
	<tr>
		<td class="textsmall" colspan="2">&nbsp;</td>
	</tr>
	<!--- spacer --->
	<tr>
		<td class="textsmall" colspan="2">&nbsp;</td>
	</tr>
</table>
</cfoutput>