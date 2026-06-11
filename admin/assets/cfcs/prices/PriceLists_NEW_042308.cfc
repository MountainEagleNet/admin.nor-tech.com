<cfcomponent extends="admin.assets.cfcs.Component">
	<cfset This.DataSourceName = APPLICATION.DSN_WWW>

	<cfset This.TableName = "tblPriceLists">
	<cfset This.ViewName = "vPriceLists">

	<cfset This.Columns = "PriceListID,UserID,Name,Description,MasterPriceList,MarkupPercent,DefaultPriceList">
	<cfset This.ViewColumns = "PriceListID,UserID,FirstName,LastName,Email,Name,Description,MasterPriceList,MarkupPercent,DefaultPriceList">
	
	<cfset This.PrimaryKey = "PriceListID">
	
	<cfset This.GenerateUUIDKey = 1>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "Name">
	<cfset This.SortOrder = "Asc">

	<cfset This.SortOrderList = "">
	<cfset This.SortKey = "">
	<cfset This.ParentKey = "UserID">
	<cfset This.CreatedKey = "">
	<cfset This.ModifiedKey = "">
	<cfset This.ZipCode1Key = "">
	<cfset This.ZipCode2Key = "">
	<cfset This.SavePrimaryKey = 0>
	<cfset This.ExcludeInUpdates = "">
	<cfset This.ExcludeInInserts = "">

	<cffunction name="listSalesRepPriceLists" access="public" returntype="query" output="No">
	<cfargument name="OrderByList" type="string" required="no">
		<cfset var qryPriceLists = queryNew(This.ViewColumns)>
		<cfif NOT isDefined("Arguments.OrderByList")>
			<cfset Arguments.OrderByList = This.SortColumn & " " & This.SortOrder>
		</cfif>
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "MasterPriceList", 0, True)>
		<cfset structInsert(SearchRecord, "UserID", getSessionValue("adminuserid"), True)>
		<cfset qryPriceLists = searchRecords(SearchRecord, "query", Arguments.OrderByList)>
		<cfreturn qryPriceLists>
	</cffunction>

	<cffunction name="getDefaultPriceListID" access="public" returntype="string" output="No">
		<cfset var DefaultPriceListID = "">
		<cfset qryPriceLists = listSalesRepPriceLists()>
		<cfloop query="qryPriceLists">
			<cfif qryPriceLists.DefaultPriceList EQ 1>
				<cfset DefaultPriceListID = qryPriceLists.PriceListID>
				<cfbreak>
			</cfif>
		</cfloop>
		<cfif DefaultPriceListID IS "" AND qryPriceLists.RecordCount GT 0>
			<cfset DefaultPriceListID = qryPriceLists.PriceListID>
		</cfif>
		<cfif DefaultPriceListID IS "">
			<cfset DefaultPriceListID = "MASTERPRICELISTUUID">
		</cfif>
		<cfreturn DefaultPriceListID>
	</cffunction>

	<cffunction name="getCustomerPriceListID" access="public" returntype="string" output="No">
	<cfargument name="CustomerID" type="string" required="Yes">
		<cfset var PriceListID = "">
		<cfset var qrylogin	= queryNew("")>
		<cfquery datasource="#This.DataSourceName#" name="qrylogin">
		SELECT	PriceListID
		FROM	login
		WHERE 	CustomerID = '#Arguments.CustomerID#'
		</cfquery>	
		<cfif qrylogin.RecordCount NEQ 0>
			<cfset PriceListID = qrylogin.PriceListID>
		<cfelse>
			<cfset PriceListID = "MASTERPRICELISTUUID">		
		</cfif>
<!---		
		<cfset objCust = createObject("component", "admin.assets.cfcs.Cust")>
		<cfset qrylogin = objCust.getRecordAsQueryByCustomerID(Arguments.CustomerID)>
		<cfif qrylogin.RecordCount GT 0>
			<cfset PriceListID = qrylogin.PriceListID>
		<cfelse>
			<cfset PriceListID = "MASTERPRICELISTUUID">		
		</cfif>
