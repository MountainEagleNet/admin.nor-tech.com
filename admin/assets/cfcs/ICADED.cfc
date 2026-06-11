<cfcomponent extends="admin.assets.cfcs.Component">
	<cfset This.DataSourceName = APPLICATION.DSN_AP>

	<cfset This.Columns = "ADJENSEQ,ITEMNO,ITEMDESC,QUANTITY,TRANSTYPE,LOCATION">
	<cfset This.ViewColumns = This.Columns>
	<cfset This.DESCColumn = "">
	<cfset This.LINENOColumn = "LINENO">

	<cfset This.TableName = "dbo.ICADED">
	<cfset This.ViewName = This.TableName>
	
	<cfset This.PrimaryKey = "ADJENSEQ">
	<cfset This.ITEMNOKey = "ITEMNO">
	<cfset This.QuantityKey = "QUANTITY">
	
	<cfset This.GenerateUUIDKey = 0>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "[LINENO]">
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