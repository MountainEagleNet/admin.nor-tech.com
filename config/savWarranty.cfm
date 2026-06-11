<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	01/12/2010
	Function: 		This page saves the depot warranties for the system
	Template:		savWarranty.cfm
	Task:			config_setup_warranty_save
--->
<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>
<cfset objConfigWarranty = createObject("component", "admin.assets.cfcs.config.ConfigWarranty")>
<cfset objConfigComponentCategories = createObject("component", "admin.assets.cfcs.config.ConfigComponentCategories")>
<cfset stFormCopy = duplicate(FORM)>


<cfif objConfigSystems.isMaintainedByDefault(stFormCopy.ConfigSystemID)>
    <cflocation url="index.cfm?task=config_setup_categories_list&ConfigSystemID=#urlEncodedFormat(stFormCopy.ConfigSystemID)#&RequestTimeout=6000">
<cfelse>
	<!--- Validate: Make sure at least one warranty is picked --->
    <cfset stErrors = objConfigWarranty.validateRecord(stFormCopy)>
    
    <cfif structIsEmpty(stErrors)>

        <!--- Assign Components --->
        <cfset objConfigWarranty.assignWarranty(stFormCopy)>

        <!--- If this is a default system, make all of these adjustments to sales rep systems that are being maintained by this system --->
        <cfset objConfigSystems.maintainSalesRepSystems3a(stFormCopy)>

        <cfset strConfigComponentCategory = objConfigComponentCategories.getRecord(stFormCopy.ConfigComponentCategoryID)>
        
        <!--- EDITING AN EXISTING SYSTEM: go back to the lstComponentCategories page --->
        <cfif objConfigComponentCategories.getSessionValue("NewSystem") NEQ 1>
            <cfset objConfigWarranty.setMessage("Depot Warranty options have been saved.")>
            <cflocation url="index.cfm?task=config_setup_categories_list&ConfigSystemID=#urlEncodedFormat(stFormCopy.ConfigSystemID)#&RequestTimeout=6000">
        </cfif>
        
        <!--- CREATING A NEW SYSTEM --->
        <cfset ConfigComponentCategoryID = objConfigComponentCategories.getNextCategory(stFormCopy.ConfigSystemID, strConfigComponentCategory.CategorySortOrder)>
        <cfif ConfigComponentCategoryID IS NOT "">
            <!--- Loop back to Component page for the next category --->
            <cfset objConfigWarranty.setMessage("Depot Warranty options have been saved.  Please pick components for the next category.")>
            <cflocation url="index.cfm?task=config_setup_components_edit&ConfigSystemID=#urlEncodedFormat(stFormCopy.ConfigSystemID)#&ConfigComponentCategoryID=#urlEncodedFormat(ConfigComponentCategoryID)#&RequestTimeout=6000">
        <cfelse>
            <!--- All Categories have been done, go to pricing page--->
            <cfset objConfigWarranty.setMessage("Please pick default components.")>
            <cflocation url="index.cfm?task=config_setup_markup_edit&ConfigSystemID=#urlEncodedFormat(stFormCopy.ConfigSystemID)#">	
        </cfif>
        
    <cfelse>
        <cfset objConfigWarranty.setDataRecord(stFormCopy)>
        <cfset objConfigWarranty.setErrorRecord(stErrors)>
        <cfset objConfigWarranty.setMessage("Please correct the fields indicated below.")>
        <cflocation url="index.cfm?task=config_setup_warranty_edit&Validation=1">
    </cfif>
</cfif>    