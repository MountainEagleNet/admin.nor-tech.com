<cfcomponent extends="admin.assets.cfcs.Component">

	<cfif isDefined("APPLICATION.DSN_WWW")>
		<cfset This.DataSourceName = APPLICATION.DSN_WWW>
	<cfelse>
    	<cfset This.DataSourceName = "NorTechWWW">
    </cfif>

	<cfif isDefined("APPLICATION.AdminLocation")>
		<cfset CURRENT_AdminLocation = APPLICATION.AdminLocation>
	<cfelse>
		<cfset CURRENT_AdminLocation = "admin">
	</cfif>

	<cfset This.TableName = "tblPriceListComponents">
	<cfset This.ViewName = "vPriceListComponents">

	<cfset This.Columns = "PriceListComponentID,PriceListCategoryID,ITEMNO,Description,SellPrice,FixedPrice,FixedMarkup,PercentMarkup,Active">
	<cfset This.ViewColumns = "PriceListComponentID,PriceListCategoryID,CategoryMarkUpPercent,CATEGORY,CategoryDescription,PriceListID,PriceListName,PriceListMarkUpPercent,ITEMNO,Description,SellPrice,FixedPrice,FixedMarkup,PercentMarkup,Active">
	
	<cfset This.PrimaryKey = "PriceListComponentID">
	
	<cfset This.GenerateUUIDKey = 1>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "PriceListName">
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

	<cffunction name="copyPriceListComponents" access="public" output="No">
	<cfargument name="OldPriceListCategoryID" type="string" required="Yes">
	<cfargument name="NewPriceListCategoryID" type="string" required="Yes">
		<cfset qryOrigPriceListComponents = listRecordsForParent("PriceListCategoryID", Arguments.OldPriceListCategoryID)>
		<cfloop query="qryOrigPriceListComponents">
			<cfset strNewPriceListComponents = newRecord()>
			<cfloop list="#This.Columns#" index="Column">
				<cfif Column IS "PriceListCategoryID">
					<cfset structInsert(strNewPriceListComponents, "PriceListCategoryID", Arguments.NewPriceListCategoryID, True)>
				<cfelseif Column IS NOT "PriceListComponentID">
					<cfset structInsert(strNewPriceListComponents, Column, qryOrigPriceListComponents[Column], True)>
				</cfif>
			</cfloop>
			<cfset NewPriceListComponentID = saveRecord(strNewPriceListComponents)>
		</cfloop>
	</cffunction>

	<!----------------------------------------------------------------------------------------------------------------------->
	<cffunction name="assignComponents" access="public" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var lstRecord = "">
        <cfset var Column = "">
        <cfset var THISPriceListComponentID = "">
        <cfset var ActiveField = "">
        <cfset var ActiveValue = "">

		<cfset lstRecord = structKeyList(Arguments.Record)>
        <cfloop list="#lstRecord#" index="Column">
        	<cfif findNoCase("ITEMNO|", Column) NEQ 0>
            	<cfset THISPriceListComponentID = removeChars(Column, 1, 7)>
                <cfset ActiveField = "ACTIVE|" & THISPriceListComponentID>
                <cfif structKeyExists(Arguments.Record, ActiveField)>
					<cfset ActiveValue = 1>
                <cfelse>
					<cfset ActiveValue = 0>
                </cfif>
                
                <cfquery datasource="#This.DataSourceName#">
                UPDATE 	tblPriceListComponents
                SET 	Active = #ActiveValue#
                WHERE 	PriceListComponentID = '#THISPriceListComponentID#'
                </cfquery>

            </cfif>
        </cfloop>
        
<!--- OLD method.  Saved 1/17/2013
		<cfset qryPriceListComponents = listRecordsForParent("PriceListCategoryID", Arguments.Record.PriceListCategoryID)>
		<cfloop query="qryPriceListComponents">
			<cfset CURRENTPriceListComponentID = qryPriceListComponents.PriceListComponentID>
			<cfset ColumnName = "ACTIVE|" & CURRENTPriceListComponentID>
			<cfset strPriceListComponent = getRecord(CURRENTPriceListComponentID)>
			<cfif structKeyExists(Arguments.Record, ColumnName)>
				<cfset structInsert(strPriceListComponent, "Active", 1, True)>
			<cfelse>
				<cfset structInsert(strPriceListComponent, "Active", 0, True)>
			</cfif>
			<cfset structDelete(strPriceListComponent, "FixedPrice")>
			<cfset structDelete(strPriceListComponent, "SellPrice")>
			<cfset saveRecord(strPriceListComponent)>
		</cfloop>
