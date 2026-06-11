<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	12/31/2007
	Function: 		Delete a comp build item
	Template:		delCompBuild.cfm
	Task:			serials_admin_compbuild_delete
--->
<cfset objCompBuildItems = createObject("component", "admin.assets.cfcs.CompBuildItems")>

<cfset objCompBuildItems.deleteRecord(URL.CompBuildItemsID)>

<cfset objCompBuildItems.setMessage("The record has been successfully deleted.")>

<cflocation url="index.cfm?task=serials_admin_compbuild_list">