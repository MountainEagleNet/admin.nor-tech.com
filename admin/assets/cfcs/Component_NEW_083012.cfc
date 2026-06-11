<cfcomponent extends="admin.assets.cfcs.Validation">
	<cfset This.DataSourceName = "">

	<cfset This.Initialized = 0>
	
	<cfset This.Columns = "">
	<cfset This.ViewColumns = "">
	<cfset This.ProcedureColumns = "">
	<cfset This.DESCColumn = "">
	<cfset This.LINENOColumn = "">

	<cfset This.PrimaryKey = "">

	<cfset This.ForeignHeaderKey = "">
	<cfset This.ForeignDetailKey = "">
	<cfset This.OrderNumberKey = "">
	<cfset This.ITEMNOKey = "">
	<cfset This.SortOrderKey = "">

	<cfset This.SortKey = "">
	<cfset This.ParentKey = "">
	<cfset This.RootKey = "">
	<cfset This.ForeignKey = "">
	<cfset This.DefaultKey = "">
	<cfset This.JoinBoxKey1 = "">
	<cfset This.JoinBoxKey2 = "">
	<cfset This.CreatedKey = "Created">
	<cfset This.ModifiedKey = "Modified">
	<cfset This.CreatorKey = "">
	<cfset This.ZipCode1Key = "">
	<cfset This.ZipCode2Key = "">
	
	<cfset This.GenerateUUIDKey = True>
	
	<cfset This.Component = "">
	
	<cfset This.XmlRootTag = "">
	<cfset This.XmlChildTag = "">
	<cfset This.XmlDataFile = "">
	
	<cfset This.Format = "query">
	<cfset This.SortColumn = "">	
	<cfset This.SortOrder = "Asc">
<!---
	<cfset This.SortOrderList = "">
	<cfset This.ExactMatch = 0>
	<cfset This.UseSortOrder = 1>
	<cfset This.UseSortOrderList = 0>
--->
	<cfset This.SavePrimaryKey = 0>
	
	<cfset This.ExcludeInUpdates = "Created">
	<cfset This.ExcludeInInserts = "Created,Modified">
	<cfset This.QuotedInsertList = "">
	
	<cfset This.TableName = "">
	<cfset This.ViewName = "">
	<cfset This.ProcedureName = "">
	
	<cfset This.Format = "query">
	
	<cfset This.CascadingTables = "">
	
	<cfset This.Format = "xml">
	<cfset This.XmlFilePath = "">

	<cfset This.DataRecordName = "GenericDataRecord">
	<cfset This.ErrorRecordName = "GenericErrorRecord">
	
<!---	
	<cffunction name="createGUID" access="public" returntype="string" output="No">
	<cfargument name="UUID" type="string" required="No">
		<cfif isDefined("Arguments.UUID") EQ 0>
			<cfset UUID = trim(replaceNoCase(createUUID(), "-", "", "all"))>
		<cfelse>
			<cfset UUID = trim(replaceNoCase(left(Arguments.UUID, 32), chr(32), "", "all"))>
		</cfif>
		<cfset ServerID = left(getServerName(), 7)>
		<cfset SiteID = left(getSiteName(), 9)>
		<cfset GUID = ServerID & "_" & SiteID & "_" & UUID>
		<cfreturn GUID>
	</cffunction>

	<cffunction name="getInitialized" access="public" returntype="boolean" output="No">
		<cfreturn This.Initialized>
	</cffunction>
	
	<cffunction name="setInitialized" access="public" output="No">
	<cfargument name="Initialized" type="boolean" required="Yes">
		<cfset This.Initialized = Arguments.Initialized>
		<cfreturn>
	</cffunction>
	
	<cffunction name="getSettings" access="public" returntype="any" output="No">
		<cfreturn Request.Settings>
	</cffunction>
	
	<cffunction name="getDatasource" access="public" returntype="string" output="No">
		<cfreturn getSettings().getDatasource()>
	</cffunction>
	
	<cffunction name="getSiteName" access="public" returntype="string" output="No">
		<cfreturn getSettings().getSiteName()>
	</cffunction>
	
	<cffunction name="getServerName" access="public" returntype="string" output="No">
		<cfreturn getSettings().getServerName()>
	</cffunction>
	
	<cffunction name="getPS" access="public" returntype="string" output="No">
		<cfreturn getSettings().getPathSeparator()>
	</cffunction>
	
	<cffunction name="getRecordKey" access="public" returntype="string" output="No">
		<cfreturn getSettings().getRecordKey()>
	</cffunction>
	
	<cffunction name="getSearchKey" access="public" returntype="string" output="No">
		<cfreturn getSettings().getSearchKey()>
	</cffunction>
	
	<cffunction name="getErrorKey" access="public" returntype="string" output="No">
		<cfreturn getSettings().getErrorKey()>
	</cffunction>
	
	<cffunction name="getColumns" access="public" returntype="string" output="No">
		<cfreturn This.Columns>
	</cffunction>
	
	<cffunction name="setColumns" access="public" output="No">
	<cfargument name="Columns" type="string" required="Yes">
		<cfset This.Columns = Arguments.Columns>
		<cfreturn>
	</cffunction>
	
	<cffunction name="getPrimaryKey" access="public" returntype="string" output="No">
		<cfreturn This.PrimaryKey>
	</cffunction>

	<cffunction name="setPrimaryKey" access="public" output="No">
	<cfargument name="PrimaryKey" type="string" required="Yes">
		<cfset This.PrimaryKey = Arguments.PrimaryKey>
		<cfreturn>
	</cffunction>
	
	<cffunction name="getForeignKey" access="public" returntype="string" output="No">
		<cfreturn This.ForeignKey>
	</cffunction>

	<cffunction name="setForeignKey" access="public" output="No">
	<cfargument name="ForeignKey" type="string" required="Yes">
		<cfset This.ForeignKey = Arguments.ForeignKey>
		<cfreturn>
	</cffunction>
	
	<cffunction name="getParentKey" access="public" returntype="string" output="No">
		<cfreturn This.ParentKey>
	</cffunction>

	<cffunction name="setParentKey" access="public" output="No">
	<cfargument name="ParentKey" type="string" required="Yes">
		<cfset This.ParentKey = Arguments.ParentKey>
		<cfreturn>
	</cffunction>
	
	<cffunction name="getRootKey" access="public" returntype="string" output="No">
		<cfreturn This.RootKey>
	</cffunction>

	<cffunction name="setRootKey" access="public" output="No">
	<cfargument name="RootKey" type="string" required="Yes">
		<cfset This.RootKey = Arguments.RootKey>
		<cfreturn>
	</cffunction>
	
	<cffunction name="getXmlDataFileName" access="public" returntype="string" output="No">
		<cfreturn This.XmlDataFile>
	</cffunction>

	<cffunction name="setXmlDataFileName" access="public" output="No">
	<cfargument name="XmlDataFileName" type="string" required="Yes">
		<cfset This.XmlDataFileName = Arguments.XmlDataFileName>
		<cfreturn>
	</cffunction>
	
	<cffunction name="getSortKey" access="public" returntype="string" output="No">
		<cfreturn This.SortKey>
	</cffunction>

	<cffunction name="setSortKey" access="public" output="No">
	<cfargument name="SortKey" type="string" required="Yes">
		<cfset This.SortKey = Arguments.SortKey>
		<cfreturn>
	</cffunction>
	
	<cffunction name="getFormat" access="public" returntype="string" output="No">
		<cfreturn This.Format>
	</cffunction>

	<cffunction name="setFormat" access="public" output="No">
	<cfargument name="Format" type="string" required="Yes">
		<cfset This.Format = Arguments.Format>
		<cfreturn>
	</cffunction>
	
	<cffunction name="getSortColumn" access="public" returntype="string" output="No">
		<cfreturn This.SortColumn>
	</cffunction>

	<cffunction name="setSortColumn" access="public" output="No">
	<cfargument name="SortColumn" type="string" required="Yes">
		<cfset This.SortColumn = Arguments.SortColumn>
		<cfreturn>
	</cffunction>
	
	<cffunction name="getSortOrder" access="public" returntype="string" output="No">
		<cfreturn This.SortOrder>
	</cffunction>

	<cffunction name="setSortOrder" access="public" output="No">
	<cfargument name="SortOrder" type="string" required="Yes">
		<cfset This.SortOrder = Arguments.SortOrder>
		<cfreturn>
	</cffunction>
--->
<!---	
	<cffunction name="getSortOrderList" access="public" returntype="string" output="No">
		<cfreturn This.SortOrderList>
	</cffunction>

	<cffunction name="setSortOrderList" access="public" output="No">
	<cfargument name="SortOrderList" type="string" required="Yes">
		<cfset This.SortOrderList = Arguments.SortOrderList>
		<cfreturn>
	</cffunction>

	<cffunction name="getUseSortOrderList" access="public" returntype="boolean" output="No">
		<cfreturn This.UseSortOrderList>
	</cffunction>

	<cffunction name="setUseSortOrderList" access="public" output="No">
	<cfargument name="UseSortOrderList" type="boolean" required="Yes">
		<cfset This.UseSortOrderList = Arguments.UseSortOrderList>
		<cfreturn>
	</cffunction>
--->	
<!---
	<cffunction name="getViewColumns" access="public" returntype="string" output="No">
		<cfreturn This.ViewColumns>
	</cffunction>
	
	<cffunction name="setViewColumns" access="public" output="No">
	<cfargument name="ViewColumns" type="string" required="Yes">
		<cfset This.ViewColumns = Arguments.ViewColumns>
		<cfreturn>
	</cffunction>
	
	<cffunction name="getTableName" access="public" returntype="string" output="No">
		<cfreturn This.TableName>
	</cffunction>
	
	<cffunction name="setTableName" access="public" output="No">
	<cfargument name="TableName" type="string" required="Yes">
		<cfset This.TableName = Arguments.TableName>
		<cfreturn>
	</cffunction>

	<cffunction name="getViewName" access="public" returntype="string" output="No">
		<cfreturn This.ViewName>
	</cffunction>
	
	<cffunction name="setViewName" access="public" output="No">
	<cfargument name="ViewName" type="string" required="Yes">
		<cfset This.ViewName = Arguments.ViewName>
		<cfreturn>
	</cffunction>
	
	<cffunction name="getCascadingTables" access="public" returntype="string" output="No">
		<cfreturn This.CascadingTables>
	</cffunction>

	<cffunction name="setCascadingTables" access="public" output="No">
	<cfargument name="CascadingTables" type="string" required="Yes">
		<cfset This.CascadingTables = Arguments.CascadingTables>
		<cfreturn>
	</cffunction>
	
	<cffunction name="dropTable" access="package" output="No">
		<cfquery datasource="#This.DataSourceName#">
		DROP Table #This.TableName#
		</cfquery>
		<cfreturn>
	</cffunction>
	
	<cffunction name="createTable" access="package" output="No">
		<cfreturn>
	</cffunction>