--->        
        
	</cffunction>

	<!----------------------------------------------------------------------------------------------------------------------->
	<cffunction name="saveRecord" access="public" returntype="string" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var RecordID = "">
		<cfif structKeyExists(Arguments.Record, "FixedPrice") AND trim(Arguments.Record.FixedPrice) IS "">
			<cfset structInsert(Arguments.Record, "FixedPrice", "NULL", True)>
		</cfif>
		<cfif structKeyExists(Arguments.Record, "FixedMarkup") AND trim(Arguments.Record.FixedMarkup) IS "">
			<cfset structInsert(Arguments.Record, "FixedMarkup", "NULL", True)>
		</cfif>
		<cfif structKeyExists(Arguments.Record, "PercentMarkup") AND trim(Arguments.Record.PercentMarkup) IS "">
			<cfset structInsert(Arguments.Record, "PercentMarkup", "NULL", True)>
		</cfif>
		<cfset RecordID = super.saveRecord(Arguments.Record)>
		<cfreturn RecordID>
	</cffunction>

	<!----------------------------------------------------------------------------------------------------------------------->
	<cffunction name="saveFixedPrice" access="public" returntype="string" output="no">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var PriceListComponentID = "">
		<cfset var FixedPriceValue = "">
		<cfset var FixedMarkupValue = "">
		<cfset var PercentMarkupValue = "">
		<cfset var stRecord = Arguments.Record>
		<cfset var lstRecord = "">
		<cfset var Column = "">
		<cfset var ColumnValue = "">
		<cfset var PercentMarkupField = "">
		<cfset var FixedMarkupField = "">
		<cfset var FixedPriceField = "">
		<cfset var strPriceListComponent = structNew()>

		<cfset lstRecord = structKeyList(stRecord)>
		<cfloop list="#lstRecord#" index="Column">
			<cfif findNoCase("UPDATE|", Column) NEQ 0>
				<cfset ColumnValue = stRecord[Column]>
				<cfif ColumnValue IS "1">
					<cfset PriceListComponentID = removeChars(Column, 1, 7)>
					<cfbreak>
				</cfif>
			</cfif>
		</cfloop>

		<!--- SAVE PERCENT MARKUP --->
		<cfset PercentMarkupField = "PCT|" & PriceListComponentID>
		<cfif structKeyExists(stRecord, PercentMarkupField)>
			<cfset PercentMarkupValue = trim(stRecord[PercentMarkupField])>
			<cfif PercentMarkupValue IS NOT "" AND (NOT isNumeric(PercentMarkupValue) OR PercentMarkupValue LT 0)>
				<cfset PriceListComponentID = "ERROR|FIXED_PRCNT|" & PriceListComponentID>
			</cfif>
		</cfif>

		<!--- SAVE FIXED MARKUP --->
		<cfset FixedMarkupField = "MRK|" & PriceListComponentID>
		<cfif structKeyExists(stRecord, FixedMarkupField)>
			<cfset FixedMarkupValue = trim(stRecord[FixedMarkupField])>
			<cfif FixedMarkupValue IS NOT "" AND (NOT isNumeric(FixedMarkupValue) OR FixedMarkupValue LT 0)>
				<cfset PriceListComponentID = "ERROR|FIXED_MRKUP|" & PriceListComponentID>
<!---
			<cfelse>
				<cfset strPriceListComponent = getRecord(PriceListComponentID)>
				<cfif FixedMarkupValue IS "">
					<cfset structInsert(strPriceListComponent, "FixedMarkup", "NULL", True)>
				<cfelseif isNumeric(FixedMarkupValue)>
					<cfset structInsert(strPriceListComponent, "FixedMarkup", FixedMarkupValue, True)>
				</cfif>
				<cfset saveRecord(strPriceListComponent)>
