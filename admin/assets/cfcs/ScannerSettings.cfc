<cfcomponent extends="admin.assets.cfcs.Component">

	<cfset This.DataSourceName = APPLICATION.DSN_WWW>

	<cfset This.Columns = "ScannerSettingsID,Task,InputPrefix,InputSeparator,InputNumbered,FormName,DataField,AlertDupes,AlertMask">
	<cfset This.ViewColumns = This.Columns>
	
	<cfset This.TableName = "tblScannerSettings">
	<cfset This.ViewName = This.TableName>
	
	<cfset This.PrimaryKey = "ScannerSettingsID">
	<cfset This.ForeignHeaderKey = "">
	<cfset This.ForeignDetailKey = "">
	
	<cfset This.ITEMNOKey = "">	

	<cfset This.GenerateUUIDKey = 1>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "Task">
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