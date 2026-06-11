<cfcomponent extends="admin.assets.cfcs.Component">
	<cfset This.DataSourceName = APPLICATION.DSN_AP>

	<cfset This.Columns = "RETHSEQ,RETLREV,ITEMNO,ITEMDESC,RQRETURNED,LOCATION">
	<cfset This.ViewColumns = This.Columns>
	<cfset This.DESCColumn = "">
	
	<cfset This.TableName = "dbo.PORETL">
	<cfset This.ViewName = This.TableName>
	
	<cfset This.PrimaryKey = "RETHSEQ">
	<cfset This.ITEMNOKey = "ITEMNO">
	<cfset This.QuantityKey = "RQRETURNED">
	
	<cfset This.GenerateUUIDKey = 0>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "RETLREV">
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