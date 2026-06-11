<cfcomponent extends="admin.assets.cfcs.Component">
	<cfset This.DataSourceName = APPLICATION.DSN_WWW>

	<cfset This.TableName = "tblComponentCategories">
	<cfset This.ViewName = This.TableName>

	<cfset This.Columns = "ComponentCategoryID,CATEGORY,Name,SortOrder,IsAdditionalWarranty">
	<cfset This.ViewColumns = This.Columns>
	
	<cfset This.PrimaryKey = "ComponentCategoryID">
	
	<cfset This.GenerateUUIDKey = 1>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "SortOrder">
	<cfset This.SortOrder = "Asc">

	<cfset This.SortOrderList = "">
	<cfset This.SortKey = "SortOrder">
	<cfset This.ParentKey = "">
	<cfset This.CreatedKey = "">
	<cfset This.ModifiedKey = "">
	<cfset This.ZipCode1Key = "">
	<cfset This.ZipCode2Key = "">
	<cfset This.SavePrimaryKey = 0>
	<cfset This.ExcludeInUpdates = "">
	<cfset This.ExcludeInInserts = "">

	<cffunction name="listACCPACCategories" access="public" returntype="query" output="No">
	<!--- Returns a query of categories from dbo.ICCATG --->
		<cfset var qryRecords = queryNew("CATEGORY,DESC")>
		<cfquery datasource="#APPLICATION.DSN_AP#" name="qryRecords">
		SELECT 	CATEGORY, [DESC]
		FROM 	dbo.ICCATG
		ORDER BY CATEGORY
		</cfquery>
		<cfreturn qryRecords>
	</cffunction>

	<cffunction name="getACCPACCategoryDescription" access="public" returntype="string" output="no">
	<cfargument name="CATEGORY" type="string" required="Yes">
		<cfset var CategoryDescription = "">
		<cfquery datasource="#APPLICATION.DSN_AP#" name="qryRecords">
		SELECT 	[DESC]
		FROM 	dbo.ICCATG
		WHERE 	CATEGORY = '#trim(Arguments.CATEGORY)#'
		</cfquery>
		<cfif qryRecords.RecordCount NEQ 0>
			<cfset CategoryDescription = trim(qryRecords.DESC)>
		</cfif>
		<cfreturn CategoryDescription>
	</cffunction>


	<cffunction name="validateRecord" access="public" returntype="struct" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
		<cfif validateRequired(Arguments.Record.Name) EQ 0>
			<cfset stErrors.Name = "Please enter a name for the component category">
		</cfif>
		<cfif validateRequired(Arguments.Record.CATEGORY) EQ 0>
			<cfset stErrors.CATEGORY = "Please make a selection for the category">
		</cfif>
		<cfreturn stErrors>
	</cffunction>

<!---
	<cffunction name="renumberSortOrder" access="public" output="No">
		<cfset qryComponentCategories = listRecords("query", "SortOrder")>
		<cfset SortOrderNumber = 1>
		<cfloop query="qryComponentCategories">
			<cfset strComponentCategory = getRecord(qryComponentCategories.ComponentCategoryID)>
			<cfset structInsert(strComponentCategory, "SortOrder", SortOrderNumber, True)>
			<cfset SortOrderNumber = SortOrderNumber + 1>
			<cfset saveRecord(strComponentCategory)>
		</cfloop>
	</cffunction>
--->

</cfcomponent>