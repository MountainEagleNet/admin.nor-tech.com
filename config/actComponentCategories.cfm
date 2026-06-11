<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/16/2007
	Function: 		This page saves the component categories for the system
	Template:		actComponentCategories.cfm
	Task:			config_setup_categories_list_act
--->

<cfset objConfigComponentCategories = createObject("component", "admin.assets.cfcs.config.ConfigComponentCategories")>
<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>

<cfset stFormCopy = duplicate(FORM)>

<cfif NOT objConfigSystems.isMaintainedByDefault(stFormCopy.ConfigSystemID)>
	<cfset objConfigComponentCategories.setMessage("Please pick default components.")>
</cfif>    
<cflocation url="index.cfm?task=config_setup_markup_edit&ConfigSystemID=#urlEncodedFormat(stFormCopy.ConfigSystemID)#">