<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/04/2006
	Function: 		This page displays detail information
	Template:		detailInfo.cfm
	Task:			[none] (page is included)
--->
<cfoutput>
<!--- RMA DETAIL INFORMATION --->
<table cellpadding="1" cellspacing="0" width="100%" border="0">
	<tr>
		<td class="textmain" align="left" width="25%"><b>Item Number:</b></td>
		<td class="textmain" align="left">#qryDetail.ITEM#</td>
	</tr>
	<tr>
		<td class="textmain" align="left"><b>Description:</b></td>
		<td class="textmain" align="left">#qryDetail.DESC#</td>
	</tr>
	<tr>
		<td class="textmain" align="left"><b>Location:</b></td>
		<td class="textmain" align="left">#qryDetail.LOCATION# (#objSerialsReturns.getLocationDescription(qryDetail.LOCATION)#)</td>
	</tr>
	<tr>
		<td class="textmain" align="left"><b>Quantity:</b></td>
		<td class="textmain" align="left">#int(qryDetail.QTY)#</td>
	</tr>
	
	<cfif isDefined("qrySerialsReturns.Posted") AND qrySerialsReturns.Posted EQ 1 AND
		  isDefined("qrySerialsReturns.PostedDate")>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td class="textmain" align="left"><b>Date Posted:</b></td>
			<td class="textmain" align="left">#dateFormat(qrySerialsReturns.PostedDate, 'mm/dd/yyyy')#, #timeFormat(qrySerialsReturns.PostedDate, 'h:mm tt')#</td>
		</tr>
	</cfif>
	
</table>
</cfoutput>