--->


	
	<cffunction name="listRecordsForParent" access="public" returntype="query" output="No">
	<cfargument name="ParentIDFieldName" type="string" required="Yes">
	<cfargument name="ParentID" type="string" required="Yes">
	<cfargument name="OrderByList" type="string" required="No">
		<cfset var qryRecords = queryNew(This.ViewColumns)>
		<cfset stSearch = structNew()>
		<cfif NOT isDefined("Arguments.OrderByList")><cfset Arguments.OrderByList = This.SortColumn & " " & This.SortOrder></cfif>
		<cfset structInsert(stSearch, Arguments.ParentIDFieldName, Arguments.ParentID, True)>
		<cfif Arguments.ParentID IS NOT "">
			<cfset qryRecords = searchRecords(stSearch, "query", Arguments.OrderByList)>
		</cfif>
		<cfreturn qryRecords>
	</cffunction>
	
	<cffunction name="listRecords" access="public" returntype="any" output="No">
	<cfargument name="Format" type="string" required="No">
	<cfargument name="OrderByList" type="string" required="No">
		<cfset var qryRecords = queryNew(This.ViewColumns)>
		<cfset var stSearch = structNew()>
		<cfif NOT isDefined("Arguments.Format")><cfset Arguments.Format = This.Format></cfif>
		<cfif NOT isDefined("Arguments.OrderByList")><cfset Arguments.OrderByList = This.SortColumn & " " & This.SortOrder></cfif>
		<cfreturn searchRecords(stSearch, Arguments.Format, Arguments.OrderByList)>
	</cffunction>

	<cffunction name="searchRecords" access="public" returntype="any" output="No">
	<cfargument name="Record" type="struct" required="No">
	<cfargument name="Format" type="string" required="No">
	<cfargument name="OrderByList" type="string" required="No">
	<cfargument name="ExactMatch" type="boolean" required="No">
		<cfset var qryRecords = queryNew(This.ViewColumns)>
		<cfif NOT isDefined("Arguments.Record")><cfset Arguments.Record = structNew()></cfif>
		<cfif NOT isDefined("Arguments.Format")><cfset Arguments.Format = This.Format></cfif>
		<cfif NOT isDefined("Arguments.OrderByList")><cfset Arguments.OrderByList = This.SortColumn & " " & This.SortOrder></cfif>
		<cfif NOT isDefined("Arguments.ExactMatch")><cfset Arguments.ExactMatch = 1></cfif>
		<cfswitch expression="#Arguments.Format#">
			<cfcase value="struct">
				<cfset qryRecords = searchRecordsAsStructure(Arguments.Record, Arguments.OrderByList, Arguments.ExactMatch)>
			</cfcase>
			<cfcase value="xml">
				<cfset qryRecords = searchRecordsAsXml(Arguments.Record, Arguments.OrderByList, Arguments.ExactMatch)>
			</cfcase>
			<cfdefaultcase>
				<cfset qryRecords = searchRecordsAsQuery(Arguments.Record, Arguments.OrderByList, Arguments.ExactMatch)>
			</cfdefaultcase>
		</cfswitch>
		<cfreturn qryRecords>
	</cffunction>
	
	<cffunction name="searchRecordsAsQuery" access="public" returntype="query" output="No">
	<cfargument name="Record" type="struct" required="Yes">
	<cfargument name="OrderByList" type="string" required="No">
	<cfargument name="ExactMatch" type="boolean" required="No">
		<cfset var qryRecords = queryNew(This.ViewColumns)>
		<cfif NOT isDefined("Arguments.OrderByList")><cfset Arguments.OrderByList = This.SortColumn & " " & This.SortOrder></cfif>
		<cfif NOT isDefined("Arguments.ExactMatch")><cfset Arguments.ExactMatch = 1></cfif>
		
		<cfset LoopList = This.ViewColumns>
		<cfif trim(This.DESCColumn) IS NOT "">
			<cfset LoopList = LoopList & "," & This.DESCColumn>
		</cfif>
		<cfif trim(This.LINENOColumn) IS NOT "">
			<cfset LoopList = LoopList & "," & This.LINENOColumn>
		</cfif>

		<cfquery datasource="#This.DataSourceName#" name="qryRecords" result="result_name">
		SELECT 	#This.ViewColumns#
			<cfif trim(This.DESCColumn) IS NOT "">
				, [#This.DESCColumn#]
			</cfif>
			<cfif trim(This.LINENOColumn) IS NOT "">
				, [#This.LINENOColumn#]
			</cfif>
		FROM 	#This.ViewName#
		WHERE 	
			<cfif This.GenerateUUIDKey EQ 1>
				#This.PrimaryKey# <> ''
			<cfelse>
				0=0
			</cfif>
			<cfloop list="#LoopList#" index="Column">
				<cfif structKeyExists(Arguments.Record, Column)>
					<cfset ColumnValue = Arguments.Record[Column]>
					<cfif Arguments.ExactMatch EQ 0 AND trim(ColumnValue) IS NOT "">
						<cfif Column IS This.DESCColumn OR Column IS This.LINENOColumn>
							AND [#Column#] LIKE '%#trim(ColumnValue)#%'
						<cfelse>
							AND #Column# LIKE '%#trim(ColumnValue)#%'
						</cfif>
					<cfelse>
						<cfif Column IS This.DESCColumn OR Column IS This.LINENOColumn>
							AND [#Column#] = '#ColumnValue#'
						<cfelseif isNumeric(Column) EQ 1 AND ColumnValue NEQ 0>
							AND #Column# = #ColumnValue#
						<cfelseif trim(ColumnValue) IS NOT "">
							AND #Column# = '#ColumnValue#'
						</cfif>
					</cfif>
				</cfif>
			</cfloop>
		ORDER BY #Arguments.OrderByList# 
		</cfquery>
<!---<cfdump var="#result_name#"><cfabort>--->
		<cfreturn qryRecords>
	</cffunction>
	
	<cffunction name="searchRecordsAsStructure" access="public" returntype="struct" output="No">
	<cfargument name="Record" type="struct" required="Yes">
	<cfargument name="OrderByList" type="string" required="No">
	<cfargument name="ExactMatch" type="boolean" required="No">
		<cfset var stRecords = structNew()>
		<cfif NOT isDefined("Arguments.OrderByList")><cfset Arguments.OrderByList = This.SortColumn & " " & This.SortOrder></cfif>
		<cfif NOT isDefined("Arguments.ExactMatch")><cfset Arguments.ExactMatch = 1></cfif>
		<cfset qryRecords = searchRecordsAsQuery(Arguments.Record, Arguments.OrderByList, Arguments.ExactMatch)>
		<cfoutput query="qryRecords">
			<cfset stRecord = structNew()>
			<cfloop list="#qryRecords.ColumnList#" index="Column">
				<cfset structInsert(stRecord, Column, evaluate(Column), True)>
			</cfloop>
			<cfset structInsert(stRecords, evaluate(This.PrimaryKey), stRecord, True)>
		</cfoutput>
		<cfreturn stRecords>
	</cffunction>
	
	<cffunction name="searchRecordsAsXml" access="public" returntype="string" output="No">
	<cfargument name="Record" type="struct" required="Yes">
	<cfargument name="OrderByList" type="string" required="No">
	<cfargument name="ExactMatch" type="boolean" required="No">
		<cfset var XmlString = "">
		<cfif NOT isDefined("Arguments.OrderByList")><cfset Arguments.OrderByList = This.SortColumn & " " & This.SortOrder></cfif>
		<cfif NOT isDefined("Arguments.ExactMatch")><cfset Arguments.ExactMatch = 1></cfif>
		<cfset qryRecords = searchRecordsAsQuery(Arguments.Record, Arguments.OrderByList, Arguments.ExactMatch)>
		<cfxml variable="XmlDoc" casesensitive="Yes">
			<cfoutput>
			<#This.XmlRootTag#>
			</cfoutput>
				<cfoutput query="qryRecords">
					<#This.XmlChildTag#>
						<cfloop list="#qryRecords.ColumnList#" index="Column">
							<#Column#>#evaluate(Column)#</#Column#>
						</cfloop>
					</#This.XmlChildTag#>
				</cfoutput>
			<cfoutput>
			</#This.XmlRootTag#>	
			</cfoutput>		
		</cfxml>
		<cfset XmlString = toString(XmlDoc)>
		<cfreturn XmlString>
	</cffunction>
	
	<cffunction name="getRecord" access="public" returntype="any" output="No">
	<cfargument name="RecordID" type="string" required="Yes">
	<cfargument name="Format" type="string" required="No" default="struct">
		<cfswitch expression="#Arguments.Format#">
			<cfcase value="query">
				<cfset anyRecord = getRecordAsQuery(Arguments.RecordID)>
			</cfcase>
			<cfcase value="xml">
				<cfset anyRecord = getRecordAsXml(Arguments.RecordID)>
			</cfcase>
			<cfdefaultcase>
				<cfif Arguments.RecordID IS "">
					<cfset anyRecord = structNew()>
				<cfelse>
					<cfset anyRecord = getRecordAsStructure(Arguments.RecordID)>
				</cfif>
			</cfdefaultcase>
		</cfswitch>
		<cfreturn anyRecord>
	</cffunction>
	
	<cffunction name="getRecordAsStructure" access="public" returntype="struct" output="No">
	<cfargument name="RecordID" type="string" required="Yes">
		<cfset var stRecord = structNew()>
		<cfset qryRecord = getRecordAsQuery(Arguments.RecordID)>
		<cfoutput maxrows="1" query="qryRecord">
			<cfloop list="#qryRecord.ColumnList#" index="Column">
				<cfset structInsert(stRecord, Column, evaluate(Column), True)>
			</cfloop>
		</cfoutput>
		<cfreturn stRecord>
	</cffunction>
	
	<cffunction name="getRecordAsQuery" access="public" returntype="query" output="No">
	<cfargument name="RecordID" type="string" required="Yes">
		<cfset var stSearch = structNew()>
		<cfset structInsert(stSearch, This.PrimaryKey, Arguments.RecordID, True)>
		<cfreturn searchRecords(stSearch)>
	</cffunction>
	
	<cffunction name="getRecordAsXml" access="public" returntype="string" output="No">
	<cfargument name="RecordID" type="string" required="Yes">
		<cfset qryRecord = getRecordAsQuery(Arguments.RecordID)>
		<cfxml variable="XmlDoc" casesensitive="Yes">
			<cfoutput>
			<#This.XmlRootTag#>
			</cfoutput>
				<cfoutput query="qryRecord" maxrows="1">
					<#This.XmlChildTag#>
						<cfloop list="#qryRecord.ColumnList#" index="Column">
							<#Column#>#evaluate(Column)#</#Column#>
						</cfloop>
					</#This.XmlChildTag#>
				</cfoutput>
			<cfoutput>
			</#This.XmlRootTag#>	
			</cfoutput>		
		</cfxml>
		<cfset XmlString = toString(XmlDoc)>
		<cfreturn XmlString>
	</cffunction>
	
	<cffunction name="saveRecord" access="public" returntype="string" output="No">
	<cfargument name="Record" type="struct" required="No">
		<cfset var RecordID = "">
		<cfif isDefined("Arguments.Record") EQ 0>
			<cfset Arguments.Record = Request.Settings.getValue(getRecordKey())>
		</cfif>
		<cfset RecordID = Arguments.Record[This.PrimaryKey]>
		<cfif This.GenerateUUIDKey>
			<cfif RecordID EQ 0 OR trim(RecordID) IS "">
				<cfset RecordID = insertRecord(Arguments.Record)>
			<cfelse>
				<cfset RecordID = updateRecord(Arguments.Record)>
			</cfif>
		<cfelse>
			<cfset RecordID = mergeRecord(Arguments.Record)>
		</cfif>
		<cfreturn RecordID>
	</cffunction>
	
	<cffunction name="insertRecord" access="public" returntype="string" output="no">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var RecordID = "">
		<cfif This.GenerateUUIDKey>
			<cfset RecordID = createUUID()>
		<cfelse>
			<cfset RecordID = Arguments.Record[This.PrimaryKey]>
		</cfif>
		<cfif trim(This.CreatedKey) IS NOT "">
			<cfset structInsert(Arguments.Record, This.CreatedKey, createODBCDateTime(now()), True)>
		</cfif>
		<cfif trim(This.ModifiedKey) IS NOT "">
			<cfset structInsert(Arguments.Record, This.ModifiedKey, createODBCDateTime(now()), True)>
		</cfif>
<!---		
		<cfif listFindNoCase(This.Columns, "RecordCreator") NEQ 0>
			<cfset structInsert(Arguments.Record, "RecordCreator", Request.Settings.getContactID(), True)>
		</cfif>
--->		
		<cfif trim(This.SortKey) IS NOT "">
			<cfif trim(This.ParentKey) IS NOT "">
				<cfif This.TableName IS "tblConfigSystems" AND isDefined("Arguments.Record.Type") AND isDefined("Arguments.Record.DefaultSystem")>
					<cfset MaxSortOrder = getMaxSortOrder(Arguments.Record[This.ParentKey],Arguments.Record.Type,Arguments.Record.DefaultSystem)>
				<cfelse>
					<cfset MaxSortOrder = getMaxSortOrder(Arguments.Record[This.ParentKey])>
				</cfif>
			<cfelse>
				<cfset MaxSortOrder = getMaxSortOrder()>
			</cfif>
			<cfset RecordSortOrder = (MaxSortOrder + 1)>
			<cfset structInsert(Arguments.Record, This.SortKey, RecordSortOrder, True)>
		</cfif>

		<cfset RecordKeys = structKeyList(Arguments.Record)>
		<cfset NumKeys = listLen(RecordKeys)>
		
		<cfquery datasource="#This.DataSourceName#" result="result_name">
		INSERT INTO #This.TableName# (
			<cfset FirstOne = "">
			<cfloop from="1" to="#NumKeys#" step="1" index="i">
				<cfset CurrentKey = listGetAt(RecordKeys, i)>	
				<cfif CurrentKey IS This.LINENOColumn AND This.LINENOColumn IS NOT "">
					<cfif FirstOne IS NOT "">,</cfif>
					<cfset FirstOne = "found">
					[#CurrentKey#]											
				<cfelseif ListFindNoCase(This.Columns, CurrentKey) NEQ 0 AND listFindNoCase(This.ExcludeInInserts, CurrentKey) EQ 0>		
					<cfif FirstOne IS NOT "">,</cfif>
					<cfset FirstOne = "found">
					#CurrentKey#											
				</cfif>															
			</cfloop>
		)
		VALUES (
			<cfset FirstOne = "">
			<cfloop from="1" to="#NumKeys#" step="1" index="j">
				<cfset CurrentKey = listGetAt(RecordKeys, j)>
				<cfset CurrentValue = Arguments.Record[CurrentKey]>
				<cfif (CurrentKey IS This.LINENOColumn AND This.LINENOColumn IS NOT "") OR
					  (ListFindNoCase(This.Columns, CurrentKey) NEQ 0 AND listFindNoCase(This.ExcludeInInserts, CurrentKey) EQ 0)>	
					<cfif FirstOne IS NOT "">,</cfif>
					<cfset FirstOne = "found">
					<cfif CurrentKey IS This.PrimaryKey>
						'#RecordID#'
					<cfelseif CurrentKey IS "SerialNumber" OR CurrentKey IS "TransactionNumber">
						'#CurrentValue#'
					<cfelseif CurrentKey IS This.ZipCode1Key OR CurrentKey IS This.ZipCode2Key>
						'#CurrentValue#'

					<cfelseif listFindNoCase(This.QuotedInsertList, CurrentKey) NEQ 0>
						'#CurrentValue#'

					<cfelseif (CurrentKey IS This.CreatedKey) OR (CurrentKey IS This.ModifiedKey)>
						#CurrentValue#
					<cfelseif isNumeric(CurrentValue)>						
						#CurrentValue#	
					<cfelseif isDate(CurrentValue)>
						#createODBCDateTime(CurrentValue)#								
					<cfelseif (CurrentKey IS "MarkupPercentage" OR CurrentKey IS "MarkupPercent" OR 
							   CurrentKey IS "FixedPrice" OR CurrentKey IS "FixedMarkup" OR CurrentKey IS "PercentMarkup" OR 
							   CurrentKey IS "SellPrice") AND CurrentValue IS "NULL">
						NULL
					<cfelse>											
						'#CurrentValue#'											
					</cfif>
				</cfif>														
			</cfloop>
		)
		</cfquery>
		<cfreturn RecordID>
	</cffunction>
	
	<cffunction name="updateRecord" access="public" returntype="string" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var RecordID = Arguments.Record[This.PrimaryKey]>
		<cfif trim(This.ModifiedKey) IS NOT "">
			<cfset structInsert(Arguments.Record, This.ModifiedKey, createODBCDateTime(now()), True)>
		</cfif>
		<cfif trim(This.CreatedKey) IS NOT "">
			<cfset structDelete(Arguments.Record, This.CreatedKey, True)>
		</cfif>
		<cfset RecordKeys = structKeyList(Arguments.Record)>
		<cfset NumKeys = listLen(RecordKeys)>
		<cfset FirstOne = "">
		<cfquery datasource="#This.DataSourceName#">
			UPDATE #This.TableName# SET
			<cfloop from="1" to="#NumKeys#" step="1" index="i">
				<cfset CurrentKey = listGetAt(RecordKeys, i)>
				<cfset CurrentValue = Arguments.Record[CurrentKey]>
				<cfif listFindNoCase(This.ExcludeInUpdates, CurrentKey) EQ 0 AND
					  ((CurrentKey IS This.LINENOColumn AND This.LINENOColumn IS NOT "") OR
					   (listFindNoCase(This.Columns, CurrentKey) NEQ 0 ))>	
					<cfif This.SavePrimaryKey EQ 0 AND CurrentKey IS NOT This.PrimaryKey>
						<cfif FirstOne IS NOT "">,</cfif>
						<cfset FirstOne = "found">
						<cfif CurrentKey IS "SerialNumber" OR CurrentKey IS "TransactionNumber">
							#CurrentKey# = '#CurrentValue#'	
						<cfelseif CurrentKey IS This.LINENOColumn AND This.LINENOColumn IS NOT "">
							[#CurrentKey#] = '#CurrentValue#'	
						<cfelseif CurrentKey IS This.ZipCode1Key OR CurrentKey IS This.ZipCode2Key>
							#CurrentKey# = '#CurrentValue#'	
						<cfelseif listFindNoCase(This.QuotedInsertList, CurrentKey) NEQ 0>
							#CurrentKey# = '#CurrentValue#'	
						<cfelseif (CurrentKey IS This.CreatedKey) OR (CurrentKey IS This.ModifiedKey)>
							#CurrentKey# = #CurrentValue#
						<cfelseif isNumeric(CurrentValue)>
							#CurrentKey# = #CurrentValue#		
						<cfelseif isDate(CurrentValue)>
							#CurrentKey# = #createODBCDateTime(CurrentValue)#
						<cfelseif (CurrentKey IS "MarkupPercentage" OR CurrentKey IS "MarkupPercent" OR 
								   CurrentKey IS "FixedPrice" OR CurrentKey IS "FixedMarkup" OR CurrentKey IS "PercentMarkup" OR 
								   CurrentKey IS "SellPrice") AND CurrentValue IS "NULL">
							#CurrentKey# = NULL
						<cfelse>
							#CurrentKey# = '#CurrentValue#'		
						</cfif>
					<cfelse>
						<cfif FirstOne IS NOT "">,</cfif>
						<cfset FirstOne = "found">
						<cfif CurrentKey IS "SerialNumber">
							#CurrentKey# = '#CurrentValue#'	
						<cfelseif CurrentKey IS This.LINENOColumn AND This.LINENOColumn IS NOT "">
							[#CurrentKey#] = '#CurrentValue#'	
						<cfelseif CurrentKey IS This.ZipCode1Key OR CurrentKey IS This.ZipCode2Key>
							#CurrentKey# = '#CurrentValue#'		
						<cfelseif listFindNoCase(This.QuotedInsertList, CurrentKey) NEQ 0>
							#CurrentKey# = '#CurrentValue#'	
						<cfelseif isNumeric(CurrentValue)>
							#CurrentKey# = #CurrentValue#		
						<cfelseif isDate(CurrentValue)>
							#CurrentKey# = #createODBCDateTime(CurrentValue)#
						<cfelse>
							#CurrentKey# = '#CurrentValue#'		
						</cfif>
					</cfif>
				</cfif>
			</cfloop>
			WHERE #This.PrimaryKey# = <cfif isNumeric(RecordID)>#RecordID#<cfelse>'#RecordID#'</cfif>
		</cfquery>
		<cfreturn RecordID>
	</cffunction>
	
	<cffunction name="mergeRecord" access="public" returntype="string" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var RecordID = Arguments.Record[This.PrimaryKey]>
		<cfif RecordID IS NOT "">
			<cfset stRecord = getRecord(RecordID, "struct")>
			<cfif structKeyExists(stRecord, This.PrimaryKey)>
				<cfset RecordID = updateRecord(Arguments.Record)>
			<cfelse>
				<cfset RecordID = insertRecord(Arguments.Record)>
			</cfif>
		<cfelse>
			<cfset RecordID = insertRecord(Arguments.Record)>
		</cfif>
		<cfreturn RecordID>
	</cffunction>

<!---	
	<cffunction name="archiveRecord" access="public" output="No">
	<cfargument name="RecordID" type="string" required="Yes">
		<cfset deleteRecord(Arguments.RecordID)>
		<cfset deleteChildren(Arguments.RecordID)>
		<cfreturn>
	</cffunction>
--->
	
	<cffunction name="deleteRecord" access="public" output="No">
	<cfargument name="RecordID" type="string" required="Yes">
		<cfquery datasource="#This.DataSourceName#">
		Delete From #This.TableName#
		Where #This.PrimaryKey# = 
			<cfif isNumeric(Arguments.RecordID)>
				#Arguments.RecordID#
			<cfelse>
				'#Arguments.RecordID#'
			</cfif>
		</cfquery>
<!---	<cfset deleteChildren(Arguments.RecordID)>	--->
		<cfreturn>
	</cffunction>

<!---	
	<cffunction name="deleteRecords" access="public" output="No">
	<cfargument name="KeyName" type="string" required="Yes">
	<cfargument name="KeyValue" type="string" required="Yes">
		<cfquery datasource="#This.DataSourceName#">
		Delete From #This.TableName#
		Where #Arguments.KeyName# = 
			<cfif isNumeric(Arguments.KeyValue)>
				#Arguments.KeyValue#
			<cfelse>
				'#Arguments.KeyValue#'
			</cfif>
		</cfquery>
		<cfreturn>
	</cffunction>
--->

<!---	
	<cffunction name="deleteChildren" access="public" output="No">
	<cfargument name="RecordID" type="string" required="Yes">
		<cfif getCascadingTables() IS NOT "">
			<cfloop list="#getCascadingTables()#" index="Table">
				<cfquery datasource="#This.DataSourceName#">
				Delete From #Table# 
				Where #This.PrimaryKey# = 
					<cfif isNumeric(Arguments.RecordID)>
						#Arguments.RecordID#
					<cfelse>
						'#Arguments.RecordID#'
					</cfif>
				</cfquery>
			</cfloop>
		</cfif>
		<cfreturn>
	</cffunction>
--->	
	<cffunction name="validateRecord" access="public" returntype="struct" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
		<cfset var stRecord = Arguments.Record>
		<cfreturn stErrors>
	</cffunction>
	
	<cffunction name="exportRecords" access="public" output="No">
		<cfset XmlString = stSearchsAsXml(structNew())>
		<cfset XmlPath = Request.Settings.getConfigDirectory() & getPS() & "data" & getPS() & This.XmlDataFile>
		<cffile action="write" file="#XmlPath#" mode="777" output="#XmlString#">
		<cfreturn>
	</cffunction>
	
	<cffunction name="importRecords" access="public" output="No">
		<cfset qryRecords = queryNew(This.ViewColumns)>
		<cfset XmlPath = Request.Settings.getConfigDirectory() & getPS() & "data" & getPS() & This.XmlDataFile>
		<cffile action="read" file="#XmlPath#" variable="XmlString">
		<cfset XmlDoc = xmlParse(XmlString)>
		<cfset XpathString = "#This.XmlRootTag#/#This.XmlChildTag#">
		<cfset Records = xmlSearch(XmlDoc, XpathString)>
		<cfset NumRecords = arrayLen(Records)>
		<cfloop from="1" to="#NumRecords#" step="1" index="i">
			<cfset queryAddRow(qryRecords)>
			<cfloop list="#This.Columns#" index="Column">
				<cfset XmlColumn = "Records[i].#Column#[1].XmlText">
				<cfset querySetCell(qryRecords, Column, trim(evaluate(XmlColumn)))>
			</cfloop>
		</cfloop>
		<cfoutput query="qryRecords">
			<cfset stRecord = structNew()>
			<cfloop list="#qryRecords.ColumnList#" index="Column">			
				<cfset structInsert(stRecord, Column, evaluate(Column), True)>
			</cfloop>
			<cfset mergeRecord(stRecord)>
		</cfoutput>
		<cfreturn>
	</cffunction>
	
	<cffunction name="newRecord" access="public" returntype="struct" output="No">
		<cfset var stRecord = structNew()>
		<cfloop list="#This.ViewColumns#" index="Column">
			<cfset structInsert(stRecord, Column, "", True)>
		</cfloop>
		<cfreturn stRecord>
	</cffunction>
	
	<cffunction name="newQuery" access="public" returntype="query" output="No">
		<cfset var qryRecord = queryNew(This.ViewColumns)>
		<cfset queryAddRow(qryRecord)>
		<cfloop list="#This.ViewColumns#" index="Column">
			<cfset querySetCell(qryRecord, Column, "")>
		</cfloop>
		<cfreturn qryRecord>
	</cffunction>
	
	<cffunction name="getMaxSortOrder" access="public" returntype="numeric" output="No">
	<cfargument name="ParentKeyID" type="string" required="No">
		<cfset var MaxOrder = 0>
		<cfquery datasource="#This.DataSourceName#" name="qryMax">
		SELECT Max(#This.SortKey#) AS MaxSortOrder
		FROM #This.TableName#
		<cfif trim(This.ParentKey) IS NOT "" AND isDefined("Arguments.ParentKeyID")>
			WHERE #This.ParentKey# = '#Arguments.ParentKeyID#'
		</cfif> 
		</cfquery>
		<cfif qryMax.RecordCount GTE 1>
			<cfif isNumeric(qryMax.MaxSortOrder)>
				<cfset MaxOrder = qryMax.MaxSortOrder>
			</cfif>
		</cfif>
		<cfreturn MaxOrder>
	</cffunction>

	<cffunction name="sortUp" access="public" returntype="numeric" output="No">
	<cfargument name="RecordID" type="string" required="Yes">
		<cfset var NewSortOrder = 1>
		<cfset var stSearch= structNew()>
		<cfset stRecord = getRecord(Arguments.RecordID)>
		<!--- we are either going to use foreign key or parent id depeding on type of module --->

		<cfif trim(This.ParentKey) IS NOT "">
			<cfset ParentID = stRecord[This.ParentKey]>
		<cfelse>
			<cfset ParentID = "">
		</cfif>
	
		<cfset OldSortOrder = stRecord[This.SortKey]>
		
		<cfif OldSortOrder NEQ 1 AND OldSortOrder NEQ 0>
			<cfset NewSortOrder = (OldSortOrder - 1)>
			
			<!--- first get all records with the same parent or foreign key --->
			<cfif ParentID IS NOT "">
				<cfset structInsert(stSearch, This.ParentKey, ParentID, True)>
				<cfset qryGroup = searchRecords(stSearch)>
			<cfelse>
				<cfset qryGroup = listRecords()>
			</cfif>
			
			<!--- get the record this one will replace --->
			<cfquery dbType="query" name="qryHigher">
			SELECT #This.PrimaryKey#
			FROM qryGroup
			WHERE #This.SortKey# = #NewSortOrder#
			</cfquery>
			
			<!--- if it exists, knock it down --->
			<cfif qryHigher.RecordCount NEQ 0>
				<cfset PrimaryValue = "qryHigher." & This.PrimaryKey>
				<cfquery datasource="#This.DataSourceName#">
				UPDATE #This.TableName#
				SET #This.SortKey# = #OldSortOrder#
				WHERE #This.PrimaryKey# = '#evaluate(PrimaryValue)#'
				</cfquery>
			</cfif>
		<cfelse>
			<cfset NewSortOrder = OldSortOrder>
		</cfif>
		
		<!--- make this update to this record --->
		<cfquery datasource="#This.DataSourceName#">
		UPDATE #This.TableName#
		SET #This.SortKey# = #NewSortOrder#
		WHERE #This.PrimaryKey# = '#Arguments.RecordID#'
		</cfquery>
		<cfreturn NewSortOrder>
	</cffunction>
	
	<cffunction name="sortDown" access="public" returntype="numeric" output="No">
	<cfargument name="RecordID" type="string" required="Yes">
		<cfset var NewSortOrder = 1>
		<cfset var MaxSortOrder = 1>
		<cfset var stSearch = structNew()>
		<!--- fetch information about this task --->
		<cfset stRecord = getRecord(Arguments.RecordID)>

		<cfif trim(This.ParentKey) IS NOT "">
			<cfset ParentID = stRecord[This.ParentKey]>
		<cfelse>
			<cfset ParentID = "">
		</cfif>
		
		<cfset OldSortOrder = stRecord[This.SortKey]>
		
		<!--- get the highest sort order --->
		<cfset MaxSortOrder = getMaxSortOrder(ParentID)>

		<cfif OldSortOrder NEQ MaxSortOrder>
			<cfset NewSortOrder = (OldSortOrder + 1)>
					
			<!--- first get all records with the same parent or foreign key --->
			<cfif ParentID IS NOT "">
				<cfset structInsert(stSearch, This.ParentKey, ParentID, True)>
				<cfset qryGroup = searchRecords(stSearch)>
			<cfelse>
				<cfset qryGroup = listRecords()>
			</cfif>
		
			<!--- get the record this one will replace --->
			<cfquery dbType="query" name="qryHigher">
			SELECT #This.PrimaryKey#
			FROM qryGroup
			WHERE #This.SortKey# = #NewSortOrder#
			</cfquery>
			
			<!--- if it exists, knock it up --->
			<cfif qryHigher.RecordCount NEQ 0>
				<cfset PrimaryValue = "qryHigher." & This.PrimaryKey>
				<cfquery datasource="#This.DataSourceName#">
				UPDATE #This.TableName#
				SET #This.SortKey# = #OldSortOrder#
				WHERE #This.PrimaryKey# = '#evaluate(PrimaryValue)#'
				</cfquery>
			</cfif>
		<cfelse>
			<cfset NewSortOrder = OldSortOrder>
		</cfif>
		
		<!--- make this update to this Record --->
		<cfquery datasource="#This.DataSourceName#">
		UPDATE #This.TableName#
		SET #This.SortKey# = #NewSortOrder#
		WHERE #This.PrimaryKey# = '#Arguments.RecordID#'
		</cfquery>
		<cfreturn NewSortOrder>
	</cffunction>
	
	<cffunction name="listChildren" access="public" returntype="any" output="No">
	<cfargument name="RecordID" type="string" required="No">
	<cfargument name="Format" type="string" required="No">
	<cfargument name="SortColumn" type="string" required="No">
	<cfargument name="SortOrder" type="string" required="No">
	<cfargument name="ExactMatch" type="boolean" required="No">
		<cfset var qryRecords = queryNew(This.ViewColumns)>
		<cfset var stSearch = structNew()>
		<cfif NOT isDefined("Arguments.Record")><cfset Arguments.Record = structNew()></cfif>
		<cfif NOT isDefined("Arguments.Format")><cfset Arguments.Format = This.Format></cfif>
		<cfif NOT isDefined("Arguments.SortColumn")><cfset Arguments.SortColumn = This.SortColumn></cfif>
		<cfif NOT isDefined("Arguments.SortOrder")><cfset Arguments.SortOrder = This.SortOrder></cfif>
		<cfif NOT isDefined("Arguments.ExactMatch")><cfset Arguments.ExactMatch = 0></cfif>
		<cfset structInsert(stSearch, This.ParentKey, Arguments.RecordID, True)>
		<cfset qryRecords = searchRecords(stSearch, Arguments.Format, Arguments.SortColumn, Arguments.SortOrder, Arguments.ExactMatch)>
		<cfreturn qryRecords>
	</cffunction>
	
	<cffunction name="isDefaultRecord" access="public" returntype="boolean" output="No">
	<cfargument name="RecordID" type="string" required="Yes">
		<cfset var Default = 0>
		<cfif trim(This.DefaultKey) IS NOT "">
			<cfset stRecord = getRecord(Arguments.RecordID)>
			<cfif structKeyExists(stRecord, This.DefaultKey)>
				<cfif isBoolean(stRecord[This.DefaultKey])>
					<cfset Default = stRecord[This.DefaultKey]>
				</cfif>
			</cfif>
		</cfif>
		<cfreturn Default>
	</cffunction>
	
	<cffunction name="makeDefaultRecord" access="public" returntype="void" output="No">
	<cfargument name="RecordID" type="string" required="Yes">
		<cfif trim(This.DefaultKey) IS NOT "">
			<cfset stRecord = getRecord(Arguments.RecordID)>
			<cfif structKeyExists(stRecord, This.DefaultKey)>
				<cfset structInsert(stRecord, This.DefaultKey, 1, True)>
			</cfif>
			<cfset saveRecord(stRecord)>
		</cfif>
		<cfreturn>
	</cffunction>
	
	<cffunction name="recordExists" access="public" returntype="boolean" output="No">
	<cfargument name="RecordID" type="string" required="Yes">
		<cfset var RecordFound = 0>
		<cfquery datasource="#This.DataSourceName#" name="qryFound">
		Select #This.PrimaryKey# From #This.TableName#
		Where #This.PrimaryKey# = '#Arguments.RecordID#'
		</cfquery>
		<cfif qryFound.RecordCount GTE 1><cfset RecordFound = 1></cfif>
		<cfreturn RecordFound>
	</cffunction>
	
	<cffunction name="getJoinBoxID" access="public" returntype="string" output="No">
	<cfargument name="JoinBoxID1" type="string" required="Yes">
	<cfargument name="JoinBoxID2" type="string" required="Yes">
		<cfset var PrimaryID = "">
		<cfif trim(This.JoinBoxKey1) IS NOT "" AND trim(This.JoinBoxKey2) IS NOT "">
			<cfset stSearch = structNew()>
			<cfset stSearch[This.JoinBoxKey1] = Arguments.JoinBoxID1>
			<cfset stSearch[This.JoinBoxKey2] = Arguments.JoinBoxID2>
			<cfset qryResults = searchRecords(stSearch)>
			<cfif qryResults.RecordCount GTE 1>
				<cfoutput maxrows="1" query="qryResults">
					<cfset PrimaryID = evaluate(This.PrimaryKey)>
				</cfoutput>
			</cfif>
		</cfif>
		<cfreturn PrimaryID>
	</cffunction>

<!---===============================================================--->
<!--- 						CUSTOM FUNCTIONS 						--->
<!---===============================================================--->

	<cffunction name="setMessage" access="public" output="No">
	<cfargument name="Message" type="string" required="yes">
		<cfset setSessionValue("Message", Arguments.Message)>
		<cfreturn>
	</cffunction>

	<cffunction name="getMessage" access="public" returntype="string" output="No">
		<cfset MessageText = getSessionValue("Message")>
		<cfset setMessage("")>
		<cfreturn MessageText>
<!---	<cfreturn getSessionValue("Message")>	--->
	</cffunction>

	<cffunction name="setDataRecord" access="public" returntype="void" output="No">
	<cfargument name="Record" type="struct" required="Yes">
<!---	<cfset setSessionValue("ValidateDataRecord", Arguments.Record)>	--->
		<cfset setSessionValue(This.DataRecordName, Arguments.Record)>
		<cfreturn>
	</cffunction>

	<cffunction name="getDataRecord" access="public" returntype="struct" output="No">
		<cfset var stRecord = structNew()>
<!---	<cfif isStruct(getSessionValue("ValidateDataRecord")) EQ 1>	--->
		<cfif isStruct(getSessionValue(This.DataRecordName)) EQ 1>
<!---		<cfset stRecord = getSessionValue("ValidateDataRecord")>	--->
			<cfset stRecord = getSessionValue(This.DataRecordName)>
		</cfif>
		<cfreturn stRecord>
	</cffunction>

	<cffunction name="setErrorRecord" access="public" returntype="void" output="No">
	<cfargument name="Record" type="struct" required="Yes">
<!---	<cfset setSessionValue("ValidateErrorRecord", Arguments.Record)>	--->
		<cfset setSessionValue(This.ErrorRecordName, Arguments.Record)>
		<cfreturn>
	</cffunction>

	<cffunction name="getErrorRecord" access="public" returntype="struct" output="No">
		<cfset var stRecord = structNew()>
<!---	<cfif isStruct(getSessionValue("ValidateErrorRecord")) EQ 1>	--->
		<cfif isStruct(getSessionValue(This.ErrorRecordName)) EQ 1>
<!---		<cfset stRecord = getSessionValue("ValidateErrorRecord")>	--->
			<cfset stRecord = getSessionValue(This.ErrorRecordName)>
		</cfif>
		<cfreturn stRecord>
	</cffunction>

	<cffunction name="setSessionValue" access="public" returntype="void" output="No">
	<!---- set a value into the Session scope safely --->
	<cfargument name="Key" type="string" required="Yes">
	<cfargument name="Value" type="any" required="Yes">
		<cflock scope="Session" type="Exclusive" timeout="30">
			<cfset Session[Arguments.Key] = Arguments.Value>
		</cflock>
		<cfreturn>
	</cffunction>

	<cffunction name="getSessionValue" access="public" returntype="any" output="No">
	<!--- retrieve a value from the Session scope safely --->
	<cfargument name="Key" type="string" required="Yes">
		<cfset var Value = "">
		<cflock scope="Session" type="ReadOnly" timeout="30">
			<cfif structKeyExists(Session, Arguments.Key)>
				<cfset Value = Session[Arguments.Key]>
			</cfif>
		</cflock>
		<cfreturn Value>
	</cffunction>
		
	<cffunction name="formatDate" access="public" returntype="string" output="No">
	<cfargument name="DateText" type="string" required="Yes">
		<cfset var FormattedDate = "">
		<cfset DateToFormat = trim(Arguments.DateText)>
		<cfset FormattedDate = mid(DateToFormat, 5, 2) & "/" & mid(DateToFormat, 7, 2) & "/" & mid(DateToFormat, 1, 4)>
		<cfreturn FormattedDate>
	</cffunction>

	<cffunction name="formatDateToInteger" access="public" returntype="numeric" output="no">
	<!--- Takes in a Date, formats it to "yyyymmdd" integer format that ACCPAC recognizes --->
	<cfargument name="DateText" type="string" required="Yes">
		<cfset var FormattedDate = 0>
		<cfset DateToFormat = trim(Arguments.DateText)>
		<cfset StartIndex = 1>
		<cfset MonthString = "">
		<cfset DayString = "">
		<cfset YearString = "">
		<cfloop from="1" to="#len(DateToFormat)#" step="1" index="i">
			<cfif NOT isNumeric(mid(DateToFormat,i,1)) OR i EQ len(DateToFormat)>
				<cfif MonthString IS "">
					<cfset MonthString = mid(DateToFormat,StartIndex,(i-StartIndex))>
				<cfelseif DayString IS "">
					<cfset DayString = mid(DateToFormat,StartIndex,(i-StartIndex))>
				<cfelse>
					<cfset YearString = mid(DateToFormat,StartIndex,(i-StartIndex+1))>
				</cfif>
				<cfset StartIndex = i + 1>
			</cfif>
		</cfloop>
		<cfif len(MonthString) EQ 1>
			<cfset MonthString = "0" & MonthString>
		<cfelseif len(MonthString) NEQ 2>
			<cfset MonthString = right(MonthString,2)>
		</cfif>
		<cfif len(DayString) EQ 1>
			<cfset DayString = "0" & DayString>
		<cfelseif len(DayString) NEQ 2>
			<cfset DayString = right(DayString,2)>
		</cfif>
		<cfif len(YearString) EQ 1>
			<cfset YearString = "200" & YearString>
		<cfelseif len(YearString) EQ 2>
			<cfset YearString = "20" & YearString>
		<cfelseif len(YearString) EQ 3>
			<cfset YearString = "2" & YearString>
		<cfelseif len(YearString) GT 4>
			<cfset YearString = right(YearString,4)>
		</cfif>
		<cfset FormattedString = YearString & MonthString & DayString>
		<cfset FormattedDate = FormattedString>
		<cfreturn FormattedDate>
	</cffunction>


	<!--------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="getSerializedLines" access="public" returntype="query" output="No">
	<!--- Returns a query of serialized items --->
	<cfargument name="RecordID" type="string" required="Yes">
		<cfset var qryRecords = queryNew(This.ViewColumns)>
		<cfquery datasource="#This.DataSourceName#" name="qryRecords">
		SELECT 	#This.ViewName#.*
		FROM 	#This.ViewName#, dbo.ICITEM
		WHERE 	#This.PrimaryKey# = '#Arguments.RecordID#' AND
				#This.ViewName#.#This.ITEMNOKey# = dbo.ICITEM.ITEMNO AND
				dbo.ICITEM.OPTFLD1 = 'Y'
		ORDER BY #This.ViewName#.#This.SortColumn# #This.SortOrder#
		</cfquery>
		<cfreturn qryRecords>
	</cffunction>

	<!--------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="getSerializedLinesQuantity" access="public" returntype="query" output="No">
	<!---	Returns a query of items meeting the following criteria:
				o the item is a serialized item
				o the quanity is greater than zero	--->
	<cfargument name="RecordID" type="string" required="Yes">
		<cfset var qryRecords = queryNew(This.ViewColumns)>
		<cfquery datasource="#This.DataSourceName#" name="qryRecords">
		SELECT 	#This.ViewName#.*
		FROM 	#This.ViewName#, dbo.ICITEM
		WHERE 	#This.PrimaryKey# = '#Arguments.RecordID#' AND
				#This.ViewName#.#This.ITEMNOKey# = dbo.ICITEM.ITEMNO AND
				dbo.ICITEM.OPTFLD1 = 'Y' AND
				#This.ViewName#.#This.QuantityKey# > 0
		ORDER BY #This.ViewName#.#This.SortColumn# #This.SortOrder#
		</cfquery>
		<cfreturn qryRecords>
	</cffunction>

	<!--------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="getPostedFlag" access="public" returntype="string" output="No">
	<cfargument name="HeaderKey" type="string" required="Yes">
	<cfargument name="DetailKey" type="string" required="Yes">
		<cfset var PostedFlag = "">
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, This.ForeignHeaderKey, Arguments.HeaderKey, True)>
		<cfset structInsert(SearchRecord, This.ForeignDetailKey, Arguments.DetailKey, True)>
		<cfset qryRecords = searchRecords(SearchRecord, "query")>
		<cfif qryRecords.RecordCount EQ 0>
			<cfset PostedFlag = "No Serial Numbers">
		<cfelseif qryRecords.Posted EQ 1>
			<cfset PostedFlag = "Serial Numbers Posted">	
		<cfelse>
			<cfset PostedFlag = "Serial Numbers (" & qryRecords.RecordCount &")">	
		</cfif>
		<cfreturn PostedFlag>
	</cffunction>

	<cffunction name="getPostedFlagAlternate" access="public" returntype="string" output="No">
	<cfargument name="HeaderKey" type="string" required="Yes">
	<cfargument name="DetailKey" type="string" required="Yes">
	<cfargument name="LineQuantity" type="numeric" required="No">
		<cfset var PostedFlag = "">
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, This.ForeignHeaderKey, Arguments.HeaderKey, True)>
		<cfset structInsert(SearchRecord, This.ForeignDetailKey, Arguments.DetailKey, True)>
		<cfset qryRecords = searchRecords(SearchRecord, "query")>
		<cfset NumberOfPostedOnes = 0>
		<cfloop query="qryRecords">
			<cfif qryRecords.Posted EQ 1>
				<cfset NumberOfPostedOnes = NumberOfPostedOnes + 1>
			</cfif>
		</cfloop>
		<cfif qryRecords.RecordCount EQ 0>
			<cfset PostedFlag = "No Serial Numbers">
		<cfelseif NumberOfPostedOnes GE Arguments.LineQuantity>
			<cfset PostedFlag = "Serial Numbers Posted">
		<cfelse>
			<cfset PostedFlag = "Serial Numbers (" & qryRecords.RecordCount &")">	
		</cfif>
		<cfreturn PostedFlag>
	</cffunction>
	
	<cffunction name="checkForErrors" access="public" returntype="struct" output="No">
	<!---
	If the same serial number is entered in two or more of the serial number fields, 
	the serial number entry page is redisplayed with an error message indicating that 
	duplicate entries were made.  
	--->
	<!--- 6/5/06: This function is no longer being called; checking for dupliactes is now being 
		  performed by the scanning JavaScript.  -Ron Barth --->
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
		<cfset RecordList = structKeyList(Arguments.Record)>
		<cfloop list="#RecordList#" index="SNColumn">
			<cfif findNoCase("SN_", SNColumn) NEQ 0>
				<cfset SNValue = trim(Arguments.Record[SNColumn])>
				<cfif SNValue IS NOT "">
					<cfloop list="#RecordList#" index="SNColumnCompare">
						<cfset SNCompareValue = trim(Arguments.Record[SNColumnCompare])>
						<cfif findNoCase("SN_", SNColumnCompare) NEQ 0 AND
							  SNColumnCompare IS NOT SNColumn AND
							  SNValue IS SNCompareValue>
							<cfset structInsert(stErrors, "DuplicatesFound", 1, True)>
							<cfset structInsert(stErrors, SNColumn, "Error", True)>
						</cfif>
					</cfloop>
				</cfif>
			</cfif>
		</cfloop>
		<cfreturn stErrors>
	</cffunction>

	<cffunction name="checkForBatchItemError" access="public" returntype="struct" output="no">
	<!--- if the item is identified as a "batch number item", make sure that the same entry is made 
	in all of the serial number input boxes.  If not, the serial number entry page is redisplayed 
	with an error message --->
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
		<cfset objScannerBatchItems = createObject("component", "admin.assets.cfcs.ScannerBatchItems")>
		<cfif NOT isDefined("Arguments.Record.StartBoxNumber")>
			<cfset Arguments.Record.StartBoxNumber = 1>
		</cfif>
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ITEMNO", Arguments.Record[This.ITEMNOKey], True)>
		<cfset qryScannerBatchItems = objScannerBatchItems.searchRecords(SearchRecord, "query")>
		<cfif qryScannerBatchItems.RecordCount GT 0>
			<cfset FirstSerialNumberField = "SN_" & Arguments.Record.StartBoxNumber>
			<cfset FirstSerialNumber = trim(Arguments.Record[FirstSerialNumberField])>
			<cfif FirstSerialNumber IS NOT "">
				<cfset RecordList = structKeyList(Arguments.Record)>
				<cfloop list="#RecordList#" index="SNColumn">
					<cfif findNoCase("SN_", SNColumn) NEQ 0>
						<cfset SNValue = trim(Arguments.Record[SNColumn])>
						<cfif SNValue IS NOT "" AND SNValue IS NOT FirstSerialNumber>
							<cfset structInsert(stErrors, "BatchItemError", 1, True)>
							<cfset structInsert(stErrors, SNColumn, "Error", True)>
						</cfif>
					</cfif>
				</cfloop>
			</cfif>
		</cfif>
		<cfreturn stErrors>
	</cffunction>

	<!---------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="saveSerialNumberInput" access="public" output="no">
	<cfargument name="Record" type="struct" required="Yes">
	<cfargument name="UnpostedOnly" type="boolean" required="no">
    	<cfset var BoxNumberValue = "">
        <cfset var qrySNExists = queryNew("")>

		<!--- Save the serial numbers to their respective input table: tblSerialsReceipts,
			  tblSerialsShipments, etc. --->
		<cfset RecordList = structKeyList(Arguments.Record)>
		
		<cfif NOT isDefined("Arguments.UnpostedOnly")>
			<cfset Arguments.UnpostedOnly = 0>
		</cfif>

		<!--- First, delete all existing entries --->
        <!--- RAB 8/22/2012 --->
        <cfif This.TableName IS NOT "tblSerialsShipments">
			<cfset deleteSerialNumbers(Arguments.Record, Arguments.UnpostedOnly)>
        </cfif>

		<!--- 1/31/07 BUG CHECKING --->
		<cfset qryNewRecords = queryNew("NEWSerialNumber")>
		
		<!--- Then, add the new ones --->
		<cfloop list="#RecordList#" index="SNColumn">
			<cfif findNoCase("SN_", SNColumn) NEQ 0>
            
            	<cfset BoxNumberValue = removeChars(trim(SNColumn), 1, 3)>
				<cfset SNValue = trim(ucase(Arguments.Record[SNColumn]))>
                
				<cfif trim(SNValue) IS NOT "">
                
                    <!--- RAB 08/22/2012 Does the SN already exist? --->
                    <cfif This.TableName IS "tblSerialsShipments">
                        <cfquery datasource="#This.DataSourceName#" name="qrySNExists">
                        SELECT	SerialsShipmentsID
                        FROM 	tblSerialsShipments
                        WHERE 	ORDUNIQ = '#Arguments.Record[This.ForeignHeaderKey]#' AND
                        		ORDLINENUM = '#Arguments.Record[This.ForeignDetailKey]#' AND
                                BoxNumber = '#BoxNumberValue#'
                        </cfquery>

                        <cfif qrySNExists.RecordCount NEQ 0>
                            <cfquery datasource="#This.DataSourceName#">
                            UPDATE 	tblSerialsShipments
                            SET		SerialNumber = '#trim(SNValue)#'
                            WHERE 	SerialsShipmentsID = '#trim(qrySNExists.SerialsShipmentsID)#'
                            </cfquery>

                        <cfelse>
                            <cfquery datasource="#This.DataSourceName#">
                            INSERT INTO tblSerialsShipments (
                                SerialsShipmentsID, 
                                ORDUNIQ,
                                ORDLINENUM,
                                ORDNUMBER,
                                SerialNumber,
                                BoxNumber)
                            VALUES (
                                '#createUUID()#', 
                                '#Arguments.Record[This.ForeignHeaderKey]#',
                                '#Arguments.Record[This.ForeignDetailKey]#',
                                '#Arguments.Record[This.OrderNumberKey]#',
                                '#trim(SNValue)#',
                                '#trim(BoxNumberValue)#'
                                )
                            </cfquery>
                        </cfif>

					<cfelse>


						<cfset strRecord = structNew()>
                        <cfset structInsert(strRecord, This.PrimaryKey, "", True)>
                        <cfset structInsert(strRecord, This.ForeignHeaderKey, Arguments.Record[This.ForeignHeaderKey], True)>
                        <cfset structInsert(strRecord, This.ForeignDetailKey, Arguments.Record[This.ForeignDetailKey], True)>
                        <cfif This.OrderNumberKey IS NOT "">
                            <cfset structInsert(strRecord, This.OrderNumberKey, Arguments.Record[This.OrderNumberKey], True)>
                        </cfif>
                        <cfif This.SortOrderKey IS NOT "">
                            <cfset NewSortOrder = removeChars(SNColumn,1,3)>
                            <cfset structInsert(strRecord, This.SortOrderKey, NewSortOrder, True)>
                        </cfif>
                        <cfset structInsert(strRecord, "SerialNumber", trim(SNValue), True)>

                        <cfset saveRecord(strRecord)>

                    </cfif>


					<!--- 1/31/07 BUG CHECKING --->
					<cfset queryAddRow(qryNewRecords)>
					<cfset querySetCell(qryNewRecords, "NEWSerialNumber", SNValue)>
					
				</cfif>
			</cfif>
		</cfloop>


		<!--- 1/31/07 BUG CHECKING --->
<!---		
		<cfif This.TableName IS "tblSerialsShipments">
			<cfset objScannerBatchItems = createObject("component", "admin.assets.cfcs.ScannerBatchItems")>
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "ITEMNO", Arguments.Record.ITEM, True)>
			<cfset qryScannerBatchItems = objScannerBatchItems.searchRecords(SearchRecord, "query")>
			<cfif qryScannerBatchItems.RecordCount LE 0>
				
				<cfquery dbtype="query" name="qryFinal">
				SELECT 	*
				FROM 	qryNewRecords
				ORDER BY NEWSerialNumber
				</cfquery>
				
				<cfset CurrentSerialNumber = "">
				<cfset PossibleError = 0>
				<cfloop query="qryFinal">
					<cfif trim(qryFinal.NEWSerialNumber) IS trim(CurrentSerialNumber)>
						<cfset PossibleError = 1>
					<cfelse>
						<cfset CurrentSerialNumber = trim(qryFinal.NEWSerialNumber)>
					</cfif>
				</cfloop>
				
				<cfif PossibleError>
					<cfmail from="Nor-Tech <info@nor-tech.com>" to="ron_barth@altsystem.com" subject="POSSIBLE BUG . . ." type="html" timeout="60">Hey Ron: check it out:  There are two identical serial numbers posted on this order line, and it's not a batch number item.  Could be the bug you're looking for.<br>Order Number: #Arguments.Record.ORDNUMBER#<br>Item: #Arguments.Record.ITEM#<br>Order Line Number: #Arguments.Record.ORDLINENUM#<br>
						Here's Arguments.Record:<br>
						<cfdump var="#Arguments.Record#"><br>
						Here's RecordList:<br>
						#RecordList#<br>
					</cfmail>
				</cfif>
			</cfif>
		</cfif>
--->		
		
	</cffunction>

	<cffunction name="deleteSerialNumbers" access="public" output="no">
	<cfargument name="Record" type="struct" required="Yes">
	<cfargument name="UnpostedOnly" type="boolean" required="no">
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, This.ForeignHeaderKey, Arguments.Record[This.ForeignHeaderKey], True)>
		<cfset structInsert(SearchRecord, This.ForeignDetailKey, Arguments.Record[This.ForeignDetailKey], True)>
		<cfif isDefined("Arguments.UnpostedOnly") AND Arguments.UnpostedOnly EQ 1>
			<cfset structInsert(SearchRecord, "Posted", 0, True)>
		</cfif>
		<cfset qryRecords = searchRecords(SearchRecord, "query")>
		<cfloop query="qryRecords">
			<cfset RecordID = qryRecords[This.PrimaryKey]>
			<cfset deleteRecord(RecordID)>
		</cfloop>
	</cffunction>

	<cffunction name="setPosted" access="public" output="No">
	<!--- Set the posted flag --->
	<cfargument name="Record" type="struct" required="Yes">
	<cfargument name="OrderPosting" type="boolean" required="no">
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, This.ForeignHeaderKey, Arguments.Record[This.ForeignHeaderKey], True)>
		<cfset structInsert(SearchRecord, This.ForeignDetailKey, Arguments.Record[This.ForeignDetailKey], True)>
		<cfset qryRecords = searchRecords(SearchRecord, "query")>
		<cfloop query="qryRecords">
			<cfset RecordID = qryRecords[This.PrimaryKey]>
			<cfset strRecord = getRecord(RecordID)>
			<cfset structInsert(strRecord, "Posted", 1, True)>
			<cfif isDefined("Arguments.OrderPosting") AND Arguments.OrderPosting EQ 1>
				<cfset structDelete(strRecord, "SHIUNIQ")>
				<cfset structDelete(strRecord, "LINENUM")>
				<cfset structDelete(strRecord, "INVUNIQ")>
				<cfset structDelete(strRecord, "INVLINENUM")>
			</cfif>
			<cfset saveRecord(strRecord)>
		</cfloop>
	</cffunction>

	<cffunction name="addSerialNumbers" access="public" output="no">
	<!--- Save the serial numbers to the master serial number list, tblSerials --->
	<cfargument name="Record" type="struct" required="Yes">
	<cfargument name="UnpostedOnly" type="boolean" required="no">
		<cfset objSerials = createObject("component", "admin.assets.cfcs.Serials")>
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, This.ForeignHeaderKey, Arguments.Record[This.ForeignHeaderKey], True)>
		<cfset structInsert(SearchRecord, This.ForeignDetailKey, Arguments.Record[This.ForeignDetailKey], True)>
		<cfif isDefined("Arguments.UnpostedOnly") AND Arguments.UnpostedOnly EQ 1>
			<cfset structInsert(SearchRecord, "Posted", 0, True)>
		</cfif>
		<cfset qryRecords = searchRecords(SearchRecord, "query")>
		<cfloop query="qryRecords">
			<cfset strRecord = structNew()>
			<cfset structInsert(strRecord, "SerialID", "", True)>
			<cfset structInsert(strRecord, "ITEMNO", Arguments.Record[This.ITEMNOKey], True)>
			<cfif isDefined("Arguments.Record.LOCATION")>
				<cfset structInsert(strRecord, "LOCATION", Arguments.Record.LOCATION, True)>
			</cfif>
			<cfset structInsert(strRecord, "SerialNumber", trim(qryRecords.SerialNumber), True)>
			<cfset objSerials.saveRecord(strRecord)>
		</cfloop>
	</cffunction>

	<cffunction name="removeSerialNumbers" access="public" output="no">
	<!--- Remove the serial numbers from the master serial number list, tblSerials --->
	<cfargument name="Record" type="struct" required="Yes">
	<cfargument name="UnattachedOnly" type="boolean" required="no">
	<cfargument name="UnpostedOnly" type="boolean" required="no">
		<cfset objSerials = createObject("component", "admin.assets.cfcs.Serials")>
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, This.ForeignHeaderKey, Arguments.Record[This.ForeignHeaderKey], True)>
		<cfset structInsert(SearchRecord, This.ForeignDetailKey, Arguments.Record[This.ForeignDetailKey], True)>
		<cfif isDefined("Arguments.UnattachedOnly") AND Arguments.UnattachedOnly EQ 1>
			<cfset structInsert(SearchRecord, "AttachedToInvoice", 0, True)>
		</cfif>
		<cfif isDefined("Arguments.UnpostedOnly") AND Arguments.UnpostedOnly EQ 1>
			<cfset structInsert(SearchRecord, "Posted", 0, True)>
		</cfif>
		<cfset qryRecords = searchRecords(SearchRecord, "query")>
		<cfloop query="qryRecords">
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "SerialNumber", qryRecords.SerialNumber, True)>
			<cfset structInsert(SearchRecord, "ITEMNO", Arguments.Record[This.ITEMNOKey], True)>
			<cfset qrySerials = objSerials.searchRecords(SearchRecord, "query")>
			<cfif qrySerials.RecordCount GT 0>
				<cfset objSerials.deleteRecord(qrySerials.SerialID)>
			</cfif>
		</cfloop>
	</cffunction>

	<cffunction name="updateSerialNumbers" access="public" output="no">
	<!--- If a serial number doesn’t exist and the user overruled and proceeded with the posting process, 
		  then the serial numbers are added to the master list of serial numbers.  
		  Otherwise, the location field of the serial number is changed to match the “to” location on the transfer --->
	<cfargument name="Record" type="struct" required="Yes">
		<cfset objSerials = createObject("component", "admin.assets.cfcs.Serials")>
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, This.ForeignHeaderKey, Arguments.Record[This.ForeignHeaderKey], True)>
		<cfset structInsert(SearchRecord, This.ForeignDetailKey, Arguments.Record[This.ForeignDetailKey], True)>
		<cfset qryRecords = searchRecords(SearchRecord, "query")>
		<cfloop query="qryRecords">
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "SerialNumber", trim(qryRecords.SerialNumber), True)>
			<cfset structInsert(SearchRecord, "ITEMNO", Arguments.Record[This.ITEMNOKey], True)>
			<cfset qrySerials = objSerials.searchRecords(SearchRecord, "query")>
			<cfif qrySerials.RecordCount EQ 0>
				<!--- Serial Number / Item is not found, so add it --->
				<cfset strRecord = structNew()>
				<cfset structInsert(strRecord, "SerialID", "", True)>
				<cfset structInsert(strRecord, "ITEMNO", Arguments.Record[This.ITEMNOKey], True)>
				<cfset structInsert(strRecord, "SerialNumber", ucase(qryRecords.SerialNumber), True)>
			<cfelse>
				<!--- Serial Number / Item is found, update it --->
				<cfset strRecord = objSerials.getRecord(qrySerials.SerialID)>
			</cfif>
			<cfif isDefined("Arguments.Record.TOLOC")>
				<cfset structInsert(strRecord, "LOCATION", Arguments.Record.TOLOC, True)>
			</cfif>
			<cfset objSerials.saveRecord(strRecord)>
		</cfloop>
	</cffunction>

	<cffunction name="createAuditTrail" access="public" output="no">
	<!--- Create audit trail entries in tblSerialNumberAuditTrail --->
	<cfargument name="Record" type="struct" required="Yes">
	<cfargument name="TransactionType" type="string" required="Yes">
	<cfargument name="UnattachedOnly" type="boolean" required="no">
	<cfargument name="UnpostedOnly" type="boolean" required="no">
		<cfset objSerialNumberAuditTrail = createObject("component", "admin.assets.cfcs.SerialNumberAuditTrail")>
		<cfset objAdmin = createObject("component", "admin.assets.cfcs.Admin")>

		<!--- Get all records in the input table (e.g., tblSerialsReceipts) --->
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, This.ForeignHeaderKey, Arguments.Record[This.ForeignHeaderKey], True)>
		<cfset structInsert(SearchRecord, This.ForeignDetailKey, Arguments.Record[This.ForeignDetailKey], True)>
		<cfif isDefined("Arguments.UnattachedOnly") AND Arguments.UnattachedOnly EQ 1>
			<cfset structInsert(SearchRecord, "AttachedToInvoice", 0, True)>
		</cfif>
		<cfif isDefined("Arguments.UnpostedOnly") AND Arguments.UnpostedOnly EQ 1>
			<cfset structInsert(SearchRecord, "Posted", 0, True)>
		</cfif>
		<cfset qryRecords = searchRecords(SearchRecord, "query")>
		
		<!--- Get the User --->
		<cfset qryUser = objAdmin.getRecordAsQuery(SESSION.adminuserid)>

		<!--- TransactionType:  "Receipt"
								"Order"
								"Return"
								"VendorReturn"
								"AdjustmentIncrease"
								"AdjustmentDecrease"
								"Transfer" . . . --->
		<cfset XType = Arguments.TransactionType>
		<cfif XType IS "Receipt" OR XType IS "Return" OR XType IS "AdjustmentIncrease" OR XType IS "TransferIncrease">
			<cfset AddorRemoveValue = "Add">
		<cfelseif XType IS "Order" OR XType IS "VendorReturn" OR XType IS "AdjustmentDecrease" OR XType IS "TransferDecrease">
			<cfset AddorRemoveValue = "Remove">
		<cfelse>
			<cfset AddorRemoveValue = "???">
		</cfif>
		
		<cfloop query="qryRecords">
			<cfset strRecord = structNew()>
			<cfset structInsert(strRecord, "SerialNumberAuditTrailID", "", True)>
			<cfif XType IS "AdjustmentIncrease" OR XType IS "AdjustmentDecrease">
				<cfset structInsert(strRecord, "TransactionType", "Adjustment", True)>
			<cfelseif XType IS "TransferIncrease" OR XType IS "TransferDecrease">
				<cfset structInsert(strRecord, "TransactionType", "Transfer", True)>
			<cfelse>
				<cfset structInsert(strRecord, "TransactionType", XType, True)>
			</cfif>
			<cfif isDefined("Arguments.Record.TransactionNumber")>
				<cfset structInsert(strRecord, "TransactionNumber", Arguments.Record.TransactionNumber, True)>
			</cfif>
			<cfset structInsert(strRecord, "CreationDate", "", True)>
			<cfset structInsert(strRecord, "UserFirstName", qryUser.fname, True)>
			<cfset structInsert(strRecord, "UserLastName", qryUser.lname, True)>
			<cfset structInsert(strRecord, "UserEmail", qryUser.emailaddress, True)>
			<cfif isDefined("Arguments.Record.Password")>
				<cfset structInsert(strRecord, "ApprovalPassword", Arguments.Record.Password, True)>
			</cfif>
			<cfset structInsert(strRecord, "ITEMNO", Arguments.Record[This.ITEMNOKey], True)>
			<cfset structInsert(strRecord, "ITEMDESC", getItemDescription(Arguments.Record[This.ITEMNOKey]), True)>
			<cfset structInsert(strRecord, "SerialNumber", trim(qryRecords.SerialNumber), True)>
			<cfset structInsert(strRecord, "AddorRemove", AddorRemoveValue, True)>
			<cfif isDefined("Arguments.Record.LOCATION")>
				<cfset structInsert(strRecord, "LOCATION", Arguments.Record.LOCATION, True)>
				<cfset structInsert(strRecord, "LOCATIONDESC", getLocationDescription(Arguments.Record.LOCATION), True)>
			<cfelse>
				<!--- TRANSFERS --->
				<cfif XType IS "TransferDecrease" AND isDefined("Arguments.Record.FROMLOC")>
					<cfset structInsert(strRecord, "LOCATION", Arguments.Record.FROMLOC, True)>
					<cfset structInsert(strRecord, "LOCATIONDESC", getLocationDescription(Arguments.Record.FROMLOC), True)>
				<cfelseif XType IS "TransferIncrease" AND isDefined("Arguments.Record.TOLOC")>
					<cfset structInsert(strRecord, "LOCATION", Arguments.Record.TOLOC, True)>
					<cfset structInsert(strRecord, "LOCATIONDESC", getLocationDescription(Arguments.Record.TOLOC), True)>
				</cfif>
			</cfif>
			<cfif isDefined("Arguments.Record.CUSTOMER")>
				<cfset structInsert(strRecord, "CUSTOMER", Arguments.Record.CUSTOMER, True)>
			</cfif>
			<cfif isDefined("Arguments.Record.BILNAME")>
				<cfset structInsert(strRecord, "BILNAME", Arguments.Record.BILNAME, True)>
			</cfif>
			<cfif isDefined("Arguments.Record.VDCODE")>
				<cfset structInsert(strRecord, "VDCODE", Arguments.Record.VDCODE, True)>
			</cfif>
			<cfif isDefined("Arguments.Record.VDNAME")>
				<cfset structInsert(strRecord, "VDNAME", Arguments.Record.VDNAME, True)>
			</cfif>
			<cfset structInsert(strRecord, "SerialTable", This.TableName, True)>
			<cfset structInsert(strRecord, "SerialTableIDField", This.PrimaryKey, True)>
			<cfset RecordID = qryRecords[This.PrimaryKey]>
			<cfset structInsert(strRecord, "SerialTableIDValue", RecordID, True)>
			<cfset objSerialNumberAuditTrail.saveRecord(strRecord)>
		</cfloop>

	</cffunction>

	<cffunction name="createAuditTrailCorrection" access="public" output="no">
	<!--- Create audit trail entries for Corrections --->
	<cfargument name="SerialID" type="string" required="Yes">
	<cfargument name="SerialNumber" type="string" required="Yes">
	<cfargument name="AddorRemove" type="string" required="Yes">
		<cfset objSerialNumberAuditTrail = createObject("component", "admin.assets.cfcs.SerialNumberAuditTrail")>
		<cfset objAdmin = createObject("component", "admin.assets.cfcs.Admin")>
		<cfset objSerials = createObject("component", "admin.assets.cfcs.Serials")>
		<!--- Get the User --->
		<cfset qryUser = objAdmin.getRecordAsQuery(SESSION.adminuserid)>
		<cfset strSerial = objSerials.getRecord(Arguments.SerialID)>
		
		<cfset strRecord = structNew()>
		<cfset structInsert(strRecord, "SerialNumberAuditTrailID", "", True)>
		<cfset structInsert(strRecord, "TransactionType", "Correction", True)>
		<cfset structInsert(strRecord, "CreationDate", "", True)>
		<cfset structInsert(strRecord, "UserFirstName", qryUser.fname, True)>
		<cfset structInsert(strRecord, "UserLastName", qryUser.lname, True)>
		<cfset structInsert(strRecord, "UserEmail", qryUser.emailaddress, True)>
		<cfset structInsert(strRecord, "ITEMNO", strSerial.ITEMNO, True)>
		<cfset structInsert(strRecord, "ITEMDESC", getItemDescription(strSerial.ITEMNO), True)>
		<cfset structInsert(strRecord, "SerialNumber", ucase(Arguments.SerialNumber), True)>
		<cfset structInsert(strRecord, "AddorRemove", Arguments.AddorRemove, True)>
		<cfset structInsert(strRecord, "LOCATION", strSerial.LOCATION, True)>
		<cfset structInsert(strRecord, "LOCATIONDESC", getLocationDescription(strSerial.LOCATION), True)>	
		<cfset objSerialNumberAuditTrail.saveRecord(strRecord)>
	</cffunction>

	<cffunction name="createAuditTrailDeletion" access="public" output="no">
	<!--- Create audit trail entries for Corrections --->
	<cfargument name="SerialNumber" type="string" required="Yes">
	<cfargument name="ITEMNO" type="string" required="Yes">
	<cfargument name="LOCATION" type="string" required="Yes">
	<cfargument name="TransactionNumber" type="string" required="Yes">
	<cfargument name="TransactionType" type="string" required="Yes">
	<cfargument name="AddorRemove" type="string" required="Yes">
	<cfargument name="SerialTableIDValue" type="string" required="no">
		<cfset objSerialNumberAuditTrail = createObject("component", "admin.assets.cfcs.SerialNumberAuditTrail")>
		<cfset objAdmin = createObject("component", "admin.assets.cfcs.Admin")>
		<!--- Get the User --->
		<cfset UserID = getSessionValue("adminuserid")>
		<cfset qryUser = objAdmin.getRecordAsQuery(UserID)>
		
		<cfset strRecord = structNew()>
		<cfset structInsert(strRecord, "SerialNumberAuditTrailID", "", True)>
		<cfset structInsert(strRecord, "TransactionType", Arguments.TransactionType, True)>
		<cfset structInsert(strRecord, "TransactionNumber", Arguments.TransactionNumber, True)>
		<cfset structInsert(strRecord, "CreationDate", "", True)>
		<cfset structInsert(strRecord, "UserFirstName", qryUser.fname, True)>
		<cfset structInsert(strRecord, "UserLastName", qryUser.lname, True)>
		<cfset structInsert(strRecord, "UserEmail", qryUser.emailaddress, True)>
		<cfset structInsert(strRecord, "ITEMNO", Arguments.ITEMNO, True)>
		<cfset structInsert(strRecord, "ITEMDESC", getItemDescription(Arguments.ITEMNO), True)>
		<cfset structInsert(strRecord, "SerialNumber", ucase(Arguments.SerialNumber), True)>
		<cfset structInsert(strRecord, "AddorRemove", Arguments.AddorRemove, True)>
		<cfset structInsert(strRecord, "LOCATION", Arguments.LOCATION, True)>
		<cfset structInsert(strRecord, "LOCATIONDESC", getLocationDescription(Arguments.LOCATION), True)>

		<cfif isDefined("Arguments.SerialTableIDValue")>
			<cfset structInsert(strRecord, "SerialTable", This.TableName, True)>
			<cfset structInsert(strRecord, "SerialTableIDField", This.PrimaryKey, True)>
			<cfset structInsert(strRecord, "SerialTableIDValue", Arguments.SerialTableIDValue, True)>
		</cfif>
		
		<cfset objSerialNumberAuditTrail.saveRecord(strRecord)>
	</cffunction>
	
	<!--- ************************************************************** --->
	<!---                   ACCPAC, ICITEM, Inventory                    --->
	<!--- ************************************************************** --->

	<cffunction name="itemExists" access="public" returntype="boolean" output="No">
	<cfargument name="ITEMNO" type="string" required="Yes">
		<cfset var Found = 0>

		<cfif isDefined("APPLICATION.DSN_AP")>
			<cfset CURRENT_Datasource = APPLICATION.DSN_AP>
		<cfelseif isDefined("This.ACCPACDataSourceName")>		
			<cfset CURRENT_Datasource = This.ACCPACDataSourceName>
		<cfelse>
			<cfset CURRENT_Datasource = "NorTechAP">		
		</cfif>

		<cfquery datasource="#CURRENT_Datasource#" name="qryItem">
		SELECT 	dbo.ICITEM.ITEMNO
		FROM 	dbo.ICITEM
		WHERE	dbo.ICITEM.ITEMNO = '#Arguments.ITEMNO#'
		</cfquery>
		<cfif qryItem.RecordCount GT 0>
			<cfset Found = 1>
		</cfif>
		<cfreturn Found>
	</cffunction>


	<!--------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="itemIsSerialized" access="public" returntype="boolean" output="No">
	<cfargument name="ITEMNO" type="string" required="Yes">
		<cfset var Found = 0>

		<cfif isDefined("APPLICATION.DSN_AP")>
			<cfset CURRENT_Datasource = APPLICATION.DSN_AP>
		<cfelseif isDefined("This.ACCPACDataSourceName")>		
			<cfset CURRENT_Datasource = This.ACCPACDataSourceName>
		<cfelse>
			<cfset CURRENT_Datasource = "NorTechAP">		
		</cfif>

		<cfif itemExists(Arguments.ITEMNO)>
			<cfquery datasource="#CURRENT_Datasource#" name="qryItem">
			SELECT 	dbo.ICITEM.ITEMNO
			FROM 	dbo.ICITEM
			WHERE	dbo.ICITEM.ITEMNO = '#Arguments.ITEMNO#' AND
					dbo.ICITEM.OPTFLD1 = 'Y'
			</cfquery>
			<cfif qryItem.RecordCount GT 0>
				<cfset Found = 1>
			</cfif>
		</cfif>
		<cfreturn Found>
	</cffunction>

	<!--------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="getItemDescription" access="public" returntype="string" output="No">
	<cfargument name="ItemNo" type="string" required="Yes">
		<cfset var ItemDescription = "">
		<cfif trim(Arguments.ItemNo) IS "[NONE]">
			<cfset ItemDescription = "None">
		<cfelse>
			<cfquery datasource="#APPLICATION.DSN_AP#" name="qryItem">
			SELECT 	dbo.ICITEM.[DESC]
			FROM 	dbo.ICITEM
			WHERE 	dbo.ICITEM.ITEMNO = '#Arguments.ItemNo#'
			</cfquery>
			<cfif isDefined("qryItem.Desc")>
				<cfset ItemDescription = qryItem.Desc>
			</cfif>
		</cfif>
		<cfreturn ItemDescription>
	</cffunction>

	<cffunction name="getCategory" access="public" returntype="string" output="no">
	<cfargument name="ItemNo" type="string" required="Yes">
		<cfset var Category = "">
        <cfset var qryICITEM = queryNew("")>
		<cfquery datasource="#APPLICATION.DSN_AP#" name="qryICITEM">
		SELECT 	dbo.ICITEM.CATEGORY
		FROM 	dbo.ICITEM
		WHERE 	dbo.ICITEM.ITEMNO = '#trim(Arguments.ItemNo)#'
		</cfquery>
		<cfif qryICITEM.RecordCount NEQ 0>
			<cfset Category = qryICITEM.CATEGORY>
		</cfif>
		<cfreturn Category>
	</cffunction>

	<cffunction name="getCategoryDescription" access="public" returntype="string" output="no">
	<cfargument name="ItemNo" type="string" required="Yes">
		<cfset var CategoryDescription = "">
		<cfquery datasource="#APPLICATION.DSN_AP#" name="qryICITEM">
		SELECT 	dbo.ICITEM.CATEGORY
		FROM 	dbo.ICITEM
		WHERE 	dbo.ICITEM.ITEMNO = '#Arguments.ItemNo#'
		</cfquery>
		<cfif qryICITEM.RecordCount NEQ 0>
			<cfquery datasource="#APPLICATION.DSN_AP#" name="qryICCATG">
			SELECT 	dbo.ICCATG.[DESC]
			FROM 	dbo.ICCATG
			WHERE 	dbo.ICCATG.CATEGORY = '#qryICITEM.CATEGORY#'
			</cfquery>
			<cfif qryICCATG.RecordCount NEQ 0>
				<cfset CategoryDescription = qryICCATG.DESC>
			</cfif>
		</cfif>
		<cfreturn CategoryDescription>
	</cffunction>


	<cffunction name="getItemCost" access="public" returntype="numeric" output="No">
	<!--- Send in an inventory Item Number (ITEMNO), returns the price for that item --->
	<cfargument name="ItemNo" type="string" required="Yes">
		<cfset var ItemCost = 0>
        
        <cfif isDefined("APPLICATION.DSN_AP")>
        	<cfset ThisDatasource = APPLICATION.DSN_AP>
        <cfelse>
        	<cfset ThisDatasource = "NorTechAP">        
        </cfif>
		<cfquery datasource="#ThisDatasource#" name="qryItemLocation">
		SELECT 	dbo.ICILOC.TOTALCOST, dbo.ICILOC.QTYONHAND, dbo.ICILOC.LASTCOST, dbo.ICILOC.RECENTCOST
		FROM 	dbo.ICILOC
		WHERE 	dbo.ICILOC.ITEMNO = '#Arguments.ItemNo#' AND
				dbo.ICILOC.LOCATION = '1'
		</cfquery>
		<cfif qryItemLocation.RecordCount GT 0>
			<!--- TOTALCOST/QTYONHAND, if QTYONHAND > 0 --->
			<cfif isNumeric(qryItemLocation.TOTALCOST) AND isNumeric(qryItemLocation.QTYONHAND) AND qryItemLocation.QTYONHAND GT 0>
				<cfset ItemCost = qryItemLocation.TOTALCOST / qryItemLocation.QTYONHAND>
		
			<!--- Otherwise use LAST COST, if last cost is greater than zero --->
			<cfelseif isNumeric(qryItemLocation.LASTCOST) AND qryItemLocation.LASTCOST GT 0>
				<cfset ItemCost = qryItemLocation.LASTCOST>
				
			<!--- Otherwise use RECENT COST --->
			<cfelse>
				<cfset ItemCost = qryItemLocation.RECENTCOST>
			</cfif>
		</cfif>

