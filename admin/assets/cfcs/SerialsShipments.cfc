<cfcomponent extends="admin.assets.cfcs.Component">

	<cfif isDefined("APPLICATION.DSN_WWW")>
		<cfset This.DataSourceName = APPLICATION.DSN_WWW>
	<cfelse>
		<cfset This.DataSourceName = "NorTechWWW">
	</cfif>

	<cfset This.Columns = "SerialsShipmentsID,SHIUNIQ,LINENUM,ORDNUMBER,SerialNumber,Posted,PostedDate,ORDUNIQ,ORDLINENUM,INVUNIQ,INVLINENUM,AttachedToInvoice">
	<cfset This.ViewColumns = This.Columns>
	
	<cfset This.TableName = "tblSerialsShipments">
	<cfset This.ViewName = This.TableName>
	
	<cfset This.PrimaryKey = "SerialsShipmentsID">
	
<!---
	<cfset This.ForeignHeaderKey = "SHIUNIQ">
	<cfset This.ForeignDetailKey = "LINENUM">
--->
	<cfset This.ForeignHeaderKey = "ORDUNIQ">
	<cfset This.ForeignDetailKey = "ORDLINENUM">

	<cfset This.OrderNumberKey = "ORDNUMBER">
	<cfset This.ITEMNOKey = "ITEM">		 <!--- Item number key of the detail table, OESHID --->

	<cfset This.GenerateUUIDKey = 1>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "SerialsShipmentsID">
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

	<cfset This.DataRecordName = "OrdersDataRecord">
	<cfset This.ErrorRecordName = "OrdersErrorRecord">

<!---
	<cffunction name="getPostedFlag" access="public" returntype="string" output="No">
	<cfargument name="HeaderKey" type="string" required="Yes">
	<cfargument name="DetailKey" type="string" required="Yes">
	<cfargument name="OrderLineQuantity" type="numeric" required="Yes">
		<cfset var PostedFlag = "">
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, This.ForeignHeaderKey, Arguments.HeaderKey, True)>
		<cfset structInsert(SearchRecord, This.ForeignDetailKey, Arguments.DetailKey, True)>
		<cfset qryRecords = searchRecords(SearchRecord, "query")>
		<cfset NumberOfPostedOnes = 0>
		<cfloop query="qryRecords">
			<cfif qryRecords.Posted EQ 1>
				<cfset NumberOfPostedOnes = NumberOfPostedOnes + 1>
			</cfif>
		</cfloop>
		<cfif qryRecords.RecordCount EQ 0>
			<cfset PostedFlag = "No Serial Numbers">
		<cfelseif NumberOfPostedOnes GE Arguments.OrderLineQuantity>
			<cfset PostedFlag = "Serial Numbers Posted">
		<cfelse>
			<cfset PostedFlag = "Serial Numbers (" & qryRecords.RecordCount &")">	
		</cfif>
		<cfreturn PostedFlag>
	</cffunction>
--->

	<cffunction name="checkForWarnings" access="public" returntype="struct" output="no">
	<!--- Check for the following warnings:
		  		1) Any of the entered serial numbers are not on file.
				2) One or more of the serial number fields is blank.
				3) This is a comp build item and the serial number(s) has already been used on another order
	--->
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stWarnings = structNew()>
		<cfset var qrySerialNumberAuditTrail = queryNew("")>
		<cfset objSerials = createObject("component", "admin.assets.cfcs.Serials")>
		<cfset objScannerBatchItems = createObject("component", "admin.assets.cfcs.ScannerBatchItems")>
		<cfset objScannerBatchItemSNs = createObject("component", "admin.assets.cfcs.ScannerBatchItemSNs")>
		<cfset objVirtualItems = createObject("component", "admin.assets.cfcs.VirtualItems")>
		<cfset objCompBuildItems = createObject("component", "admin.assets.cfcs.CompBuildItems")>

		<!--- Is this is a "batch number item"? --->
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
		
		<!--- Is this a computer build? --->
		<cfset ComputerBuild = 0>
        <cfif objCompBuildItems.isCompBuildItem(Arguments.Record[This.ITEMNOKey])>
			<cfset ComputerBuild = 1>
		</cfif>
<!---        
		<cfif trim(Arguments.Record[This.ITEMNOKey]) IS "AC-COMP-BUILD" OR
			  trim(Arguments.Record[This.ITEMNOKey]) IS "AC-COMP-CLUSTER" OR
			  trim(Arguments.Record[This.ITEMNOKey]) IS "AC-COMP-SERVER">
			<cfset ComputerBuild = 1>
		</cfif>
--->

        
		<cfset RecordList = structKeyList(Arguments.Record)>
		<cfset NumberOfBlankFields = 0>
		<cfloop list="#RecordList#" index="SNColumn">
			<cfif findNoCase("SN_", SNColumn) NEQ 0>
				<cfset SNValue = Arguments.Record[SNColumn]>
				<cfif trim(SNValue) IS "">
					<cfset NumberOfBlankFields = NumberOfBlankFields + 1>
				<cfelse>
					<cfset SavedSNValue = trim(SNValue)>

<!---				3) This is a comp build item and the serial number(s) has already been used on another order	--->
					<cfif ComputerBuild>
                        <cfquery datasource="#This.DataSourceName#" name="qrySerialNumberAuditTrail">
                        SELECT	tblSerialNumberAuditTrail.SerialNumberAuditTrailID
                        FROM	tblSerialNumberAuditTrail 
                                INNER JOIN tblCompBuilditems ON tblCompBuilditems.ITEMNO = tblSerialNumberAuditTrail.ITEMNO
                        WHERE  	(tblSerialNumberAuditTrail.TransactionType = 'order') AND 
                                (tblSerialNumberAuditTrail.AddorRemove = 'remove') AND 
                                (tblSerialNumberAuditTrail.SerialNumber = '#trim(SNValue)#')                    
                        </cfquery>
                        <cfif qrySerialNumberAuditTrail.RecordCount NEQ 0>
							<cfset structInsert(stWarnings, "CompBuildFound", 1, True)>
							<cfset ColumnName = "CompBuildFound_" & SNColumn>
							<cfset structInsert(stWarnings, ColumnName, SNValue, True)>
						</cfif>                    
					</cfif>
                    
					<cfif NOT VirtualItem AND NOT ComputerBuild>
						<!--- Is this serial number not on file? --->
						<cfset SearchRecord = structNew()>
						<cfset structInsert(SearchRecord, "SerialNumber", trim(SNValue), True)>
						<cfset qrySerials = objSerials.searchRecords(SearchRecord, "query")>
	
						<cfif qrySerials.RecordCount EQ 1 AND qrySerials.ITEMNO IS NOT Arguments.Record.ITEM>
							<cfset structInsert(stWarnings, "WrongItem", 1, True)>
							<cfset ColumnName = "WrongItem_" & SNColumn>
							<cfset structInsert(stWarnings, ColumnName, SNValue, True)>
						<cfelse>
							<!--- We're only performing the "make sure serial numbers are on file" check after the 
								  date specified by APPLICATION.WarningActivationDate in Application.cfm --->
							<cfif dateCompare(now(), APPLICATION.WarningActivationDate) EQ 1>
								<cfset structInsert(SearchRecord, "ITEMNO", Arguments.Record[This.ITEMNOKey], True)>
								<cfset qrySerials = objSerials.searchRecords(SearchRecord, "query")>
								<cfif qrySerials.RecordCount EQ 0>
									<cfset structInsert(stWarnings, "NotOnFile", 1, True)>
									<cfset ColumnName = "NotOnFile_" & SNColumn>
									<cfset structInsert(stWarnings, ColumnName, SNValue, True)>
								<cfelseif qrySerials.RecordCount GT 1 AND NOT BatchNumberItem>
									<cfset structInsert(stWarnings, "MultipleFound", 1, True)>
									<cfset ColumnName = "MultipleFound_" & SNColumn>
									<cfset structInsert(stWarnings, ColumnName, SNValue, True)>
								</cfif>
							</cfif>
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
		
		<!--- If this is a batch item, make sure that the quantity of serial numbers scanned isn't greater than the number
			  of them in tblSerials --->
		<cfif NOT isDefined("Arguments.Record.NumberOfBoxes")>
			<cfset Arguments.Record.NumberOfBoxes = 1>
		</cfif>
		<cfif BatchNumberItem>
			<cfset NumberOfSerialNumbers = Arguments.Record.NumberOfBoxes - NumberOfBlankFields>
			<cfset OnHandAmount = objSerials.getOnHandAmount(Arguments.Record.ITEM)>
			<cfif NumberOfSerialNumbers GT OnHandAmount>
				<cfset structInsert(stWarnings, "BatchItemWarning2", "Error", True)>
			</cfif>
		</cfif>
			  
		
		<!--- Any Serial Number Fields were left blank --->
		<!--- 10/17/2006: With the "Orders/Invoices addendum, we're removing this validation warning.
			  This is because each order can be shipped in multiple invoices, and the system has no way of knowing if the 
			  user left some fields blank by mistake, or because only part of the order is being shipped at this time.
			  See section "4.1.3.1. Post" in "Orders-Invoices Design Document.doc".     - Ron Barth
		--->
<!---
		<cfif NumberOfBlankFields GT 0>
			<cfset structInsert(stWarnings, "BlankFields", NumberOfBlankFields, True)>
		</cfif>
--->
		<cfreturn stWarnings>
	</cffunction>

	<cffunction name="getSerialNumberList" access="public" returntype="string" output="No">
	<!--- This function returns a list of serial numbers.  It is called from the partners section,
		  partners/orders/dspOrderDetail.cfm, to display the serial number on the invoice details. --->
<!---<cfargument name="SHINUMBER" type="string" required="Yes">--->
	<cfargument name="INVUNIQ" type="string" required="Yes">
	<cfargument name="LINENUM" type="string" required="Yes">
		<cfset var SerialNumberList = "">
<!---
		<cfset objOESHIH = createObject("component", "admin.assets.cfcs.OESHIH")>
		<!--- Get the Shipment Header, OESHIH --->
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "SHINUMBER", Arguments.SHINUMBER, True)>
		<cfset qryOESHIH = objOESHIH.searchRecords(SearchRecord)>
		<cfif isDefined("qryOESHIH.SHIUNIQ")>
--->
			<!--- Get all corresponding records in tblSerialsShipments --->
			<cfset SearchRecord = structNew()>
<!---		<cfset structInsert(SearchRecord, "SHIUNIQ", qryOESHIH.SHIUNIQ, True)>	--->
			<cfset structInsert(SearchRecord, "INVUNIQ", Arguments.INVUNIQ, True)>
			<cfset structInsert(SearchRecord, "INVLINENUM", Arguments.LINENUM, True)>
			<cfset structInsert(SearchRecord, "Posted", 1, True)>
			<cfset qrySerialsShipments = searchRecords(SearchRecord, "query", "SerialNumber")>
			<cfset FirstOne = 1>
			<cfloop query="qrySerialsShipments">
				<cfif trim(qrySerialsShipments.SerialNumber) IS NOT "">
					<cfif NOT FirstOne>
						<cfset SerialNumberList = SerialNumberList & ", ">
					</cfif>
					<cfset FirstOne = 0>
					<cfset SerialNumberList = SerialNumberList & trim(qrySerialsShipments.SerialNumber)>
				</cfif>
			</cfloop>
<!---	</cfif>	--->
		<cfreturn SerialNumberList>
	</cffunction>

<!---
	<cffunction name="findInvoiceToAttach" access="public" returntype="string" output="no">
	<!--- This function takes in an Order Number (ORDUNIQ), searches for an Invoice to attach it to, and
	      returns the Invoice Number (INVUNIQ), if found.  If not found, it returns INVUNIQ = "".
		  It is called from the admin section, serials\orders\confAttach.cfm --->
	<cfargument name="ORDUNIQ" type="string" required="Yes">
		<cfset var INVUNIQFound = "">

		<cfset objOEORDH = createObject("component", "admin.assets.cfcs.OEORDH")>
		<cfset objOEORDD = createObject("component", "admin.assets.cfcs.OEORDD")>
		<cfset objOEINVH = createObject("component", "admin.assets.cfcs.OEINVH")>
		<cfset objOEINVD = createObject("component", "admin.assets.cfcs.OEINVD")>
		<cfset objICITEM = createObject("component", "admin.assets.cfcs.ICITEM")>

		<!--- Structure of the Order Header --->
		<cfset strOEORDH = objOEORDH.getRecord(Arguments.ORDUNIQ)>

		<!--- Query of all Invoices for this Order --->
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ORDNUMBER", strOEORDH.ORDNUMBER, True)>
		<cfset qryOEINVH = objOEINVH.searchRecords(SearchRecord, "query")>

		<cfloop query="qryOEINVH">
			<cfset InvoiceFound = 1>
			<cfset CURRENTINVUNIQ = qryOEINVH.INVUNIQ>
			
			<!--- Query of all Invoice Lines for this Invoice --->
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "INVUNIQ", CURRENTINVUNIQ, True)>
			<cfset qryOEINVD = objOEINVD.searchRecords(SearchRecord, "query")>
			
			<cfloop query="qryOEINVD">
				<cfset CURRENTQTYSHIPPED = qryOEINVD.QTYSHIPPED>

				
				<!--- Check for serial numbers only if this line is for a serialized item --->
				<cfset strICITEM = objICITEM.getRecord(qryOEINVD.ITEM, "struct")>
				<cfif NOT structIsEmpty(strICITEM) AND trim(strICITEM.OPTFLD1) IS "Y">
			
					<!--- Query of Order Lines that match the item number (will usually be only 1) --->
					<cfset SearchRecord = structNew()>
					<cfset structInsert(SearchRecord, "ORDUNIQ", Arguments.ORDUNIQ, True)>
					<cfset structInsert(SearchRecord, "ITEM", qryOEINVD.ITEM, True)>
					<cfset qryOEORDD = objOEORDD.searchRecords(SearchRecord, "query")>

					<cfset FoundMatchingOrderLine = 0>
					
					<cfloop query="qryOEORDD">
						<!--- Query of the serial numbers for this order line --->
						<cfset SearchRecord = structNew()>
						<cfset structInsert(SearchRecord, "ORDUNIQ", Arguments.ORDUNIQ, True)>
						<cfset structInsert(SearchRecord, "ORDLINENUM", qryOEORDD.LINENUM, True)>
						<cfset structInsert(SearchRecord, "Posted", 1, True)>
						<cfset structInsert(SearchRecord, "AttachedToInvoice", 0, True)>
						<cfset qrySerialsShipments = searchRecords(SearchRecord, "query")>
	
						<cfif qrySerialsShipments.RecordCount EQ CURRENTQTYSHIPPED>
							<cfset FoundMatchingOrderLine = 1>
							<cfbreak>
						</cfif>
					</cfloop>
					
					<cfif NOT FoundMatchingOrderLine>
						<cfset InvoiceFound = 0>
						<cfbreak>
					</cfif>
				</cfif>
			</cfloop>
			<cfif InvoiceFound>
				<cfset INVUNIQFound = CURRENTINVUNIQ>
				<cfbreak>
			</cfif>
		</cfloop>
		<cfreturn INVUNIQFound>
	</cffunction>
