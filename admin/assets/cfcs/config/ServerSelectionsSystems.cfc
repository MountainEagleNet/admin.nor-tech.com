<cfcomponent extends="admin.assets.cfcs.Component">

	<cfif isDefined("APPLICATION.DSN_WWW")>
		<cfset This.DataSourceName = APPLICATION.DSN_WWW>
	<cfelse>
		<cfset This.DataSourceName = "NorTechWWW">
	</cfif>

	<cfif isDefined("APPLICATION.DSN_AP")>
		<cfset This.APDataSourceName = APPLICATION.DSN_AP>
	<cfelse>
		<cfset This.APDataSourceName = "NorTechAP">
	</cfif>

	<cfif isDefined("APPLICATION.AdminLocation")>
		<cfset CURRENT_AdminLocation = APPLICATION.AdminLocation>
	<cfelse>
		<cfset CURRENT_AdminLocation = "admin">
	</cfif>

	<cfset This.TableName = "tblServerSelectionsSystems">
	<cfset This.ViewName = "vServerSelectionsSystems">

	<cfset This.Columns = "ServerSelectionsSystemsID,ConfigSystemID,ServerOptionSelectionID">
	<cfset This.ViewColumns = This.Columns & ",ServerOptionName,SelectionName,SystemName,DefaultSystem">
	
	<cfset This.PrimaryKey = "ServerSelectionsSystemsID">
	<cfset This.ForeignHeaderKey = "">
	<cfset This.ForeignDetailKey = "">
	
	<cfset This.ITEMNOKey = "">	

	<cfset This.GenerateUUIDKey = 1>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "ServerSelectionsSystemsID">
	<cfset This.SortOrder = "Asc">

	<cfset This.SortOrderList = "">
	<cfset This.SortKey = "">
	<cfset This.ParentKey = "">
	<cfset This.CreatedKey = "">
	<cfset This.ModifiedKey = "">
	<cfset This.ZipCode1Key = "">
	<cfset This.ZipCode2Key = "">
	<cfset This.SavePrimaryKey = 0>
	<cfset This.ExcludeInUpdates = "">
	<cfset This.ExcludeInInserts = "">


	<!---------------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="saveSelections" access="public" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var lstRecord = structKeyList(Arguments.Record)>
        <cfset var Column = "">
        <cfset var ServerOptionSelectionID = "">
		<cfset objServerOptions = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ServerOptions")>

		<!--- Remove all server option selections for this system --->
        <cfquery datasource="#This.DataSourceName#">
        DELETE FROM tblServerSelectionsSystems
        WHERE 		ConfigSystemID = '#Arguments.Record.ConfigSystemID#'
        </cfquery>

      	<!--- Then, fill them back up --->        
		<cfloop list="#lstRecord#" index="Column">

			<!--- Save the Default Component --->
            <cfif findNoCase("SERVOPT_", Column) NEQ 0>
                <cfset ServerOptionSelectionID = Arguments.Record[Column]>

                <cfquery datasource="#This.DataSourceName#">
                INSERT INTO tblServerSelectionsSystems (
                    ServerSelectionsSystemsID, 
                    ConfigSystemID,
                    ServerOptionSelectionID)
                VALUES (
                    '#createUUID()#', 
                    '#Arguments.Record.ConfigSystemID#',
                    '#ServerOptionSelectionID#')
                </cfquery>
            
            </cfif> 
		</cfloop>
        
	</cffunction>

	<!---------------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="inDatabase" access="public" returntype="boolean" output="No">
	<cfargument name="ConfigSystemID" type="string" required="Yes">
	<cfargument name="ServerOptionSelectionID" type="string" required="Yes">
		<cfset var isInDatabase = 0>
		<cfset var qryServerSelectionsSystems = queryNew("")>       
        
		<cfquery datasource="#This.DataSourceName#" name="qryServerSelectionsSystems">
		SELECT 	ServerSelectionsSystemsID
		FROM 	tblServerSelectionsSystems
		WHERE 	ConfigSystemID = '#Arguments.ConfigSystemID#' AND
        		ServerOptionSelectionID = '#Arguments.ServerOptionSelectionID#' 
		</cfquery>
		<cfif qryServerSelectionsSystems.RecordCount NEQ 0>
			<cfset isInDatabase = 1>
        </cfif>
		<cfreturn isInDatabase>
	</cffunction>
	
    
    
    
	<!---------------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="selectServers" access="public" returntype="query" output="No">
	<cfargument name="qryResellerSystems" type="query" required="Yes">
	<cfargument name="stRecord" type="struct" required="Yes">
    	<cfset var qryServers = queryNew("CLASSIFICATIONID,CLASSIFICATIONSORTORDER,CONFIGSYSTEMID,DESCRIPTION,ENERGYSTARAPPROVED,PHOTOIMAGE,SPECS,SYSTEMALIAS,SYSTEMBASEPRICE,SYSTEMNAME,SYSTEMSORTORDER,SYSTEMTOTAL,SYSTEMTYPE")>
        
		<cfset var lstRecord = structKeyList(Arguments.stRecord)>
		<cfset var Column = "">
        <cfset var qryServerOptionSelections = queryNew("ServerOptionSelectionID")>
        <cfset var qryFound = queryNew("")>

