<cfcomponent extends="admin.assets.cfcs.Component">
	<cfset This.DataSourceName = APPLICATION.DSN_AP>

	<cfset This.Columns = "ADJENSEQ,DOCNUM,HDRDESC,TRANSDATE,STATUS,DELETED">
	<cfset This.ViewColumns = This.Columns>
	<cfset This.ColumnTypes = "Integer,VarChar,VarChar,Decimal,Integer,Integer">

	<cfset This.TableName = "dbo.ICADEH">
	<cfset This.ViewName = This.TableName>
	
	<cfset This.PrimaryKey = "ADJENSEQ">
	<cfset This.ITEMNOKey = "">
	<cfset This.GenerateUUIDKey = 0>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "DOCNUM">
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
	
	<cffunction name="listAdjustments" access="public" returntype="query" output="No">
	<cfargument name="OrderByList" type="string" required="No">
	<cfargument name="LookBackDays" type="numeric" required="no">

		<cfset var qryFinal = queryNew(This.ViewColumns)>
		
		<cfif NOT isDefined("Arguments.OrderByList")>
			<cfset Arguments.OrderByList = This.SortColumn & " " & This.SortOrder>
		</cfif>
		<cfif NOT isDefined("Arguments.LookBackDays")>
			<cfset Arguments.LookBackDays = 15>
		</cfif>
		
		<cfset objSerialsAdjustments = createObject("component", "admin.assets.cfcs.SerialsAdjustments")>
		<cfset objSerialsAdjustmentsExclude = createObject("component", "admin.assets.cfcs.SerialsAdjustmentsExclude")>

		<!--- Retrieve all lines for serialized items that were received within the last 5 days --->
<!---	<cfset FiveDaysAgo = dateFormat(dateAdd("d", -5, now()), "yyyymmdd")>	--->
		<cfset XDaysAgo = dateFormat(dateAdd("d", -(Arguments.LookBackDays), now()), "yyyymmdd")>
<!---        
		<cfquery datasource="#This.DataSourceName#" name="qryICADED">
			SELECT	dbo.ICADED.*
			FROM	dbo.ICADED INNER JOIN
					dbo.ICITEM ON dbo.ICADED.ITEMNO = dbo.ICITEM.ITEMNO INNER JOIN
					dbo.ICADEH ON dbo.ICADED.ADJENSEQ = dbo.ICADEH.ADJENSEQ
			WHERE	(dbo.ICITEM.OPTFLD1 = 'Y') AND 
<!---				(dbo.ICADEH.TRANSDATE > '#FiveDaysAgo#') AND 	--->
					(dbo.ICADEH.TRANSDATE > '#XDaysAgo#') AND 
					(dbo.ICADEH.STATUS > 1) AND
					(dbo.ICADEH.DELETED  = 0) AND
					(dbo.ICADED.QUANTITY > 0)
			ORDER BY dbo.ICADED.ADJENSEQ, dbo.ICADED.[LINENO]
		</cfquery>
--->
        
		<cfquery datasource="#This.DataSourceName#" name="qryICADED">							<!--- RAB 08/09/2012 --->
			SELECT	dbo.ICADED.*
			FROM	dbo.ICADED INNER JOIN
					dbo.ICITEM ON dbo.ICADED.ITEMNO = dbo.ICITEM.ITEMNO INNER JOIN
					dbo.ICADEH ON dbo.ICADED.ADJENSEQ = dbo.ICADEH.ADJENSEQ
                    
                    INNER JOIN dbo.ICITEMO ON dbo.ICITEM.ITEMNO = dbo.ICITEMO.ITEMNO			<!--- RAB 08/09/2012 --->
                    
			WHERE	(dbo.ICITEMO.OPTFIELD = 'SERIALNUM') AND (dbo.ICITEMO.VALUE = 'Y') AND		<!--- RAB 08/09/2012 --->

            		(dbo.ICADEH.TRANSDATE > '#XDaysAgo#') AND 
					(dbo.ICADEH.STATUS > 1) AND
					(dbo.ICADEH.DELETED  = 0) AND
					(dbo.ICADED.QUANTITY > 0)
			ORDER BY dbo.ICADED.ADJENSEQ, dbo.ICADED.[LINENO]
		</cfquery>
			
		<cfset SavedADJENSEQ = "">
		<cfset qryRecords = queryNew(This.ViewColumns, This.ColumnTypes)>
		<cfloop query="qryICADED">
		
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "ADJENSEQ", qryICADED.ADJENSEQ, True)>
			<cfset qrySerialsAdjustmentsExclude = objSerialsAdjustmentsExclude.searchRecords(SearchRecord, "query")>

			<cfif qrySerialsAdjustmentsExclude.RecordCount EQ 0>
			
				<cfif qryICADED.ADJENSEQ IS NOT SavedADJENSEQ>
					<cfset SavedADJENSEQ = qryICADED.ADJENSEQ>
					<cfset ThisAdjustmentAdded = 0>
				</cfif>
	
				<cfif NOT ThisAdjustmentAdded>
	
					<!--- Get all posted serial numbers for this line --->
					<cfset SearchRecord = structNew()>
					<cfset structInsert(SearchRecord, "ADJENSEQ", qryICADED.ADJENSEQ, True)>
					<cfset structInsert(SearchRecord, "LINENO", qryICADED.LINENO, True)>
					<cfset structInsert(SearchRecord, "Posted", 1, True)>
					<cfset qrySerialsAdjustments = objSerialsAdjustments.searchRecords(SearchRecord, "query")>
					
					<!--- If no posted serial numbers --->
					<cfif qrySerialsAdjustments.RecordCount EQ 0>
						<cfset strICADEH = getRecord(qryICADED.ADJENSEQ)>
						<cfset queryAddRow(qryRecords)>
						<cfset querySetCell(qryRecords, "ADJENSEQ", strICADEH.ADJENSEQ)>
						<cfset querySetCell(qryRecords, "DOCNUM", strICADEH.DOCNUM)>
						<cfset querySetCell(qryRecords, "HDRDESC", strICADEH.HDRDESC)>
						<cfset querySetCell(qryRecords, "TRANSDATE", strICADEH.TRANSDATE)>
						<cfset querySetCell(qryRecords, "STATUS", strICADEH.STATUS)>
						<cfset querySetCell(qryRecords, "DELETED", strICADEH.DELETED)>
						<cfset ThisAdjustmentAdded = 1>
					</cfif>
	
				</cfif>
				
			</cfif>

		</cfloop>

		<cfquery dbtype="query" name="qryFinal">
		SELECT 	*
		FROM 	qryRecords
		ORDER BY #Arguments.OrderByList#
		</cfquery>		

		<cfreturn qryFinal>
	</cffunction>
	
</cfcomponent>