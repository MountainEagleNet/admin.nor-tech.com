<cfcomponent extends="admin.assets.cfcs.Component">
	<cfset This.DataSourceName = APPLICATION.DSN_WWW>

	<cfset This.TableName = "tblPriceListCategories">
	<cfset This.ViewName = "vPriceListCategories">

	<cfset This.Columns = "PriceListCategoryID,PriceListID,CATEGORY,CategoryDescription,MarkupPercent,SortOrder">
	<cfset This.ViewColumns = "PriceListCategoryID,PriceListID,PriceListName,PriceListMarkUpPercent,CATEGORY,CategoryDescription,MarkupPercent,SortOrder">
	
	<cfset This.PrimaryKey = "PriceListCategoryID">
	
	<cfset This.GenerateUUIDKey = 1>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "PriceListName">
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

	<cffunction name="deleteRecord" access="public" output="No">
	<cfargument name="RecordID" type="string" required="Yes">
		<cfset objPriceListComponents = createObject("component", "admin.assets.cfcs.prices.PriceListComponents")>
		<cfset super.deleteRecord(Arguments.RecordID)>
		<!--- Delete children records in tblPriceListComponents --->
		<cfset qryPriceListComponents = objPriceListComponents.listRecordsForParent("PriceListCategoryID",Arguments.RecordID)>
		<cfloop query="qryPriceListComponents">
			<cfset objPriceListComponents.deleteRecord(qryPriceListComponents.PriceListComponentID)>
		</cfloop>
		<cfreturn>
	</cffunction>

	<cffunction name="saveRecord" access="public" returntype="string" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var RecordID = "">
		<cfif structKeyExists(Arguments.Record, "MarkupPercent") AND trim(Arguments.Record.MarkupPercent) IS "">
			<cfset structInsert(Arguments.Record, "MarkupPercent", "NULL", True)>
		</cfif>
		<cfset RecordID = super.saveRecord(Arguments.Record)>
		<cfreturn RecordID>
	</cffunction>

	<cffunction name="saveMarkupPercentage" access="public" returntype="string" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var PriceListCategoryID = "">
		<cfset stRecord = Arguments.Record>
		<cfset lstRecord = structKeyList(stRecord)>
		<cfloop list="#lstRecord#" index="Column">
			<cfif findNoCase("UPDATE|", Column) NEQ 0>
				<cfset ColumnValue = stRecord[Column]>
				<cfif ColumnValue IS "1">
					<cfset PriceListCategoryID = removeChars(Column, 1, 7)>
					<cfbreak>
				</cfif>
			</cfif>
		</cfloop>
		<cfset MarkupPercentField = "PCT|" & PriceListCategoryID>
		<cfif structKeyExists(stRecord, MarkupPercentField)>
			<cfset MarkupPercentValue = trim(stRecord[MarkupPercentField])>
			<cfif MarkupPercentValue IS NOT "" AND (NOT isNumeric(MarkupPercentValue) OR MarkupPercentValue LT 0)>
				<cfset PriceListCategoryID = "ERROR|MARKUP_PERCENT">
			<cfelse>
				<cfset strPriceListCategory = getRecord(PriceListCategoryID)>
				<cfif MarkupPercentValue IS "">
					<cfset structInsert(strPriceListCategory, "MarkupPercent", "NULL", True)>
				<cfelseif isNumeric(MarkupPercentValue)>
					<cfset structInsert(strPriceListCategory, "MarkupPercent", MarkupPercentValue, True)>
				</cfif>
				<cfset saveRecord(strPriceListCategory)>
			</cfif>
		</cfif>
		<cfreturn PriceListCategoryID>
	</cffunction>

	<cffunction name="calculateSellingPrices" access="public" output="No">
	<cfargument name="PriceListCategoryID" type="string" required="Yes">
		<cfset objPriceListComponents = createObject("component", "admin.assets.cfcs.prices.PriceListComponents")>
		<cfset qryPriceListComponents = objPriceListComponents.listRecordsForParent("PriceListCategoryID", Arguments.PriceListCategoryID)>
		<cfloop query="qryPriceListComponents">
			<cfif qryPriceListComponents.Active EQ 1>
				<cfset objPriceListComponents.calculateSellingPrice(qryPriceListComponents.PriceListComponentID)>
			</cfif>
		</cfloop>
	</cffunction>


	<!--- ******************************************************* --->
	<!--- I believe the following functions are NOT being used.   --->
	<!--- 5/24/07, Ron Barth									  --->
	<!--- ******************************************************* --->

	<cffunction name="copyPriceListCategories" access="public" output="No">
	<cfargument name="OldPriceListID" type="string" required="Yes">
	<cfargument name="NewPriceListID" type="string" required="Yes">
		<cfset objPriceListComponents = createObject("component", "admin.assets.cfcs.config.PriceListComponents")>
		<cfset qryOrigPriceListCategories = listRecordsForParent("PriceListID", Arguments.OldPriceListID)>
		<cfloop query="qryOrigPriceListCategories">
			<cfset strNewPriceListCategories = newRecord()>
			<cfloop list="#This.Columns#" index="Column">
				<cfif Column IS "PriceListID">
					<cfset structInsert(strNewPriceListCategories, "PriceListID", Arguments.NewPriceListID, True)>
				<cfelseif Column IS NOT "PriceListCategoryID">
					<cfset structInsert(strNewPriceListCategories, Column, qryOrigPriceListCategories[Column], True)>
				</cfif>
			</cfloop>
			<cfset NewPriceListCategoryID = saveRecord(strNewPriceListCategories)>

			<!--- Create records in tblPriceListComponents --->
			<cfset objPriceListComponents.copyPriceListComponents(qryOrigPriceListCategories.PriceListCategoryID, NewPriceListCategoryID)>
		</cfloop>
	</cffunction>


	<cffunction name="assignCategories" access="public" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset objComponentCategories = createObject("component", "admin.assets.cfcs.config.ComponentCategories")>
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

	<cffunction name="updateCategories" access="public" returntype="void" output="no">
	<cfargument name="record" type="struct" required="yes">
		<cfset local.dsp_keys = structNew()>
		<cfset local.srt_keys = structNew()>
		<cfset local.pct_keys = structNew()>
		<cfset local.record_keys = structKeyList(arguments.record)> 
		<cfloop list="#local.record_keys#" index="local.rkey">
			<cfif left(local.rkey, 3) is "DSP">
				<cfset local.plcid = listLast(local.rkey, "|")>
				<cfset local.dsp_keys[local.plcid] = arguments.record[local.rkey]>
			<cfelseif left(local.rkey, 3) is "SRT">
				<cfset local.plcid = listLast(local.rkey, "|")>
				<cfset local.srt_keys[local.plcid] = arguments.record[local.rkey]>
			<cfelseif left(local.rkey, 3) is "PCT">
				<cfset local.plcid = listLast(local.rkey, "|")>
				<cfset local.pct_keys[local.plcid] = arguments.record[local.rkey]>
			</cfif>
		</cfloop>
		<cfset local.q = listRecordsForParent("PriceListID", arguments.Record.PriceListID, "SortOrder")>
		<cfloop query="local.q">
			<cfif structKeyExists(local.dsp_keys, local.q.PriceListCategoryID) eq 0>
				<cfquery datasource="#This.DataSourceName#">
				UPDATE tblPriceListCategories
				SET SortOrder = 0
				WHERE PriceListCategoryID = '#local.q.PriceListCategoryID#'
				</cfquery>
			<cfelseif structKeyExists(local.srt_keys, local.q.PriceListCategoryID) neq 0 AND isNumeric(local.srt_keys[local.q.PriceListCategoryID]) neq 0 AND local.srt_keys[local.q.PriceListCategoryID] NEQ 0>
				<cfquery datasource="#This.DataSourceName#">
				UPDATE tblPriceListCategories
				SET SortOrder = #local.srt_keys[local.q.PriceListCategoryID]#
				WHERE PriceListCategoryID = '#local.q.PriceListCategoryID#'
				</cfquery>
			<cfelse>
				<cfquery datasource="#This.DataSourceName#">
				UPDATE tblPriceListCategories
				SET SortOrder = 999
				WHERE PriceListCategoryID = '#local.q.PriceListCategoryID#'
				</cfquery>
			</cfif>
			<cfif structKeyExists(local.pct_keys, local.q.PriceListCategoryID) neq 0 AND isNumeric(local.pct_keys[local.q.PriceListCategoryID]) neq 0 AND local.pct_keys[local.q.PriceListCategoryID] NEQ 0>
				<cfquery datasource="#This.DataSourceName#">
				UPDATE tblPriceListCategories
				SET MarkupPercent = #local.pct_keys[local.q.PriceListCategoryID]#
				WHERE PriceListCategoryID = '#local.q.PriceListCategoryID#'
				</cfquery>
			</cfif>
		</cfloop>
		<cfquery datasource="#This.DataSourceName#" name="qryPriceListCategories">
        SELECT	PriceListCategoryID, SortOrder
        FROM	tblPriceListCategories
        WHERE	PriceListID = '#arguments.record.PriceListID#'
		AND SortOrder >= 1
        ORDER BY SortOrder, CATEGORY
        </cfquery>
		<cfset NewSortOrder = 1>
        <cfloop query="qryPriceListCategories">
            <cfquery datasource="#This.DataSourceName#">
            UPDATE	tblPriceListCategories
            SET 	SortOrder = #NewSortOrder#
            WHERE	PriceListCategoryID = '#qryPriceListCategories.PriceListCategoryID#'
            </cfquery>
			<cfset NewSortOrder = NewSortOrder + 1>
        </cfloop>
	</cffunction>
	
	<cffunction name="getPriceListCategories" access="public" returntype="query" output="no">
	<cfargument name="PriceListID" type="string" required="yes">
		<cfquery name="local.qry" datasource="#This.datasourcename#">
		SELECT #This.ViewColumns#
		FROM #This.ViewName#
		WHERE PriceListID = '#arguments.PriceListID#'
		AND SortOrder >= 1
		ORDER BY SortOrder Asc
		</cfquery>
		<cfreturn local.qry>
	</cffunction>
	
	<cffunction name="listRecords" access="public" returntype="query" output="no">
		<cfquery name="local.qry" datasource="#This.datasourcename#">
		SELECT #This.ViewColumns#
		FROM #This.ViewName#
		WHERE SortOrder >= 1
		ORDER BY SortOrder Asc
		</cfquery>
		<cfreturn local.qry>
	</cffunction>
	
	<cffunction name="listRecordsForParent" access="public" returntype="query" output="no">
	<cfargument name="ParentKey" type="string" required="Yes">
	<cfargument name="ParentValue" type="string" required="Yes">
	<cfargument name="SortKey" type="string" required="no" default="SortOrder">
		<cfquery name="local.qry" datasource="#This.datasourcename#">
		SELECT #This.ViewColumns#
		FROM #This.ViewName#
		WHERE #arguments.ParentKey# = '#arguments.ParentValue#' 
		AND SortOrder >= 1
		ORDER BY #arguments.SortKey# Asc
		</cfquery>
		<cfreturn local.qry>
	</cffunction>
	
	
</cfcomponent>