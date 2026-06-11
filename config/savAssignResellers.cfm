<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/19/2006
	Function: 		This page assigns the sales rep's resellers to the system
	Template:		savAssignResellers.cfm
	Task:			config_setup_resellers_save
--->
<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>
<cfset objComponentPrices = createObject("component", "admin.assets.cfcs.config.ComponentPrices")>
<!---
<cfset objConfigComponents = createObject("component", "admin.assets.cfcs.config.ConfigComponents")>
--->
<cfset stFormCopy = duplicate(FORM)>

<cfparam name="stFormCopy.AssignAllResellers" default="">

<!--- VALIDATE --->
<!---
<cfset stErrors = objConfigSystems.validateAssignResellers(stFormCopy)>
<cfif NOT structIsEmpty(stErrors)>
	<cfset objConfigSystems.setDataRecord(stFormCopy)>
	<cfset objConfigSystems.setErrorRecord(stErrors)>
	<cfset objConfigSystems.setMessage("Please correct the fields indicated below.")>
	<cflocation url="index.cfm?task=config_setup_resellers_edit&Validation=1">
--->	
<!--- SAVE --->
<!---<cfelse>--->
	<cfif stFormCopy.AssignAllResellers IS "All">
		<cfset objConfigSystems.assignResellers(stFormCopy.ConfigSystemID)>
		<cfset objConfigSystems.setMessage("Resellers have been assigned.")>
	<cfelseif stFormCopy.AssignAllResellers IS "None">
		<cfset objConfigSystems.removeResellers(stFormCopy.ConfigSystemID)>
		<cfset objConfigSystems.setMessage("Resellers have been removed.")>
	<cfelse>
		<cfset objConfigSystems.assignCheckedResellers(stFormCopy)>
		<cfset objConfigSystems.setMessage("Resellers have been assigned as checked on the previous page.")>
	</cfif>
<!---
	<!--- Bug fix --->
    <cfset objConfigComponents.cleanUpPowerSupplyComponents(stFormCopy.ConfigSystemID)>
--->
    <!--- Create entries in tblComponentPrices for this System if this is a new system --->
    <cfif objConfigSystems.getSessionValue("newsystem") IS "1">
		<cfset objComponentPrices.createPricesForSystem(stFormCopy.ConfigSystemID)>
    </cfif>

	<cflocation url="index.cfm?task=config_setup_systems_list">
<!---</cfif>--->