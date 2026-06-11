<cfcomponent extends="admin.assets.cfcs.Component">
	<cfset This.DataSourceName = APPLICATION.DSN_WWW>

	<cfset This.Columns = "SerialsReceiptsID,RCPHSEQ,RCPLREV,SerialNumber,Posted,PostedDate,BarCodesPrinted,SortOrder">
	<cfset This.ViewColumns = This.Columns>
	
	<cfset This.TableName = "tblSerialsReceipts">
	<cfset This.ViewName = This.TableName>
	
	<cfset This.PrimaryKey = "SerialsReceiptsID">
	<cfset This.ForeignHeaderKey = "RCPHSEQ">
	<cfset This.ForeignDetailKey = "RCPLREV">
	
	<cfset This.ITEMNOKey = "ITEMNO">	<!--- Item number key of the detail table, PORCPL --->
	<cfset This.SortOrderKey = "SortOrder">

	<cfset This.GenerateUUIDKey = 1>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "SerialsReceiptsID">
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

	<cfset This.DataRecordName = "ReceiptsDataRecord">
	<cfset This.ErrorRecordName = "ReceiptsErrorRecord">

	<cffunction name="checkForWarnings" access="public" returntype="struct" output="no">
	<!--- Check for the following warnings:
		  		1) Any of the entered serial numbers are already on file.
				2) One or more of the serial number fields is blank.
	--->
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stWarnings = structNew()>
		<cfset var qryPORCPH1 = queryNew("")>
		<cfset var qrySerialNumberAuditTrail = queryNew("")>

		<!--- RAB 02/26/2015 --->
		<cfset var RecordList = "">
		<cfset var BatchNumberItem = "">
		<cfset var SearchRecord = structNew()>		
		<cfset var NumberOfFilledFields = "">
		<cfset var SNColumn = "">
		<cfset var SNValue = "">
		<cfset var SavedSNValue = "">		
		<cfset var qryScannerBatchItems = queryNew("")>		
		<cfset var qryScannerBatchItemSNs = queryNew("")>	
		<cfset var qrySerials = queryNew("")>	
		<cfset var FoundIt = "">
		<cfset var NumberOfBlankFields = "">
		
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

		<cfset NumberOfFilledFields = 0>
		<cfloop list="#RecordList#" index="SNColumn">
			<cfif findNoCase("SN_", SNColumn) NEQ 0>	
				<cfset SNValue = Arguments.Record[SNColumn]>
				<cfif trim(SNValue) IS NOT "">
					<cfset SavedSNValue = trim(SNValue)>
					<cfset NumberOfFilledFields = NumberOfFilledFields + 1>
					
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
					
					<!--- Was this serial number already sent back to the vendor through a vendor return more than once? --->
					<cfif NOT BatchNumberItem AND isDefined("Arguments.Record.RCPHSEQ") AND structKeyExists(Arguments.Record, "RCPHSEQ")>
						<!--- Get the Vendor Code --->
						<cfquery datasource="#APPLICATION.DSN_AP#" name="qryPORCPH1">
						SELECT 	VDCODE
						FROM 	dbo.PORCPH1
						WHERE 	RCPHSEQ = '#trim(Arguments.Record.RCPHSEQ)#'
						</cfquery>
						<cfif qryPORCPH1.RecordCount NEQ 0 AND structKeyExists(Arguments.Record, "ITEMNO")>
							<cfquery datasource="#This.DataSourceName#" name="qrySerialNumberAuditTrail">
							SELECT 	SerialNumberAuditTrailID
							FROM 	tblSerialNumberAuditTrail
							WHERE 	TransactionType = 'VendorReturn' AND
									VDCODE = '#trim(qryPORCPH1.VDCODE)#' AND
									ITEMNO = '#trim(Arguments.Record.ITEMNO)#' AND
									SerialNumber = '#trim(SNValue)#'
							</cfquery>
							<cfif qrySerialNumberAuditTrail.RecordCount GT 1>
								<cfset structInsert(stWarnings, "ReturnedToVendor", 1, True)>
								<cfset structInsert(stWarnings, "RTV|#SNColumn#", SNValue, True)>
							</cfif>
						</cfif>
					</cfif>
					
				</cfif>
			</cfif>
		</cfloop>

			
		<!--- Make sure the serial number entered matches the one saved in tblScannerBatchItemSNs --->
		<cfif BatchNumberItem AND isDefined("SavedSNValue") AND SavedSNValue IS NOT "">
			<cfset qryScannerBatchItemSNs = objScannerBatchItemSNs.listRecordsForParent("ScannerBatchItemID", qryScannerBatchItems.ScannerBatchItemID)>
			<cfif qryScannerBatchItemSNs.RecordCount GT 0>
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

