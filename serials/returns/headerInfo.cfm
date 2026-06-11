<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/04/2006
	Function: 		This page displays header information
	Template:		headerInfo.cfm
	Task:			[none] (page is included)
--->
<cfoutput>
<!--- RMA HEADER INFORMATION --->
<table cellpadding="1" cellspacing="0" width="100%" border="0">
	<tr>
		<td class="textmain" align="left"><b>Transaction Type:</b></td>
		<td class="textmain" align="left">
			<cfif NOT isDefined("URL.RMAAction")>
				Returns/RMA
			<cfelseif URL.RMAAction IS "Receiving">
				Returns/RMA - Receiving
			<cfelse>
				Returns/RMA - Authorization
			</cfif>
		</td>
	</tr>
	<tr>
		<td width="25%" class="textmain" align="left"><b>RMA Number:</b></td>
		<td class="textmain" align="left">#strHeader.RMANUMBER#</td>
	</tr>
	<tr>
		<td class="textmain" align="left"><b>RMA Date:</b></td>
		<td class="textmain" align="left">#objRAHEAD.formatDate(strHeader.RMADATE)#</td>
	</tr>
	<tr>
		<td class="textmain" align="left"><b>Customer Code:</b></td>
		<td class="textmain" align="left">#strHeader.CUSTOMER#</td>
	</tr>
	<tr>
		<td class="textmain" align="left"><b>Customer Name:</b></td>
		<td class="textmain" align="left">#strHeader.BILNAME#</td>
	</tr>
</table>
</cfoutput>