--->
			</cfif>
		</cfif>

		<!--- SAVE FIXED PRICE --->
		<cfset FixedPriceField = "FIX|" & PriceListComponentID>
		<cfif structKeyExists(stRecord, FixedPriceField)>
			<cfset FixedPriceValue = trim(stRecord[FixedPriceField])>
			<cfif FixedPriceValue IS NOT "" AND (NOT isNumeric(FixedPriceValue) OR FixedPriceValue LT 0)>
				<cfset PriceListComponentID = "ERROR|FIXED_PRICE|" & PriceListComponentID>
<!---
			<cfelse>
				<cfset strPriceListComponent = getRecord(PriceListComponentID)>
				<cfif FixedPriceValue IS "">
					<cfset structInsert(strPriceListComponent, "FixedPrice", "NULL", True)>
				<cfelseif isNumeric(FixedPriceValue)>
					<cfset structInsert(strPriceListComponent, "FixedPrice", FixedPriceValue, True)>
				</cfif>
				<cfset saveRecord(strPriceListComponent)>
--->
			</cfif>
		</cfif>
		
		
		
		<cfif findNoCase('ERROR|FIXED_', PriceListComponentID) EQ 0>
			<cfset strPriceListComponent = getRecord(PriceListComponentID)>
			<cfif FixedPriceValue IS "">
				<cfset structInsert(strPriceListComponent, "FixedPrice", "NULL", True)>
			<cfelseif isNumeric(FixedPriceValue)>
				<cfset structInsert(strPriceListComponent, "FixedPrice", FixedPriceValue, True)>
			</cfif>
			<cfif FixedMarkupValue IS "">
				<cfset structInsert(strPriceListComponent, "FixedMarkup", "NULL", True)>
			<cfelseif isNumeric(FixedMarkupValue)>
				<cfset structInsert(strPriceListComponent, "FixedMarkup", FixedMarkupValue, True)>
			</cfif>
			<cfif PercentMarkupValue IS "">
				<cfset structInsert(strPriceListComponent, "PercentMarkup", "NULL", True)>
			<cfelseif isNumeric(PercentMarkupValue)>
				<cfset structInsert(strPriceListComponent, "PercentMarkup", PercentMarkupValue, True)>
			</cfif>
			
			<cfset saveRecord(strPriceListComponent)>
		</cfif>
			
		<cfreturn PriceListComponentID>
	</cffunction>

	<!---------------------------------------------------------------------------------------------------------------->
	<cffunction name="calculateSellingPrice" access="public" output="No">
	<cfargument name="PriceListComponentID" type="string" required="Yes">
		<cfset objPriceLists = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.prices.PriceLists")>

		<cfset strPriceListComponent = getRecord(Arguments.PriceListComponentID)>
		<cfset ACCPACCost = getItemCost(strPriceListComponent.ITEMNO)>
		<cfset MasterPriceListMarkupPercent = objPriceLists.getMasterPriceListMarkupPercent()>

		<!--- COMPONENT FIXED PRICE --->
		<cfif strPriceListComponent.FixedPrice IS NOT "">
			<cfset NewSellPrice = strPriceListComponent.FixedPrice>

		<!--- COMPONENT FIXED MARKUP --->
		<cfelseif strPriceListComponent.FixedMarkup IS NOT "">
			<cfset NewSellPrice = ACCPACCost + strPriceListComponent.FixedMarkup>

		<!--- COMPONENT PERCENT MARKUP --->
		<cfelseif strPriceListComponent.PercentMarkup IS NOT "">
			<cfset NewSellPrice = ACCPACCost + (ACCPACCost * strPriceListComponent.PercentMarkup) / 100>

		<!--- CATEGORY MARKUP PERCENT --->
		<cfelseif strPriceListComponent.CategoryMarkupPercent IS NOT "">
			<cfset NewSellPrice = ACCPACCost + (ACCPACCost * strPriceListComponent.CategoryMarkupPercent) / 100>

		<!--- PRICE LIST MARKUP PERCENT --->
		<cfelseif strPriceListComponent.PriceListMarkupPercent IS NOT "">
			<cfset NewSellPrice = ACCPACCost + (ACCPACCost * strPriceListComponent.PriceListMarkupPercent) / 100>

		<!--- MASTER PRICE LIST MARKUP PERCENT --->
		<cfelseif MasterPriceListMarkupPercent IS NOT "">
			<cfset NewSellPrice = ACCPACCost + (ACCPACCost * MasterPriceListMarkupPercent) / 100>

		<!--- COPY ACCPAC COST TO SELL PRICE --->
		<cfelse>
			<cfset NewSellPrice = ACCPACCost>
		</cfif>
		
		<cfquery datasource="#This.DataSourceName#">
		UPDATE 	#This.TableName#
		SET 	SellPrice = #ceiling(NewSellPrice)#
		WHERE 	#This.PrimaryKey# = '#Arguments.PriceListComponentID#'
		</cfquery>

		<!--- UPDATE tblComponentPrices --->
		<cfquery datasource="#This.DataSourceName#">
		UPDATE 	tblComponentPrices
		SET 	Price = #ceiling(NewSellPrice)#
		WHERE 	PriceListID = '#strPriceListComponent.PriceListID#' AND
        		ITEMNO = '#strPriceListComponent.ITEMNO#'
		</cfquery>
        
