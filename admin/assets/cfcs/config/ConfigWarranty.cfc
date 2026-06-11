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


	<cfset This.Columns = "ConfigWarrantyID,AdditionalWarrantyID,ConfigComponentCategoryID,DefaultComponent">
	<cfset This.ViewColumns = This.Columns & ",Name,PercentMarkUp,SortOrder,ConfigSystemID,CategoryName">
	
	<cfset This.TableName = "tblConfigWarranty">
	<cfset This.ViewName = "vConfigWarranty">
	
	<cfset This.PrimaryKey = "ConfigWarrantyID">
	<cfset This.ForeignHeaderKey = "">
	<cfset This.ForeignDetailKey = "">
	
	<cfset This.ITEMNOKey = "">	

	<cfset This.GenerateUUIDKey = 1>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "SortOrder">
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
	
	<!--------------------------------------------------------------------------------------------------->
	<cffunction name="validateRecord" access="public" returntype="struct" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
        <cfset var FoundOne = 0>
        <cfset var lstRecord = "">
        <cfset var qryAdditionalWarranty = queryNew("")>
   		<cfset objAdditionalWarranty = createObject("component", "admin.assets.cfcs.config.AdditionalWarranty")>
		<cfset lstRecord = structKeyList(Arguments.Record)>
        
		<cfset FoundOne = 0>
        <cfset qryAdditionalWarranty = objAdditionalWarranty.listRecords()>
        <cfif qryAdditionalWarranty.RecordCount EQ 0>
            <!--- Don't report an error if the category has no items to choose from --->
            <cfset FoundOne = 1>
        <cfelse>
            <cfloop list="#lstRecord#" index="Column">
                <cfif findNoCase("DEPOT|", Column) NEQ 0>
                    <cfset FoundOne = 1>
                    <cfbreak>
                </cfif>
            </cfloop>
        </cfif>
        <cfif NOT FoundOne>
            <cfset structInsert(stErrors, "PickOne", "Please pick at least one warranty", True)>
        </cfif>

		<cfreturn stErrors>
	</cffunction>

	<!---------------------------------------------------------------------------------------------------------------------->
	<cffunction name="assignWarranty" access="public" output="no">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var SearchRecord = structNew()>
        <cfset var lstRecord = "">
        <cfset var qryAdditionalWarranty = queryNew("")>
        <cfset var qryConfigWarranty = queryNew("")>
        <cfset var qryConfigWarranty2 = queryNew("")>
        <cfset var InDatabase = 0>
        <cfset var CheckedOnForm = 0>
        <cfset var strConfigWarranty = structNew()>
        <cfset var WarrantyField = "">
   		<cfset objAdditionalWarranty = createObject("component", "admin.assets.cfcs.config.AdditionalWarranty")>
            
		<cfset lstRecord = structKeyList(Arguments.Record)>

		<cfset qryAdditionalWarranty = objAdditionalWarranty.listRecords()>
        <cfloop query="qryAdditionalWarranty">
            <cfset SearchRecord = structNew()>
            <cfset structInsert(SearchRecord, "ConfigComponentCategoryID", Arguments.Record.ConfigComponentCategoryID, True)>
            <cfset structInsert(SearchRecord, "AdditionalWarrantyID", qryAdditionalWarranty.AdditionalWarrantyID, True)>
            <cfset qryConfigWarranty = searchRecords(SearchRecord, "query")>
            
            <cfset InDatabase = 0>
            <cfif qryConfigWarranty.RecordCount GT 0>
                <cfset InDatabase = 1>
            </cfif>
            
            <cfset CheckedOnForm = 0>
            <cfset WarrantyField = "DEPOT|" & qryAdditionalWarranty.AdditionalWarrantyID>
            <cfif listContainsNoCase(lstRecord, WarrantyField) NEQ 0>
                <cfset CheckedOnForm = 1>
            </cfif>
            
            <!--- The user unchecked this component on the form --->
            <cfif InDatabase AND NOT CheckedOnForm>
                <!--- Delete it --->
                <cfset deleteRecord(qryConfigWarranty.ConfigWarrantyID)>
            <!--- The user checked this component on the form --->
            <cfelseif NOT InDatabase AND CheckedOnForm>
                <!--- Add it --->
                <cfset strConfigWarranty = newRecord()>
                <cfset structInsert(strConfigWarranty, "ConfigComponentCategoryID", Arguments.Record.ConfigComponentCategoryID, True)>
                <cfset structInsert(strConfigWarranty, "AdditionalWarrantyID", qryAdditionalWarranty.AdditionalWarrantyID, True)>
                <cfset structDelete(strConfigWarranty, "DefaultComponent")>
                <cfset saveRecord(strConfigWarranty)>
            </cfif>
        </cfloop>

        <!--- If this category now has only one component, and it's not marked as the default, mark it as the default --->          
        <cfquery datasource="#This.DataSourceName#" name="qryConfigWarranty2">
        SELECT	ConfigWarrantyID,DefaultComponent
        FROM    tblConfigWarranty 
        WHERE   ConfigComponentCategoryID = '#Arguments.Record.ConfigComponentCategoryID#'
        </cfquery>
        <cfif qryConfigWarranty2.RecordCount EQ 1 AND qryConfigWarranty2.DefaultComponent IS "">
            <cfquery datasource="#This.DataSourceName#">
            UPDATE	tblConfigWarranty
            SET 	DefaultComponent = 1
            WHERE 	ConfigWarrantyID = '#qryConfigWarranty2.ConfigWarrantyID#'
            </cfquery>
        </cfif>
            
	</cffunction>
    
	<!--------------------------------------------------------------------------------------------------->
	<cffunction name="listDefaultWarranty" access="public" returntype="query" output="No">
	<cfargument name="ConfigSystemID" type="string" required="Yes">
		<cfset qryConfigWarranty = queryNew(This.ViewColumns)>
        <cfquery datasource="#This.DataSourceName#" name="qryConfigWarranty">
        SELECT	*
        FROM    vConfigWarranty 
        WHERE   ConfigSystemID = '#Arguments.ConfigSystemID#' AND
        		DefaultComponent = '1'
        </cfquery>
		<cfreturn qryConfigWarranty>
	</cffunction>

	<!--------------------------------------------------------------------------------------------------->
	<cffunction name="copyConfigWarranty" access="public" output="No">
	<cfargument name="OldConfigComponentCategoryID" type="string" required="Yes">
	<cfargument name="NewConfigComponentCategoryID" type="string" required="Yes">
		<cfset qryOrigConfigWarranty = listRecordsForParent("ConfigComponentCategoryID", Arguments.OldConfigComponentCategoryID)>
		<cfloop query="qryOrigConfigWarranty">
			<cfset strNewConfigWarranty = newRecord()>
			<cfloop list="#This.Columns#" index="Column">
				<cfif Column IS "ConfigComponentCategoryID">
					<cfset structInsert(strNewConfigWarranty, "ConfigComponentCategoryID", Arguments.NewConfigComponentCategoryID, True)>
				<cfelseif Column IS NOT "ConfigWarrantyID">
					<cfset structInsert(strNewConfigWarranty, Column, qryOrigConfigWarranty[Column], True)>
				</cfif>
			</cfloop>
			<cfset NewConfigWarrantyID = saveRecord(strNewConfigWarranty)>
		</cfloop>
	</cffunction>
    
