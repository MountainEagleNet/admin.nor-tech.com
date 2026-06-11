<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	12/06/2006
	Function: 		Returns to Vendor with No Serial Numbers Entered Report
	Template:		dspUndoneVendorReturns.cfm
	Task:			serials_reports_undone_vendorreturns
--->
	<cfset objPORETH1 = createObject("component", "admin.assets.cfcs.PORETH1")>

	<cfset qryVendorReturns = objPORETH1.listVendorReturns("RETNUMBER", 30)>		<!--- 30=LookBackDays --->

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
				<b>Returns to Vendor with No Serial Numbers Entered</b></font>
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
		<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Return Number</font></td>
		<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Vendor Name</font></td>
		<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Date of Return</font></td>
	</tr>

	<!--- LIST DATA --->	
	<cfif qryVendorReturns.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="3" class="productTitle"><font color="FF0000">There are no returns to vendor entered within the last 30 days awaiting serial number input.</font></td>
		</tr>
	</cfif>
	
	<cfloop query="qryVendorReturns">

		<tr <cfif qryVendorReturns.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
			<td class="textsmall" align="left" valign="top">#qryVendorReturns.RETNUMBER#</td>
			<td class="textsmall" align="left" valign="top">#qryVendorReturns.VDNAME#</td>
			<td class="textsmall" align="left" valign="top">#objPORETH1.formatDate(qryVendorReturns.DATE)#</td>
		</tr>
	</cfloop>

	</table>
</td>
</tr>


</table>
</cfoutput>