<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/08/2006
	Function: 		This page saves the component categories for the system
	Template:		savConfigComponentCategories.cfm
	Task:			config_setup_categories_save
--->
<cfset objConfigComponentCategories = createObject("component", "admin.assets.cfcs.config.ConfigComponentCategories")>
<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>
<cfset objConfigComponents = createObject("component", "admin.assets.cfcs.config.ConfigComponents")>

<cfset stFormCopy = duplicate(FORM)>

<cfif objConfigSystems.isMaintainedByDefault(stFormCopy.ConfigSystemID)>
    <cflocation url="index.cfm?task=config_setup_categories_list&ConfigSystemID=#urlEncodedFormat(stFormCopy.ConfigSystemID)#&RequestTimeout=6000">
<cfelse>

	<!--- Assign Component Categories --->
    <cfset objConfigComponentCategories.assignCategories(stFormCopy)>

	<!--- Bug fix --->
    <cfset objConfigComponents.cleanUpPowerSupplyComponents(stFormCopy.ConfigSystemID)>
    
    <!--- If this is a default system, make all of these adjustments to sales rep systems that are being maintained by this system --->
    <cfset objConfigSystems.maintainSalesRepSystems2(stFormCopy)>
    
    <cfset qryConfigComponentCategories = objConfigComponentCategories.listRecordsForParent("ConfigSystemID", stFormCopy.ConfigSystemID)>
    <cfif qryConfigComponentCategories.RecordCount EQ 0>
        <cfset objConfigComponentCategories.setMessage("Please pick at least one component category for this system.")>
        <cflocation url="index.cfm?task=config_setup_categories_edit&ConfigSystemID=#urlEncodedFormat(stFormCopy.ConfigSystemID)#">
    </cfif>

	<!--- If editing an existing system, go to the list of categories --->
    <cfset isNewSystem = objConfigComponentCategories.getSessionValue("NewSystem")>
    
    <cfif isNewSystem>
        <!--- Get the first category, go to component selection page for that category --->
        <cfset ConfigComponentCategoryID = objConfigComponentCategories.getNextCategory(stFormCopy.ConfigSystemID, 0)>
        <cfset objConfigComponentCategories.setMessage("Component categories have been saved.  Please pick components for the first category.")>
        <cflocation url="index.cfm?task=config_setup_components_edit&ConfigSystemID=#urlEncodedFormat(stFormCopy.ConfigSystemID)#&ConfigComponentCategoryID=#urlEncodedFormat(ConfigComponentCategoryID)#&RequestTimeout=6000">
    <cfelse>
        <cfset objConfigComponentCategories.setMessage("Component categories have been saved.")>
        <cflocation url="index.cfm?task=config_setup_categories_list&ConfigSystemID=#urlEncodedFormat(stFormCopy.ConfigSystemID)#&RequestTimeout=6000">
    </cfif>
</cfif>    