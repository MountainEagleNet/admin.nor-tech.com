<cfcomponent extends="admin.assets.cfcs.Component">

	<cfif isDefined("APPLICATION.DSN_WWW")>
		<cfset This.DataSourceName = APPLICATION.DSN_WWW>
	<cfelse>
		<cfset This.DataSourceName = "NorTechWWW">
	</cfif>

	<cfset This.Columns = "BackOrderReceiptID,BackOrderID,QuantityReceived,DateReceived,QuantityReceivedScanned,RCPHSEQ,RCPLREV,RCPNUMBER">
	<cfset This.ViewColumns = "BackOrderReceiptID,BackOrderID,QuantityReceived,DateReceived,QuantityReceivedScanned,QuantityReceivedRemaining,RCPHSEQ,RCPLREV,RCPNUMBER,ITEMNO,ORDNUMBER,ORDUNIQ,LINENUM,QuantityBackordered,OrderQuantity,EarliestSNDate,QuantitySNs">
	
	<cfset This.TableName = "tblBackOrderReceipts">
	<cfset This.ViewName = "vBackOrderReceipts">
	
	<cfset This.PrimaryKey = "BackOrderReceiptID">
	<cfset This.ForeignHeaderKey = "">
	<cfset This.ForeignDetailKey = "">
	
	<cfset This.ITEMNOKey = "">	

	<cfset This.GenerateUUIDKey = 1>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "DateReceived">
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

	<cffunction name="findBackOrderReceipts" access="public" output="no">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset objBackOrder = createObject("component", "admin.assets.cfcs.BackOrder")>
		<cfset objSerialsReceipts = createObject("component", "admin.assets.cfcs.SerialsReceipts")>
		<cfset objPORCPH1 = createObject("component", "admin.assets.cfcs.PORCPH1")>
		<cfset objPORCPL = createObject("component", "admin.assets.cfcs.PORCPL")>

		<!--- Ignore items being received into warehouse location 3 (RMA Dept. Bad Product) --->
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "RCPHSEQ", Arguments.Record.RCPHSEQ, True)>
		<cfset structInsert(SearchRecord, "RCPLREV", Arguments.Record.RCPLREV, True)>
		<cfset qryPORCPL = objPORCPL.searchRecords(SearchRecord, "query")>
		<cfif NOT isDefined("qryPORCPL.LOCATION") OR trim(qryPORCPL.LOCATION) IS NOT "3">
		
			<!--- Ignore Drop Ship Receipts --->
			<cfset strPORCPH1 = objPORCPH1.getRecord(Arguments.Record.RCPHSEQ)>
			<cfif NOT isDefined("strPORCPH1.Reference") OR findNoCase("drop", trim(strPORCPH1.Reference)) EQ 0>
			
				<cfset qryBackOrder = objBackOrder.getRecordsForReceipt(Arguments.Record.ITEMNO)>
				<cfif qryBackOrder.RecordCount GT 0>
					<cfset SearchRecord = structNew()>
					<cfset structInsert(SearchRecord, "RCPHSEQ", Arguments.Record.RCPHSEQ, True)>
					<cfset structInsert(SearchRecord, "RCPLREV", Arguments.Record.RCPLREV, True)>
					<cfset structInsert(SearchRecord, "Posted", 1, True)>
					<cfset qrySerialsReceipts = objSerialsReceipts.searchRecords(SearchRecord, "query")>
					<cfset SerialNumberCount = qrySerialsReceipts.RecordCount>
					
					<cfset CountLeftToApply = SerialNumberCount>
					<cfloop query="qryBackOrder">
						<cfif objBackOrder.existsInACCPAC(qryBackOrder.ORDUNIQ,qryBackOrder.LINENUM)>
							<cfif objBackOrder.orderIsNotAttached(qryBackOrder.ORDUNIQ)>
								<cfif CountLeftToApply LE 0>
									<cfbreak>
								<cfelse>
									<cfif qryBackOrder.QuantityReceived IS "">
										<cfset qryBackOrder.QuantityReceived = 0>
									</cfif>
	
									<cfif qryBackOrder.QuantityReceived GT qryBackOrder.QuantitySNs>
										<cfset RemainingQuantity = qryBackOrder.OrderQuantity - qryBackOrder.QuantityReceived>
									<cfelse>
										<cfset RemainingQuantity = qryBackOrder.OrderQuantity - qryBackOrder.QuantitySNs>
									</cfif>
	
									<cfif RemainingQuantity GT 0>
										<cfif RemainingQuantity GT CountLeftToApply>
											<cfset applyReceipt(qryBackOrder.BackOrderID, CountLeftToApply, Arguments.Record.RCPHSEQ, Arguments.Record.RCPLREV, strPORCPH1.RCPNUMBER)>
											<cfset CountLeftToApply = 0>
										<cfelse>
											<cfset applyReceipt(qryBackOrder.BackOrderID, RemainingQuantity, Arguments.Record.RCPHSEQ, Arguments.Record.RCPLREV, strPORCPH1.RCPNUMBER)>
											<cfset CountLeftToApply = CountLeftToApply - RemainingQuantity>
										</cfif>
									</cfif>
								</cfif>
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="applyReceipt" access="public" output="no">
	<cfargument name="BackOrderID" type="string" required="Yes">
	<cfargument name="Amount" type="numeric" required="Yes">
	<cfargument name="RCPHSEQ" type="string" required="Yes">
	<cfargument name="RCPLREV" type="string" required="Yes">
	<cfargument name="RCPNUMBER" type="string" required="Yes">
		<cfset strBackOrderReceipt = newRecord()>
		<cfset structInsert(strBackOrderReceipt, "BackOrderID", Arguments.BackOrderID, true)>
		<cfset structInsert(strBackOrderReceipt, "QuantityReceived", Arguments.Amount, true)>
		<cfset structInsert(strBackOrderReceipt, "DateReceived", now(), true)>
		<cfset structInsert(strBackOrderReceipt, "QuantityReceivedScanned", 0, true)>
		<cfset structInsert(strBackOrderReceipt, "RCPHSEQ", Arguments.RCPHSEQ, true)>
		<cfset structInsert(strBackOrderReceipt, "RCPLREV", Arguments.RCPLREV, true)>
		<cfset structInsert(strBackOrderReceipt, "RCPNUMBER", Arguments.RCPNUMBER, true)>
		<cfset saveRecord(strBackOrderReceipt)>
	</cffunction>
	
	<cffunction name="getReceiptsForToday" access="public" returntype="query" output="no">
		<cfset qryRecords = queryNew(This.ViewColumns)>
		<cfset qryFinal = queryNew(This.ViewColumns)>
		<cfset objOEORDH = createObject("component", "admin.assets.cfcs.OEORDH")>
		<cfset StartDate = dateFormat(now(), "yyyy-mm-dd 00:00:00.0")>
		<cfset EndDate = DateFormat(now(), "yyyy-mm-dd 23:59:59.9")>
		<cfquery datasource="#This.DataSourceName#" name="qryRecords">
		SELECT 	#This.ViewColumns#
		FROM 	#This.ViewName#
		WHERE 	DateReceived >= '#StartDate#' AND 
				DateReceived <= '#EndDate#' AND
				QuantitySNs < OrderQuantity	AND
				QuantityReceivedRemaining > 0			
		ORDER BY ITEMNO, ORDNUMBER
		</cfquery>
		
		<cfloop query="qryRecords">
			<cfset strOEORDH = objOEORDH.getRecord(qryRecords.ORDUNIQ)>
			<cfif NOT structIsEmpty(strOEORDH)>
				<cfset OrderDate = dateFormat(objOEORDH.formatDate(strOEORDH.ORDDATE), "mm/dd/yyyy")>
				<cfset ThirtyDaysAgo = dateAdd("d", -30, now())>
				<cfif dateCompare(OrderDate,ThirtyDaysAgo) EQ 1>
					<cfset queryAddRow(qryFinal)>
					<cfset querySetCell(qryFinal, "BackOrderReceiptID", qryRecords.BackOrderReceiptID)>
					<cfset querySetCell(qryFinal, "BackOrderID", qryRecords.BackOrderID)>
					<cfset querySetCell(qryFinal, "QuantityReceived", qryRecords.QuantityReceived)>
					<cfset querySetCell(qryFinal, "QuantityReceivedScanned", qryRecords.QuantityReceivedScanned)>
					<cfset querySetCell(qryFinal, "QuantityReceivedRemaining", qryRecords.QuantityReceivedRemaining)>
					<cfset querySetCell(qryFinal, "DateReceived", qryRecords.DateReceived)>
					<cfset querySetCell(qryFinal, "ITEMNO", qryRecords.ITEMNO)>
					<cfset querySetCell(qryFinal, "ORDNUMBER", qryRecords.ORDNUMBER)>
					<cfset querySetCell(qryFinal, "ORDUNIQ", qryRecords.ORDUNIQ)>
					<cfset querySetCell(qryFinal, "LINENUM", qryRecords.LINENUM)>
					<cfset querySetCell(qryFinal, "QuantityBackordered", qryRecords.QuantityBackordered)>
					<cfset querySetCell(qryFinal, "OrderQuantity", qryRecords.OrderQuantity)>
					<cfset querySetCell(qryFinal, "EarliestSNDate", qryRecords.EarliestSNDate)>
					<cfset querySetCell(qryFinal, "QuantitySNs", qryRecords.QuantitySNs)>
				</cfif>
			</cfif>
		</cfloop>
		
		<cfreturn qryFinal>
	</cffunction>

	<!--- RAB --->
	<cffunction name="applyOrderToBackOrders" access="public" output="no">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var SearchRecord = structNew()>
		<cfset var qryBackOrderReceipts = queryNew("BackOrderReceiptID,QuantityReceivedScanned,QuantityReceived")>
		<cfset var CountToApply = 0>
		<cfset var AmountToPostNow = 0>
		<cfset var lstRecord = "">
		<cfset var ColumnValue = "">
		<cfset var CURRENTBackOrderReceiptID = "">
		<cfset var QuantityToApply = 0>
		<cfset var strBackOrderReceipt = structNew()>
		<cfset var NewQuantityReceivedScanned = 0>
