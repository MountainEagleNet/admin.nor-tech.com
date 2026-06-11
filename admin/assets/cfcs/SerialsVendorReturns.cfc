<cfcomponent extends="admin.assets.cfcs.Component">
	<cfset This.DataSourceName = APPLICATION.DSN_WWW>

	<cfset This.Columns = "SerialsVendorReturnsID,RETHSEQ,RETLREV,SerialNumber,Posted,PostedDate">
	<cfset This.ViewColumns = This.Columns>
	
	<cfset This.TableName = "tblSerialsVendorReturns">
	<cfset This.ViewName = This.TableName>
	
	<cfset This.PrimaryKey = "SerialsVendorReturnsID">
	<cfset This.ForeignHeaderKey = "RETHSEQ">
	<cfset This.ForeignDetailKey = "RETLREV">
	
	<cfset This.ITEMNOKey = "ITEMNO">	<!--- Item number key of the detail table, PORETL --->

	<cfset This.GenerateUUIDKey = 1>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "SerialsVendorReturnsID">
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

	<cfset This.DataRecordName = "VendorReturnDataRecord">
	<cfset This.ErrorRecordName = "VendorReturnErrorRecord">

	<!----------------------------------------------------------------------------------------------------------------->
	<cffunction name="checkForWarnings" access="public" returntype="struct" output="No">
	<!--- Check for the following warnings:
		  		1) Any of the entered serial numbers are not on file.
				2) One or more of the serial number fields is blank.
	--->
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stWarnings = structNew()>
        <cfset var qrySerials = queryNew("")>
        <cfset var qrySerialsByLocation = queryNew("")>
        
<!---	<cfset var qryPORETH1 = queryNew("")>	--->
<!---	<cfset var qrySerialNumberAuditTrail = queryNew("")>	--->
		
		<cfset objSerials = createObject("component", "admin.assets.cfcs.Serials")>
		<cfset objScannerBatchItems = createObject("component", "admin.assets.cfcs.ScannerBatchItems")>
		<cfset objScannerBatchItemSNs = createObject("component", "admin.assets.cfcs.ScannerBatchItemSNs")>
		<cfset objVirtualItems = createObject("component", "admin.assets.cfcs.VirtualItems")>

		<!--- If this is a "batch number item", don't check to see if the serial numbers are already on file --->
		<cfset BatchNumberItem = 0>
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ITEMNO", Arguments.Record[This.ITEMNOKey], True)>
		<cfset qryScannerBatchItems = objScannerBatchItems.searchRecords(SearchRecord, "query")>
		<cfif qryScannerBatchItems.RecordCount GT 0>
			<cfset BatchNumberItem = 1>
		</cfif>
		
		<!--- Is this is a "virtual item"? --->
		<cfset VirtualItem = 0>
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ITEMNO", Arguments.Record[This.ITEMNOKey], True)>
		<cfset qryVirtualItems = objVirtualItems.searchRecords(SearchRecord, "query")>
		<cfif qryVirtualItems.RecordCount GT 0>
			<cfset VirtualItem = 1>
		</cfif>

		<cfset RecordList = structKeyList(Arguments.Record)>
		<cfset NumberOfFilledFields = 0>
		<cfloop list="#RecordList#" index="SNColumn">
			<cfif findNoCase("SN_", SNColumn) NEQ 0>
				<cfset SNValue = Arguments.Record[SNColumn]>
				<cfif trim(SNValue) IS NOT "">
					<cfset NumberOfFilledFields = NumberOfFilledFields + 1>
					<cfset SavedSNValue = trim(SNValue)>
					
					<cfif NOT VirtualItem>
						<!--- We're only performing the "make sure serial numbers are on file" check after the 
							  date specified by APPLICATION.WarningActivationDate in Application.cfm --->
						<cfif dateCompare(now(), APPLICATION.WarningActivationDate) EQ 1>
							<!--- Is this serial number / item not on file? --->
							<cfset SearchRecord = structNew()>
							<cfset structInsert(SearchRecord, "SerialNumber", trim(SNValue), True)>
							<cfset structInsert(SearchRecord, "ITEMNO", Arguments.Record[This.ITEMNOKey], True)>
							<cfset qrySerials = objSerials.searchRecords(SearchRecord, "query")>
                            
							<cfif qrySerials.RecordCount EQ 0>
								<cfset structInsert(stWarnings, "NotOnFile", 1, True)>
								<cfset structInsert(stWarnings, SNColumn, SNValue, True)>
                           	<cfelseif isDefined("Arguments.Record.LOCATION")>
								<cfset structInsert(SearchRecord, "LOCATION", Arguments.Record.LOCATION, True)>
								<cfset qrySerialsByLocation = objSerials.searchRecords(SearchRecord, "query")>
								<cfif qrySerialsByLocation.RecordCount EQ 0>
									<cfset structInsert(stWarnings, "WrongLocation", 1, True)>
                                    <cfset structInsert(stWarnings, SNColumn, SNValue, True)>
                                </cfif>
							</cfif>
						</cfif>
					</cfif>
					
					<!--- Was this serial number already sent back to the vendor through a vendor return? --->
