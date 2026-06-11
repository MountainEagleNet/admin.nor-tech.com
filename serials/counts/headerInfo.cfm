<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/08/2006
	Function: 		This page displays header information, tblCounts
	Template:		headerInfo.cfm
	Task:			[none] (page is included)
--->
<cfoutput>

<cfset objAdmin = createObject("component", "admin.assets.cfcs.Admin")>
<cfset qryUser = objAdmin.getRecordAsQuery(SESSION.adminuserid)>

<!--- HEADER INFORMATION --->
<table cellpadding="1" cellspacing="0" width="100%" border="0">
	<tr>
		<td width="30%" class="textmain" align="left"><b>Transaction Type:</b></td>
		<td class="textmain" align="left">Count</td>
	</tr>
	<tr>
		<td class="textmain" align="left"><b>Item Number:</b></td>
		<td class="textmain" align="left">#stRecord.ITEMNO#</td>
	</tr>
	<tr>
		<td class="textmain" align="left"><b>Item Description:</b></td>
		<td class="textmain" align="left">#objSerialsCounts.getItemDescription(stRecord.ITEMNO)#</td>
	</tr>
	<tr>
		<td class="textmain" align="left"><b>Location:</b></td>
		<td class="textmain" align="left">#stRecord.LOCATION#</td>
	</tr>
	<tr>
		<td class="textmain" align="left"><b>Location Description:</b></td>
		<td class="textmain" align="left">#objSerialsCounts.getLocationDescription(stRecord.LOCATION)#</td>
	</tr>
	<tr>
		<td class="textmain" align="left"><b>User:</b></td>
		<td class="textmain" align="left">
			<cfif isDefined("stRecord.Posted") AND stRecord.Posted EQ 1>
				#stRecord.UserName#
			<cfelse>
				#qryUser.fname# #qryUser.lname#
			</cfif>
		</td>
	</tr>
	<tr>
		<td class="textmain" align="left"><b>Date/Time:</b></td>
		<td class="textmain" align="left">
			<cfif isDefined("stRecord.Posted") AND stRecord.Posted EQ 1>
				#dateFormat(stRecord.PostedDate, 'mm/dd/yyyy')#, #timeFormat(stRecord.PostedDate, 'h:mm tt')#
			<cfelse>
				#dateFormat(now(), 'mm/dd/yyyy')#, #timeFormat(now(), 'h:mm tt')#
			</cfif>
		</td>
	</tr>
	<tr>
		<td class="textmain" align="left"><b>Quantity:</b></td>
		<td class="textmain" align="left">#int(stRecord.QUANTITY)#</td>
	</tr>
</table>
</cfoutput>