<!---
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ORDUNIQ", trim(Arguments.Record.ORDUNIQ), True)>
		<cfset structInsert(SearchRecord, "LINENUM", trim(Arguments.Record.ORDLINENUM), True)>
		<cfset qryBackOrderReceipts = searchRecords(SearchRecord, "query")>
--->
		<cfquery datasource="#This.DataSourceName#" name="qryBackOrderReceipts">
		SELECT 	BackOrderReceiptID,QuantityReceivedScanned,QuantityReceived
		FROM 	vBackOrderReceipts
		WHERE 	ORDUNIQ = '#trim(Arguments.Record.ORDUNIQ)#' AND 
				LINENUM = '#trim(Arguments.Record.ORDLINENUM)#' 
		ORDER BY DateReceived
		</cfquery>

		<cfif qryBackOrderReceipts.RecordCount GT 0>
			<cfset CountToApply = 0>
			<cfset lstRecord = structKeyList(Arguments.Record)>
			<cfloop list="#lstRecord#" index="Column">
				<cfif findNoCase('SN_',Column) NEQ 0>
					<cfset ColumnValue = Arguments.Record[Column]>
					<cfif trim(ColumnValue) IS NOT "">
						<cfset CountToApply = CountToApply + 1>
					</cfif>
				</cfif>
			</cfloop>

			<!--- DEBUG --->
			<cfif CountToApply EQ 0 OR qryBackOrderReceipts.RecordCount EQ 0>
				<cfmail from=	"Nor-Tech <info@nor-tech.com>" 
						to=		"seanq@nor-tech.com" 
						subject="CHECK IT OUT . . ."
						type=	"html"
						timeout="60">
					BackOrderReceipts.cfc<br>
					function applyOrderToBackOrders<br>
					CountToApply = 0<br>
					Arguments.Record:<cfdump var="#Arguments.Record#">
					qryBackOrderReceipts:<cfdump var="#qryBackOrderReceipts#">
				</cfmail>
			</cfif>

			<cfloop query="qryBackOrderReceipts">
				<cfset CURRENTBackOrderReceiptID = qryBackOrderReceipts.BackOrderReceiptID>
		
				<cfif CountToApply LE 0>
					<cfbreak>
				<cfelse>
					<cfif NOT isNumeric(qryBackOrderReceipts.QuantityReceivedScanned)>
						<cfset qryBackOrderReceipts.QuantityReceivedScanned = 0>
					</cfif>
			
					<cfset QuantityToApply = qryBackOrderReceipts.QuantityReceived - qryBackOrderReceipts.QuantityReceivedScanned>

					<cfif QuantityToApply GT 0>
