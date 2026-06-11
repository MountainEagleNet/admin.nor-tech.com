<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/04/2006
	Function: 		This page displays detail information
	Template:		detailInfo.cfm
	Task:			[none] (page is included)
--->
<cfoutput>
<!--- SHIPMENT DETAIL INFORMATION --->
<table cellpadding="1" cellspacing="0" width="100%" border="0">
	<tr>
		<td width="30%" class="textmain" align="left"><b>Item Number:</b></td>
		<td class="textmain" align="left">#qryDetail.ITEM#</td>
	</tr>
	<tr>
		<td class="textmain" align="left"><b>Description:</b></td>
		<td class="textmain" align="left">#qryDetail.DESC#</td>
	</tr>

	<tr>
		<td class="textmain" align="left"><b>Order Quantity:</b></td>
<!---	<td class="textmain" align="left">#int(qryDetail.ORIGQTY)#</td>	--->
		<td class="textmain" align="left">#int(qryDetail.QTYORDERED + qryDetail.QTYSHPTODT)#</td>
	</tr>
	<tr>
		<td class="textmain" align="left"><b>Remaining Quantity:</b></td>
		<td class="textmain" align="left">#RemainingQuantity#</td>
	</tr>

<!---
	<cfif isDefined("qrySerialsShipments.Posted") AND qrySerialsShipments.Posted EQ 1 AND
		  isDefined("qrySerialsShipments.PostedDate")>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td class="textmain" align="left"><b>Date Posted:</b></td>
			<td class="textmain" align="left">#dateFormat(qrySerialsShipments.PostedDate, 'mm/dd/yyyy')#, #timeFormat(qrySerialsShipments.PostedDate, 'h:mm tt')#</td>
		</tr>
	</cfif>
--->	
</table>
</cfoutput>