<cfcomponent extends="admin.assets.cfcs.Component">
	<cfset This.DataSourceName = APPLICATION.DSN_WWW>

	<cfset This.Columns = "SerialBatch2ID,ITEMNO,ITEMDESC">
	<cfset This.ViewColumns = This.Columns>
	
	<cfset This.TableName = "tblSerialBatch2">
	<cfset This.ViewName = This.TableName>
	
	<cfset This.PrimaryKey = "SerialBatch2ID">
	<cfset This.ForeignHeaderKey = "">
	<cfset This.ForeignDetailKey = "">
	
	<cfset This.ITEMNOKey = "">	

	<cfset This.GenerateUUIDKey = 1>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "ITEMNO">
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

	<cffunction name="formatSerialNumbers" access="public" returntype="struct" output="no">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var NewRecord = Arguments.Record>
		<cfif isDefined("Arguments.Record.ITEMNO")>
			<cfset ThisItem = Arguments.Record.ITEMNO>
		<cfelseif isDefined("Arguments.Record.ITEM")>
			<cfset ThisItem = Arguments.Record.ITEM>
		<cfelse>
			<cfset ThisItem = "">
		</cfif>
		<cfif ThisItem IS NOT "" AND isBatch2Item(ThisItem)>
			<cfset lstRecord = structKeyList(Arguments.Record)>
			<cfloop list="#lstRecord#" index="Column">
				<cfif findNoCase("SN_",Column) NEQ 0>
					<cfset ColumnValue = Arguments.Record[Column]>
					<cfset SNValue = stripNonNumericChars(ColumnValue)>
					<cfset structInsert(NewRecord, Column, SNValue, True)>
				</cfif>
			</cfloop>
		</cfif>
		<cfreturn NewRecord>
	</cffunction>

	<cffunction name="isBatch2Item" access="public" returntype="boolean" output="no">
	<cfargument name="ITEMNO" type="string" required="Yes">
		<cfset var ThisIsBatch2Item = 0>
		<cfset objSerialBatch2 = createObject("component", "admin.assets.cfcs.SerialBatch2")>
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ITEMNO", Arguments.ITEMNO, True)>
		<cfset qrySerialBatch2 = objSerialBatch2.searchRecords(SearchRecord, "query")>
		<cfif qrySerialBatch2.RecordCount GT 0>
			<cfset ThisIsBatch2Item = 1>
		</cfif>
		<cfreturn ThisIsBatch2Item>
	</cffunction>

	<cffunction name="stripNonNumericChars" access="public" returntype="string" output="no">
	<cfargument name="SerialNumber" type="string" required="Yes">
		<cfset var FormattedSerialNumber = "">
		<cfset SNInput = trim(Arguments.SerialNumber)>	
		<cfset SNLength = len(SNInput)>
		<cfloop from="1" to="#SNLength#" step="1" index="i">
			<cfif isNumeric(mid(SNInput,i,1))>
				<cfset FormattedSerialNumber = FormattedSerialNumber & mid(SNInput,i,1)>
			</cfif>
		</cfloop>
		<cfreturn FormattedSerialNumber>
	</cffunction>

</cfcomponent>