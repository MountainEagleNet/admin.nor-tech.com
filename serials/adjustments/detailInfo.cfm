<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/04/2006
	Function: 		This page displays detail information, ICADED
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
		<td class="textmain" align="left"><b>Adjustment Type:</b></td>
		<td class="textmain" align="left">
			<cfif qryDetail.TRANSTYPE EQ 1 OR qryDetail.TRANSTYPE EQ 3 OR qryDetail.TRANSTYPE EQ 5>
				Increase
			<cfelse>
				Decrease
			</cfif>
		</td>
	</tr>
	
	<cfif isDefined("qrySerialsAdjustments.Posted") AND qrySerialsAdjustments.Posted EQ 1 AND
		  isDefined("qrySerialsAdjustments.PostedDate")>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td class="textmain" align="left"><b>Date Posted:</b></td>
			<td class="textmain" align="left">#dateFormat(qrySerialsAdjustments.PostedDate, 'mm/dd/yyyy')#, #timeFormat(qrySerialsAdjustments.PostedDate, 'h:mm tt')#</td>
		</tr>
	</cfif>
	
</table>
</cfoutput>