<!---
	<cffunction name="validateReplicate" access="public" returntype="struct" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
		<cfset SNIndex = int(Arguments.Record.NumberOfBoxes)>
		<cfloop condition="#SNIndex# GT 0">
			<cfif isDefined("Arguments.Record.StartBoxNumber")>
				<cfset FieldName = "SN_" & (Arguments.Record.StartBoxNumber + SNIndex - 1)>
			<cfelse>
				<cfset FieldName = "SN_" & SNIndex>
			</cfif>
			<cfset FieldValue = Arguments.Record[FieldName]>
			<cfif trim(FieldValue) IS NOT "">
				<cfbreak>
			</cfif>
			<cfset SNIndex = SNIndex - 1>
		</cfloop>
		<cfif SNIndex EQ 0>
			<cfset stErrors.Replicate = "To use the 'Replicate' function, you must scan the first serial number">
		</cfif>
		<cfreturn stErrors>
	</cffunction>
--->

<!---
	<cffunction name="replicate" access="public" returntype="struct" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stRecord = Arguments.Record>
		<cfset SNIndex = int(Arguments.Record.NumberOfBoxes)>
		<cfset FieldValueToReplicate = "">
		<cfloop condition="#SNIndex# GT 0">
			<cfset FieldName = "SN_" & (Arguments.Record.StartBoxNumber + SNIndex - 1)>
			<cfset FieldValue = Arguments.Record[FieldName]>
			<cfif trim(FieldValue) IS NOT "">
				<cfset FieldValueToReplicate = FieldValue>
				<cfbreak>
			</cfif>
			<cfset SNIndex = SNIndex - 1>
		</cfloop>
		<cfif FieldValueToReplicate IS NOT "">
			<cfloop index="LoopCount" from="#(stRecord.StartBoxNumber + SNIndex - 1)#" to="#stRecord.EndBoxNumber#">
				<cfset structInsert(stRecord, "SN_#LoopCount#", FieldValueToReplicate, True)>
			</cfloop>
		</cfif>
		<cfreturn stRecord>
	</cffunction>
--->
	
	<cffunction name="getSerialNumbers" access="public" returntype="query" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var qryRecords = queryNew(This.ViewColumns)>
		<cfquery datasource="#This.DataSourceName#" name="qryRecords">
		SELECT 	#This.ViewColumns#
		FROM 	#This.ViewName#
		WHERE 	#This.ForeignHeaderKey# = '#Arguments.Record[This.ForeignHeaderKey]#' AND
				#This.ForeignDetailKey# = '#Arguments.Record[This.ForeignDetailKey]#' AND
				#This.SortOrderKey# >= #Arguments.Record.StartBoxNumber# AND
				#This.SortOrderKey# <= #Arguments.Record.EndBoxNumber# 
		ORDER BY #This.SortOrderKey# 
		</cfquery>
		<cfreturn qryRecords>
	</cffunction>

	<cffunction name="deleteSerialNumbers" access="public" output="no">
	<cfargument name="Record" type="struct" required="Yes">
	<cfargument name="UnpostedOnly" type="boolean" required="no">
		<cfset var qryRecords = queryNew("")>
		<cfset var RecordID = "">
		<cfset qryRecords = getSerialNumbers(Arguments.Record)>
		<cfloop query="qryRecords">
			<cfif NOT isDefined("Arguments.UnpostedOnly") OR 
				  Arguments.UnpostedOnly EQ 0 OR
				  (Arguments.UnpostedOnly EQ 1 AND qryRecords.Posted EQ 0)>
				<cfset RecordID = qryRecords[This.PrimaryKey]>
				<cfset deleteRecord(RecordID)>
			</cfif>
		</cfloop>
	</cffunction>

	<cffunction name="checkForDuplicates" access="public" returntype="struct" output="No">
	<!--- Make sure the same serial number isn't scanned from one batch to the next. --->
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
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
						<cfset structInsert(SearchRecord, This.ForeignHeaderKey, Arguments.Record[This.ForeignHeaderKey], True)>
						<cfset structInsert(SearchRecord, This.ForeignDetailKey, Arguments.Record[This.ForeignDetailKey], True)>
						<cfset structInsert(SearchRecord, "SerialNumber", SNValue, True)>
						<cfset qrySerialsReceipts = searchRecords(SearchRecord, "query")>
						<cfloop query="qrySerialsReceipts">
							<cfif qrySerialsReceipts.SortOrder LT Arguments.Record.StartBoxNumber OR 
								  qrySerialsReceipts.SortOrder GT Arguments.Record.EndBoxNumber>
								<cfset structInsert(stErrors, "DuplicatesFound", 1, True)>
								<cfset structInsert(stErrors, SNColumn, "Error", True)>
							</cfif>
						</cfloop>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
		<cfreturn stErrors>
	</cffunction>

