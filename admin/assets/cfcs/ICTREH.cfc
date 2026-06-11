<cfcomponent extends="admin.assets.cfcs.Component">
	<cfset This.DataSourceName = APPLICATION.DSN_AP>

	<cfset This.Columns = "TRANFENSEQ,DOCNUM,HDRDESC,TRANSDATE,STATUS,DELETED">
	<cfset This.ViewColumns = This.Columns>
	<cfset This.ColumnTypes = "Integer,VarChar,VarChar,Decimal,Integer,Integer">

	<cfset This.TableName = "dbo.ICTREH">
	<cfset This.ViewName = This.TableName>
	
	<cfset This.PrimaryKey = "TRANFENSEQ">
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
	
	<cffunction name="listTransfers" access="public" returntype="query" output="No">
	<cfargument name="OrderByList" type="string" required="No">
	<cfargument name="LookBackDays" type="numeric" required="no">

		<cfset var qryFinal = queryNew(This.ViewColumns)>
		
		<cfif NOT isDefined("Arguments.OrderByList")>
			<cfset Arguments.OrderByList = This.SortColumn & " " & This.SortOrder>
		</cfif>
		<cfif NOT isDefined("Arguments.LookBackDays")>
			<cfset Arguments.LookBackDays = 15>
		</cfif>

		<cfset objSerialsTransfers = createObject("component", "admin.assets.cfcs.SerialsTransfers")>

		<!--- Retrieve all lines for serialized items that were received within the last 5 days --->
<!---	<cfset FiveDaysAgo = dateFormat(dateAdd("d", -5, now()), "yyyymmdd")>	--->
		<cfset XDaysAgo = dateFormat(dateAdd("d", -(Arguments.LookBackDays), now()), "yyyymmdd")>
<!---        
		<cfquery datasource="#This.DataSourceName#" name="qryICTRED">
			SELECT	dbo.ICTRED.*
			FROM	dbo.ICTRED INNER JOIN
					dbo.ICITEM ON dbo.ICTRED.ITEMNO = dbo.ICITEM.ITEMNO INNER JOIN
					dbo.ICTREH ON dbo.ICTRED.TRANFENSEQ = dbo.ICTREH.TRANFENSEQ
			WHERE	(dbo.ICITEM.OPTFLD1 = 'Y') AND 
<!---				(dbo.ICTREH.TRANSDATE > '#FiveDaysAgo#') AND --->
					(dbo.ICTREH.TRANSDATE > '#XDaysAgo#') AND 
					(dbo.ICTREH.STATUS > 1) AND
					(dbo.ICTREH.DELETED  = 0)
			ORDER BY dbo.ICTRED.TRANFENSEQ, dbo.ICTRED.[LINENO]
		</cfquery>
--->			
		<cfquery datasource="#This.DataSourceName#" name="qryICTRED">					<!--- RAB 08/09/2012 --->
			SELECT	dbo.ICTRED.*
			FROM	dbo.ICTRED INNER JOIN
					dbo.ICITEM ON dbo.ICTRED.ITEMNO = dbo.ICITEM.ITEMNO INNER JOIN
					dbo.ICTREH ON dbo.ICTRED.TRANFENSEQ = dbo.ICTREH.TRANFENSEQ
                    
                    INNER JOIN dbo.ICITEMO ON dbo.ICITEM.ITEMNO = dbo.ICITEMO.ITEMNO			<!--- RAB 08/09/2012 --->

			WHERE	(dbo.ICITEMO.OPTFIELD = 'SERIALNUM') AND (dbo.ICITEMO.VALUE = 'Y') AND		<!--- RAB 08/09/2012 --->
            
					(dbo.ICTREH.TRANSDATE > '#XDaysAgo#') AND 
					(dbo.ICTREH.STATUS > 1) AND
					(dbo.ICTREH.DELETED  = 0)
			ORDER BY dbo.ICTRED.TRANFENSEQ, dbo.ICTRED.[LINENO]
		</cfquery>
			
		<cfset SavedTRANFENSEQ = "">
		<cfset qryRecords = queryNew(This.ViewColumns, This.ColumnTypes)>
		<cfloop query="qryICTRED">
			<cfif qryICTRED.TRANFENSEQ IS NOT SavedTRANFENSEQ>
				<cfset SavedTRANFENSEQ = qryICTRED.TRANFENSEQ>
				<cfset ThisTransferAdded = 0>
			</cfif>

			<cfif NOT ThisTransferAdded>

				<!--- Get all posted serial numbers for this line --->
				<cfset SearchRecord = structNew()>
				<cfset structInsert(SearchRecord, "TRANFENSEQ", qryICTRED.TRANFENSEQ, True)>
				<cfset structInsert(SearchRecord, "LINENO", qryICTRED.LINENO, True)>
				<cfset structInsert(SearchRecord, "Posted", 1, True)>
				<cfset qrySerialsTransfers = objSerialsTransfers.searchRecords(SearchRecord, "query")>
				
				<!--- If no posted serial numbers --->
				<cfif qrySerialsTransfers.RecordCount EQ 0>
					<cfset strICTREH = getRecord(qryICTRED.TRANFENSEQ)>
					<cfset queryAddRow(qryRecords)>
					<cfset querySetCell(qryRecords, "TRANFENSEQ", strICTREH.TRANFENSEQ)>
					<cfset querySetCell(qryRecords, "DOCNUM", strICTREH.DOCNUM)>
					<cfset querySetCell(qryRecords, "HDRDESC", strICTREH.HDRDESC)>
					<cfset querySetCell(qryRecords, "TRANSDATE", strICTREH.TRANSDATE)>
					<cfset querySetCell(qryRecords, "STATUS", strICTREH.STATUS)>
					<cfset querySetCell(qryRecords, "DELETED", strICTREH.DELETED)>
					<cfset ThisTransferAdded = 1>
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