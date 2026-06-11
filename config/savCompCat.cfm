<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/30/2006
	Function: 		This page saves the component category
	Template:		savCompCat.cfm
	Task:			config_setup_compcats_save
--->
<cfset objComponentCategories = createObject("component", "admin.assets.cfcs.config.ComponentCategories")>
<cfset stFormCopy = duplicate(FORM)>

<!--- DELETE --->
<cfif isDefined("stFormCopy.ButtonClicked") AND stFormCopy.ButtonClicked IS "Delete">
	<cflocation url="index.cfm?task=config_setup_compcats_delete&ComponentCategoryID=#urlEncodedFormat(stFormCopy.ComponentCategoryID)#">

<!--- VALIDATE AND SAVE --->
<cfelse>

	<cfset stErrors = objComponentCategories.validateRecord(stFormCopy)>
	
	<cfif structIsEmpty(stErrors)>
		<cfset objComponentCategories.saveRecord(stFormCopy)>
<!---
		<cfif stFormCopy.ComponentCategoryID IS "">
			<cfset objComponentCategories.renumberSortOrder()>
		</cfif>
--->
		<cfset objComponentCategories.setMessage("The component category was successfully saved.")>
		<cflocation url="index.cfm?task=config_setup_compcats_list">
	<cfelse>
		<cfset objComponentCategories.setDataRecord(stFormCopy)>
		<cfset objComponentCategories.setErrorRecord(stErrors)>
		<cfset objComponentCategories.setMessage("Please correct the fields indicated below.")>
		<cflocation url="index.cfm?task=config_setup_compcats_edit&Validation=1">
	</cfif>

</cfif>	