--->

	<cffunction name="findInvoiceToAttach" access="public" returntype="struct" output="no">
	<!--- This function takes in an Order Number (ORDUNIQ), searches for an Invoice to attach it to, and
	      returns the Invoice Number (INVUNIQ), if found.  If not found, it returns INVUNIQ = "".
		  It is called from the admin section, serials\orders\confAttach.cfm --->
	<cfargument name="ORDUNIQ" type="string" required="Yes">
		<cfset var strInvoiceAttach = structNew()>
		<cfset var qryErrors = queryNew("ORDLINENUM,ITEM,INVNUMBER,SNsScanned,QTYSHIPPED")>		
		<cfset structInsert(strInvoiceAttach, "INVUNIQFound", "", True)>

		<cfset objOEORDH = createObject("component", "admin.assets.cfcs.OEORDH")>
		<cfset objOEORDD = createObject("component", "admin.assets.cfcs.OEORDD")>
		<cfset objOEINVH = createObject("component", "admin.assets.cfcs.OEINVH")>
		<cfset objOEINVD = createObject("component", "admin.assets.cfcs.OEINVD")>

		<!--- Structure of the Order Header --->
		<cfset strOEORDH = objOEORDH.getRecord(Arguments.ORDUNIQ)>

		<!--- Query of Order Lines --->
		<cfset qryOEORDD = getSerializedLinesNotAttached(Arguments.ORDUNIQ)>

		<!--- Query of all Invoices for this Order --->
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ORDNUMBER", strOEORDH.ORDNUMBER, True)>
		<cfset qryOEINVH = objOEINVH.searchRecords(SearchRecord, "query")>

		<cfif qryOEORDD.RecordCount NEQ 0>
			<cfloop query="qryOEINVH">
				<cfset CURRENTINVUNIQ = qryOEINVH.INVUNIQ>
				<cfset CURRENTINVNUMBER = qryOEINVH.INVNUMBER>
				
				<!--- If this invoice already has serial numbers attached, skip it --->
				<cfset SearchRecord = structNew()>
				<cfset structInsert(SearchRecord, "ORDUNIQ", Arguments.ORDUNIQ, True)>
				<cfset structInsert(SearchRecord, "INVUNIQ", CURRENTINVUNIQ, True)>
				<cfset structInsert(SearchRecord, "AttachedToInvoice", 1, True)>
				<cfset qrySerialsShipments = searchRecords(SearchRecord, "query")>
				<cfif qrySerialsShipments.RecordCount EQ 0>
				
					<cfset InvoiceFound = 1>
					<cfloop query="qryOEORDD">
						<cfset CURRENTOrdLineNum = qryOEORDD.LINENUM>

						<!--- Query of the serial numbers for this order line --->
						<cfset SearchRecord = structNew()>
						<cfset structInsert(SearchRecord, "ORDUNIQ", Arguments.ORDUNIQ, True)>
						<cfset structInsert(SearchRecord, "ORDLINENUM", CURRENTOrdLineNum, True)>
						<cfset structInsert(SearchRecord, "Posted", 1, True)>
						<cfset structInsert(SearchRecord, "AttachedToInvoice", 0, True)>
						<cfset qrySerialsShipments = searchRecords(SearchRecord, "query")>
												
						<!--- Query of Invoice Lines that match the item number (will usually be only 1) --->
						<cfset SearchRecord = structNew()>
						<cfset structInsert(SearchRecord, "INVUNIQ", CURRENTINVUNIQ, True)>
						<cfset structInsert(SearchRecord, "ITEM", qryOEORDD.ITEM, True)>
						<cfset qryOEINVD = objOEINVD.searchRecords(SearchRecord, "query")>
						<cfset FoundMatchingInvoiceLine = 0>
						<cfif qryOEINVD.RecordCount EQ 0>
							<cfset InvoiceFound = 0>
						</cfif>
						<cfloop query="qryOEINVD">
							<cfset CURRENTQTYSHIPPED = int(qryOEINVD.QTYSHIPPED)>
							<cfif qrySerialsShipments.RecordCount EQ CURRENTQTYSHIPPED>
								<cfset FoundMatchingInvoiceLine = 1>
								<cfbreak>
							</cfif>
						</cfloop>

						<cfif NOT FoundMatchingInvoiceLine AND qryOEINVD.RecordCount GT 0>
							<cfset InvoiceFound = 0>
							<cfset queryAddRow(qryErrors)>
							<cfset querySetCell(qryErrors, "ORDLINENUM", CURRENTOrdLineNum)>
							<cfset querySetCell(qryErrors, "ITEM", qryOEORDD.ITEM)>
							<cfset querySetCell(qryErrors, "INVNUMBER", CURRENTINVNUMBER)>
							<cfset querySetCell(qryErrors, "SNsScanned", qrySerialsShipments.RecordCount)>
							<cfif isDefined("CURRENTQTYSHIPPED")>
								<cfset querySetCell(qryErrors, "QTYSHIPPED", CURRENTQTYSHIPPED)>						
							</cfif>
						</cfif>		
							
					</cfloop>
					<cfif InvoiceFound>
						<cfset structInsert(strInvoiceAttach, "INVUNIQFound", CURRENTINVUNIQ, True)>
						<cfbreak>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
		<cfquery dbtype="query" name="qryErrors">
		SELECT	*
		FROM	qryErrors
		ORDER BY INVNUMBER, ORDLINENUM
		</cfquery>
		<cfset structInsert(strInvoiceAttach, "qryErrors", qryErrors, True)>	
		<cfreturn strInvoiceAttach>
	</cffunction>

	<cffunction name="validateInvoiceNumber" access="public" returntype="struct" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>

		<cfset objOEINVH = createObject("component", "admin.assets.cfcs.OEINVH")>
		<cfset objOEINVD = createObject("component", "admin.assets.cfcs.OEINVD")>
		<cfset objOEORDD = createObject("component", "admin.assets.cfcs.OEORDD")>

		<!--- INVOICE NUMBER --->
		<cfif trim(Arguments.Record.InvoiceNumber) IS "">
			<cfset stErrors.InvoiceNumber = "Please enter an Invoice Number:">
		<!--- RE-ENTER INVOICE NUMBER --->
		<cfelseif trim(Arguments.Record.REInvoiceNumber) IS "">
			<cfset stErrors.REInvoiceNumber = "Please re-enter the Invoice Number:">
		<!--- THEY MUST MATCH --->
		<cfelseif trim(Arguments.Record.InvoiceNumber) IS NOT trim(Arguments.Record.REInvoiceNumber)>
			<cfset stErrors.InvoiceNumber = "The two invoice numbers you entered do not match.">
			<cfset stErrors.REInvoiceNumber = "Please re-enter the exact Invoice Number:">
		<cfelse>
			<!--- Make sure the invoice number they entered is valid --->
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "INVNUMBER", trim(Arguments.Record.InvoiceNumber), True)>
			<cfset qryOEINVH = objOEINVH.searchRecords(SearchRecord, "query")>
			<cfif qryOEINVH.RecordCount NEQ 1>
				<cfset stErrors.InvoiceNumber = "The invoice was not found.">
			<cfelse>
				<!--- Determine if this invoice already has serial numbers attached to it --->
				<cfset SearchRecord = structNew()>
				<cfset structInsert(SearchRecord, "ORDUNIQ", Arguments.Record.ORDUNIQ, True)>
				<cfset structInsert(SearchRecord, "INVUNIQ", qryOEINVH.INVUNIQ, True)>
				<cfset structInsert(SearchRecord, "AttachedToInvoice", 1, True)>
				<cfset qrySerialsShipments = searchRecords(SearchRecord, "query")>
				<cfif qrySerialsShipments.RecordCount NEQ 0>
					<cfset stErrors.InvoiceNumber = "This invoice already has serial numbers attached to it.">
				<cfelse>
					<!--- Query of Invoice Lines --->
					<cfset qryOEINVD = objOEINVD.listRecordsForParent("INVUNIQ", qryOEINVH.INVUNIQ)>
					<cfloop query="qryOEINVD">
						<!--- Query of Order Lines that match the item number (will usually be only 1) --->
						<cfset SearchRecord = structNew()>
						<cfset structInsert(SearchRecord, "ORDUNIQ", Arguments.Record.ORDUNIQ, True)>
						<cfset structInsert(SearchRecord, "ITEM", qryOEINVD.ITEM, True)>
						<cfset qryOEORDD = objOEORDD.searchRecords(SearchRecord, "query")>
						<cfif qryOEORDD.RecordCount EQ 0>
							<cfset stErrors.WrongInvoice = "Error">
							<cfbreak>
						</cfif>
					</cfloop>
				</cfif>
			</cfif>
		</cfif>
		<cfreturn stErrors>
	</cffunction>

	<cffunction name="getSerializedLinesNotAttached" access="public" returntype="query" output="no">
	<!--- Returns a query of serialized items --->
	<cfargument name="RecordID" type="string" required="Yes">
		<cfset var qryFinal = queryNew("ORDUNIQ,LINENUM,ITEM,ORIGQTY,QTYSHPTODT,QTYORDERED,LOCATION")>
<!---        
		<cfquery datasource="#APPLICATION.DSN_AP#" name="qryRecords">
		SELECT 	dbo.OEORDD.*
		FROM 	dbo.OEORDD, dbo.ICITEM
		WHERE 	dbo.OEORDD.ORDUNIQ = '#Arguments.RecordID#' AND
				dbo.OEORDD.ITEM = dbo.ICITEM.ITEMNO AND
				dbo.ICITEM.OPTFLD1 = 'Y'
		ORDER BY dbo.OEORDD.LINENUM Asc
		</cfquery>
--->
		<cfquery datasource="#APPLICATION.DSN_AP#" name="qryRecords">
		SELECT 	dbo.OEORDD.*
		FROM 	dbo.OEORDD
        		INNER JOIN dbo.ICITEM ON dbo.OEORDD.ITEM = dbo.ICITEM.ITEMNO
        
                INNER JOIN dbo.ICITEMO ON dbo.ICITEM.ITEMNO = dbo.ICITEMO.ITEMNO			<!--- RAB 08/09/2012 --->

		WHERE 	dbo.OEORDD.ORDUNIQ = '#Arguments.RecordID#' 

				AND (dbo.ICITEMO.OPTFIELD = 'SERIALNUM') AND (dbo.ICITEMO.VALUE = 'Y')		<!--- RAB 08/09/2012 --->

		ORDER BY dbo.OEORDD.LINENUM Asc
		</cfquery>

		<cfloop query="qryRecords">
			<cfset IncludeIt = 0>
			
			<!--- If there are no serial numbers at all for this order line, include it --->
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "ORDUNIQ", qryRecords.ORDUNIQ, True)>
			<cfset structInsert(SearchRecord, "ORDLINENUM", qryRecords.LINENUM, True)>
			<cfset structInsert(SearchRecord, "Posted", 1, True)>
			<cfset qrySerialsShipments = searchRecords(SearchRecord, "query")>
			<cfif qrySerialsShipments.RecordCount EQ 0>
				<cfset IncludeIt = 1>
			<cfelse>
				<!--- If there's at least 1 unattached serial number, include it --->
				<cfset structInsert(SearchRecord, "AttachedToInvoice", 0, True)>
				<cfset qrySerialsShipments = searchRecords(SearchRecord, "query")>
				<cfif qrySerialsShipments.RecordCount GT 0>
					<cfset IncludeIt = 1>
				</cfif>
			</cfif>