<!---
						<cfset strBackOrderReceipt = getRecord(CURRENTBackOrderReceiptID)>						
						<cfif strBackOrderReceipt.RCPHSEQ IS "">
							<cfset structDelete(strBackOrderReceipt, "RCPHSEQ")>
						</cfif>
						<cfif strBackOrderReceipt.RCPLREV IS "">
							<cfset structDelete(strBackOrderReceipt, "RCPLREV")>
						</cfif>
						<cfif strBackOrderReceipt.RCPNUMBER IS "">
							<cfset structDelete(strBackOrderReceipt, "RCPNUMBER")>
						</cfif>
--->
						<cfif QuantityToApply GT CountToApply>
<!---						<cfset structInsert(strBackOrderReceipt, "QuantityReceivedScanned", CountToApply, True)>	--->
							<cfset AmountToPostNow =  CountToApply>							
							<cfset CountToApply = 0>
						<cfelse>
<!---						<cfset structInsert(strBackOrderReceipt, "QuantityReceivedScanned", QuantityToApply, True)>	--->
							<cfset AmountToPostNow =  QuantityToApply>							
							<cfset CountToApply = CountToApply - QuantityToApply>
						</cfif>

<!---					<cfset saveRecord(strBackOrderReceipt)>		--->

						<cfset NewQuantityReceivedScanned = qryBackOrderReceipts.QuantityReceivedScanned + AmountToPostNow>
						<cfquery datasource="#This.DataSourceName#">
						UPDATE	tblBackOrderReceipts
						SET		QuantityReceivedScanned = #NewQuantityReceivedScanned#
						WHERE	BackOrderReceiptID = '#CURRENTBackOrderReceiptID#'
						</cfquery>
									
					</cfif>		
				</cfif>
			</cfloop>
		</cfif>
	</cffunction>

	<cffunction name="updateBackOrderReceipts" access="public" output="no">
		<cfset StartDate = dateFormat(now(), "yyyy-mm-dd 00:00:00.0")>
		<cfset EndDate = DateFormat(now(), "yyyy-mm-dd 23:59:59.9")>
		<cfquery datasource="#This.DataSourceName#" name="qryRecords">
		SELECT 	#This.ViewColumns#
		FROM 	#This.ViewName#
		WHERE 	DateReceived >= '#StartDate#' AND 
				DateReceived <= '#EndDate#' 		
		</cfquery>
		<cfloop query="qryRecords">
			<cfif isNumeric(qryRecords.QuantityReceivedRemaining) AND qryRecords.QuantityReceivedRemaining GT 0>
				<cfset strBackOrderReceipt = getRecord(qryRecords.BackOrderReceiptID)>
				<cfset NewQuantityReceived = qryRecords.QuantityReceived - qryRecords.QuantityReceivedRemaining>
				<cfset structInsert(strBackOrderReceipt, "QuantityReceived", NewQuantityReceived, True)>
				<cfset saveRecord(strBackOrderReceipt)>
			</cfif>
		</cfloop>
	</cffunction>
	
</cfcomponent>