<!---
Arguments.qryResellerSystems:<cfdump var="#Arguments.qryResellerSystems#"><br>
Arguments.stRecord:<cfdump var="#Arguments.stRecord#"><br>
lstRecord:<cfdump var="#lstRecord#"><br>
--->
		<cfloop list="#lstRecord#" index="Column">
        	<cfif findNoCase('SERVOPT|', Column) NEQ 0>
            	<cfif trim(Arguments.stRecord[Column]) IS NOT "">
                	<cfset queryAddRow(qryServerOptionSelections)>
                    <cfset querySetCell(qryServerOptionSelections, "ServerOptionSelectionID", trim(Arguments.stRecord[Column]))>
                </cfif>
            </cfif>        
        </cfloop>
<!---
qryServerOptionSelections:<cfdump var="#qryServerOptionSelections#"><br>
--->

		<!--- If they made no selections --->
		<cfif qryServerOptionSelections.RecordCount EQ 0>
        	<cfset qryServers = Arguments.qryResellerSystems>
        <cfelse>
            <cfloop query="Arguments.qryResellerSystems">
<!---
Arguments.qryResellerSystems.SystemName:<cfdump var="#Arguments.qryResellerSystems.SystemName#"><br>
--->
                <cfquery datasource="#This.DataSourceName#" name="qryFound">
                SELECT 	ServerSelectionsSystemsID
                FROM 	tblServerSelectionsSystems
                WHERE 	ConfigSystemID = '#Arguments.qryResellerSystems.ConfigSystemID#' 
                
                        AND
                        (
                        <cfloop query="qryServerOptionSelections">
                            ServerOptionSelectionID = '#qryServerOptionSelections.ServerOptionSelectionID#' 
                            <cfif qryServerOptionSelections.CurrentRow NEQ qryServerOptionSelections.RecordCount>
                                OR
                            </cfif>
                        </cfloop>
                       	)   
                </cfquery>
<!---
qryFound:<cfdump var="#qryFound#"><br>
--->
                
<!---           <cfif qryFound.RecordCount NEQ 0>	--->
                <cfif qryFound.RecordCount EQ qryServerOptionSelections.RecordCount>
<!---                
FOUND<br><br>
--->                
                    <cfset queryAddRow(qryServers)>
                    <cfset querySetCell(qryServers, "CLASSIFICATIONID", Arguments.qryResellerSystems.CLASSIFICATIONID)>
                    <cfset querySetCell(qryServers, "CLASSIFICATIONSORTORDER", Arguments.qryResellerSystems.CLASSIFICATIONSORTORDER)>
                    <cfset querySetCell(qryServers, "CONFIGSYSTEMID", Arguments.qryResellerSystems.CONFIGSYSTEMID)>
                    <cfset querySetCell(qryServers, "DESCRIPTION", Arguments.qryResellerSystems.DESCRIPTION)>
                    <cfset querySetCell(qryServers, "ENERGYSTARAPPROVED", Arguments.qryResellerSystems.ENERGYSTARAPPROVED)>
                    <cfset querySetCell(qryServers, "PHOTOIMAGE", Arguments.qryResellerSystems.PHOTOIMAGE)>
                    <cfset querySetCell(qryServers, "SPECS", Arguments.qryResellerSystems.SPECS)>
                    <cfset querySetCell(qryServers, "SYSTEMALIAS", Arguments.qryResellerSystems.SYSTEMALIAS)>
                    <cfset querySetCell(qryServers, "SYSTEMBASEPRICE", Arguments.qryResellerSystems.SYSTEMBASEPRICE)>
                    <cfset querySetCell(qryServers, "SYSTEMNAME", Arguments.qryResellerSystems.SYSTEMNAME)>
                    <cfset querySetCell(qryServers, "SYSTEMSORTORDER", Arguments.qryResellerSystems.SYSTEMSORTORDER)>
                    <cfset querySetCell(qryServers, "SYSTEMTOTAL", Arguments.qryResellerSystems.SYSTEMTOTAL)>
                    <cfset querySetCell(qryServers, "SYSTEMTYPE", Arguments.qryResellerSystems.SYSTEMTYPE)>
                </cfif>
            </cfloop>
        </cfif>
<!---
qryServers:<cfdump var="#qryServers#"><br>
<cfabort>
--->    
        <cfreturn qryServers>
	</cffunction>
    
    
    
    
    
    
    
    
</cfcomponent>