<!--- 3/8/07, Ron Barth:
	  When we first designed the configurator, we were told to take the base price from the selling price of the item in ACCPAC,
	  as below.  Now we are told to take it from the current cost of the item, so we changed the code to the above.	--->
<!---		
		<cfquery datasource="#APPLICATION.DSN_AP#" name="qryItem">
		SELECT 	dbo.ICITEM.DEFPRICLST
		FROM 	dbo.ICITEM
		WHERE 	dbo.ICITEM.ITEMNO = '#Arguments.ItemNo#'
		</cfquery>
		<cfif qryItem.RecordCount GT 0>
			<cfquery datasource="#APPLICATION.DSN_AP#" name="qryItemPrice">
			SELECT 	dbo.ICPRIC.BASEPRICE
			FROM 	dbo.ICPRIC
			WHERE 	dbo.ICPRIC.ITEMNO = '#Arguments.ItemNo#' AND
					dbo.ICPRIC.PRICELIST = '#qryItem.DEFPRICLST#'
			</cfquery>
			<cfif qryItemPrice.RecordCount NEQ 0 AND isDefined("qryItemPrice.BASEPRICE") AND isNumeric(qryItemPrice.BASEPRICE)>
				<cfset ItemCost = qryItemPrice.BASEPRICE>
			</cfif>
		</cfif>
