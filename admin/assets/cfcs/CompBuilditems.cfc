<cfcomponent extends="admin.assets.cfcs.Component">

	<cfif isDefined("APPLICATION.DSN_WWW")>
		<cfset This.DataSourceName = APPLICATION.DSN_WWW>
	<cfelse>
		<cfset This.DataSourceName = "NorTechWWW">
	</cfif>

	<cfset This.Columns = "CompBuildItemsID,ITEMNO,ITEMDESC">
	<cfset This.ViewColumns = This.Columns>
	
	<cfset This.TableName = "tblCompBuilditems">
	<cfset This.ViewName = This.TableName>
	
	<cfset This.PrimaryKey = "CompBuildItemsID">
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

	<cffunction name="isCompBuildItem" access="public" returntype="boolean" output="No">
	<cfargument name="ITEMNO" type="string" required="Yes">
		<cfset var isCompBuildItem = 0>
        <cfset var qryCompBuildItem = queryNew("")>
        <cfset Arguments.ITEMNO = trim(Arguments.ITEMNO)>
        <cfquery datasource="#This.DataSourceName#" name="qryCompBuildItem">
        SELECT	CompBuildItemsID
        FROM 	tblCompBuildItems
        WHERE 	ITEMNO = '#Arguments.ITEMNO#'
        </cfquery>
        <cfif qryCompBuildItem.RecordCount NEQ 0>
			<cfset isCompBuildItem = 1>
		</cfif>
		<cfreturn isCompBuildItem>
	</cffunction>

</cfcomponent>