<!---	

	<!--------------------------------------------------------------------------------------------------->
	<cffunction name="saveRecord" access="public" returntype="string" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var AdditionalWarrantyID = "">
		<cfset var qryAdditionalWarranty = queryNew("")>        
		<cfset var CurrentSortOrder = 1>
        <cfset AdditionalWarrantyID = super.saveRecord(Arguments.Record)>
        <cfquery name="qryAdditionalWarranty" datasource="#This.DataSourceName#">
        SELECT	*
        FROM	#This.TableName# 
        ORDER BY SortOrder
        </cfquery>
        <cfloop query="qryAdditionalWarranty">
            <cfquery datasource="#This.DataSourceName#">
            UPDATE	#This.TableName# 
            SET		SortOrder = '#CurrentSortOrder#'
            WHERE	AdditionalWarrantyID = '#qryAdditionalWarranty.AdditionalWarrantyID#'            
            </cfquery>
			<cfset CurrentSortOrder = CurrentSortOrder + 1>
		</cfloop>
		<cfreturn AdditionalWarrantyID>
	</cffunction>

	<!--------------------------------------------------------------------------------------------------->
	<cffunction name="SystemHasDepotWarranty" access="public" returntype="boolean" output="No">
	<cfargument name="ConfigSystemID" type="string" required="Yes">
		<cfset var SystemHasDepotWarranty = 0>
        <cfset var qryConfigComponentCategories = queryNew("")>
        <cfquery name="qryConfigComponentCategories" datasource="#This.DataSourceName#">
        SELECT  tblConfigComponentCategories.ConfigComponentCategoryID
        FROM   	tblConfigComponentCategories INNER JOIN
                tblComponentCategories ON tblComponentCategories.ComponentCategoryID = tblConfigComponentCategories.ComponentCategoryID
        WHERE 	tblConfigComponentCategories.ConfigSystemID = '#Arguments.ConfigSystemID#' AND 
        		tblComponentCategories.IsAdditionalWarranty = 1
        </cfquery>
        <cfif qryConfigComponentCategories.RecordCount NEQ 0>
			<cfset SystemHasDepotWarranty = 1>
        </cfif>
		<cfreturn SystemHasDepotWarranty>
	</cffunction>

	<!--------------------------------------------------------------------------------------------------->
	<cffunction name="getCostOfItems" access="public" returntype="numeric" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var CostOfItems = 0>
        <cfset var lstRecord = "">
        <cfset var Column = "">
        <cfset var ConfigComponentID = "">
        <cfset var qryConfigComponent = queryNew("")>
        <cfset var ItemCost = 0>
