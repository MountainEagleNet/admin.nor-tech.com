<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/04/2006
	Function: 		This page displays detail information
	Template:		detailInfo.cfm
	Task:			[none] (page is included)
--->
<cfoutput>
<!--- DETAIL INFORMATION --->
<table cellpadding="1" cellspacing="0" width="100%" border="0">
	<tr>
		<td width="25%" class="textmain" align="left"><b>Item Number:</b></td>
		<td class="textmain" align="left">#qryDetail.ITEMNO#</td>
	</tr>
	<tr>
		<td class="textmain" align="left"><b>Description:</b></td>
		<td class="textmain" align="left">#qryDetail.ITEMDESC#</td>
	</tr>
	<tr>
		<td class="textmain" align="left"><b>Quantity:</b></td>
		<td class="textmain" align="left">#int(qryDetail.RQRETURNED)#</td>
	</tr>

	<cfif isDefined("qrySerialsVendorReturns.Posted") AND qrySerialsVendorReturns.Posted EQ 1 AND
		  isDefined("qrySerialsVendorReturns.PostedDate")>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td class="textmain" align="left"><b>Date Posted:</b></td>
			<td class="textmain" align="left">#dateFormat(qrySerialsVendorReturns.PostedDate, 'mm/dd/yyyy')#, #timeFormat(qrySerialsVendorReturns.PostedDate, 'h:mm tt')#</td>
		</tr>
	</cfif>
	
</table>
</cfoutput>