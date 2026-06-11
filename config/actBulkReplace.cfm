<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	10/21/2008
	Function: 		Replace Component - Action Page
	Template:		actBulkReplace.cfm
	Task:			config_setup_bulkreplace_act
--->
<cfset objConfigComponents = createObject("component", "admin.assets.cfcs.config.ConfigComponents")>

<cfset stFormCopy = duplicate(FORM)>


<!--- VALIDATE AND SAVE --->
<cfset stErrors = objConfigComponents.validateBulkReplace(stFormCopy)>

<cfif NOT structIsEmpty(stErrors)>
    <cfset objConfigComponents.setSessionValue("BulkComponent1", stFormCopy)>
    <cfset objConfigComponents.setErrorRecord(stErrors)>
    <cfset objConfigComponents.setMessage("Please correct the fields indicated below.")>
    <cflocation url="index.cfm?task=config_setup_bulkreplace_frm&Validation=1">
<cfelse>
    <cfset objConfigComponents.setSessionValue("BulkComponent1", stFormCopy)>

    <cflocation url="index.cfm?task=config_setup_bulkreplace_frm2&RequestTimeout=6000">
</cfif>