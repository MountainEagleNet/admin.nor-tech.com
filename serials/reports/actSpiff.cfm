<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	03/06/2008
	Function: 		Close-Out Specials (Spiff) Report - Action page
	Template:		actSpiff.cfm
	Task:			serials_reports_actSpiff
--->
<cfsetting requesttimeout="6000">

<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>
<cfset stFormCopy = duplicate(FORM)>

<cfset stErrors = objSerialsShipments.validate_Spiff(stFormCopy)>

<cfif NOT structIsEmpty(stErrors)>
	<cfset objSerialsShipments.setDataRecord(stFormCopy)>
	<cfset objSerialsShipments.setErrorRecord(stErrors)>
	<cfset objSerialsShipments.setMessage("Please correct the fields indicated below.")>
	<cflocation url="index.cfm?task=serials_reports_frmSpiff&Validation=1">
<cfelse>
	<cfset objSerialsShipments.emailSpiffReport(stFormCopy)>
	<cfset objSerialsShipments.setMessage("The report was sent succesfully to '#stFormCopy.EmailAddress#'")>
	<cflocation url="index.cfm?task=serials_reports_frmSpiff">
</cfif>