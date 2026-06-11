<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/12/2009
	Function: 		This page saves the Classification
	Template:		savClassifications.cfm
	Task:			classifications_save
--->
<cfset objClassifications = createObject("component", "admin.assets.cfcs.config.Classifications")>
<cfset stFormCopy = duplicate(FORM)>


<cfparam name="stFormCopy.Type" default="">
<cfparam name="stFormCopy.DefaultClassification" default="0">


<!--- DELETE --->
<cfif isDefined("stFormCopy.ButtonClicked") AND stFormCopy.ButtonClicked IS "Delete">

	<!--- See if this classification is assigned to any systems --->
    <cfif objClassifications.isAssigned(stFormCopy.ClassificationID)>
		<cfset objClassifications.setMessage("You're trying to delete this classification, but it's assigned to one or more systems.")>
		<cfset stErrors = structNew()>
		<cfset objClassifications.setDataRecord(stFormCopy)>
		<cfset objClassifications.setErrorRecord(stErrors)>
		<cflocation url="index.cfm?task=classifications_edit&Validation=1">

	<cfelse>
    
    	<!--- Delete it --->
		<cfset objClassifications.deleteClassification(stFormCopy.ClassificationID)>

    </cfif>
</cfif>


<!--- VALIDATE AND SAVE --->
<cfset stErrors = objClassifications.validateRecord(stFormCopy)>


<cfif structIsEmpty(stErrors)>
	<cfset ClassificationID = objClassifications.saveRecord(stFormCopy)>
	<cfset objClassifications.setMessage("The classification has been saved.")>
	<cflocation url="index.cfm?task=classifications_list">
<cfelse>
	<cfset objClassifications.setDataRecord(stFormCopy)>
	<cfset objClassifications.setErrorRecord(stErrors)>
	<cfset objClassifications.setMessage("Please correct the fields indicated below.")>
	<cflocation url="index.cfm?task=classifications_edit&Validation=1">
</cfif>