<!---			
<!---		<cfset structInsert(SearchRecord, "AttachedToInvoice", 0, True)>	--->
			<cfset structInsert(SearchRecord, "AttachedToInvoice", 1, True)>
			<cfset qrySerialsShipments = searchRecords(SearchRecord, "query")>

<!---		<cfif qrySerialsShipments.RecordCount GT 0>	--->
			<cfif qrySerialsShipments.RecordCount EQ 0>
--->
			<cfif IncludeIt>
				<cfset queryAddRow(qryFinal)>
				<cfset querySetCell(qryFinal, "ORDUNIQ", qryRecords.ORDUNIQ)>
				<cfset querySetCell(qryFinal, "LINENUM", qryRecords.LINENUM)>
				<cfset querySetCell(qryFinal, "ITEM", qryRecords.ITEM)>
				<cfset querySetCell(qryFinal, "ORIGQTY", qryRecords.ORIGQTY)>
				<cfset querySetCell(qryFinal, "QTYSHPTODT", qryRecords.QTYSHPTODT)>
				<cfset querySetCell(qryFinal, "QTYORDERED", qryRecords.QTYORDERED)>
				<cfset querySetCell(qryFinal, "LOCATION", qryRecords.LOCATION)>
			</cfif>
		</cfloop>
		<cfreturn qryFinal>
	</cffunction>

	
	<cffunction name="attachInvoice" access="public" returntype="boolean" output="No">
	<!--- This function takes in an Order Number (ORDUNIQ) and an Invoice Number (INVUNIQ),
		  and "attaches" all unattached serial numbers for that order to that invoice.
		  It is called from the admin section, serials\orders\actConfAttach.cfm --->
	<cfargument name="ORDUNIQ" type="string" required="Yes">
	<cfargument name="INVUNIQ" type="string" required="Yes">
	<cfargument name="ManualInvoiceNumber" type="string" required="No">
		<cfset var Success = 1>
		<cfset objOEORDD = createObject("component", "admin.assets.cfcs.OEORDD")>
		<cfset objOEINVH = createObject("component", "admin.assets.cfcs.OEINVH")>
		<cfset objOEINVD = createObject("component", "admin.assets.cfcs.OEINVD")>
		<cfset objOESHIH = createObject("component", "admin.assets.cfcs.OESHIH")>

		<cfif NOT isDefined("Arguments.ManualInvoiceNumber")>
			<cfset Arguments.ManualInvoiceNumber = 0>
		</cfif>
		
		<!--- Structure of the Invoice Header --->
		<cfset strOEINVH = objOEINVH.getRecord(Arguments.INVUNIQ)>
		
		<!--- Get the Shipment Number (SHIUNIQ) that corresponds to this invoice --->
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "SHINUMBER", strOEINVH.SHINUMBER, True)>
		<cfset qryOESHIH = objOESHIH.searchRecords(SearchRecord, "query")>
		<cfset ShipmentSHIUNIQ = "">
		<cfif qryOESHIH.RecordCount GT 0>
			<cfset ShipmentSHIUNIQ = qryOESHIH.SHIUNIQ>
		</cfif>

		<!--- Query of Order Lines for this Order --->
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ORDUNIQ", Arguments.ORDUNIQ, True)>
		<cfset qryOEORDD = objOEORDD.searchRecords(SearchRecord, "query", "LINENUM")>
		<cfloop query="qryOEORDD">
			<cfset CURRENTITEM = qryOEORDD.ITEM>
			<cfset CURRENTLINENUM = qryOEORDD.LINENUM>
			
			<!--- Query of the serial numbers for this order line --->
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "ORDUNIQ", Arguments.ORDUNIQ, True)>
			<cfset structInsert(SearchRecord, "ORDLINENUM", CURRENTLINENUM, True)>
			<cfset structInsert(SearchRecord, "Posted", 1, True)>
			<cfset structInsert(SearchRecord, "AttachedToInvoice", 0, True)>
			<cfset qrySerialsShipments = searchRecords(SearchRecord, "query")>
			
			<cfif qrySerialsShipments.RecordCount GT 0>
				<!--- Query of Invoice Lines that match the item number (will usually be only 1) --->
				<cfset SearchRecord = structNew()>
				<cfset structInsert(SearchRecord, "INVUNIQ", Arguments.INVUNIQ, True)>
				<cfset structInsert(SearchRecord, "ITEM", CURRENTITEM, True)>
				<cfset qryOEINVD = objOEINVD.searchRecords(SearchRecord, "query", "LINENUM")>
				
				<cfset InvoiceLINENUM = "">
				<cfloop query="qryOEINVD">
					<cfif qrySerialsShipments.RecordCount EQ qryOEINVD.QTYSHIPPED>
						<cfset InvoiceLINENUM = qryOEINVD.LINENUM>
						<cfbreak>
					</cfif>
				</cfloop>

				<!--- If we couldn't find the line with the exact quantity, use the first line that matches the item --->
				<cfif Arguments.ManualInvoiceNumber AND InvoiceLINENUM IS "">
					<cfloop query="qryOEINVD">
						<cfset InvoiceLINENUM = qryOEINVD.LINENUM>
						<cfbreak>
					</cfloop>
				</cfif>				
				
				<cfif InvoiceLINENUM IS "">
					<cfset Success = 0>
				<cfelse>
					<cfloop query="qrySerialsShipments">
						<cfset strSerialsShipment = getRecord(qrySerialsShipments.SerialsShipmentsID)>
						<cfset structInsert(strSerialsShipment, "INVUNIQ", Arguments.INVUNIQ, True)>
						<cfset structInsert(strSerialsShipment, "INVLINENUM", InvoiceLINENUM, True)>
						<cfset structInsert(strSerialsShipment, "AttachedToInvoice", 1, True)>
						<cfif trim(ShipmentSHIUNIQ) IS NOT "">
							<cfset structInsert(strSerialsShipment, "SHIUNIQ", ShipmentSHIUNIQ, True)>
						<cfelse>
							<cfset structDelete(strSerialsShipment, "SHIUNIQ")>
						</cfif>
						<cfset structInsert(strSerialsShipment, "LINENUM", InvoiceLINENUM, True)>
						<cfset saveRecord(strSerialsShipment)>
					</cfloop>
				</cfif>
			</cfif>
		</cfloop>
		<cfreturn Success>
	</cffunction>	

	<cffunction name="correctSerialNumber" access="public" output="no">
	<cfargument name="Record" type="struct" required="Yes">

		<cfset objOEORDD = createObject("component", "admin.assets.cfcs.OEORDD")>
		<cfset objSerialNumberAuditTrail = createObject("component", "admin.assets.cfcs.SerialNumberAuditTrail")>
		<cfset objSerials = createObject("component", "admin.assets.cfcs.Serials")>

		<!--- Get a query of the Order detail --->
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ORDUNIQ", Arguments.Record.ORDUNIQ, True)>
		<cfset structInsert(SearchRecord, "LINENUM", Arguments.Record.ORDLINENUM, True)>
		<cfset qryDetail = objOEORDD.searchRecords(SearchRecord, "query")>
	
		<!--- Update tblSerialsShipments with the new serial number --->
		<cfset strSerialsShipment = getRecord(Arguments.Record.SerialsShipmentsID)>
		<cfset structInsert(strSerialsShipment, "SerialNumber", Arguments.Record.NewSerialNumber, True)>
		<cfset structDelete(strSerialsShipment, "SHIUNIQ")>
		<cfset structDelete(strSerialsShipment, "LINENUM")>
		<cfset structDelete(strSerialsShipment, "INVUNIQ")>
		<cfset structDelete(strSerialsShipment, "INVLINENUM")>
		<cfset saveRecord(strSerialsShipment)>

		<!--- Edit the Audit Trail --->
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "SerialTableIDValue", Arguments.Record.SerialsShipmentsID, True)>
		<cfset qrySerialNumberAuditTrail = objSerialNumberAuditTrail.searchRecords(SearchRecord, "query")>
		<cfset CurrentLOCATION = qrySerialNumberAuditTrail.LOCATION>
<!---
		<cfset strSerialNumberAuditTrail = objSerialNumberAuditTrail.getRecord(qrySerialNumberAuditTrail.SerialNumberAuditTrailID)>
		<cfset structInsert(strSerialNumberAuditTrail, "SerialNumber", Arguments.Record.NewSerialNumber, True)>
		<cfset objSerialNumberAuditTrail.saveRecord(strSerialNumberAuditTrail)>
--->
		<!--- Create a "correction" record in tblSerialNumberAuditTrail for the Old Serial Number --->
		<cfset objSerialNumberAuditTrail.createAuditTrailDeletion(Arguments.Record.OldSerialNumber, qrySerialNumberAuditTrail.ITEMNO, qrySerialNumberAuditTrail.LOCATION, qrySerialNumberAuditTrail.TransactionNumber, "Ord Correction", "Add", Arguments.Record.SerialsShipmentsID)>
		<!--- Create a "correction" record in tblSerialNumberAuditTrail for the New Serial Number --->
		<cfset objSerialNumberAuditTrail.createAuditTrailDeletion(Arguments.Record.NewSerialNumber, qrySerialNumberAuditTrail.ITEMNO, qrySerialNumberAuditTrail.LOCATION, qrySerialNumberAuditTrail.TransactionNumber, "Ord Correction", "Remove", Arguments.Record.SerialsShipmentsID)>
		
		<!--- Add the Old serial number back to tblSerials --->
		<cfset strSerial = objSerials.newRecord()>
		<cfset structInsert(strSerial, "ITEMNO", qryDetail.ITEM, True)>
		<cfset structInsert(strSerial, "LOCATION", CurrentLOCATION, True)>
		<cfset structInsert(strSerial, "SerialNumber", Arguments.Record.OldSerialNumber, True)>
		<cfset objSerials.saveRecord(strSerial)>
		
		<!--- Remove the new serial number from tblSerials --->
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "SerialNumber", Arguments.Record.NewSerialNumber, True)>
		<cfset structInsert(SearchRecord, "ITEMNO", qryDetail.ITEM, True)>
		<cfset qrySerials = objSerials.searchRecords(SearchRecord, "query")>
		<cfif qrySerials.RecordCount NEQ 0>
			<cfset objSerials.deleteRecord(qrySerials.SerialID)>
		</cfif>

	</cffunction>

	<cffunction name="getFirstUnpostedItem" access="public" returntype="string" output="No">
	<cfargument name="ORDUNIQ" type="string" required="Yes">
	<cfargument name="ORDLINENUM" type="string" required="No">
		<cfset var FirstUnpostedLINENUM = "">
		<cfset objOEORDD = createObject("component", "admin.assets.cfcs.OEORDD")>
		<cfset qryOEORDD = objOEORDD.getSerializedLines(Arguments.ORDUNIQ)>
		<cfloop query="qryOEORDD">
			<cfif NOT isDefined("Arguments.ORDLINENUM") OR qryOEORDD.LINENUM GT Arguments.ORDLINENUM>
		
				<cfset SearchRecord = structNew()>
				<cfset structInsert(SearchRecord, This.ForeignHeaderKey, qryOEORDD.ORDUNIQ, True)>
				<cfset structInsert(SearchRecord, This.ForeignDetailKey, qryOEORDD.LINENUM, True)>
				<cfset structInsert(SearchRecord, "Posted", 1, True)>
				<cfset qrySerialsShipments = searchRecords(SearchRecord, "query")>
				<cfif qrySerialsShipments.RecordCount EQ 0>
					<cfset FirstUnpostedLINENUM = qryOEORDD.LINENUM>
					<cfbreak>
				<cfelseif qrySerialsShipments.RecordCount LT (qryOEORDD.QTYORDERED + qryOEORDD.QTYSHPTODT)>
					<cfset FirstUnpostedLINENUM = qryOEORDD.LINENUM>
					<cfif NOT isDefined("Arguments.ORDLINENUM")>
						<cfbreak>
					</cfif>
				</cfif>
			</cfif>
		</cfloop>
		<cfreturn FirstUnpostedLINENUM>
	</cffunction>

	<cffunction name="setPosted" access="public" output="No">
	<!--- Set the posted flag --->
	<cfargument name="Record" type="struct" required="Yes">
		<cfset CurrentPostedDate = createODBCDateTime(now())>
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ORDUNIQ", Arguments.Record.ORDUNIQ, True)>
		<cfset structInsert(SearchRecord, "ORDLINENUM", Arguments.Record.ORDLINENUM, True)>
		<cfset qryRecords = searchRecords(SearchRecord, "query")>
		<cfloop query="qryRecords">
			<cfquery datasource="#This.DataSourceName#">
				UPDATE 	tblSerialsShipments 
				SET		Posted = 1
						<cfif qryRecords.PostedDate IS "">
							, PostedDate = #CurrentPostedDate#
						</cfif>
				WHERE 	SerialsShipmentsID = '#qryRecords.SerialsShipmentsID#'
			</cfquery>
		</cfloop>
	</cffunction>

	<cffunction name="checkForBug" access="public" output="no">
	<cfargument name="Record" type="struct" required="Yes">
	<cfargument name="PostLocation" type="numeric" required="Yes">
		<cfset objOEORDD = createObject("component", "admin.assets.cfcs.OEORDD")>
		
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ORDUNIQ", Arguments.Record.ORDUNIQ, True)>
		<cfset structInsert(SearchRecord, "LINENUM", Arguments.Record.ORDLINENUM, True)>
		<cfset qryOrderDetail = objOEORDD.searchRecords(SearchRecord, "query")>
		
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ORDUNIQ", Arguments.Record.ORDUNIQ, True)>
		<cfset structInsert(SearchRecord, "ORDLINENUM", Arguments.Record.ORDLINENUM, True)>
		<cfif Arguments.PostLocation EQ 4>
			<cfset structInsert(SearchRecord, "Posted", 1, True)>
		</cfif>
		<cfset qrySerialsShipments = searchRecords(SearchRecord, "query")>

		<cfif NOT isNumeric(qryOrderDetail.QTYORDERED)><cfset qryOrderDetail.QTYORDERED = 0></cfif>
		<cfif NOT isNumeric(qryOrderDetail.QTYSHPTODT)><cfset qryOrderDetail.QTYSHPTODT = 0></cfif>
		<cfset RemainingQuantity = int((qryOrderDetail.QTYORDERED + qryOrderDetail.QTYSHPTODT) - qrySerialsShipments.RecordCount)>

		<cfif RemainingQuantity LT 0>