--->		
		<cfreturn ItemCost>
	</cffunction>

	<cffunction name="getItemCostMarkedUp" access="public" returntype="numeric" output="no">
	<!--- Send in a ConfigComponentID, returns the marked-up price for that item --->
	<cfargument name="ConfigComponentID" type="string" required="Yes">
	<cfargument name="CustomerID" type="string" required="No">
	<cfargument name="ExportableConfigurator" type="boolean" required="No">
		<cfset var ItemCostMarkedUp = 0>

		<cfset objConfigComponents = createObject("component", "admin.assets.cfcs.config.ConfigComponents")>
		<cfset objConfigComponentsResellers = createObject("component", "admin.assets.cfcs.config.ConfigComponentsResellers")>
		<cfset objConfigComponentCategories = createObject("component", "admin.assets.cfcs.config.ConfigComponentCategories")>
		<cfset objSalesRep = createObject("component", "admin.assets.cfcs.SalesRep")>
		<cfset objCust = createObject("component", "admin.assets.cfcs.Cust")>

		<cfset strConfigComponent = objConfigComponents.getRecord(Arguments.ConfigComponentID)>
		<cfif NOT structIsEmpty(strConfigComponent)>
			<cfset ItemCost = getItemCost(strConfigComponent.ITEMNO)>
			<cfset ItemCostMarkedUp = ItemCost>
			<cfset Found = 0>
		
			<!--- Reseller-specific fixed price or markup percentage --->
			<cfif isDefined("Arguments.CustomerID") AND trim(Arguments.CustomerID) IS NOT "">
				<cfset SearchRecord = structNew()>
				<cfset structInsert(SearchRecord, "ConfigComponentID", Arguments.ConfigComponentID, True)>
				<cfset structInsert(SearchRecord, "CustomerID", Arguments.CustomerID, True)>
				<cfset qryConfigComponentsResellers = objConfigComponentsResellers.searchRecords(SearchRecord)>
				<cfif qryConfigComponentsResellers.RecordCount GT 0>
					<cfif isNumeric(qryConfigComponentsResellers.FixedPrice)>
						<cfset ItemCostMarkedUp = qryConfigComponentsResellers.FixedPrice>
						<cfset Found = 1>
					<cfelseif isNumeric(qryConfigComponentsResellers.MarkupPercentage)>
						<cfset ItemCostMarkedUp = ItemCost + ItemCost * qryConfigComponentsResellers.MarkupPercentage / 100>
						<cfset Found = 1>
					</cfif>
				</cfif>
			</cfif>
			
			<!--- Component fixed price or markup percentage --->
			<cfif NOT Found>
				<cfif isNumeric(strConfigComponent.FixedPrice)>
					<cfset ItemCostMarkedUp = strConfigComponent.FixedPrice>
					<cfset Found = 1>
				<cfelseif isNumeric(strConfigComponent.MarkupPercentage)>
					<cfset ItemCostMarkedUp = ItemCost + ItemCost * strConfigComponent.MarkupPercentage / 100>
					<cfset Found = 1>
				</cfif>
			</cfif>
			
			<!--- Category markup percentage --->
			<cfif NOT Found>
				<cfif trim(strConfigComponent.ConfigComponentCategoryID) IS NOT "">
					<cfset strConfigComponentCategory = objConfigComponentCategories.getRecord(strConfigComponent.ConfigComponentCategoryID)>
					<cfif isNumeric(strConfigComponentCategory.MarkupPercentage)>
						<cfset ItemCostMarkedUp = ItemCost + ItemCost * strConfigComponentCategory.MarkupPercentage / 100>
						<cfset Found = 1>
					</cfif>
				</cfif>
			</cfif>
			
			<!--- System Type markup percentage --->
			<cfif NOT Found>
				<cfset strSalesRep = structNew()>

				<!--- Exportable Configurator --->
				<cfif isDefined("Arguments.CustomerID") AND trim(Arguments.CustomerID) IS NOT "">
					<cfset qryLogin = objCust.getLoginRecord(Arguments.CustomerID)>
					<cfif qryLogin.RecordCount NEQ 0>
						<cfset strSalesRep = objSalesRep.getRecordAsStruct(qryLogin.SalesRepID)>
					</cfif>

				<cfelse>
					<cfset UserID = getSessionValue("adminuserid")>
					<cfset SalesRepID = getSessionValue("salesrepid")>
					<cfif UserID IS NOT "" OR SalesRepID IS NOT "">
						<!--- Admin Section --->			
						<cfif UserID IS NOT "">
							<cfset strSalesRep = objSalesRep.getSalesRepByUserID(UserID)>
						
						<!--- Partners Section --->			
						<cfelse>
							<cfset strSalesRep = objSalesRep.getRecordAsStruct(SalesRepID)>
						</cfif>
					</cfif>
				</cfif>

				<cfif NOT structIsEmpty(strSalesRep)>
					<cfif strConfigComponent.SystemType IS "Workstation" AND isNumeric(strSalesRep.MarkupPctWorkstations)>
						<cfset ItemCostMarkedUp = ItemCost + ItemCost * strSalesRep.MarkupPctWorkstations / 100>
						<cfset Found = 1>
					<cfelseif strConfigComponent.SystemType IS "Notebook" AND isNumeric(strSalesRep.MarkupPctNotebooks)>
						<cfset ItemCostMarkedUp = ItemCost + ItemCost * strSalesRep.MarkupPctNotebooks / 100>
						<cfset Found = 1>
					<cfelseif strConfigComponent.SystemType IS "Server" AND isNumeric(strSalesRep.MarkupPctServers)>
						<cfset ItemCostMarkedUp = ItemCost + ItemCost * strSalesRep.MarkupPctServers / 100>
						<cfset Found = 1>
					</cfif>
				</cfif>

			</cfif>

			<!--- For the Exportable Configurator, markup the Item cost by the reseller's markup percentage --->		
			<cfif isDefined("Arguments.ExportableConfigurator") AND Arguments.ExportableConfigurator EQ 1 AND
				  isDefined("Arguments.CustomerID") AND trim(Arguments.CustomerID) IS NOT "">
	
				<cfset qryLogin = objCust.getLoginRecord(Arguments.CustomerID)>
				<cfif qryLogin.RecordCount NEQ 0>
					<cfif strConfigComponent.SystemType IS "Workstation" AND isNumeric(qryLogin.PercentWorkstations)>
						<cfset ItemCostMarkedUp = ItemCostMarkedUp + ItemCostMarkedUp * qryLogin.PercentWorkstations>
					<cfelseif strConfigComponent.SystemType IS "Notebook" AND isNumeric(qryLogin.PercentNotebooks)>
						<cfset ItemCostMarkedUp = ItemCostMarkedUp + ItemCostMarkedUp * qryLogin.PercentNotebooks>
					<cfelseif strConfigComponent.SystemType IS "Server" AND isNumeric(qryLogin.PercentServers)>
						<cfset ItemCostMarkedUp = ItemCostMarkedUp + ItemCostMarkedUp * qryLogin.PercentServers>
					</cfif>
				</cfif>
			</cfif>
			
		</cfif>
		<cfreturn ItemCostMarkedUp>
	</cffunction>

	<cffunction name="getCurrentAvailability" access="public" returntype="numeric" output="No">
	<!--- Send in an inventory Item Number (ITEMNO), returns the current available amount in ACCPAC --->
	<cfargument name="ItemNo" type="string" required="Yes">
		<cfset var AvailableAmount = 0>
		<cfquery datasource="#APPLICATION.DSN_AP#" name="qryItemLocation">
		SELECT 	dbo.ICILOC.QTYONHAND, dbo.ICILOC.QTYSALORDR
		FROM 	dbo.ICILOC
		WHERE 	dbo.ICILOC.ITEMNO = '#Arguments.ItemNo#' AND
				dbo.ICILOC.LOCATION = '1'
		</cfquery>
		<cfif qryItemLocation.RecordCount GT 0>
			<!--- Current Available Amount = QTYONHAND - QTYSALORDR --->
			<cfif isNumeric(qryItemLocation.QTYONHAND) AND isNumeric(qryItemLocation.QTYSALORDR)>
				<cfset AvailableAmount = qryItemLocation.QTYONHAND - qryItemLocation.QTYSALORDR>
			</cfif>
		</cfif>
		<cfreturn AvailableAmount>
	</cffunction>
	
	<cffunction name="getLocationDescription" access="public" returntype="string" output="No">
	<cfargument name="Location" type="string" required="Yes">
		<cfset var LocationDescription = "">
		<cfquery datasource="#APPLICATION.DSN_AP#" name="qryLocation">
		SELECT 	dbo.ICLOC.[DESC]
		FROM 	dbo.ICLOC
		WHERE 	dbo.ICLOC.LOCATION = '#Arguments.Location#'
		</cfquery>
		<cfif isDefined("qryLocation.Desc")>
			<cfset LocationDescription = qryLocation.Desc>
		</cfif>
		<cfreturn LocationDescription>
	</cffunction>

	<cffunction name="getLocations" access="public" returntype="query" output="No">
		<cfset var qryLocations = queryNew("LOCATION,DESC")>
		<cfquery datasource="#APPLICATION.DSN_AP#" name="qryLocations">
		SELECT 	dbo.ICLOC.LOCATION, dbo.ICLOC.[DESC]
		FROM 	dbo.ICLOC
		ORDER BY	dbo.ICLOC.LOCATION
		</cfquery>
		<cfreturn qryLocations>
	</cffunction>


	<cffunction name="getScannerSettings" access="public" returntype="struct" output="No">
	<cfargument name="Task" type="string" required="Yes">
	<cfargument name="ITEMNO" type="string" required="No">
		<cfset var strSettings = structNew()>
		<cfset objScannerSettings = createObject("component", "admin.assets.cfcs.ScannerSettings")>
		<cfset objScannerBatchItems = createObject("component", "admin.assets.cfcs.ScannerBatchItems")>

		<!--- Get Application-Specific Scanner Settings --->
		<cfset structInsert(strSettings, "KEYCODE", APPLICATION.KEYCODE, True)>
		<cfset structInsert(strSettings, "CANCELKEY", APPLICATION.CANCELKEY, True)>
		<cfset structInsert(strSettings, "FINALSOUND", APPLICATION.FINALSOUND, True)>
		<cfset structInsert(strSettings, "DUPESOUND", APPLICATION.DUPESOUND, True)>
		<cfset structInsert(strSettings, "MASKSOUND", APPLICATION.MASKSOUND, True)>

		<!--- Get Page-Specific Scanner Settings --->
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "Task", Arguments.Task, True)>
		<cfset qryScannerSettings = objScannerSettings.searchRecords(SearchRecord, "query")>
		<cfif qryScannerSettings.RecordCount NEQ 0>
			<cfset structInsert(strSettings, "InputPrefix", qryScannerSettings.InputPrefix, True)>
			<cfset structInsert(strSettings, "InputSeparator", qryScannerSettings.InputSeparator, True)>
			<cfset structInsert(strSettings, "InputNumbered", qryScannerSettings.InputNumbered, True)>
			<cfset structInsert(strSettings, "FormName", qryScannerSettings.FormName, True)>
			<cfset structInsert(strSettings, "DataField", qryScannerSettings.DataField, True)>
			<cfset structInsert(strSettings, "AlertDupes", qryScannerSettings.AlertDupes, True)>
			<cfset structInsert(strSettings, "AlertMask", qryScannerSettings.AlertMask, True)>
		</cfif>
		
		<!--- Determine if this Item is in the list of batch number scanned items --->
		<cfif isDefined("Arguments.ITEMNO") AND trim(Arguments.ITEMNO) IS NOT "">
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "ITEMNO", Arguments.ITEMNO, True)>
			<cfset qryScannerBatchItems = objScannerBatchItems.searchRecords(SearchRecord, "query")>
			<cfif qryScannerBatchItems.RecordCount GT 0>
				<cfset structInsert(strSettings, "AlertDupes", 0, True)>
			</cfif>
		</cfif>

		<cfreturn strSettings>
	</cffunction>

	<cffunction name="jsonEncode" access="public" returntype="string" output="No">
	<cfargument name="arg" type="any" required="Yes">
	    <cfset var i=0>
		<cfset var o="">
		<cfset var u="">
		<cfset var v="">
		<cfset var z="">
		<cfset var r="">
		<cfif isArray(arguments.arg)>
			<cfset o="">
			<cfloop from="1" to="#arrayLen(arg)#" step="1" index="i">
				<cftry>
					<cfset v = jsonEncode(arguments.arg[i])>
					<cfif o IS NOT "">
						<cfset o = o & ",">
					</cfif>
					<cfset o = o & v>
					<cfcatch type="any"><cfset o=o></cfcatch>
				</cftry>
			</cfloop>
			<cfreturn "["& o &"]">
		</cfif>
		<cfif isStruct(arguments.arg)>
			<cfset o = "">
			<cfif structIsEmpty(arguments.arg)>
				<cfreturn "{null}">
			</cfif>
			<cfset z = structKeyArray(arguments.arg)>
			<cfloop from="1" to="#arrayLen(z)#" step="1" index="i">
				<cftry>
					<cfset v = jsonEncode(evaluate("arguments.arg." & z[i]))>
					<cfcatch type="any"></cfcatch>
				</cftry>
				<cfif o IS NOT  "">
					<cfset o = o & ",">
				</cfif>
				<cfset o = o & '"' & lcase(z[i]) & '":' & v>
			</cfloop>
			<cfreturn "{" & o & "}">
		</cfif>
		<cfif isObject(arguments.arg)>
	        <cfreturn "unknown">
		</cfif>
		<cfif isSimpleValue(arguments.arg) and isNumeric(arguments.arg)>
			<cfreturn toString(arguments.arg)>
		</cfif>
		<cfif isSimpleValue(arguments.arg)>
	        <cfreturn '"' & replace(ToString(arg),'(")','\\\1',"All") & '"'>
		</cfif>
		<cfif isQuery(arguments.arg)>
			<cfset o = o & '"RECORDCOUNT":' & arguments.arg.recordcount>
			<cfset o = o & ',"COLUMNLIST":'& jsonencode(arg.columnlist)>
			<cfset o = o & ',"DATA":{'>
			<cfloop from="1" to="#listlen(arguments.arg.columnlist)#" step="1" index="i">
				<cfset v = "">
				<cfloop from="1" to="#arguments.arg.RecordCount#" step="1" index="z">
					<cfif v IS NOT "">
						<cfset v =v  & ",">
					</cfif>
					<cfset v = v & jsonEncode(evaluate("arguments.arg." & listgetat(arguments.arg.columnlist,i) & "["& z & "]"))>
				</cfloop>
				<cfif i neq 1>
					<cfset o = o & ",">
				</cfif>
				<cfset o = o & '"' & listgetat(arg.columnlist,i) & '":[' & v & ']'>
			</cfloop>
			<cfset o = o & '}'>
			<cfreturn "{" & o & "}">
		</cfif>
		<cfreturn "unknown">
	</cffunction>

	<cffunction name="printBarCodeLabels" access="public" returntype="boolean" output="no">
	<!--- This function prints multiple bar code labels for a recently posted Receiving or Adjustment --->
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var Success = 0>
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, This.ForeignHeaderKey, Arguments.Record[This.ForeignHeaderKey], True)>
		<cfset structInsert(SearchRecord, This.ForeignDetailKey, Arguments.Record[This.ForeignDetailKey], True)>
		<cfset qryRecords = searchRecords(SearchRecord, "query", This.SortOrderKey)>
		<cfif qryRecords.RecordCount GT 0>
			<!--- Create the contents of the TXT File --->
