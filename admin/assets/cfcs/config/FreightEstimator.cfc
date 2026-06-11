<cfcomponent>	
	
	<cffunction name="getEstimatedFreight" access="public" returntype="struct" output="no">
	<cfargument name="Record" type="struct" required="Yes">
    <cfargument name="ExportableConfigurator" type="boolean" default="0" required="no">
		<cfset var freight = initializeEstimatedFreight(arguments.record)>
		<cfset freight.exportableconfigurator = arguments.exportableconfigurator>
		<cfset freight.weights.system = getEstimatedFreightSystemWeight(freight)>
		<cfif freight.weights.system eq 0>
			<cfset freight.result.success = 0>
			<cfset freight.result.errormessage = "A shipping charge could not be determined because the system type is unknown.">
		</cfif>
		<cfset freight.weights.monitor = getEstimatedFreightMonitorWeight(freight)>
		<cfset freight.weight = freight.weights.system + freight.weights.monitor>
		<cfif freight.shipper IS "FEDEX">
			<cfset freight.result = getEstimatedFreightFedex(freight)>
		<cfelse>
			<cfset freight.result = getEstimatedFreightUPS(freight)>
		</cfif>
		<cfif freight.exportableconfigurator eq 1>
			<cfset freight.result.estimatedfreight = freight.result.estimatedfreight + getEstimatedFreightExportableConfigurator(freight)>
		</cfif>
		<cfif freight.result.estimatedfreight gt 0>
			<cfset freight.result.estimatedfreight = freight.result.estimatedfreight + 4> <!--- insurance --->		
		</cfif>
		<cfreturn freight.result>
	</cffunction>	
	
	<cffunction name="getEstimatedFreightFedex" access="private" returntype="struct" output="yes">
	<cfargument name="record" type="struct" required="Yes">
		<cfset var stResult = structNew()>
		<cfset fedexShipper = createObject("component", "FedexShipper").init("live")>
		<cfset stResult = fedexShipper.getRates(arguments.record)>
		<cfreturn stResult>
	</cffunction>
	
	<cffunction name="getEstimatedFreightUPS" access="private" returntype="struct" output="yes">
	<cfargument name="record" type="struct" required="Yes">
		<cfset var stResult = structNew()>
		<cfset upsShipper = createObject("component", "UPSShipper").init("4C3B00A21EA24410","nortechrb","tlldob1!",0)>
		<cfset stResult = upsShipper.getRates(arguments.record)>
		<cfreturn stResult>
	</cffunction>
	
	<cffunction name="getEstimatedFreightMonitorWeight" access="private" returntype="numeric" output="no">
	<cfargument name="record" type="struct" required="yes">
		<cfset var pkeys = structKeyList(arguments.record)>
		<cfset var ConfigComponentCategoryIDs = "">
		<cfset var MonitorWeight = 0>
		<cfloop list="#pkeys#" index="pkey">
			<cfif findNoCase("CAT_", pkey) NEQ 0>
            	<cfset ConfigComponentCategoryIDs = listAppend(ConfigComponentCategoryIDs, removeChars(pkey, 1, 4))>
			</cfif>
		</cfloop>
		<cfloop list="#ConfigComponentCategoryIDs#" index="ConfigComponentCategoryID">
			<cfquery datasource="#arguments.record.datasource#" name="qryConfigComponentCategories">
            SELECT TOP 1 CATEGORY FROM vConfigComponentCategories WHERE ConfigComponentCategoryID = '#ConfigComponentCategoryID#'
            </cfquery>	
			<cfif qryConfigComponentCategories.RecordCount NEQ 0 AND trim(qryConfigComponentCategories.CATEGORY) IS "MN">
            	<cfset ConfigComponentID = arguments.record[pkey]>
                <cfif findNoCase("|", ConfigComponentID) NEQ 0>
                	<cfset ConfigComponentID = removeChars(ConfigComponentID, findNoCase("|", ConfigComponentID), len(ConfigComponentID)-findNoCase("|", ConfigComponentID)+1)>
                </cfif>
                <cfquery datasource="#arguments.record.datasource#" name="qryConfigComponents">
                SELECT TOP 1 DESCRIPTION FROM vConfigComponents WHERE ConfigComponentID = '#ConfigComponentID#'
                </cfquery>	
                <cfif qryConfigComponents.RecordCount NEQ 0>
               		<cfif findNoCase("17IN", qryConfigComponents.DESCRIPTION) NEQ 0 OR findNoCase("17""", qryConfigComponents.DESCRIPTION) NEQ 0>
                        <cfset MonitorWeight = 14>
                    <cfelseif findNoCase("19IN", qryConfigComponents.DESCRIPTION) NEQ 0 OR findNoCase("19""", qryConfigComponents.DESCRIPTION) NEQ 0>
                        <cfset MonitorWeight = 16>
                    <cfelseif findNoCase("22IN", qryConfigComponents.DESCRIPTION) NEQ 0 OR findNoCase("22""", qryConfigComponents.DESCRIPTION) NEQ 0>
                        <cfset MonitorWeight = 22>
                    <cfelseif findNoCase("24IN", qryConfigComponents.DESCRIPTION) NEQ 0 OR findNoCase("24""", qryConfigComponents.DESCRIPTION) NEQ 0>
                        <cfset MonitorWeight = 25>
                    <cfelseif findNoCase("32IN", qryConfigComponents.DESCRIPTION) NEQ 0 OR findNoCase("32""", qryConfigComponents.DESCRIPTION) NEQ 0>
                        <cfset MonitorWeight = 52>
                    </cfif>
                </cfif>
  				<cfset QuantityField = "QTY|" & ConfigComponentCategoryID>
                <cfif structKeyExists(arguments.record, QuantityField)>
                    <cfif isNumeric(arguments.record[QuantityField]) eq 1>
                    	<cfset MonitorWeight = MonitorWeight * arguments.params[QuantityField]>
                    </cfif>
                </cfif>
        	</cfif>            
		</cfloop>
		<cfreturn MonitorWeight>
	</cffunction>
	
	<cffunction name="getEstimatedFreightSystemWeight" access="private" returntype="numeric" output="no">
	<cfargument name="record" type="struct" required="yes">
		<cfset var wgt = 0>
		<cfquery datasource="#arguments.record.datasource#" name="qryConfigSystem">
        SELECT TOP 1 Type FROM tblConfigSystems WHERE ConfigSystemID = '#arguments.record.params.ConfigSystemID#'
        </cfquery>
		<cfif qryConfigSystem.RecordCount NEQ 0>
			<cfif qryConfigSystem.Type IS "Workstation">
                <cfset wgt = 42>
            <cfelseif qryConfigSystem.Type IS "Server">
                <cfset wgt = 70>
            <cfelseif qryConfigSystem.Type IS "Notebook">
                <cfset wgt = 12>
            <cfelseif qryConfigSystem.Type IS "MiniMountablePC">
                <cfset wgt = 10>
            </cfif>
		</cfif>
		<cfreturn wgt>
	</cffunction>
	
	<cffunction name="initializeEstimatedFreight" access="private" returntype="struct" output="no">
	<cfargument name="record" type="struct" required="yes">
		<cfset r = structNew()>
		<cfset r.params = duplicate(arguments.record)>
		<cfset r.columns = structKeyList(r.params)>
		<cfset r.datasource = APPLICATION.DSN_WWW>
		
		<cfset r.result.success = 1>
		<cfset r.result.errormessage = "">
		<cfset r.result.estimatedfreight = 0>
		
		<cfset r.from.line1 = "901 East Cliff Road">
		<cfset r.from.city = "Burnsville">
		<cfset r.from.state = "MN">
		<cfset r.from.zip = "55337">
		<cfset r.from.country = "US">
		
		<cfset r.to.state = uCase(r.params.state)>
		<cfset r.to.zip = r.params.ZipCode>
		<cfif structKeyExists(r.params, "ResidentialDelivery") eq 0><cfset r.to.residence = 0><cfelse><cfset r.to.residence = 1></cfif>
		<cfif structKeyExists(r.params, "SignatureRequired") eq 0><cfset r.to.signature = 0><cfelse><cfset r.to.signature = 1></cfif>
		
		<cfif left(arguments.record.ShippingMethod,1) IS "F"><cfset r.shipper = "FEDEX"><cfelse><cfset r.shipper = "UPS"></cfif>
		<cfset r.weight = 0>
		<cfset r.weights.system = 0>
		<cfset t.weights.monitor = 0>
		
		<cfreturn r>
	</cffunction>
	
	<cffunction name="getEstimatedFreightExportableConfigurator" access="private" returntype="numeric" output="no">
	<cfargument name="record" type="struct" required="yes">
		<!--- Exportable Configurator; mark up the shipping cost --->
		<cfif Arguments.record.ExportableConfigurator eq 1>
			<cfquery datasource="#arguments.record.datasource#" name="qrylogin">
			SELECT	ShippingChargeType, MarkupShippingCharges, MarkupType, PercentWorkstations, PercentNotebooks, PercentServers, PercentMiniMountablePCs
			FROM	login
			WHERE 	CustomerID = '#Arguments.Record.params.CustomerID#'
			</cfquery>	
			<cfif qrylogin.ShippingChargeType IS "Freight Estimator" AND qrylogin.MarkupShippingCharges EQ 1>
				<!--- MARGIN PERCENT --->
				<cfif qryLogin.MarkupType IS "Margin">
					<cfif qryConfigSystem.Type IS "Workstation" AND isNumeric(qryLogin.PercentWorkstations)>
						<cfset arguments.record.result.EstimatedFreight = arguments.record.result.EstimatedFreight / (1 - qryLogin.PercentWorkstations)>
					<cfelseif qryConfigSystem.Type IS "Notebook" AND isNumeric(qryLogin.PercentNotebooks)>
						<cfset arguments.record.result.EstimatedFreight = arguments.record.result.EstimatedFreight / (1 - qryLogin.PercentNotebooks)>
					<cfelseif qryConfigSystem.Type IS "Server" AND isNumeric(qryLogin.PercentServers)>
						<cfset arguments.record.result.EstimatedFreight = arguments.record.result.EstimatedFreight / (1 - qryLogin.PercentServers)>
					<cfelseif qryConfigSystem.Type IS "MiniMountablePC" AND isNumeric(qryLogin.PercentMiniMountablePCs)>
						<cfset arguments.record.result.EstimatedFreight = arguments.record.result.EstimatedFreight / (1 - qryLogin.PercentMiniMountablePCs)>
					</cfif>
				<!--- MARKUP PERCENTAGES --->
				<cfelse>
					<cfif qryConfigSystem.Type IS "Workstation" AND isNumeric(qryLogin.PercentWorkstations)>
						<cfset arguments.record.result.EstimatedFreight = arguments.record.result.EstimatedFreight + arguments.record.result.EstimatedFreight * qryLogin.PercentWorkstations>
					<cfelseif qryConfigSystem.Type IS "Notebook" AND isNumeric(qryLogin.PercentNotebooks)>
						<cfset arguments.record.result.EstimatedFreight = arguments.record.result.EstimatedFreight + arguments.record.result.EstimatedFreight * qryLogin.PercentNotebooks>
					<cfelseif qryConfigSystem.Type IS "Server" AND isNumeric(qryLogin.PercentServers)>
						<cfset arguments.record.result.EstimatedFreight = arguments.record.result.EstimatedFreight + arguments.record.result.EstimatedFreight * qryLogin.PercentServers>
					<cfelseif qryConfigSystem.Type IS "MiniMountablePC" AND isNumeric(qryLogin.PercentMiniMountablePCs)>
						<cfset arguments.record.result.EstimatedFreight = arguments.record.result.EstimatedFreight + arguments.record.result.EstimatedFreight * qryLogin.PercentMiniMountablePCs>
					</cfif>
				</cfif>
			</cfif>
		</cfif>
		<cfreturn arguments.record.result.EstimatedFreight>
	</cffunction>
	
</cfcomponent>