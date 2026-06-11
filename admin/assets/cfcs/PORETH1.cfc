<cfcomponent extends="admin.assets.cfcs.Component">
	<cfset This.DataSourceName = APPLICATION.DSN_AP>

	<cfset This.Columns = "RETHSEQ,RETNUMBER,DATE,VDCODE,VDNAME">
	<cfset This.ViewColumns = This.Columns>
	<cfset This.ColumnTypes = "Decimal,VarChar,Decimal,VarChar,VarChar">

	<cfset This.TableName = "dbo.PORETH1">
	<cfset This.ViewName = This.TableName>
	
	<cfset This.PrimaryKey = "RETHSEQ">
	<cfset This.ITEMNOKey = "">
	<cfset This.GenerateUUIDKey = 0>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "RETNUMBER">
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
	
	<cffunction name="listVendorReturns" access="public" returntype="query" output="YES">
	<cfargument name="OrderByList" type="string" required="No">
	<cfargument name="LookBackDays" type="numeric" required="no">

		<cfset var qryFinal = queryNew(This.ViewColumns)>

		<cfif NOT isDefined("Arguments.OrderByList")>
			<cfset Arguments.OrderByList = This.SortColumn & " " & This.SortOrder>
		</cfif>
		<cfif NOT isDefined("Arguments.LookBackDays")>
			<cfset Arguments.LookBackDays = 5>
		</cfif>

		<cfset objSerialsVendorReturns = createObject("component", "admin.assets.cfcs.SerialsVendorReturns")>

		<!--- Retrieve all lines for serialized items that were received within the last 5 days --->
<!---	<cfset FiveDaysAgo = dateFormat(dateAdd("d", -5, now()), "yyyymmdd")>	--->
		<cfset XDaysAgo = dateFormat(dateAdd("d", -(Arguments.LookBackDays), now()), "yyyymmdd")>
<!---        
		<cfquery datasource="#This.DataSourceName#" name="qryPORETL">
			SELECT	dbo.PORETL.*
			FROM	dbo.PORETL INNER JOIN
					dbo.ICITEM ON dbo.PORETL.ITEMNO = dbo.ICITEM.ITEMNO INNER JOIN
					dbo.PORETH1 ON dbo.PORETL.RETHSEQ = dbo.PORETH1.RETHSEQ
<!---		WHERE	(dbo.ICITEM.OPTFLD1 = 'Y') AND (dbo.PORETH1.[DATE] > '#FiveDaysAgo#')	--->
			WHERE	(dbo.ICITEM.OPTFLD1 = 'Y') AND (dbo.PORETH1.[DATE] > '#XDaysAgo#')
			ORDER BY dbo.PORETL.RETHSEQ, dbo.PORETL.RETLREV
		</cfquery>
--->
		<cfquery datasource="#This.DataSourceName#" name="qryPORETL">					<!--- RAB 08/09/2012 --->
			SELECT	dbo.PORETL.*
			FROM	dbo.PORETL INNER JOIN
					dbo.ICITEM ON dbo.PORETL.ITEMNO = dbo.ICITEM.ITEMNO INNER JOIN
					dbo.PORETH1 ON dbo.PORETL.RETHSEQ = dbo.PORETH1.RETHSEQ
                    
                    INNER JOIN dbo.ICITEMO ON dbo.ICITEM.ITEMNO = dbo.ICITEMO.ITEMNO			<!--- RAB 08/09/2012 --->
                    
			WHERE	(dbo.ICITEMO.OPTFIELD = 'SERIALNUM') AND (dbo.ICITEMO.VALUE = 'Y') AND		<!--- RAB 08/09/2012 --->
            
            		(dbo.PORETH1.[DATE] > '#XDaysAgo#')
			ORDER BY dbo.PORETL.RETHSEQ, dbo.PORETL.RETLREV
		</cfquery>

		<cfset SavedRETHSEQ = "">
		<cfset qryRecords = queryNew(This.ViewColumns, This.ColumnTypes)>
		<cfloop query="qryPORETL">
			<cfif qryPORETL.RETHSEQ IS NOT SavedRETHSEQ>
				<cfset SavedRETHSEQ = qryPORETL.RETHSEQ>
				<cfset ThisVendorReturnAdded = 0>
			</cfif>

			<cfif NOT ThisVendorReturnAdded>
				<!--- Get all posted serial numbers for this line --->
				<cfset SearchRecord = structNew()>
				<cfset structInsert(SearchRecord, "RETHSEQ", qryPORETL.RETHSEQ, True)>
				<cfset structInsert(SearchRecord, "RETLREV", qryPORETL.RETLREV, True)>
				<cfset structInsert(SearchRecord, "Posted", 1, True)>
				<cfset qrySerialsVendorReturns = objSerialsVendorReturns.searchRecords(SearchRecord, "query")>
				
				<!--- If no posted serial numbers --->
				<cfif qrySerialsVendorReturns.RecordCount EQ 0>
					<cfset strPORETH1 = getRecord(qryPORETL.RETHSEQ)>
					<cfset queryAddRow(qryRecords)>
					<cfset querySetCell(qryRecords, "RETHSEQ", strPORETH1.RETHSEQ)>
					<cfset querySetCell(qryRecords, "RETNUMBER", strPORETH1.RETNUMBER)>
					<cfset querySetCell(qryRecords, "DATE", strPORETH1.DATE)>
					<cfset querySetCell(qryRecords, "VDCODE", strPORETH1.VDCODE)>
					<cfset querySetCell(qryRecords, "VDNAME", strPORETH1.VDNAME)>
					<cfset ThisVendorReturnAdded = 1>
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