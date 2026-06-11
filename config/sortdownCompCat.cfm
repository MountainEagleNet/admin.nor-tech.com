<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/30/2006
	Function: 		This page sorts the component category down
	Template:		sortdownCompCat.cfm
	Task:			config_setup_compcats_sortdown
--->
<cfset objComponentCategories = createObject("component", "admin.assets.cfcs.config.ComponentCategories")>

<cfset objComponentCategories.sortDown(URL.ComponentCategoryID)>

<cfset objComponentCategories.setMessage("The Component Category list has been successfully re-sorted")>

<cflocation url="index.cfm?task=config_setup_compcats_list">