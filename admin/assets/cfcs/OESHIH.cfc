<cfcomponent extends="admin.assets.cfcs.Component">
	<cfset This.DataSourceName = APPLICATION.DSN_AP>

	<cfset This.Columns = "SHIUNIQ,SHINUMBER,ORDNUMBER,SHIDATE,CUSTOMER,BILNAME,SHPNAME,SHPADDR1,SHPADDR2,SHPADDR3,SHPADDR4,SHPCITY,SHPSTATE,SHPZIP">
	<cfset This.ViewColumns = This.Columns>
	
	<cfset This.TableName = "dbo.OESHIH">
	<cfset This.ViewName = This.TableName>
	
	<cfset This.PrimaryKey = "SHIUNIQ">
	<cfset This.ITEMNOKey = "">
	<cfset This.GenerateUUIDKey = 0>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "SHINUMBER">
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