<cfcomponent extends="admin.assets.cfcs.Component">
	<cfset This.DataSourceName = APPLICATION.DSN_WWW>

	<cfset This.Columns = "SerialNumberAuditTrailID,TransactionType,TransactionNumber,CreationDate,UserFirstName,UserLastName,UserEmail,ApprovalPassword,ITEMNO,ITEMDESC,SerialNumber,AddorRemove,LOCATION,LOCATIONDESC,CUSTOMER,BILNAME,VDCODE,VDNAME,SerialTable,SerialTableIDField,SerialTableIDValue">
	<cfset This.ViewColumns = This.Columns>
	
	<cfset This.TableName = "tblSerialNumberAuditTrail">
	<cfset This.ViewName = This.TableName>
	
	<cfset This.PrimaryKey = "SerialNumberAuditTrailID">
	<cfset This.ForeignHeaderKey = "">
	<cfset This.ForeignDetailKey = "">

	<cfset This.GenerateUUIDKey = 1>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "SerialNumber">
	<cfset This.SortOrder = "Asc">

	<cfset This.SortOrderList = "">
	<cfset This.SortKey = "">
	<cfset This.ParentKey = "">
	<cfset This.CreatedKey = "CreationDate">
	<cfset This.ModifiedKey = "">
	<cfset This.ZipCode1Key = "">
	<cfset This.ZipCode2Key = "">
	<cfset This.SavePrimaryKey = 0>
	<cfset This.ExcludeInUpdates = "">
	<cfset This.ExcludeInInserts = "">
	
	<cffunction name="findSerialNumber" access="public" returntype="query" output="no">
	<cfargument name="SerialNumber" type="string" required="Yes">
	<cfargument name="ExactMatch" type="boolean" required="No">
		<cfset var qryFinal = queryNew("SerialNumber,ITEMNO,ITEMDESC")>
		<cfif NOT isDefined("Arguments.ExactMatch")>
			<cfset Arguments.ExactMatch = 0>
		</cfif>
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "SerialNumber", Arguments.SerialNumber, True)>
<!---	<cfset qryRecords = searchRecords(SearchRecord, "query", "SerialNumber, ITEMNO", 0)>--->
		<cfset qryRecords = searchRecords(SearchRecord, "query", "SerialNumber, ITEMNO", Arguments.ExactMatch)>
		<cfset SavedSerialNumber = "">
		<cfset SavedITEMNO = "">
		<cfloop query="qryRecords">
			<cfif trim(qryRecords.SerialNumber) IS NOT trim(SavedSerialNumber) OR trim(qryRecords.ITEMNO) IS NOT trim(SavedITEMNO)>
				<cfset SavedSerialNumber = qryRecords.SerialNumber>
				<cfset SavedITEMNO = qryRecords.ITEMNO>
				<cfset queryAddRow(qryFinal)>
				<cfset querySetCell(qryFinal, "SerialNumber", qryRecords.SerialNumber)>
				<cfset querySetCell(qryFinal, "ITEMNO", qryRecords.ITEMNO)>
				<cfset querySetCell(qryFinal, "ITEMDESC", qryRecords.ITEMDESC)>
			</cfif>
		</cfloop>
		<cfreturn qryFinal>
	</cffunction>

	<cffunction name="serialNumberHistoryReport" access="public" returntype="query" output="no">
	<cfargument name="SerialNumber" type="string" required="Yes">
	<cfargument name="ITEMNO" type="string" required="Yes">
	<cfargument name="BeginDate" type="string" required="Yes">
	<cfargument name="EndDate" type="string" required="Yes">
	<cfargument name="TransactionType" type="string" required="No">
		<!--- Beginning Date is greater than Ending Date --->
		<cfif isDate(Arguments.BeginDate) AND isDate(Arguments.EndDate) AND 
			  dateCompare(Arguments.BeginDate,Arguments.EndDate) EQ 1>
			<cfset Arguments.BeginDate = "NONE">
			<cfset Arguments.EndDate = "NONE">
		</cfif>
		<cfquery datasource="#This.DataSourceName#" name="qryRecords">
		SELECT 	#This.ViewColumns#
		FROM 	#This.ViewName#
		WHERE 	SerialNumber = '#Arguments.SerialNumber#' AND
				ITEMNO = '#Arguments.ITEMNO#'
				<cfif Arguments.BeginDate IS NOT "NONE" AND isDate(Arguments.BeginDate)>
					<cfset BeginDateFormatted = DateFormat(Arguments.BeginDate, "yyyy-mm-dd 00:00:00.0")>
					AND CreationDate >= '#BeginDateFormatted#'
				</cfif>
				<cfif Arguments.EndDate IS NOT "NONE" AND isDate(Arguments.EndDate)>
					<cfset EndDateFormatted = DateFormat(Arguments.EndDate, "yyyy-mm-dd 23:59:59.9")>
					AND CreationDate <= '#EndDateFormatted#'			
				</cfif>
				<cfif isDefined("Arguments.TransactionType") AND Arguments.TransactionType IS NOT "">
					AND TransactionType = '#Arguments.TransactionType#'
				</cfif>
		ORDER BY CreationDate
		</cfquery>
		<cfreturn qryRecords>
	</cffunction>

	<cffunction name="partNumberHistoryReport" access="public" returntype="query" output="no">
	<cfargument name="ITEMNO" type="string" required="Yes">
	<cfargument name="BeginDate" type="string" required="Yes">
	<cfargument name="EndDate" type="string" required="Yes">
	<cfargument name="TransactionType" type="string" required="Yes">
		<!--- Beginning Date is greater than Ending Date --->
		<cfif isDate(Arguments.BeginDate) AND isDate(Arguments.EndDate) AND 
			  dateCompare(Arguments.BeginDate,Arguments.EndDate) EQ 1>
			<cfset Arguments.BeginDate = "NONE">
			<cfset Arguments.EndDate = "NONE">
		</cfif>
		<cfset ITEMNOTrimmed = trim(Arguments.ITEMNO)>
		<cfquery datasource="#This.DataSourceName#" name="qryRecords">
		SELECT 	#This.ViewColumns#
		FROM 	#This.ViewName#
		WHERE 	ITEMNO = '#ITEMNOTrimmed#'
				<cfif Arguments.BeginDate IS NOT "NONE" AND isDate(Arguments.BeginDate)>
					<cfset BeginDateFormatted = DateFormat(Arguments.BeginDate, "yyyy-mm-dd 00:00:00.0")>
					AND CreationDate >= '#BeginDateFormatted#'
				</cfif>
				<cfif Arguments.EndDate IS NOT "NONE" AND isDate(Arguments.EndDate)>
					<cfset EndDateFormatted = DateFormat(Arguments.EndDate, "yyyy-mm-dd 23:59:59.9")>
					AND CreationDate <= '#EndDateFormatted#'			
				</cfif>
				<cfif isDefined("Arguments.TransactionType") AND Arguments.TransactionType IS NOT "">
					AND TransactionType = '#Arguments.TransactionType#'
				</cfif>
		ORDER BY CreationDate, SerialNumber
		</cfquery>
		<cfreturn qryRecords>
	</cffunction>
	
</cfcomponent>