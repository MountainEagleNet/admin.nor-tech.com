<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/05/2006
	Function: 		This page displays detail information
	Template:		detailInfo.cfm
	Task:			[none] (page is included)
--->
<cfoutput>
<!--- DETAIL INFORMATION --->
<table cellpadding="1" cellspacing="0" width="100%" border="0">
	<tr>
		<td width="30%" class="textmain" align="left"><b>Item Number:</b></td>
		<td class="textmain" align="left">#qryDetail.ITEMNO#</td>
	</tr>
	<tr>
		<td class="textmain" align="left"><b>Description:</b></td>
		<td class="textmain" align="left">#qryDetail.ITEMDESC#</td>
	</tr>
	<tr>
		<td class="textmain" align="left"><b>Quantity:</b></td>
		<td class="textmain" align="left">#int(qryDetail.QUANTITY)#</td>
	</tr>
	<tr>
		<td class="textmain" align="left"><b>From Location:</b></td>
		<td class="textmain" align="left">#trim(qryDetail.FROMLOC)#: #qryDetail.FRLOCDESC#</td>
	</tr>
	<tr>
		<td class="textmain" align="left"><b>To Location:</b></td>
		<td class="textmain" align="left">#trim(qryDetail.TOLOC)#: #qryDetail.TOLOCDESC#</td>
	</tr>
	
	<cfif isDefined("qrySerialsTransfers.Posted") AND qrySerialsTransfers.Posted EQ 1 AND
		  isDefined("qrySerialsTransfers.PostedDate")>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td class="textmain" align="left"><b>Date Posted:</b></td>
			<td class="textmain" align="left">#dateFormat(qrySerialsTransfers.PostedDate, 'mm/dd/yyyy')#, #timeFormat(qrySerialsTransfers.PostedDate, 'h:mm tt')#</td>
		</tr>
	</cfif>
	
</table>
</cfoutput>