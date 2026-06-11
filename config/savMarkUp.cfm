<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/12/2006
	Function: 		This page saves the markup percentages and fixed prices
	Template:		savMarkUp.cfm
	Task:			config_setup_markup_save
--->
<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>
<cfset objConfigComponents = createObject("component", "admin.assets.cfcs.config.ConfigComponents")>
<cfset stFormCopy = duplicate(FORM)>

<cfif objConfigSystems.isMaintainedByDefault(stFormCopy.ConfigSystemID)>
    <cflocation url="index.cfm?task=config_setup_price_edit&ConfigSystemID=#urlEncodedFormat(stFormCopy.ConfigSystemID)#">	
<cfelse>
	<!--- Validate: Make sure that a default is picked for each category, markups and fixed prices are decimals --->
    <cfset stErrors = objConfigComponents.validateMarkUp(stFormCopy)>
    
    <cfif structIsEmpty(stErrors)>

        <!--- Save markup percentages, fixed prices, default selections --->
        <cfset objConfigComponents.saveMarkups(stFormCopy)>
<!---    
        <!--- If this is a default system, make all of these adjustments to sales rep systems that are being maintained by this system --->
        <cfset objConfigSystems.maintainSalesRepSystems4(stFormCopy)>
--->

		<!--- If power supply automatically selected based on the case, select the appropirate power supply components, 
			  mark one of them as the default. --->
		<cfset objConfigComponents.savePowerSupplies(stFormCopy.ConfigSystemID)>
        
		<!--- Bug fix --->
        <cfset objConfigComponents.cleanUpPowerSupplyComponents(stFormCopy.ConfigSystemID)>


		<!--- If this system has Case as a category, and the default case has an image associated with in, then set this image as
			  the default image for the system --->
        <cfset objConfigComponents.setSystemImage(stFormCopy.ConfigSystemID)>

        <!--- If this is a default system, make all of these adjustments to sales rep systems that are being maintained by this system --->
        <cfset objConfigSystems.maintainSalesRepSystems4(stFormCopy)>

        
        <cfset objConfigComponents.setMessage("Default Component information has been saved.")>
        <cflocation url="index.cfm?task=config_setup_price_edit&ConfigSystemID=#urlEncodedFormat(stFormCopy.ConfigSystemID)#">	
    <cfelse>
        <cfset objConfigComponents.setDataRecord(stFormCopy)>
        <cfset objConfigComponents.setErrorRecord(stErrors)>
        <cfset objConfigComponents.setMessage("Please correct the fields indicated below.")>
        <cflocation url="index.cfm?task=config_setup_markup_edit&Validation=1">
    </cfif>
</cfif>    