<!---
	<cffunction name="addBatchNumberSN" access="public" output="no">
	<!--- If this is a Batch Number Item, save the serial number in tblScannerBatchItemSNs --->
	<cfargument name="Record" type="struct" required="Yes">
		<cfset objScannerBatchItems = createObject("component", "admin.assets.cfcs.ScannerBatchItems")>
		<cfset objScannerBatchItemSNs = createObject("component", "admin.assets.cfcs.ScannerBatchItemSNs")>
		<!--- If this is a "batch number item" --->
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ITEMNO", Arguments.Record[This.ITEMNOKey], True)>
		<cfset qryScannerBatchItems = objScannerBatchItems.searchRecords(SearchRecord, "query")>
		<cfif qryScannerBatchItems.RecordCount GT 0>
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, This.ForeignHeaderKey, Arguments.Record[This.ForeignHeaderKey], True)>
			<cfset structInsert(SearchRecord, This.ForeignDetailKey, Arguments.Record[This.ForeignDetailKey], True)>
			<cfset qryRecords = searchRecords(SearchRecord, "query")>
			<cfloop query="qryRecords">
				<cfset FoundIt = 0>
				<cfset qryScannerBatchItemSNs = objScannerBatchItemSNs.listRecordsForParent("ScannerBatchItemID", qryScannerBatchItems.ScannerBatchItemID)>
				<cfloop query="qryScannerBatchItemSNs">
					<cfif trim(qryRecords.SerialNumber) IS trim(qryScannerBatchItemSNs.SerialNumber)>
						<cfset FoundIt = 1>
						<cfbreak>
					</cfif>
				</cfloop>
				<cfif NOT FoundIt>
					<cfset strScannerBatchItemSN = objScannerBatchItemSNs.newRecord()>
					<cfset structInsert(strScannerBatchItemSN, "ScannerBatchItemID", qryScannerBatchItems.ScannerBatchItemID, True)>
					<cfset structInsert(strScannerBatchItemSN, "SerialNumber", trim(qryRecords.SerialNumber), True)>
					<cfset objScannerBatchItemSNs.saveRecord(strScannerBatchItemSN)>
				</cfif>
			</cfloop>
		</cfif>
	</cffunction>