--->		
		<cfreturn PriceListID>
	</cffunction>

	<cffunction name="validate_frmNew" access="public" returntype="struct" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
		<cfif validateRequired(Arguments.Record.COPYPriceListID) EQ 0>
			<cfset stErrors.COPYPriceListID = "Please make a selection">
		</cfif>
		<cfreturn stErrors>
	</cffunction>

	<cffunction name="validate_frmName" access="public" returntype="struct" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
		<cfif validateRequired(Arguments.Record.Name) EQ 0>
			<cfset structInsert(stErrors, "Name", "Please enter a name for the price list", True)>
		</cfif>
		<cfif trim(Arguments.Record.MarkUpPercent) IS NOT "" AND validateZeroDecimal(Arguments.Record.MarkUpPercent) EQ 0>
			<cfset structInsert(stErrors, "MarkUpPercent", "Please enter only a decimal value (greater than or equal to zero) in the markup percentage field", True)>
		</cfif>
		<cfreturn stErrors>
	</cffunction>

	<cffunction name="saveRecord" access="public" returntype="string" output="No">
	<cfargument name="Record" type="struct" required="No">
		<cfset var RecordID = "">
		<cfif structKeyExists(Arguments.Record, "MarkUpPercent") AND trim(Arguments.Record.MarkUpPercent) IS "">
			<cfset structInsert(Arguments.Record, "MarkUpPercent", "NULL", True)>
		</cfif>
		<cfset RecordID = super.saveRecord(Arguments.Record)>
		<cfreturn RecordID>
	</cffunction>
	
	<cffunction name="importComponents" access="public" returntype="numeric" output="no">
	<cfargument name="ITEMNO" type="string" required="No">
		<cfset var ImportCount = 0>
		<cfset var SearchRecord = structNew()>
		<cfset var ItemAdded = 0>

		<cfset objConfigComponents = createObject("component", "admin.assets.cfcs.config.ConfigComponents")>
		<cfset objPriceListCategories = createObject("component", "admin.assets.cfcs.prices.PriceListCategories")>
		<cfset objPriceListComponents = createObject("component", "admin.assets.cfcs.prices.PriceListComponents")>
		<cfset objICITEM = createObject("component", "admin.assets.cfcs.ICITEM")>

		<cfif NOT isDefined("Arguments.ITEMNO")>
			<cfset Arguments.ITEMNO = "">
		</cfif>

		<cfif Arguments.ITEMNO IS "">
			<cfset qryItems = objConfigComponents.getConfigurableItems()>
		<cfelse>
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "ITEMNO", trim(Arguments.ITEMNO), true)>
			<cfset structInsert(SearchRecord, "ALLOWONWEB", 1, true)>
			<cfset qryItems = objICITEM.searchRecords(SearchRecord, "query")>
		</cfif>
		
		<cfset qryPriceLists = listRecords()>
		
		<!--- Loop through all items marked as "Configurable" in ACCPAC --->
		<cfset ImportCount = 0>
		<cfloop query="qryItems">
			<cfset CURRENT_ITEMNO = trim(qryItems.ITEMNO)>
			<cfset CURRENT_CATEGORY = trim(qryItems.CATEGORY)>
			<cfif CURRENT_ITEMNO IS NOT "[NONE]">
				<!--- Get the Category Description --->
				<cfquery datasource="#APPLICATION.DSN_AP#" name="qryICCATG">
				SELECT 	dbo.ICCATG.[DESC]
				FROM 	dbo.ICCATG
				WHERE	dbo.ICCATG.CATEGORY = '#CURRENT_CATEGORY#'
				</cfquery>
				<cfset CURRENT_CategoryDescription = "">
				<cfif qryICCATG.RecordCount GT 0>
					<cfset CURRENT_CategoryDescription = trim(qryICCATG.DESC)>
				</cfif>

				<cfset ItemAdded = 0>	
				<cfloop query="qryPriceLists">
					<cfset CURRENTPriceListID = qryPriceLists.PriceListID>
					<cfset CURRENTPriceListMarkUpPercent = qryPriceLists.MarkUpPercent>
					<cfif qryPriceLists.MasterPriceList>
						<cfset isMasterPriceList = 1>
					<cfelse>
						<cfset isMasterPriceList = 0>
					</cfif>
	
					<!--- Is this item already in this price list? --->
					<cfset SearchRecord = structNew()>
					<cfset structInsert(SearchRecord, "PriceListID", CURRENTPriceListID, True)>
					<cfset structInsert(SearchRecord, "ITEMNO", CURRENT_ITEMNO, True)>
					<cfset qryPriceListComponents = objPriceListComponents.searchRecords(SearchRecord, "query")>			
					<cfif qryPriceListComponents.RecordCount EQ 0>

						<cfset ItemAdded = 1>	
						
						<!--- Is this Category already in this price list? --->
						<cfset SearchRecord = structNew()>
						<cfset structInsert(SearchRecord, "PriceListID", CURRENTPriceListID, True)>
						<cfset structInsert(SearchRecord, "CATEGORY", CURRENT_CATEGORY, True)>
						<cfset qryPriceListCategories = objPriceListCategories.searchRecords(SearchRecord, "query")>			
						<cfif qryPriceListCategories.RecordCount EQ 0>
							<!--- If not, Add the Category --->
							<cfset strPriceListCategory = objPriceListCategories.newRecord()>
							<cfset structInsert(strPriceListCategory, "PriceListID", CURRENTPriceListID, True)>
							<cfset structInsert(strPriceListCategory, "CATEGORY", CURRENT_CATEGORY, True)>
							<cfset structInsert(strPriceListCategory, "CategoryDescription", CURRENT_CategoryDescription, True)>
