<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/09/2006
	Function: 		This page sorts the system down
	Template:		sortdownSystem.cfm
	Task:			config_setup_systems_sortdown
--->
<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>

<cfset objConfigSystems.sortDownSystem(URL.ConfigSystemID,URL.SystemType)>

<cfset objConfigSystems.setMessage("The System list has been successfully re-sorted")>

<cflocation url="index.cfm?task=config_setup_systems_sort&SystemType=#URL.SystemType#">