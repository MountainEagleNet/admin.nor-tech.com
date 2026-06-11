<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/31/2007
	Function: 		Delete a part from the list
	Template:		delPartsAdmin.cfm
	Task:			parts_admin_delete
--->
<cfset objPartsAdmin = createObject("component", "admin.assets.cfcs.parts.PartsAdmin")>

<cfset objPartsAdmin.deleteRecord(URL.PartsAdminID)>

<cfset objPartsAdmin.setMessage("The record has been successfully deleted.")>

<cflocation url="index.cfm?task=parts_admin_list">