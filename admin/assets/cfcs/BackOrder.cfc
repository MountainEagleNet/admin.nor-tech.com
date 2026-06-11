<cfcomponent extends="admin.assets.cfcs.Component">

	<cfif isDefined("APPLICATION.DSN_WWW")>
		<cfset This.DataSourceName = APPLICATION.DSN_WWW>
	<cfelse>
		<cfset This.DataSourceName = "NorTechWWW">
	</cfif>
	
	<cfif isDefined("APPLICATION.DSN_AP")>
		<cfset This.ACCPACDataSourceName = APPLICATION.DSN_AP>
	<cfelse>
		<cfset This.ACCPACDataSourceName = "NorTechAP">
	</cfif>
	
	<cfif isDefined("APPLICATION.AdminLocation")>
		<cfset CURRENT_AdminLocation = APPLICATION.AdminLocation>
	<cfelse>
		<cfset CURRENT_AdminLocation = "admin">
	</cfif>

	<cfset This.Columns = "BackOrderID,ORDUNIQ,LINENUM,ORDNUMBER,CUSTOMER,BILNAME,ORDDATE,ITEMNO,ITEMDESC,SalesRepID,QuantityBackordered,OrderQuantity,EarliestSNDate,DateReported">
	<cfset This.ViewColumns = "BackOrderID,ORDUNIQ,LINENUM,ORDNUMBER,CUSTOMER,BILNAME,ORDDATE,ITEMNO,ITEMDESC,SalesRepID,QuantityBackordered,OrderQuantity,EarliestSNDate,DateReported,QuantityReceived,QuantityRemaining,QuantitySNs">
	
	<cfset This.TableName = "tblBackOrder">
	<cfset This.ViewName = "vBackOrder">
	
	<cfset This.PrimaryKey = "BackOrderID">
	<cfset This.ForeignHeaderKey = "">
	<cfset This.ForeignDetailKey = "">
	
	<cfset This.ITEMNOKey = "">	

	<cfset This.GenerateUUIDKey = 1>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "ORDNUMBER">
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

	<cffunction name="findBackOrderItems" access="public" output="no">
	<cfargument name="ORDUNIQ" type="string" required="no">
	<!--- 
		Find all items that are part of comp builds that need to be backordered.  Selection criteria are as follows:
			[1] At least one serial number was scanned and posted today for any line of the order.
			[2] The order is a comp build.  This means that any of the following part numbers is found on one of the lines of the order:
					AC-COMP-BUILD, AC-COMP-SERVER, AC-NOTE-BUILD, AC-COMP-100SERV, AC-COMP-10SERV, AC-COMP-1SERV, 
					AC-COMP-25SERV, AC-COMP-40SERV, AC-COMP-50SERV, AC-COMP-CLUSTER, AC-COMP-DEPOT, AC-COMP-NETWORK, 
					AC-COMP-ONSITE, AC-COMP-TH
			[3] The order is not complete (at least one line has a backorder amount, or a discrepancy between the number of 
			   serial numbers scanned and the quantity on that line number).
			[4] The part is identified as a serialized item in ACCPAC.
			[5] The part is not one of these software part numbers: SW-MS-66J02326, SW-MS-66J02410, SW-MS-WINXP-I
			[6] Add items to the backorder report only if the order has not been invoiced
			
		Also, check to make sure the order/item has not already been entered in tblBackOrder; it can only be entered once.	
	--->
		<cfif NOT isDefined("Arguments.ORDUNIQ")>
			<cfset SearchAllOrders = 1>
		<cfelse>
			<cfset SearchAllOrders = 0>
		</cfif>

		<cfset objOEORDH = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.OEORDH")>
		<cfset objOEORDD = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.OEORDD")>
		<cfset objCust = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.Cust")>
		
		<cfset StartDate = dateFormat(dateAdd("d", -30, now()), "yyyy-mm-dd 00:00:00.0")>
		<cfset EndDate = dateFormat(now(), "yyyy-mm-dd 23:59:59.9")>

		<cfif SearchAllOrders>
			<!--- Get a list of all orders that had at least one serial number scanned/posted today (criteria [1] above)--->
			<cfquery datasource="#This.DataSourceName#" name="qryTodaysOrders">
			SELECT 	DISTINCT ORDUNIQ
			FROM 	tblSerialsShipments
			WHERE 	Posted = 1 AND
					PostedDate >= '#StartDate#' AND 
					PostedDate <= '#EndDate#'
<!--- TEMP: 02/20/2009: Chris Belcher asked me to remove order number 144761 from the out of stock report --->
					AND (ORDUNIQ <> '11229576')                  

			ORDER BY ORDUNIQ
			</cfquery>
		<cfelse>
<!---		
			<cfquery datasource="#This.DataSourceName#" name="qryTodaysOrders">
			SELECT 	DISTINCT ORDUNIQ
			FROM 	tblSerialsShipments
			WHERE 	ORDUNIQ = '#Arguments.ORDUNIQ#'
			ORDER BY ORDUNIQ
			</cfquery>
