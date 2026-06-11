<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	12/31/2007
	Function: 		This page saves a comp build item
	Template:		savCompBuild.cfm
	Task:			serials_admin_compbuild_save
--->
<cfset objCompBuilditems = createObject("component", "admin.assets.cfcs.CompBuilditems")>

<cfset stFormCopy = duplicate(Form)>

<!--- SAVE --->
<cfset objCompBuilditems.addAdminItems(stFormCopy)>

<cflocation url="index.cfm?task=serials_admin_compbuild_list">