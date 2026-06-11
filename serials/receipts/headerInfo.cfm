<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/04/2006
	Function: 		This page displays header information, PORCPH1
	Template:		headerInfo.cfm
	Task:			[none] (page is included)
--->
<cfoutput>
<!--- HEADER INFORMATION --->
<table cellpadding="1" cellspacing="0" width="100%" border="0">
	<!--- HEADER INFORMATION --->
	<tr>
		<td width="30%" class="textmain" align="left"><b>Transaction Type:</b></td>
		<td class="textmain" align="left">Receipt</td>
	</tr>
	<tr>
		<td class="textmain" align="left"><b>Receipt Number:</b></td>
		<td class="textmain" align="left">#strHeader.RCPNUMBER#</td>
	</tr>
	<tr>
		<td class="textmain" align="left"><b>Vendor Name:</b></td>
		<td class="textmain" align="left">#strHeader.VDNAME#</td>
	</tr>
	<tr>
		<td class="textmain" align="left"><b>Date of Receipt:</b></td>
		<td class="textmain" align="left">#objPORCPH1.formatDate(strHeader.DATE)#</td>
	</tr>
</table>
</cfoutput>