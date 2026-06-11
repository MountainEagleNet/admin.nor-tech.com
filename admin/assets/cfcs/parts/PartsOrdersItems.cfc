<cfcomponent extends="admin.assets.cfcs.Component">

	<cfif isDefined("APPLICATION.DSN_WWW")>
		<cfset This.DataSourceName = APPLICATION.DSN_WWW>
	<cfelse>
		<cfset This.DataSourceName = "NorTechWWW">
	</cfif>

	<cfset This.Columns = "PartsOrdersItemsID,PartsOrdersID,ITEMNO,ITEMDESC,SellPrice,Quantity">
	<cfset This.ViewColumns = "PartsOrdersItemsID,PartsOrdersID,CustomerID,SessionID,OrderPlaced,ITEMNO,ITEMDESC,SellPrice,Quantity">
	
	<cfset This.TableName = "tblPartsOrdersItems">
	<cfset This.ViewName = "vPartsOrdersItems">
	
	<cfset This.PrimaryKey = "PartsOrdersItemsID">
	<cfset This.ForeignHeaderKey = "">
	<cfset This.ForeignDetailKey = "">
	
	<cfset This.ITEMNOKey = "">	

	<cfset This.GenerateUUIDKey = 1>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "ITEMNO">
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
	
	<cffunction name="validateRecord" access="public" returntype="struct" output="no">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
		<cfset lstRecord = structKeyList(Arguments.Record)>
		<cfloop list="#lstRecord#" index="Column">
			<cfif findNoCase('QTY|', Column) NEQ 0>
				<cfset ColumnValue = trim(Arguments.Record[Column])>
				<cfif ColumnValue IS NOT "">
					<cfif validateZeroInteger(ColumnValue) EQ 0>
						<cfset structInsert(stErrors, Column, 1, True)>
						<cfset structInsert(stErrors, "QuantityError", "Please enter only integers in the quantity fields.", True)>
					</cfif>
				</cfif>
			</cfif>		
		</cfloop>
		<cfreturn stErrors>
	</cffunction>

	<cffunction name="saveParts" access="public" returntype="numeric" output="no">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var NumberPartsSaved = 0>

		<cfset objCust = createObject("component", "admin.assets.cfcs.Cust")>
		<cfset objPartsOrders = createObject("component", "admin.assets.cfcs.parts.PartsOrders")>
		<cfset objPriceListComponents = createObject("component", "admin.assets.cfcs.prices.PriceListComponents")>
		<cfset objPartsAdmin = createObject("component", "admin.assets.cfcs.parts.PartsAdmin")>
		<cfset objComponentPrices = createObject("component", "admin.assets.cfcs.config.ComponentPrices")>

		<!--- Get/create record in tblPartsOrders --->
		<cfset SessionUserID = getSessionValue("id")>
		<cfset strLogin = objCust.getRecordAsStruct(URLDecode(SessionUserID))>
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "SessionID", Arguments.Record.SessionID, True)>
		<cfset structInsert(SearchRecord, "CustomerID", strLogin.CustomerID, True)>
		<cfset structInsert(SearchRecord, "OrderPlaced", 0, True)>
		<cfset qryPartsOrder = objPartsOrders.searchRecords(SearchRecord, "query")>
		<cfif qryPartsOrder.RecordCount NEQ 0>
			<cfset PartsOrdersID = qryPartsOrder.PartsOrdersID>
		<cfelse>
			<cfset strPartsOrder = objPartsOrders.newRecord()>
			<cfset structInsert(strPartsOrder, "CustomerID", strLogin.CustomerID, True)>
			<cfset structInsert(strPartsOrder, "SessionID", Arguments.Record.SessionID, True)>
			<cfset PartsOrdersID = objPartsOrders.saveRecord(strPartsOrder)>
		</cfif>
		<cfset lstRecord = structKeyList(Arguments.Record)>
		<cfloop list="#lstRecord#" index="Column">
			<cfif findNoCase('QTY|', Column) NEQ 0>
				<cfset ThisItemQuantity = trim(Arguments.Record[Column])>
				
				<cfif NOT isNumeric(ThisItemQuantity) OR ThisItemQuantity LE 0>
					<cfset RemoveThisItem = 1>
				<cfelse>
					<cfset RemoveThisItem = 0>
				</cfif>
			
				<cfset ComponentID = removeChars(Column, 1, 4)>
				<cfif isDefined("Arguments.Record.GarageSaleItems") AND Arguments.Record.GarageSaleItems EQ 1>
					<cfset strComponent = objPartsAdmin.getRecord(ComponentID)>
