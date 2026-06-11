<cfcomponent extends="admin.assets.cfcs.Component">
	<cfset This.DataSourceName = APPLICATION.DSN_WWW>

	<cfset This.Columns = "SerialsReturnsID,RMAUNIQ,LINENUM,SerialNumber,Posted,PostedDate,BarCodesPrinted">
	<cfset This.ViewColumns = This.Columns>
	
	<cfset This.TableName = "tblSerialsReturns">
	<cfset This.ViewName = This.TableName>
	
	<cfset This.PrimaryKey = "SerialsReturnsID">
	<cfset This.ForeignHeaderKey = "RMAUNIQ">
	<cfset This.ForeignDetailKey = "LINENUM">
	<cfset This.OrderNumberKey = "">
	<cfset This.ITEMNOKey = "ITEM">		 <!--- Item number key of the detail table, RADET --->
	<cfset This.SortOrderKey = "SerialNumber">

	<cfset This.GenerateUUIDKey = 1>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "SerialsReturnsID">
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

	<cfset This.DataRecordName = "ReturnsDataRecord">
	<cfset This.ErrorRecordName = "ReturnsErrorRecord">

	<cffunction name="checkForWarningsAuthorization" access="public" returntype="struct" output="YES">
	<!--- Check for the following warnings:
		  		1) Any of the entered serial numbers are already on file.
				2) One or more of the serial number fields is blank.
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

					<!--- Is this serial number / item already on file? --->
					<cfif NOT BatchNumberItem>
						<cfset SearchRecord = structNew()>
						<cfset structInsert(SearchRecord, "SerialNumber", trim(SNValue), True)>
						<cfset structInsert(SearchRecord, "ITEMNO", Arguments.Record[This.ITEMNOKey], True)>
						<cfset qrySerials = objSerials.searchRecords(SearchRecord, "query")>
						<cfif qrySerials.RecordCount GT 0>
							<cfset structInsert(stWarnings, "AlreadyOnFile", 1, True)>
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

	<cffunction name="checkForWarningsReceiving" access="public" returntype="struct" output="YES">
	<!--- Check for the following warnings:
		  		1) Any of the entered serial numbers do not match those that were entered 
				   on the Serial Number Authorization Page
				2) One or more of the serial number fields is blank.
	--->
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stWarnings = structNew()>
		<cfset RecordList = structKeyList(Arguments.Record)>
		<cfset NumberOfBlankFields = 0>
		<cfloop list="#RecordList#" index="SNColumn">
			<cfif findNoCase("SN_", SNColumn) NEQ 0>
				<cfset SNValue = Arguments.Record[SNColumn]>
				<cfif trim(SNValue) IS "">
					<cfset NumberOfBlankFields = NumberOfBlankFields + 1>
				<cfelse>
					<!--- Does this serial number match the one authorized? --->
					<cfset SearchRecord = structNew()>
					<cfset structInsert(SearchRecord, "RMAUNIQ", Arguments.Record.RMAUNIQ, True)>
					<cfset structInsert(SearchRecord, "LINENUM", Arguments.Record.LINENUM, True)>
					<cfset structInsert(SearchRecord, "SerialNumber", SNValue, True)>
					<cfset qrySerialReturns = searchRecords(SearchRecord, "query")>
					<cfif qrySerialReturns.RecordCount EQ 0>
						<cfset structInsert(stWarnings, "NotAuthorized", 1, True)>
						<cfset structInsert(stWarnings, SNColumn, SNValue, True)>
					</cfif>
				</cfif>
			</cfif>
		</cfloop>
		<!--- Any Serial Number Fields were left blank --->
		<cfif NumberOfBlankFields GT 0>
			<cfset structInsert(stWarnings, "BlankFields", NumberOfBlankFields, True)>
		</cfif>
		<cfreturn stWarnings>
	</cffunction>

	<cffunction name="getFirstUnpostedItem" access="public" returntype="string" output="no">
	<cfargument name="RMAUNIQ" type="string" required="Yes">
	<cfargument name="LINENUM" type="string" required="Yes">
	<cfargument name="RMAACTION" type="string" required="Yes">
		<cfset var FirstUnpostedLINENUM = "">
		<cfset objRADET = createObject("component", "admin.assets.cfcs.RADET")>
		<cfset qryRADET = objRADET.getSerializedLines(Arguments.RMAUNIQ)>
		<cfloop query="qryRADET">
			<cfif Arguments.LINENUM IS "[NONE]" OR qryRADET.LINENUM GT Arguments.LINENUM>
				<cfset SearchRecord = structNew()>
				<cfset structInsert(SearchRecord, This.ForeignHeaderKey, qryRADET.RMAUNIQ, True)>
				<cfset structInsert(SearchRecord, This.ForeignDetailKey, qryRADET.LINENUM, True)>
				<cfif Arguments.RMAACTION IS NOT "Authorization">
					<cfset structInsert(SearchRecord, "Posted", 1, True)>
				</cfif>
				<cfset qrySerialsReturns = searchRecords(SearchRecord, "query")>
				<cfif qrySerialsReturns.RecordCount EQ 0>
					<cfset FirstUnpostedLINENUM = qryRADET.LINENUM>
					<cfbreak>
				<cfelseif qrySerialsReturns.RecordCount LT (qryRADET.QTY)>
					<cfset FirstUnpostedLINENUM = qryRADET.LINENUM>
					<cfif Arguments.LINENUM IS "[NONE]">
						<cfbreak>
					</cfif>
				</cfif>
			</cfif>
		</cfloop>
		<cfreturn FirstUnpostedLINENUM>
	</cffunction>

</cfcomponent>