<!---						<cfset structInsert(strPriceListCategory, "MarkupPercent", CURRENTPriceListMarkUpPercent, True)>	--->
							<cfset structInsert(strPriceListCategory, "MarkupPercent", "", True)>
							<cfset PriceListCategoryID = objPriceListCategories.saveRecord(strPriceListCategory)>
						<cfelse>
							<cfset PriceListCategoryID = qryPriceListCategories.PriceListCategoryID>
						</cfif>
						
						<!--- Add the Component --->
						<cfset strPriceListComponent = objPriceListComponents.newRecord()>
						<cfset structInsert(strPriceListComponent, "PriceListCategoryID", PriceListCategoryID, True)>
						<cfset structInsert(strPriceListComponent, "ITEMNO", CURRENT_ITEMNO, True)>
						<cfset structInsert(strPriceListComponent, "FixedPrice", "NULL", True)>
						<cfset structInsert(strPriceListComponent, "SellPrice", "NULL", True)>
						<cfif isMasterPriceList>
							<cfset structInsert(strPriceListComponent, "Active", 1, True)>
						<cfelse>
							<cfset structInsert(strPriceListComponent, "Active", 0, True)>
						</cfif>
						<cfset PriceListComponentID = objPriceListComponents.saveRecord(strPriceListComponent)>
					</cfif>
				</cfloop>
				<cfif ItemAdded>
					<cfset ImportCount = ImportCount + 1>
				</cfif>
			</cfif>
		</cfloop>
		
		<!--- Loop through all components in all price lists.  If the component is no longer marked as "configurable" in ACCPAC,
			  remove it from the price list --->			  
		<cfset qryPriceListComponents = objPriceListComponents.listRecords()>
		<cfloop query="qryPriceListComponents">
			<cfif NOT isItemConfigurable(qryPriceListComponents.ITEMNO)>
				<cfset objPriceListComponents.deleteRecord(qryPriceListComponents.PriceListComponentID)>
			</cfif>
		</cfloop>

		<!--- Loop through all components in all configurations.  If the component is no longer marked as "configurable" in ACCPAC,
			  remove it from the configuration --->
		<cfset qryConfigComponents = objConfigComponents.listRecords()>
		<cfloop query="qryConfigComponents">
			<cfif trim(qryConfigComponents.ITEMNO) IS NOT "[NONE]" AND NOT isItemConfigurable(qryConfigComponents.ITEMNO)>
				<cfset objConfigComponents.deleteRecord(qryConfigComponents.ConfigComponentID)>
			</cfif>
		</cfloop>

		<cfreturn ImportCount>
	</cffunction>

	<cffunction name="importCategoryDescriptions" access="public" output="no">
		<cfset objPriceListCategories = createObject("component", "admin.assets.cfcs.prices.PriceListCategories")>
		<cfset objComponentCategories = createObject("component", "admin.assets.cfcs.config.ComponentCategories")>
		<cfset qryPriceListCategories = objPriceListCategories.listRecords()>
		<cfloop query="qryPriceListCategories">
			<cfset CURRENTPriceListCategoryID = qryPriceListCategories.PriceListCategoryID>
			<cfset NewCategoryDescription = objComponentCategories.getACCPACCategoryDescription(qryPriceListCategories.CATEGORY)>
			<cfset strPriceListCategory = objPriceListCategories.getRecord(CURRENTPriceListCategoryID)>
			<cfset structInsert(strPriceListCategory, "CategoryDescription", NewCategoryDescription, True)>
			<cfset objPriceListCategories.saveRecord(strPriceListCategory)>
		</cfloop>
	</cffunction>

	<cffunction name="isItemConfigurable" access="public" returntype="boolean" output="No">
	<cfargument name="ITEMNO" type="string" required="No">
		<cfset var ItemIsConfigurable = 0>
		<cfquery datasource="#APPLICATION.DSN_AP#" name="qryItem">
		SELECT 	dbo.ICITEM.ITEMNO, dbo.ICITEM.ALLOWONWEB
		FROM 	dbo.ICITEM
		WHERE	dbo.ICITEM.ITEMNO = '#trim(Arguments.ITEMNO)#'
		</cfquery>
		<cfif qryItem.RecordCount GT 0 AND qryItem.ALLOWONWEB EQ 1>
			<cfset ItemIsConfigurable = 1>
		</cfif>
		<cfreturn ItemIsConfigurable>
	</cffunction>
	
	<cffunction name="createNewPriceList" access="public" returntype="string" output="YES">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var NewPriceListID = "">
		<cfset objPriceListCategories = createObject("component", "admin.assets.cfcs.prices.PriceListCategories")>
		<cfset objPriceListComponents = createObject("component", "admin.assets.cfcs.prices.PriceListComponents")>

		<cfset strPriceListCOPY = getRecord(Arguments.Record.COPYPriceListID)>
		
		<!--- Create the record in tblPriceLists --->
		<cfset NewPriceListName = strPriceListCOPY.Name & " [New]">
		<cfif strPriceListCOPY.MasterPriceList EQ 1>
			<cfset NewPriceListName = "[New Price List]">
		</cfif>
		<cfset strPriceListNEW = newRecord()>
		<cfset structInsert(strPriceListNEW, "UserID", getSessionValue("adminuserid"), True)>
		<cfset structInsert(strPriceListNEW, "Name", NewPriceListName, True)>
		<cfset structInsert(strPriceListNEW, "Description", strPriceListCOPY.Description, True)>
		<cfset structInsert(strPriceListNEW, "MasterPriceList", 0, True)>
