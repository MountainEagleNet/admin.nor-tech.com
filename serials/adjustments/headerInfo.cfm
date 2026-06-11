<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/04/2006
	Function: 		This page displays header information, ICADEH
	Template:		headerInfo.cfm
	Task:			[none] (page is included)
--->
<cfoutput>
<!--- HEADER INFORMATION --->
<table cellpadding="1" cellspacing="0" width="100%" border="0">
	<tr>
		<td width="30%" class="textmain" align="left"><b>Transaction Type:</b></td>
		<td class="textmain" align="left">Adjustment</td>
	</tr>
	<tr>
		<td class="textmain" align="left"><b>Adjustment Number:</b></td>
		<td class="textmain" align="left">#strHeader.DOCNUM#</td>
	</tr>
	<tr>
		<td class="textmain" align="left"><b>Date of Adjustment:</b></td>
		<td class="textmain" align="left">#objICADEH.formatDate(strHeader.TRANSDATE)#</td>
	</tr>
</table>
</cfoutput>