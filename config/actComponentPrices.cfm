<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/05/2010
	Template:		actComponentPrices.cfm
--->
<cfset objComponentPrices = createObject("component", "admin.assets.cfcs.config.ComponentPrices")>

<cfif isDefined("URL.ConfigSystemID") AND URL.ConfigSystemID IS NOT "">
	<cfset objComponentPrices.createPricesForSystem(URL.ConfigSystemID)>
    
	<cfset objComponentPrices.setMessage("Component Prices were calculated and saved for this system.")>
</cfif>

<cflocation url="../index.cfm?task=config_setup_systems_edit&ConfigSystemID=#urlEncodedFormat(URL.ConfigSystemID)#&RequestTimeout=6000">