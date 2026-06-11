<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/21/2006
	Function: 		This page saves a batch number item
	Template:		savBatch.cfm
	Task:			serials_admin_batch_save
--->
<cfset objScannerBatchItems = createObject("component", "admin.assets.cfcs.ScannerBatchItems")>

<cfset stFormCopy = duplicate(Form)>

<!--- SAVE --->
<cfset objScannerBatchItems.addAdminItems(stFormCopy)>

<!---
<cfset strScannerBatchItem = objScannerBatchItems.newRecord()>
<cfset structInsert(strScannerBatchItem, "ITEMNO", URL.ITEMNO, True)>
<cfset structInsert(strScannerBatchItem, "ITEMDESC", URL.ITEMDESC, True)>
<cfset objScannerBatchItems.saveRecord(strScannerBatchItem)>
--->

<cflocation url="index.cfm?task=serials_admin_batch_list">