<!---
			<cfmail from=	"Nor-Tech <info@nor-tech.com>" 
					to=		"ron_barth@altsystem.com" 
					subject="POSSIBLE BUG . . ."
					type=	"html"
					timeout="60">
				Hey Ron: check it out:  This order line has a remaining quantity less than zero.<br>
				Order Number: #Arguments.Record.ORDNUMBER#<br>
				Item: #Arguments.Record.ITEM#<br>
				Order Line Number: #Arguments.Record.ORDLINENUM#<br>
				actPost POST LOCATION: #Arguments.PostLocation#<br>
				Here's stRecord:<br>
				<cfdump var="#Arguments.Record#">
			</cfmail>
--->
			<cfmail from=	"Nor-Tech <info@nor-tech.com>"
					to=		"robb@nor-tech.com; larryh@nor-tech.com"
					subject="An Order Line has a quantity less than zero"
					type=	"html"
					timeout="60">
				Rob<br><br>
				
				This order line has a remaining quantity less than zero.<br>
				Order Number: #Arguments.Record.ORDNUMBER#<br>
				Item: #Arguments.Record.ITEM#<br><br>
				
				Go into the order, find the item in question, click "Serial Numbers Posted", then click "[DELETE]" on the duplicated serial number.
			</cfmail>
		</cfif>

	</cffunction>

	<cffunction name="applySerialNumbersFromReceipt" access="public" returntype="boolean" output="no">
	<cfargument name="ORDUNIQ" type="string" required="Yes">
	<cfargument name="RCPHSEQ" type="string" required="Yes">	
		<cfset var AtLeastOneSNApplied = 0>
		<cfset var stRecord = structNew()>
		<cfset var ThisSerialNumberWasApplied = 0>
		<cfset objSerialsReceipts = createObject("component", "admin.assets.cfcs.SerialsReceipts")>
		<cfset objPORCPL = createObject("component", "admin.assets.cfcs.PORCPL")>
		<cfset objSerials = createObject("component", "admin.assets.cfcs.Serials")>
		<cfset objOEORDD = createObject("component", "admin.assets.cfcs.OEORDD")>
		<cfset objOEORDH = createObject("component", "admin.assets.cfcs.OEORDH")>
		<cfset objAdmin = createObject("component", "admin.assets.cfcs.Admin")>
		<cfset objSerialNumberAuditTrail = createObject("component", "admin.assets.cfcs.SerialNumberAuditTrail")>
		<cfset objBackOrderReceipts = createObject("component", "admin.assets.cfcs.BackOrderReceipts")>

		<!--- Get all serial numbers for this receipt --->
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "RCPHSEQ", trim(Arguments.RCPHSEQ), True)>
		<cfset qrySerialsReceipts = objSerialsReceipts.searchRecords(SearchRecord, "query", "RCPLREV, SortOrder")>

		<cfloop query="qrySerialsReceipts">
			<cfset Current_RCPLREV = qrySerialsReceipts.RCPLREV>
			<cfset Current_SerialNumber = qrySerialsReceipts.SerialNumber>
			
			<cfif qrySerialsReceipts.Posted EQ 1>
				
				<!--- Get the item number --->				
				<cfset SearchRecord = structNew()>
				<cfset structInsert(SearchRecord, "RCPHSEQ", trim(Arguments.RCPHSEQ), True)>
				<cfset structInsert(SearchRecord, "RCPLREV", trim(Current_RCPLREV), True)>
				<cfset qryPORCPL = objPORCPL.searchRecords(SearchRecord, "query")>
				<cfif qryPORCPL.RecordCount GT 0>
					<cfset Current_ITEMNO = qryPORCPL.ITEMNO>
					<cfset Current_LOCATION = qryPORCPL.LOCATION>
					
					<!--- Make sure the serial number exists in tblSerials --->
					<cfset SearchRecord = structNew()>
					<cfset structInsert(SearchRecord, "SerialNumber", trim(Current_SerialNumber), True)>
					<cfset structInsert(SearchRecord, "ITEMNO", trim(Current_ITEMNO), True)>
					<cfset structInsert(SearchRecord, "LOCATION", trim(Current_LOCATION), True)>
					<cfset qrySerials = objSerials.searchRecords(SearchRecord, "query")>
					<cfif qrySerials.RecordCount GT 0>
					
						<cfset Current_SerialID = qrySerials.SerialID>
					
						<!--- Find all order lines for this order that matches the item --->
						<cfset SearchRecord = structNew()>
						<cfset structInsert(SearchRecord, "ORDUNIQ", trim(Arguments.ORDUNIQ), True)>
						<cfset structInsert(SearchRecord, "ITEM", trim(Current_ITEMNO), True)>
						<cfset qryOEORDD = objOEORDD.searchRecords(SearchRecord, "query")>

						<cfset ThisSerialNumberWasApplied = 0>
						<cfloop query="qryOEORDD">
							<cfif NOT ThisSerialNumberWasApplied>
								<cfset Current_ORDLINENUM = qryOEORDD.LINENUM>
								
								<!--- Find remaining quantity for this order line --->
								<cfset SearchRecord = structNew()>
								<cfset structInsert(SearchRecord, "ORDUNIQ", trim(Arguments.ORDUNIQ), True)>
								<cfset structInsert(SearchRecord, "ORDLINENUM", trim(Current_ORDLINENUM), True)>
								<cfset structInsert(SearchRecord, "Posted", 1, True)>
								<cfset qrySerialsShipments = searchRecords(SearchRecord, "query")>
						
								<cfif NOT isNumeric(qryOEORDD.QTYORDERED)><cfset qryOEORDD.QTYORDERED = 0></cfif>
								<cfif NOT isNumeric(qryOEORDD.QTYSHPTODT)><cfset qryOEORDD.QTYSHPTODT = 0></cfif>
								<cfset RemainingQuantity = int((qryOEORDD.QTYORDERED + qryOEORDD.QTYSHPTODT) - qrySerialsShipments.RecordCount)>
								<cfif RemainingQuantity GT 0>
									<!--- Structure of the Order Header --->
									<cfset strOEORDH = objOEORDH.getRecord(Arguments.ORDUNIQ)>
									
									<!--- Save the Serial Number to tblSerialsShipments --->
									<cfset strSerialsShipment = structNew()>
									<cfset structInsert(strSerialsShipment, "SerialsShipmentsID", "", True)>
									<cfset structInsert(strSerialsShipment, "ORDNUMBER", trim(strOEORDH.ORDNUMBER), True)>
									<cfset structInsert(strSerialsShipment, "SerialNumber", trim(Current_SerialNumber), True)>
									<cfset structInsert(strSerialsShipment, "Posted", 1, True)>
									<cfset structInsert(strSerialsShipment, "ORDUNIQ", trim(Arguments.ORDUNIQ), True)>
									<cfset structInsert(strSerialsShipment, "ORDLINENUM", trim(Current_ORDLINENUM), True)>
									<cfset structInsert(strSerialsShipment, "AttachedToInvoice", 0, True)>
									<cfset NewSerialsShipmentsID = saveRecord(strSerialsShipment)>
									
									<!--- Remove Serial Number from tblSerials --->
									<cfset objSerials.deleteRecord(Current_SerialID)>
									
									<!--- Create Audit Trail entry in tblSerialNumberAuditTrail --->
									<cfset strSerialNumberAuditTrail = structNew()>
									<cfset structInsert(strSerialNumberAuditTrail, "SerialNumberAuditTrailID", "", True)>
									<cfset structInsert(strSerialNumberAuditTrail, "TransactionType", "Order", True)>
									<cfset structInsert(strSerialNumberAuditTrail, "TransactionNumber", trim(strOEORDH.ORDNUMBER), True)>
									<cfset structInsert(strSerialNumberAuditTrail, "CreationDate", "", True)>
									<cfset qryUser = objAdmin.getRecordAsQuery(SESSION.adminuserid)>
									<cfset structInsert(strSerialNumberAuditTrail, "UserFirstName", trim(qryUser.fname), True)>
									<cfset structInsert(strSerialNumberAuditTrail, "UserLastName", trim(qryUser.lname), True)>
									<cfset structInsert(strSerialNumberAuditTrail, "UserEmail", trim(qryUser.emailaddress), True)>
									<cfset structInsert(strSerialNumberAuditTrail, "ITEMNO", trim(Current_ITEMNO), True)>
									<cfset structInsert(strSerialNumberAuditTrail, "ITEMDESC", trim(getItemDescription(Current_ITEMNO)), True)>
									<cfset structInsert(strSerialNumberAuditTrail, "SerialNumber", trim(Current_SerialNumber), True)>
									<cfset structInsert(strSerialNumberAuditTrail, "AddorRemove", "Remove", True)>								
									<cfset structInsert(strSerialNumberAuditTrail, "LOCATION", trim(Current_LOCATION), True)>
									<cfset structInsert(strSerialNumberAuditTrail, "LOCATIONDESC", trim(getLocationDescription(Current_LOCATION)), True)>
									<cfset structInsert(strSerialNumberAuditTrail, "CUSTOMER", trim(strOEORDH.CUSTOMER), True)>
									<cfset structInsert(strSerialNumberAuditTrail, "BILNAME", trim(strOEORDH.BILNAME), True)>
	
									<cfset structInsert(strSerialNumberAuditTrail, "SerialTable", "tblSerialsShipments", True)>
									<cfset structInsert(strSerialNumberAuditTrail, "SerialTableIDField", "SerialsShipmentsID", True)>
									<cfset structInsert(strSerialNumberAuditTrail, "SerialTableIDValue", trim(NewSerialsShipmentsID), True)>
									<cfset objSerialNumberAuditTrail.saveRecord(strSerialNumberAuditTrail)>
	
									<!--- Apply to back order receipts --->
									<cfset stRecord = structNew()>
									<cfset structInsert(stRecord, "ORDUNIQ", Arguments.ORDUNIQ, true)>
									<cfset structInsert(stRecord, "ORDLINENUM", Current_ORDLINENUM, true)>
									<cfset structInsert(stRecord, "SN_1", Current_SerialNumber, true)>
									<cfset objBackOrderReceipts.applyOrderToBackOrders(stRecord)>
	
									<cfset ThisSerialNumberWasApplied = 1>
									<cfset AtLeastOneSNApplied = 1>
																	
								</cfif>
							</cfif>
						</cfloop>
					</cfif>
				</cfif>
			</cfif>
		</cfloop>
		
		<cfreturn AtLeastOneSNApplied>
	</cffunction>

	<cffunction name="applySerialNumbersFromOrder" access="public" returntype="boolean" output="no">
	<cfargument name="ORDUNIQ_To" type="string" required="Yes">
	<cfargument name="ORDUNIQ_From" type="string" required="Yes">	
		<cfset var AtLeastOneSNApplied = 0>
		<cfset var stRecord = structNew()>
		<cfset var qryBackOrder = queryNew("")>
		<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>
		<cfset objOEORDD = createObject("component", "admin.assets.cfcs.OEORDD")>
		<cfset objOEORDH = createObject("component", "admin.assets.cfcs.OEORDH")>
		<cfset objAdmin = createObject("component", "admin.assets.cfcs.Admin")>
		<cfset objSerialNumberAuditTrail = createObject("component", "admin.assets.cfcs.SerialNumberAuditTrail")>

		<!--- Get all serial numbers for the "From" order --->
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ORDUNIQ", trim(Arguments.ORDUNIQ_From), True)>
		<cfset qrySerialsShipments_From = objSerialsShipments.searchRecords(SearchRecord, "query", "ORDLINENUM")>
		
		<cfloop query="qrySerialsShipments_From">
			<cfset Current_ORDLINENUM_From = qrySerialsShipments_From.ORDLINENUM>
			<cfset Current_SerialNumber = qrySerialsShipments_From.SerialNumber>
			<cfset Current_SerialsShipmentsID_From = qrySerialsShipments_From.SerialsShipmentsID>
			
			<cfif qrySerialsShipments_From.Posted EQ 1>
				
				<!--- Get the item number --->				
				<cfset SearchRecord = structNew()>
				<cfset structInsert(SearchRecord, "ORDUNIQ", trim(Arguments.ORDUNIQ_From), True)>
				<cfset structInsert(SearchRecord, "LINENUM", trim(Current_ORDLINENUM_From), True)>
				<cfset qryOEORDD_From = objOEORDD.searchRecords(SearchRecord, "query")>
				<cfif qryOEORDD_From.RecordCount GT 0>
					<cfset Current_ITEM_From = qryOEORDD_From.ITEM>
					<cfset Current_LOCATION_From = qryOEORDD_From.LOCATION>
					
					<!--- Find all order lines for this order that matches the item --->
					<cfset SearchRecord = structNew()>
					<cfset structInsert(SearchRecord, "ORDUNIQ", trim(Arguments.ORDUNIQ_To), True)>
					<cfset structInsert(SearchRecord, "ITEM", trim(Current_ITEM_From), True)>
					<cfset qryOEORDD_To = objOEORDD.searchRecords(SearchRecord, "query")>
					<cfloop query="qryOEORDD_To">
						<cfset Current_ORDLINENUM_To = qryOEORDD_To.LINENUM>
						<cfset Current_LOCATION_To = qryOEORDD_To.LOCATION>

						<!--- Find remaining quantity for this order line --->
						<cfset SearchRecord = structNew()>
						<cfset structInsert(SearchRecord, "ORDUNIQ", trim(Arguments.ORDUNIQ_To), True)>
						<cfset structInsert(SearchRecord, "ORDLINENUM", trim(Current_ORDLINENUM_To), True)>
						<cfset structInsert(SearchRecord, "Posted", 1, True)>
						<cfset qrySerialsShipments_To = searchRecords(SearchRecord, "query")>
				
						<cfif NOT isNumeric(qryOEORDD_To.QTYORDERED)><cfset qryOEORDD_To.QTYORDERED = 0></cfif>
						<cfif NOT isNumeric(qryOEORDD_To.QTYSHPTODT)><cfset qryOEORDD_To.QTYSHPTODT = 0></cfif>
						<cfset RemainingQuantity = int((qryOEORDD_To.QTYORDERED + qryOEORDD_To.QTYSHPTODT) - qrySerialsShipments_To.RecordCount)>
						<cfif RemainingQuantity GT 0>
						
							<!--- FOR THE FROM ORDER: Delete the Serial Number from tblSerialsShipments --->
							<cfset deleteRecord(Current_SerialsShipmentsID_From)>

							<!--- Structure of the Order Header --->
							<cfset strOEORDH_From = objOEORDH.getRecord(Arguments.ORDUNIQ_From)>

							<!--- FOR THE FROM ORDER: Create Audit Trail entry in tblSerialNumberAuditTrail --->
							<cfset strSerialNumberAuditTrail_From = structNew()>
							<cfset structInsert(strSerialNumberAuditTrail_From, "SerialNumberAuditTrailID", "", True)>
							<cfset structInsert(strSerialNumberAuditTrail_From, "TransactionType", "Order", True)>
							<cfset structInsert(strSerialNumberAuditTrail_From, "TransactionNumber", trim(strOEORDH_From.ORDNUMBER), True)>
							<cfset structInsert(strSerialNumberAuditTrail_From, "CreationDate", "", True)>
							<cfset qryUser = objAdmin.getRecordAsQuery(SESSION.adminuserid)>
							<cfset structInsert(strSerialNumberAuditTrail_From, "UserFirstName", trim(qryUser.fname), True)>
							<cfset structInsert(strSerialNumberAuditTrail_From, "UserLastName", trim(qryUser.lname), True)>
							<cfset structInsert(strSerialNumberAuditTrail_From, "UserEmail", trim(qryUser.emailaddress), True)>
							<cfset structInsert(strSerialNumberAuditTrail_From, "ITEMNO", trim(Current_ITEM_From), True)>
							<cfset structInsert(strSerialNumberAuditTrail_From, "ITEMDESC", trim(getItemDescription(Current_ITEM_From)), True)>
							<cfset structInsert(strSerialNumberAuditTrail_From, "SerialNumber", trim(Current_SerialNumber), True)>
							<cfset structInsert(strSerialNumberAuditTrail_From, "AddorRemove", "Add", True)>								
							<cfset structInsert(strSerialNumberAuditTrail_From, "LOCATION", trim(Current_LOCATION_From), True)>
							<cfset structInsert(strSerialNumberAuditTrail_From, "LOCATIONDESC", trim(getLocationDescription(Current_LOCATION_From)), True)>
							<cfset structInsert(strSerialNumberAuditTrail_From, "CUSTOMER", trim(strOEORDH_From.CUSTOMER), True)>
							<cfset structInsert(strSerialNumberAuditTrail_From, "BILNAME", trim(strOEORDH_From.BILNAME), True)>

							<cfset structInsert(strSerialNumberAuditTrail_From, "SerialTable", "tblSerialsShipments", True)>
							<cfset structInsert(strSerialNumberAuditTrail_From, "SerialTableIDField", "SerialsShipmentsID", True)>
							<cfset structInsert(strSerialNumberAuditTrail_From, "SerialTableIDValue", trim(Current_SerialsShipmentsID_From), True)>
							<cfset objSerialNumberAuditTrail.saveRecord(strSerialNumberAuditTrail_From)>							
						
						
							<!--- Structure of the Order Header --->
							<cfset strOEORDH_To = objOEORDH.getRecord(Arguments.ORDUNIQ_To)>
							
							<!--- FOR THE TO ORDER: Save the Serial Number to tblSerialsShipments --->
							<cfset strSerialsShipment_To = structNew()>
							<cfset structInsert(strSerialsShipment_To, "SerialsShipmentsID", "", True)>
							<cfset structInsert(strSerialsShipment_To, "ORDNUMBER", trim(strOEORDH_To.ORDNUMBER), True)>
							<cfset structInsert(strSerialsShipment_To, "SerialNumber", trim(Current_SerialNumber), True)>
							<cfset structInsert(strSerialsShipment_To, "Posted", 1, True)>
							<cfset structInsert(strSerialsShipment_To, "ORDUNIQ", trim(Arguments.ORDUNIQ_To), True)>
							<cfset structInsert(strSerialsShipment_To, "ORDLINENUM", trim(Current_ORDLINENUM_To), True)>
							<cfset structInsert(strSerialsShipment_To, "AttachedToInvoice", 0, True)>
							<cfset NewSerialsShipmentsID_To = saveRecord(strSerialsShipment_To)>
							
							<!--- FOR THE TO ORDER: Create Audit Trail entry in tblSerialNumberAuditTrail --->
							<cfset strSerialNumberAuditTrail_To = structNew()>
							<cfset structInsert(strSerialNumberAuditTrail_To, "SerialNumberAuditTrailID", "", True)>
							<cfset structInsert(strSerialNumberAuditTrail_To, "TransactionType", "Order", True)>
							<cfset structInsert(strSerialNumberAuditTrail_To, "TransactionNumber", trim(strOEORDH_To.ORDNUMBER), True)>
							<cfset structInsert(strSerialNumberAuditTrail_To, "CreationDate", "", True)>
							<cfset qryUser = objAdmin.getRecordAsQuery(SESSION.adminuserid)>
							<cfset structInsert(strSerialNumberAuditTrail_To, "UserFirstName", trim(qryUser.fname), True)>
							<cfset structInsert(strSerialNumberAuditTrail_To, "UserLastName", trim(qryUser.lname), True)>
							<cfset structInsert(strSerialNumberAuditTrail_To, "UserEmail", trim(qryUser.emailaddress), True)>
							<cfset structInsert(strSerialNumberAuditTrail_To, "ITEMNO", trim(Current_ITEM_From), True)>
							<cfset structInsert(strSerialNumberAuditTrail_To, "ITEMDESC", trim(getItemDescription(Current_ITEM_From)), True)>
							<cfset structInsert(strSerialNumberAuditTrail_To, "SerialNumber", trim(Current_SerialNumber), True)>
							<cfset structInsert(strSerialNumberAuditTrail_To, "AddorRemove", "Remove", True)>								
							<cfset structInsert(strSerialNumberAuditTrail_To, "LOCATION", trim(Current_LOCATION_To), True)>
							<cfset structInsert(strSerialNumberAuditTrail_To, "LOCATIONDESC", trim(getLocationDescription(Current_LOCATION_To)), True)>
							<cfset structInsert(strSerialNumberAuditTrail_To, "CUSTOMER", trim(strOEORDH_To.CUSTOMER), True)>
							<cfset structInsert(strSerialNumberAuditTrail_To, "BILNAME", trim(strOEORDH_To.BILNAME), True)>

							<cfset structInsert(strSerialNumberAuditTrail_To, "SerialTable", "tblSerialsShipments", True)>
							<cfset structInsert(strSerialNumberAuditTrail_To, "SerialTableIDField", "SerialsShipmentsID", True)>
							<cfset structInsert(strSerialNumberAuditTrail_To, "SerialTableIDValue", trim(NewSerialsShipmentsID_To), True)>
							<cfset objSerialNumberAuditTrail.saveRecord(strSerialNumberAuditTrail_To)>

							<cfset AtLeastOneSNApplied = 1>
															
						</cfif>
					</cfloop>
				</cfif>
			</cfif>
		</cfloop>
		
		<!--- Delete entires in tblBackOrder and tblBackOrderReceipts for the OLD order --->
		<cfif AtLeastOneSNApplied>
			<cfquery datasource="#This.DataSourceName#" name="qryBackOrder">
			SELECT	BackOrderID
			FROM 	tblBackOrder
			WHERE 	ORDUNIQ = '#Arguments.ORDUNIQ_From#'
			</cfquery>
			<cfloop query="qryBackOrder">
				<cfquery datasource="#This.DataSourceName#">
				DELETE FROM	tblBackOrderReceipts
				WHERE 	BackOrderID = '#qryBackOrder.BackOrderID#'
				</cfquery>
			</cfloop>
			<cfquery datasource="#This.DataSourceName#">
			DELETE FROM	tblBackOrder
			WHERE 	ORDUNIQ = '#Arguments.ORDUNIQ_From#'
			</cfquery>
		</cfif>
		
		<cfreturn AtLeastOneSNApplied>
	</cffunction>
		
	<cffunction name="replicate" access="public" returntype="struct" output="no">
	<cfargument name="Record" type="struct" required="Yes">
	<cfargument name="ReplicateQuantity" type="string" required="Yes">
		<cfset var stRecord = Arguments.Record>

		<cfif isNumeric(Arguments.ReplicateQuantity) AND Arguments.ReplicateQuantity GT 0>
		
			<cfif Arguments.ReplicateQuantity GT stRecord.RemainingQuantity>
				<cfset Arguments.ReplicateQuantity = stRecord.RemainingQuantity>
			</cfif>
		
			<cfif isDefined("stRecord.StartBoxNumber") AND isDefined("stRecord.EndBoxNumber")>
				<cfset SNIndex = int(stRecord.EndBoxNumber)>
				<cfset BaseIndex = int(stRecord.StartBoxNumber) - 1>
			<cfelse>
				<cfset SNIndex = int(stRecord.NumberOfBoxes)>
				<cfset BaseIndex = 0>
			</cfif>
			<cfset FieldValueToReplicate = "">
			<cfloop condition="#SNIndex# GT #BaseIndex#">
				<cfset FieldName = "SN_" & SNIndex>
				<cfset FieldValue = stRecord[FieldName]>
				<cfif trim(FieldValue) IS NOT "">
					<cfset StartingPoint = SNIndex + 1>				
					<cfset FieldValueToReplicate = FieldValue>
					<cfbreak>
				</cfif>
				<cfset SNIndex = SNIndex - 1>
			</cfloop>
			<cfif FieldValueToReplicate IS NOT "">
				<cfset EndingPoint = StartingPoint + Arguments.ReplicateQuantity - 2>
				<cfif StartingPoint LE EndingPoint>
					<cfloop index="LoopCount" from="#StartingPoint#" to="#EndingPoint#">
						<cfset structInsert(stRecord, "SN_#LoopCount#", FieldValueToReplicate, True)>
					</cfloop>
				</cfif>
			</cfif>				
		</cfif>
		<cfreturn stRecord>
	</cffunction>	

	<cffunction name="listOrphans" access="public" returntype="query" output="no">
	<cfargument name="StartDate" type="string" required="Yes">
	<cfargument name="EndDate" type="string" required="Yes">
		<cfset var qryOrphans = queryNew("SerialsShipmentsID,ORDUNIQ,ORDNUMBER,ORDLINENUM,ITEMNO,SerialNumber,PostedDate")>
		<cfset objOEORDD = createObject("component", "admin.assets.cfcs.OEORDD")>
		<cfset objSerialNumberAuditTrail = createObject("component", "admin.assets.cfcs.SerialNumberAuditTrail")>
		<cfset qrySerialsShipments = listRecordsForDateRange(Arguments.StartDate, Arguments.EndDate, "ORDNUMBER, ORDLINENUM, SerialNumber")>
		<cfloop query="qrySerialsShipments">
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "ORDUNIQ", qrySerialsShipments.ORDUNIQ, True)>
			<cfset structInsert(SearchRecord, "LINENUM", qrySerialsShipments.ORDLINENUM, True)>
			<cfset qryOEORDD = objOEORDD.searchRecords(SearchRecord, "query")>
			<cfif qryOEORDD.RecordCount EQ 0>

				<cfset ThisITEMNO = "[unknown]">
				<cfset SearchRecord = structNew()>
				<cfset structInsert(SearchRecord, "SerialTableIDValue", qrySerialsShipments.SerialsShipmentsID, True)>
				<cfset qrySerialNumberAuditTrail = objSerialNumberAuditTrail.searchRecords(SearchRecord, "query")>
				<cfif isDefined("qrySerialNumberAuditTrail.ITEMNO")>
					<cfset ThisITEMNO = qrySerialNumberAuditTrail.ITEMNO>
				</cfif>

				<cfset queryAddRow(qryOrphans)>
				<cfset querySetCell(qryOrphans, "SerialsShipmentsID", qrySerialsShipments.SerialsShipmentsID)>
				<cfset querySetCell(qryOrphans, "ORDUNIQ", qrySerialsShipments.ORDUNIQ)>
				<cfset querySetCell(qryOrphans, "ORDNUMBER", qrySerialsShipments.ORDNUMBER)>
				<cfset querySetCell(qryOrphans, "ORDLINENUM", qrySerialsShipments.ORDLINENUM)>
				<cfset querySetCell(qryOrphans, "ITEMNO", ThisITEMNO)>
				<cfset querySetCell(qryOrphans, "SerialNumber", qrySerialsShipments.SerialNumber)>
				<cfset querySetCell(qryOrphans, "PostedDate", qrySerialsShipments.PostedDate)>
			</cfif>
		</cfloop>
	
		<cfreturn qryOrphans>
	</cffunction>	

	<cffunction name="listOrphanedOrders" access="public" returntype="query" output="no">
	<cfargument name="qryOrphanedSerialNumbers" type="query" required="Yes">
		<cfset var qryOrphanedOrders = queryNew("ORDNUMBER,ITEMNO,SerialNumberCount,PostedDate")>
		<cfset qryOrphanedSNs = Arguments.qryOrphanedSerialNumbers>
		<cfset SavedORDNUMBER = "">
		<cfset SavedITEMNO = "">
		<cfset SavedORDNUMBER_ITEMNO = "">
		<cfset SNCount = 0>
		<cfset SNPostedDate = "">
		
		<cfloop query="qryOrphanedSNs">
			<cfset ThisORDNUMBER_ITEMNO = trim(qryOrphanedSNs.ORDNUMBER) & trim(qryOrphanedSNs.ITEMNO)>
			<cfif (SavedORDNUMBER_ITEMNO IS NOT ThisORDNUMBER_ITEMNO AND SavedORDNUMBER_ITEMNO IS NOT "")>
				<cfset queryAddRow(qryOrphanedOrders)>
				<cfset querySetCell(qryOrphanedOrders, "ORDNUMBER", SavedORDNUMBER)>
				<cfset querySetCell(qryOrphanedOrders, "ITEMNO", SavedITEMNO)>
				<cfset querySetCell(qryOrphanedOrders, "SerialNumberCount", SNCount)>
				<cfset querySetCell(qryOrphanedOrders, "PostedDate", SNPostedDate)>
				<cfset SNCount = 1>
			<cfelse>
				<cfset SNCount = SNCount + 1>
			</cfif>
			<cfset SavedORDNUMBER = trim(qryOrphanedSNs.ORDNUMBER)>
			<cfset SavedITEMNO = trim(qryOrphanedSNs.ITEMNO)>
			<cfset SavedORDNUMBER_ITEMNO = trim(qryOrphanedSNs.ORDNUMBER) & trim(qryOrphanedSNs.ITEMNO)>
			<cfset SNPostedDate = dateFormat(qryOrphanedSNs.PostedDate, 'mm/dd/yyyy')>
			<cfif qryOrphanedSNs.CurrentRow EQ qryOrphanedSNs.RecordCount>
				<cfset queryAddRow(qryOrphanedOrders)>
				<cfset querySetCell(qryOrphanedOrders, "ORDNUMBER", SavedORDNUMBER)>
				<cfset querySetCell(qryOrphanedOrders, "ITEMNO", SavedITEMNO)>
				<cfset querySetCell(qryOrphanedOrders, "SerialNumberCount", SNCount)>
				<cfset querySetCell(qryOrphanedOrders, "PostedDate", SNPostedDate)>
			</cfif>
		</cfloop>
		
		<cfreturn qryOrphanedOrders>
	</cffunction>	

	<cffunction name="listRecordsForDateRange" access="public" returntype="query" output="no">
	<cfargument name="StartDate" type="string" required="Yes">
	<cfargument name="EndDate" type="string" required="Yes">
	<cfargument name="OrderByList" type="string" required="Yes">
		<cfset var qryRecords = queryNew(This.ViewColumns)>
		<cfset StartDate = dateFormat(Arguments.StartDate, "yyyy-mm-dd 00:00:00.0")>
		<cfset EndDate = dateFormat(Arguments.EndDate, "yyyy-mm-dd 23:59:59.9")>
		<cfquery datasource="#This.DataSourceName#" name="qryRecords">
		SELECT 	#This.ViewColumns#
		FROM 	#This.ViewName#
		WHERE 	Posted = 1 AND
				PostedDate >= '#StartDate#' AND 
				PostedDate <= '#EndDate#'
		ORDER BY #Arguments.OrderByList#
		</cfquery>
		<cfreturn qryRecords>
	</cffunction>	

	<cffunction name="validateOrphanDates" access="public" returntype="struct" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
		<cfif validateDate(Arguments.Record.StartDate) EQ 0>
			<cfset structInsert(stErrors, "StartDate", "Please enter a valid Start Date as mm/dd/yyyy", True)>
		</cfif>
		<cfif validateDate(Arguments.Record.EndDate) EQ 0>
			<cfset structInsert(stErrors, "EndDate", "Please enter a valid End Date as mm/dd/yyyy", True)>
		</cfif>
		<cfif structIsEmpty(stErrors) AND dateCompare(Arguments.Record.StartDate, Arguments.Record.EndDate) EQ 1>
			<cfset structInsert(stErrors, "StartDate", "Start Date must be before End Date", True)>
		</cfif>
		<cfreturn stErrors>
	</cffunction>

	<cffunction name="validate_Export" access="public" returntype="struct" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
		<cfset objICITEM = createObject("component", "admin.assets.cfcs.ICITEM")>
		<cfif trim(Arguments.Record.BeginningDate) IS NOT "" AND validateDate(Arguments.Record.BeginningDate) EQ 0>
			<cfset structInsert(stErrors, "BeginningDate", "Please enter a valid Beginning Date as mm/dd/yyyy", True)>
		</cfif>
		<cfif trim(Arguments.Record.EndingDate) IS NOT "" AND validateDate(Arguments.Record.EndingDate) EQ 0>
			<cfset structInsert(stErrors, "EndingDate", "Please enter a valid Ending Date as mm/dd/yyyy", True)>
		</cfif>
		<cfif structIsEmpty(stErrors) AND 
			  trim(Arguments.Record.BeginningDate) IS NOT "" AND
			  trim(Arguments.Record.EndingDate) IS NOT "" AND
			  dateCompare(Arguments.Record.BeginningDate, Arguments.Record.EndingDate) EQ 1>
			<cfset structInsert(stErrors, "BeginningDate", "Beginning Date must be before Ending Date", True)>
		</cfif>
		<cfif trim(Arguments.Record.ITEMNO1) IS "" AND trim(Arguments.Record.ITEMNO2) IS "">
			<cfset structInsert(stErrors, "ITEMNO1", "Please enter at least one part number", True)>
		<cfelse>
			<cfif trim(Arguments.Record.ITEMNO1) IS NOT "">
				<cfset SearchRecord = structNew()>
				<cfset structInsert(SearchRecord, "ITEMNO", trim(Arguments.Record.ITEMNO1), True)>
				<cfset qryICITEM = objICITEM.searchRecords(SearchRecord, "query")>
				<cfif qryICITEM.RecordCount EQ 0>
					<cfset structInsert(stErrors, "ITEMNO1", "This part number was not found in ACCPAC", True)>
				</cfif>
			</cfif>
			<cfif trim(Arguments.Record.ITEMNO2) IS NOT "">
				<cfset SearchRecord = structNew()>
				<cfset structInsert(SearchRecord, "ITEMNO", trim(Arguments.Record.ITEMNO2), True)>
				<cfset qryICITEM = objICITEM.searchRecords(SearchRecord, "query")>
				<cfif qryICITEM.RecordCount EQ 0>
					<cfset structInsert(stErrors, "ITEMNO2", "This part number was not found in ACCPAC", True)>
				</cfif>
			</cfif>
		</cfif>
		<cfreturn stErrors>
	</cffunction>
	
	<cffunction name="findSerialNumbersForExport" access="public" returntype="query" output="no">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var qrySerialNumbers = queryNew("SerialNumber")>
		<cfset objOEORDH = createObject("component", "admin.assets.cfcs.OEORDH")>
		<cfset objOEORDD = createObject("component", "admin.assets.cfcs.OEORDD")>
		<cfset objBackOrder = createObject("component", "admin.assets.cfcs.BackOrder")>
		<cfset BeginningDate = "">
		<cfset EndingDate = "">
		<cfif trim(Arguments.Record.BeginningDate) IS NOT "">
			<cfset BeginningDate = formatDateToInteger(Arguments.Record.BeginningDate)>
		</cfif>
		<cfif trim(Arguments.Record.EndingDate) IS NOT "">
			<cfset EndingDate = formatDateToInteger(Arguments.Record.EndingDate)>
		</cfif>

		<!--- Get orders in ACCPAC that fall in this date range --->
		<cfset qryOEORDH = objOEORDH.getOrdersByDateRange(BeginningDate, EndingDate)>
		<cfloop query="qryOEORDH">
			<cfset CURRENT_ORDUNIQ = qryOEORDH.ORDUNIQ>
			<!--- Look only at orders that are Comp Builds --->
			<cfif objBackOrder.isCompBuild(CURRENT_ORDUNIQ)>
				<!--- Get lines for this order that match the item numbers --->
				<cfset qryOEORDD = objOEORDD.getLinesForItems(CURRENT_ORDUNIQ,Arguments.Record.ITEMNO1,Arguments.Record.ITEMNO2)>
