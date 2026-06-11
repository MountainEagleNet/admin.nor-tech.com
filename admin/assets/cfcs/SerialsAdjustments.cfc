<cfcomponent extends="admin.assets.cfcs.Component">
	<cfset This.DataSourceName = APPLICATION.DSN_WWW>

	<cfset This.Columns = "SerialsAdjustmentsID,ADJENSEQ,SerialNumber,Posted,PostedDate,BarCodesPrinted,SortOrder">
	<cfset This.ViewColumns = This.Columns>
	<cfset This.LINENOColumn = "LINENO">

	<cfset This.TableName = "tblSerialsAdjustments">
	<cfset This.ViewName = This.TableName>
	
	<cfset This.PrimaryKey = "SerialsAdjustmentsID">
	<cfset This.ForeignHeaderKey = "ADJENSEQ">
	<cfset This.ForeignDetailKey = "LINENO">
	
	<cfset This.ITEMNOKey = "ITEMNO">	<!--- Item number key of the detail table, ICADED --->
	<cfset This.SortOrderKey = "SortOrder">

	<cfset This.GenerateUUIDKey = 1>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "SerialsAdjustmentsID">
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
	
	<cfset This.DataRecordName = "AdjustmentsDataRecord">
	<cfset This.ErrorRecordName = "AdjustmentsErrorRecord">

	<cffunction name="checkForWarnings" access="public" returntype="struct" output="No">
	<!--- Check for the following warnings:
				1) One or more of the serial number fields is blank.
		  		2) If increase and any of the entered serial numbers are already on file.
		  		3) If decrease and any of the entered serial numbers are not on file.
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
				
					<cfset SearchRecord = structNew()>
					<cfset structInsert(SearchRecord, "SerialNumber", trim(SNValue), True)>
					<cfset structInsert(SearchRecord, "ITEMNO", Arguments.Record[This.ITEMNOKey], True)>
					<cfset qrySerials = objSerials.searchRecords(SearchRecord, "query")>

					<!--- Increase and this serial number / item is already on file? --->
					<cfif NOT BatchNumberItem>
						<cfif Arguments.Record.AdjustmentType IS "Increase" AND qrySerials.RecordCount GT 0>
							<cfset structInsert(stWarnings, "WarningFound", "AlreadyOnFile", True)>
							<cfset structInsert(stWarnings, SNColumn, SNValue, True)>
						</cfif>
					</cfif>

					<!--- Decrease and this serial number / item is not on file? --->
					<!--- We're only performing the "make sure serial numbers are on file" check after the 
						  date specified by APPLICATION.WarningActivationDate in Application.cfm --->
					<cfif dateCompare(now(), APPLICATION.WarningActivationDate) EQ 1>
						<cfif Arguments.Record.AdjustmentType IS "Decrease" AND qrySerials.RecordCount EQ 0>
							<cfset structInsert(stWarnings, "WarningFound", "NotOnFile", True)>
							<cfset structInsert(stWarnings, SNColumn, SNValue, True)>
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
	
	<cffunction name="applySerialNumbersFromReceipt" access="public" returntype="boolean" output="no">
	<cfargument name="ADJENSEQ" type="string" required="Yes">
	<cfargument name="RCPHSEQ" type="string" required="Yes">	
		<cfset var AtLeastOneSNApplied = 0>
		<cfset objICADED = createObject("component", "admin.assets.cfcs.ICADED")>
		<cfset objSerialsReceipts = createObject("component", "admin.assets.cfcs.SerialsReceipts")>
		<cfset objPORCPL = createObject("component", "admin.assets.cfcs.PORCPL")>

		<!--- Get all serial numbers for this receipt --->
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "RCPHSEQ", trim(Arguments.RCPHSEQ), True)>
		<cfset qrySerialsReceiptsScanned = objSerialsReceipts.searchRecords(SearchRecord, "query", "RCPLREV, SortOrder")>
		<!--- Get all lines for this adjustment --->
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ADJENSEQ", Arguments.ADJENSEQ, True)>
		<cfset qryICADED = objICADED.searchRecords(SearchRecord, "query", "[LINENO]")>
		<cfloop query="qryICADED">
			<cfset CURRENT_LINENO = qryICADED.LINENO>
			<cfset CURRENT_QUANTITY = qryICADED.QUANTITY>
			<cfset CURRENT_ITEMNO = trim(qryICADED.ITEMNO)>
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "ADJENSEQ", Arguments.ADJENSEQ, True)>
			<cfset structInsert(SearchRecord, "LINENO", CURRENT_LINENO, True)>
			<cfset qrySerialsAdjustments = searchRecords(SearchRecord, "query", "SortOrder")>
			<cfif qrySerialsAdjustments.RecordCount EQ 0>
				<cfset SNCount = 0>
				<cfloop query="qrySerialsReceiptsScanned">
					<!--- Make sure the receipt was for the same item --->
					<cfset SearchRecord = structNew()>
					<cfset structInsert(SearchRecord, "RCPHSEQ", qrySerialsReceiptsScanned.RCPHSEQ, True)>
					<cfset structInsert(SearchRecord, "RCPLREV", qrySerialsReceiptsScanned.RCPLREV, True)>
					<cfset qryPORCPL = objPORCPL.searchRecords(SearchRecord, "query")>
					<cfif isDefined("qryPORCPL.ITEMNO") AND trim(qryPORCPL.ITEMNO) IS CURRENT_ITEMNO>
						<cfif SNCount LT CURRENT_QUANTITY>
							<cfset strSerialsAdjustments = newRecord()>
							<cfset structInsert(strSerialsAdjustments, "ADJENSEQ", Arguments.ADJENSEQ, True)>
							<cfset structInsert(strSerialsAdjustments, "LINENO", CURRENT_LINENO, True)>
							<cfset structInsert(strSerialsAdjustments, "SerialNumber", qrySerialsReceiptsScanned.SerialNumber, True)>
							<cfset structInsert(strSerialsAdjustments, "Posted", 0, True)>
							<cfset structInsert(strSerialsAdjustments, "PostedDate", now(), True)>
							<cfset structInsert(strSerialsAdjustments, "BarCodesPrinted", 0, True)>
							<cfset structInsert(strSerialsAdjustments, "SortOrder", qrySerialsReceiptsScanned.SortOrder, True)>
							<cfset saveRecord(strSerialsAdjustments)>
							<cfset SNCount = SNCount + 1>
							<cfset AtLeastOneSNApplied = 1>
						</cfif>
					</cfif>
				</cfloop>
			</cfif>
		</cfloop>
		<cfreturn AtLeastOneSNApplied>
	</cffunction>
	
</cfcomponent>