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
		<td class="textmain" align="left" width="30%"><b>Item Number:</b></td>
		<td class="textmain" align="left">#strHeader.ITEMNO#</td>
	</tr>
	<tr>
		<td class="textmain" align="left"><b>Item Description:</b></td>
		<td class="textmain" align="left">#strHeader.DESC#</td>
	</tr>
	<cfif isDefined("qrySerials.RecordCount")>
		<tr>
			<td class="textmain" align="left"><b>Quantity Found:</b></td>
			<td class="textmain" align="left">#qrySerials.RecordCount#</td>
		</tr>
	</cfif>

</table>
</cfoutput>