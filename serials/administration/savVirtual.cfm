<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	11/02/2006
	Function: 		This page saves a virtual item
	Template:		savVirtual.cfm
	Task:			serials_admin_virtual_save
--->
<cfset objVirtualItems = createObject("component", "admin.assets.cfcs.VirtualItems")>

<cfset stFormCopy = duplicate(Form)>

<!--- SAVE --->
<cfset objVirtualItems.addAdminItems(stFormCopy)>

<cflocation url="index.cfm?task=serials_admin_virtual_list">