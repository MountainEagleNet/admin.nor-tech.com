<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/07/2006
	Function: 		Delete a system
	Template:		delSystem.cfm
	Task:			config_setup_systems_delete
--->
<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>

<cfset ThisIsADefaultSystem = objConfigSystems.isDefaultSystem(URL.ConfigSystemID)>

<cfset objConfigSystems.deleteRecord(URL.ConfigSystemID)>

<cfif ThisIsADefaultSystem>
	<cfset objConfigSystems.deleteMaintainSystemDefault(URL.ConfigSystemID)>
</cfif>

<cfset objConfigSystems.setMessage("The system has been successfully deleted.")>

<cfif objConfigSystems.getSessionValue("DefaultSystems")>
	<cflocation url="index.cfm?task=config_setup_systems_list&DefaultSystems=1">
<cfelse>
	<cflocation url="index.cfm?task=config_setup_systems_list">
</cfif>