<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	10/20/2006
	Function: 		Delete a bar code item
	Template:		delBarCode.cfm
	Task:			serials_admin_barcode_delete
--->
<cfset objPrintBarCodeItems = createObject("component", "admin.assets.cfcs.PrintBarCodeItems")>

<cfset objPrintBarCodeItems.deleteRecord(URL.PrintBarCodeItemID)>

<cfset objPrintBarCodeItems.setMessage("The record has been successfully deleted.")>

<cflocation url="index.cfm?task=serials_admin_barcode_list">