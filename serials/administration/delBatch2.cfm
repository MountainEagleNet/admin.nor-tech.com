<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/13/2007
	Function: 		Delete a batch 2 item
	Template:		delBatch2.cfm
	Task:			serials_admin_batch2_delete
--->
<cfset objSerialBatch2 = createObject("component", "admin.assets.cfcs.SerialBatch2")>

<cfset objSerialBatch2.deleteRecord(URL.SerialBatch2ID)>

<cfset objSerialBatch2.setMessage("The record has been successfully deleted.")>

<cflocation url="index.cfm?task=serials_admin_batch2_list">