<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	09/20/2006
	Function: 		This page creates default systems out of the selected sales reps' systems
	Template:		copySalesRepSystems.cfm
	Task:			config_setup_salesrepsystems_copy
--->
<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>
<cfset stFormCopy = duplicate(FORM)>

<!--- Import Systems --->
<cfset ImportedAtLeastOne = objConfigSystems.importSalesRepSystems(stFormCopy)>
<cfif ImportedAtLeastOne>
	<cfset objConfigSystems.setMessage("Sales Rep Systems have been successfully imported.")>
<cfelse>
	<cfset objConfigSystems.setMessage("No boxes were checked, so no Sales Rep Systems were imported.")>
</cfif>
<cflocation url="index.cfm?task=config_setup_systems_list&DefaultSystems=1">	