<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/01/2006
	Function: 		This page saves the system
	Template:		savSystem.cfm
	Task:			config_setup_systems_save
--->
<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>
<cfset objConfigComponents = createObject("component", "admin.assets.cfcs.config.ConfigComponents")>

<cfset stFormCopy = duplicate(FORM)>

<cfparam name="stFormCopy.Type" default="">
<cfparam name="stFormCopy.ConfigPhotoID" default="">
<cfparam name="stFormCopy.EnergystarApproved" default="">
<cfparam name="stFormCopy.PowerSupplyAutoSelect" default="">
<!---<cfset objConfigSystems.setSessionValue("CopySystem", 0)>--->


<!--- DELETE --->
<cfif isDefined("stFormCopy.ButtonClicked") AND stFormCopy.ButtonClicked IS "Delete">
	<cflocation url="index.cfm?task=config_setup_systems_delete&ConfigSystemID=#urlEncodedFormat(stFormCopy.ConfigSystemID)#">

<!--- COPY --->
<cfelseif isDefined("stFormCopy.ButtonClicked") AND stFormCopy.ButtonClicked IS "Copy System">
<!---<cfset objConfigSystems.setSessionValue("CopySystem", 1)>--->
	<cflocation url="index.cfm?task=config_setup_systems_copy&ConfigSystemID=#urlEncodedFormat(stFormCopy.ConfigSystemID)#">

<!--- VALIDATE AND SAVE --->
<cfelse>

	<!--- MAINTAINED BY DEFAULT SYSTEM --->
	<cfif objConfigSystems.isMaintainedByDefault(stFormCopy.ConfigSystemID)>
    	<cfset objConfigSystems.saveSalesRepDefaultCase(stFormCopy)>
        
        <cfset objConfigComponents.setSystemImage(stFormCopy.ConfigSystemID, 1)>	<!--- 1=ThisIsTheSalesRep --->

        <!--- If this is a server, go to page to select Server Options --->
        <cfif stFormCopy.Type IS "server">
            <cflocation url="index.cfm?task=config_setup_serveroptions_edit&ConfigSystemID=#urlEncodedFormat(stFormCopy.ConfigSystemID)#">
        <cfelse>
            <cflocation url="index.cfm?task=config_setup_categories_edit&ConfigSystemID=#urlEncodedFormat(stFormCopy.ConfigSystemID)#">
        </cfif>
            
            
    <cfelse>
		<cfset stErrors = objConfigSystems.validateRecord(stFormCopy)>
        
        <cfif structIsEmpty(stErrors)>
            <cfset ConfigSystemID = objConfigSystems.saveRecord(stFormCopy)>
            
            <!--- If this is a default system, make all of these adjustments to sales rep systems that are being maintained by this system --->
            <cfset objConfigSystems.maintainSalesRepSystems1(ConfigSystemID)>

			<!--- If this is a server, go to page to select Server Options --->
            <cfif stFormCopy.Type IS "server">
				<cfset objConfigSystems.setMessage("The system has been saved.  Please select Server Options.")>
                <cflocation url="index.cfm?task=config_setup_serveroptions_edit&ConfigSystemID=#urlEncodedFormat(ConfigSystemID)#">
            <cfelse>
				<cfset objConfigSystems.setMessage("The system has been saved.  Please assign component categories.")>
                <cflocation url="index.cfm?task=config_setup_categories_edit&ConfigSystemID=#urlEncodedFormat(ConfigSystemID)#">
            </cfif>
            
            
        <cfelse>
            <cfset objConfigSystems.setDataRecord(stFormCopy)>
            <cfset objConfigSystems.setErrorRecord(stErrors)>
            <cfset objConfigSystems.setMessage("Please correct the fields indicated below.")>
            <cflocation url="index.cfm?task=config_setup_systems_edit&Validation=1">
        </cfif>
	</cfif>
</cfif>	