<!---		<cfset LabelFile = "#chr(34)#SerialNumber#chr(34)##chr(13)##chr(10)#">	--->	<!---RAB--->
			<cfset LabelFile = "#chr(34)#SerialNumber#chr(34)#,#chr(34)#Item Number#chr(34)##chr(13)##chr(10)#">
			
			<!--- Get the Item Number --->
			<cfset ItemNumberValue = "">
			<!--- Printing labels from Receipts --->
			<cfif This.ForeignHeaderKey IS "RCPHSEQ">
				<cfset objPORCPL = createObject("component", "admin.assets.cfcs.PORCPL")>
				<cfset SearchRecord = structNew()>
				<cfset structInsert(SearchRecord, "RCPHSEQ", Arguments.Record[This.ForeignHeaderKey], True)>
				<cfset structInsert(SearchRecord, "RCPLREV", Arguments.Record[This.ForeignDetailKey], True)>
				<cfset qryPORCPL = objPORCPL.searchRecords(SearchRecord, "query")>
				<cfif qryPORCPL.RecordCount NEQ 0>
					<cfset ItemNumberValue = qryPORCPL.ITEMNO>
				</cfif>
			<!--- Printing labels from Returns --->
			<cfelseif This.ForeignHeaderKey IS "RMAUNIQ">
				<cfset objRADET = createObject("component", "admin.assets.cfcs.RADET")>
				<cfset SearchRecord = structNew()>
				<cfset structInsert(SearchRecord, "RMAUNIQ", Arguments.Record[This.ForeignHeaderKey], True)>
				<cfset structInsert(SearchRecord, "LINENUM", Arguments.Record[This.ForeignDetailKey], True)>
				<cfset qryRADET = objRADET.searchRecords(SearchRecord, "query")>
				<cfif qryRADET.RecordCount NEQ 0>
					<cfset ItemNumberValue = qryRADET.ITEM>
				</cfif>
			<!--- Printing labels from Adjustments --->
			<cfelseif This.ForeignHeaderKey IS "ADJENSEQ">
				<cfset objICADED = createObject("component", "admin.assets.cfcs.ICADED")>
				<cfset SearchRecord = structNew()>
				<cfset structInsert(SearchRecord, "ADJENSEQ", Arguments.Record[This.ForeignHeaderKey], True)>
				<cfset structInsert(SearchRecord, "LINENO", Arguments.Record[This.ForeignDetailKey], True)>
				<cfset qryICADED = objICADED.searchRecords(SearchRecord, "query")>
				<cfif qryICADED.RecordCount NEQ 0>
					<cfset ItemNumberValue = qryICADED.ITEMNO>
				</cfif>
			</cfif>
			
			<cfloop query="qryRecords">
				<cfoutput>
