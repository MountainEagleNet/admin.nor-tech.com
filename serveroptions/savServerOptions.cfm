<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/31/2007
	Function: 		This page saves the part
	Template:		savServerOptions.cfm
	Task:			server_options_save
--->
<cfset objServerOptions = createObject("component", "admin.assets.cfcs.config.ServerOptions")>
<cfset stFormCopy = duplicate(FORM)>

<!--- VALIDATE AND SAVE --->
<cfset stErrors = objServerOptions.validateRecord(stFormCopy)>

<cfif structIsEmpty(stErrors)>
	<cfset ServerOptionID = objServerOptions.saveRecord(stFormCopy)>
	<cfset objServerOptions.setMessage("The server option has been saved.")>
	<cflocation url="index.cfm?task=server_options_list">
<cfelse>
	<cfset objServerOptions.setDataRecord(stFormCopy)>
	<cfset objServerOptions.setErrorRecord(stErrors)>
	<cfset objServerOptions.setMessage("Please correct the fields indicated below.")>
	<cflocation url="index.cfm?task=server_options_edit&Validation=1">
</cfif>