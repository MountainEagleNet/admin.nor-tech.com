<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/31/2007
	Function: 		This page saves the part
	Template:		savMiscParts.cfm
	Task:			misc_parts_save
--->
<cfset objMiscParts = createObject("component", "admin.assets.cfcs.parts.MiscParts")>
<cfset stFormCopy = duplicate(FORM)>

<!--- VALIDATE AND SAVE --->
<cfset stErrors = objMiscParts.validateRecord(stFormCopy)>

<cfif structIsEmpty(stErrors)>
	<cfset MiscPartID = objMiscParts.saveRecord(stFormCopy)>
	<cfset objMiscParts.setMessage("The part has been saved.")>
	<cflocation url="index.cfm?task=misc_parts_list">
<cfelse>
	<cfset objMiscParts.setDataRecord(stFormCopy)>
	<cfset objMiscParts.setErrorRecord(stErrors)>
	<cfset objMiscParts.setMessage("Please correct the fields indicated below.")>
	<cflocation url="index.cfm?task=misc_parts_edit&Validation=1">
</cfif>