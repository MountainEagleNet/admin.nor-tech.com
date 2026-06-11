<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/31/2007
	Function: 		Delete a part from the list
	Template:		delMiscParts.cfm
	Task:			misc_parts_delete
--->
<cfset objMiscParts = createObject("component", "admin.assets.cfcs.parts.MiscParts")>

<cfset objMiscParts.deleteRecord(URL.MiscPartID)>

<cfset objMiscParts.setMessage("The record has been successfully deleted.")>

<cflocation url="index.cfm?task=misc_parts_list">