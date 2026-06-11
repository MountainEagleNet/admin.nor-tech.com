<cfcomponent extends="admin.assets.cfcs.Component">
	<cfset This.DataSourceName = APPLICATION.DSN_WWW>

	<cfset This.Columns = "SerialsCountsID,CountsID,SerialNumber,Posted,PostedDate,SortOrder">
	<cfset This.ViewColumns = This.Columns>
	<cfset This.LINENOColumn = "">

	<cfset This.TableName = "tblSerialsCounts">
	<cfset This.ViewName = This.TableName>
	
	<cfset This.PrimaryKey = "SerialsCountsID">
	<cfset This.ForeignHeaderKey = "">
	<cfset This.ForeignDetailKey = "">
	
	<cfset This.ITEMNOKey = "ITEMNO">	<!--- Item number key of the detail table, tblCounts --->
	<cfset This.SortOrderKey = "SortOrder">

	<cfset This.GenerateUUIDKey = 1>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "SerialsCountsID">
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

	<cfset This.DataRecordName = "CountsDataRecord">
	<cfset This.ErrorRecordName = "CountsErrorRecord">

	<cffunction name="checkForWarnings" access="public" returntype="struct" output="No">
	<!--- Check for the following warning:  One or more of the serial number fields is blank. --->
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stWarnings = structNew()>
		
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
		<cfset NumberOfFilledFields = 0>
		<cfloop list="#RecordList#" index="SNColumn">
			<cfif findNoCase("SN_", SNColumn) NEQ 0>
				<cfset SNValue = Arguments.Record[SNColumn]>
				<cfif trim(SNValue) IS NOT "">
					<cfset NumberOfFilledFields = NumberOfFilledFields + 1>
					<cfset SavedSNValue = trim(SNValue)>
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
					<cfif trim(qryScannerBatchItemSNs.SerialNumber) IS SavedSNValue>
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
		<cfif structKeyExists(Arguments.Record, "NumberOfBoxes") AND NumberOfFilledFields LT Arguments.Record.NumberOfBoxes>
			<cfset NumberOfBlankFields = Arguments.Record.NumberOfBoxes - NumberOfFilledFields>
			<cfset structInsert(stWarnings, "BlankFields", NumberOfBlankFields, True)>
		</cfif>
		<cfreturn stWarnings>
	</cffunction>

	<cffunction name="getNotOnFile" access="public" returntype="query" output="No">
	<!--- Check to see if any of the scanned serial numbers are not on file --->
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var qryNotOnFile = queryNew("SerialNumber")>
		<cfset objSerials = createObject("component", "admin.assets.cfcs.Serials")>
		<cfset qrySerialsCounts = listRecordsForParent("CountsID", Arguments.Record.CountsID, "SortOrder")>
		<cfloop query="qrySerialsCounts">
			<cfset SNValue = qrySerialsCounts.SerialNumber>
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "ITEMNO", Arguments.Record.ITEMNO, True)>
			<cfset structInsert(SearchRecord, "LOCATION", Arguments.Record.LOCATION, True)>
			<cfset structInsert(SearchRecord, "SerialNumber", SNValue, True)>
			<cfset qrySerials = objSerials.searchRecords(SearchRecord, "query")>
			<cfif qrySerials.RecordCount EQ 0>
				<cfset queryAddRow(qryNotOnFile)>
				<cfset querySetCell(qryNotOnFile, "SerialNumber", SNValue)>
			</cfif>
		</cfloop>