--->			
			<cfset qryTodaysOrders = queryNew("ORDUNIQ")>
			<cfset queryAddRow(qryTodaysOrders)>
			<cfset querySetCell(qryTodaysOrders, "ORDUNIQ", Arguments.ORDUNIQ)>
			
		</cfif>

		<cfloop query="qryTodaysOrders">
			<cfset CURRENT_ORDUNIQ = qryTodaysOrders.ORDUNIQ>
			
			<!--- Criteria [6] above --->
			<cfif orderIsNotAttached(CURRENT_ORDUNIQ)>

				<!--- Criteria [2] above . . . . . . . Criteria [3] above --->
				<cfif isCompBuild(CURRENT_ORDUNIQ) AND orderIsNotComplete(CURRENT_ORDUNIQ)>

					<cfset EarliestPostedDate = getEarliestPostedDate(CURRENT_ORDUNIQ)>
					
					<cfset qryOrderLines = objOEORDD.listRecordsForParent("ORDUNIQ", trim(CURRENT_ORDUNIQ))>
					<cfloop query="qryOrderLines">
						<cfset CURRENT_ITEM = trim(qryOrderLines.ITEM)>
						<cfset CURRENT_DESC = qryOrderLines.DESC>
						<cfset CURRENT_LINENUM = qryOrderLines.LINENUM>
						<cfset CURRENT_OrderQuantity = int(qryOrderLines.QTYORDERED + qryOrderLines.QTYSHPTODT)>
						<cfif NOT isABuildItem(CURRENT_ITEM)>

							<!--- Criteria [4] above --->
							<cfif itemIsSerialized(trim(CURRENT_ITEM))>

								<!--- Criteria [5] above --->
								<cfif NOT isSoftwareExcludedItem(CURRENT_ITEM)>

									<cfset RemainingQuantity = getRemainingQuantity(CURRENT_ORDUNIQ, CURRENT_LINENUM)>
									<cfif RemainingQuantity GT 0>

										<!--- Has this order line already been entered? --->
										<cfset SearchRecord = structNew()>
										<cfset structInsert(SearchRecord, "ORDUNIQ", CURRENT_ORDUNIQ, True)>
										<cfset structInsert(SearchRecord, "LINENUM", CURRENT_LINENUM, True)>
										<cfset qryBackOrder = searchRecords(SearchRecord, "query")>
										<cfif qryBackOrder.RecordCount EQ 0>

											<cfset strOEORDH = objOEORDH.getRecord(trim(CURRENT_ORDUNIQ))>
											
											<!--- Get the Sales Rep ID for this order --->
											<cfset qryLogin = objCust.getRecordByAcctno(strOEORDH.CUSTOMER)>
											<cfif isDefined("qryLogin.salesrepID")>
												<cfset SalesRepID = qryLogin.salesrepID>
											<cfelse>
												<cfset SalesRepID = "">
											</cfif>
											
											<!--- Hard Code: If customer is "Reason" (acct R055), set the sales rep to Jeff Olson (ID 12) --->
											<cfif trim(strOEORDH.CUSTOMER) IS "R055">
												<cfset SalesRepID = 12>
											</cfif>
			
											<cfset strBackOrder = newRecord()>
											<cfset structInsert(strBackOrder, "ORDUNIQ", trim(CURRENT_ORDUNIQ), true)>
											<cfset structInsert(strBackOrder, "LINENUM", trim(CURRENT_LINENUM), true)>
											<cfset structInsert(strBackOrder, "ORDNUMBER", trim(strOEORDH.ORDNUMBER), true)>
											<cfset structInsert(strBackOrder, "CUSTOMER", trim(strOEORDH.CUSTOMER), true)>
											<cfset structInsert(strBackOrder, "BILNAME", trim(strOEORDH.BILNAME), true)>
											<cfset structInsert(strBackOrder, "ORDDATE", formatDate(trim(strOEORDH.ORDDATE)), true)>
											<cfset structInsert(strBackOrder, "ITEMNO", trim(CURRENT_ITEM), true)>
											<cfset structInsert(strBackOrder, "ITEMDESC", trim(CURRENT_DESC), true)>
											<cfset structInsert(strBackOrder, "SalesRepID", trim(SalesRepID), true)>
											<cfset structInsert(strBackOrder, "QuantityBackordered", RemainingQuantity, true)>
											<cfset structInsert(strBackOrder, "OrderQuantity", CURRENT_OrderQuantity, true)>
											<cfset structInsert(strBackOrder, "EarliestSNDate", EarliestPostedDate, true)>
											<cfset structInsert(strBackOrder, "DateReported", now(), true)>
											<cfset saveRecord(strBackOrder)>
										</cfif>
									</cfif>
								</cfif>
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
			</cfif>
		</cfloop>
		<cfif SearchAllOrders>
			<cfset syncBackOrder()>
		</cfif>
		
	</cffunction>

	<cffunction name="syncBackOrder" access="public" output="no">
	<!--- Perform syncronization duties:
			1. Delete the record in tblBackOrder if it no longer exists in ACCPAC.
			2. Delete the record in tblBackOrder if it is no longer marked as serialized in ACCPAC
			3. If the quantity changed in ACCPAC, update the order quantity in tblBackOrder.	
	--->
		<cfset objOEORDD = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.OEORDD")>
		<cfset qryBackOrder = getIncompleteRecords()>
		<cfloop query="qryBackOrder">
			<cfif NOT existsInACCPAC(qryBackOrder.ORDUNIQ,qryBackOrder.LINENUM) OR
				  NOT itemIsSerialized(trim(qryBackOrder.ITEMNO))>
				<cfset deleteRecord(qryBackOrder.BackOrderID)>
			<cfelse>
				<cfset updateOrderQuantity(qryBackOrder.BackOrderID)>			
			</cfif>
		</cfloop>
	</cffunction>

	<cffunction name="existsInACCPAC" access="public" returntype="boolean" output="no">
	<cfargument name="ORDUNIQ" type="string" required="Yes">
	<cfargument name="LINENUM" type="string" required="Yes">
		<cfset var doesExistInACCPAC = 1>
		<cfset objOEORDD = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.OEORDD")>
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ORDUNIQ", Arguments.ORDUNIQ, True)>
		<cfset structInsert(SearchRecord, "LINENUM", Arguments.LINENUM, True)>
		<cfset qryOEORDD = objOEORDD.searchRecords(SearchRecord, "query")>
		<cfif qryOEORDD.RecordCount EQ 0>
			<cfset doesExistInACCPAC = 0>
		</cfif>
		<cfreturn doesExistInACCPAC>
	</cffunction>

	<cffunction name="updateOrderQuantity" access="public" output="no">
	<cfargument name="BackOrderID" type="string" required="Yes">
		<cfset objOEORDD = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.OEORDD")>
		<cfset strBackOrder = getRecord(Arguments.BackOrderID)>
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ORDUNIQ", strBackOrder.ORDUNIQ, True)>
		<cfset structInsert(SearchRecord, "LINENUM", strBackOrder.LINENUM, True)>
		<cfset qryOEORDD = objOEORDD.searchRecords(SearchRecord, "query")>
		<cfif qryOEORDD.RecordCount NEQ 0>
			<cfset CURRENT_OrderQuantity = int(qryOEORDD.QTYORDERED + qryOEORDD.QTYSHPTODT)>
			<cfif isNumeric(strBackOrder.OrderQuantity) AND CURRENT_OrderQuantity NEQ strBackOrder.OrderQuantity>
				<cfset OrderQuantityAdjustment = strBackOrder.OrderQuantity - CURRENT_OrderQuantity>
				<cfset NewQuantityBackordered = strBackOrder.QuantityBackordered - OrderQuantityAdjustment>
				<cfset structInsert(strBackOrder, "OrderQuantity", CURRENT_OrderQuantity, True)>
				<cfset structInsert(strBackOrder, "QuantityBackordered", NewQuantityBackordered, True)>
				<cfset saveRecord(strBackOrder)>
			</cfif>
		</cfif>
	</cffunction>
	
	<cffunction name="isCompBuild" access="public" returntype="boolean" output="no">
	<cfargument name="ORDUNIQ" type="string" required="Yes">
		<cfset OrderIsCompBuild = 0>
		<cfset objOEORDD = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.OEORDD")>
		<cfset qryOEORDD = objOEORDD.listRecordsForParent("ORDUNIQ", trim(Arguments.ORDUNIQ))>
		<cfloop query="qryOEORDD">
			<cfif isABuildItem(qryOEORDD.ITEM)>
				<cfset OrderIsCompBuild = 1>
				<cfbreak>			
			</cfif>
		</cfloop>
		<cfreturn OrderIsCompBuild>
	</cffunction>

	<cffunction name="isABuildItem" access="public" returntype="boolean" output="no">
	<cfargument name="ITEM" type="string" required="Yes">
		<cfset var ItemIsABuildItem = 0>
		<cfset var trimmedITEM = "">
		<cfset var SearchRecord = structNew()>
		<cfset var qryCompBuildItems = queryNew("")>
		<cfset objCompBuildItems = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.CompBuildItems")>
		<cfset trimmedITEM = trim(Arguments.ITEM)>
		<cfif trimmedITEM IS NOT "">
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "ITEMNO", trimmedITEM, true)>
			<cfset qryCompBuildItems = objCompBuildItems.searchRecords(SearchRecord, "query")>
			<cfif qryCompBuildItems.RecordCount GT 0>
				<cfset ItemIsABuildItem = 1>
			</cfif>
		</cfif>
