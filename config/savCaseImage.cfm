<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	09/27/2010
	Function: 		This page saves the case images
	Template:		savCaseImage.cfm
	Task:			config_setup_components_caseimage_save
--->
<cfset objConfigComponents = createObject("component", "admin.assets.cfcs.config.ConfigComponents")>
<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>
<cfset objConfigComponentCategories = createObject("component", "admin.assets.cfcs.config.ConfigComponentCategories")>

<cfset stFormCopy = duplicate(FORM)>

<!--- VALIDATE AND SAVE --->
<cfset stErrors = objConfigComponents.validateCaseImages(stFormCopy)>

<cfif structIsEmpty(stErrors)>

	<cfset objConfigComponents.saveCaseimages(stFormCopy)>

	<!--- If this is a default system, make all of these adjustments to sales rep systems that are being maintained by this system --->
	<cfset objConfigSystems.maintainSalesRepSystems3b(stFormCopy)>
	
	<cfset objConfigComponents.setMessage("Case Images have been saved.")>

	<!--- EDITING AN EXISTING SYSTEM: go back to the lstComponentCategories page --->
	<cfif objConfigComponents.getSessionValue("NewSystem") NEQ 1>
		<cflocation url="index.cfm?task=config_setup_categories_list&ConfigSystemID=#urlEncodedFormat(stFormCopy.ConfigSystemID)#&RequestTimeout=6000">
	</cfif>

	<cfset strConfigComponentCategory = objConfigComponentCategories.getRecord(stFormCopy.ConfigComponentCategoryID)>
	
	<!--- CREATING A NEW SYSTEM --->
	<cfset ConfigComponentCategoryID = objConfigComponentCategories.getNextCategory(stFormCopy.ConfigSystemID, strConfigComponentCategory.CategorySortOrder)>
	<cfif ConfigComponentCategoryID IS NOT "">
		<!--- Loop back to Component page for the next category --->
		<cfset objConfigComponents.setMessage("Case Images have been saved.  Please pick components for the next category.")>
		
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
	<cflocation url="index.cfm?task=config_setup_components_caseimage_edit&Validation=1">
</cfif>