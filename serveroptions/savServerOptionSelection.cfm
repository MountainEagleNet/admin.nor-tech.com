<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/31/2007
	Function: 		This page saves the part
	Template:		savServerOptionSelection.cfm
--->
<cfset objServerOptionSelections = createObject("component", "admin.assets.cfcs.config.ServerOptionSelections")>
<cfset stFormCopy = duplicate(FORM)>

<!--- VALIDATE AND SAVE --->
<cfset stErrors = objServerOptionSelections.validateRecord(stFormCopy)>

<cfif structIsEmpty(stErrors)>
	<cfset ServerOptionSelectionID = objServerOptionSelections.saveRecord(stFormCopy)>
	<cfset objServerOptionSelections.sortSelections(stFormCopy.ServerOptionID)>    
	<cfset objServerOptionSelections.setMessage("The server option selection has been saved.")>
	<cflocation url="index.cfm?task=server_options_edit&ServerOptionID=#urlEncodedFormat(stFormCopy.ServerOptionID)#">
<cfelse>
	<cfset objServerOptionSelections.setDataRecord(stFormCopy)>
	<cfset objServerOptionSelections.setErrorRecord(stErrors)>
	<cfset objServerOptionSelections.setMessage("Please correct the fields indicated below.")>
	<cflocation url="index.cfm?task=server_options_selections_edit&Validation=1">
</cfif>