<!---		
		<cfset trimmedITEM = trim(Arguments.ITEM)>
		<cfif trimmedITEM IS "AC-COMP-BUILD" OR 
			  trimmedITEM IS "AC-COMP-SERVER" OR
			  trimmedITEM IS "AC-NOTE-BUILD" OR
			  trimmedITEM IS "AC-COMP-100SERV" OR
			  trimmedITEM IS "AC-COMP-10SERV" OR
			  trimmedITEM IS "AC-COMP-1SERV" OR
			  trimmedITEM IS "AC-COMP-25SERV" OR
			  trimmedITEM IS "AC-COMP-40SERV" OR
			  trimmedITEM IS "AC-COMP-50SERV" OR
			  trimmedITEM IS "AC-COMP-CLUSTER" OR
			  trimmedITEM IS "AC-COMP-DEPOT" OR
			  trimmedITEM IS "AC-COMP-NETWORK" OR
			  trimmedITEM IS "AC-COMP-ONSITE" OR
			  trimmedITEM IS "AC-COMP-TH" OR
			  trimmedITEM IS "AC-COMP-MINI/MOUNTABLEPC">
			<cfset ItemIsABuildItem = 1>
		</cfif>
--->		
		<cfreturn ItemIsABuildItem>
	</cffunction>

	<cffunction name="isSoftwareExcludedItem" access="public" returntype="boolean" output="no">
	<cfargument name="ITEM" type="string" required="Yes">
		<cfset ItemIsSoftwareExcludedItem = 0>
		<cfset objSoftwareExclude = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.SoftwareExclude")>
		<cfset trimmedITEM = trim(Arguments.ITEM)>
		<cfif trimmedITEM IS NOT "">
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "ITEMNO", trimmedITEM, true)>
			<cfset qrySoftwareExclude = objSoftwareExclude.searchRecords(SearchRecord, "query")>
			<cfif qrySoftwareExclude.RecordCount GT 0>
				<cfset ItemIsSoftwareExcludedItem = 1>
			</cfif>
		</cfif>
<!---		
		<cfif trimmedITEM IS "SW-MS-66J02326" OR 
			  trimmedITEM IS "SW-MS-66J02410" OR
			  trimmedITEM IS "SW-MS-WINXP-I">
			<cfset ItemIsSoftwareExcludedItem = 1>
		</cfif>
