<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/01/2010
	Function: 		Update the configurator system component selling prices 
	Template:		actUpdateComponentPrices.cfm
	Task:			NONE.  This is executed from an automated process set up in the ColdFusion Administrator
	
	Scheduled Task:	http://www.nor-tech.com/actUpdateComponentPrices.cfm?RequestTimeout=18000	
--->
<cfsetting requesttimeout="36000">

<cfset VARIABLES.AdminLocation = "admin">
<cfset This.DataSourceName = "NorTechWWW">


<!---
<cfset VARIABLES.AdminLocation = "adminTEST">
<cfset This.DataSourceName = "NorTechWWWTEST">
--->


<cfset objComponentPrices = createObject("component", "admin.assets.cfcs.config.ComponentPrices")>
<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>


<cfquery datasource="#This.DataSourceName#" name="qryPricesStart">
SELECT 	ComponentPriceID
FROM    tblComponentPrices
</cfquery>	
<cfmail from=	"info@nor-tech.com"		
        cc=		"ron_barth@altsystem.com"
		to=		"seanq@nor-tech.com"
        subject="Update Configurator Component Prices, actUpdateComponentPrices.cfm -  START at #timeFormat(now(), 'hh:mm:ss tt')#"
        >
Batch Started

RecordCount in tblComponentPrices = #qryPricesStart.RecordCount#
</cfmail>




<!--- Fill prices in tblComponentPrices for all prices lists (including the Master price list) for all systems --->
<cfset objComponentPrices.createPricesForAllSystems()>




<!--- CURRENTLY DISABLED --->

<!--- Make sure all systems have default components selected for all categories --->
<!---
<cfset objConfigSystems.checkComponentDefaultsForAllSystems()>
--->



<cfquery datasource="#This.DataSourceName#" name="qryPricesEnd">
SELECT 	ComponentPriceID
FROM    tblComponentPrices
</cfquery>		
<cfmail from=	"info@nor-tech.com"		
        cc=		"ron_barth@altsystem.com"
		to=		"seanq@nor-tech.com"
        subject="Update Configurator Component Prices, actUpdateComponentPrices.cfm -  ENDED at #timeFormat(now(), 'hh:mm:ss tt')#"
        >
Batch Ended

RecordCount in tblComponentPrices = #qryPricesEnd.RecordCount#
</cfmail>

