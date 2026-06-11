<cfcomponent extends="admin.assets.cfcs.Component">
	<cfset This.DataSourceName = APPLICATION.DSN_AP>

	<cfset This.Columns = "SHIUNIQ,LINENUM,ITEM,QTYSHIPPED,LOCATION">
	<cfset This.ViewColumns = This.Columns>
	<cfset This.DESCColumn = "DESC">
	
	<cfset This.TableName = "dbo.OESHID">
	<cfset This.ViewName = This.TableName>
	
	<cfset This.PrimaryKey = "SHIUNIQ">
	<cfset This.ITEMNOKey = "ITEM">
	<cfset This.QuantityKey = "QTYSHIPPED">
	
	<cfset This.GenerateUUIDKey = 0>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "LINENUM">
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
</cfcomponent>