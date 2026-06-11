<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/18/2007
	Function: 		Import Components from ACCPAC, Action Page
					
	Template:		actImportComponents.cfm
	Task:			config_pricelists_import_components
--->
<cfset objPriceLists = createObject("component", "admin.assets.cfcs.prices.PriceLists")>

<cfset stFormCopy = duplicate(FORM)>


<!--- VALIDATION: Make sure ITEMNO isn't blank --->
<cfset stErrors = objPriceLists.validate_importComponents(stFormCopy)>

<cfif NOT structIsEmpty(stErrors)>
	<cfset objPriceLists.setDataRecord(stFormCopy)>
	<cfset objPriceLists.setErrorRecord(stErrors)>
	<cfset objPriceLists.setMessage("Please correct the fields indicated below.")>
	<cflocation url="index.cfm?task=config_pricelists_import_edit&Validation=1">
</cfif>

<cfset ImportCount = objPriceLists.importComponents(stFormCopy.ITEMNO)>

<cflocation url="index.cfm?task=config_pricelists_import_view&ImportCount=#ImportCount#">