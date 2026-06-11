<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	10/20/2006
	Function: 		This page saves a print bar code item
	Template:		savBarCode.cfm
	Task:			serials_admin_barcode_save
--->
<cfset objPrintBarCodeItems = createObject("component", "admin.assets.cfcs.PrintBarCodeItems")>

<cfset stFormCopy = duplicate(Form)>

<!--- SAVE --->
<cfset objPrintBarCodeItems.addAdminItems(stFormCopy)>

<!---
<cfset strScannerBatchItem = objPrintBarCodeItems.newRecord()>
<cfset structInsert(strScannerBatchItem, "ITEMNO", URL.ITEMNO, True)>
<cfset structInsert(strScannerBatchItem, "ITEMDESC", URL.ITEMDESC, True)>
<cfset objPrintBarCodeItems.saveRecord(strScannerBatchItem)>
--->

<cflocation url="index.cfm?task=serials_admin_barcode_list">