<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	12/06/2006
	Function: 		Receipts with No Serial Numbers Entered Report
	Template:		dspUndoneReceipts.cfm
	Task:			serials_reports_undone_receipts
--->
	<cfset objPORCPH1 = createObject("component", "admin.assets.cfcs.PORCPH1")>

	<cfset qryReceipts = objPORCPH1.listReceipts("RCPNUMBER", 30, 1)>		<!--- 30=LookBackDays, 1=OmitDropShip --->

</cfsilent>

<cfoutput>
<table width="900" border="0" align="center" cellpadding="3" cellspacing="1">
<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<td width="50%" valign="top">
		<table cellpadding="1" cellspacing="0" width="100%" border="0">
		<tr>
			<td colspan="2" valign="top" class="textmain" style="font-size:16px"><font color="0033CC">
				<b>Receipts with No Serial Numbers Entered</b></font>
			</td>
		</tr>
		</table>
	</td>
	<td valign="top">
		<table cellpadding="1" cellspacing="0" width="100%" border="0">
		<tr>
			<td class="textmain" width="30%"><b>Date of Report:</b></td>
			<td class="textmain">#dateFormat(now(), 'mm/dd/yyyy')# at #timeFormat(now(), 'h:mm tt')#</td>
		</tr>
		</table>
	</td>
</tr>
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain" colspan="2">
	<table cellpadding="0" cellspacing="0" width="100%" border="0">
	
	<!--- LIST HEADINGS --->
	<tr>
		<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Receipt Number</font></td>
		<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Vendor Name</font></td>
		<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Date of Receipt</font></td>
	</tr>

	<!--- LIST DATA --->	
	<cfif qryReceipts.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="3" class="productTitle"><font color="FF0000">There are no receipts entered within the last 30 days awaiting serial number input.</font></td>
		</tr>
	</cfif>
	
	<cfloop query="qryReceipts">

		<tr <cfif qryReceipts.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
			<td class="textsmall" align="left" valign="top">#qryReceipts.RCPNUMBER#</td>
			<td class="textsmall" align="left" valign="top">#qryReceipts.VDNAME#</td>
			<td class="textsmall" align="left" valign="top">#objPORCPH1.formatDate(qryReceipts.DATE)#</td>
		</tr>
	</cfloop>

	</table>
</td>
</tr>


</table>
</cfoutput>