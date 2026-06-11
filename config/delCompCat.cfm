<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/30/2006
	Function: 		Delete a component category
	Template:		delCompCat.cfm
	Task:			config_setup_compcats_delete
--->
<cfset objComponentCategories = createObject("component", "admin.assets.cfcs.config.ComponentCategories")>
<cfset objConfigComponentCategories = createObject("component", "admin.assets.cfcs.config.ConfigComponentCategories")>

<!--- Make sure that the component category is not assigned to any systems --->
<cfset qryConfigComponentCategories = objConfigComponentCategories.listRecordsForParent("ComponentCategoryID", URL.ComponentCategoryID)>
<cfif qryConfigComponentCategories.RecordCount GT 0>
	<cfset objComponentCategories.setMessage("This category cannot be deleted because it is already assigned to one or more systems.  It must be removed from all systems before it can be deleted.")>
	<cflocation url="index.cfm?task=config_setup_compcats_edit&ComponentCategoryID=#urlEncodedFormat(URL.ComponentCategoryID)#">
</cfif>

<cfset objComponentCategories.deleteRecord(URL.ComponentCategoryID)>

<cfset objComponentCategories.setMessage("The record has been successfully deleted.")>

<cflocation url="index.cfm?task=config_setup_compcats_list">