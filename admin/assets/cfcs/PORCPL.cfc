<cfcomponent extends="admin.assets.cfcs.Component">
	<cfset This.DataSourceName = APPLICATION.DSN_AP>

	<cfset This.Columns = "RCPHSEQ,RCPLREV,ITEMNO,ITEMDESC,RQRECEIVED,LOCATION">
	<cfset This.ViewColumns = This.Columns>
	<cfset This.DESCColumn = "">
	
	<cfset This.TableName = "dbo.PORCPL">
	<cfset This.ViewName = This.TableName>
	
	<cfset This.PrimaryKey = "RCPHSEQ">
	<cfset This.ITEMNOKey = "ITEMNO">
	<cfset This.QuantityKey = "RQRECEIVED">
	
	<cfset This.GenerateUUIDKey = 0>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "RCPLREV">
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