<!---qryOEORDD.ORDUNIQ:#qryOEORDD.ORDUNIQ#<br>--->
				<cfloop query="qryOEORDD">
					<cfset SearchRecord = structNew()>
					<cfset structInsert(SearchRecord, "ORDUNIQ", CURRENT_ORDUNIQ, True)>
					<cfset structInsert(SearchRecord, "ORDLINENUM", qryOEORDD.LINENUM, True)>
					<cfset qrySerialsShipments = searchRecords(SearchRecord, "query")>
					<cfloop query="qrySerialsShipments">
						<cfset queryAddRow(qrySerialNumbers)>
						<cfset querySetCell(qrySerialNumbers, "SerialNumber", qrySerialsShipments.SerialNumber)>					
					</cfloop>
				</cfloop>
			</cfif>
		</cfloop>
		<cfreturn qrySerialNumbers>
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

	<cffunction name="customerSalesReport" access="public" returntype="query" output="no">
	<cfargument name="BeginningDate" type="string" required="Yes">
	<cfargument name="EndingDate" type="string" required="Yes">
	<cfargument name="BeginningItem" type="string" required="Yes">
	<cfargument name="EndingItem" type="string" required="Yes">
		<cfset var qryFinal = queryNew("SalesRep,INVUNIQ,CUSTOMER,SHPNAME,SHPADDR1,SHPADDR2,SHPADDR3,SHPADDR4,SHPCITY,SHPSTATE,SHPZIP,INVNUMBER,INVDATE,LINENUM,ITEM,QTYSHIPPED,UNITPRICE,NAMEEMPL,SerialNumbers")>
		<cfset var qryRecords = queryNew("SalesRep,INVUNIQ,CUSTOMER,SHPNAME,SHPADDR1,SHPADDR2,SHPADDR3,SHPADDR4,SHPCITY,SHPSTATE,SHPZIP,INVNUMBER,INVDATE,LINENUM,ITEM,QTYSHIPPED,UNITPRICE,NAMEEMPL,SerialNumbers")>
		<cfset var qryLogin = queryNew("SalesRepID")>
		<cfset var qrySalesRep = queryNew("repname")>
		<cfset var qrySerialsShipments = queryNew("SerialNumber")>
		<cfset var SerialNumberList = "">
		
		<cfset Arguments.BeginningDate = formatDateToInteger(Arguments.BeginningDate)>
		<cfset Arguments.EndingDate = formatDateToInteger(Arguments.EndingDate)>
		<cfset Arguments.BeginningItem = trim(Arguments.BeginningItem)>
		<cfset Arguments.EndingItem = trim(Arguments.EndingItem)>

