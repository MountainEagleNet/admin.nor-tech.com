<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/04/2006
	Function: 		This page displays detail information, PORCPL
	Template:		detailInfo.cfm
	Task:			[none] (page is included)
--->

<cfif NOT isDefined("RemainingQuantity")>
	<cfset RemainingQuantity = objSerialsReceipts.getRemainingQuantity(qryDetail.RCPHSEQ, qryDetail.RCPLREV)>
</cfif>

<cfoutput>
<!--- DETAIL INFORMATION --->
<table cellpadding="1" cellspacing="0" width="100%" border="0">
	<!--- DETAIL INFORMATION --->
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
		<td class="textmain" align="left">#int(qryDetail.RQRECEIVED)#</td>
	</tr>

	<cfif isDefined("RemainingQuantity")>
		<tr>
			<td class="textmain" align="left"><b>Remaining Quantity:</b></td>
			<td class="textmain" align="left">#RemainingQuantity#</td>
		</tr>
	</cfif>

	<cfif isDefined("qrySerialsReceipts.Posted") AND qrySerialsReceipts.Posted EQ 1 AND
		  isDefined("qrySerialsReceipts.PostedDate")>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td class="textmain" align="left"><b>Date Posted:</b></td>
			<td class="textmain" align="left">#dateFormat(qrySerialsReceipts.PostedDate, 'mm/dd/yyyy')#, #timeFormat(qrySerialsReceipts.PostedDate, 'h:mm tt')#</td>
		</tr>
	</cfif>

</table>
</cfoutput>