--->
		<cfreturn ItemIsSoftwareExcludedItem>
	</cffunction>
		
	<cffunction name="orderIsNotComplete" access="public" returntype="boolean" output="no">
	<cfargument name="ORDUNIQ" type="string" required="Yes">
	<cfargument name="IgnoreSoftware" type="string" required="No">
		<cfset ThisOrderIsNotComplete = 0>
		<cfif isDefined("Arguments.IgnoreSoftware") AND Arguments.IgnoreSoftware IS "Ignore Software">
			<cfset IgnoreSoftware = 1>
		<cfelse>
			<cfset IgnoreSoftware = 0>		
		</cfif>
		<cfset objOEORDD = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.OEORDD")>
		<cfset qryOEORDD = objOEORDD.listRecordsForParent("ORDUNIQ", trim(Arguments.ORDUNIQ))>
		<cfloop query="qryOEORDD">
			<cfif NOT IgnoreSoftware OR NOT isSoftwareExcludedItem(qryOEORDD.ITEM)>
				<cfset RemainingQuantity = getRemainingQuantity(Arguments.ORDUNIQ, qryOEORDD.LINENUM)>
				<cfif RemainingQuantity GT 0>
					<cfset ThisOrderIsNotComplete = 1>
					<cfbreak>			
				</cfif>
			</cfif>
		</cfloop>
		<cfreturn ThisOrderIsNotComplete>
	</cffunction>

	<cffunction name="getRemainingQuantity" access="public" returntype="numeric" output="no">
	<cfargument name="ORDUNIQ" type="string" required="Yes">
	<cfargument name="LINENUM" type="string" required="Yes">
		<cfset RemainingQuantity = 0>
		<cfset objOEORDD = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.OEORDD")>
		<cfset objSerialsShipments = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.SerialsShipments")>

		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ORDUNIQ", trim(Arguments.ORDUNIQ), True)>
		<cfset structInsert(SearchRecord, "ORDLINENUM", trim(Arguments.LINENUM), True)>
		<cfset structInsert(SearchRecord, "Posted", 1, True)>
		<cfset qrySerialsShipmentsAttached = objSerialsShipments.searchRecords(SearchRecord, "query")>
		
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ORDUNIQ", trim(Arguments.ORDUNIQ), True)>
		<cfset structInsert(SearchRecord, "LINENUM", trim(Arguments.LINENUM), True)>
		<cfset qryOEORDD_This = objOEORDD.searchRecords(SearchRecord, "query")>

		<cfif NOT isNumeric(qryOEORDD_This.QTYORDERED)>
			<cfset qryOEORDD_This.QTYORDERED = 0>
		</cfif>
		<cfif NOT isNumeric(qryOEORDD_This.QTYSHPTODT)>
			<cfset qryOEORDD_This.QTYSHPTODT = 0>
		</cfif>
		
		<cfset RemainingQuantity = int((qryOEORDD_This.QTYORDERED + qryOEORDD_This.QTYSHPTODT) - qrySerialsShipmentsAttached.RecordCount)>

		<cfreturn RemainingQuantity>
	</cffunction>

	<cffunction name="emailOutOfStockReport" access="public" output="no">
	<!---
		Generate and send two versions of the Out of Stock report, as follows:
			The "Sales Rep" Format:  
				This version is sent by email to each sales rep, and shows backordered items and quantities for orders 
				for their customers only.
			The "Purchasing" Format:  
				This version displays a list of all items and quantities that need to be backordered. 
				It is sent by email to the following addresses:
				jeffo@nor-tech.com, larryh@nor-tech.com, robb@nor-tech.com, todds@nor-tech.com, seanq@nor-tech.com.
	--->
		<cfset objAdmin = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.Admin")>

		<!--- THE "SALES REP" FORMAT --->
		<cfset qrySalesReps = objAdmin.listSalesReps()>

<!---TEMP--->
<!---
qrySalesReps:<cfdump var="#qrySalesReps#"><br>
--->		
		<cfloop query="qrySalesReps">

<!---TEMP--->
<!---
<cfif qrySalesReps.UserID IS "7F09125A-423B-5784-915F80CC00FE83A0">
--->
			<cfif qrySalesReps.Active EQ 1>
				<cfset EmailText = getSalesRepFormat(qrySalesReps.UserID)>
				<cfif EmailText IS NOT "">
					<cfset ToAddress = qrySalesReps.emailaddress>	
				
					<!--- Debugging purposes: If Ron Barth is logged in, send all emails to him --->
					<!--- TEST Comment this out --->
<!---                    
					<cfif objAdmin.getSessionValue("AdminUserID") IS "7EBCFD4D-423B-5784-96BD9CB11DAE423D">
						<cfset ToAddress = "ron_barth@altsystem.com">
					</cfif>
--->
					<cfif findNoCase("@", ToAddress) NEQ 0 AND findNoCase(".", ToAddress) NEQ 0>
						<cfif ToAddress IS NOT "ronbarth@comcast.net">
							<cfmail from=	"info@nor-tech.com"		
									to=		"#ToAddress#"
									subject="Nor-Tech Out of Stock Report"
									
									
									type="html">
								<html>
								<head><style type="text/css">BODY {font-family: Verdana, Arial, Helvetica, sans-serif;}</style></head>
								<body>
								#EmailText#
								</body>
								</html>	
							</cfmail>
						</cfif>
					</cfif>
				</cfif>
			</cfif>

<!---TEMP--->
<!---
</cfif>        
--->
		</cfloop>

<!---TEMP--->
<!---
<cfabort>
--->		
		<!--- THE "PURCHASING" FORMAT --->
		<cfset EmailText = getPurchasingFormat()>
		<cfif EmailText IS NOT "">
<!---        
			<cfset ToAddress = "jeffo@nor-tech.com; larryh@nor-tech.com; robb@nor-tech.com; todds@nor-tech.com; seanq@nor-tech.com; stevec@nor-tech.com; chrisb@nor-tech.com; mikeb@nor-tech.com">	