<!---        
<cfdump var="#Arguments.Record#"><br><br>
--->
		<cfset lstRecord = structKeyList(Arguments.Record)>
        <cfloop list="#lstRecord#" index="Column">
        	<cfif findNoCase("CAT_", Column) NEQ 0>
            	<cfif Arguments.Record[Column] IS NOT "">
					<cfset ConfigComponentID = left(Arguments.Record[Column], FindNoCase("_",Arguments.Record[Column])-1)>
<!---
ConfigComponentID:<cfdump var="#ConfigComponentID#"><br>
--->
                    <cfquery name="qryConfigComponent" datasource="#This.DataSourceName#">
                    SELECT  ITEMNO
                    FROM   	tblConfigComponents
                    WHERE 	ConfigComponentID = '#ConfigComponentID#' 
                    </cfquery>
                    <cfif qryConfigComponent.RecordCount NEQ 0>
                    	<cfset ItemCost = getItemCost(qryConfigComponent.ITEMNO)>
<!---
qryConfigComponent.ITEMNO:<cfdump var="#qryConfigComponent.ITEMNO#"><br>
ItemCost:<cfdump var="#ItemCost#"><br><br>
--->
						<cfif isNumeric(ItemCost)>
							<cfset CostOfItems = CostOfItems + ItemCost>
                        </cfif>
                    </cfif>
                </cfif>
            </cfif>
        </cfloop>
