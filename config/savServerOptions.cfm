<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/29/2012
	Function: 		This page saves the server option selections
	Template:		savMarkUp.cfm
	Task:			config_setup_markup_save
--->
<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>
<cfset objServerOptionSelections = createObject("component", "admin.assets.cfcs.config.ServerOptionSelections")>
<cfset objServerSelectionsSystems = createObject("component", "admin.assets.cfcs.config.ServerSelectionsSystems")>

<cfset stFormCopy = duplicate(FORM)>
<!---
stFormCopy:<cfdump var="#stFormCopy#">
--->
<cfif objConfigSystems.isMaintainedByDefault(stFormCopy.ConfigSystemID)>
    <cflocation url="index.cfm?task=config_setup_categories_edit&ConfigSystemID=#urlEncodedFormat(stFormCopy.ConfigSystemID)#">	
<cfelse>
	<!--- Validate: Make sure that a selection is made for each server option --->
    <cfset stErrors = objServerOptionSelections.validateServerOptions(stFormCopy)>

    
    <cfif structIsEmpty(stErrors)>

        <!--- Save Server Option selections --->
        <cfset objServerSelectionsSystems.saveSelections(stFormCopy)>
        
        <!--- If this is a default system, make all of these adjustments to sales rep systems that are being maintained by this system --->
        <cfset objConfigSystems.maintainSalesRepSystems1a(stFormCopy.ConfigSystemID)>
        
        <cfset objServerOptionSelections.setMessage("Server Option Selections have been saved.  Please assign component categories.")>
        <cflocation url="index.cfm?task=config_setup_categories_edit&ConfigSystemID=#urlEncodedFormat(stFormCopy.ConfigSystemID)#">	
    <cfelse>
        <cfset objServerOptionSelections.setDataRecord(stFormCopy)>
        <cfset objServerOptionSelections.setErrorRecord(stErrors)>
        <cfset objServerOptionSelections.setMessage("Please correct the fields indicated below.")>
        <cflocation url="index.cfm?task=config_setup_serveroptions_edit&Validation=1">
    </cfif>
</cfif>    