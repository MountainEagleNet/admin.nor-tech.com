<cfcomponent extends="admin.assets.cfcs.Component">
	<cfset This.DataSourceName = APPLICATION.DSN_AP>

	<cfset This.Columns = "CODE,NAME">
	
	<cfset This.ViewColumns = This.Columns>
	<cfset This.DESCColumn = "">

	<cfset This.TableName = "dbo.OEVIA">
	<cfset This.ViewName = This.TableName>
	
	<cfset This.PrimaryKey = "CODE">
	<cfset This.ITEMNOKey = "">
	<cfset This.GenerateUUIDKey = 0>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "CODE">
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

	<cffunction name="getShippingMethod" access="public" returntype="string" output="no">
	<cfargument name="SHIPVIA" type="string" required="yes">
		<cfset var ShippingMethod = "">
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "CODE", Arguments.SHIPVIA, True)>
		<cfset qryOEVIA = searchRecords(SearchRecord, "query")>
		<cfif isDefined("qryOEVIA.NAME")>
			<cfset ShippingMethod = trim(qryOEVIA.NAME)>
		</cfif>
		<cfreturn ShippingMethod>
	</cffunction>
	
</cfcomponent>