<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/07/2006
	Function: 		This page copies a system
	Template:		copySystem.cfm
	Task:			config_setup_systems_copy
--->
<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>

<!--- Copy Default Systems --->
<cfif isDefined("URL.CopyDefaultSystems") AND URL.CopyDefaultSystems EQ 1>
	<cfset objConfigSystems.copyDefaultSystems()>
	<cfset objConfigSystems.setSessionValue("CopySystem", 0)>
	<cflocation url="index.cfm?task=config_setup_systems_list">

<!--- Copy Individual System --->
<cfelse>
	<!--- Make copy of tblConfigSystems --->
	<cfset NewConfigSystemID = objConfigSystems.copyConfigSystem(URL.ConfigSystemID)>
	<cfset objConfigSystems.setSessionValue("CopySystem", 1)>
    
    <cfif objConfigSystems.isMaintainedByDefault(NewConfigSystemID)>
		<cfset objConfigSystems.setMessage("The copy has been made and saved to the database.  You are now viewing the copy.")>
    <cfelse>
		<cfset objConfigSystems.setMessage("The copy has been made and saved to the database.  You are now editing the copy.")>
    </cfif>
    
	<cflocation url="index.cfm?task=config_setup_systems_edit&ConfigSystemID=#urlEncodedFormat(NewConfigSystemID)#">
</cfif>

