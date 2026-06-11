<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/04/2006
	Function: 		This page displays header information
	Template:		headerInfo.cfm
	Task:			[none] (page is included)
--->
<cfoutput>
<!--- HEADER INFORMATION --->
<table cellpadding="1" cellspacing="0" width="100%" border="0">
	<tr>
		<td width="25%" class="textmain" align="left"><b>Transaction Type:</b></td>
		<td class="textmain" align="left">Return to Vendor</td>
	</tr>
	<tr>
		<td class="textmain" align="left"><b>Return Number:</b></td>
		<td class="textmain" align="left">#strHeader.RETNUMBER#</td>
	</tr>
	<tr>
		<td class="textmain" align="left"><b>Vendor Name:</b></td>
		<td class="textmain" align="left">#strHeader.VDNAME#</td>
	</tr>
	<tr>
		<td class="textmain" align="left"><b>Date of Return:</b></td>
		<td class="textmain" align="left">#objPORETH1.formatDate(strHeader.DATE)#</td>
	</tr>
</table>
</cfoutput>