--->            
			<cfset ToAddress = "jeffo@nor-tech.com; larryh@nor-tech.com; robb@nor-tech.com; seanq@nor-tech.com; stevec@nor-tech.com; chrisb@nor-tech.com; mikeb@nor-tech.com; amandag@nor-tech.com">	

			<!--- Debugging purposes: If Ron Barth is logged in, send the email to him --->
			<!--- TEST Comment this out --->
<!---            
			<cfif objAdmin.getSessionValue("AdminUserID") IS "7EBCFD4D-423B-5784-96BD9CB11DAE423D">
				<cfset ToAddress = "ron_barth@altsystem.com">
			</cfif>
--->
			<cfmail from=	"info@nor-tech.com"		
					to=		"#ToAddress#"
					subject="Nor-Tech Out of Stock Report"
					
					
					type="html">
				<html>
				<head><style type="text/css">BODY {font-family: Verdana, Arial, Helvetica, sans-serif;}</style></head>
				<body>
				#EmailText#
				</body>
				</html>	
			</cfmail>
		</cfif>

	</cffunction>

	<!---------------------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="getSalesRepFormat" access="public" returntype="string" output="No">
	<cfargument name="SalesRepUserID" type="string" required="Yes">
		<cfset var EmailText = "">
		<cfset objSalesrep = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.SalesRep")>
		<cfset qryRecords = getRecordsForToday()>

		<cfset strSalesRep = objSalesrep.getSalesRepByUserID(Arguments.SalesRepUserID)>

<!---TEMP---> 
<!---       
strSalesRep:<cfdump var="#strSalesRep#"><br>
--->        
		<cfif isDefined("strSalesRep.ID") AND trim(strSalesRep.ID) IS NOT "">

			<cfquery dbtype="query" name="qryBackOrder">
			SELECT 	*
			FROM 	qryRecords
			WHERE 	SalesRepID = #strSalesRep.ID#
			ORDER BY ORDNUMBER, ITEMNO
			</cfquery>

<!---TEMP--->   
<!---     
qryBackOrder:<cfdump var="#qryBackOrder#"><br>
<cfloop query="qryBackOrder">
    qryBackOrder.ITEMNO:<cfdump var="#qryBackOrder.ITEMNO#"><br>
	<cfif isSoftwareExcludedItem(qryBackOrder.ITEMNO)>
    	isSoftwareExcludedItem<Br>
	</cfif>    
   	<cfif NOT orderIsNotAttached(qryBackOrder.ORDUNIQ)>
    	orderIsAttached<br>
    </cfif>
	<br><br>

</cfloop>
<cfabort>
--->			
			<cfsavecontent variable="EmailText">
				<cfoutput>
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td colspan="6">
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td height="18" style="font-size:14px; font-weight:bold;" width="33%">
											Nor-Tech Out of Stock Report 
										</td>
										<td height="18" style="font-size:14px; font-weight:bold;" width="33%" align="center">
											<cfif isDefined("strSalesRep.repname")>
												Sales Rep: #strSalesRep.repname#
											<cfelse>
												&nbsp;
											</cfif>
										</td>
										<td height="18" style="font-size:14px; font-weight:bold;" align="right">
											Report Date: #dateFormat(now(), 'mmmm d, yyyy')#
										</td>
									</tr>
								</table>								
							</td>
						</tr>
						
						<!--- Header --->
						<tr>
							<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF">Order Number</td>
							<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF">Customer Number</font></td>
							<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF">Customer Name</td>
							<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" align="center">Order Date</td>
							<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF">Part Number</td>
							<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" align="center">Quantity on Backorder</td>
						</tr>			
						
						<!--- Data --->
						<cfif qryBackOrder.RecordCount EQ 0>
							<tr>
								<td align="center" colspan="6" style="font-size:12px; font-weight:bold; color:FF0000">
									No items need to be backordered to complete comp builds for your customers.
								</td>
							</tr>
						</cfif>
	
						<cfset GrandTotal = 0>
						<cfloop query="qryBackOrder">
							<cfif NOT isSoftwareExcludedItem(qryBackOrder.ITEMNO)>
								<cfif orderIsNotAttached(qryBackOrder.ORDUNIQ)>
									<tr<cfif qryBackOrder.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
										<!--- ORDER NUMBER --->
										<td style="font-size:10px" valign="top">#qryBackOrder.ORDNUMBER#</td>
			
										<!--- CUSTOMER NUMBER --->
										<td style="font-size:10px" valign="top">#qryBackOrder.CUSTOMER#</td>
			
										<!--- CUSTOMER NAME --->
										<td style="font-size:10px" valign="top">#qryBackOrder.BILNAME#</td>
			
										<!--- ORDER DATE --->
										<td style="font-size:10px" valign="top" align="center">#dateFormat(qryBackOrder.ORDDATE, 'm/d/yyyy')#</td>
			
										<!--- PART NUMBER --->
										<td style="font-size:10px" valign="top">#qryBackOrder.ITEMNO#</td>
										
										<!--- QUANTITY ON BACKORDER --->
										<cfif NOT isNumeric(qryBackOrder.QuantitySNs)>
											<cfset qryBackOrder.QuantitySNs = 0>
										</cfif>
										<cfset CurrentBackorderQuantity = qryBackOrder.OrderQuantity - qryBackOrder.QuantitySNs>
										<td style="font-size:10px" valign="top" align="center">#CurrentBackorderQuantity#</td>
									</tr>
									<cfset GrandTotal = GrandTotal + CurrentBackorderQuantity>
								</cfif>
							</cfif>
						</cfloop>
						
						<!--- Grand Total --->
						<tr style="background-color:##e5e5e6">
							<td height="22" bgcolor="006633" style="font-size:12px; font-weight:bold; font-style:italic; color:FFFFFF" colspan="5" align="right" valign="middle">
								Grand Total:
							</td>
							<td height="22" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" colspan="1" align="center" valign="middle">
								#GrandTotal#
							</td>
						</tr>
					</table>
				</cfoutput>
			</cfsavecontent>
		</cfif>			
        