<!---	<cfset structDelete(strPriceListNEW, "MarkupPercent")>	--->
		<cfset structInsert(strPriceListNEW, "MarkupPercent", strPriceListCOPY.MarkupPercent, True)>
		<cfset structInsert(strPriceListNEW, "DefaultPriceList", 0, True)>
		<cfset NEWPriceListID = saveRecord(strPriceListNEW)>
		
		<!--- Create the records in tblPriceListCategories --->
		<cfset qryPriceListCategoriesCOPY = objPriceListCategories.listRecordsForParent("PriceListID", strPriceListCOPY.PriceListID)>
		<cfloop query="qryPriceListCategoriesCOPY">
			<cfset strPriceListCategoryNEW = objPriceListCategories.newRecord()>
			<cfset structInsert(strPriceListCategoryNEW, "PriceListID", NEWPriceListID, True)>
			<cfset structInsert(strPriceListCategoryNEW, "CATEGORY", qryPriceListCategoriesCOPY.CATEGORY, True)>
			<cfset structInsert(strPriceListCategoryNEW, "CategoryDescription", qryPriceListCategoriesCOPY.CategoryDescription, True)>
<!---		<cfset structDelete(strPriceListCategoryNEW, "MarkupPercent")>	--->
			<cfset structInsert(strPriceListCategoryNEW, "MarkupPercent", qryPriceListCategoriesCOPY.MarkupPercent, True)>
			<cfset structInsert(strPriceListCategoryNEW, "SortOrder", qryPriceListCategoriesCOPY.SortOrder, True)>
			<cfset NEWPriceListCategoryID = objPriceListCategories.saveRecord(strPriceListCategoryNEW)>
			<!--- Create the records in tblPriceListComponents --->
			<cfset qryPriceListComponentsCOPY = objPriceListComponents.listRecordsForParent("PriceListCategoryID", qryPriceListCategoriesCOPY.PriceListCategoryID)>
			<cfloop query="qryPriceListComponentsCOPY">
				<cfset strPriceListComponentNEW = objPriceListComponents.newRecord()>
				<cfset structInsert(strPriceListComponentNEW, "PriceListCategoryID", NEWPriceListCategoryID, True)>
				<cfset structInsert(strPriceListComponentNEW, "ITEMNO", qryPriceListComponentsCOPY.ITEMNO, True)>
