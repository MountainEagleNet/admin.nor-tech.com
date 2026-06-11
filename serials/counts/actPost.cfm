<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/08/2006
	Function: 		Serial Number Posting Page
	Template:		actPost.cfm
	Task:			serials_counts_serials_post
--->

<!--- QUIT was clicked --->
<cfif isDefined("FORM.ButtonClicked") AND findNoCase("Quit", FORM.ButtonClicked) NEQ 0>
	<cfif FORM.Quantity GT 0>
		<cflocation url="index.cfm?task=serials_counts_serials_edit&Validation=1">
	<cfelse>
		<cflocation url="index.cfm?task=serials_counts_enter">
	</cfif>

<!--- CONTINUE was clicked --->
<cfelse>

	<cfset objSerialsCounts = createObject("component", "admin.assets.cfcs.SerialsCounts")>
	<cfset objSerials = createObject("component", "admin.assets.cfcs.Serials")>
	<cfset objCounts = createObject("component", "admin.assets.cfcs.Counts")>
	<cfset objScannerBatchItems = createObject("component", "admin.assets.cfcs.ScannerBatchItems")>

	<cfset stRecord = objSerialsCounts.getDataRecord()>

	<!--- Save data to tblCounts --->
	<cfset CountsID = objCounts.saveRecord(stRecord, 1)>	<!--- 1=SaveAndPostpone --->
	
	<!--- Save Serial Numbers to tblSerialsCounts --->
	<cfset structInsert(stRecord, "CountsID", CountsID, True)>