<!---				<cfsavecontent variable="FieldData">"#qryRecords.SerialNumber#"#chr(13)##chr(10)#</cfsavecontent>---><!---RAB--->
					<cfset TrimITEMNO = trim(ItemNumberValue)>
					<cfsavecontent variable="FieldData">"#qryRecords.SerialNumber#","#TrimITEMNO#"#chr(13)##chr(10)#</cfsavecontent>

					<cfset LabelFile = LabelFile & FieldData>
					<!--- Set the BarCodesPrinted Flag --->
					<cfset RecordID = qryRecords[This.PrimaryKey]>
					<cfset strRecord = getRecord(RecordID)>
					<cfset structInsert(strRecord, "BarCodesPrinted", 1, True)>
					<cfset saveRecord(strRecord)>
				</cfoutput>
			</cfloop>
			<!--- FTP the file to the Label Matrix computer --->
			<cfset Success = FTPLabelFile(LabelFile, RecordID)>
		</cfif>
		<cfreturn Success>
	</cffunction>

	<cffunction name="printSingleBarCodeLabel" access="public" returntype="boolean" output="no">
	<!--- This function prints a single bar code label from the "Print Single Serial Number Bar Code" report. --->
	<cfargument name="SerialID" type="string" required="Yes">
		<cfset var Success = 0>
		<cfset strRecord = getRecord(Arguments.SerialID)>
		<cfif NOT structIsEmpty(strRecord)>
			<!--- Create the contents of the TXT File --->