<!---		
		<cfset structInsert(strPriceListComponent, "SellPrice", ceiling(NewSellPrice), True)>
		<cfset saveRecord(strPriceListComponent)>
--->		
	</cffunction>

	<!---------------------------------------------------------------------------------------------------------------->
	<cffunction name="getSellingPrice" access="public" returntype="numeric" output="No">
	<cfargument name="PriceListID" type="string" required="Yes">
	<cfargument name="ITEMNO" type="string" required="Yes">
		<cfset var ItemSellPrice = 0>
		<cfset var qryPriceListComponents = queryNew("")>

		<cfset objConfigComponents = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ConfigComponents")>
		<cfset SellPriceFound = 0>

		<cfif trim(Arguments.ITEMNO) IS "[NONE]">
			<cfset ItemSellPrice = 0>
			<cfset SellPriceFound = 1>
		</cfif>

		<cfif NOT SellPriceFound>
			<!--- Get Sell Price from Price List --->
<!---			
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "PriceListID", Arguments.PriceListID, True)>
			<cfset structInsert(SearchRecord, "ITEMNO", trim(Arguments.ITEMNO), True)>
<!---		<cfset structInsert(SearchRecord, "Active", 1, True)>	--->	<!---RAB 12/31/07--->
			<cfset qryPriceListComponents = searchRecords(SearchRecord)>
--->			
<!---
			<cfquery datasource="#This.DataSourceName#" name="qryPriceListComponents">
			SELECT	tblPriceListComponents.SellPrice
			FROM 	tblPriceListComponents
					INNER JOIN tblPriceListCategories ON 
						tblPriceListComponents.PriceListCategoryID = tblPriceListCategories.PriceListCategoryID
			WHERE	tblPriceListCategories.PriceListID = '#Arguments.PriceListID#' AND
					tblPriceListComponents.ITEMNO = '#trim(Arguments.ITEMNO)#'
			</cfquery>
--->			
			<cfstoredproc procedure="spr_get_SellPrice" datasource="#This.DataSourceName#" blockfactor="15" returncode="Yes">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" variable="@PriceListID" dbvarname="@PriceListID" value="#Arguments.PriceListID#" maxlength="50" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" variable="@ITEMNO" dbvarname="@ITEMNO" value="#Arguments.ITEMNO#" maxlength="50" null="No">
				<cfprocresult name="qryPriceListComponents" resultset="1">
			</cfstoredproc>
			
			<cfif qryPriceListComponents.RecordCount NEQ 0>
				<cfif isNumeric(qryPriceListComponents.SellPrice) AND qryPriceListComponents.SellPrice GT 0>
					<cfset ItemSellPrice = qryPriceListComponents.SellPrice>
					<cfset SellPriceFound = 1>
				</cfif>
			</cfif>
		</cfif>
		
		<cfif NOT SellPriceFound>

			<!--- If above wasn't successful, then get Sell Price from Master Price List --->
<!---
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "PriceListID", "MASTERPRICELISTUUID", True)>
			<cfset structInsert(SearchRecord, "ITEMNO", trim(Arguments.ITEMNO), True)>
<!---		<cfset structInsert(SearchRecord, "Active", 1, True)>	--->	<!---RAB 12/31/07--->
			<cfset qryPriceListComponents = searchRecords(SearchRecord)>
