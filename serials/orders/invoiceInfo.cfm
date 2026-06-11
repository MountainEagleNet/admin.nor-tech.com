<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	10/16/2006
	Function: 		This page displays invoice header information
	Template:		invoiceInfo.cfm
	Task:			[none] (page is included)
--->

<cfoutput>
<!--- INVOICE HEADER INFORMATION --->
<table cellpadding="1" cellspacing="0" width="100%" border="0">
	<tr>
		<td width="30%" class="textmain" align="left"><b>Invoice Number:</b></td>
		<td class="textmain" align="left">
			#strOEINVH.INVNUMBER#
		</td>
	</tr>
	<tr>
		<td class="textmain" align="left"><b>Invoice Date:</b></td>
		<td class="textmain" align="left">
			#objOEINVH.formatDate(strOEINVH.INVDATE)#
		</td>
	</tr>
</table>
</cfoutput>