<!---<cfdump var="#stRecord#">--->

	<cfset objSerialsCounts.saveSerialNumberInput(stRecord, 1)>	<!--- 1=SaveAndPostpone --->

	<cfif stRecord.ReadyToPost EQ 1>

		<cfif NOT isDefined("FORM.CameFromConfirmationPage")>
			<cflocation url="index.cfm?task=serials_counts_serials_confirm&RequestTimeout=6000">
		<cfelse>

			<!--- Set the "posted" flag in tblCounts --->
			<cfset objCounts.setPosted(stRecord)>
	
			<!--- Set the "posted" flag for all records in tblSerialsCounts --->
			<cfset objSerialsCounts.setPosted(stRecord)>
		
			<cfset qryNotOnFile = objSerialsCounts.getNotOnFile(stRecord)>
			<cfset qryOnFile = objSerialsCounts.getOnFile(stRecord)>
			<cfset quantityError = objSerialsCounts.getQuantityError(stRecord)>
			
			<!--- Don't do this stuff if there are no discrepancies --->
			<cfif qryNotOnFile.RecordCount GT 0 OR qryOnFile.RecordCount GT 0 OR quantityError IS NOT "">

				<!--- Serial Numbers Currently on File --->
				<cfset SearchRecord = structNew()>
				<cfset structInsert(SearchRecord, "ITEMNO", stRecord.ITEMNO, True)>
				<cfset structInsert(SearchRecord, "LOCATION", stRecord.LOCATION, True)>
				<cfset qrySerials = objSerials.searchRecords(SearchRecord, "query")>
				
				<!--- Serial Numbers Scanned In --->
				<cfset qrySerialsCounts = objSerialsCounts.listRecordsForParent("CountsID", CountsID, "SortOrder")>
		
				<cfset ThisIsABatchNumberItem = 0>
				<cfset SearchRecord = structNew()>
				<cfset structInsert(SearchRecord, "ITEMNO", stRecord.ITEMNO, True)>
				<cfset qryScannerBatchItems = objScannerBatchItems.searchRecords(SearchRecord, "query")>
				<cfif qryScannerBatchItems.RecordCount GT 0>
					<cfset ThisIsABatchNumberItem = 1>
				</cfif>
						
				<cfif ThisIsABatchNumberItem>
				
					<!--- If the serial number changed --->
					<cfif trim(qrySerials.SerialNumber) IS NOT trim(qrySerialsCounts.SerialNumber)>
						<!--- Delete the Serial Numbers on file (from tblSerials) --->		
						<cfloop query="qrySerials">
							<cfset objSerials.deleteRecord(qrySerials.SerialID)>
							<cfset objSerialsCounts.createAuditTrail(stRecord, qrySerials.SerialNumber, "Remove")>
						</cfloop>
						<!--- Add the Serial Numbers that were scanned in --->
						<cfloop query="qrySerialsCounts">
							<cfset SNValue = ucase(qrySerialsCounts.SerialNumber)>
							<cfif trim(SNValue) IS NOT "">
								<!--- Add the Serial Number to tlbSerials --->
								<cfset strSerial = structNew()>
								<cfset structInsert(strSerial, "SerialID", "", True)>
								<cfset structInsert(strSerial, "ITEMNO", stRecord.ITEMNO, True)>
								<cfset structInsert(strSerial, "LOCATION", stRecord.LOCATION, True)>
								<cfset structInsert(strSerial, "SerialNumber", trim(ucase(SNValue)), True)>
								<cfset objSerials.saveRecord(strSerial)>
								<!--- Create an Audit Trail entry --->
								<cfset objSerialsCounts.createAuditTrail(stRecord, ucase(SNValue), "Add")>
							</cfif>
						</cfloop>
				
					<cfelseif qrySerials.RecordCount GT qrySerialsCounts.RecordCount>
						<!--- Need to remove serial numbers --->
						<cfset NumberToRemove = qrySerials.RecordCount - qrySerialsCounts.RecordCount>
						<cfloop query="qrySerials">
							<cfif NumberToRemove GT 0>
								<!--- Delete the Serial Number from tblSerials --->		
								<cfset objSerials.deleteRecord(qrySerials.SerialID)>
								<!--- Create an Audit Trail entry --->
								<cfset objSerialsCounts.createAuditTrail(stRecord, qrySerials.SerialNumber, "Remove")>
								<cfset NumberToRemove = NumberToRemove - 1>
							<cfelse>
								<cfbreak>
							</cfif>
						</cfloop>
					
					<cfelseif qrySerialsCounts.RecordCount GT qrySerials.RecordCount>
						<!--- Need to add serial numbers --->
						<cfset NumberToAdd = qrySerialsCounts.RecordCount - qrySerials.RecordCount>
						<cfloop query="qrySerialsCounts">
							<cfif NumberToAdd GT 0>
								<cfset SNValue = ucase(qrySerialsCounts.SerialNumber)>
								<cfif trim(SNValue) IS NOT "">
									<!--- Add the Serial Number to tlbSerials --->
									<cfset strSerial = structNew()>
									<cfset structInsert(strSerial, "SerialID", "", True)>
									<cfset structInsert(strSerial, "ITEMNO", stRecord.ITEMNO, True)>
									<cfset structInsert(strSerial, "LOCATION", stRecord.LOCATION, True)>
									<cfset structInsert(strSerial, "SerialNumber", trim(ucase(SNValue)), True)>
									<cfset objSerials.saveRecord(strSerial)>
									<!--- Create an Audit Trail entry --->
									<cfset objSerialsCounts.createAuditTrail(stRecord, ucase(SNValue), "Add")>
									<cfset NumberToAdd = NumberToAdd - 1>
								</cfif>
							<cfelse>
								<cfbreak>
							</cfif>
						</cfloop>
					</cfif>

				<cfelse>

					
					<!--- Remove the serial numbers that are currently on file --->
					<cfloop query="qrySerials">
						<cfset CURRENTSerialNumber = qrySerials.SerialNumber>
						<cfset FoundInScan = 0>
						<cfloop query="qrySerialsCounts">
							<cfif trim(CURRENTSerialNumber) IS trim(qrySerialsCounts.SerialNumber)>
								<cfset FoundInScan = 1>
								<cfbreak>
							</cfif>
						</cfloop>
						<cfif NOT FoundInScan>
							<!--- Delete the Serial Number from tblSerials --->		
							<cfset objSerials.deleteRecord(qrySerials.SerialID)>
							<!--- Create an Audit Trail entry --->
							<cfset objSerialsCounts.createAuditTrail(stRecord, qrySerials.SerialNumber, "Remove")>
						</cfif>
					</cfloop>
					
					<!--- Add the new ones --->
					<cfloop query="qrySerialsCounts">
						<cfset FoundOnFile = 0>
						<cfset SNValue = ucase(qrySerialsCounts.SerialNumber)>
						<cfloop query="qrySerials">
							<cfif trim(SNValue) IS trim(qrySerials.SerialNumber)>
								<cfset FoundOnFile = 1>
								<cfbreak>
							</cfif>
						</cfloop>
						<cfif NOT FoundOnFile AND trim(SNValue) IS NOT "">
							<!--- Add the Serial Number to tlbSerials --->
							<cfset strSerial = structNew()>
							<cfset structInsert(strSerial, "SerialID", "", True)>
							<cfset structInsert(strSerial, "ITEMNO", stRecord.ITEMNO, True)>
							<cfset structInsert(strSerial, "LOCATION", stRecord.LOCATION, True)>
							<cfset structInsert(strSerial, "SerialNumber", trim(ucase(SNValue)), True)>
							<cfset objSerials.saveRecord(strSerial)>
							<!--- Create an Audit Trail entry --->
							<cfset objSerialsCounts.createAuditTrail(stRecord, ucase(SNValue), "Add")>
						</cfif>
					</cfloop>
				
				</cfif>

			</cfif>
		
			<!--- If this is a Batch Number Item, save the serial number in tblScannerBatchItemSNs --->
			<cfset objSerialsCounts.addBatchNumberSN(stRecord)>
		
			<cfif qryNotOnFile.RecordCount GT 0 OR qryOnFile.RecordCount GT 0 OR quantityError IS NOT "">
				<cfset objSerialsCounts.setMessage("Serial Numbers were posted successfully.")>
			<cfelse>
				<cfset objSerialsCounts.setMessage("The count was marked as posted.")>
			</cfif>

		</cfif>

	<cfelse>
		<cfset objSerialsCounts.setMessage("Serial Numbers were saved.  Please scan the next set of serial numbers.")>
	</cfif>

	<cfif stRecord.ReadyToPost EQ 1>
		<!--- Go to the display page --->
		<cflocation url="index.cfm?task=serials_counts_serials_view&CountsID=#urlEncodedFormat(CountsID)#">
	<cfelse>
		<!--- If this is a "large quantity" count (processing 200 at a time), go back to frmSerials for the next batch of 200 --->
		<cfset StartBoxNumber = stRecord.EndBoxNumber + 1>
		<cflocation url="index.cfm?task=serials_counts_serials_edit&CountsID=#urlEncodedFormat(CountsID)#&StartBoxNumber=#StartBoxNumber#">
	</cfif>

</cfif>