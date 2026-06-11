<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	07/18/2007
	Function: 		Delete a batch 2 item
	Template:		delSoftwareExclude.cfm
	Task:			serials_admin_SW_delete
--->
<cfset objSoftwareExclude = createObject("component", "admin.assets.cfcs.SoftwareExclude")>

<cfset objSoftwareExclude.deleteRecord(URL.SoftwareExcludeID)>

<cfset objSoftwareExclude.setMessage("The record has been successfully deleted.")>

<cflocation url="index.cfm?task=serials_admin_SW_list">