<cfcomponent extends="admin.assets.cfcs.Component">
	<cfset This.DataSourceName = APPLICATION.DSN_AP>

	<cfset This.Columns = "RCPHSEQ,RCPNUMBER,DATE,VDCODE,VDNAME,Reference">
	<cfset This.ViewColumns = This.Columns>
	<cfset This.ColumnTypes = "Decimal,VarChar,Decimal,VarChar,VarChar,VarChar">

	<cfset This.TableName = "dbo.PORCPH1">
	<cfset This.ViewName = This.TableName>
	
	<cfset This.PrimaryKey = "RCPHSEQ">
	<cfset This.ITEMNOKey = "">
	<cfset This.GenerateUUIDKey = 0>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "RCPNUMBER">
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
	
	<cffunction name="listReceipts" access="public" returntype="query" output="No">
	<cfargument name="OrderByList" type="string" required="No">
	<cfargument name="LookBackDays" type="numeric" required="no">
	<cfargument name="OmitDropShip" type="boolean" required="no">
	
		<cfset var qryFinal = queryNew(This.ViewColumns)>
		
		<cfif NOT isDefined("Arguments.OrderByList")>
			<cfset Arguments.OrderByList = This.SortColumn & " " & This.SortOrder>
		</cfif>
		<cfif NOT isDefined("Arguments.LookBackDays")>
			<cfset Arguments.LookBackDays = 5>
		</cfif>
		<cfif NOT isDefined("Arguments.OmitDropShip")>
			<cfset Arguments.OmitDropShip = 0>
		</cfif>

		<cfset objSerialsReceipts = createObject("component", "admin.assets.cfcs.SerialsReceipts")>
		<cfset objSerialsReceiptsExclude = createObject("component", "admin.assets.cfcs.SerialsReceiptsExclude")>

		<!--- Retrieve all lines for serialized items that were received within the last 5 days --->
<!---	<cfset FiveDaysAgo = dateFormat(dateAdd("d", -5, now()), "yyyymmdd")>	--->
		<cfset XDaysAgo = dateFormat(dateAdd("d", -(Arguments.LookBackDays), now()), "yyyymmdd")>
        
<!---        
		<cfquery datasource="#This.DataSourceName#" name="qryPORCPL">
			SELECT	dbo.PORCPL.*
			FROM	dbo.PORCPL INNER JOIN
					dbo.ICITEM ON dbo.PORCPL.ITEMNO = dbo.ICITEM.ITEMNO INNER JOIN
					dbo.PORCPH1 ON dbo.PORCPL.RCPHSEQ = dbo.PORCPH1.RCPHSEQ
<!---		WHERE	(dbo.ICITEM.OPTFLD1 = 'Y') AND (dbo.PORCPH1.[DATE] > '#FiveDaysAgo#')	--->
			WHERE	(dbo.ICITEM.OPTFLD1 = 'Y') AND (dbo.PORCPH1.[DATE] > '#XDaysAgo#')
					<cfif Arguments.OmitDropShip>
						AND (dbo.PORCPH1.Reference NOT LIKE 'drop%')
					</cfif>
			
			ORDER BY dbo.PORCPL.RCPHSEQ, dbo.PORCPL.RCPLREV
		</cfquery>
--->		
	
    
    
    
		<cfquery datasource="#This.DataSourceName#" name="qryPORCPL">
			SELECT	<!---dbo.PORCPL.*--->
            		dbo.PORCPL.RCPHSEQ, dbo.PORCPL.RCPLREV										<!--- RAB 08/09/2012 (Optimizing the Search) --->

			FROM	dbo.PORCPL INNER JOIN
					dbo.ICITEM ON dbo.PORCPL.ITEMNO = dbo.ICITEM.ITEMNO INNER JOIN
					dbo.PORCPH1 ON dbo.PORCPL.RCPHSEQ = dbo.PORCPH1.RCPHSEQ
                    
                    INNER JOIN dbo.ICITEMO ON dbo.ICITEM.ITEMNO = dbo.ICITEMO.ITEMNO			<!--- RAB 08/09/2012 --->
                    
			WHERE	<!---(dbo.ICITEM.OPTFLD1 = 'Y') AND---> (dbo.PORCPH1.[DATE] > '#XDaysAgo#')	<!--- RAB 08/09/2012 --->

					AND (dbo.ICITEMO.OPTFIELD = 'SERIALNUM') AND (dbo.ICITEMO.VALUE = 'Y')		<!--- RAB 08/09/2012 --->

					<cfif Arguments.OmitDropShip>
						AND (dbo.PORCPH1.Reference NOT LIKE 'drop%')
					</cfif>
			
			ORDER BY dbo.PORCPL.RCPHSEQ, dbo.PORCPL.RCPLREV
		</cfquery>

		
		<cfset SavedRCPHSEQ = "">
		<cfset qryRecords = queryNew(This.ViewColumns, This.ColumnTypes)>
		<cfloop query="qryPORCPL">
		
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "RCPHSEQ", qryPORCPL.RCPHSEQ, True)>
			<cfset qrySerialsReceiptsExclude = objSerialsReceiptsExclude.searchRecords(SearchRecord, "query")>
<!---		
			<cfquery datasource="#APPLICATION.DSN_WWW#" name="qrySerialsReceiptsExclude">
				SELECT	*
				FROM	tblSerialsReceiptsExclude
				WHERE	tblSerialsReceiptsExclude.RCPHSEQ = '#qryPORCPL.RCPHSEQ#'
			</cfquery>
--->
			<cfif qrySerialsReceiptsExclude.RecordCount EQ 0>
		
				<cfif qryPORCPL.RCPHSEQ IS NOT SavedRCPHSEQ>
					<cfset SavedRCPHSEQ = qryPORCPL.RCPHSEQ>
					<cfset ThisReceiptAdded = 0>
				</cfif>
	
				<cfif NOT ThisReceiptAdded>
	
					<!--- Get all posted serial numbers for this line --->
					<cfset SearchRecord = structNew()>
					<cfset structInsert(SearchRecord, "RCPHSEQ", qryPORCPL.RCPHSEQ, True)>
					<cfset structInsert(SearchRecord, "RCPLREV", qryPORCPL.RCPLREV, True)>
					<cfset structInsert(SearchRecord, "Posted", 1, True)>
					<cfset qrySerialsReceipts = objSerialsReceipts.searchRecords(SearchRecord, "query")>
					
					<!--- If no posted serial numbers --->
					<cfif qrySerialsReceipts.RecordCount EQ 0>
						<cfset strPORCPH1 = getRecord(qryPORCPL.RCPHSEQ)>
						<cfset queryAddRow(qryRecords)>
						<cfset querySetCell(qryRecords, "RCPHSEQ", strPORCPH1.RCPHSEQ)>
						<cfset querySetCell(qryRecords, "RCPNUMBER", strPORCPH1.RCPNUMBER)>
						<cfset querySetCell(qryRecords, "DATE", strPORCPH1.DATE)>
						<cfset querySetCell(qryRecords, "VDCODE", strPORCPH1.VDCODE)>
						<cfset querySetCell(qryRecords, "VDNAME", strPORCPH1.VDNAME)>
						<cfset ThisReceiptAdded = 1>
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