<!---		<cfset LabelFile = "#chr(34)#SerialNumber#chr(34)##chr(13)##chr(10)#">	--->	<!---RAB--->
			<cfset LabelFile = "#chr(34)#SerialNumber#chr(34)#,#chr(34)#Item Number#chr(34)##chr(13)##chr(10)#">
			
			<cfoutput>
<!---			<cfsavecontent variable="FieldData">"#strRecord.SerialNumber#"#chr(13)##chr(10)#</cfsavecontent>	---><!---RAB--->
				<cfset TrimITEMNO = trim(strRecord.ITEMNO)>
				<cfsavecontent variable="FieldData">"#strRecord.SerialNumber#","#TrimITEMNO#"#chr(13)##chr(10)#</cfsavecontent>
				
				<cfset LabelFile = LabelFile & FieldData>
			</cfoutput>
			<!--- FTP the file to the Label Matrix computer --->
			<cfset Success = FTPLabelFile(LabelFile, Arguments.SerialID)>
		</cfif>
		<cfreturn Success>
	</cffunction>


	<cffunction name="FTPLabelFile" access="public" returntype="boolean" output="no">
	<cfargument name="LabelFile" type="string" required="Yes">
	<cfargument name="RecordID" type="string" required="Yes">
		<cfset var FTPSuccess = 0>
		<cfset FileToFTP = "C:\Inetpub\wwwroot\" & APPLICATION.AdminLocation & "\labels\labels_" & Arguments.RecordID & ".txt">

		<!--- Save the TXT File on the server --->
		<cffile action="write" file="#FileToFTP#" output="#Arguments.LabelFile#">		
		
		<!--- cfftp the TXT file to the computer running Label Matrix --->
		<cftry>
			<!--- Lock session scope. We will store ftp connection in there --->
			<cflock scope="session" type="exclusive" timeout="300" throwontimeout="no">
				<!--- Open a connection to the ftp server, store connection in session.ObjFtpConn --->
				<cfftp action="open" 
					username="#APPLICATION.FTPServerUserName#" 
					password="#APPLICATION.FTPServerPassword#" 
					timeout="65" 
					server="#APPLICATION.FTPServerIP#" 
					port="#APPLICATION.FTPServerPort#" 
					connection="session.objFtpConn"
					stopOnError = "No" 
					passive="yes">
<!---				
				<!--- switch to target directory on server --->
				<cfftp action="changeDir"
					connection="session.objFtpConn"
					directory="#APPLICATION.LabelMatrixPollDirectory#">
--->				
				<!--- put file --->
				<cfftp action="putFile"
					connection="session.objFtpConn"
					transfermode="binary"
					localfile="#FileToFTP#"
					remotefile="labels.txt"
					failifexists="No">
		
				<!--- close connection --->
				<cfftp action="close" connection="session.objFtpConn">
			</cflock>
			<cfcatch type="any">
				<cfoutput>
					<cfif isDefined("cfftp.succeeded")>Succeeded?: #cfftp.succeeded#<br/></cfif>
					<cfif isDefined("cfftp.ErrorCode")>Error Code: #cfftp.ErrorCode#<br/></cfif>
					<cfif isDefined("cfftp.ErrorText")>Error Text: #cfftp.ErrorText#<br/></cfif>
					<cfif isDefined("cfcatch.Type")>Type: #cfcatch.Type#<br/></cfif>
					<cfif isDefined("cfcatch.Message")>Message: #cfcatch.Message#<br/></cfif>
					<cfif isDefined("cfcatch.Detail")>Detail: #cfcatch.Detail#<br/></cfif>
				</cfoutput>
			</cfcatch>
		</cftry>
		<cfif isDefined("cfftp.succeeded") AND trim(cfftp.succeeded) IS "YES">
			<cfset FTPSuccess = 1>
		</cfif>

		<!--- Delete the label file from the server --->
		<cffile action="delete" file="#FileToFTP#">

		<cfreturn FTPSuccess>
	</cffunction>

	<cffunction name="validateReplicate" access="public" returntype="struct" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
		<cfset SNIndex = int(Arguments.Record.NumberOfBoxes)>
		<cfloop condition="#SNIndex# GT 0">
			<cfif isDefined("Arguments.Record.StartBoxNumber")>
				<cfset FieldName = "SN_" & (Arguments.Record.StartBoxNumber + SNIndex - 1)>
			<cfelse>
				<cfset FieldName = "SN_" & SNIndex>
			</cfif>
			<cfset FieldValue = Arguments.Record[FieldName]>
			<cfif trim(FieldValue) IS NOT "">
				<cfbreak>
			</cfif>
			<cfset SNIndex = SNIndex - 1>
		</cfloop>
		<cfif SNIndex EQ 0>
			<cfset stErrors.Replicate = "To use the 'Replicate' function, you must scan the first serial number">
		</cfif>
		<cfreturn stErrors>
	</cffunction>
	
	<cffunction name="replicate" access="public" returntype="struct" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stRecord = Arguments.Record>
		<cfset SNIndex = int(Arguments.Record.NumberOfBoxes)>
		<cfset FieldValueToReplicate = "">
		<cfloop condition="#SNIndex# GT 0">
			<cfif isDefined("Arguments.Record.StartBoxNumber")>
				<cfset FieldName = "SN_" & (Arguments.Record.StartBoxNumber + SNIndex - 1)>
			<cfelse>
				<cfset FieldName = "SN_" & SNIndex>
			</cfif>
			<cfset FieldValue = Arguments.Record[FieldName]>
			<cfif trim(FieldValue) IS NOT "">
				<cfset FieldValueToReplicate = FieldValue>
				<cfbreak>
			</cfif>
			<cfset SNIndex = SNIndex - 1>
		</cfloop>
		<cfif FieldValueToReplicate IS NOT "">
			<cfif isDefined("stRecord.StartBoxNumber")>
				<cfset FirstBox = stRecord.StartBoxNumber + SNIndex - 1>
			<cfelse>
				<cfset FirstBox = SNIndex>
			</cfif>
			<cfif isDefined("stRecord.EndBoxNumber")>
				<cfset LastBox = stRecord.EndBoxNumber>
			<cfelse>
				<cfset LastBox = stRecord.NumberOfBoxes>
			</cfif>
<!---		<cfloop index="LoopCount" from="#(stRecord.StartBoxNumber + SNIndex - 1)#" to="#stRecord.EndBoxNumber#">	--->
			<cfloop index="LoopCount" from="#FirstBox#" to="#LastBox#">
				<cfset structInsert(stRecord, "SN_#LoopCount#", FieldValueToReplicate, True)>
			</cfloop>
		</cfif>
		<cfreturn stRecord>
	</cffunction>

	<cffunction name="validateConsecutiveOrder" access="public" returntype="struct" output="no">
	<!--- Make sure no serial number boxes are filled in --->
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
		<cfset RecordList = structKeyList(Arguments.Record)>
		<cfloop list="#RecordList#" index="SNColumn">
			<cfif findNoCase("SN_", SNColumn) NEQ 0>
				<cfset SNValue = Arguments.Record[SNColumn]>
				<cfif trim(SNValue) IS NOT "">
					<cfset stErrors.ConsecutiveOrder = "In order to list serial numbers consecutively, all serial number fields must be empty">
					<cfbreak>						
				</cfif>
			</cfif>
		</cfloop>
		<cfreturn stErrors>
	</cffunction>

	<cffunction name="validateConsecutiveOrder2" access="public" returntype="struct" output="no">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
		<cfset SNIndex = int(Arguments.Record.NumberOfBoxes)>
		<cfloop condition="#SNIndex# GT 0">
			<cfif isDefined("Arguments.Record.StartBoxNumber")>
				<cfset FieldName = "SN_" & (Arguments.Record.StartBoxNumber + SNIndex - 1)>
			<cfelse>
				<cfset FieldName = "SN_" & SNIndex>
			</cfif>
			<cfset FieldValue = Arguments.Record[FieldName]>
			<cfif trim(FieldValue) IS NOT "">
				<cfif len(FieldValue) LT 4>
					<cfset stErrors.ConsecutiveOrder = "To use the 'Consecutive Order 2' function, the last serial number scanned must contain four or more characters">
					<cfbreak>
				</cfif>
				<cfset LastFourCharacters = right(trim(FieldValue),4)>
				<cfif validateInteger(LastFourCharacters) EQ 0>
					<cfset stErrors.ConsecutiveOrder = "To use the 'Consecutive Order 2' function, the last four characters of the last serial number scanned must be all numbers (no alphabetic characters)">
				</cfif>
				<cfbreak>
			</cfif>
			<cfset SNIndex = SNIndex - 1>
		</cfloop>
		<cfif SNIndex EQ 0>
			<cfset stErrors.ConsecutiveOrder = "To use the 'Consecutive Order 2' function, you must scan the first serial number">
		</cfif>
		
		<!--- perform validation to make sure that the serial hasn’t already been entered --->
		<cfif structIsEmpty(stErrors)>
			<cfset lstRecord = structKeyList(Arguments.Record)>
			<cfloop list="#lstRecord#" index="Column">
				<cfif findNoCase('SN_',Column) NEQ 0>
					<cfif Column IS NOT FieldName>
						<cfif trim(Arguments.Record[Column]) IS trim(FieldValue)>
							<cfset stErrors.ConsecutiveOrder = "The Serial Number you scanned is already entered on this page.  Please re-enter.">
							<cfset structInsert(stErrors, FieldName, "error", True)>
						</cfif>					
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
		
		<cfreturn stErrors>
	</cffunction>

	<cffunction name="consecutiveOrder2" access="public" returntype="struct" output="no">
	<cfargument name="Record" type="struct" required="Yes">
	<cfargument name="ConsecutiveQuantity" type="string" required="Yes">
		<cfset var stRecord = Arguments.Record>
        <cfset var NumberLeadingZeros = 0>
        <cfset var LeadingZeros = "">
        <cfset var StrippedFieldValue = "">

		<cfif isNumeric(Arguments.ConsecutiveQuantity) AND Arguments.ConsecutiveQuantity GT 0>
			<cfif isDefined("stRecord.StartBoxNumber") AND isDefined("stRecord.EndBoxNumber")>
				<cfset SNIndex = int(stRecord.EndBoxNumber)>
				<cfset BaseIndex = int(stRecord.StartBoxNumber) - 1>
			<cfelse>
				<cfset SNIndex = int(stRecord.NumberOfBoxes)>
				<cfset BaseIndex = 0>
			</cfif>
			
			<cfset BaseIndex = BaseIndex + 1>
			<cfloop from="#BaseIndex#" to="#SNIndex#" step="1" index="CurrentStep">
				<cfset FieldName = "SN_" & CurrentStep>
				<cfset FieldValue = stRecord[FieldName]>
				<cfif trim(FieldValue) IS "">
					<cfset StartingPoint = CurrentStep>
					<cfset FieldName = "SN_" & (CurrentStep-1)>
					<cfset FieldValue = trim(stRecord[FieldName])>
					<cfset LastFourCharacters = right(trim(FieldValue),4)>	
					<cfset FirstPartOfString = removeChars(trim(FieldValue), len(trim(FieldValue))-3, 4)>

					<cfif isNumeric(FieldValue)>	<!--- RAB 081908 --->
                    	<!--- Retain leading zeros --->

						<cfset LeadingZeros = "">
                        <cfloop from="1" to="#len(FieldValue)#" index="i">
                        	<cfif mid(FieldValue, i, 1) IS "0">
                            	<cfset LeadingZeros = LeadingZeros & "0">
                            <cfelse>
								<cfset NumberLeadingZeros = i - 1>
                                <cfbreak>
							</cfif>
                        </cfloop>
						<cfset StrippedFieldValue = FieldValue>
                        <cfif NumberLeadingZeros GT 0>
							<cfset StrippedFieldValue = removeChars(FieldValue, 1, NumberLeadingZeros)>
						</cfif>
						<cfset StrippedFieldValue = StrippedFieldValue + 1>
                        <cfset SerialNumberValue = LeadingZeros & StrippedFieldValue>
						<cfset AllNumericSerialNumber = 1>
					<cfelse>
						<cfset SerialNumberValue = LastFourCharacters + 1>
						<cfif len(SerialNumberValue) GT 4>
							<cfset LastPartOfString = SerialNumberValue>
						<cfelse>
							<cfset LastPartOfString = "0000">
							<cfset LastPartOfString = removeChars(LastPartOfString, 4-len(SerialNumberValue)+1, len(SerialNumberValue))>
							<cfset LastPartOfString = insert(SerialNumberValue, LastPartOfString, 4-len(SerialNumberValue))>
						</cfif>
						<cfset AllNumericSerialNumber = 0>
					</cfif>

					<cfbreak>
				</cfif>
			</cfloop>
			
