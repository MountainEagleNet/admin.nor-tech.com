<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/09/2007
	Function: 		This page validates the information
	Template:		actCreate.cfm
	Task:			serials_admin_create_act
--->
<cfset objSerialsAdministration = createObject("component", "admin.assets.cfcs.SerialsAdministration")>

<cfset stFormCopy = duplicate(FORM)>
<!---
<cfdump var="#stFormCopy#">
<cfabort>
--->
<cfset stErrors = objSerialsAdministration.validateCreateRecord(stFormCopy)>

<cfif NOT structIsEmpty(stErrors)>
	<cfset objSerialsAdministration.setDataRecord(stFormCopy)>
	<cfset objSerialsAdministration.setErrorRecord(stErrors)>
	<cfset objSerialsAdministration.setMessage("Please correct the fields indicated below.")>
	<cflocation url="index.cfm?task=serials_admin_create_enter&Validation=1">
<cfelse>

	<!--- Create the Serial Numbers, Print Bar Code Labels --->
	<cfset Success = objSerialsAdministration.createAndPrintBarCodes(stFormCopy)>
	<cfif Success>
		<cfset objSerialsAdministration.setMessage("Serial Numbers were created and bar code labels were printed successfully.")>
	<cfelse>
		<cfset objSerialsAdministration.setMessage("Serial Numbers were created, but there was a problem with the printing process; bar code labels were NOT printed.")>
	</cfif>
	
	<!--- Go to Display Page --->
	<cfset objSerialsAdministration.setDataRecord(stFormCopy)>
	<cflocation url="index.cfm?task=serials_admin_create_view">
</cfif>