<!---
		<cfset RecordList = structKeyList(Arguments.Record)>
		<cfloop list="#RecordList#" index="SNColumn">
			<cfif findNoCase("SN_", SNColumn) NEQ 0>
				<cfset SNValue = Arguments.Record[SNColumn]>
				<cfset SearchRecord = structNew()>
				<cfset structInsert(SearchRecord, "ITEMNO", Arguments.Record.ITEMNO, True)>
				<cfset structInsert(SearchRecord, "LOCATION", Arguments.Record.LOCATION, True)>
				<cfset structInsert(SearchRecord, "SerialNumber", SNValue, True)>
				<cfset qrySerials = objSerials.searchRecords(SearchRecord, "query")>
				<cfif qrySerials.RecordCount EQ 0>
					<cfset queryAddRow(qryNotOnFile)>
					<cfset querySetCell(qryNotOnFile, "SerialNumber", SNValue)>
				</cfif>
			</cfif>
		</cfloop>
--->
		<cfreturn qryNotOnFile>
	</cffunction>

	<cffunction name="getOnFile" access="public" returntype="query" output="No">
	<!--- Check to see if any of the serials numbers on file for this item/location were not scanned --->
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var qryOnFile = queryNew("SerialNumber,SerialID")>
		<cfset objSerials = createObject("component", "admin.assets.cfcs.Serials")>
		<cfset qrySerialsCounts = listRecordsForParent("CountsID", Arguments.Record.CountsID, "SortOrder")>

<!---	<cfset RecordList = structKeyList(Arguments.Record)>	--->
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ITEMNO", trim(Arguments.Record.ITEMNO), True)>
		<cfset structInsert(SearchRecord, "LOCATION", trim(Arguments.Record.LOCATION), True)>
		<cfset qrySerials = objSerials.searchRecords(SearchRecord, "query")>
		<cfloop query="qrySerials">
			<cfset CURRENTSerialNumber = trim(qrySerials.SerialNumber)>
			<cfset CURRENTSerialID = qrySerials.SerialID>
			<cfset Found = 0>
			<cfloop query="qrySerialsCounts">
<!---		<cfloop list="#RecordList#" index="SNColumn">	--->
<!---			<cfif findNoCase("SN_", SNColumn) NEQ 0>	--->
<!---				<cfset SNValue = Arguments.Record[SNColumn]>	--->
					<cfset SNValue = trim(qrySerialsCounts.SerialNumber)>
<!---				<cfif trim(qrySerials.SerialNumber) IS trim(SNValue)>	--->
					<cfif CURRENTSerialNumber IS SNValue>
						<cfset Found = 1>
						<cfbreak>
					</cfif>
<!---			</cfif>	--->
			</cfloop>
			<cfif NOT Found>
				<cfset queryAddRow(qryOnFile)>
				<cfset querySetCell(qryOnFile, "SerialNumber", CURRENTSerialNumber)>
				<cfset querySetCell(qryOnFile, "SerialID", CURRENTSerialID)>
			</cfif>
		</cfloop>
		<cfreturn qryOnFile>
	</cffunction>

	<cffunction name="getQuantityError" access="public" returntype="string" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var QuantityError = "">
		<cfset objSerials = createObject("component", "admin.assets.cfcs.Serials")>
<!---	<cfset RecordList = structKeyList(Arguments.Record)>	--->
		
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ITEMNO", Arguments.Record.ITEMNO, True)>
		<cfset structInsert(SearchRecord, "LOCATION", Arguments.Record.LOCATION, True)>
		<cfset qrySerialsOnFile = objSerials.searchRecords(SearchRecord, "query")>
<!---
		<cfset QTYSerialsScanned = 0>
		<cfloop list="#RecordList#" index="SNColumn">
			<cfif findNoCase("SN_", SNColumn) NEQ 0>
				<cfset SNValue = Arguments.Record[SNColumn]>
				<cfif trim(SNValue) IS NOT "">
					<cfset QTYSerialsScanned = QTYSerialsScanned + 1>
				</cfif>
			</cfif>
		</cfloop>