<!---			
			<cfloop condition="#SNIndex# GT #BaseIndex#">
				<cfset FieldName = "SN_" & SNIndex>
				<cfset FieldValue = stRecord[FieldName]>
				<cfif trim(FieldValue) IS NOT "">
					<cfset StartingPoint = SNIndex + 1>
					<cfset LastFourCharacters = right(trim(FieldValue),4)>	
					<cfset FirstPartOfString = removeChars(trim(FieldValue), len(trim(FieldValue))-3, 4)>
					<cfset SerialNumberValue = LastFourCharacters + 1>
					<cfif len(SerialNumberValue) GT 4>
						<cfset LastPartOfString = SerialNumberValue>
					<cfelse>
						<cfset LastPartOfString = "0000">
						<cfset LastPartOfString = removeChars(LastPartOfString, 4-len(SerialNumberValue)+1, len(SerialNumberValue))>
						<cfset LastPartOfString = insert(SerialNumberValue, LastPartOfString, 4-len(SerialNumberValue))>
					</cfif>
					<cfbreak>
				</cfif>
				<cfset SNIndex = SNIndex - 1>
			</cfloop>
--->		
			
			
			<cfset EndingPoint = StartingPoint + Arguments.ConsecutiveQuantity - 2>
			<cfif StartingPoint LE EndingPoint>
				<cfloop index="LoopCount" from="#StartingPoint#" to="#EndingPoint#">
					<cfif NOT AllNumericSerialNumber>
						<cfset NewString = FirstPartOfString & LastPartOfString>
					</cfif>
					
					<!--- RAB 7/24/07 --->
					<cfset FieldName = "SN_" & LoopCount>
					<cfif structKeyExists(stRecord, FieldName)>
						<cfset FieldValue = stRecord[FieldName]>
						<cfif trim(FieldValue) IS "">
							<cfif AllNumericSerialNumber>
								<cfset structInsert(stRecord, "SN_#LoopCount#", SerialNumberValue, True)>
							<cfelse>
								<cfset structInsert(stRecord, "SN_#LoopCount#", NewString, True)>
							</cfif>
						</cfif>
					</cfif>						

					<cfif AllNumericSerialNumber>
                    	<cfset StrippedFieldValue = StrippedFieldValue + 1>
                        <cfset SerialNumberValue = LeadingZeros & StrippedFieldValue>
                    <cfelse>
						<cfset SerialNumberValue = SerialNumberValue + 1>                
                    </cfif>
					
					<cfif NOT AllNumericSerialNumber>
						<cfif len(SerialNumberValue) GT 4>
							<cfset LastPartOfString = SerialNumberValue>
						<cfelse>
							<cfset LastPartOfString = "0000">
							<cfset LastPartOfString = removeChars(LastPartOfString, 4-len(SerialNumberValue)+1, len(SerialNumberValue))>
							<cfset LastPartOfString = insert(SerialNumberValue, LastPartOfString, 4-len(SerialNumberValue))>
						</cfif>
					</cfif>
				</cfloop>
			</cfif>
		</cfif>
		<cfreturn stRecord>
	</cffunction>

	<cffunction name="validateConsecutiveOrder3Qty" access="public" returntype="struct" output="no">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
		<cfif validateZeroInteger(Arguments.Record.ConsecutiveQuantity) EQ 0>
			<cfset structInsert(stErrors, "ConsecutiveQuantity", "Please enter an integer value greater than zero", True)>
		<cfelseif Arguments.Record.ConsecutiveQuantity GT Arguments.Record.NumberOfBoxes>
			<cfset structInsert(stErrors, "ConsecutiveQuantity", "Please enter a quantity less than or equal to #Arguments.Record.NumberOfBoxes#", True)>
		</cfif>
		<cfreturn stErrors>
	</cffunction>

	<cffunction name="validateConsecutiveOrder3" access="public" returntype="struct" output="no">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
		<cfset lstRecord = structKeyList(Arguments.Record)>
		<cfloop list="#lstRecord#" index="Column">
			<cfif findNoCase('SNC3_',Column) NEQ 0>
				<cfset FieldValue = Arguments.Record[Column]>
				<cfif trim(FieldValue) IS NOT "">
					<cfif len(FieldValue) LT 4>
						<cfset stErrors[Column] = "This serial number must contain four or more characters">
					<cfelse>
						<cfset LastFourCharacters = right(trim(FieldValue),4)>
						<cfif validateInteger(LastFourCharacters) EQ 0>
							<cfset stErrors[Column] = "The last four characters of this serial number must be all numbers (no alphabetic characters)">
						</cfif>
					</cfif>
				</cfif>
			</cfif>
		</cfloop>
		<cfreturn stErrors>
	</cffunction>
	
	<cffunction name="consecutiveOrder3" access="public" returntype="struct" output="no">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stRecord = Arguments.Record>
        <cfset var LeadingZeros = "">
        <cfset var NumberLeadingZeros = 0>
        
		<cfset lstRecord = structKeyList(stRecord)>
		<cfset stRecordNew = structNew()>
		<cfloop list="#lstRecord#" index="Column">
			<cfif findNoCase("SNC3_", Column) NEQ 0>
				<cfset NumberedField = removeChars(Column, 1, 5)>
				<cfset structInsert(stRecordNew, NumberedField, stRecord[Column], True)>
			</cfif>
		</cfloop>

		<cfset lstRecordNew = listSort(structKeyList(stRecordNew), "numeric")>
		<cfset Counter = 1>
		<cfloop list="#lstRecordNew#" index="Column">
			<cfset SNValue = ucase(trim(stRecordNew[Column]))>
			<cfset LastFourCharacters = right(trim(SNValue),4)>	
			<cfif isNumeric(LastFourCharacters)>
				<cfset FirstPartOfString = removeChars(trim(SNValue), len(trim(SNValue))-3, 4)>

				<cfif isNumeric(SNValue)>	<!--- RAB 081908 --->

					<!--- Retain leading zeros --->
                    <cfset LeadingZeros = "">
                    <cfloop from="1" to="#len(SNValue)#" index="i">
                        <cfif mid(SNValue, i, 1) IS "0">
                            <cfset LeadingZeros = LeadingZeros & "0">
                        <cfelse>
                            <cfset NumberLeadingZeros = i - 1>
                            <cfbreak>
                        </cfif>
                    </cfloop>
                    <cfset StrippedFieldValue = SNValue>
                    <cfif NumberLeadingZeros GT 0>
                        <cfset StrippedFieldValue = removeChars(SNValue, 1, NumberLeadingZeros)>
                    </cfif>
                    <cfset StrippedFieldValue = StrippedFieldValue + 1>
                    <cfset SerialNumberValue = LeadingZeros & StrippedFieldValue>
                    <cfset AllNumericSerialNumber = 1>

<!---
					<cfset SerialNumberValue = SNValue + 1>
					<cfset AllNumericSerialNumber = 1>
--->                    
				<cfelse>
					<cfset SerialNumberValue = LastFourCharacters + 1>
					<cfif len(SerialNumberValue) GT 4>
						<cfset LastPartOfString = SerialNumberValue>
					<cfelse>
						<cfset LastPartOfString = "0000">
						<cfset LastPartOfString = removeChars(LastPartOfString, 4-len(SerialNumberValue)+1, len(SerialNumberValue))>
						<cfset LastPartOfString = insert(SerialNumberValue, LastPartOfString, 4-len(SerialNumberValue))>
					</cfif>
					<cfset AllNumericSerialNumber = 0>
				</cfif>

				<cfset FieldName = "SN_" & Counter>
				<cfset Counter = Counter + 1>
				<cfset structInsert(stRecord, FieldName, SNValue, True)>
				
				<cfloop index="LoopCount" from="1" to="#stRecord.ConsecutiveQuantity-1#">					

					<cfif NOT AllNumericSerialNumber>
						<cfset NewString = FirstPartOfString & LastPartOfString>
					</cfif>					

					<cfset FieldName = "SN_" & Counter>
					<cfset Counter = Counter + 1>
					<cfif AllNumericSerialNumber>
						<cfset structInsert(stRecord, FieldName, SerialNumberValue, True)>
					<cfelse>
						<cfset structInsert(stRecord, FieldName, NewString, True)>
					</cfif>


					<cfif AllNumericSerialNumber>
                    	<cfset StrippedFieldValue = StrippedFieldValue + 1>
                        <cfset SerialNumberValue = LeadingZeros & StrippedFieldValue>
                    <cfelse>
						<cfset SerialNumberValue = SerialNumberValue + 1>                
                    </cfif>

					<cfif NOT AllNumericSerialNumber>
						<cfif len(SerialNumberValue) GT 4>
							<cfset LastPartOfString = SerialNumberValue>
						<cfelse>
							<cfset LastPartOfString = "0000">
							<cfset LastPartOfString = removeChars(LastPartOfString, 4-len(SerialNumberValue)+1, len(SerialNumberValue))>
							<cfset LastPartOfString = insert(SerialNumberValue, LastPartOfString, 4-len(SerialNumberValue))>
						</cfif>
					</cfif>						
						
				</cfloop>
			</cfif>
		</cfloop>
		
		<cfreturn stRecord>
	</cffunction>

<!--- ********************************************************************************************* --->
<!--- The following two functions are used in the adminstrative section of the serialization system --->
<!--- They are called from the following templates in admin\serials\administration:				    --->
<!---		frmBatch.cfm, savBatch.cfm, frmBarCode.cfm, savBarCode.cfm								--->
<!--- ********************************************************************************************* --->

	<cffunction name="searchAdminItems" access="public" returntype="query" output="No">
	<cfargument name="Record" type="struct" required="No">
		<cfset var qryRecords = queryNew("ITEMNO,DESC")>
		<cfset objICITEM = createObject("component", "admin.assets.cfcs.ICITEM")>
		<cfset qryItems = objICITEM.searchRecords(Arguments.Record, "query", "ITEMNO", 0)>
		<cfset NumberFound = 0>
		<cfloop query="qryItems">
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "ITEMNO", qryItems.ITEMNO, True)>
			<cfset qryAdminItems = searchRecords(SearchRecord)>
			<cfif qryAdminItems.RecordCount EQ 0>
				<cfset queryAddRow(qryRecords)>
				<cfset querySetCell(qryRecords, "ITEMNO", qryItems.ITEMNO)>
				<cfset querySetCell(qryRecords, "DESC", qryItems.DESC)>
				<cfset NumberFound = NumberFound + 1>
			</cfif>
			<cfif NumberFound GT 20>
				<cfbreak>
			</cfif>
		</cfloop>
		<cfreturn qryRecords>
	</cffunction>

	<cffunction name="addAdminItems" access="public" output="no">
	<cfargument name="Record" type="struct" required="No">
		<cfset objICITEM = createObject("component", "admin.assets.cfcs.ICITEM")>
		<cfset lstRecord = structKeyList(Arguments.Record)>
		<cfloop list="#lstRecord#" index="Column">
			<cfif findNoCase("ITEM_", Column) NEQ 0>
				<cfset ITEMNO = removeChars(Column, 1, 5)>
				<cfset SearchRecord = structNew()>
				<cfset structInsert(SearchRecord, "ITEMNO", ITEMNO, True)>
				<cfset qryAdminItems = searchRecords(SearchRecord, "query")>
				<cfif qryAdminItems.RecordCount EQ 0>
					<cfset strAdminItem = newRecord()>
					<cfset structInsert(strAdminItem, "ITEMNO", ITEMNO, True)>
					<cfset strICITEM = objICITEM.getRecord(ITEMNO)>
					<cfset structInsert(strAdminItem, "ITEMDESC", strICITEM.DESC, True)>
					<cfset saveRecord(strAdminItem)>
				</cfif>
			</cfif>
		</cfloop>
	</cffunction>

	<cffunction name="addBatchNumberSN" access="public" output="no">
	<!--- If this is a Batch Number Item, save the serial number in tblScannerBatchItemSNs --->
	<cfargument name="Record" type="struct" required="Yes">
		<cfset objScannerBatchItems = createObject("component", "admin.assets.cfcs.ScannerBatchItems")>
		<cfset objScannerBatchItemSNs = createObject("component", "admin.assets.cfcs.ScannerBatchItemSNs")>
		<!--- If this is a "batch number item" --->
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ITEMNO", Arguments.Record[This.ITEMNOKey], True)>
		<cfset qryScannerBatchItems = objScannerBatchItems.searchRecords(SearchRecord, "query")>
		<cfif qryScannerBatchItems.RecordCount GT 0>
			<cfset RecordList = structKeyList(Arguments.Record)>
			<cfset SNValue = "">
			<cfloop list="#RecordList#" index="SNColumn">
				<cfif findNoCase("SN_", SNColumn) NEQ 0>
					<cfif trim(Arguments.Record[SNColumn]) IS NOT "">
						<cfset SNValue = ucase(trim(Arguments.Record[SNColumn]))>
						<cfbreak>
					</cfif>
				</cfif>
			</cfloop>
			<cfif trim(SNValue) IS NOT "">
				<cfset FoundIt = 0>
				<cfset qryScannerBatchItemSNs = objScannerBatchItemSNs.listRecordsForParent("ScannerBatchItemID", qryScannerBatchItems.ScannerBatchItemID)>
				<cfloop query="qryScannerBatchItemSNs">
					<cfif trim(SNValue) IS trim(qryScannerBatchItemSNs.SerialNumber)>
						<cfset FoundIt = 1>
						<cfbreak>
					</cfif>
				</cfloop>
				<cfif NOT FoundIt>
					<cfset strScannerBatchItemSN = objScannerBatchItemSNs.newRecord()>
					<cfset structInsert(strScannerBatchItemSN, "ScannerBatchItemID", qryScannerBatchItems.ScannerBatchItemID, True)>
					<cfset structInsert(strScannerBatchItemSN, "SerialNumber", trim(SNValue), True)>
					<cfset objScannerBatchItemSNs.saveRecord(strScannerBatchItemSN)>
				</cfif>
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="formatPhoneNumber" access="public" returntype="string" output="No">
	<cfargument name="PhoneNumber" type="string" required="Yes">
	<cfargument name="Country" type="string" required="No">
		<cfset var FormattedPhoneNumber = "">
		<cfif NOT isDefined("Arguments.Country")>
			<cfset Arguments.Country = "US">
		</cfif>
		<cfset RawNumber = trim(Arguments.PhoneNumber)>
		<cfif trim(Arguments.Country) IS NOT "US">
			<cfset FormattedPhoneNumber = RawNumber>
		<cfelse>
			<cfset OnlyNumber = "">
			<cfloop index="L" from="1" to="#Len(RawNumber)#">
				<cfif mid(RawNumber, L, 1) EQ "0" 
					OR mid(RawNumber, L, 1) EQ "1"
					OR mid(RawNumber, L, 1) EQ "2"
					OR mid(RawNumber, L, 1) EQ "3"
					OR mid(RawNumber, L, 1) EQ "4"
					OR mid(RawNumber, L, 1) EQ "5"
					OR mid(RawNumber, L, 1) EQ "6"
					OR mid(RawNumber, L, 1) EQ "7"
					OR mid(RawNumber, L, 1) EQ "8"
					OR mid(RawNumber, L, 1) EQ "9">
					<cfset OnlyNumber = OnlyNumber & mid(RawNumber, L, 1)>
				</cfif>
			</cfloop>
			<cfif len(OnlyNumber) EQ 10>
				<cfset FormattedPhoneNumber = "(#left(OnlyNumber,3)#) #mid(OnlyNumber, 4, 3)#-#right(OnlyNumber,4)#">
			<cfelseif len(OnlyNumber) EQ 7>
				<cfset FormattedPhoneNumber = left(OnlyNumber, 3) & "-" & right(OnlyNumber, 4)>
			<cfelseif len(OnlyNumber) EQ 11 AND left(OnlyNumber, 1) EQ 1>
				<cfset FormattedPhoneNumber = "(" & mid(OnlyNumber, 2, 3) & ") " & mid(OnlyNumber, 5, 3) & "-" & right(OnlyNumber, 4)>
			<cfelse>
				<cfset FormattedPhoneNumber = RawNumber>
<!---			<cfset FormattedPhoneNumber = OnlyNumber>	--->
			</cfif>
		</cfif>
		<cfreturn FormattedPhoneNumber>
	</cffunction>
		
</cfcomponent>
