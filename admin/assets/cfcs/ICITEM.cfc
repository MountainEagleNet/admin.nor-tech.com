<cfcomponent extends="admin.assets.cfcs.Component">
	<cfset This.DataSourceName = APPLICATION.DSN_AP>

<!---<cfset This.Columns = "ITEMNO,CATEGORY,DEFPRICLST,SERIALNO">--->
<!---<cfset This.Columns = "ITEMNO,CATEGORY,DEFPRICLST,OPTFLD1,ALLOWONWEB">--->
	<cfset This.Columns = "ITEMNO,CATEGORY,DEFPRICLST,ALLOWONWEB">				<!--- RAB 08/09/2012 --->

	<cfset This.ViewColumns = This.Columns>
	<cfset This.DESCColumn = "DESC">

	<cfset This.TableName = "dbo.ICITEM">
	<cfset This.ViewName = This.TableName>
	
	<cfset This.PrimaryKey = "ITEMNO">
	<cfset This.ITEMNOKey = "">
	<cfset This.GenerateUUIDKey = 0>
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
	
</cfcomponent>