--->
<!---
			<cfquery datasource="#This.DataSourceName#" name="qryPriceListComponents">
			SELECT	tblPriceListComponents.SellPrice
			FROM 	tblPriceListComponents
					INNER JOIN tblPriceListCategories ON 
						tblPriceListComponents.PriceListCategoryID = tblPriceListCategories.PriceListCategoryID
			WHERE	tblPriceListCategories.PriceListID = 'MASTERPRICELISTUUID' AND
					tblPriceListComponents.ITEMNO = '#trim(Arguments.ITEMNO)#'
			</cfquery>
--->
			<cfstoredproc procedure="spr_get_SellPrice" datasource="#This.DataSourceName#" blockfactor="15" returncode="Yes">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" variable="@PriceListID" dbvarname="@PriceListID" value="MASTERPRICELISTUUID" maxlength="50" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" variable="@ITEMNO" dbvarname="@ITEMNO" value="#Arguments.ITEMNO#" maxlength="50" null="No">
				<cfprocresult name="qryPriceListComponents" resultset="1">
			</cfstoredproc>


			<cfif qryPriceListComponents.RecordCount NEQ 0>
				<cfif isNumeric(qryPriceListComponents.SellPrice) AND qryPriceListComponents.SellPrice GT 0>
					<cfset ItemSellPrice = qryPriceListComponents.SellPrice>
					<cfset SellPriceFound = 1>
				</cfif>
			</cfif>
		</cfif>
		
		<!--- Last-ditch effort:  If selling price is still not found, just use the ACCPAC cost marked up by 15% --->
		<cfif NOT SellPriceFound>
			<cfset ItemCost = objConfigComponents.getItemCost(trim(Arguments.ITEMNO))>
			<cfset ItemSellPrice = ItemCost + ItemCost * .15>
		</cfif>

		<cfreturn ItemSellPrice>
	</cffunction>

	<cffunction name="markUpSellingPrice" access="public" returntype="numeric" output="No">
	<cfargument name="CustomerID" type="string" required="Yes">
	<cfargument name="ConfigComponentID" type="string" required="Yes">
	<cfargument name="PriceOfThisComponent" type="numeric" required="Yes">
		<cfset var NewPriceOfThisComponent = Arguments.PriceOfThisComponent>
		<cfset objCust = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.Cust")>
		<cfset objConfigComponents = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ConfigComponents")>
		<!--- For the Exportable Configurator, markup the Item cost by the reseller's markup percentage --->		
		<cfset qryLogin = objCust.getLoginRecord(Arguments.CustomerID)>
		<cfif qryLogin.RecordCount NEQ 0>
			<cfset strConfigComponent = objConfigComponents.getRecord(Arguments.ConfigComponentID)>

			<!--- MARGIN PERCENT --->
            <cfif qryLogin.MarkupType IS "Margin">
                <cfif strConfigComponent.SystemType IS "Workstation" AND isNumeric(qryLogin.PercentWorkstations)>
	                <cfset NewPriceOfThisComponent = Arguments.PriceOfThisComponent / (1 - qryLogin.PercentWorkstations)>
                <cfelseif strConfigComponent.SystemType IS "Notebook" AND isNumeric(qryLogin.PercentNotebooks)>
	                <cfset NewPriceOfThisComponent = Arguments.PriceOfThisComponent / (1 - qryLogin.PercentNotebooks)>
                <cfelseif strConfigComponent.SystemType IS "Server" AND isNumeric(qryLogin.PercentServers)>
	                <cfset NewPriceOfThisComponent = Arguments.PriceOfThisComponent / (1 - qryLogin.PercentServers)>
                <cfelseif strConfigComponent.SystemType IS "MiniMountablePC" AND isNumeric(qryLogin.PercentMiniMountablePCs)>
	                <cfset NewPriceOfThisComponent = Arguments.PriceOfThisComponent / (1 - qryLogin.PercentMiniMountablePCs)>
                </cfif>
            
            <!--- MARKUP PERCENTAGES --->
            <cfelse>
                <cfif strConfigComponent.SystemType IS "Workstation" AND isNumeric(qryLogin.PercentWorkstations)>
	                <cfset NewPriceOfThisComponent = Arguments.PriceOfThisComponent + Arguments.PriceOfThisComponent * qryLogin.PercentWorkstations>
                <cfelseif strConfigComponent.SystemType IS "Notebook" AND isNumeric(qryLogin.PercentNotebooks)>
					<cfset NewPriceOfThisComponent = Arguments.PriceOfThisComponent + Arguments.PriceOfThisComponent * qryLogin.PercentNotebooks>
                <cfelseif strConfigComponent.SystemType IS "Server" AND isNumeric(qryLogin.PercentServers)>
					<cfset NewPriceOfThisComponent = Arguments.PriceOfThisComponent + Arguments.PriceOfThisComponent * qryLogin.PercentServers>
                <cfelseif strConfigComponent.SystemType IS "MiniMountablePC" AND isNumeric(qryLogin.PercentMiniMountablePCs)>
					<cfset NewPriceOfThisComponent = Arguments.PriceOfThisComponent + Arguments.PriceOfThisComponent * qryLogin.PercentMiniMountablePCs>
                </cfif>
            </cfif>
            
		</cfif>
		
		<cfreturn NewPriceOfThisComponent>
	</cffunction>
	
	<cffunction name="getComponentsForCustomerPriceList" access="public" returntype="query" output="No">
	<cfargument name="PriceListCategoryID" type="string" required="Yes">
		<cfquery datasource="#This.DataSourceName#" name="qryRecords">
		SELECT 	#This.ViewColumns#
		FROM 	#This.ViewName#
		WHERE 	PriceListCategoryID = '#Arguments.PriceListCategoryID#' AND
				SellPrice <> '' AND
				Active = 1
		ORDER BY ITEMNO ASC 
		</cfquery>
		<cfreturn qryRecords>
	</cffunction>

	<!-------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="listComponents" access="public" returntype="query" output="YES">
	<cfargument name="PriceListCategoryID" type="string" required="Yes">
	<cfargument name="OrderByList" type="string" required="Yes">
		<cfset var qryRecords = queryNew("PriceListComponentID,Active,ITEMNO,AmountAvailable,ItemCost,SellPrice,FixedPrice,FixedMarkup,PercentMarkup","VarChar,Bit,VarChar,Integer,Decimal,Decimal,VarChar,VarChar,VarChar")>
		<cfset qryFinal = queryNew("PriceListComponentID,Active,ITEMNO,AmountAvailable,ItemCost,SellPrice,FixedPrice,FixedMarkup,PercentMarkup","VarChar,Bit,VarChar,Integer,Decimal,Decimal,VarChar,VarChar,VarChar")>
		<cfset qryPriceListComponents = listRecordsForParent("PriceListCategoryID", Arguments.PriceListCategoryID)>
		<cfloop query="qryPriceListComponents">
			<cfset queryAddRow(qryRecords)>
			<cfset querySetCell(qryRecords, "PriceListComponentID", qryPriceListComponents.PriceListComponentID)>
			<cfset querySetCell(qryRecords, "Active", qryPriceListComponents.Active)>
			<cfset querySetCell(qryRecords, "ITEMNO", qryPriceListComponents.ITEMNO)>
			<cfset querySetCell(qryRecords, "AmountAvailable", getCurrentAvailability(qryPriceListComponents.ITEMNO))>
			<cfset querySetCell(qryRecords, "ItemCost", getItemCost(qryPriceListComponents.ITEMNO))>
			<cfset querySetCell(qryRecords, "SellPrice", qryPriceListComponents.SellPrice)>
			<cfset querySetCell(qryRecords, "FixedPrice", qryPriceListComponents.FixedPrice)>
			<cfset querySetCell(qryRecords, "FixedMarkup", qryPriceListComponents.FixedMarkup)>
			<cfset querySetCell(qryRecords, "PercentMarkup", qryPriceListComponents.PercentMarkup)>
		</cfloop>

		<cfif qryRecords.RecordCount NEQ 0>
			<cfquery dbtype="query" name="qryFinal">
			SELECT 	*
			FROM	qryRecords
			ORDER BY #Arguments.OrderByList#
			</cfquery>
		</cfif>
		
		<cfreturn qryFinal>
	</cffunction>


	<!-------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="searchComponentsPrices" access="public" returntype="query" output="No">
	<cfargument name="PriceListID" type="string" required="Yes">
	<cfargument name="PriceListCategoryID" type="string" required="Yes">
	<cfargument name="SearchText" type="string" required="Yes">
	<cfargument name="OrderByList" type="string" required="No">
		<cfset var qryRecords = queryNew("PriceListComponentID,Active,ITEMNO,Description,AmountAvailable,ItemCost,SellPrice,FixedPrice,FixedMarkup,PercentMarkup","VarChar,Bit,VarChar,VarChar,Integer,Decimal,Decimal,VarChar,VarChar,VarChar")>        
    	<cfset var qryPriceListComponents = queryNew("")>
		<cfset var ACCPACDescription = "">
        
        <cfif NOT isDefined("Arguments.OrderByList")>
        	<cfset Arguments.OrderByList = "ITEMNO">
        </cfif>
