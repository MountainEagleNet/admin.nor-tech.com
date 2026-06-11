<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	11/08/2007
	Function: 		Customer Sales Report
	Template:		dspSales.cfm
	Task:			serials_reports_sales_disp
--->
<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>

<cfset qrySalesReport = objSerialsShipments.customerSalesReport(URL.BeginningDate, URL.EndingDate, URL.BeginningItem, URL.EndingItem)>

<!--- TEMP --->
<!---<cfset querySetCell(qrySalesReport, "SerialNumbers", "01232sdte,043454hgdfg,023453ahgf,032hasdfe", 1)>--->


<!--- Export the report to a CSV file --->
<cfif URL.Export EQ 1>

	<cfset textHeader = "Invoice ##, Invoice Date, Customer Name, Address Line 1, Address Line 2, Address Line 3, Address Line 4, City, State, Zip Code, Item ##, Quantity Sold, Serial Number(s)#chr(10)#">

	<!--- loop over all serial numbers --->
	<cfloop query="qrySalesReport">

		<cfset SerialNumberList = "">
<!---
		<cfif findNoCase(",", qrySalesReport.SerialNumbers) EQ 0>
			<cfset SerialNumberList = "'" & qrySalesReport.SerialNumbers & "'">
		<cfelse>
--->		
			<cfset FirstOne = 1>
			<cfloop list="#qrySalesReport.SerialNumbers#" index="Column">
				<cfif NOT FirstOne>
<!---				<cfset SerialNumberList = SerialNumberList & ", ">	--->
					<cfset SerialNumberList = SerialNumberList & ",">
				</cfif>
				<cfset FirstOne = 0>
				<cfset SerialNumberList = SerialNumberList & Column>
			</cfloop>
			
			<cfset SerialNumberList = "'" & SerialNumberList & "'">
<!---
		</cfif>
--->
		<cfoutput>
			<cfsavecontent variable="tmpHeader">"#qrySalesReport.INVNUMBER#","#objSerialsShipments.formatDate(qrySalesReport.INVDATE)#","#left(trim(qrySalesReport.SHPNAME), 35)#","#trim(qrySalesReport.SHPADDR1)#","#trim(qrySalesReport.SHPADDR2)#","#trim(qrySalesReport.SHPADDR3)#","#trim(qrySalesReport.SHPADDR4)#","#trim(qrySalesReport.SHPCITY)#","#trim(qrySalesReport.SHPSTATE)#","#trim(qrySalesReport.SHPZIP)#","#trim(qrySalesReport.ITEM)#","#int(qrySalesReport.QTYSHIPPED)#","#SerialNumberList#"#chr(13)##chr(10)#</cfsavecontent>
			<cfset textHeader = textHeader & tmpHeader>
		</cfoutput>
	</cfloop>

	<cfset TempUUID = createUUID()>
	
	<!--- create the files --->
	<cfset CSVDirectory = "C:\inetpub\htdocs\ntc.nortech.com\media\wwwexport\">
	
	
<!---<cffile action="write" file="c:\wwwexport\CustomerSalesCSV-#TempUUID#.csv" output="#textHeader#">--->
<!---<cffile action="write" file="C:\inetpub\htdocs\test\wwwexport\CustomerSalesCSV-#TempUUID#.csv" output="#textHeader#">--->		
	 <cffile action="write" file="#CSVDirectory#CustomerSalesCSV-#TempUUID#.csv" output="#textHeader#">	
	
		
	
<!---<cfheader name="Content-Disposition" value="attachment; filename=c:\wwwexport\CustomerSalesCSV-#TempUUID#.csv" />--->
<!---<cfheader name="Content-Disposition" value="attachment; filename=C:\inetpub\htdocs\test\wwwexport\CustomerSalesCSV-#TempUUID#.csv" />--->
	 <cfheader name="Content-Disposition" value="attachment; filename=#CSVDirectory#CustomerSalesCSV-#TempUUID#.csv" />
	 
	 
	 		
<!---<cfcontent type="text/plain" file="c:\wwwexport\CustomerSalesCSV-#TempUUID#.csv" />--->
<!---<cfcontent type="text/plain" file="C:\inetpub\htdocs\test\wwwexport\CustomerSalesCSV-#TempUUID#.csv" />--->
	 <cfcontent type="text/plain" file="#CSVDirectory#CustomerSalesCSV-#TempUUID#.csv" />
	
	
		
</cfif>

