<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	10/27/2008
	Function: 		Delete Component - Action Page
	Template:		actBulkDelete.cfm
	Task:			config_setup_bulkdelete_act
--->
<cfset objConfigComponents = createObject("component", "admin.assets.cfcs.config.ConfigComponents")>

<cfset stFormCopy = duplicate(FORM)>


<!--- VALIDATE AND SAVE --->
<cfset stErrors = objConfigComponents.validateBulkDelete(stFormCopy)>

<cfif NOT structIsEmpty(stErrors)>
    <cfset objConfigComponents.setSessionValue("BulkComponent1", stFormCopy)>
    <cfset objConfigComponents.setErrorRecord(stErrors)>
    <cfset objConfigComponents.setMessage("Please correct the fields indicated below.")>
    <cflocation url="index.cfm?task=config_setup_bulkdelete_frm&Validation=1">
<cfelse>
    <cfset objConfigComponents.setSessionValue("BulkComponent1", stFormCopy)>

    <cflocation url="index.cfm?task=config_setup_bulkdelete_frm2&RequestTimeout=6000">
</cfif>