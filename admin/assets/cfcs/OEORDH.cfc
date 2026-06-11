<cfcomponent extends="admin.assets.cfcs.Component">

	<!---RAB--->
<!---<cfset This.DataSourceName = APPLICATION.DSN_AP>--->
	<cfif isDefined("APPLICATION.DSN_AP")>
		<cfset This.DataSourceName = APPLICATION.DSN_AP>
	<cfelse>
		<cfset This.DataSourceName = "NorTechAP">
	</cfif>

	<cfset This.Columns = "ORDUNIQ,ORDNUMBER,ORDDATE,CUSTOMER,BILNAME,SHPNAME">
	<cfset This.ViewColumns = This.Columns>
	
	<cfset This.TableName = "dbo.OEORDH">
	<cfset This.ViewName = This.TableName>
	
	<cfset This.PrimaryKey = "ORDUNIQ">
	<cfset This.ITEMNOKey = "">
	<cfset This.GenerateUUIDKey = 0>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "ORDNUMBER">
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

	<cffunction name="getOrdersByDateRange" access="public" returntype="query" output="No">
	<cfargument name="BeginningDate" type="string" required="Yes">
	<cfargument name="EndingDate" type="string" required="Yes">
		<cfset var qryRecords = queryNew(This.ViewColumns)>
		<cfquery datasource="#This.DataSourceName#" name="qryRecords">
		SELECT 	#This.ViewColumns#
		FROM 	#This.ViewName#
		WHERE 	#This.PrimaryKey# > 0
				<cfif Arguments.BeginningDate IS NOT "">
					AND ORDDATE >= #Arguments.BeginningDate#
				</cfif>
				<cfif Arguments.EndingDate IS NOT "">
					AND ORDDATE <= #Arguments.EndingDate#
				</cfif>
		ORDER BY ORDDATE, ORDNUMBER
		</cfquery>
		<cfreturn qryRecords>
	</cffunction>
	
</cfcomponent>