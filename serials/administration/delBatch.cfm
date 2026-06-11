<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/21/2006
	Function: 		Delete a batch number item
	Template:		delBatch.cfm
	Task:			serials_admin_batch_delete
--->
<cfset objScannerBatchItems = createObject("component", "admin.assets.cfcs.ScannerBatchItems")>

<cfset objScannerBatchItems.deleteRecord(URL.ScannerBatchItemID)>

<cfset objScannerBatchItems.setMessage("The record has been successfully deleted.")>

<cflocation url="index.cfm?task=serials_admin_batch_list">