--->
		<cfset qrySerialsCounts = listRecordsForParent("CountsID", Arguments.Record.CountsID, "SortOrder")>
		<cfset QTYSerialsScanned = qrySerialsCounts.RecordCount>

		<cfif qrySerialsOnFile.RecordCount NEQ QTYSerialsScanned>

			<cfif QTYSerialsScanned GT qrySerialsOnFile.RecordCount>
				<cfset QuantityError = "You scanned " & QTYSerialsScanned & " serial number">
				<cfif QTYSerialsScanned GT 1>
					<cfset QuantityError = QuantityError & "s">
				</cfif>
				<cfset QuantityError = QuantityError & ", but there ">
				<cfif qrySerialsOnFile.RecordCount EQ 0>
					<cfset QuantityError = QuantityError & "are none on file; ">
				<cfelseif qrySerialsOnFile.RecordCount GT 1>
					<cfset QuantityError = QuantityError & "are only " & qrySerialsOnFile.RecordCount & " on file; ">
				<cfelse>
					<cfset QuantityError = QuantityError & "is only 1 on file; ">
				</cfif>
				<cfset QuantityError = QuantityError & "the " & QTYSerialsScanned & " that you scanned will be added to the database and will replace any existing serial numbers for this item.">
<!---				 
				<cfset QuantityError = QuantityError & (QTYSerialsScanned-qrySerialsOnFile.RecordCount) & " serial number">
				<cfif (QTYSerialsScanned-qrySerialsOnFile.RecordCount) GT 1>
					<cfset QuantityError = QuantityError & "s">
				</cfif>
				<cfset QuantityError = QuantityError & " will be added to the database.">
--->				
			<cfelse>
				<cfset QuantityError = "You scanned only " & QTYSerialsScanned & " serial number">
				<cfif QTYSerialsScanned GT 1>
					<cfset QuantityError = QuantityError & "s">
				</cfif>
				<cfset QuantityError = QuantityError & ", but there ">
				<cfif qrySerialsOnFile.RecordCount EQ 0>
					<cfset QuantityError = QuantityError & "are none on file; ">
				<cfelseif qrySerialsOnFile.RecordCount GT 1>
					<cfset QuantityError = QuantityError & "are " & qrySerialsOnFile.RecordCount & " on file; ">
				<cfelse>
					<cfset QuantityError = QuantityError & "is only 1 on file; ">
				</cfif> 
				<cfset QuantityError = QuantityError & "the " & QTYSerialsScanned & " that you scanned will be added to the database and will replace any existing serial numbers for this item.">
<!---				
				<cfset QuantityError = QuantityError & (qrySerialsOnFile.RecordCount-QTYSerialsScanned) & " serial number">
				<cfif (qrySerialsOnFile.RecordCount-QTYSerialsScanned) GT 1>
					<cfset QuantityError = QuantityError & "s">
				</cfif>
				<cfset QuantityError = QuantityError & " will be removed from the database.">