<!---			<cfset structDelete(strPriceListComponentNEW, "SellPrice")>	--->
				<cfset structInsert(strPriceListComponentNEW, "SellPrice", qryPriceListComponentsCOPY.SellPrice, True)>
<!---			<cfset structDelete(strPriceListComponentNEW, "FixedPrice")>	--->
				<cfset structInsert(strPriceListComponentNEW, "FixedPrice", qryPriceListComponentsCOPY.FixedPrice, True)>
				<cfset structInsert(strPriceListComponentNEW, "Active", qryPriceListComponentsCOPY.Active, True)>
				<cfset NEWPriceListComponentID = objPriceListComponents.saveRecord(strPriceListComponentNEW)>
			</cfloop>
		</cfloop>
		<cfreturn NewPriceListID>
	</cffunction>

	<cffunction name="listAssignedResellers" access="public" returntype="query" output="no">
	<cfargument name="PriceListID" type="string" required="Yes">
		<cfquery name="qryResellers" datasource="#This.DataSourceName#">
		SELECT	*
		FROM	login
		WHERE	PriceListID = '#Arguments.PriceListID#'
		ORDER BY Company, firstname, lastname
		</cfquery>
		<cfreturn qryResellers>
	</cffunction>

	<cffunction name="checkPriceListAssigned" access="public" returntype="boolean" output="no">
	<cfargument name="PriceListID" type="string" required="Yes">
		<cfset var listIsAssignedToResellers = 0>
		<cfset qryLogin = listAssignedResellers(Arguments.PriceListID)>
		<cfif qryLogin.RecordCount GT 0>
			<cfset listIsAssignedToResellers = 1>
		</cfif>
		<cfreturn listIsAssignedToResellers>
	</cffunction>

	<cffunction name="setDefaultPriceList" access="public" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfif Arguments.Record.DefaultPriceList EQ 1>
			<cfset qryPriceLists = listSalesRepPriceLists()>
			<cfloop query="qryPriceLists">
				<cfif qryPriceLists.PriceListID IS NOT Arguments.Record.PriceListID>
					<cfset strPriceList = getRecord(qryPriceLists.PriceListID)>
					<cfset structInsert(strPriceList, "DefaultPriceList", 0, True)>
					<cfset saveRecord(strPriceList)>
				</cfif>
			</cfloop>
		</cfif>
	</cffunction>

	<cffunction name="deleteRecord" access="public" output="No">
	<cfargument name="RecordID" type="string" required="Yes">
		<cfset objPriceListCategories = createObject("component", "admin.assets.cfcs.prices.PriceListCategories")>
		<cfset strPriceListOLD = getRecord(Arguments.RecordID)>
		<cfset super.deleteRecord(Arguments.RecordID)>
		<!--- Delete children records in tblPriceListCategories --->
		<cfset qryPriceListCategories = objPriceListCategories.listRecordsForParent("PriceListID",Arguments.RecordID)>
		<cfloop query="qryPriceListCategories">
			<cfset objPriceListCategories.deleteRecord(qryPriceListCategories.PriceListCategoryID)>
		</cfloop>
		<cfreturn>
	</cffunction>

	<cffunction name="saveMarkupPercentage" access="public" returntype="string" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var PriceListID = Arguments.Record.PriceListID>
		<cfset stRecord = Arguments.Record>
		<cfif structKeyExists(stRecord, "MarkupPercent")>
			<cfset MarkupPercentValue = trim(stRecord.MarkupPercent)>
			<cfif MarkupPercentValue IS NOT "" AND (NOT isNumeric(MarkupPercentValue) OR MarkupPercentValue LT 0)>
				<cfset PriceListID = "ERROR|MARKUP_PERCENT">
			<cfelse>
				<cfset strPriceList = getRecord(stRecord.PriceListID)>
				<cfif MarkupPercentValue IS "">
					<cfset structInsert(strPriceList, "MarkupPercent", "NULL", True)>
				<cfelseif isNumeric(MarkupPercentValue)>
					<cfset structInsert(strPriceList, "MarkupPercent", MarkupPercentValue, True)>
				</cfif>
				<cfset PriceListID = saveRecord(strPriceList)>
			</cfif>
		</cfif>
		<cfreturn PriceListID>
	</cffunction>

	<cffunction name="calculateSellingPrices" access="public" output="No">
	<cfargument name="PriceListID" type="string" required="Yes">
		<cfset objPriceListCategories = createObject("component", "admin.assets.cfcs.prices.PriceListCategories")>
		<cfset qryPriceListCategories = objPriceListCategories.listRecordsForParent("PriceListID", Arguments.PriceListID)>
		<cfloop query="qryPriceListCategories">
			<cfset objPriceListCategories.calculateSellingPrices(qryPriceListCategories.PriceListCategoryID)>
		</cfloop>
	</cffunction>
	
	<cffunction name="getMasterPriceListMarkupPercent" access="public" returntype="any" output="no">
		<cfset var MasterPriceListMarkupPercent = "">
		<cfset strMasterPriceList = getRecord("MASTERPRICELISTUUID")>
		<cfif isNumeric(strMasterPriceList.MarkupPercent)>
			<cfset MasterPriceListMarkupPercent = strMasterPriceList.MarkupPercent>
		</cfif>
		<cfreturn MasterPriceListMarkupPercent>
	</cffunction>


	<cffunction name="customerFormattedPriceList" access="public" returntype="string" output="No">
	<cfargument name="PriceListID" type="string" required="Yes">
	<cfargument name="ExportableConfigurator" type="boolean" required="no">
	<cfargument name="CustID" type="string" required="no">