<!---TEMP---> 
<!---       
EmailText:<cfdump var="#EmailText#"><br>
<cfabort>
--->        
		<cfreturn EmailText>
	</cffunction>	
	
	<cffunction name="getPurchasingFormat" access="public" returntype="string" output="No">
		<cfset var EmailText = "">
		<cfset objOEORDH = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.OEORDH")>
		<cfset objOEORDD = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.OEORDD")>
		<cfset objSerials = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.Serials")>
		<cfset qryBackOrder = getRecordsForToday()>
		<cfsavecontent variable="EmailText">
			<cfoutput>
				<table width="80%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td height="18" style="font-size:14px; font-weight:bold;" colspan="2">
							Nor-Tech Out of Stock Report
						</td>
						<td height="18" style="font-size:14px; font-weight:bold;" align="right" colspan="5">
							Report Date: #dateFormat(now(), 'mmmm d, yyyy')#
						</td>
					</tr>
					
					<!--- Header --->
					<tr>
						<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF">Part Number</td>
						<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF">&nbsp;</td>
						<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF">Order<br>Number</font></td>
						<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF">Customer<br>Number</font></td>
						<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" align="center" colspan="3">Quantity on Backorder</td>
					</tr>
					
					<!--- Data --->
					<cfif qryBackOrder.RecordCount EQ 0>
						<tr>
							<td align="center" colspan="7" style="font-size:12px; font-weight:bold; color:FF0000">
								No items need to be backordered to complete comp builds.
							</td>
						</tr>
					</cfif>
					
					<cfset ItemTotal = 0>
					<cfset GrandTotal = 0>
					<cfset SavedItem = "">
					<cfset FirstItemTotal = 1>
					<cfloop query="qryBackOrder">
						<cfif NOT isSoftwareExcludedItem(qryBackOrder.ITEMNO)>
							<cfif orderIsNotAttached(qryBackOrder.ORDUNIQ)>
