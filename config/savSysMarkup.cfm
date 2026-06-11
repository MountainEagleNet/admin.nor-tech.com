<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/26/2006
	Function: 		This page saves Default Markup Percentages
	Template:		savSysMarkup.cfm
	Task:			config_setup_sysmarkup_save
--->
<cfset objsalesrep = createObject("component", "admin.assets.cfcs.SalesRep")>
<cfset stFormCopy = duplicate(FORM)>

<cfset stErrors = objsalesrep.validateMarkupPercentages(stFormCopy)>

<cfif structIsEmpty(stErrors)>
	<cfset objsalesrep.updateMarkupPercentages(stFormCopy)>
	<cfset objsalesrep.setMessage("Default markup percentages were successfully saved.")>
	<cflocation url="index.cfm?task=config_setup_sysmarkup_edit">
<cfelse>
	<cfset objsalesrep.setDataRecord(stFormCopy)>
	<cfset objsalesrep.setErrorRecord(stErrors)>
	<cfset objsalesrep.setMessage("Please correct the fields indicated below.")>
	<cflocation url="index.cfm?task=config_setup_sysmarkup_edit&Validation=1">
</cfif>