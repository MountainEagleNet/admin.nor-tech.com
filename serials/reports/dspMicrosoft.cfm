<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	11/08/2007
	Function: 		Customer Sales Report
	Template:		dspSales.cfm
	Task:			serials_reports_sales_disp
--->
<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>
<cfset stFormCopy = objSerialsShipments.getSessionValue("MicrosoftItems")>
<cfset qryMicrosoftSku = objSerialsShipments.microsoftSkuReport(stFormCopy)>

<cfoutput>
<table width="950" border="0" align="center" cellpadding="3" cellspacing="1">
<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<td width="50%" valign="top">
		<table cellpadding="1" cellspacing="0" width="100%" border="0">
		<tr>
			<td colspan="2" valign="top" class="textmain" style="font-size:16px"><font color="0033CC">
				<b>Microsoft SKU Report</b></font>
			</td>
		</tr>
		<tr>
			<td class="textmain" width="30%"><b>Invoice Date Range:</b></td>
			<td class="textmain">#dateFormat(stFormCopy.BeginningDate, 'mm/dd/yyyy')# - #dateFormat(stFormCopy.EndingDate, 'mm/dd/yyyy')#</td>
		</tr>
<!---
		<tr>
			<td class="textmain"><b>Item Number(s):</b></td>
			<td class="textmain">
				<cfset RecordList = structKeyList(stFormCopy)>
				<cfloop list="#RecordList#" index="Column">
					<cfif findNoCase('ITEM', Column) NEQ 0 AND trim(stFormCopy[Column]) IS NOT "">
						#trim(stFormCopy[Column])#
					</cfif>
				</cfloop>
			</td>
		</tr>
--->		
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
		<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Sales Rep</font></td>
		<td height="18" bgcolor="006633" class="productTitle" colspan="2"><font color="FFFFFF">Customer</font></td>
		<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Item</font></td>
		<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Description</font></td>
		<td height="18" bgcolor="006633" class="productTitle" align="center"><font color="FFFFFF">Invoice<br>Number</font></td>
		<td height="18" bgcolor="006633" class="productTitle" align="center"><font color="FFFFFF">Invoice<br>Date</font></td>
		<td height="18" bgcolor="006633" class="productTitle" align="center"><font color="FFFFFF">Quantity</font></td>
		<td height="18" bgcolor="006633" class="productTitle" align="center"><font color="FFFFFF">Price</font></td>
	</tr>

	<!--- LIST DATA --->	
	<cfif qryMicrosoftSku.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="9" class="productTitle">
				<font color="FF0000">
					No records were found that match your selection criteria
				</font>
			</td>
		</tr>
	</cfif>
	
	<cfloop query="qryMicrosoftSku">
		<tr  <cfif qryMicrosoftSku.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
			<td class="textsmall" align="left" valign="top">#qryMicrosoftSku.SalesRep#</td>
			<td class="textsmall" align="left" valign="top">#qryMicrosoftSku.CUSTOMER#</td>
			<td class="textsmall" align="left" valign="top">
				<table cellpadding="0" cellspacing="0" width="100%" border="0">
					<tr><td class="textsmall" align="left">#trim(qryMicrosoftSku.SHPNAME)#</td></tr>
					<cfif trim(qryMicrosoftSku.SHPADDR1) IS NOT "">
						<tr><td class="textsmall" align="left">#qryMicrosoftSku.SHPADDR1#</td></tr>
					</cfif>
					<cfif trim(qryMicrosoftSku.SHPADDR2) IS NOT "">
						<tr><td class="textsmall" align="left">#qryMicrosoftSku.SHPADDR2#</td></tr>
					</cfif>
					<cfif trim(qryMicrosoftSku.SHPADDR3) IS NOT "">
						<tr><td class="textsmall" align="left">#qryMicrosoftSku.SHPADDR3#</td></tr>
					</cfif>
					<cfif trim(qryMicrosoftSku.SHPADDR4) IS NOT "">
						<tr><td class="textsmall" align="left">#qryMicrosoftSku.SHPADDR4#</td></tr>
					</cfif>
					<tr><td class="textsmall" align="left">#qryMicrosoftSku.SHPCITY#, #qryMicrosoftSku.SHPSTATE# #qryMicrosoftSku.SHPZIP#</td></tr>
				</table>
			</td>
			<td class="textsmall" align="left" valign="top">#trim(qryMicrosoftSku.ITEM)#</td>
			<td class="textsmall" align="left" valign="top">#trim(qryMicrosoftSku.DESC)#</td>
			<td class="textsmall" align="center" valign="top">#qryMicrosoftSku.INVNUMBER#</td>
			<td class="textsmall" align="center" valign="top">#objSerialsShipments.formatDate(qryMicrosoftSku.INVDATE)#</td>
			<td class="textsmall" align="center" valign="top">#int(qryMicrosoftSku.QTYSHIPPED)#</td>
			<td class="textsmall" align="center" valign="top">#dollarFormat(qryMicrosoftSku.UNITPRICE)#</td>
		</tr>
	</cfloop>

	</table>
</td>
</tr>

</table>
</cfoutput>