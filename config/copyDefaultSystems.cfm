<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	09/14/2006
	Function: 		This page imports the selected default systems to the sales rep's systems
	Template:		copyDefaultSystems.cfm
	Task:			config_setup_defaultsystems_copy
--->
<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>
<cfset stFormCopy = duplicate(FORM)>

<!--- Import Systems --->
<cfset ImportedAtLeastOne = objConfigSystems.importSystems(stFormCopy)>
<cfif ImportedAtLeastOne>
	<cfset objConfigSystems.setMessage("Default Systems have been successfully imported and assigned to all of your resellers.")>
<cfelse>
	<cfset objConfigSystems.setMessage("No boxes were checked, so no Default Systems were imported.")>
</cfif>
<cflocation url="index.cfm?task=config_setup_systems_list&DefaultSystems=0">	