<!---
		<cfset qryPriceListComponents = listRecordsForParent("PriceListCategoryID", Arguments.PriceListCategoryID, Arguments.OrderByList)>
--->

        <cfquery datasource="#This.DataSourceName#" name="qryPriceListComponents" result="RonTest">
        SELECT	tblPriceListComponents.PriceListComponentID, 
        		tblPriceListComponents.Active,
        		tblPriceListComponents.ITEMNO, 
                tblPriceListComponents.SellPrice,
                tblPriceListComponents.FixedPrice,
                tblPriceListComponents.FixedMarkup,
                tblPriceListComponents.PercentMarkup
                
        FROM    tblPriceListComponents INNER JOIN
                tblPriceListCategories ON tblPriceListCategories.PriceListCategoryID = tblPriceListComponents.PriceListCategoryID
                
        WHERE 	tblPriceListCategories.PriceListID = '#Arguments.PriceListID#' 
                <cfif Arguments.PriceListCategoryID IS NOT "">
                	AND tblPriceListComponents.PriceListCategoryID = '#Arguments.PriceListCategoryID#'
                </cfif>
		ORDER BY #Arguments.OrderByList#                 
        </cfquery>


		<cfloop query="qryPriceListComponents">
        	<cfset ACCPACDescription = getItemDescription(qryPriceListComponents.ITEMNO)>
			<cfif findNoCase(trim(Arguments.SearchText), ACCPACDescription) NEQ 0>
            	<cfset queryAddRow(qryRecords)>
                <cfset querySetCell(qryRecords, "PriceListComponentID", qryPriceListComponents.PriceListComponentID)>
				<cfset querySetCell(qryRecords, "Active", qryPriceListComponents.Active)>
                <cfset querySetCell(qryRecords, "ITEMNO", qryPriceListComponents.ITEMNO)>
                <cfset querySetCell(qryRecords, "AmountAvailable", getCurrentAvailability(qryPriceListComponents.ITEMNO))>
                <cfset querySetCell(qryRecords, "ItemCost", getItemCost(qryPriceListComponents.ITEMNO))>
                <cfset querySetCell(qryRecords, "SellPrice", qryPriceListComponents.SellPrice)>
                <cfset querySetCell(qryRecords, "Description", ACCPACDescription)>
                <cfset querySetCell(qryRecords, "FixedPrice", qryPriceListComponents.FixedPrice)>
                <cfset querySetCell(qryRecords, "FixedMarkup", qryPriceListComponents.FixedMarkup)>
                <cfset querySetCell(qryRecords, "PercentMarkup", qryPriceListComponents.PercentMarkup)>
            </cfif>
        </cfloop>
        
        <cfreturn qryRecords>
	</cffunction>

	<!-------------------------------------------------------------------------------------------------------------------------->
