<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	10/12/2006
	Function: 		This page displays header information
	Template:		headerInfo.cfm
	Task:			[none] (page is included)
--->
<cfoutput>
<!--- ORDER INFORMATION --->
<table cellpadding="1" cellspacing="0" width="100%" border="0">
	<!--- HEADER INFORMATION --->
	<tr>
		<td width="30%" class="textmain" align="left"><b>Transaction Type:</b></td>
		<td class="textmain" align="left">Order Fulfillment</td>
	</tr>
	<tr>
		<td class="textmain" align="left"><b>Order Number:</b></td>
		<td class="textmain" align="left">#strHeader.ORDNUMBER#</td>
	</tr>
	<tr>
		<td class="textmain" align="left"><b>Customer Name:</b></td>
		<td class="textmain" align="left">#strHeader.BILNAME#</td>
	</tr>
	<tr>
		<td class="textmain" align="left"><b>Order Date:</b></td>
		<td class="textmain" align="left">#objOEORDH.formatDate(strHeader.ORDDATE)#</td>
	</tr>
</table>
</cfoutput>