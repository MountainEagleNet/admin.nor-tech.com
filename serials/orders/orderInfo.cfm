<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/04/2006
	Function: 		This page displays order information
	Template:		orderInfo.cfm
	Task:			[none] (page is included)
--->
<cfoutput>
<!--- ORDER INFORMATION --->
<table cellpadding="1" cellspacing="0" width="100%" border="0">
	<tr>
		<td width="25%" class="textmain" align="left"><b>Transaction Type:</b></td>
		<td class="textmain" align="left">Order Fulfillment</td>
	</tr>
	<tr>
		<td class="textmain" align="left"><b>Order Number:</b></td>
		<td class="textmain" align="left">#qryOrder.ORDNUMBER#</td>
	</tr>
	<tr>
		<td class="textmain" align="left"><b>Customer Name:</b></td>
		<td class="textmain" align="left">#qryOrder.BILNAME#</td>
	</tr>
	<tr>
		<td class="textmain" align="left"><b>Order Date:</b></td>
		<td class="textmain" align="left">#objOEORDH.formatDate(qryOrder.ORDDATE)#</td>
	</tr>
</table>
</cfoutput>