<cfcomponent extends="admin.assets.cfcs.Component">

	<!---RAB--->
<!---<cfset This.DataSourceName = APPLICATION.DSN_AP>--->
	<cfif isDefined("APPLICATION.DSN_AP")>
		<cfset This.DataSourceName = APPLICATION.DSN_AP>
	<cfelse>
		<cfset This.DataSourceName = "NorTechAP">
	</cfif>

	<cfset This.Columns = "ORDUNIQ,LINENUM,ITEM,ORIGQTY,QTYSHPTODT,QTYORDERED,LOCATION">
	<cfset This.ViewColumns = This.Columns>
	<cfset This.DESCColumn = "DESC">

	<cfset This.TableName = "dbo.OEORDD">
	<cfset This.ViewName = This.TableName>
	
	<cfset This.PrimaryKey = "ORDUNIQ">
	<cfset This.ITEMNOKey = "ITEM">
	<cfset This.QuantityKey = "ORIGQTY">

	<cfset This.GenerateUUIDKey = 0>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "LINENUM">
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

	<cffunction name="getLinesForItems" access="public" returntype="query" output="No">
	<cfargument name="ORDUNIQ" type="string" required="Yes">
	<cfargument name="ITEMNO1" type="string" required="Yes">
	<cfargument name="ITEMNO2" type="string" required="Yes">
		<cfset var qryRecords = queryNew(This.ViewColumns)>
		<cfquery datasource="#This.DataSourceName#" name="qryRecords">
		SELECT 	#This.ViewColumns#
		FROM 	#This.ViewName#
		WHERE 	#This.PrimaryKey# = '#Arguments.ORDUNIQ#'
				<cfif Arguments.ITEMNO1 IS NOT "" OR Arguments.ITEMNO2 IS NOT "">
					AND (
						<cfif Arguments.ITEMNO1 IS NOT "">
							#This.ITEMNOKey# = '#Arguments.ITEMNO1#'
						</cfif>
						<cfif Arguments.ITEMNO1 IS NOT "" AND Arguments.ITEMNO2 IS NOT "">
							OR
						</cfif>
						<cfif Arguments.ITEMNO2 IS NOT "">
							#This.ITEMNOKey# = '#Arguments.ITEMNO2#'
						</cfif>
					)
				</cfif>
		ORDER BY LINENUM
		</cfquery>
		<cfreturn qryRecords>
	</cffunction>
	
</cfcomponent>