--->				
			</cfif>
		</cfif>

		<cfreturn QuantityError>
	</cffunction>

	<cffunction name="saveSerialNumberInput" access="public" output="no">
	<!--- Save the serial numbers to the input table: tblSerialsCounts --->
	<cfargument name="Record" type="struct" required="Yes">
	<cfargument name="SaveAndPostpone" type="string" required="No">
		<cfif isDefined("Arguments.SaveAndPostpone") EQ 0>
			<cfset Arguments.SaveAndPostpone = 0>
		</cfif>
		<!--- First, delete all existing entries --->
		<cfset deleteSerialNumbers(Arguments.Record)>
		<cfset RecordList = structKeyList(Arguments.Record)>
		<cfloop list="#RecordList#" index="SNColumn">
			<cfif findNoCase("SN_", SNColumn) NEQ 0>
				<cfset SNValue = ucase(Arguments.Record[SNColumn])>
				<cfif trim(SNValue) IS NOT "">
					<cfset strRecord = structNew()>
					<cfset structInsert(strRecord, This.PrimaryKey, "", True)>
					<cfset structInsert(strRecord, "CountsID", Arguments.Record.CountsID, True)>
					<cfset structInsert(strRecord, "SerialNumber", trim(SNValue), True)>
					<cfif Arguments.SaveAndPostpone EQ 1>
						<cfset structInsert(strRecord, "Posted", 0, True)>
					<cfelse>
						<cfset structInsert(strRecord, "Posted", 1, True)>
					</cfif>
					<cfif This.SortOrderKey IS NOT "">
						<cfset NewSortOrder = removeChars(SNColumn,1,3)>
						<cfset structInsert(strRecord, This.SortOrderKey, NewSortOrder, True)>
					</cfif>
					<cfset saveRecord(strRecord)>
				</cfif>
			</cfif>
		</cfloop>
	</cffunction>
	
	<cffunction name="deleteSerialNumbers" access="public" output="no">
	<cfargument name="Record" type="struct" required="Yes">
		<cfif NOT isDefined("Arguments.Record.StartBoxNumber")>
			<cfset Arguments.Record.StartBoxNumber = 1>
		</cfif>
		<cfif NOT isDefined("Arguments.Record.EndBoxNumber")>
			<cfset Arguments.Record.EndBoxNumber = Arguments.Record.Quantity>
		</cfif>
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "CountsID", Arguments.Record.CountsID, True)>
		<cfset qryRecords = searchRecords(SearchRecord, "query")>
		<cfloop query="qryRecords">
			<cfif qryRecords.SortOrder GE Arguments.Record.StartBoxNumber AND qryRecords.SortOrder LE Arguments.Record.EndBoxNumber>
				<cfset deleteRecord(qryRecords.SerialsCountsID)>
			</cfif>
		</cfloop>
	</cffunction>

	<cffunction name="createAuditTrail" access="public" output="YES">
	<!--- Create audit trail entries in tblSerialNumberAuditTrail --->
	<cfargument name="Record" type="struct" required="Yes">
	<cfargument name="SerialNumber" type="string" required="Yes">
	<cfargument name="AddorRemove" type="string" required="Yes">
		<cfset objSerialNumberAuditTrail = createObject("component", "admin.assets.cfcs.SerialNumberAuditTrail")>
		<cfset objSerialsCounts = createObject("component", "admin.assets.cfcs.SerialsCounts")>
		<cfset objAdmin = createObject("component", "admin.assets.cfcs.Admin")>
		<!--- Get the User --->
		<cfset qryUser = objAdmin.getRecordAsQuery(SESSION.adminuserid)>
		
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "CountsID", Arguments.Record.CountsID, True)>
		<cfset structInsert(SearchRecord, "SerialNumber", Arguments.SerialNumber, True)>
		<cfset qrySerialsCounts = objSerialsCounts.searchRecords(SearchRecord, "query")>
		<cfif qrySerialsCounts.RecordCount EQ 0>
			<cfset RecordID = "">
		<cfelse>
			<cfset RecordID = qrySerialsCounts.SerialsCountsID>
		</cfif>
		
		<cfset strRecord = structNew()>
		<cfset structInsert(strRecord, "SerialNumberAuditTrailID", "", True)>
		<cfset structInsert(strRecord, "TransactionType", "Count", True)>
		<cfset structInsert(strRecord, "CreationDate", "", True)>
		<cfset structInsert(strRecord, "UserFirstName", qryUser.fname, True)>
		<cfset structInsert(strRecord, "UserLastName", qryUser.lname, True)>
		<cfset structInsert(strRecord, "UserEmail", qryUser.emailaddress, True)>
		<cfset structInsert(strRecord, "ITEMNO", Arguments.Record[This.ITEMNOKey], True)>
		<cfset structInsert(strRecord, "ITEMDESC", getItemDescription(Arguments.Record[This.ITEMNOKey]), True)>
		<cfset structInsert(strRecord, "SerialNumber", Arguments.SerialNumber, True)>
		<cfset structInsert(strRecord, "AddorRemove", Arguments.AddorRemove, True)>
		<cfset structInsert(strRecord, "LOCATION", Arguments.Record.LOCATION, True)>
		<cfset structInsert(strRecord, "LOCATIONDESC", getLocationDescription(Arguments.Record.LOCATION), True)>
		<cfif RecordID IS NOT "">
			<cfset structInsert(strRecord, "SerialTable", This.TableName, True)>
			<cfset structInsert(strRecord, "SerialTableIDField", This.PrimaryKey, True)>
		</cfif>
		<cfset structInsert(strRecord, "SerialTableIDValue", RecordID, True)>
		<cfset objSerialNumberAuditTrail.saveRecord(strRecord)>

	</cffunction>

	<cffunction name="getSerialNumbers" access="public" returntype="query" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var qryRecords = queryNew(This.ViewColumns)>
		<cfquery datasource="#This.DataSourceName#" name="qryRecords">
		SELECT 	#This.ViewColumns#
		FROM 	#This.ViewName#
		WHERE 	CountsID = '#Arguments.Record.CountsID#' AND
				#This.SortOrderKey# >= #Arguments.Record.StartBoxNumber# AND
				#This.SortOrderKey# <= #Arguments.Record.EndBoxNumber# 
		ORDER BY #This.SortOrderKey# 
		</cfquery>
		<cfreturn qryRecords>
	</cffunction>

	<cffunction name="setPosted" access="public" output="No">
	<!--- Set the posted flag --->
	<cfargument name="Record" type="struct" required="Yes">
		<cfset CurrentPostedDate = createODBCDateTime(now())>
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "CountsID", Arguments.Record.CountsID, True)>
		<cfset qryRecords = searchRecords(SearchRecord, "query")>
		<cfloop query="qryRecords">
			<cfquery datasource="#This.DataSourceName#">
				UPDATE 	tblSerialsCounts 
				SET		Posted = 1
						<cfif qryRecords.PostedDate IS "">
							, PostedDate = #CurrentPostedDate#
						</cfif>
				WHERE 	SerialsCountsID = '#qryRecords.SerialsCountsID#'
			</cfquery>
		</cfloop>
	</cffunction>

	<cffunction name="checkForDuplicates" access="public" returntype="struct" output="no">
	<!--- Make sure the same serial number isn't scanned from one batch to the next. --->
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>

		<cfif trim(Arguments.Record.CountsID) IS NOT "">
			<!--- Don't perform this check if this is a batch number item --->
			<cfset objScannerBatchItems = createObject("component", "admin.assets.cfcs.ScannerBatchItems")>
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "ITEMNO", Arguments.Record[This.ITEMNOKey], True)>
			<cfset qryScannerBatchItems = objScannerBatchItems.searchRecords(SearchRecord, "query")>
			<cfif qryScannerBatchItems.RecordCount EQ 0>
				<cfset RecordList = structKeyList(Arguments.Record)>
				<cfloop list="#RecordList#" index="SNColumn">
					<cfif findNoCase("SN_", SNColumn) NEQ 0>
						<cfset SNValue = trim(Arguments.Record[SNColumn])>
						<cfif SNValue IS NOT "">
							<cfset SearchRecord = structNew()>
							<cfset structInsert(SearchRecord, "CountsID", Arguments.Record.CountsID, True)>
							<cfset structInsert(SearchRecord, "SerialNumber", SNValue, True)>
							<cfset qrySerialsCounts = searchRecords(SearchRecord, "query")>
							<cfloop query="qrySerialsCounts">
								<cfif qrySerialsCounts.SortOrder LT Arguments.Record.StartBoxNumber OR 
									  qrySerialsCounts.SortOrder GT Arguments.Record.EndBoxNumber>
									<cfset structInsert(stErrors, "DuplicatesFound", 1, True)>
									<cfset structInsert(stErrors, SNColumn, "Error", True)>
								</cfif>
							</cfloop>
						</cfif>
					</cfif>
				</cfloop>
			</cfif>
		</cfif>
		<cfreturn stErrors>
	</cffunction>
	
</cfcomponent>