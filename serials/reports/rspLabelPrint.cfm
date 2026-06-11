<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/12/2006
	Function: 		This page displays the confirmation page prior to printing the bar code label
	Template:		rspLabelPrint.cfm
	Task:			serials_reports_label_response
--->
	<cfset objSerials = createObject("component", "admin.assets.cfcs.Serials")>

	<cfset stRecord = objSerials.getRecord(URL.SerialID)>

</cfsilent>

<cfoutput>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objSerials.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	<tr>
		<td valign="top" class="textmain" width="30%"><b>Serial Number:</b></td>
		<td valign="top" class="textmain">#stRecord.SerialNumber#</td>
	</tr>
	<tr>
		<td valign="top" class="textmain"><b>Item Number:</b></td>
		<td valign="top" class="textmain">#stRecord.ITEMNO#</td>
	</tr>
	<tr>
		<td valign="top" class="textmain"><b>Item Description:</b></td>
		<td valign="top" class="textmain">#objSerials.getItemDescription(stRecord.ITEMNO)#</td>
	</tr>
	</table>
</td>
</tr>
</table>
</cfoutput>