<!--- SAVED 1/15/2013
	<cffunction name="searchComponents" access="public" returntype="query" output="No">
	<cfargument name="PriceListID" type="string" required="Yes">
	<cfargument name="PriceListCategoryID" type="string" required="Yes">
	<cfargument name="SearchText" type="string" required="Yes">
	<cfargument name="OrderByList" type="string" required="No">
    	<cfset var qryPriceListComponents = queryNew("")>
        <cfif NOT isDefined("Arguments.OrderByList")>
        	<cfset Arguments.OrderByList = "ITEMNO">
        </cfif>
        <cfquery datasource="#This.DataSourceName#" name="qryPriceListComponents">
        SELECT	tblPriceListComponents.PriceListComponentID, tblPriceListComponents.ITEMNO, 
        		tblPriceListComponents.Description, tblPriceListComponents.SellPrice
        FROM    tblPriceListComponents INNER JOIN
                tblPriceListCategories ON tblPriceListCategories.PriceListCategoryID = tblPriceListComponents.PriceListCategoryID
        WHERE 	tblPriceListCategories.PriceListID = '#Arguments.PriceListID#' AND
        		tblPriceListComponents.Active = 1 AND
        		tblPriceListComponents.Description LIKE '%#trim(Arguments.SearchText)#%'
                <cfif Arguments.PriceListCategoryID IS NOT "">
                	AND tblPriceListComponents.PriceListCategoryID = '#Arguments.PriceListCategoryID#'
                </cfif>
		ORDER BY #Arguments.OrderByList#                 
        </cfquery>
        <cfreturn qryPriceListComponents>
	</cffunction>