<!---							<cfif (SavedItem IS NOT qryBackOrder.ITEMNO AND qryBackOrder.CurrentRow NEQ 1)>	--->
								<cfif (SavedItem IS NOT qryBackOrder.ITEMNO AND NOT FirstItemTotal)>
									<tr style="background-color:##e5e5e6">
										<td style="font-size:11px; font-weight:bold; font-style:italic" colspan="5" align="right" valign="top">
											Total:<br>&nbsp;
										</td>
										<td style="font-size:11px; font-weight:bold" valign="top" align="right">
											#ItemTotal#<br>&nbsp;
										</td>
										<td style="font-size:11px; font-weight:bold" valign="top">
											&nbsp;<br>&nbsp;
										</td>
									</tr>
									<cfset ItemTotal = 0>
								</cfif>
								<cfset FirstItemTotal = 0>
								
								<tr>
									<!--- PART NUMBER --->
									<td style="font-size:10px" width="35%">
										<cfif SavedItem IS NOT qryBackOrder.ITEMNO>
											#qryBackOrder.ITEMNO#
										<cfelse>
											&nbsp;
										</cfif>
									</td>

									<!--- ON HAND AMOUNT --->
									<cfset OnHandAmount = objSerials.getOnHandAmount(qryBackOrder.ITEMNO)>
									<td style="font-size:10px" width="10%">
										<cfif SavedItem IS NOT qryBackOrder.ITEMNO AND OnHandAmount GT 0>
											<font color="##FF0000">* #OnHandAmount#</font>
										<cfelse>
											&nbsp;
										</cfif>
									</td>
									
									<!--- ORDER NUMBER --->
									<td style="font-size:10px" width="15%">#qryBackOrder.ORDNUMBER#</td>
									
									<!--- CUSTOMER NUMBER --->
									<td style="font-size:10px" width="15%">#qryBackOrder.CUSTOMER#</td>

									<!--- QUANTITY ON BACKORDER --->
									<cfif NOT isNumeric(qryBackOrder.QuantitySNs)>
										<cfset qryBackOrder.QuantitySNs = 0>
									</cfif>
									<cfset CurrentBackorderQuantity = qryBackOrder.OrderQuantity - qryBackOrder.QuantitySNs>
									<td width="10%">&nbsp;</td>
									<td width="10%" style="font-size:10px" align="right">#CurrentBackorderQuantity#</td>
									<td>&nbsp;</td>
									
								</tr>
								<cfset SavedItem = qryBackOrder.ITEMNO>
		
								<cfset ItemTotal = ItemTotal + CurrentBackorderQuantity>
								<cfset GrandTotal = GrandTotal + CurrentBackorderQuantity>
								
								<cfif qryBackOrder.CurrentRow EQ qryBackOrder.RecordCount>
									<tr style="background-color:##e5e5e6">
										<td style="font-size:11px; font-weight:bold; font-style:italic" colspan="5" align="right" valign="top">
											Total:<br>&nbsp;
										</td>
										<td style="font-size:11px; font-weight:bold" valign="top" align="right">
											#ItemTotal#<br>&nbsp;
										</td>
										<td style="font-size:11px; font-weight:bold" valign="top">
											&nbsp;<br>&nbsp;
										</td>
									</tr>
									<cfset ItemTotal = 0>
								</cfif>
							</cfif>
						</cfif>
					</cfloop>
					
					<!--- Grand Total --->
					<tr style="background-color:##e5e5e6">
						<td height="22" bgcolor="006633" style="font-size:12px; font-weight:bold; font-style:italic; color:FFFFFF" colspan="5" align="right" valign="middle">
							Grand Total: 
						</td>					
						<td height="22" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" colspan="1" align="right" valign="middle">
							#GrandTotal#
						</td>					
						<td height="22" bgcolor="006633" style="font-size:12px; font-weight:bold; font-style:italic; color:FFFFFF" colspan="1" align="right" valign="middle">&nbsp;
							
						</td>
					</tr>
					
					<!--- Grand Total Number of Orders --->
					<cfquery dbtype="query" name="qryOrderNumbers">
					SELECT 	DISTINCT ORDNUMBER
					FROM 	qryBackOrder
					</cfquery>
					<cfset AssemblyTotal = 0>
					<cfset RailsTotal = 0>
					<cfloop query="qryOrderNumbers">
						<cfset SearchRecord = structNew()>
						<cfset structInsert(SearchRecord, "ORDNUMBER", qryOrderNumbers.ORDNUMBER, True)>
						<cfset qryOEORDH = objOEORDH.searchRecords(SearchRecord, "query")>
						<cfif orderIsNotAttached(qryOEORDH.ORDUNIQ)>
							<cfset qryOEORDD = objOEORDD.listRecordsForParent("ORDUNIQ", qryOEORDH.ORDUNIQ)>
							<cfset NumberOfSystems = 0>
							<cfloop query="qryOEORDD">
								<cfif isABuildItem(trim(qryOEORDD.ITEM))>
									<cfset NumberOfSystems = NumberOfSystems + qryOEORDD.QTYORDERED + qryOEORDD.QTYSHPTODT>
								</cfif>
							</cfloop>
							<cfif NumberOfSystems GE 10>
								<cfset AssemblyTotal = AssemblyTotal + 1>
							<cfelse>
								<cfset RailsTotal = RailsTotal + 1>
							</cfif>
						</cfif>
					</cfloop>

					<tr style="background-color:##e5e5e6">
						<td height="22" bgcolor="006633" style="font-size:12px; font-weight:bold; font-style:italic; color:FFFFFF" colspan="5" align="right" valign="middle">
							Assembly Total: 
						</td>					
						<td height="22" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" colspan="1" align="right" valign="middle">
							#AssemblyTotal#
						</td>					
						<td height="22" bgcolor="006633" style="font-size:12px; font-weight:bold; font-style:italic; color:FFFFFF" colspan="1" align="right" valign="middle">&nbsp;
							
						</td>
					</tr>

					<tr style="background-color:##e5e5e6">
						<td height="22" bgcolor="006633" style="font-size:12px; font-weight:bold; font-style:italic; color:FFFFFF" colspan="5" align="right" valign="middle">
							Rails Total: 
						</td>					
						<td height="22" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" colspan="1" align="right" valign="middle">
							#RailsTotal#
						</td>					
						<td height="22" bgcolor="006633" style="font-size:12px; font-weight:bold; font-style:italic; color:FFFFFF" colspan="1" align="right" valign="middle">&nbsp;
							
						</td>
					</tr>

					<tr style="background-color:##e5e5e6">
						<td height="22" bgcolor="006633" style="font-size:12px; font-weight:bold; font-style:italic; color:FFFFFF" colspan="5" align="right" valign="middle">
							Grand Total Number of Orders: 
						</td>					
						<td height="22" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" colspan="1" align="right" valign="middle">
							#(AssemblyTotal + RailsTotal)#
						</td>					
						<td height="22" bgcolor="006633" style="font-size:12px; font-weight:bold; font-style:italic; color:FFFFFF" colspan="1" align="right" valign="middle">&nbsp;
							
						</td>
					</tr>
					
					<!--- Completed Orders Total --->
					<cfset CompletedOrdersTotal = getCompletedOrdersTotal()>
					<tr style="background-color:##e5e5e6">
						<td height="22" bgcolor="006633" style="font-size:12px; font-weight:bold; font-style:italic; color:FFFFFF" colspan="5" align="right" valign="middle">
							Total Number of Completed Orders: 
						</td>					
						<td height="22" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" colspan="1" align="right" valign="middle">
							#CompletedOrdersTotal#
						</td>					
						<td height="22" bgcolor="006633" style="font-size:12px; font-weight:bold; font-style:italic; color:FFFFFF" colspan="1" align="right" valign="middle">&nbsp;
							
						</td>
					</tr>

				</table>
			</cfoutput>
		</cfsavecontent>
		<cfreturn EmailText>
	</cffunction>	

	<cffunction name="getCompletedOrdersTotal" access="public" returntype="numeric" output="no">
		<cfset var CompletedOrdersTotal = 0>
		<cfset StartDate = dateFormat(dateAdd("d", -30, now()), "yyyy-mm-dd 00:00:00.0")>
		<cfset EndDate = dateFormat(now(), "yyyy-mm-dd 23:59:59.9")>

		<cfquery datasource="#This.DataSourceName#" name="qryOrders">
		SELECT 	DISTINCT ORDUNIQ
		FROM 	tblSerialsShipments
		WHERE 	Posted = 1 AND
				PostedDate >= '#StartDate#' AND 
				PostedDate <= '#EndDate#'
		ORDER BY ORDUNIQ
		</cfquery>
		<cfloop query="qryOrders">
			<cfset CURRENT_ORDUNIQ = qryOrders.ORDUNIQ>
			<cfif isCompBuild(CURRENT_ORDUNIQ)>
				<cfif NOT orderIsNotComplete(CURRENT_ORDUNIQ, "Ignore Software")>
					<cfif orderIsNotAttached(CURRENT_ORDUNIQ)>
						<cfset CompletedOrdersTotal = CompletedOrdersTotal + 1>
					</cfif>
				</cfif>
			</cfif>
		</cfloop>
		<cfreturn CompletedOrdersTotal>
	</cffunction>

	<cffunction name="orderIsNotAttached" access="public" returntype="boolean" output="no">
	<!--- This function determines whether or not an order has been invoiced, using the following logic:
		  If all serial numbers for the "AC-COMP-BUILD" item have been attached to invoices, and the number of serial numbers
		  scanned and attached for "AC-COMP-BUILD" is greater than or equal to the order quantity, consider the order invoiced.--->
	<cfargument name="ORDUNIQ" type="string" required="Yes">
		<cfset var OrderIsNotInvoiced = 0>
		<cfset var qryOEORDD = queryNew("")>
		<cfset var Done = 0>
		<cfset objOEORDD = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.OEORDD")>
		<cfset objSerialsShipments = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.SerialsShipments")>

		<cfset qryOEORDD = objOEORDD.listRecordsForParent("ORDUNIQ", trim(Arguments.ORDUNIQ))>
		<cfloop query="qryOEORDD">
			<cfif isABuildItem(qryOEORDD.ITEM)>
				<cfset SearchRecord = structNew()>
				<cfset structInsert(SearchRecord, "ORDUNIQ", trim(Arguments.ORDUNIQ), True)>
				<cfset structInsert(SearchRecord, "ORDLINENUM", trim(qryOEORDD.LINENUM), True)>
				<cfset structInsert(SearchRecord, "Posted", 1, True)>
				<cfset qrySerialsShipmentsPosted = objSerialsShipments.searchRecords(SearchRecord, "query")>
				<!--- No SNs are scanned for the "AC-COMP-BUILD" item --->
				<cfif qrySerialsShipmentsPosted.RecordCount EQ 0>
					<cfset OrderIsNotInvoiced = 1>
					<cfset Done = 1>
				</cfif>
				
				<!--- SNs for the "AC-COMP-BUILD" item are not attached to an invoice --->
				<cfif NOT Done>
					<cfloop query="qrySerialsShipmentsPosted">
						<cfif qrySerialsShipmentsPosted.AttachedToInvoice EQ 0>
							<cfset OrderIsNotInvoiced = 1>
							<cfset Done = 1>
							<cfbreak>			
						</cfif>
					</cfloop>
				</cfif>

				<!--- Quantity of SNs scanned and attached for "AC-COMP-BUILD" is less than the order quantity --->
				<cfif NOT Done>
					<cfif qrySerialsShipmentsPosted.RecordCount LT (qryOEORDD.QTYORDERED + qryOEORDD.QTYSHPTODT)>
						<cfset OrderIsNotInvoiced = 1>
						<cfset Done = 1>
					</cfif>
				</cfif>
				
				<cfbreak>			
			</cfif>
		</cfloop>
		<cfreturn OrderIsNotInvoiced>
	</cffunction>

	<cffunction name="getRecordsForToday" access="public" returntype="query" output="no">
		<cfset qryRecords = queryNew(This.ViewColumns)>
		<cfset StartDate = dateFormat("6/1/2007", "yyyy-mm-dd 00:00:00.0")>
		<cfset EndDate = DateFormat(now(), "yyyy-mm-dd 23:59:59.9")>
		<cfquery datasource="#This.DataSourceName#" name="qryRecords">
		SELECT 	#This.ViewColumns#
		FROM 	#This.ViewName#
		WHERE 	DateReported >= '#StartDate#' AND 
				DateReported <= '#EndDate#' AND 
				QuantitySNs < OrderQuantity