<!---<cfargument name="MarkupPercentage" type="string" required="no">--->
		<cfset var PriceListText = "">
		<cfset objPriceListCategories = createObject("component", "admin.assets.cfcs.prices.PriceListCategories")>
		<cfset objPriceListComponents = createObject("component", "admin.assets.cfcs.prices.PriceListComponents")>
		<cfset objSalesRep = createObject("component", "admin.assets.cfcs.SalesRep")>
		<cfset objLogin = createObject("component", "admin.assets.cfcs.Cust")>
		<cfset objPartsAdmin = createObject("component", "admin.assets.cfcs.parts.PartsAdmin")>

		<cfif NOT isDefined("Arguments.ExportableConfigurator")>
			<cfset Arguments.ExportableConfigurator = 0>
		</cfif>

		<cfif Arguments.ExportableConfigurator>
			<cfset strLogin = objLogin.getRecordAsStruct(Arguments.CustID)>
		</cfif>
		
		<cfset qryPriceListCategories = objPriceListCategories.listRecordsForParent("PriceListID", Arguments.PriceListID, "SortOrder")>

		<cfset strPriceList = getRecord(Arguments.PriceListID)>
		<cfset strSalesRep = objSalesRep.getSalesRepByUserID(strPriceList.UserID)>
		
		<cfsavecontent variable="PriceListText">
			<cfoutput>

				<table width="80%" border="0" cellpadding="3" cellspacing="1">
					<tr>
						<td height="18" style="font-size:14px; font-weight:bold;" colspan="3">
							<cfif NOT Arguments.ExportableConfigurator>
								Nor-Tech 
							<cfelseif isDefined("strLogin.company")>
								#strLogin.company#
							</cfif>
							Customer Price List, #dateFormat(now(), 'mmmm d, yyyy')#
						</td>
					</tr>
					<tr>
						<td colspan="3">
							<table width="100%" border="0" cellpadding="3" cellspacing="2">
								<tr>
									<cfif NOT Arguments.ExportableConfigurator>
										<td width="50%" valign="top" align="center" style="font-size:12px; font-weight:bold;">
											<img src="https://www.nor-tech.com/images/logo.gif" alt="" name="logo" width="150" border="0"><br>
											www.nor-tech.com
										</td>
									</cfif>
									<td style="font-size:12px" valign="top">
										<cfif NOT Arguments.ExportableConfigurator>
											#strSalesRep.repname#<br>
											#strSalesRep.repemail#<br>
											#strSalesRep.repphone#<br>
	<!---									(877) 808-1010	--->
										<cfelse>
											<cfif isDefined("strLogin.firstname") AND isDefined("strLogin.lastname")>
												#strLogin.firstname# #strLogin.lastname#<br>
											</cfif>
											<cfif isDefined("strLogin.email")>
												#strLogin.email#<br>
											</cfif>
											<cfif isDefined("strLogin.PhoneNumber")>
												#strLogin.PhoneNumber#<br>
											</cfif>
										</cfif>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					
					<cfloop query="qryPriceListCategories">
						<cfset qryPriceListComponents = objPriceListComponents.getComponentsForCustomerPriceList(qryPriceListCategories.PriceListCategoryID)>
						<cfif qryPriceListComponents.RecordCount GT 0>
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td height="18" bgcolor="990000" style="font-size:12px; font-weight:bold; color:FFFFFF" colspan="3" align="center">
									#qryPriceListCategories.CategoryDescription#
								</td>
							</tr>
							<tr>
								<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF">Part ##</td>
								<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF">Description</font></td>
								<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" align="center">Price</td>
							</tr>
							<cfloop query="qryPriceListComponents">
								<cfif NOT objPartsAdmin.isGarageSaleItem(qryPriceListComponents.ITEMNO)>
									<tr<cfif qryPriceListComponents.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
										<!--- PART NUMBER --->
										<td style="font-size:10px">#qryPriceListComponents.ITEMNO#</td>
										
										<!--- PART DESCRIPTION --->
										<cfset ItemDescription = trim(objPriceListComponents.getItemDescription(qryPriceListComponents.ITEMNO))>
										<td style="font-size:10px">#ItemDescription#</td>
										
										<!--- SELLING PRICE --->
										<cfset SellingPrice =  qryPriceListComponents.SellPrice>
										<cfif Arguments.ExportableConfigurator AND 
											  isDefined("strLogin.PercentComponents") AND
											  isNumeric(strLogin.PercentComponents)>
											<cfset SellingPrice = ceiling(SellingPrice + qryPriceListComponents.SellPrice * strLogin.PercentComponents)>
										</cfif>
										<td style="font-size:10px" align="center">
											#dollarFormat(SellingPrice)#
										</td>
									</tr>
								</cfif>
							</cfloop>
						</cfif>
					</cfloop>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td height="18" style="font-size:12px; font-weight:bold;" colspan="3">
							<em>Price and availability subject to change without notice.  Not responsible for typographical errors.</em>
						</td>
					</tr>
				</table>
			</cfoutput>
		</cfsavecontent>
		<cfreturn PriceListText>
	</cffunction>

	<!--- ******************************************************* --->
	<!--- I believe the following functions are NOT being used.   --->
	<!--- 5/24/07, Ron Barth									  --->
	<!--- ******************************************************* --->

	<cffunction name="copyPriceList" access="public" returntype="string" output="No">
	<cfargument name="PriceListID" type="string" required="Yes">
		<cfset var NewPriceListID = "">
		<cfset objPriceListCategories = createObject("component", "admin.assets.cfcs.config.PriceListCategories")>

		<!--- Make copy of tblPriceLists --->
		<cfset strOldSystem = getRecord(Arguments.PriceListID)>
		<cfset strNewSystem = newRecord()>
		<cfloop list="#This.Columns#" index="Column">
			<cfif Column IS "Name">
				<cfset NewName = strOldSystem.Name & " [copy]">
				<cfset structInsert(strNewSystem, "Name", NewName, True)>
			<cfelseif Column IS NOT "PriceListID">
				<cfset structInsert(strNewSystem, Column, strOldSystem[Column], True)>
			</cfif>
		</cfloop>
		<cfset NewPriceListID = saveRecord(strNewSystem)>

		<!--- Create records in tblPriceListCategories --->
		<cfset objPriceListCategories.copyPriceListCategories(strOldSystem.PriceListID, NewPriceListID)>

		<cfreturn NewPriceListID>
	</cffunction>

	<cffunction name="copyMasterPriceList" access="public" output="No">
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "MasterPriceList", 1, True)>
		<cfset qryMasterPriceList = searchRecords(SearchRecord, "query")>
		<cfset NewPriceListID = copyPriceList(qryMasterPriceList.PriceListID)>
		<cfset strNewPriceList = getRecord(NewPriceListID)>
		<cfset structInsert(strNewPriceList, "UserID", getSessionValue("adminuserid"), True)>
		<cfset structInsert(strNewPriceList, "Name", qryMasterPriceList.Name, True)>
		<cfset structInsert(strNewPriceList, "MasterPriceList", 0, True)>
		<cfset Variables.PriceListID = saveRecord(strNewPriceList)>
	</cffunction>
	

</cfcomponent>