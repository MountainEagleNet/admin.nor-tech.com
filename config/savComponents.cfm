<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/08/2006
	Function: 		This page saves the components for the system
	Template:		savComponents.cfm
	Task:			config_setup_components_save
--->
<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>
<cfset objConfigComponents = createObject("component", "admin.assets.cfcs.config.ConfigComponents")>
<cfset objConfigComponentCategories = createObject("component", "admin.assets.cfcs.config.ConfigComponentCategories")>
<cfset stFormCopy = duplicate(FORM)>


<cfif objConfigSystems.isMaintainedByDefault(stFormCopy.ConfigSystemID)>
    <cflocation url="index.cfm?task=config_setup_categories_list&ConfigSystemID=#urlEncodedFormat(stFormCopy.ConfigSystemID)#&RequestTimeout=6000">
<cfelse>
	<!--- Validate: Make sure at least one component is picked for each category --->
    <cfset stErrors = objConfigComponents.validateRecord(stFormCopy)>
    
    <cfif structIsEmpty(stErrors)>
    
        <!--- Assign Components --->
        <cfset objConfigComponents.assignComponents(stFormCopy)>
        
<!---        
        <!--- Bug fix --->
        <cfset objConfigComponents.cleanUpPowerSupplyComponents(stFormCopy.ConfigSystemID)>
--->        
        
        <!--- If this is a default system, make all of these adjustments to sales rep systems that are being maintained by this system --->
        <cfset objConfigSystems.maintainSalesRepSystems3(stFormCopy)>
    
        <cfset strConfigComponentCategory = objConfigComponentCategories.getRecord(stFormCopy.ConfigComponentCategoryID)>


		<!--- If this is a Case, go to the Case Image page --->
        <cfif trim(strConfigComponentCategory.Category) IS "CS">
            <cfset objConfigComponents.setMessage("Components have been saved for Category '#strConfigComponentCategory.CategoryName#'.")>
            <cflocation url="index.cfm?task=config_setup_components_caseimage_edit&ConfigSystemID=#urlEncodedFormat(stFormCopy.ConfigSystemID)#&ConfigComponentCategoryID=#urlEncodedFormat(ConfigComponentCategoryID)#&RequestTimeout=6000">
        </cfif>

        
        <!--- EDITING AN EXISTING SYSTEM: go back to the lstComponentCategories page --->
        <cfif objConfigComponentCategories.getSessionValue("NewSystem") NEQ 1>
            <cfset objConfigComponents.setMessage("Components have been saved for Category '#strConfigComponentCategory.CategoryName#'.")>
            <cflocation url="index.cfm?task=config_setup_categories_list&ConfigSystemID=#urlEncodedFormat(stFormCopy.ConfigSystemID)#&RequestTimeout=6000">
        </cfif>
        
        <!--- CREATING A NEW SYSTEM --->
        <cfset ConfigComponentCategoryID = objConfigComponentCategories.getNextCategory(stFormCopy.ConfigSystemID, strConfigComponentCategory.CategorySortOrder)>
        <cfif ConfigComponentCategoryID IS NOT "">
        
            <!--- Loop back to Component page for the next category --->
            <cfset objConfigComponents.setMessage("Components have been saved for Category '#strConfigComponentCategory.CategoryName#'.  Please pick components for the next category.")>
            <cflocation url="index.cfm?task=config_setup_components_edit&ConfigSystemID=#urlEncodedFormat(stFormCopy.ConfigSystemID)#&ConfigComponentCategoryID=#urlEncodedFormat(ConfigComponentCategoryID)#&RequestTimeout=6000">
        <cfelse>
            <!--- All Categories have been done, go to pricing page--->
            <cfset objConfigComponents.setMessage("Please pick default components.")>
            <cflocation url="index.cfm?task=config_setup_markup_edit&ConfigSystemID=#urlEncodedFormat(stFormCopy.ConfigSystemID)#">	
        </cfif>
        
    <cfelse>
        <cfset objConfigComponents.setDataRecord(stFormCopy)>
        <cfset objConfigComponents.setErrorRecord(stErrors)>
        <cfset objConfigComponents.setMessage("Please correct the fields indicated below.")>
        <cflocation url="index.cfm?task=config_setup_components_edit&Validation=1">
    </cfif>
</cfif>    