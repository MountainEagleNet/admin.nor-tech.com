<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/13/2007
	Function: 		This page saves a batch 2 item
	Template:		savBatch2.cfm
	Task:			serials_admin_batch2_save
--->
<cfset objSerialBatch2 = createObject("component", "admin.assets.cfcs.SerialBatch2")>

<cfset stFormCopy = duplicate(Form)>

<!--- SAVE --->
<cfset objSerialBatch2.addAdminItems(stFormCopy)>

<cflocation url="index.cfm?task=serials_admin_batch2_list">