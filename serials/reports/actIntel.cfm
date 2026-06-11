<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	07/15/2008
	Function: 		Customer Sales Report
	Template:		actIntel.cfm
	Task:			serials_reports_actIntel
--->
<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>

<cfset qrySalesReport = objSerialsShipments.intelSalesReport(URL.BeginningDate, URL.EndingDate, URL.BeginningItem1, URL.EndingItem1, URL.BeginningItem2, URL.EndingItem2, URL.BeginningItem3, URL.EndingItem3, URL.BeginningItem4, URL.EndingItem4)>

<!---
<cfdump var="#qrySalesReport#">
<cfabort>
--->

<!--- Export the report to a CSV file --->
<!---<cfset textHeader = "Invoice Date, Intel ID ##, Customer Name, Address Line 1, Address Line 2, Address Line 3, Address Line 4, City, State, Zip Code, Phone, Item ##, Quantity Sold#chr(10)#">--->
<cfset textHeader = "Customer Name, Account Number, Address Line 1, Address Line 2, City, State, Zip Code, Country, Item ##, Quantity Sold, Unit Sell Price, Currency, Unit Distributor Cost, Invoice Date, Invoice Number, Intel ID ##, Error Correction, Previous Report#chr(10)#">


<cfloop query="qrySalesReport">   
	<cfoutput>
<!---	<cfsavecontent variable="tmpHeader">"#objSerialsShipments.formatDate(qrySalesReport.INVDATE)#","#qrySalesReport.IntelIDNumber#","#left(trim(qrySalesReport.BILNAME), 35)#","#trim(qrySalesReport.BILADDR1)#","#trim(qrySalesReport.BILADDR2)#","#trim(qrySalesReport.BILADDR3)#","#trim(qrySalesReport.BILADDR4)#","#trim(qrySalesReport.BILCITY)#","#trim(qrySalesReport.BILSTATE)#","#trim(qrySalesReport.BILZIP)#","#trim(qrySalesReport.PhoneNumber)#","#trim(qrySalesReport.ITEM)#","#int(qrySalesReport.QTYSHIPPED)#"#chr(13)##chr(10)#</cfsavecontent>--->
		<cfsavecontent variable="tmpHeader">"#left(trim(qrySalesReport.BILNAME), 35)#","#trim(qrySalesReport.CUSTOMER)#","#trim(qrySalesReport.BILADDR1)#","#trim(qrySalesReport.BILADDR2)#","#trim(qrySalesReport.BILCITY)#","#trim(qrySalesReport.BILSTATE)#","#trim(qrySalesReport.BILZIP)#","US","#trim(qrySalesReport.ITEM)#","#int(qrySalesReport.QTYSHIPPED)#","#trim(qrySalesReport.UNITPRICE)#","USD","","#objSerialsShipments.formatDate(qrySalesReport.INVDATE)#","#trim(qrySalesReport.INVNUMBER)#","#qrySalesReport.IntelIDNumber#","",""#chr(13)##chr(10)#</cfsavecontent>
		<cfset textHeader = textHeader & tmpHeader>
	</cfoutput>
</cfloop>

<cfset TempUUID = createUUID()>

<!--- create the files --->
<cffile action="write" file="c:\wwwexport\IntelSalesCSV-#TempUUID#.csv" output="#textHeader#">

<cfheader name="Content-Disposition" value="attachment; filename=c:\wwwexport\IntelSalesCSV-#TempUUID#.csv" />
<cfcontent type="text/plain" file="c:\wwwexport\IntelSalesCSV-#TempUUID#.csv" />