<!---                    
				<cfelseif isDefined("Arguments.Record.SearchText")>  
					<cfset strComponent = objComponentPrices.getRecord(ComponentID)>
--->                    
				<cfelse>
					<cfset strComponent = objPriceListComponents.getRecord(ComponentID)>
				</cfif>

				<cfif isDefined("strComponent.Price")>
                	<cfset SellingPrice = strComponent.Price>
				<cfelse>
					<cfset SellingPrice = objPartsAdmin.getSellPrice(strComponent.ITEMNO)>
                    <cfif SellingPrice IS "">
                        <cfset SellingPrice = strComponent.SellPrice>
                    </cfif>
                </cfif>
                
				<cfset SearchRecord = structNew()>
				<cfset structInsert(SearchRecord, "PartsOrdersID",PartsOrdersID, True)>
				<cfset structInsert(SearchRecord, "ITEMNO", trim(strComponent.ITEMNO), True)>
				<cfset qryPartsOrdersItems = searchRecords(SearchRecord, "query")>
				<cfif qryPartsOrdersItems.RecordCount EQ 0 AND NOT RemoveThisItem>
					<cfset strPartsOrdersItem = newRecord()>
					<cfset structInsert(strPartsOrdersItem, "PartsOrdersID", PartsOrdersID, True)>
					<cfset structInsert(strPartsOrdersItem, "ITEMNO", trim(strComponent.ITEMNO), True)>
					<cfset structInsert(strPartsOrdersItem, "ITEMDESC", getItemDescription(strComponent.ITEMNO), True)>
					<cfset structInsert(strPartsOrdersItem, "SellPrice", SellingPrice, True)>
					<cfset structInsert(strPartsOrdersItem, "Quantity", ThisItemQuantity, True)>
					<cfset saveRecord(strPartsOrdersItem)>
					<cfset NumberPartsSaved = NumberPartsSaved + 1>

				<cfelseif qryPartsOrdersItems.RecordCount GT 0 AND NOT RemoveThisItem>>
					<cfset strPartsOrdersItem = getRecord(qryPartsOrdersItems.PartsOrdersItemsID)>
					<cfset structInsert(strPartsOrdersItem, "SellPrice", SellingPrice, True)>
					<cfset structInsert(strPartsOrdersItem, "Quantity", ThisItemQuantity, True)>
					<cfset saveRecord(strPartsOrdersItem)>
					<cfset NumberPartsSaved = NumberPartsSaved + 1>

				<cfelseif qryPartsOrdersItems.RecordCount GT 0 AND RemoveThisItem>
					<cfset deleteRecord(qryPartsOrdersItems.PartsOrdersItemsID)>						
				</cfif>
			</cfif>		
		</cfloop>
		<cfreturn NumberPartsSaved>
	</cffunction>
	
	
	<cffunction name="getQuantity" access="public" returntype="any" output="no">
	<cfargument name="ITEMNO" type="string" required="Yes">
		<cfset var CurrentQuantity = "">
		<cfset objCust = createObject("component", "admin.assets.cfcs.Cust")>

		<cfset SessionUserID = getSessionValue("id")>
		<cfset strLogin = objCust.getRecordAsStruct(URLDecode(SessionUserID))>
		<cfset ThisSessionID = getSessionValue("SessionID")>
		
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "CustomerID", strLogin.CustomerID, True)>
		<cfset structInsert(SearchRecord, "SessionID", ThisSessionID, True)>
		<cfset structInsert(SearchRecord, "OrderPlaced", 0, True)>
		<cfset structInsert(SearchRecord, "ITEMNO", trim(Arguments.ITEMNO), True)>
		<cfset qryPartsOrdersItems = searchRecords(SearchRecord, "query")>
		<cfif qryPartsOrdersItems.RecordCount NEQ 0>
			<cfset CurrentQuantity = qryPartsOrdersItems.Quantity>
		</cfif>
		<cfreturn CurrentQuantity>
	</cffunction>
	
	
</cfcomponent>