<!---
				AND
				(QuantityReceived IS NULL OR
				QuantityRemaining > 0) 
--->				
		ORDER BY ITEMNO, ORDNUMBER
		</cfquery>
		<cfreturn qryRecords>
	</cffunction>

	<cffunction name="getIncompleteRecords" access="public" returntype="query" output="no">
		<cfset qryRecords = queryNew(This.ViewColumns)>
		<cfquery datasource="#This.DataSourceName#" name="qryRecords">
		SELECT 	#This.ViewColumns#
		FROM 	#This.ViewName#
		WHERE 	QuantitySNs < OrderQuantity
		ORDER BY ORDNUMBER, LINENUM
		</cfquery>
		<cfreturn qryRecords>
	</cffunction>

	<cffunction name="getRecordsForReceipt" access="public" returntype="query" output="no">
	<cfargument name="ITEMNO" type="string" required="Yes">
		<cfset qryRecords = queryNew(This.ViewColumns)>
		<cfset ThirtyDaysAgo = dateFormat(dateAdd("d", -30, now()), "m/d/yyyy")>
		<cfset SixtyDaysAgo = dateFormat(dateAdd("d", -60, now()), "m/d/yyyy")>
		<cfquery datasource="#This.DataSourceName#" name="qryRecords">
		SELECT 	#This.ViewColumns#
		FROM 	#This.ViewName#
		WHERE 	ITEMNO = '#trim(Arguments.ITEMNO)#' AND 
<!---
				(QuantityReceived IS NULL OR
				QuantityRemaining > 0) AND 
--->				
				QuantitySNs < OrderQuantity AND
<!---			ORDDATE >= '#ThirtyDaysAgo#'	--->
				ORDDATE >= '#SixtyDaysAgo#'
		ORDER BY EarliestSNDate
		</cfquery>		
		<cfreturn qryRecords>
	</cffunction>

	<cffunction name="getEarliestPostedDate" access="public" returntype="string" output="no">
	<cfargument name="ORDUNIQ" type="string" required="Yes">
		<cfset EarliestPostedDate = now()>
		<cfquery datasource="#This.DataSourceName#" name="qrySerialsShipments">
		SELECT 	MIN(PostedDate) AS EarliestDate
		FROM 	tblSerialsShipments
		WHERE 	ORDUNIQ = '#Arguments.ORDUNIQ#' AND
				Posted = 1
		</cfquery>
		<cfif isDefined("qrySerialsShipments.EarliestDate")>
			<cfset EarliestPostedDate = qrySerialsShipments.EarliestDate>
		</cfif>
		<cfreturn EarliestPostedDate>
	</cffunction>

</cfcomponent>