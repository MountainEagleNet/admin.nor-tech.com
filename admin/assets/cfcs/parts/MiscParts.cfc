<cfcomponent extends="admin.assets.cfcs.Component">

	<cfif isDefined("APPLICATION.DSN_WWW")>
		<cfset This.DataSourceName = APPLICATION.DSN_WWW>
	<cfelse>
		<cfset This.DataSourceName = "NorTechWWW">
	</cfif>

	<cfif isDefined("APPLICATION.DSN_AP")>
		<cfset This.APDataSourceName = APPLICATION.DSN_AP>
	<cfelse>
		<cfset This.APDataSourceName = "NorTechAP">
	</cfif>


	<cfset This.Columns = "MiscPartID,UserID,MfgrPartNumber,Description,Cost,Notes,ComponentCategoryID">
	<cfset This.ViewColumns = This.Columns>
	
	<cfset This.TableName = "tblMiscParts">
	<cfset This.ViewName = This.TableName>
	
	<cfset This.PrimaryKey = "MiscPartID">
	<cfset This.ForeignHeaderKey = "">
	<cfset This.ForeignDetailKey = "">
	
	<cfset This.ITEMNOKey = "">	

	<cfset This.GenerateUUIDKey = 1>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "MfgrPartNumber">
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
	
	<cffunction name="validateRecord" access="public" returntype="struct" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
		<cfif validateRequired(Arguments.Record.MfgrPartNumber) EQ 0>
			<cfset stErrors.MfgrPartNumber = "Please enter the manufacturer's part number">
		</cfif>
		<cfif validateRequired(Arguments.Record.Description) EQ 0>
			<cfset stErrors.Description = "Please enter a description for this part">
		</cfif>
		<cfif validateRequired(Arguments.Record.Cost) EQ 0>
			<cfset stErrors.Cost = "You must enter a selling price.">
		<cfelseif validateZeroDecimal(Arguments.Record.Cost) EQ 0>
			<cfset stErrors.Cost = "Please enter a numeric value greater than or equal to zero.">
		</cfif>
		<cfreturn stErrors>
	</cffunction>
	
	
</cfcomponent>