<cfoutput>
<table width="950" border="0" align="center" cellpadding="3" cellspacing="1">
<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<td width="50%" valign="top">
		<table cellpadding="1" cellspacing="0" width="100%" border="0">
		<tr>
			<td colspan="2" valign="top" class="textmain" style="font-size:16px"><font color="0033CC">
				<b>Customer Sales Report</b></font>
			</td>
		</tr>
		<tr>
			<td class="textmain" width="30%"><b>Invoice Date Range:</b></td>
			<td class="textmain">#dateFormat(URL.BeginningDate, 'mm/dd/yyyy')# - #dateFormat(URL.EndingDate, 'mm/dd/yyyy')#</td>
		</tr>
		<tr>
			<td class="textmain"><b>Item Number(s):</b></td>
			<td class="textmain">
				#URL.BeginningItem#
				<cfif trim(URL.EndingItem) IS NOT "">
					- #URL.EndingItem#
				</cfif>
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
		<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Sales Rep</font></td>
		<td height="18" bgcolor="006633" class="productTitle" colspan="2"><font color="FFFFFF">Customer</font></td>
		<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Item</font></td>
		<td height="18" bgcolor="006633" class="productTitle" align="center"><font color="FFFFFF">Invoice<br>Number</font></td>
		<td height="18" bgcolor="006633" class="productTitle" align="center"><font color="FFFFFF">Invoice<br>Date</font></td>
		<td height="18" bgcolor="006633" class="productTitle" align="center"><font color="FFFFFF">Quantity</font></td>
		<td height="18" bgcolor="006633" class="productTitle" align="center"><font color="FFFFFF">Price</font></td>
		<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Serial<br>Numbers</font></td>
	</tr>

	<!--- LIST DATA --->	
	<cfif qrySalesReport.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="9" class="productTitle">
				<font color="FF0000">
					No records were found that match your selection criteria
				</font>
			</td>
		</tr>
	</cfif>
	
	<cfloop query="qrySalesReport">
		<tr  <cfif qrySalesReport.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
			<td class="textsmall" align="left" valign="top">#qrySalesReport.SalesRep#</td>
			<td class="textsmall" align="left" valign="top">#qrySalesReport.CUSTOMER#</td>
			<td class="textsmall" align="left" valign="top">
				<table cellpadding="0" cellspacing="0" width="100%" border="0">
					<tr><td class="textsmall" align="left">#trim(qrySalesReport.SHPNAME)#</td></tr>
					<cfif trim(qrySalesReport.SHPADDR1) IS NOT "">
						<tr><td class="textsmall" align="left">#qrySalesReport.SHPADDR1#</td></tr>
					</cfif>
					<cfif trim(qrySalesReport.SHPADDR2) IS NOT "">
						<tr><td class="textsmall" align="left">#qrySalesReport.SHPADDR2#</td></tr>
					</cfif>
					<cfif trim(qrySalesReport.SHPADDR3) IS NOT "">
						<tr><td class="textsmall" align="left">#qrySalesReport.SHPADDR3#</td></tr>
					</cfif>
					<cfif trim(qrySalesReport.SHPADDR4) IS NOT "">
						<tr><td class="textsmall" align="left">#qrySalesReport.SHPADDR4#</td></tr>
					</cfif>
					<tr><td class="textsmall" align="left">#qrySalesReport.SHPCITY#, #qrySalesReport.SHPSTATE# #qrySalesReport.SHPZIP#</td></tr>
				</table>
			</td>
			<td class="textsmall" align="left" valign="top">#trim(qrySalesReport.ITEM)#</td>
			<td class="textsmall" align="center" valign="top">#qrySalesReport.INVNUMBER#</td>
			<td class="textsmall" align="center" valign="top">#objSerialsShipments.formatDate(qrySalesReport.INVDATE)#</td>
			<td class="textsmall" align="center" valign="top">#int(qrySalesReport.QTYSHIPPED)#</td>
			<td class="textsmall" align="center" valign="top">#dollarFormat(qrySalesReport.UNITPRICE)#</td>
			<td class="textsmall" align="left" valign="top">
				<table cellpadding="0" cellspacing="0" width="100%" border="0">
					<cfloop list="#qrySalesReport.SerialNumbers#" index="ThisSerialNumber">
						<tr>
							<td class="textsmall" align="left" valign="top">#ThisSerialNumber#</td>
						</tr>
					</cfloop>
				</table>
			</td>	
		</tr>
	</cfloop>

	</table>
</td>
</tr>

</table>
</cfoutput>