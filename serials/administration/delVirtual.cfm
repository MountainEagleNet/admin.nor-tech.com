<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	11/02/2006
	Function: 		Delete a virtual item
	Template:		delVirtual.cfm
	Task:			serials_admin_virtual_delete
--->
<cfset objVirtualItems = createObject("component", "admin.assets.cfcs.VirtualItems")>

<cfset objVirtualItems.deleteRecord(URL.VirtualItemID)>

<cfset objVirtualItems.setMessage("The record has been successfully deleted.")>

<cflocation url="index.cfm?task=serials_admin_virtual_list">