--->	

	<cffunction name="getFirstUnpostedItem" access="public" returntype="string" output="No">
	<cfargument name="RCPHSEQ" type="string" required="Yes">
	<cfargument name="RCPLREV" type="string" required="No">
		<cfset var FirstUnpostedRCPLREV = "">
		<cfset objPORCPL = createObject("component", "admin.assets.cfcs.PORCPL")>
		<cfset qryPORCPL = objPORCPL.getSerializedLines(Arguments.RCPHSEQ)>
		<cfloop query="qryPORCPL">
			<cfif NOT isDefined("Arguments.RCPLREV") OR qryPORCPL.RCPLREV GT Arguments.RCPLREV>
				<cfset SearchRecord = structNew()>
				<cfset structInsert(SearchRecord, This.ForeignHeaderKey, qryPORCPL.RCPHSEQ, True)>
				<cfset structInsert(SearchRecord, This.ForeignDetailKey, qryPORCPL.RCPLREV, True)>
				<cfset structInsert(SearchRecord, "Posted", 1, True)>
				<cfset qrySerialsReceipts = searchRecords(SearchRecord, "query")>
				<cfif qrySerialsReceipts.RecordCount EQ 0>
					<cfset FirstUnpostedRCPLREV = qryPORCPL.RCPLREV>
					<cfbreak>
				</cfif>
			</cfif>				
		</cfloop>
		<cfreturn FirstUnpostedRCPLREV>
	</cffunction>

	<cffunction name="checkForBug" access="public" output="no">
	<cfargument name="Record" type="struct" required="Yes">
	<cfargument name="PostLocation" type="numeric" required="Yes">
		<cfset objPORCPL = createObject("component", "admin.assets.cfcs.PORCPL")>

		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "RCPHSEQ", Arguments.Record.RCPHSEQ, True)>
		<cfset structInsert(SearchRecord, "RCPLREV", Arguments.Record.RCPLREV, True)>
		<cfset qryReceiptDetail = objPORCPL.searchRecords(SearchRecord, "query")>

		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "RCPHSEQ", Arguments.Record.RCPHSEQ, True)>
		<cfset structInsert(SearchRecord, "RCPLREV", Arguments.Record.RCPLREV, True)>
		<cfif Arguments.PostLocation EQ 4>
			<cfset structInsert(SearchRecord, "Posted", 1, True)>
		</cfif>
		<cfset qrySerialsReceipts = searchRecords(SearchRecord, "query")>

		<cfset RemainingQuantity = int(qryReceiptDetail.RQRECEIVED - qrySerialsReceipts.RecordCount)>

		<cfif RemainingQuantity LT 0>
			<cfmail from=	"Nor-Tech <info@nor-tech.com>" 
					to=		"ron_barth@altsystem.com" 
					subject="POSSIBLE BUG . . . RECEIPTS"
					type=	"html"
					timeout="60">
				Hey Ron: check it out:  This receipt line has a remaining quantity less than zero.<br>
				Receipt Number: #Arguments.Record.TransactionNumber#<br>
				Item: #Arguments.Record.ITEMNO#<br>
				Receipt Line Number: #Arguments.Record.RCPLREV#<br>
				actPost POST LOCATION: #Arguments.PostLocation#<br>
				Here's stRecord:<br>
				<cfdump var="#Arguments.Record#">
			</cfmail>
		</cfif>

	</cffunction>

	<cffunction name="checkForBug2" access="public" output="no">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var lstRecord = "">
		<cfset var Column = "">
		<cfset var SerialNumberValue = "">
		<cfset var qrySerials = queryNew("")>
		<cfset lstRecord = structKeyList(Arguments.Record)>
		<cfloop list="#lstRecord#" index="Column">
			<cfif findNoCase('SN_',Column) NEQ 0>
				<cfset SerialNumberValue = trim(Arguments.Record[Column])>
				<cfif SerialNumberValue IS NOT "">
					<cfquery datasource="#This.DataSourceName#" name="qrySerials">
					SELECT	SerialID, SerialNumber
					FROM	tblSerials
					WHERE 	SerialNumber = '#SerialNumberValue#'
					</cfquery>	
					<cfif qrySerials.RecordCount EQ 0>
						<cfmail from=	"Nor-Tech <info@nor-tech.com>" 
								to=		"ron_barth@altsystem.com" 
								subject="NEW POSSIBLE BUG . . . RECEIPTS . . . 1/28/08"
								type=	"html"
								timeout="60">
							Hey Ron: check it out:  After this receipt posted: a serial number posted, but wasn't found in 
							tblSerials.<br>
							Receipt Number: #Arguments.Record.TransactionNumber#<br>
							Item: #Arguments.Record.ITEMNO#<br>
							Receipt Line Number: #Arguments.Record.RCPLREV#<br><br>
							
							Serial Number: #SerialNumberValue#<br><br>
							
							Here's Arguments.Record:<br>
							<cfdump var="#Arguments.Record#">
						</cfmail>
					</cfif>
				</cfif>
			</cfif>
		</cfloop>
	</cffunction>
	
	
	<cffunction name="getRemainingQuantity" access="public" returntype="numeric" output="No">
	<cfargument name="RCPHSEQ" type="string" required="Yes">
	<cfargument name="RCPLREV" type="string" required="Yes">
		<cfset var RemainingQuantity = 0>
		<cfset objPORCPL = createObject("component", "admin.assets.cfcs.PORCPL")>
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "RCPHSEQ", Arguments.RCPHSEQ, True)>
		<cfset structInsert(SearchRecord, "RCPLREV", Arguments.RCPLREV, True)>
		<cfset qryDetail = objPORCPL.searchRecords(SearchRecord, "query")>
		<cfset structInsert(SearchRecord, "Posted", 1, True)>
		<cfset qryPostedSNs = searchRecords(SearchRecord, "query")>
		<cfset RemainingQuantity = qryDetail.RQRECEIVED - qryPostedSNs.RecordCount>
		<cfreturn RemainingQuantity>
	</cffunction>

</cfcomponent>