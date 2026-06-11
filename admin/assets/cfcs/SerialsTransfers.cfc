<cfcomponent extends="admin.assets.cfcs.Component">
	<cfset This.DataSourceName = APPLICATION.DSN_WWW>

	<cfset This.Columns = "SerialsTransfersID,TRANFENSEQ,SerialNumber,Posted,PostedDate">
	<cfset This.ViewColumns = This.Columns>
	<cfset This.LINENOColumn = "LINENO">

	<cfset This.TableName = "tblSerialsTransfers">
	<cfset This.ViewName = This.TableName>
	
	<cfset This.PrimaryKey = "SerialsTransfersID">
	<cfset This.ForeignHeaderKey = "TRANFENSEQ">
	<cfset This.ForeignDetailKey = "LINENO">
	
	<cfset This.ITEMNOKey = "ITEMNO">	<!--- Item number key of the detail table, ICTRED --->

	<cfset This.GenerateUUIDKey = 1>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "SerialsTransfersID">
	<cfset This.SortOrder = "Asc">

	<cfset This.SortOrderList = "">
	<cfset This.SortKey = "">
	<cfset This.ParentKey = "">
	<cfset This.CreatedKey = "PostedDate">
	<cfset This.ModifiedKey = "">
	<cfset This.ZipCode1Key = "">
	<cfset This.ZipCode2Key = "">
	<cfset This.SavePrimaryKey = 0>
	<cfset This.ExcludeInUpdates = "">
	<cfset This.ExcludeInInserts = "">

	<cfset This.DataRecordName = "TransfersDataRecord">
	<cfset This.ErrorRecordName = "TransfersErrorRecord">

	<cffunction name="checkForWarnings" access="public" returntype="struct" output="No">
	<!--- Check for the following warnings:
				1) One or more of the serial number fields is blank.
		  		2) Any of the entered serial numbers are not on file.
				3) The "from" location doesn't match
	--->
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stWarnings = structNew()>
		<cfset objSerials = createObject("component", "admin.assets.cfcs.Serials")>
		<cfset objScannerBatchItems = createObject("component", "admin.assets.cfcs.ScannerBatchItems")>
		<cfset objScannerBatchItemSNs = createObject("component", "admin.assets.cfcs.ScannerBatchItemSNs")>

		<!--- If this is a "batch number item", don't check to see if the serial numbers are already on file --->
		<cfset BatchNumberItem = 0>
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ITEMNO", Arguments.Record[This.ITEMNOKey], True)>
		<cfset qryScannerBatchItems = objScannerBatchItems.searchRecords(SearchRecord, "query")>
		<cfif qryScannerBatchItems.RecordCount GT 0>
			<cfset BatchNumberItem = 1>
		</cfif>
		
		<cfset RecordList = structKeyList(Arguments.Record)>
		<cfset NumberOfBlankFields = 0>
		<cfloop list="#RecordList#" index="SNColumn">
			<cfif findNoCase("SN_", SNColumn) NEQ 0>
				<cfset SNValue = Arguments.Record[SNColumn]>
				<cfif trim(SNValue) IS "">
					<cfset NumberOfBlankFields = NumberOfBlankFields + 1>
				<cfelse>
					<cfset SavedSNValue = trim(SNValue)>
				
					<!--- Is this serial number / item not on file? --->
					<cfset SearchRecord = structNew()>
					<cfset structInsert(SearchRecord, "SerialNumber", trim(SNValue), True)>
					<cfset structInsert(SearchRecord, "ITEMNO", Arguments.Record[This.ITEMNOKey], True)>
					<cfset qrySerials = objSerials.searchRecords(SearchRecord, "query")>
					<cfif qrySerials.RecordCount EQ 0>
						<!--- We're only performing the "make sure serial numbers are on file" check after the 
							  date specified by APPLICATION.WarningActivationDate in Application.cfm --->
						<cfif dateCompare(now(), APPLICATION.WarningActivationDate) EQ 1>
							<cfset structInsert(stWarnings, "NotOnFile", 1, True)>
							<cfset ColumnName = "NotOnFile_" & SNColumn>
							<cfset structInsert(stWarnings, ColumnName, SNValue, True)>
						</cfif>
					<cfelse>
						<cfset structInsert(SearchRecord, "LOCATION", Arguments.Record.FROMLOC, True)>
						<cfset qrySerials = objSerials.searchRecords(SearchRecord, "query")>
						<cfif qrySerials.RecordCount EQ 0>
							<cfset structInsert(stWarnings, "WrongLocation", 1, True)>
							<cfset ColumnName = "WrongLocation_" & SNColumn>
							<cfset structInsert(stWarnings, ColumnName, SNValue, True)>
						</cfif>
					</cfif>
				</cfif>
			</cfif>
		</cfloop>
		
		<!--- Make sure the serial number entered matches the one saved in tblScannerBatchItemSNs --->
		<cfif BatchNumberItem AND isDefined("SavedSNValue") AND SavedSNValue IS NOT "">
			<cfset qryScannerBatchItemSNs = objScannerBatchItemSNs.listRecordsForParent("ScannerBatchItemID", qryScannerBatchItems.ScannerBatchItemID)>
			<cfif qryScannerBatchItemSNs.RecordCount EQ 0 AND dateCompare(now(), APPLICATION.WarningActivationDate) EQ 1>
				<cfset structInsert(stWarnings, "BatchItemWarning", SavedSNValue, True)>
			<cfelseif qryScannerBatchItemSNs.RecordCount GT 0>
				<cfset FoundIt = 0>
				<cfloop query="qryScannerBatchItemSNs">
					<cfif qryScannerBatchItemSNs.SerialNumber IS SavedSNValue>
						<cfset FoundIt = 1>
						<cfbreak>
					</cfif>
				</cfloop>
				<cfif NOT FoundIt>
					<cfset structInsert(stWarnings, "BatchItemWarning", SavedSNValue, True)>
				</cfif>
			</cfif>
		</cfif>		
		
		<!--- Any Serial Number Fields were left blank --->
		<cfif NumberOfBlankFields GT 0>
			<cfset structInsert(stWarnings, "BlankFields", NumberOfBlankFields, True)>
		</cfif>
		<cfreturn stWarnings>
	</cffunction>

<!---
	<cffunction name="validateConsecutiveOrder" access="public" returntype="struct" output="YES">
	<!--- Make sure no serial number boxes are filled in --->
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
		<cfset RecordList = structKeyList(Arguments.Record)>
		<cfloop list="#RecordList#" index="SNColumn">
			<cfif findNoCase("SN_", SNColumn) NEQ 0>
				<cfset SNValue = Arguments.Record[SNColumn]>
				<cfif trim(SNValue) IS NOT "">
					<cfset stErrors.ConsecutiveOrder = "In order to list serial numbers consecutively, all serial number fields must be empty">
					<cfbreak>						
				</cfif>
			</cfif>
		</cfloop>
		<cfreturn stErrors>
	</cffunction>
--->

</cfcomponent>