<!---
		<cfquery datasource="#APPLICATION.DSN_AP#" name="qryRecords">
		SELECT	dbo.OEINVH.INVUNIQ, dbo.OEINVH.CUSTOMER, dbo.OEINVH.SHPNAME, dbo.OEINVH.SHPADDR1, dbo.OEINVH.SHPADDR2, 
				dbo.OEINVH.SHPADDR3, dbo.OEINVH.SHPADDR4, dbo.OEINVH.SHPCITY, dbo.OEINVH.SHPSTATE, dbo.OEINVH.SHPZIP, 
				dbo.OEINVH.INVNUMBER, dbo.OEINVH.INVDATE, dbo.OEINVD.LINENUM, dbo.OEINVD.ITEM, dbo.OEINVD.QTYSHIPPED, 
				dbo.OEINVD.UNITPRICE
		FROM	dbo.OEINVH INNER JOIN
				dbo.OEINVD ON dbo.OEINVH.INVUNIQ = dbo.OEINVD.INVUNIQ
		WHERE   (dbo.OEINVD.QTYSHIPPED > 0) AND
				(dbo.OEINVH.INVDATE >= #Arguments.BeginningDate#) AND 
				(dbo.OEINVH.INVDATE <= #Arguments.EndingDate#) 				
				<cfif Arguments.EndingItem IS "">
					AND (dbo.OEINVD.ITEM LIKE '#Arguments.BeginningItem#%')
				<cfelse>
					AND (dbo.OEINVD.ITEM >= '#Arguments.BeginningItem#')
					AND (dbo.OEINVD.ITEM <= '#Arguments.EndingItem#')
				</cfif>
		</cfquery>
--->
		<cfquery datasource="#APPLICATION.DSN_AP#" name="qryRecords">
		SELECT	dbo.OEINVH.INVUNIQ, dbo.OEINVH.CUSTOMER, dbo.OEINVH.SHPNAME, dbo.OEINVH.SHPADDR1, dbo.OEINVH.SHPADDR2, 
				dbo.OEINVH.SHPADDR3, dbo.OEINVH.SHPADDR4, dbo.OEINVH.SHPCITY, dbo.OEINVH.SHPSTATE, dbo.OEINVH.SHPZIP, 
				dbo.OEINVH.INVNUMBER, dbo.OEINVH.INVDATE, dbo.OEINVD.LINENUM, dbo.OEINVD.ITEM, dbo.OEINVD.QTYSHIPPED, 
				dbo.OEINVD.UNITPRICE, dbo.ARSAP.NAMEEMPL AS SalesRep
		FROM	dbo.OEINVH 
				INNER JOIN dbo.OEINVD ON dbo.OEINVH.INVUNIQ = dbo.OEINVD.INVUNIQ
				INNER JOIN dbo.ARCUS ON dbo.OEINVH.CUSTOMER = dbo.ARCUS.IDCUST 
				INNER JOIN dbo.ARSAP ON dbo.ARCUS.CODESLSP1 = dbo.ARSAP.CODESLSP
		WHERE   (dbo.OEINVD.QTYSHIPPED > 0) AND
				(dbo.OEINVH.INVDATE >= #Arguments.BeginningDate#) AND 
				(dbo.OEINVH.INVDATE <= #Arguments.EndingDate#) 				
				<cfif Arguments.EndingItem IS "">
					AND (dbo.OEINVD.ITEM LIKE '#Arguments.BeginningItem#%')
				<cfelse>
					AND (dbo.OEINVD.ITEM >= '#Arguments.BeginningItem#')
					AND (dbo.OEINVD.ITEM <= '#Arguments.EndingItem#')
				</cfif>
		ORDER BY dbo.ARSAP.NAMEEMPL, dbo.OEINVH.CUSTOMER, dbo.OEINVD.ITEM				
		</cfquery>

		<cfset SerialNumberArray = ArrayNew(1)>
<!---	<cfset queryAddColumn(qryRecords, "SalesRep", SerialNumberArray)>	--->
		<cfset queryAddColumn(qryRecords, "SerialNumbers", SerialNumberArray)>

		<cfloop query="qryRecords">
<!---
			<!--- Add Sales Rep --->
			<cfquery datasource="#This.DataSourceName#" name="qryARCUS">
			SELECT	SalesRepID
			FROM	login
			WHERE	acctno = '#qryRecords.CUSTOMER#'
			</cfquery>
			
			<cfquery datasource="#This.DataSourceName#" name="qryLogin">
			SELECT	SalesRepID
			FROM	login
			WHERE	acctno = '#qryRecords.CUSTOMER#'
			</cfquery>
			<cfif qryLogin.RecordCount EQ 0>
				<cfset querySetCell(qryRecords, "SalesRep", "", qryRecords.CurrentRow)>
			<cfelse>
				<cfquery datasource="#This.DataSourceName#" name="qrySalesRep">
				SELECT	repname
				FROM	salesrep
				WHERE	ID = '#qryLogin.SalesRepID#'
				</cfquery>
				<cfif qrySalesRep.RecordCount EQ 0>
					<cfset querySetCell(qryRecords, "SalesRep", "", qryRecords.CurrentRow)>
				<cfelse>
					<cfset querySetCell(qryRecords, "SalesRep", qrySalesRep.repname, qryRecords.CurrentRow)>			
				</cfif>
			</cfif>
--->

			<!--- Add Serial Numbers --->
			<cfquery datasource="#This.DataSourceName#" name="qrySerialsShipments">
			SELECT	SerialNumber
			FROM	tblSerialsShipments
			WHERE	AttachedToInvoice = 1 AND
					INVUNIQ = '#qryRecords.INVUNIQ#' AND
					INVLINENUM = '#qryRecords.LINENUM#'
			</cfquery>
			<cfif qrySerialsShipments.RecordCount EQ 0>
				<cfset querySetCell(qryRecords, "SerialNumbers", "", qryRecords.CurrentRow)>
			<cfelse>
				<cfset SerialNumberList = "">
				<cfloop query="qrySerialsShipments">
					<cfset SerialNumberList = listAppend(SerialNumberList, qrySerialsShipments.SerialNumber)>
				</cfloop>
				<cfset querySetCell(qryRecords, "SerialNumbers", SerialNumberList, qryRecords.CurrentRow)>			
			</cfif>
		</cfloop>
<!---		
		<cfquery dbtype="query" name="qryFinal">
		SELECT	*
		FROM	qryRecords
		WHERE	SalesRep <> '' 				
		ORDER BY SalesRep, CUSTOMER, ITEM
		</cfquery>
--->
		<cfreturn qryRecords>
	</cffunction>



	<cffunction name="intelSalesReport" access="public" returntype="query" output="no">
	<cfargument name="BeginningDate" type="string" required="Yes">
	<cfargument name="EndingDate" type="string" required="Yes">
	<cfargument name="BeginningItem1" type="string" required="Yes">
	<cfargument name="EndingItem1" type="string" required="Yes">
	<cfargument name="BeginningItem2" type="string" required="Yes">
	<cfargument name="EndingItem2" type="string" required="Yes">
	<cfargument name="BeginningItem3" type="string" required="Yes">
	<cfargument name="EndingItem3" type="string" required="Yes">
	<cfargument name="BeginningItem4" type="string" required="Yes">
	<cfargument name="EndingItem4" type="string" required="Yes">
		<cfset var qryRecords = queryNew("SalesRep,INVUNIQ,CUSTOMER,SHPNAME,SHPADDR1,SHPADDR2,SHPADDR3,SHPADDR4,SHPCITY,SHPSTATE,SHPZIP,INVNUMBER,INVDATE,LINENUM,ITEM,QTYSHIPPED,UNITPRICE,NAMEEMPL,SerialNumbers")>
		<cfset var qryLogin = queryNew("SalesRepID")>
		
		<cfset Arguments.BeginningDate = formatDateToInteger(Arguments.BeginningDate)>
		<cfset Arguments.EndingDate = formatDateToInteger(Arguments.EndingDate)>
		<cfset Arguments.BeginningItem1 = trim(Arguments.BeginningItem1)>
		<cfset Arguments.EndingItem1 = trim(Arguments.EndingItem1)>
		<cfset Arguments.BeginningItem2 = trim(Arguments.BeginningItem2)>
		<cfset Arguments.EndingItem2 = trim(Arguments.EndingItem2)>
		<cfset Arguments.BeginningItem3 = trim(Arguments.BeginningItem3)>
		<cfset Arguments.EndingItem3 = trim(Arguments.EndingItem3)>
		<cfset Arguments.BeginningItem4 = trim(Arguments.BeginningItem4)>
		<cfset Arguments.EndingItem4 = trim(Arguments.EndingItem4)>

		<cfquery datasource="#APPLICATION.DSN_AP#" name="qryRecords">
		SELECT	dbo.OEINVH.INVDATE, dbo.OEINVH.CUSTOMER, dbo.OEINVH.INVNUMBER,
				dbo.OEINVH.BILNAME, dbo.OEINVH.BILADDR1, dbo.OEINVH.BILADDR2, 
				dbo.OEINVH.BILADDR3, dbo.OEINVH.BILADDR4, dbo.OEINVH.BILCITY, dbo.OEINVH.BILSTATE, dbo.OEINVH.BILZIP,				
				dbo.ARCUS.TEXTPHON1 AS PhoneNumber,
				dbo.OEINVD.ITEM, dbo.OEINVD.QTYSHIPPED, dbo.OEINVD.UNITPRICE
		FROM	dbo.OEINVH 
				INNER JOIN dbo.OEINVD ON dbo.OEINVH.INVUNIQ = dbo.OEINVD.INVUNIQ
				INNER JOIN dbo.ARCUS ON dbo.OEINVH.CUSTOMER = dbo.ARCUS.IDCUST 
		WHERE   (dbo.OEINVD.QTYSHIPPED > 0) AND
				(dbo.OEINVH.INVDATE >= #Arguments.BeginningDate#) AND 
				(dbo.OEINVH.INVDATE <= #Arguments.EndingDate#) AND (
				<cfif Arguments.BeginningItem1 IS NOT "" AND Arguments.EndingItem1 IS "">
						(dbo.OEINVD.ITEM LIKE '#Arguments.BeginningItem1#%')
				<cfelseif Arguments.BeginningItem1 IS NOT "" AND Arguments.EndingItem1 IS NOT "">
					    (dbo.OEINVD.ITEM >= '#Arguments.BeginningItem1#' AND dbo.OEINVD.ITEM <= '#Arguments.EndingItem1#')
				</cfif>
				<cfif Arguments.BeginningItem2 IS NOT "" AND Arguments.EndingItem2 IS "">
					 OR (dbo.OEINVD.ITEM LIKE '#Arguments.BeginningItem2#%')
				<cfelseif Arguments.BeginningItem2 IS NOT "" AND Arguments.EndingItem2 IS NOT "">
					 OR (dbo.OEINVD.ITEM >= '#Arguments.BeginningItem2#' AND dbo.OEINVD.ITEM <= '#Arguments.EndingItem2#')
				</cfif>
				<cfif Arguments.BeginningItem3 IS NOT "" AND Arguments.EndingItem3 IS "">
					 OR (dbo.OEINVD.ITEM LIKE '#Arguments.BeginningItem3#%')
				<cfelseif Arguments.BeginningItem3 IS NOT "" AND Arguments.EndingItem3 IS NOT "">
					 OR (dbo.OEINVD.ITEM >= '#Arguments.BeginningItem3#' AND dbo.OEINVD.ITEM <= '#Arguments.EndingItem3#')
				</cfif>
				<cfif Arguments.BeginningItem4 IS NOT "" AND Arguments.EndingItem4 IS "">
					 OR (dbo.OEINVD.ITEM LIKE '#Arguments.BeginningItem4#%')
				<cfelseif Arguments.BeginningItem4 IS NOT "" AND Arguments.EndingItem4 IS NOT "">
					 OR (dbo.OEINVD.ITEM >= '#Arguments.BeginningItem4#' AND dbo.OEINVD.ITEM <= '#Arguments.EndingItem4#')
				</cfif>
				)
		ORDER BY dbo.OEINVH.INVDATE	
		</cfquery>

		<cfset IntelIDNumberArray = ArrayNew(1)>
		<cfset queryAddColumn(qryRecords, "IntelIDNumber", IntelIDNumberArray)>
<!---
		<cfset PhoneNumberArray = ArrayNew(1)>
		<cfset queryAddColumn(qryRecords, "PhoneNumber", PhoneNumberArray)>
--->
		<cfloop query="qryRecords">
			<cfset querySetCell(qryRecords, "IntelIDNumber", "", qryRecords.CurrentRow)>
<!---		<cfset querySetCell(qryRecords, "PhoneNumber", "", qryRecords.CurrentRow)>	--->

			<!--- Add IntelIDNumber, PhoneNumber --->
			<cfquery datasource="#This.DataSourceName#" name="qryLogin">
			SELECT	IntelIDNumber
			FROM	login
			WHERE	acctno = '#qryRecords.CUSTOMER#'
			</cfquery>
<!---
			<cfif qryLogin.RecordCount EQ 0>
				<cfset querySetCell(qryRecords, "IntelIDNumber", "", qryRecords.CurrentRow)>
				<cfset querySetCell(qryRecords, "PhoneNumber", "", qryRecords.CurrentRow)>
			<cfelse>
--->			
				<cfloop query="qryLogin">
					<cfif trim(qryLogin.IntelIDNumber) IS NOT "">
						<cfset querySetCell(qryRecords, "IntelIDNumber", qryLogin.IntelIDNumber, qryRecords.CurrentRow)>
						<cfbreak>
					</cfif>
<!---					
					<cfif trim(qryLogin.PhoneNumber) IS NOT "">
						<cfset querySetCell(qryRecords, "PhoneNumber", qryLogin.PhoneNumber, qryRecords.CurrentRow)>			
					</cfif>
--->
				</cfloop>
				
<!---		</cfif>--->
			
			
		</cfloop>
		<cfreturn qryRecords>
	</cffunction>
		
	<cffunction name="microsoftSkuReport" access="public" returntype="query" output="no">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var qryRecords = queryNew("")>
		<cfset var RecordList = "">
		<cfset var BeginDate = 0>
		<cfset var EndDate = 0>
		<cfset BeginDate = formatDateToInteger(Arguments.Record.BeginningDate)>
		<cfset EndDate = formatDateToInteger(Arguments.Record.EndingDate)>
		<cfset RecordList = structKeyList(Arguments.Record)>
		<cfquery datasource="#APPLICATION.DSN_AP#" name="qryRecords">
		SELECT	dbo.OEINVH.INVUNIQ, dbo.OEINVH.CUSTOMER, dbo.OEINVH.SHPNAME, dbo.OEINVH.SHPADDR1, dbo.OEINVH.SHPADDR2, 
				dbo.OEINVH.SHPADDR3, dbo.OEINVH.SHPADDR4, dbo.OEINVH.SHPCITY, dbo.OEINVH.SHPSTATE, dbo.OEINVH.SHPZIP, 
				dbo.OEINVH.INVNUMBER, dbo.OEINVH.INVDATE, dbo.OEINVD.LINENUM, dbo.OEINVD.ITEM, dbo.OEINVD.[DESC], 
				dbo.OEINVD.QTYSHIPPED, dbo.OEINVD.UNITPRICE, dbo.ARSAP.NAMEEMPL AS SalesRep
		FROM	dbo.OEINVH 
				INNER JOIN dbo.OEINVD ON dbo.OEINVH.INVUNIQ = dbo.OEINVD.INVUNIQ
				INNER JOIN dbo.ARCUS ON dbo.OEINVH.CUSTOMER = dbo.ARCUS.IDCUST 
				INNER JOIN dbo.ARSAP ON dbo.ARCUS.CODESLSP1 = dbo.ARSAP.CODESLSP
		WHERE   (dbo.OEINVD.QTYSHIPPED > 0) AND
				(dbo.OEINVH.INVDATE >= #BeginDate#) AND 
				(dbo.OEINVH.INVDATE <= #EndDate#) AND 
				(
					dbo.OEINVD.ITEM = '#trim(Arguments.Record.ITEM1)#'
						<cfloop list="#RecordList#" index="Column">
							<cfif findNoCase('ITEM', Column) NEQ 0 AND 
								  Column IS NOT "ITEM1" AND
								  trim(Arguments.Record[Column]) IS NOT "">
								OR dbo.OEINVD.ITEM = '#trim(Arguments.Record[Column])#'
							</cfif>
						</cfloop>
				)
		ORDER BY dbo.ARSAP.NAMEEMPL, dbo.OEINVH.CUSTOMER, dbo.OEINVD.ITEM	
		</cfquery>
		
		<cfreturn qryRecords>
	</cffunction>

	<cffunction name="validate_Spiff" access="public" returntype="struct" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
		<cfif trim(Arguments.Record.BeginningDate) IS NOT "" AND validateDate(Arguments.Record.BeginningDate) EQ 0>
			<cfset structInsert(stErrors, "BeginningDate", "Please enter a valid Beginning Date as mm/dd/yyyy", True)>
		</cfif>
		<cfif trim(Arguments.Record.EndingDate) IS NOT "" AND validateDate(Arguments.Record.EndingDate) EQ 0>
			<cfset structInsert(stErrors, "EndingDate", "Please enter a valid Ending Date as mm/dd/yyyy", True)>
		</cfif>
		<cfif structIsEmpty(stErrors) AND 
			  trim(Arguments.Record.BeginningDate) IS NOT "" AND
			  trim(Arguments.Record.EndingDate) IS NOT "" AND
			  dateCompare(Arguments.Record.BeginningDate, Arguments.Record.EndingDate) EQ 1>
			<cfset structInsert(stErrors, "BeginningDate", "Beginning Date must be before Ending Date", True)>
		</cfif>
		<cfif trim(Arguments.Record.SpiffPercentage) IS "">
			<cfset structInsert(stErrors, "SpiffPercentage", "Please enter the spiff percentage", True)>
		<cfelseif NOT isNumeric(Arguments.Record.SpiffPercentage)>
			<cfset structInsert(stErrors, "SpiffPercentage", "Please enter a number for the spiff percentage", True)>
		</cfif>
		<cfif trim(Arguments.Record.EmailAddress) IS "" OR validateEmail(Arguments.Record.EmailAddress) EQ 0>
			<cfset structInsert(stErrors, "EmailAddress", "Please enter a valid email address to send the report to", True)>
		</cfif>
		<cfreturn stErrors>
	</cffunction>

	<cffunction name="emailSpiffReport" access="public" output="no">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var BeginDate = "">
		<cfset var EndDate = "">
		<cfset var qryCloseoutItems = queryNew("")>
		<cfset var qryOrders = queryNew("")>
		<cfset var qrySpiffs = queryNew("SalesRep,ITEM,INVNUMBER,QTYSHIPPED,UNITPRICE")>
		<cfset var qryFinal = queryNew("SalesRep,ITEM,INVNUMBER,QTYSHIPPED,UNITPRICE")>
		<cfset var SavedSalesRep = "">
		<cfset var Spiff = 0>
		<cfset var SpiffTotal = 0>
		
		<cfset objOEORDH = createObject("component", "admin.assets.cfcs.OEORDH")>
		<cfset objOEORDD = createObject("component", "admin.assets.cfcs.OEORDD")>
		<cfset objBackOrder = createObject("component", "admin.assets.cfcs.BackOrder")>
		
		<cfif trim(Arguments.Record.BeginningDate) IS NOT "">
			<cfset BeginDate = formatDateToInteger(Arguments.Record.BeginningDate)>
		</cfif>
		<cfif trim(Arguments.Record.EndingDate) IS NOT "">
			<cfset EndDate = formatDateToInteger(Arguments.Record.EndingDate)>
		</cfif>
		
		<!--- Get all close out items --->
		<cfquery datasource="#This.DataSourceName#" name="qryCloseoutItems">
		SELECT	*
		FROM	tblPartsAdmin

		WHERE 	GarageSale = 1

<!--- TEMP 10/07/2011 --->
<!---
		WHERE	GarageSale = 1 OR
        		(GarageSale = 0 AND Inactive = 1)
--->
		ORDER BY ITEMNO
		</cfquery>	

		<cfloop query="qryCloseoutItems">

			<cfquery datasource="#APPLICATION.DSN_AP#" name="qryOrders">
			SELECT	dbo.ARSAP.NAMEEMPL AS SalesRep, dbo.OEINVD.ITEM, dbo.OEINVD.[DESC], dbo.OEINVH.INVNUMBER,
					dbo.OEINVD.QTYSHIPPED, dbo.OEINVD.UNITPRICE
			FROM	dbo.OEINVH 
					INNER JOIN dbo.OEINVD ON dbo.OEINVH.INVUNIQ = dbo.OEINVD.INVUNIQ
					INNER JOIN dbo.ARCUS ON dbo.OEINVH.CUSTOMER = dbo.ARCUS.IDCUST 
					INNER JOIN dbo.ARSAP ON dbo.ARCUS.CODESLSP1 = dbo.ARSAP.CODESLSP
			WHERE   (dbo.OEINVD.QTYSHIPPED > 0) AND 
					(dbo.OEINVD.ITEM = '#trim(qryCloseoutItems.ITEMNO)#')
					<cfif BeginDate IS NOT "">
						AND (dbo.OEINVH.INVDATE >= #BeginDate#) 
					</cfif>
					<cfif EndDate IS NOT "">
						AND (dbo.OEINVH.INVDATE <= #EndDate#) 
					</cfif>
			ORDER BY dbo.ARSAP.NAMEEMPL, dbo.OEINVD.ITEM	
			</cfquery>

			<cfloop query="qryOrders">
				<cfset queryAddRow(qrySpiffs)>
				<cfset querySetCell(qrySpiffs, "SalesRep", qryOrders.SalesRep)>
				<cfset querySetCell(qrySpiffs, "ITEM", qryOrders.ITEM)>
				<cfset querySetCell(qrySpiffs, "INVNUMBER", qryOrders.INVNUMBER)>
				<cfset querySetCell(qrySpiffs, "QTYSHIPPED", qryOrders.QTYSHIPPED)>
				<cfset querySetCell(qrySpiffs, "UNITPRICE", qryOrders.UNITPRICE)>
			</cfloop>

		</cfloop>

		<cfquery dbtype="query" name="qryFinal">
		SELECT	*
		FROM	qrySpiffs
		ORDER BY SalesRep, ITEM, INVNUMBER
		</cfquery>

		<cfmail from=	"Nor-Tech<info@nor-tech.com>" 
				to=		"#trim(Arguments.Record.EmailAddress)#" 
				replyto="#trim(Arguments.Record.EmailAddress)#" 
				subject="Close-Out Specials (Spiff) Report"
				type=	"html"
				timeout="60">
		<html>
		<head>
			<style type="text/css">
				BODY	{font-family:Arial, Helvetica, sans-serif; font-size:12px;}
				TD		{font-family:Arial, Helvetica, sans-serif; font-size:12px;}
			</style>
		</head>
		<body>
		
			<table width="90%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td height="18" style="font-size:14px; font-weight:bold;" colspan="2">
						Close-Out Specials (Spiff) Report
					</td>
					<td height="18" style="font-size:14px; font-weight:bold;" align="right" colspan="5">
						Report Date: #dateFormat(now(), 'mmmm d, yyyy')#
					</td>
				</tr>
				<!--- Header --->
				<tr>
					<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF">Sales Rep</td>
					<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF">Item Number</td>
					<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF">Invoice Number</font></td>
					<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" align="center">Quantity Sold</font></td>
					<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" align="right">Item Price</font></td>
					<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" align="right">Total Price</font></td>
					<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" align="right">Spiff</font></td>
				</tr>

				<!--- Data --->
				<cfif qryFinal.RecordCount EQ 0>
					<tr>
						<td align="center" colspan="7" style="font-size:12px; font-weight:bold; color:FF0000">
							No items were found matching your selection criteria.
						</td>
					</tr>
				</cfif>

				<cfset SavedSalesRep = "">			
				<cfset Spiff = 0>	
				<cfset SpiffTotal = 0>	
				<cfloop query="qryFinal">
					<!--- Sales Rep Total --->
					<cfif SavedSalesRep IS NOT "" AND SavedSalesRep IS NOT qryFinal.SalesRep>
						<tr style="background-color:##e5e5e6">
							<td style="font-size:10px" colspan="5">&nbsp;</td>
							<td style="font-size:10px">Total:</td>
							<td style="font-size:10px"  align="right">#dollarFormat(SpiffTotal)#</td>
						</tr>
						<cfset SpiffTotal = 0>	
					</cfif>
					<cfset SavedSalesRep = qryFinal.SalesRep>				
					<cfset Spiff = qryFinal.QTYSHIPPED * qryFinal.UNITPRICE * Arguments.Record.SpiffPercentage / 100>
				
					<tr>
						<!--- SALES REP --->
						<td style="font-size:10px">#qryFinal.SalesRep#</td>
						<!--- ITEM NUMBER --->
						<td style="font-size:10px">#qryFinal.ITEM#</td>
						<!--- INVOICE NUMBER --->
						<td style="font-size:10px">#qryFinal.INVNUMBER#</td>
						<!--- QUANTITY --->
						<td style="font-size:10px" align="center">#int(qryFinal.QTYSHIPPED)#</td>
						<!--- ITEM PRICE --->
						<td style="font-size:10px" align="right">#dollarFormat(qryFinal.UNITPRICE)#</td>
						<!--- TOTAL PRICE --->
						<td style="font-size:10px" align="right">#dollarFormat(qryFinal.QTYSHIPPED * qryFinal.UNITPRICE)#</td>
						<!--- SPIFF --->
						<td style="font-size:10px" align="right">#dollarFormat(Spiff)#</td>
					</tr>
					<cfset SpiffTotal = SpiffTotal + Spiff>	

					<cfif qryFinal.CurrentRow EQ qryFinal.RecordCount>
						<tr style="background-color:##e5e5e6">
							<td style="font-size:10px" colspan="5">&nbsp;</td>
							<td style="font-size:10px">Total:</td>
							<td style="font-size:10px"  align="right">#dollarFormat(SpiffTotal)#</td>
						</tr>
					</cfif>
					
				</cfloop>
			</table>
		</body>
		</html>	
		</cfmail>
	</cffunction>

	<cffunction name="getRemainingQuantity" access="public" returntype="numeric" output="No">
	<cfargument name="ORDUNIQ" type="string" required="Yes">
	<cfargument name="LINENUM" type="string" required="Yes">
		<cfset var RemainingQuantity = 0>
        <cfset var SearchRecord = structNew()>
        <cfset var qryDetail = queryNew("")>
        <cfset var qryPostedSNs = queryNew("")>
        
		<cfset objOEORDD = createObject("component", "admin.assets.cfcs.OEORDD")>
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ORDUNIQ", Arguments.ORDUNIQ, True)>
		<cfset structInsert(SearchRecord, "LINENUM", Arguments.LINENUM, True)>
		<cfset qryDetail = objOEORDD.searchRecords(SearchRecord, "query")>

		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ORDUNIQ", Arguments.ORDUNIQ, True)>
		<cfset structInsert(SearchRecord, "ORDLINENUM", Arguments.LINENUM, True)>
		<cfset structInsert(SearchRecord, "Posted", 1, True)>
		<cfset qryPostedSNs = searchRecords(SearchRecord, "query")>
		<cfset RemainingQuantity = (qryDetail.QTYORDERED + qryDetail.QTYSHPTODT) - qryPostedSNs.RecordCount>
		<cfreturn RemainingQuantity>
	</cffunction>
			
</cfcomponent>