--->

	<!-------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="searchComponents" access="public" returntype="query" output="No">
	<cfargument name="PriceListID" type="string" required="Yes">
	<cfargument name="PriceListCategoryID" type="string" required="Yes">
	<cfargument name="SearchText" type="string" required="Yes">
	<cfargument name="OrderByList" type="string" required="No">
		<cfset var qryFinal = queryNew("PriceListComponentID,ITEMNO,Description,SellPrice")>
    	<cfset var qryPriceListComponents = queryNew("")>
        
        <cfif NOT isDefined("Arguments.OrderByList")>
        	<cfset Arguments.OrderByList = "ITEMNO">
        </cfif>
        
<!---        
        <cfquery datasource="#This.DataSourceName#" name="qryPriceListComponents">
        SELECT	tblPriceListComponents.PriceListComponentID, tblPriceListComponents.ITEMNO, 
        		tblPriceListComponents.Description, tblPriceListComponents.SellPrice
        FROM    tblPriceListComponents INNER JOIN
                tblPriceListCategories ON tblPriceListCategories.PriceListCategoryID = tblPriceListComponents.PriceListCategoryID
        WHERE 	tblPriceListCategories.PriceListID = '#Arguments.PriceListID#' AND
        		tblPriceListComponents.Active = 1 AND
        		tblPriceListComponents.Description LIKE '%#trim(Arguments.SearchText)#%'
                <cfif Arguments.PriceListCategoryID IS NOT "">
                	AND tblPriceListComponents.PriceListCategoryID = '#Arguments.PriceListCategoryID#'
                </cfif>
		ORDER BY #Arguments.OrderByList#                 
        </cfquery>
--->        
        
        <!--- RAB 1/15/2013: We're now searching in ACCPAC for the item description --->
        <cfquery datasource="#This.DataSourceName#" name="qryPriceListComponents" result="RonTest">
        SELECT	tblPriceListComponents.PriceListComponentID, tblPriceListComponents.ITEMNO, 
        		tblPriceListComponents.Description, tblPriceListComponents.SellPrice
                
        FROM    tblPriceListComponents INNER JOIN
                tblPriceListCategories ON tblPriceListCategories.PriceListCategoryID = tblPriceListComponents.PriceListCategoryID
                
        WHERE 	tblPriceListCategories.PriceListID = '#Arguments.PriceListID#' AND
        		tblPriceListComponents.Active = 1 
                <cfif Arguments.PriceListCategoryID IS NOT "">
                	AND tblPriceListComponents.PriceListCategoryID = '#Arguments.PriceListCategoryID#'
                </cfif>
		ORDER BY #Arguments.OrderByList#                 
        </cfquery>

		<cfloop query="qryPriceListComponents">
        	<cfset ACCPACDescription = getItemDescription(qryPriceListComponents.ITEMNO)>
			<cfif findNoCase(trim(Arguments.SearchText), ACCPACDescription) NEQ 0>
            	<cfset queryAddRow(qryFinal)>
                <cfset querySetCell(qryFinal, "PriceListComponentID", qryPriceListComponents.PriceListComponentID)>
                <cfset querySetCell(qryFinal, "ITEMNO", qryPriceListComponents.ITEMNO)>
                <cfset querySetCell(qryFinal, "Description", ACCPACDescription)>
                <cfset querySetCell(qryFinal, "SellPrice", qryPriceListComponents.SellPrice)>
            </cfif>

        </cfloop>
        
        <cfreturn qryFinal>
	</cffunction>

</cfcomponent>