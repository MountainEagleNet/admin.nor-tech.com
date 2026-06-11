<cfcomponent extends="admin.assets.cfcs.Component">
	<cfset This.DataSourceName = APPLICATION.DSN_WWW>

	<cfset This.TableName = "tblConfigComponentCategories">
	<cfset This.ViewName = "vConfigComponentCategories">

	<cfset This.Columns = "ConfigComponentCategoryID,ConfigSystemID,ComponentCategoryID,MarkupPercentage,MaximumQuantity,DefaultQuantity">
	<cfset This.ViewColumns = "ConfigComponentCategoryID,ConfigSystemID,SystemName,SystemType,SystemTypeSortOrder,ComponentCategoryID,CategoryName,CategorySortOrder,CATEGORY,IsAdditionalWarranty,MarkupPercentage,MaximumQuantity,DefaultQuantity">
	
	<cfset This.PrimaryKey = "ConfigComponentCategoryID">
	
	<cfset This.GenerateUUIDKey = 1>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "SystemName">
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

	<cffunction name="copyConfigComponentCategories" access="public" output="No">
	<cfargument name="OldConfigSystemID" type="string" required="Yes">
	<cfargument name="NewConfigSystemID" type="string" required="Yes">
		<cfset objConfigComponents = createObject("component", "admin.assets.cfcs.config.ConfigComponents")>
		<cfset objConfigWarranty = createObject("component", "admin.assets.cfcs.config.ConfigWarranty")>
		<cfset qryOrigConfigComponentCategories = listRecordsForParent("ConfigSystemID", Arguments.OldConfigSystemID)>
		<cfloop query="qryOrigConfigComponentCategories">
			<cfset strNewConfigComponentCategories = newRecord()>
			<cfloop list="#This.Columns#" index="Column">
				<cfif Column IS "ConfigSystemID">
					<cfset structInsert(strNewConfigComponentCategories, "ConfigSystemID", Arguments.NewConfigSystemID, True)>
				<cfelseif Column IS NOT "ConfigComponentCategoryID">
					<cfset structInsert(strNewConfigComponentCategories, Column, qryOrigConfigComponentCategories[Column], True)>
				</cfif>
			</cfloop>
			<cfset NewConfigComponentCategoryID = saveRecord(strNewConfigComponentCategories)>
			<cfif qryOrigConfigComponentCategories.IsAdditionalWarranty IS "1">
				<!--- Create records in tblConfigWarranty --->
                <cfset objConfigWarranty.copyConfigWarranty(qryOrigConfigComponentCategories.ConfigComponentCategoryID, NewConfigComponentCategoryID)>
			<cfelse>
				<!--- Create records in tblConfigComponents --->
                <cfset objConfigComponents.copyConfigComponents(qryOrigConfigComponentCategories.ConfigComponentCategoryID, NewConfigComponentCategoryID)>
			</cfif>
		</cfloop>
	</cffunction>

	<!---------------------------------------------------------------------------------------------------------------------->
	<cffunction name="deleteRecord" access="public" output="No">
	<cfargument name="RecordID" type="string" required="Yes">
		<cfset var qryConfigComponents = queryNew("")>
        <cfset var qryConfigWarranty = queryNew("")>
		<cfset objConfigComponents = createObject("component", "admin.assets.cfcs.config.ConfigComponents")>
		<cfset objConfigWarranty = createObject("component", "admin.assets.cfcs.config.ConfigWarranty")>

		<cfset super.deleteRecord(Arguments.RecordID)>
        
		<!--- Delete children records in tblConfigComponents --->
		<cfset qryConfigComponents = objConfigComponents.listRecordsForParent("ConfigComponentCategoryID",Arguments.RecordID)>
		<cfloop query="qryConfigComponents">
			<cfset objConfigComponents.deleteRecord(qryConfigComponents.ConfigComponentID)>
		</cfloop>
        
		<!--- Delete children records in tblConfigWarranty --->
		<cfset qryConfigWarranty = objConfigWarranty.listRecordsForParent("ConfigComponentCategoryID",Arguments.RecordID)>
		<cfloop query="qryConfigWarranty">
			<cfset objConfigWarranty.deleteRecord(qryConfigWarranty.ConfigWarrantyID)>
		</cfloop>
        
		<cfreturn>
	</cffunction>

	<!---------------------------------------------------------------------------------------------------------------------->
	<cffunction name="assignCategories" access="public" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var ConfigSystemID = "">
        <cfset var lstRecord = "">
        <cfset var qryComponentCategories = queryNew("")>
		<cfset var SearchRecord = structNew()>
        <cfset var qryConfigComponentCategories = queryNew("")>
        <cfset var InDatabase = 0>
        <cfset var CheckedOnForm = 0>
        <cfset var strConfigComponentCategory = structNew()>
		<cfset objComponentCategories = createObject("component", "admin.assets.cfcs.config.ComponentCategories")>
		<cfset objComponentPrices = createObject("component", "admin.assets.cfcs.config.ComponentPrices")>
        
		<cfset ConfigSystemID = Arguments.Record.ConfigSystemID>
		<cfset lstRecord = structKeyList(Arguments.Record)>
		<cfset qryComponentCategories = objComponentCategories.listRecords("query", "SortOrder")>
		<cfloop query="qryComponentCategories">
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "ConfigSystemID", ConfigSystemID, True)>
			<cfset structInsert(SearchRecord, "ComponentCategoryID", qryComponentCategories.ComponentCategoryID, True)>
			<cfset qryConfigComponentCategories = searchRecords(SearchRecord, "query")>
			<cfset InDatabase = 0>
			<cfif qryConfigComponentCategories.RecordCount GT 0>
				<cfset InDatabase = 1>
			</cfif>
			<cfset CheckedOnForm = 0>
			<cfif listContainsNoCase(lstRecord, "COMPCAT_#qryComponentCategories.ComponentCategoryID#") NEQ 0>
				<cfset CheckedOnForm = 1>
			</cfif>
			<!--- The user unchecked this category on the form --->
			<cfif InDatabase AND NOT CheckedOnForm>
				<!--- Delete it --->
				<cfset deleteRecord(qryConfigComponentCategories.ConfigComponentCategoryID)>
				<cfset objComponentPrices.deletePricesForCategory(qryConfigComponentCategories.ConfigComponentCategoryID)>
                
			<!--- The user checked this category on the form --->
			<cfelseif NOT InDatabase AND CheckedOnForm>
				<!--- Add it --->
				<cfset strConfigComponentCategory = newRecord()>
				<cfset structInsert(strConfigComponentCategory, "ConfigSystemID", ConfigSystemID, True)>
				<cfset structInsert(strConfigComponentCategory, "ComponentCategoryID", qryComponentCategories.ComponentCategoryID, True)>
				<cfset structDelete(strConfigComponentCategory, "MarkupPercentage")>
				<cfset saveRecord(strConfigComponentCategory)>
			</cfif>
		</cfloop>
	</cffunction>

	<cffunction name="saveRecord" access="public" returntype="string" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var RecordID = "">
		<cfif structKeyExists(Arguments.Record, "MarkupPercentage") AND	trim(Arguments.Record.MarkupPercentage) IS "">
			<cfset structInsert(Arguments.Record, "MarkupPercentage", "NULL", True)>
		</cfif>
		<cfset RecordID = super.saveRecord(Arguments.Record)>
		<cfreturn RecordID>
	</cffunction>

	<!--------------------------------------------------------------------------------------------------------------->
	<cffunction name="getNextCategory" access="public" returntype="string" output="No">
	<cfargument name="ConfigSystemID" type="string" required="Yes">
	<cfargument name="CategorySortOrder" type="numeric" required="Yes">
		<cfset var ConfigComponentCategoryID = "">
        <cfset var qryConfigSystem = queryNew("")>
		<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>
        
		<cfquery datasource="#This.DataSourceName#" name="qryRecords">
		SELECT 	#This.ViewColumns#
		FROM 	#This.ViewName#
		WHERE 	ConfigSystemID = '#Arguments.ConfigSystemID#' AND
				CategorySortOrder > #Arguments.CategorySortOrder# AND
                CategoryName <> 'EnergyStar' 
                
                <cfif objConfigSystems.isPowerSupplyAutoSelect(Arguments.ConfigSystemID)>
                	AND CategoryName <> 'Power Supply' 
                </cfif>
                
		ORDER BY CategorySortOrder
		</cfquery>
		<cfif qryRecords.RecordCount GT 0>
			<cfset ConfigComponentCategoryID = qryRecords.ConfigComponentCategoryID>
		</cfif>
		<cfreturn ConfigComponentCategoryID>
	</cffunction>

	<!--------------------------------------------------------------------------------------------------------------->
	<cffunction name="getCategories_Config" access="public" returntype="query" output="No">
	<cfargument name="ConfigSystemID" type="string" required="Yes">
	<cfargument name="IncludeAdditionalWarranty" type="boolean" required="no">
		<cfset var qryConfigComponentCategories = queryNew("")>
        <cfif NOT isDefined("Arguments.IncludeAdditionalWarranty")><cfset Arguments.IncludeAdditionalWarranty = 1></cfif>
		<cfquery datasource="#This.DataSourceName#" name="qryConfigComponentCategories">
		SELECT 	tblConfigComponentCategories.ConfigComponentCategoryID, tblConfigComponentCategories.DefaultQuantity, 
        		tblConfigComponentCategories.MaximumQuantity, tblComponentCategories.Name AS CategoryName,
                tblComponentCategories.IsAdditionalWarranty,
                
                tblComponentCategories.CATEGORY
<!---				
				(SELECT	tblComponentCategories.Name
				 FROM   tblComponentCategories
				 WHERE  tblComponentCategories.ComponentCategoryID = tblConfigComponentCategories.ComponentCategoryID) AS CategoryName,
				(SELECT	tblComponentCategories.SortOrder
				 FROM   tblComponentCategories
				 WHERE  tblComponentCategories.ComponentCategoryID = tblConfigComponentCategories.ComponentCategoryID) 
				 		AS CategorySortOrder		 
--->
		FROM 	tblConfigComponentCategories
				INNER JOIN tblComponentCategories ON 
						   tblComponentCategories.ComponentCategoryID = tblConfigComponentCategories.ComponentCategoryID
		WHERE 	ConfigSystemID = '#Arguments.ConfigSystemID#'
        		<cfif NOT Arguments.IncludeAdditionalWarranty>
                	AND tblComponentCategories.IsAdditionalWarranty <> 1
                </cfif> 
		ORDER BY tblComponentCategories.SortOrder
		</cfquery>
		<cfreturn qryConfigComponentCategories>
	</cffunction>

</cfcomponent>