<!---
					<cfif NOT BatchNumberItem AND isDefined("Arguments.Record.RETHSEQ")>
						<!--- Get the Vendor Code --->
						<cfquery datasource="#APPLICATION.DSN_AP#" name="qryPORETH1">
						SELECT 	VDCODE
						FROM 	dbo.PORETH1
						WHERE 	RETHSEQ = '#trim(Arguments.Record.RETHSEQ)#'
						</cfquery>
						<cfif qryPORETH1.RecordCount NEQ 0>
							<cfquery datasource="#This.DataSourceName#" name="qrySerialNumberAuditTrail">
							SELECT 	SerialNumberAuditTrailID
							FROM 	tblSerialNumberAuditTrail
							WHERE 	TransactionType = 'VendorReturn' AND
									VDCODE = '#trim(qryPORETH1.VDCODE)#' AND
									ITEMNO = '#trim(Arguments.Record.ITEMNO)#' AND
									SerialNumber = '#trim(SNValue)#'
							</cfquery>
							<cfif qrySerialNumberAuditTrail.RecordCount NEQ 0>
								<cfset structInsert(stWarnings, "ReturnedToVendor", 1, True)>
								<cfset structInsert(stWarnings, "RTV|#SNColumn#", SNValue, True)>
							</cfif>
						</cfif>
					</cfif>
--->					
					
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
		<cfif structKeyExists(Arguments.Record, "RQRETURNED") AND NumberOfFilledFields LT Arguments.Record.RQRETURNED>
			<cfset NumberOfBlankFields = Arguments.Record.RQRETURNED - NumberOfFilledFields>
			<cfset structInsert(stWarnings, "BlankFields", NumberOfBlankFields, True)>
		</cfif>
		<cfreturn stWarnings>
	</cffunction>

	<cffunction name="getFirstUnpostedItem" access="public" returntype="string" output="No">
	<cfargument name="RETHSEQ" type="string" required="Yes">
	<cfargument name="RETLREV" type="string" required="No">
		<cfset var FirstUnpostedRETLREV = "">
		<cfset objPORETL = createObject("component", "admin.assets.cfcs.PORETL")>
		<cfset qryPORETL = objPORETL.getSerializedLines(Arguments.RETHSEQ)>
		<cfloop query="qryPORETL">
			<cfif NOT isDefined("Arguments.RETLREV") OR qryPORETL.RETLREV GT Arguments.RETLREV>
				<cfset SearchRecord = structNew()>
				<cfset structInsert(SearchRecord, This.ForeignHeaderKey, qryPORETL.RETHSEQ, True)>
				<cfset structInsert(SearchRecord, This.ForeignDetailKey, qryPORETL.RETLREV, True)>
				<cfset structInsert(SearchRecord, "Posted", 1, True)>
				<cfset qrySerialsVendorReturns = searchRecords(SearchRecord, "query")>
				<cfif qrySerialsVendorReturns.RecordCount EQ 0>
					<cfset FirstUnpostedRETLREV = qryPORETL.RETLREV>
					<cfbreak>
				</cfif>
			</cfif>				
		</cfloop>
		<cfreturn FirstUnpostedRETLREV>
	</cffunction>

</cfcomponent>