<!---
<br><br><br>CostOfItems:<cfdump var="#CostOfItems#"><br />
--->
		<cfreturn CostOfItems>
	</cffunction>


	<!--------------------------------------------------------------------------------------------------->
	<cffunction name="getMarkUp" access="public" returntype="numeric" output="No">
	<cfargument name="CostOfItems" type="numeric" required="Yes">
	<cfargument name="AdditionalWarrantyID" type="string" required="Yes">
	<cfargument name="ExportableConfigurator" type="boolean" default="0" required="no">
	<cfargument name="ConfigSystemID" type="string" required="no">
	<cfargument name="CustomerID" type="string" required="no">  
		<cfset var MarkUp = 0>
        <cfset var qryAdditionalWarranty = queryNew("")>
		<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>
		<cfif NOT isDefined("Arguments.ExportableConfigurator")>
        	<cfset Arguments.ExportableConfigurator = 0>
        </cfif>
        <cfquery name="qryAdditionalWarranty" datasource="#This.DataSourceName#">
        SELECT  PercentMarkUp
        FROM   	tblAdditionalWarranty
        WHERE 	AdditionalWarrantyID = '#Arguments.AdditionalWarrantyID#' 
        </cfquery>
		<cfif qryAdditionalWarranty.RecordCount NEQ 0>
        	<cfif isNumeric(qryAdditionalWarranty.PercentMarkUp)>
            	<cfset MarkUp = Arguments.CostOfItems * qryAdditionalWarranty.PercentMarkUp / 100>
            </cfif>
        </cfif>
        
       	<!--- EXPORTABLE CONFIGURATOR ---> 
		<cfif Arguments.ExportableConfigurator>
       		<cfset strConfigSystem = objConfigSystems.getRecord(Arguments.ConfigSystemID)>

            <cfquery datasource="#This.DataSourceName#" name="qrylogin">
            SELECT	MarkupType, PercentWorkstations, PercentNotebooks, PercentServers, PercentMiniMountablePCs
            FROM	login
            WHERE 	CustomerID = '#Arguments.CustomerID#'
            </cfquery>	

			<cfif qryLogin.RecordCount NEQ 0>            
            
                <!--- MARGIN PERCENT --->
                <cfif qryLogin.MarkupType IS "Margin">
                    <cfif strConfigSystem.Type IS "Workstation" AND isNumeric(qryLogin.PercentWorkstations)>
                        <cfset MarkUp = MarkUp / (1 - qryLogin.PercentWorkstations)>
                    <cfelseif strConfigSystem.Type IS "Notebook" AND isNumeric(qryLogin.PercentNotebooks)>
                        <cfset MarkUp = MarkUp / (1 - qryLogin.PercentNotebooks)>
                    <cfelseif strConfigSystem.Type IS "Server" AND isNumeric(qryLogin.PercentServers)>
                        <cfset MarkUp = MarkUp / (1 - qryLogin.PercentServers)>
                    <cfelseif strConfigSystem.Type IS "MiniMountablePC" AND isNumeric(qryLogin.PercentMiniMountablePCs)>
                        <cfset MarkUp = MarkUp / (1 - qryLogin.PercentMiniMountablePCs)>
                    </cfif>
                
                <!--- MARKUP PERCENTAGES --->
                <cfelse>
                    <cfif strConfigSystem.Type IS "Workstation" AND isNumeric(qryLogin.PercentWorkstations)>
                        <cfset MarkUp = MarkUp + MarkUp * qryLogin.PercentWorkstations>
                    <cfelseif strConfigSystem.Type IS "Notebook" AND isNumeric(qryLogin.PercentNotebooks)>
                        <cfset MarkUp = MarkUp + MarkUp * qryLogin.PercentNotebooks>
                    <cfelseif strConfigSystem.Type IS "Server" AND isNumeric(qryLogin.PercentServers)>
                        <cfset MarkUp = MarkUp + MarkUp * qryLogin.PercentServers>
                    <cfelseif strConfigSystem.Type IS "MiniMountablePC" AND isNumeric(qryLogin.PercentMiniMountablePCs)>
                        <cfset MarkUp = MarkUp + MarkUp * qryLogin.PercentMiniMountablePCs>
                    </cfif>
                </cfif>
            </cfif>
        </cfif>
        
        
       <!---<cfset MarkUp = numberFormat(MarkUp, ".99")>--->
        <cfset MarkUp = round(MarkUp)>
		<cfreturn MarkUp>
	</cffunction>

--->
    
</cfcomponent>