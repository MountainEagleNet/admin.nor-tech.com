<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	07/18/2007
	Function: 		This page saves a batch 2 item
	Template:		savSoftwareExclude.cfm
	Task:			serials_admin_SW_save
--->
<cfset objSoftwareExclude = createObject("component", "admin.assets.cfcs.SoftwareExclude")>

<cfset stFormCopy = duplicate(Form)>

<!--- SAVE --->
<cfset objSoftwareExclude.addAdminItems(stFormCopy)>

<cflocation url="index.cfm?task=serials_admin_SW_list">