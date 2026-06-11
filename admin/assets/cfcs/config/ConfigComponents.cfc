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


	<cfset This.TableName = "tblConfigComponents">
	<cfset This.ViewName = "vConfigComponents">

	<cfset This.Columns = "ConfigComponentID,ConfigComponentCategoryID,ITEMNO,DESCRIPTION,MarkupPercentage,FixedPrice,DefaultComponent,Case_ConfigPhotoID">
	<cfset This.ViewColumns = "ConfigComponentID,ConfigComponentCategoryID,CategoryName,CategorySortOrder,CATEGORY,ConfigSystemID,SystemName,SystemType,SystemTypeSortOrder,ITEMNO,DESCRIPTION,MarkupPercentage,FixedPrice,DefaultComponent,Case_ConfigPhotoID">
	
	<cfset This.PrimaryKey = "ConfigComponentID">
	
	<cfset This.GenerateUUIDKey = 1>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "SystemName">
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

	<!---------------------------------------------------------------------------------------------------------------------->
	<cffunction name="copyConfigComponents" access="public" output="No">
	<cfargument name="OldConfigComponentCategoryID" type="string" required="Yes">
	<cfargument name="NewConfigComponentCategoryID" type="string" required="Yes">
		<cfset qryOrigConfigComponents = listRecordsForParent("ConfigComponentCategoryID", Arguments.OldConfigComponentCategoryID)>
		<cfloop query="qryOrigConfigComponents">
			<cfset strNewConfigComponents = newRecord()>
			<cfloop list="#This.Columns#" index="Column">
				<cfif Column IS "ConfigComponentCategoryID">
					<cfset structInsert(strNewConfigComponents, "ConfigComponentCategoryID", Arguments.NewConfigComponentCategoryID, True)>
				<cfelseif Column IS NOT "ConfigComponentID">
					<cfset structInsert(strNewConfigComponents, Column, qryOrigConfigComponents[Column], True)>
				</cfif>
			</cfloop>
			<cfset NewConfigComponentID = saveRecord(strNewConfigComponents)>
		</cfloop>
	</cffunction>

	<!---------------------------------------------------------------------------------------------------------------------->
	<cffunction name="deleteRecord" access="public" output="No">
	<cfargument name="RecordID" type="string" required="Yes">
		<cfset objConfigComponentsResellers = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ConfigComponentsResellers")>
		<cfset super.deleteRecord(Arguments.RecordID)>
		<!--- Delete children records in tblConfigComponentsResellers --->
<!---        
		<cfset qryConfigComponentsResellers = objConfigComponentsResellers.listRecordsForParent("ConfigComponentID",Arguments.RecordID)>
		<cfloop query="qryConfigComponentsResellers">
			<cfset objConfigComponentsResellers.deleteRecord(qryConfigComponentsResellers.ConfigComponentsResellersID)>
		</cfloop>
--->        
		<cfreturn>
	</cffunction>

	<cffunction name="getConfigurableItems" access="public" returntype="query" output="No">
	<!--- Return all items marked as "Configurable", for a specific category --->
	<cfargument name="CATEGORY" type="string" required="No">
		<cfset var qryItems = queryNew("ITEMNO,DESC,CATEGORY")>
		<cfquery datasource="#APPLICATION.DSN_AP#" name="qryItems">
		SELECT 	dbo.ICITEM.ITEMNO, dbo.ICITEM.[DESC], dbo.ICITEM.CATEGORY
		FROM 	dbo.ICITEM
		WHERE	dbo.ICITEM.ALLOWONWEB = 1
			<cfif isDefined("Arguments.CATEGORY")>
				AND dbo.ICITEM.CATEGORY = '#Arguments.CATEGORY#'
			</cfif>
		ORDER BY dbo.ICITEM.[DESC]
		</cfquery>
		<!---
		<cfset queryAddRow(qryItems)>
		<cfset querySetCell(qryItems, "ITEMNO", "[NONE]")>
		<cfset querySetCell(qryItems, "DESC", " None")>
		--->
		<cfquery dbtype="query" name="qryFinal">
		SELECT 	*
		FROM 	qryItems
<!---	ORDER BY [DESC]	--->
		ORDER BY ITEMNO
		</cfquery>
		<cfreturn qryFinal>
	</cffunction>

	<cffunction name="validateRecord" access="public" returntype="struct" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
		<cfset objConfigComponentCategories = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ConfigComponentCategories")>
<!---	<cfset qryConfigComponentCategories = objConfigComponentCategories.listRecordsForParent("ConfigSystemID", Arguments.Record.ConfigSystemID, "CategorySortOrder")>	--->
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ConfigComponentCategoryID", Arguments.Record.ConfigComponentCategoryID, True)>
		<cfset qryConfigComponentCategories = objConfigComponentCategories.searchRecords(SearchRecord, "query")>

		<cfset lstRecord = structKeyList(Arguments.Record)>
		<cfloop query="qryConfigComponentCategories">
			<cfset FoundOne = 0>
			<cfset qryItems = getConfigurableItems(qryConfigComponentCategories.CATEGORY)>
			<cfif qryItems.RecordCount EQ 0>
				<!--- Don't report an error if the category has no items to choose from --->
				<cfset FoundOne = 1>
			<cfelse>
				<cfloop list="#lstRecord#" index="Column">
					<cfif findNoCase("COMP|", Column) NEQ 0>
						<cfset FirstPipe = findNoCase("|", Column)>
						<cfset SecondPipe = findNoCase("|", Column, FirstPipe+1)>
						<cfset FieldValue = mid(Column, FirstPipe+1, SecondPipe-FirstPipe-1)>
						<cfif qryConfigComponentCategories.ConfigComponentCategoryID IS FieldValue>
							<cfset FoundOne = 1>
							<cfbreak>
						</cfif>
					</cfif>
				</cfloop>
			</cfif>
			<cfif NOT FoundOne>
				<cfset ErrorFieldName = "COMPCAT_" & qryConfigComponentCategories.ConfigComponentCategoryID>
				<cfset structInsert(stErrors, ErrorFieldName, "Please pick at least one component for category '#qryConfigComponentCategories.CategoryName#'", True)>
			</cfif>
		</cfloop>
		<cfreturn stErrors>
	</cffunction>

	<!---------------------------------------------------------------------------------------------------------------------->
	<cffunction name="assignComponents" access="public" output="no">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var SearchRecord = structNew()>
        <cfset var qryConfigComponentCategories = queryNew("")>
        <cfset var lstRecord = "">
        <cfset var CURRENTConfigComponentCategoryID = "">
        <cfset var qryItems = queryNew("")>
        <cfset var qryConfigComponents = queryNew("")>
        <cfset var qryConfigComponents2 = queryNew("")>
        <cfset var InDatabase = 0>
        <cfset var CheckedOnForm = 0>
        <cfset var strConfigComponent = structNew()>
        <cfset var ComponentField = "">
        <cfset var ConfigComponentID = "">
		<cfset objConfigComponentCategories = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ConfigComponentCategories")>
		<cfset objComponentPrices = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ComponentPrices")>

		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ConfigComponentCategoryID", Arguments.Record.ConfigComponentCategoryID, True)>
		<cfset qryConfigComponentCategories = objConfigComponentCategories.searchRecords(SearchRecord, "query")>
		<cfset lstRecord = structKeyList(Arguments.Record)>

		<cfloop query="qryConfigComponentCategories">
			<cfset CURRENTConfigComponentCategoryID = qryConfigComponentCategories.ConfigComponentCategoryID>
			<cfset qryItems = getConfigurableItems(qryConfigComponentCategories.CATEGORY)>
			<cfloop query="qryItems">
				<cfset SearchRecord = structNew()>
				<cfset structInsert(SearchRecord, "ConfigComponentCategoryID", CURRENTConfigComponentCategoryID, True)>
				<cfset structInsert(SearchRecord, "ITEMNO", qryItems.ITEMNO, True)>
				<cfset qryConfigComponents = searchRecords(SearchRecord, "query")>
                
				<cfset InDatabase = 0>
				<cfif qryConfigComponents.RecordCount GT 0>
					<cfset InDatabase = 1>
				</cfif>
                
				<cfset CheckedOnForm = 0>
                <cfif structKeyExists(Arguments.Record, "OrigConfigComponentCategoryID")>
                	<cfset ComponentField = "COMP|" & Arguments.Record.OrigConfigComponentCategoryID & "|" & qryItems.ITEMNO>
                <cfelse>
                	<cfset ComponentField = "COMP|" & CURRENTConfigComponentCategoryID & "|" & qryItems.ITEMNO>
                </cfif>
<!---			<cfif listContainsNoCase(lstRecord, "COMP|#CURRENTConfigComponentCategoryID#|#qryItems.ITEMNO#") NEQ 0>	--->
				<cfif listContainsNoCase(lstRecord, ComponentField) NEQ 0>
					<cfset CheckedOnForm = 1>
				</cfif>
                
				<!--- The user unchecked this component on the form --->
				<cfif InDatabase AND NOT CheckedOnForm>
					<!--- Delete it --->
					<cfset deleteRecord(qryConfigComponents.ConfigComponentID)>
					<cfset objComponentPrices.deletePricesForComponent(qryConfigComponents.ConfigComponentID)>

				<!--- The user checked this component on the form --->
				<cfelseif NOT InDatabase AND CheckedOnForm>
					<!--- Add it --->
					<cfset strConfigComponent = newRecord()>
					<cfset structInsert(strConfigComponent, "ConfigComponentCategoryID", CURRENTConfigComponentCategoryID, True)>
					<cfset structInsert(strConfigComponent, "ITEMNO", qryItems.ITEMNO, True)>
					<cfset structInsert(strConfigComponent, "DESCRIPTION", getItemDescription(qryItems.ITEMNO), True)>
					<cfset structDelete(strConfigComponent, "MarkupPercentage")>
					<cfif qryItems.ITEMNO IS "[NONE]">
						<cfset structInsert(strConfigComponent, "FixedPrice", 0, True)>
					<cfelse>
						<cfset structDelete(strConfigComponent, "FixedPrice")>
					</cfif>
					<cfset structDelete(strConfigComponent, "DefaultComponent")>
					<cfset ConfigComponentID = saveRecord(strConfigComponent)>
                    <!--- If this isn't a new system, create prices in tblComponentPrices --->
					<cfset objComponentPrices.createPricesForComponent(ConfigComponentID)>
				</cfif>
			</cfloop>
  
			<!--- If this category now has only one component, and it's not marked as the default, mark it as the default --->          
            <cfquery datasource="#This.DataSourceName#" name="qryConfigComponents2">
            SELECT	ConfigComponentID,DefaultComponent
            FROM    tblConfigComponents 
            WHERE   ConfigComponentCategoryID = '#CURRENTConfigComponentCategoryID#'
            </cfquery>
            <cfif qryConfigComponents2.RecordCount EQ 1 AND qryConfigComponents2.DefaultComponent IS "">
                <cfquery datasource="#This.DataSourceName#">
                UPDATE	tblConfigComponents
                SET 	DefaultComponent = 1
                WHERE 	ConfigComponentID = '#qryConfigComponents2.ConfigComponentID#'
                </cfquery>
				<cfset objComponentPrices.setComponentPriceAsDefault(qryConfigComponents2.ConfigComponentID)>
            </cfif>
            
		</cfloop>
	</cffunction>

	<!----------------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="cleanUpPowerSupplyComponents" access="public" output="No">
	<cfargument name="ConfigSystemID" type="string" required="Yes">
    	<cfset var qryComponentPrices = queryNew("")>
        <cfset var qryConfigComponents = queryNew("")>
<!---        
<cfdump var="#arguments.ConfigSystemID#"><br>
--->
        <cfquery datasource="#This.DataSourceName#" name="qryComponentPrices">
        SELECT	ComponentPriceID, ConfigComponentID
        FROM    tblComponentPrices
        WHERE   ConfigSystemID = '#Arguments.ConfigSystemID#' AND
        		ITEMNO LIKE 'PS-%'
        </cfquery>
<!---
qryComponentPrices:<cfdump var="#qryComponentPrices#"><br>
--->
		<cfloop query="qryComponentPrices">
        
            <cfquery datasource="#This.DataSourceName#" name="qryConfigComponents">
            SELECT	ConfigComponentID
            FROM    tblConfigComponents
            WHERE   ConfigComponentID = '#qryComponentPrices.ConfigComponentID#'
            </cfquery>
            <cfif qryConfigComponents.RecordCount EQ 0>

                <cfquery datasource="#This.DataSourceName#">
                DELETE FROM tblComponentPrices
                WHERE 		ComponentPriceID = '#qryComponentPrices.ComponentPriceID#'
				</cfquery>                
            </cfif>
        </cfloop>

	</cffunction>

	<!----------------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="validateMarkUp" access="public" returntype="struct" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
        <cfset var Column = "">
		<cfset var lstRecord = structKeyList(Arguments.Record)>
		<cfset var DefaultQuantityFieldName = "">
        <cfset var MaximumQuantityFieldName = "">        
		<cfset objConfigComponentCategories = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ConfigComponentCategories")>
		<cfset objConfigSystems = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ConfigSystems")>       

		<cfset qryConfigComponentCategories = objConfigComponentCategories.listRecordsForParent("ConfigSystemID", Arguments.Record.ConfigSystemID, "CategorySortOrder")>
<!---
Arguments.Record:<cfdump var="#Arguments.Record#">
<cfabort>
--->
        
		<cfloop list="#lstRecord#" index="Column">
			<cfif findNoCase("MAXQTY|", Column) NEQ 0>
				<cfif validatePositiveInteger(Arguments.Record[Column]) EQ 0>
					<cfset structInsert(stErrors, "NUMERR|##", "All Default and Maximum Quantity fields must be filled with integers greater than zero", True)>
<!---
					<cfset structInsert(stErrors, Column, "Error", True)>
					<cfset structInsert(stErrors, "NumericError", "All Default and Maximum Quantity fields must be filled with integers greater than zero", True)>	
--->
				</cfif>
			</cfif>
		</cfloop>

		<cfloop list="#lstRecord#" index="Column">
			<cfif findNoCase("DEFQTY|", Column) NEQ 0>
				<cfif validatePositiveInteger(Arguments.Record[Column]) EQ 0>
					<cfset structInsert(stErrors, Column, "All Default and Maximum Quantity fields must be filled with integers greater than zero", True)>
<!---                
					<cfset structInsert(stErrors, Column, "Error", True)>
					<cfset structInsert(stErrors, "NumericError", "All Default and Maximum Quantity fields must be filled with integers greater than zero", True)>
--->
				</cfif>
			</cfif>
		</cfloop>

		<cfloop query="qryConfigComponentCategories">
        	<cfif qryConfigComponentCategories.CategoryName IS NOT "EnergyStar"	AND 
				 (qryConfigComponentCategories.CategoryName IS NOT "Power Supply" OR 
				  NOT objConfigSystems.isPowerSupplyAutoSelect(Arguments.Record.ConfigSystemID))>
				<cfif qryConfigComponentCategories.isAdditionalWarranty IS NOT "1">
                    <cfset FieldName = "DEFQTY|" & qryConfigComponentCategories.ConfigComponentCategoryID>
                    <cfif validatePositiveInteger(Arguments.Record[FieldName]) EQ 0>
                        <cfset structInsert(stErrors, FieldName, "Error", True)>
                        <cfset structInsert(stErrors, "NUMERR|#qryConfigComponentCategories.ConfigComponentCategoryID#", "All Default and Maximum Quantity fields must be filled with integers greater than zero", True)>	
                    </cfif>
                        
                    <cfset FieldName = "MAXQTY|" & qryConfigComponentCategories.ConfigComponentCategoryID>
                    <cfif validatePositiveInteger(Arguments.Record[FieldName]) EQ 0>
                        <cfset structInsert(stErrors, FieldName, "Error", True)>
                        <cfset structInsert(stErrors, "NUMERR|#qryConfigComponentCategories.ConfigComponentCategoryID#", "All Default and Maximum Quantity fields must be filled with integers greater than zero", True)>	
                    </cfif>
                </cfif>
                
                <cfset FieldName = "DEFCOMP_" & qryConfigComponentCategories.ConfigComponentCategoryID>
                <cfif listFindNoCase(lstRecord, FieldName) EQ 0>
                    <cfset structInsert(stErrors, FieldName, "Please select one default component for category '#qryConfigComponentCategories.CategoryName#'", True)>
                </cfif>
    
                <cfif qryConfigComponentCategories.isAdditionalWarranty IS NOT "1">
                    <cfset DefaultQuantityFieldName = "DEFQTY|" & qryConfigComponentCategories.ConfigComponentCategoryID>
                    <cfset MaximumQuantityFieldName = "MAXQTY|" & qryConfigComponentCategories.ConfigComponentCategoryID>
                    <cfif NOT structKeyExists(stErrors, DefaultQuantityFieldName) AND NOT structKeyExists(stErrors, MaximumQuantityFieldName)>
                        <cfif Arguments.Record[DefaultQuantityFieldName] GT Arguments.Record[MaximumQuantityFieldName]>
                            <cfset structInsert(stErrors, DefaultQuantityFieldName, "Error", True)>
                            <cfset structInsert(stErrors, "RANGEERR|#qryConfigComponentCategories.ConfigComponentCategoryID#", "The Default Quantity cannot be greater than the Maximum Quantity", True)>
        <!---				<cfset structInsert(stErrors, "RangeError", "All Default and Maximum Quantity fields must be filled with integers greater than zero", True)>	--->
                        </cfif>
                    </cfif>
                </cfif>
			</cfif>
		</cfloop>
<!---        
<cfdump var="#Arguments.Record#">
<cfdump var="#stErrors#">
<cfabort>
--->        
		<cfreturn stErrors>
	</cffunction>


	<!---------------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="saveMarkups" access="public" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var qryConfigComponentCategory = queryNew("")>
		<cfset objConfigComponentCategories = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ConfigComponentCategories")>
		<cfset objComponentPrices = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ComponentPrices")>
		<cfset lstRecord = structKeyList(Arguments.Record)>
		<cfloop list="#lstRecord#" index="Column">
			<cfset ThisColumnValue = trim(Arguments.Record[Column])>
<!---		<cfif ThisColumnValue IS NOT "">	--->
			
				<!--- Save the Category Markup Percentage --->
				<cfif findNoCase("CATPCT_", Column) NEQ 0>
					<cfset ConfigComponentCategoryID = removeChars(Column, 1, 7)>
					<cfset strConfigComponentCategory = objConfigComponentCategories.getRecord(ConfigComponentCategoryID)>
					<cfset structInsert(strConfigComponentCategory, "MarkupPercentage", ThisColumnValue, True)>
					<cfset objConfigComponentCategories.saveRecord(strConfigComponentCategory)>

				<!--- Save the Component Markup Percentage --->
				<cfelseif findNoCase("COMPPCT_", Column) NEQ 0>
					<cfset ConfigComponentID = removeChars(Column, 1, 8)>
					<cfset strConfigComponent = getRecord(ConfigComponentID)>
					<cfset structInsert(strConfigComponent, "MarkupPercentage", ThisColumnValue, True)>
					<cfset saveRecord(strConfigComponent)>
					
				<!--- Save the Component Fixed Price --->
				<cfelseif findNoCase("COMPFIX_", Column) NEQ 0>
					<cfset ConfigComponentID = removeChars(Column, 1, 8)>
					<cfset strConfigComponent = getRecord(ConfigComponentID)>
					<cfset structInsert(strConfigComponent, "FixedPrice", ThisColumnValue, True)>
					<cfset saveRecord(strConfigComponent)>
					
				<!--- Save the Maximum Quantity --->
				<cfelseif findNoCase("MAXQTY|", Column) NEQ 0>
					<cfset ConfigComponentCategoryID = removeChars(Column, 1, 7)>
                    <cfquery datasource="#This.DataSourceName#">
                    UPDATE	tblConfigComponentCategories
                    SET 	MaximumQuantity = '#ThisColumnValue#'
                    WHERE 	ConfigComponentCategoryID = '#ConfigComponentCategoryID#'
                    </cfquery>

				<!--- Save the Default Quantity --->
				<cfelseif findNoCase("DEFQTY|", Column) NEQ 0>
					<cfset ConfigComponentCategoryID = removeChars(Column, 1, 7)>
                    <cfquery datasource="#This.DataSourceName#">
                    UPDATE	tblConfigComponentCategories
                    SET 	DefaultQuantity = '#ThisColumnValue#'
                    WHERE 	ConfigComponentCategoryID = '#ConfigComponentCategoryID#'
                    </cfquery>

				<!--- Save the Default Component --->
				<cfelseif findNoCase("DEFCOMP_", Column) NEQ 0>
					<cfset ConfigComponentCategoryID = removeChars(Column, 1, 8)>
                    
                    <cfquery datasource="#This.DataSourceName#" name="qryConfigComponentCategory">
                    SELECT	IsAdditionalWarranty
                    FROM    vConfigComponentCategories
                    WHERE   ConfigComponentCategoryID = '#ConfigComponentCategoryID#'
                    </cfquery>
					<cfif NOT qryConfigComponentCategory.IsAdditionalWarranty>
						<cfset qryConfigComponents = listRecordsForParent("ConfigComponentCategoryID", ConfigComponentCategoryID)>
                        <cfloop query="qryConfigComponents">
                            <cfset strConfigComponent = getRecord(qryConfigComponents.ConfigComponentID)>
                            <!--- "ThisColumnValue" is the ConfigComponentID --->
                            <cfif qryConfigComponents.ConfigComponentID IS ThisColumnValue>
                                <cfset structInsert(strConfigComponent, "DefaultComponent", 1, True)>
								<cfset objComponentPrices.setComponentPriceAsDefault(qryConfigComponents.ConfigComponentID)>
                            <cfelse>
                                <cfset structInsert(strConfigComponent, "DefaultComponent", 0, True)>
                            </cfif>
                            <cfset saveRecord(strConfigComponent)>
                        </cfloop>
					<cfelse>                    
                        <cfquery datasource="#This.DataSourceName#">
                        UPDATE	tblConfigWarranty
                        SET 	DefaultComponent = '1'
                        WHERE 	ConfigComponentCategoryID = '#ConfigComponentCategoryID#' AND
                        		ConfigWarrantyID = '#ThisColumnValue#'
                        </cfquery>
                        <cfquery datasource="#This.DataSourceName#">
                        UPDATE	tblConfigWarranty
                        SET 	DefaultComponent = '0'
                        WHERE 	ConfigComponentCategoryID = '#ConfigComponentCategoryID#' AND
                        		ConfigWarrantyID <> '#ThisColumnValue#'
                        </cfquery>                        
                    </cfif>
				</cfif> 
<!---		</cfif>	--->
		</cfloop>
	</cffunction>


	<!---------------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="savePowerSupplies" access="public" output="No">
	<cfargument name="ConfigSystemID" type="string" required="Yes">
		<cfset var qryPowerSupply = queryNew("")>
        <cfset var qryCase = queryNew("")>
		<cfset var qryCaseComponents = queryNew("")>
        <cfset var qryPowerSupplyItems = queryNew("")>
        <cfset var qryPowerSupplyComponent = queryNew("")>  
		<cfset var ItemDescription = "">
        <cfset var CurrentDefaultComponent = 0>
        <cfset var RON_DefaultComponent = 0>
        <cfset var NewConfigComponentID = "">
        
		<cfset objConfigSystems = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ConfigSystems")>       
		<cfset objComponentPrices = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ComponentPrices")>

        <cfif objConfigSystems.isPowerSupplyAutoSelect(Arguments.ConfigSystemID)>

            <cfquery datasource="#This.DataSourceName#" name="qryCase">
            SELECT	ConfigComponentCategoryID, MaximumQuantity, DefaultQuantity
            FROM    vConfigComponentCategories 
            WHERE   ConfigSystemID = '#Arguments.ConfigSystemID#' AND
            		CategoryName = 'Case'
            </cfquery>
        
            <cfquery datasource="#This.DataSourceName#" name="qryPowerSupply">
            SELECT	ConfigComponentCategoryID
            FROM    vConfigComponentCategories 
            WHERE   ConfigSystemID = '#Arguments.ConfigSystemID#' AND
            		CategoryName = 'Power Supply'
            </cfquery>
        
			<cfif qryCase.RecordCount NEQ 0 AND qryPowerSupply.RecordCount NEQ 0>

	        	<!--- Set the MaximumQuantity and DefaultQuantity of the Power Suppliers to those values that were entered for the Case --->
                <cfquery datasource="#This.DataSourceName#">
                UPDATE	tblConfigComponentCategories
                SET 	MaximumQuantity = '#qryCase.MaximumQuantity#',
                        DefaultQuantity = '#qryCase.DefaultQuantity#'
                WHERE 	ConfigComponentCategoryID = '#qryPowerSupply.ConfigComponentCategoryID#'
                </cfquery>
                
				<!--- Add Power Supply Components --->
                
                <!--- First, delete existing power supplies --->
                <cfquery datasource="#This.DataSourceName#">
                DELETE FROM tblConfigComponents
                WHERE 		ConfigComponentCategoryID = '#qryPowerSupply.ConfigComponentCategoryID#'
				</cfquery>                
                <!--- Now, create them based on the Cases --->
                <cfquery datasource="#This.DataSourceName#" name="qryCaseComponents">
                SELECT	ITEMNO, DefaultComponent
                FROM    tblConfigComponents 
                WHERE   ConfigComponentCategoryID = '#qryCase.ConfigComponentCategoryID#'
                ORDER BY DefaultComponent DESC
                </cfquery>
              
                <cfloop query="qryCaseComponents">
                	<cfset RON_DefaultComponent = qryCaseComponents.DefaultComponent>
                
                    <cfset qryPowerSupplyItems = getPowerSupplies(qryCaseComponents.ITEMNO)>
<!---
qryCaseComponents.ITEMNO:<cfdump var="#qryCaseComponents.ITEMNO#"><br>
qryPowerSupplyItems:<cfdump var="#qryPowerSupplyItems#"><br>
<cfabort>
--->                    
                    <cfloop query="qryPowerSupplyItems">
                        <!--- See if this power supply is already entered --->
                        <cfquery datasource="#This.DataSourceName#" name="qryPowerSupplyComponent">
                        SELECT	ITEMNO, DefaultComponent
                        FROM    tblConfigComponents 
                        WHERE   ConfigComponentCategoryID = '#qryPowerSupply.ConfigComponentCategoryID#' AND
                                ITEMNO = '#qryPowerSupplyItems.ITEMNO#'
                        </cfquery>
                        <cfif qryPowerSupplyComponent.RecordCount EQ 0>

                            <cfset ItemDescription = getItemDescription(qryPowerSupplyItems.ITEMNO)>
                            
							<cfset CurrentDefaultComponent = 0>
                            <cfif RON_DefaultComponent EQ 1>
                            	<cfif qryPowerSupplyItems.RecordCount EQ 1>
	                            	<cfset CurrentDefaultComponent = 1>
    							<cfelseif qryPowerSupplyItems.ITEMNO IS "PS-SS-350ET">                            
	                            	<cfset CurrentDefaultComponent = 1>
								</cfif>
                            </cfif>  
                            
                            <cfset NewConfigComponentID = createUUID()>
                        	
                            <cfquery datasource="#This.DataSourceName#">
                            INSERT INTO tblConfigComponents (
                                ConfigComponentID, 
                                ConfigComponentCategoryID,
                                ITEMNO,
                                DESCRIPTION,
                                DefaultComponent)
                            VALUES (
                                '#NewConfigComponentID#', 
                                '#qryPowerSupply.ConfigComponentCategoryID#',
                                '#qryPowerSupplyItems.ITEMNO#',
                                '#ItemDescription#',
                                #CurrentDefaultComponent#)
                            </cfquery>
                            
                            <!--- Create price records in tblComponentPrices --->
                            <cfset objComponentPrices.createPricesForComponent(NewConfigComponentID)>
                            
                        </cfif>
                    </cfloop>
                    
                </cfloop>
                
			</cfif>
       
        </cfif>
        
	</cffunction>

	<!---------------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="setSystemImage" access="public" output="No">
	<cfargument name="ConfigSystemID" type="string" required="Yes">
	<cfargument name="ThisIsTheSalesRep" type="boolean" required="No">
	<!--- If this system has Case as a category, and the default case has an image associated with in, then set this image as
          the default image for the system 	
	--->
		<cfset var qryDefaultCase = queryNew("")>
		<cfset var qryConfigSystem = queryNew("")>
		<cfif NOT isDefined("Arguments.ThisIsTheSalesRep")>
        	<cfset Arguments.ThisIsTheSalesRep = 0>
        </cfif>

		<!--- Don't do it if the sales rep is picking his own default case and image for this system --->
		<cfquery datasource="#This.DataSourceName#" name="qryConfigSystem">
		SELECT	SalesRepPickDefaultCase
		FROM    tblConfigSystems
		WHERE   ConfigSystemID = '#Arguments.ConfigSystemID#'
		</cfquery>
        <cfif qryConfigSystem.RecordCount NEQ 0 AND (qryConfigSystem.SalesRepPickDefaultCase IS NOT "1" OR Arguments.ThisIsTheSalesRep)>
            <cfquery datasource="#This.DataSourceName#" name="qryDefaultCase">
            SELECT	Case_ConfigPhotoID
            FROM    vConfigComponents 
            WHERE   ConfigSystemID = '#Arguments.ConfigSystemID#' AND 
                    CATEGORY = 'CS' AND 
                    DefaultComponent = 1
            </cfquery>
            <cfif qryDefaultCase.RecordCount NEQ 0 AND trim(qryDefaultCase.Case_ConfigPhotoID) IS NOT "">
                <cfquery datasource="#This.DataSourceName#">
                UPDATE	tblConfigSystems
                SET 	ConfigPhotoID = '#qryDefaultCase.Case_ConfigPhotoID#'
                WHERE 	ConfigSystemID = '#Arguments.ConfigSystemID#'
                </cfquery>
            </cfif>
        </cfif>
	</cffunction>
    
<!--- SAVED 7/12/11 --->    
<!---
	<!---------------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="getPowerSupplies" access="public" returntype="query" output="No">
	<cfargument name="ITEMNO" type="string" required="Yes">
    	<cfset var qryPowerSupplyItems = queryNew("ITEMNO")>
        <cfif trim(Arguments.ITEMNO) IS "CS-CE-FX629MBKH" OR trim(Arguments.ITEMNO) IS "CS-CE-TLA397/NP">
			<cfset queryAddRow(qryPowerSupplyItems)>
            <cfset querySetCell(qryPowerSupplyItems, "ITEMNO", "PS-AGI-U350PLUS")>
            
        <cfelseif trim(Arguments.ITEMNO) IS "CS-EV-E4252-BLACK-NPS" OR trim(Arguments.ITEMNO) IS "CS-LO-ST951B-VOY/NP">
			<cfset queryAddRow(qryPowerSupplyItems)>
            <cfset querySetCell(qryPowerSupplyItems, "ITEMNO", "PS-SS-350ET")>
			<cfset queryAddRow(qryPowerSupplyItems)>
            <cfset querySetCell(qryPowerSupplyItems, "ITEMNO", "PS-SS-400ET")>
        </cfif>
        
        <cfreturn qryPowerSupplyItems>
	</cffunction>
--->

	<!---------------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="getPowerSupplies" access="public" returntype="query" output="No">
	<cfargument name="ITEMNO" type="string" required="Yes">
    	<cfset var qryPowerSupplyItems = queryNew("ITEMNO")>

			  <!--- RAB 04/30/2012 --->        
<!---		  trim(Arguments.ITEMNO) IS "CS-EV-E4252-BLACK-NPS" OR 	--->
		
        <cfif trim(Arguments.ITEMNO) IS "CS-CE-FX629MBKH" OR 
			  trim(Arguments.ITEMNO) IS "CS-CE-TLA397/NP" OR 			  

			  trim(Arguments.ITEMNO) IS "CS-EV-4572B-S2" OR 
			  
			  trim(Arguments.ITEMNO) IS "CS-LO-ST951B-VOY/NP">
              
			<cfset queryAddRow(qryPowerSupplyItems)>
            <cfset querySetCell(qryPowerSupplyItems, "ITEMNO", "PS-SS-350ET")>
			<cfset queryAddRow(qryPowerSupplyItems)>
            <cfset querySetCell(qryPowerSupplyItems, "ITEMNO", "PS-SS-400ET")>
			<cfset queryAddRow(qryPowerSupplyItems)>
            <cfset querySetCell(qryPowerSupplyItems, "ITEMNO", "PS-SS-500ET")>
            
        </cfif>
        
        <cfreturn qryPowerSupplyItems>
	</cffunction>


	<!---------------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="saveRecord" access="public" returntype="string" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var RecordID = "">
		<cfif structKeyExists(Arguments.Record, "MarkupPercentage") AND	trim(Arguments.Record.MarkupPercentage) IS "">
<!---		<cfset Arguments.Record.MarkupPercentage = "NULL">	--->
			<cfset structInsert(Arguments.Record, "MarkupPercentage", "NULL", True)>
<!---		<cfset structDelete(Arguments.Record, "MarkupPercentage")>	--->
		</cfif>
		<cfif structKeyExists(Arguments.Record, "FixedPrice") AND	trim(Arguments.Record.FixedPrice) IS "">
<!---		<cfset structDelete(Arguments.Record, "FixedPrice")>	--->
			<cfset structInsert(Arguments.Record, "FixedPrice", "NULL", True)>
		</cfif>
		<cfset RecordID = super.saveRecord(Arguments.Record)>
		<cfreturn RecordID>
	</cffunction>

	<cffunction name="listDefaultComponents" access="public" returntype="query" output="No">
	<cfargument name="ConfigSystemID" type="string" required="Yes">
		<cfset qryConfigComponents = queryNew(This.ViewColumns)>
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ConfigSystemID", Arguments.ConfigSystemID, True)>
		<cfset structInsert(SearchRecord, "DefaultComponent", 1, True)>
		<cfset qryConfigComponents = searchRecords(SearchRecord, "query", "CategorySortOrder,  ITEMNO")>
		<cfreturn qryConfigComponents>
	</cffunction>
	
	<!-------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="getBulletText" access="public" returntype="string" output="No">
	<cfargument name="ConfigSystemID" type="string" required="Yes">
	<cfargument name="CATEGORY" type="string" required="Yes">
		<cfset var BulletText = "">
<!---
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ConfigSystemID", Arguments.ConfigSystemID, True)>
		<cfset structInsert(SearchRecord, "CATEGORY", Arguments.CATEGORY, True)>
		<cfset structInsert(SearchRecord, "DefaultComponent", 1, True)>
		<cfset qryConfigComponents = searchRecords(SearchRecord)>
--->
		<cfquery datasource="#This.DataSourceName#" name="qryConfigComponents">
		SELECT	tblConfigComponents.ITEMNO
		FROM    tblConfigComponents 
				INNER JOIN
				tblConfigComponentCategories ON 
				tblConfigComponents.ConfigComponentCategoryID = tblConfigComponentCategories.ConfigComponentCategoryID 
				INNER JOIN
				tblComponentCategories ON tblConfigComponentCategories.ComponentCategoryID = tblComponentCategories.ComponentCategoryID
		WHERE   (tblConfigComponentCategories.ConfigSystemID = '#Arguments.ConfigSystemID#') AND 
				(tblComponentCategories.CATEGORY = '#Arguments.CATEGORY#') AND 
				(tblConfigComponents.DefaultComponent = 1)
		</cfquery>

		<cfif qryConfigComponents.RecordCount NEQ 0>
			<cfset BulletText = getItemDescription(qryConfigComponents.ITEMNO)>
			<cfif BulletText IS "None">
				<cfset BulletText = "">
			</cfif>
		</cfif>
		
		<cfreturn BulletText>
	</cffunction>

	<!-------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="getMotherBoardITEMNO" access="public" returntype="string" output="No">
	<cfargument name="ConfigSystemID" type="string" required="Yes">
		<cfset var ITEMNO = "">
		<cfset var qryConfigComponents = queryNew("")>
		<cfquery datasource="#This.DataSourceName#" name="qryConfigComponents">
		SELECT	tblConfigComponents.ITEMNO
		FROM    tblConfigComponents 
				INNER JOIN
				tblConfigComponentCategories ON 
				tblConfigComponents.ConfigComponentCategoryID = tblConfigComponentCategories.ConfigComponentCategoryID 
				INNER JOIN
				tblComponentCategories ON tblConfigComponentCategories.ComponentCategoryID = tblComponentCategories.ComponentCategoryID
		WHERE   (tblConfigComponentCategories.ConfigSystemID = '#Arguments.ConfigSystemID#') AND 
				(tblComponentCategories.CATEGORY = 'MB') AND 
				(tblConfigComponents.DefaultComponent = 1)
		</cfquery>
		<cfif qryConfigComponents.RecordCount NEQ 0>
			<cfset ITEMNO = qryConfigComponents.ITEMNO>
		</cfif>
		<cfreturn ITEMNO>
	</cffunction>
    
	<!-------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="getSystemITEMNO" access="public" returntype="string" output="No">
	<cfargument name="ConfigSystemID" type="string" required="Yes">
		<cfset var ITEMNO = "">
		<cfset var qryConfigComponents = queryNew("")>
		<cfquery datasource="#This.DataSourceName#" name="qryConfigComponents">
		SELECT	tblConfigComponents.ITEMNO
		FROM    tblConfigComponents 
				INNER JOIN
				tblConfigComponentCategories ON 
				tblConfigComponents.ConfigComponentCategoryID = tblConfigComponentCategories.ConfigComponentCategoryID 
				INNER JOIN
				tblComponentCategories ON tblConfigComponentCategories.ComponentCategoryID = tblComponentCategories.ComponentCategoryID
		WHERE   (tblConfigComponentCategories.ConfigSystemID = '#Arguments.ConfigSystemID#') AND 
				(tblComponentCategories.CATEGORY = 'SY') AND 
				(tblConfigComponents.DefaultComponent = 1)
		</cfquery>
		<cfif qryConfigComponents.RecordCount NEQ 0>
			<cfset ITEMNO = qryConfigComponents.ITEMNO>
		</cfif>
		<cfreturn ITEMNO>
	</cffunction>
    
	<!-------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="getDetailedDescription" access="public" returntype="string" output="No">
	<cfargument name="ConfigSystemID" type="string" required="Yes">
	<cfargument name="Popup" type="boolean" required="No" default="0">
		<cfset var SystemDescription = "">
        <cfset var BulletText = "">
        
		<cfset BulletText = getBulletText(Arguments.ConfigSystemID, "CPU")>
        <cfif BulletText IS NOT "">
            <cfset SystemDescription = SystemDescription & BulletText>
        </cfif>
        
        <cfset BulletText = getBulletText(Arguments.ConfigSystemID, "MB")>	
        <cfif BulletText IS NOT "">
        	<cfif SystemDescription IS NOT "">
                <cfif NOT Arguments.Popup>
					<cfset SystemDescription = SystemDescription & ", ">
                <cfelse>
					<cfset SystemDescription = SystemDescription & "<br>">
                </cfif>
            </cfif>
            <cfset SystemDescription = SystemDescription & BulletText>
        </cfif>

        <cfset BulletText = getBulletText(Arguments.ConfigSystemID, "MEM")>
        <cfif BulletText IS NOT "">
        	<cfif SystemDescription IS NOT "">
                <cfif NOT Arguments.Popup>
					<cfset SystemDescription = SystemDescription & ", ">
                <cfelse>
					<cfset SystemDescription = SystemDescription & "<br>">
                </cfif>
            </cfif>
            <cfset SystemDescription = SystemDescription & BulletText>
        </cfif>
        
        <cfset BulletText = getBulletText(Arguments.ConfigSystemID, "HD")>	
        <cfif BulletText IS NOT "">
        	<cfif SystemDescription IS NOT "">
                <cfif NOT Arguments.Popup>
					<cfset SystemDescription = SystemDescription & ", ">
                <cfelse>
					<cfset SystemDescription = SystemDescription & "<br>">
                </cfif>
            </cfif>
            <cfset SystemDescription = SystemDescription & BulletText>
        </cfif>

        <cfif Arguments.Popup>
        	<cfset SystemDescription = replace(SystemDescription,'"', '')>
        </cfif>
		
		<cfreturn SystemDescription>
	</cffunction>

	<!-------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="fillComponentOptions" access="public" returntype="query" output="No">
	<cfargument name="ConfigComponentCategoryID" type="string" required="Yes">
	<cfargument name="CustomerID" type="string" required="Yes">
	<cfargument name="ExportableConfigurator" type="boolean" required="No">
		<cfset var qryComponentOptions = queryNew("ConfigComponentID,ITEMNO,DefaultComponent")>
		<cfset objPriceLists = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.prices.PriceLists")>
		<cfset objPriceListComponents = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.prices.PriceListComponents")>

		<cfset qryTemp = queryNew("ConfigComponentID,ITEMNO,DefaultComponent,CategoryName,AddCost")>

		<cfif NOT isDefined("Arguments.ExportableConfigurator")>
			<cfset Arguments.ExportableConfigurator = 0>
		</cfif>

		<cfset PriceListID = objPriceLists.getCustomerPriceListID(Arguments.CustomerID)>

		<!--- Get price of the default component --->
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ConfigComponentCategoryID", Arguments.ConfigComponentCategoryID, True)>
		<cfset structInsert(SearchRecord, "DefaultComponent", 1, True)>
		<cfset qryDefaultComponent = searchRecords(SearchRecord)>
		
		<cfset PriceOfDefaultComponent = objPriceListComponents.getSellingPrice(PriceListID, qryDefaultComponent.ITEMNO)>

		<cfset qryConfigComponents = listRecordsForParent("ConfigComponentCategoryID", Arguments.ConfigComponentCategoryID, "ITEMNO")>
		<cfloop query="qryConfigComponents">
			<cfset queryAddRow(qryTemp)>
			<cfset querySetCell(qryTemp, "ConfigComponentID", qryConfigComponents.ConfigComponentID)>
			<cfset querySetCell(qryTemp, "ITEMNO", qryConfigComponents.ITEMNO)>
			<cfset querySetCell(qryTemp, "DefaultComponent", qryConfigComponents.DefaultComponent)>
			<cfset querySetCell(qryTemp, "CategoryName", qryConfigComponents.CategoryName)>

			<cfset PriceOfThisComponent = objPriceListComponents.getSellingPrice(PriceListID, qryConfigComponents.ITEMNO)>
			
			<cfset CostVariance = PriceOfThisComponent - PriceOfDefaultComponent>
			<cfset querySetCell(qryTemp, "AddCost", CostVariance)>
		</cfloop>

		<cfquery dbtype="query" name="qryComponentOptions">
		SELECT	*
		FROM	qryTemp
		ORDER BY AddCost
		</cfquery>
		
		<cfreturn qryComponentOptions>
	</cffunction>


	<cffunction name="fillComponentOptions_Config_OLD" access="public" returntype="query" output="No">
	<cfargument name="ConfigComponentCategoryID" type="string" required="Yes">
	<cfargument name="CustomerID" type="string" required="Yes">
	<cfargument name="ExportableConfigurator" type="boolean" required="No">
		<cfset var qryComponentOptions = queryNew("ConfigComponentID,ITEMNO,DefaultComponent")>

<!--- TEMP --->
<!---
		<cfset objPriceLists = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.prices.PriceLists")>
		<cfset objPriceListComponents = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.prices.PriceListComponents")>
		<cfset qryTemp = queryNew("ConfigComponentID,ITEMNO,DefaultComponent,CategoryName,AddCost")>
--->

<!---
		<cfif NOT isDefined("Arguments.ExportableConfigurator")>
			<cfset Arguments.ExportableConfigurator = 0>
		</cfif>
--->

<!--- TEMP --->
<!---
		<cfset PriceListID = objPriceLists.getCustomerPriceListID(Arguments.CustomerID)>
--->

		<!--- Get price of the default component --->
<!---
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ConfigComponentCategoryID", Arguments.ConfigComponentCategoryID, True)>
		<cfset structInsert(SearchRecord, "DefaultComponent", 1, True)>
		<cfset qryDefaultComponent = searchRecords(SearchRecord)>
--->		

<!---
		<cfquery datasource="#This.DataSourceName#" name="qryDefaultComponent">
		SELECT	ITEMNO
		FROM	tblConfigComponents
		WHERE 	ConfigComponentCategoryID = '#Arguments.ConfigComponentCategoryID#' AND
				DefaultComponent = 1
		</cfquery>	
--->
		
<!---	<cfset PriceOfDefaultComponent = objPriceListComponents.getSellingPrice(PriceListID, qryDefaultComponent.ITEMNO)>	--->


<!---	<cfset qryConfigComponents = listRecordsForParent("ConfigComponentCategoryID", Arguments.ConfigComponentCategoryID, "ITEMNO")>	--->

<!---
		<cfquery datasource="#This.DataSourceName#" name="qryConfigComponents">
<!---	<cfquery datasource="#This.DataSourceName#" name="qryComponentOptions">--->
		SELECT	tblConfigComponents.ConfigComponentID, tblConfigComponents.ITEMNO, tblConfigComponents.DefaultComponent, 
				tblComponentCategories.Name AS CategoryName
		FROM	tblConfigComponents
				INNER JOIN tblConfigComponentCategories ON 
					tblConfigComponents.ConfigComponentCategoryID = tblConfigComponentCategories.ConfigComponentCategoryID
				INNER JOIN tblComponentCategories ON 
					tblConfigComponentCategories.ComponentCategoryID = tblComponentCategories.ComponentCategoryID
		WHERE 	tblConfigComponents.ConfigComponentCategoryID = '#Arguments.ConfigComponentCategoryID#' 
		ORDER BY tblConfigComponents.ITEMNO
		</cfquery>	
--->

		<cfstoredproc procedure="spr_select_ConfigComponents" datasource="#This.DataSourceName#" blockfactor="15" returncode="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" variable="@ConfigComponentCategoryID" dbvarname="@ConfigComponentCategoryID" value="#Arguments.ConfigComponentCategoryID#" maxlength="50" null="No">
<!--- TEMP --->
<!---		<cfprocresult name="qryConfigComponents" resultset="1">	--->
			<cfprocresult name="qryComponentOptions" resultset="1">
		</cfstoredproc>

<!--- TEMP --->
<!---
		<cfquery dbtype="query" name="qryDefaultComponent">
		SELECT	ITEMNO
		FROM	qryConfigComponents
		WHERE 	DefaultComponent = 1
		</cfquery>	

		<cfset PriceOfDefaultComponent = objPriceListComponents.getSellingPrice(PriceListID, qryDefaultComponent.ITEMNO)>

		<cfloop query="qryConfigComponents">
			<cfset queryAddRow(qryTemp)>
			<cfset querySetCell(qryTemp, "ConfigComponentID", qryConfigComponents.ConfigComponentID)>
			<cfset querySetCell(qryTemp, "ITEMNO", qryConfigComponents.ITEMNO)>
			<cfset querySetCell(qryTemp, "DefaultComponent", qryConfigComponents.DefaultComponent)>
			<cfset querySetCell(qryTemp, "CategoryName", qryConfigComponents.CategoryName)>

			<cfset PriceOfThisComponent = objPriceListComponents.getSellingPrice(PriceListID, qryConfigComponents.ITEMNO)>
			
			<cfset CostVariance = PriceOfThisComponent - PriceOfDefaultComponent>
			<cfset querySetCell(qryTemp, "AddCost", CostVariance)>
		</cfloop>

		<cfquery dbtype="query" name="qryComponentOptions">
		SELECT	*
		FROM	qryTemp
		ORDER BY AddCost
		</cfquery>
--->		

		<cfreturn qryComponentOptions>
	</cffunction>


	<!------------------------------------------------------------------------------------------------------------>
	<cffunction name="fillComponentOptions_Config" access="public" returntype="query" output="No">
	<cfargument name="ConfigComponentCategoryID" type="string" required="Yes">
	<cfargument name="PriceListID" type="string" required="Yes">
		<cfset var qryComponentOptions = queryNew("ConfigComponentID,ITEMNO,DefaultComponent")>

		<cfstoredproc procedure="spr_select_ConfigComponents" datasource="#This.DataSourceName#" blockfactor="15" returncode="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" variable="@ConfigComponentCategoryID" dbvarname="@ConfigComponentCategoryID" value="#Arguments.ConfigComponentCategoryID#" maxlength="50" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" variable="@PriceListID" dbvarname="@PriceListID" value="#Arguments.PriceListID#" maxlength="50" null="No">
			<cfprocresult name="qryComponentOptions" resultset="1">
		</cfstoredproc>

		<cfreturn qryComponentOptions>
	</cffunction>

	<!------------------------------------------------------------------------------------------------------------>
	<cffunction name="fillComponentOptions_Config_NEW" access="public" returntype="query" output="No">
	<cfargument name="ConfigComponentCategoryID" type="string" required="Yes">
	<cfargument name="PriceListID" type="string" required="Yes">
	<cfargument name="MarkupPercentage" type="string" required="No">
	<cfargument name="MarkupType" type="string" required="No">
    <cfargument name="LoginID" type="string" default="" required="No">
    <cfargument name="ExportableConfigurator" type="boolean" default="0" required="No">
		<cfset var qryConfigComponents = queryNew("")>
<!---        
		<cfset var ExportableConfigurator = 0>
--->        
		<cfset var qryLoginPrices = queryNew("")>
		<cfset var qryDefaultComponent = queryNew("")>
		<cfset var qryFinal = queryNew("ADDDEDUCTAMOUNT,CONFIGCOMPONENTID,DEFAULTCOMPONENT,DESCRIPTION,ITEMNO,PHOTOIMAGE,PRICE")>
		<cfset var PriceOfDefaultComponent = 0>
		<cfset var ThisAddDeductAmount = 0>
		<cfset var ThisSellingPrice = 0>
		<cfset var ThereIsACustomMarkupPercent = 0>
		<cfset var ThisMarkupPercent = 0>
		<cfset var qryPriceListComponents = queryNew("")>
		<cfset var qryLoginCategories = queryNew("")>

        <cfif NOT isDefined("Arguments.LoginID")>
        	<cfset Arguments.LoginID = "">
        </cfif>
        <cfif NOT isDefined("Arguments.ExportableConfigurator")>
        	<cfset Arguments.ExportableConfigurator = 0>
        </cfif>

<!---
		<cfif isDefined("Arguments.MarkupPercentage") AND isNumeric(Arguments.MarkupPercentage) AND
			  isDefined("Arguments.MarkupType") AND trim(Arguments.MarkupType) IS NOT "">
        	<cfset ExportableConfigurator = 1>
        <cfelse>
        	<cfset ExportableConfigurator = 0>
        </cfif>
--->


		<cfquery datasource="#This.DataSourceName#" name="qryConfigComponents">
		SELECT	tblComponentPrices.ConfigComponentID, 

<!--- 10/05/2010 --->        
				tblConfigPhotos.PhotoImage AS PhotoImage,
<!--- 10/05/2010 --->        
        
        
        		<cfif Arguments.ExportableConfigurator AND Arguments.MarkupType IS "Markup">
		        	(ROUND((tblComponentPrices.Price + tblComponentPrices.Price * #Arguments.MarkupPercentage#), 0)) AS Price,
        		<cfelseif Arguments.ExportableConfigurator AND Arguments.MarkupType IS "Margin">
		        	(ROUND((
                    
                    	tblComponentPrices.Price / (1 - #Arguments.MarkupPercentage#)
                    
                    
                    ), 0)) AS Price,
                <cfelse>
		        	tblComponentPrices.Price,
                </cfif>

        		(
        		<cfif Arguments.ExportableConfigurator AND Arguments.MarkupType IS "Markup">
		        	(ROUND((tblComponentPrices.Price + tblComponentPrices.Price * #Arguments.MarkupPercentage#), 0)) 

        		<cfelseif Arguments.ExportableConfigurator AND Arguments.MarkupType IS "Margin">
		        	(ROUND((
                    
                    	tblComponentPrices.Price / (1 - #Arguments.MarkupPercentage#)
                    
                    
                    ), 0))
                    
                <cfelse>
		        	tblComponentPrices.Price
                </cfif>
                    - 
        		(SELECT TOP 1 
						<cfif Arguments.ExportableConfigurator AND Arguments.MarkupType IS "Markup">
                            (ROUND((tblComponentPrices.Price + tblComponentPrices.Price * #Arguments.MarkupPercentage#), 0)) AS Price

						<cfelseif Arguments.ExportableConfigurator AND Arguments.MarkupType IS "Margin">
                            (ROUND((
                            
                                tblComponentPrices.Price / (1 - #Arguments.MarkupPercentage#)
                            
                            
                            ), 0)) AS Price

                        <cfelse>
                            tblComponentPrices.Price
                        </cfif>
                        
                 FROM	tblComponentPrices
        		 WHERE	tblComponentPrices.ConfigComponentCategoryID = '#Arguments.ConfigComponentCategoryID#' AND
						tblComponentPrices.PriceListID = '#Arguments.PriceListID#' AND
                        tblComponentPrices.DefaultComponent = 1) 
                        
                        ) AS AddDeductAmount, 	

                tblComponentPrices.ITEMNO, tblComponentPrices.DESCRIPTION, tblComponentPrices.DefaultComponent
                
		FROM 	tblComponentPrices 
        
<!--- 10/05/2010 --->        
        		LEFT OUTER JOIN
                tblConfigComponents ON tblComponentPrices.ConfigComponentID = tblConfigComponents.ConfigComponentID 
                LEFT OUTER JOIN
                tblConfigPhotos ON tblConfigComponents.Case_ConfigPhotoID = tblConfigPhotos.ConfigPhotoID
<!--- 10/05/2010 --->        
        
        
        
        
		WHERE	tblComponentPrices.ConfigComponentCategoryID = '#Arguments.ConfigComponentCategoryID#' AND
				tblComponentPrices.PriceListID = '#Arguments.PriceListID#' 
		ORDER BY tblComponentPrices.Price                
		</cfquery>	
<!---
qryConfigComponents:<cfdump var="#qryConfigComponents#"><br>
--->
<!---TEMP--->
<!---
<cfset Arguments.ExportableConfigurator = 0>
--->

        <!--- REGULAR CONFIGURATOR --->
		<cfif NOT Arguments.ExportableConfigurator>
			<cfset qryFinal = qryConfigComponents>


        <!--- EXPORTABLE CONFIGURATOR --->
		<cfelse>
        
        	<!--- Get the price of the default component --->
            <cfquery dbtype="query" name="qryDefaultComponent">
            SELECT	ITEMNO, Price
            FROM	qryConfigComponents
            WHERE	DefaultComponent = 1
            </cfquery>
			<!--- Is there a custom price in loginPrices? --->
            <cfquery datasource="#This.DataSourceName#" name="qryLoginPrices">
            SELECT	SellPrice
            FROM	vLoginPrices
            WHERE	ITEMNO = '#trim(qryDefaultComponent.ITEMNO)#' AND
                    ID = '#Arguments.LoginID#'
            </cfquery>
			<cfif qryLoginPrices.RecordCount NEQ 0 AND isNumeric(qryLoginPrices.SellPrice)>
            	<cfset PriceOfDefaultComponent = qryLoginPrices.SellPrice>
			<cfelse>
            

				<!--- Is there a custom markup percentage in loginCategories? --->
                <cfset ThereIsACustomMarkupPercent = 0>
                <cfquery datasource="#This.DataSourceName#" name="qryPriceListComponents">
                SELECT	PriceListCategoryID
                FROM	vPriceListComponents
                WHERE	PriceListID = '#Arguments.PriceListID#' AND
                        ITEMNO = '#trim(qryDefaultComponent.ITEMNO)#' 
                </cfquery>
            
                <cfif qryPriceListComponents.RecordCount NEQ 0>
                    <cfquery datasource="#This.DataSourceName#" name="qryLoginCategories">
                    SELECT	MarkupPercent
                    FROM	loginCategories
                    WHERE	PriceListCategoryID = '#qryPriceListComponents.PriceListCategoryID#' AND
                            ID = '#Arguments.LoginID#'
                    </cfquery>
                    <cfif qryLoginCategories.RecordCount NEQ 0 AND isNumeric(qryLoginCategories.MarkupPercent)>
                        <cfset ThereIsACustomMarkupPercent = 1>
                        <cfset ThisMarkupPercent = qryLoginCategories.MarkupPercent / 100>
                    </cfif>
                </cfif>
            
                <cfif ThereIsACustomMarkupPercent>
                    <cfset PriceOfDefaultComponent = int(qryDefaultComponent.Price / (1 + Arguments.MarkupPercentage))>
                
                    <cfset PriceOfDefaultComponent = PriceOfDefaultComponent + PriceOfDefaultComponent * ThisMarkupPercent>
                <cfelse>
                    <cfset PriceOfDefaultComponent = qryDefaultComponent.Price>
                
                </cfif>


			</cfif>                
                   
        
        
        	<cfloop query="qryConfigComponents">
                <!--- Is there a custom price in loginPrices? --->
                <cfquery datasource="#This.DataSourceName#" name="qryLoginPrices">
                SELECT	SellPrice
                FROM	vLoginPrices
                WHERE	ITEMNO = '#trim(qryConfigComponents.ITEMNO)#' AND
                		ID = '#Arguments.LoginID#'
                </cfquery>
                <cfif qryLoginPrices.RecordCount NEQ 0 AND isNumeric(qryLoginPrices.SellPrice)>
                    <cfset ThisSellingPrice = qryLoginPrices.SellPrice>
				<cfelse>
                
					<!--- Is there a custom markup percentage in loginCategories? --->
                   	<cfset ThereIsACustomMarkupPercent = 0>
                    <cfquery datasource="#This.DataSourceName#" name="qryPriceListComponents">
                    SELECT	PriceListCategoryID
                    FROM	vPriceListComponents
                    WHERE	PriceListID = '#Arguments.PriceListID#' AND
                    		ITEMNO = '#trim(qryConfigComponents.ITEMNO)#' 
                    </cfquery>
                
                    <cfif qryPriceListComponents.RecordCount NEQ 0>
                        <cfquery datasource="#This.DataSourceName#" name="qryLoginCategories">
                        SELECT	MarkupPercent
                        FROM	loginCategories
                        WHERE	PriceListCategoryID = '#qryPriceListComponents.PriceListCategoryID#' AND
                                ID = '#Arguments.LoginID#'
                        </cfquery>
                        <cfif qryLoginCategories.RecordCount NEQ 0 AND isNumeric(qryLoginCategories.MarkupPercent)>
                        	<cfset ThereIsACustomMarkupPercent = 1>
                            <cfset ThisMarkupPercent = qryLoginCategories.MarkupPercent / 100>
                        </cfif>
                    </cfif>
                
                    <cfif ThereIsACustomMarkupPercent>
                    	<cfset ThisSellingPrice = int(qryConfigComponents.Price / (1 + Arguments.MarkupPercentage))>
                    
                    	<cfset ThisSellingPrice = ThisSellingPrice + ThisSellingPrice * ThisMarkupPercent>
                	<cfelse>
						<cfset ThisSellingPrice = qryConfigComponents.Price>
                	
                	</cfif>
                
                    
				</cfif>    
				
				<!--- RAB 5/13/2013 --->               
				<cfif isNumeric(ThisSellingPrice) AND isNumeric(PriceOfDefaultComponent)>				
					<cfset ThisAddDeductAmount = ThisSellingPrice - PriceOfDefaultComponent>
    			</cfif>
				            
				<cfset queryAddRow(qryFinal)>
                <cfset querySetCell(qryFinal, "ADDDEDUCTAMOUNT", ThisAddDeductAmount)>
                <cfset querySetCell(qryFinal, "CONFIGCOMPONENTID", qryConfigComponents.CONFIGCOMPONENTID)>
                <cfset querySetCell(qryFinal, "DEFAULTCOMPONENT", qryConfigComponents.DEFAULTCOMPONENT)>
                <cfset querySetCell(qryFinal, "DESCRIPTION", qryConfigComponents.DESCRIPTION)>
                <cfset querySetCell(qryFinal, "ITEMNO", qryConfigComponents.ITEMNO)>
                <cfset querySetCell(qryFinal, "PHOTOIMAGE", qryConfigComponents.PHOTOIMAGE)>
                <cfset querySetCell(qryFinal, "PRICE", ThisSellingPrice)>
            </cfloop>
        
        </cfif>
<!---
qryFinal:<cfdump var="#qryFinal#"><br>
<cfabort>
--->
<!---        
		<cfquery datasource="#This.DataSourceName#" name="qryConfigComponents">
		SELECT	ConfigComponentID, Price, AddDeductAmount, DESCRIPTION, DefaultComponent, ITEMNO
		FROM 	vComponentPrices 
		WHERE	ConfigComponentCategoryID = '#Arguments.ConfigComponentCategoryID#' AND
				CustomerID = '#Arguments.CustomerID#' 
		ORDER BY Price                
		</cfquery>	
--->  

<!---
		<cfquery datasource="#This.DataSourceName#" name="qryConfigComponents">
		SELECT	ConfigComponentID, (Price + Price * .10) AS Price, (AddDeductAmount + AddDeductAmount *.10) AS AddDeductAmount, DESCRIPTION, DefaultComponent, ITEMNO
		FROM 	vComponentPrices 
		WHERE	ConfigComponentCategoryID = '#Arguments.ConfigComponentCategoryID#' AND
				CustomerID = '#Arguments.CustomerID#' 
		ORDER BY Price                
		</cfquery>	
--->


		<cfreturn qryFinal>
	</cffunction>








	<cffunction name="fillComponentOptions_QUOTE" access="public" returntype="struct" output="No">
	<cfargument name="ConfigComponentCategoryID" type="string" required="Yes">
	<cfargument name="PriceListID" type="string" required="Yes">
	<cfargument name="ConfigComponentID" type="string" required="Yes">
    	<cfset var strConfigComponent = structNew()>
		<cfset var qryComponentOptions = queryNew("ConfigComponentID,ITEMNO,DefaultComponent")>

		<cfstoredproc procedure="spr_select_ConfigComponents" datasource="#This.DataSourceName#" blockfactor="15" returncode="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" variable="@ConfigComponentCategoryID" dbvarname="@ConfigComponentCategoryID" value="#Arguments.ConfigComponentCategoryID#" maxlength="50" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" variable="@PriceListID" dbvarname="@PriceListID" value="#Arguments.PriceListID#" maxlength="50" null="No">
			<cfprocresult name="qryComponentOptions" resultset="1">
		</cfstoredproc>
        <cfloop query="qryComponentOptions">
        	<cfif qryComponentOptions.ConfigComponentID IS Arguments.ConfigComponentID>
				<cfset structInsert(strConfigComponent, "Description", qryComponentOptions.Description, True)>
				<cfset structInsert(strConfigComponent, "SellPrice", qryComponentOptions.SellPrice, True)>
				<cfset structInsert(strConfigComponent, "ITEMNO", qryComponentOptions.ITEMNO, True)>
				<cfbreak>
			</cfif>
        </cfloop>
		<cfreturn strConfigComponent>
	</cffunction>
    
    
    
	<cffunction name="getPriceOfDefaultComponent" access="public" returntype="numeric" output="No">
	<cfargument name="ConfigComponentCategoryID" type="string" required="Yes">
	<cfargument name="PriceListID" type="string" required="Yes">
		<cfset var PriceOfDefaultComponent = 0>
		<cfset var qryDefaultComponentPrice = queryNew("SellPrice")>

		<cfstoredproc procedure="spr_get_PriceOfDefaultComponent" datasource="#This.DataSourceName#" blockfactor="15" returncode="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" variable="@ConfigComponentCategoryID" dbvarname="@ConfigComponentCategoryID" value="#Arguments.ConfigComponentCategoryID#" maxlength="50" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" variable="@PriceListID" dbvarname="@PriceListID" value="#Arguments.PriceListID#" maxlength="50" null="No">
			<cfprocresult name="qryDefaultComponentPrice" resultset="1">
		</cfstoredproc>
		
<!---		
		<cfquery datasource="#This.DataSourceName#" name="qryDefaultComponentPrice">
		SELECT	
				(SELECT	TOP 1 tblPriceListComponents.SellPrice
				 FROM	tblPriceListComponents 
				 		INNER JOIN tblPriceListCategories ON 
							tblPriceListCategories.PriceListCategoryID = tblPriceListComponents.PriceListCategoryID
				 WHERE	tblPriceListComponents.ITEMNO = tblConfigComponents.ITEMNO AND 
						tblPriceListCategories.PriceListID = '#Arguments.PriceListID#') AS SellPrice
		FROM 	tblConfigComponents 
		WHERE	(tblConfigComponents.ConfigComponentCategoryID = '#Arguments.ConfigComponentCategoryID#') AND 
				tblConfigComponents.DefaultComponent = 1
		</cfquery>
--->		
		
		<cfif qryDefaultComponentPrice.RecordCount NEQ 0 AND isNumeric(qryDefaultComponentPrice.SellPrice)>
			<cfset PriceOfDefaultComponent = round(qryDefaultComponentPrice.SellPrice)>
		</cfif>
		<cfreturn PriceOfDefaultComponent>
	</cffunction>

	
	<cffunction name="getDefaultComponentItemno" access="public" returntype="query" output="No">
	<cfargument name="ConfigComponentCategoryID" type="string" required="yes">
		<cfset var qryDefaultComponent = queryNew("")>		
		<cfquery datasource="#This.DataSourceName#" name="qryDefaultComponent">
		SELECT	ITEMNO
		FROM 	tblConfigComponents
		WHERE	ConfigComponentCategoryID = '#Arguments.ConfigComponentCategoryID#' AND
				DefaultComponent = 1
		</cfquery>
		<cfreturn qryDefaultComponent>
	</cffunction>

	<!--------------------------------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="validateBulkAdd" access="public" returntype="struct" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
		<cfset var lstRecord = "">
        <cfset var FoundOneSystem = 0>

		<cfif validateRequired(Arguments.Record.AddComponent) EQ 0>
			<cfset stErrors.AddComponent = "Please enter a Part Number">
        <cfelseif NOT itemExists(trim(Arguments.Record.AddComponent))>
			<cfset stErrors.AddComponent = "This is not a valid part number in ACCPAC">
        <cfelseif NOT isConfigurable(trim(Arguments.Record.AddComponent))>
			<cfset stErrors.AddComponent = "This part is not listed as 'configurable' or 'web-ready' ACCPAC">
		</cfif>
        <!--- Make sure at least one of the systems was checked --->
        <cfset lstRecord = structKeyList(Arguments.Record)>
		<cfset FoundOneSystem = 0>
        <cfloop list="#lstRecord#" index="Column">
        	<cfif findNoCase('SYS|', Column) NEQ 0>
				<cfset FoundOneSystem = 1>
                <cfbreak>
			</cfif>        
        </cfloop>
        <cfif NOT FoundOneSystem>
			<cfset stErrors.Systems = "Select at least one of your systems to add the component to">
		</cfif>
        
		<cfreturn stErrors>
	</cffunction>

	<!--------------------------------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="validateBulkAdd2" access="public" returntype="struct" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
		<cfset var lstRecord = "">
        <cfset var FoundOneCategory = 0>

        <!--- Make sure at least one of the categories was checked --->
        <cfset lstRecord = structKeyList(Arguments.Record)>
		<cfset FoundOneCategory = 0>
        <cfloop list="#lstRecord#" index="Column">
        	<cfif findNoCase('CAT|', Column) NEQ 0>
				<cfset FoundOneCategory = 1>
                <cfbreak>
			</cfif>        
        </cfloop>
        <cfif NOT FoundOneCategory>
			<cfset stErrors.Categories = "Select at least one of the categories to add the component to">
		</cfif>
        
		<cfreturn stErrors>
	</cffunction>
	<!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="validateBulkReplace" access="public" returntype="struct" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
		<cfset var lstRecord = "">
        <cfset var FoundOneSystem = 0>
		<cfset var qryCategory1 = queryNew("")>
        <cfset var qryCategory2 = queryNew("")>
        
		<!--- ReplaceComponent --->
		<cfif validateRequired(Arguments.Record.ReplaceComponent) EQ 0>
			<cfset stErrors.ReplaceComponent = "Please enter a Part Number">
        <cfelseif NOT itemExists(trim(Arguments.Record.ReplaceComponent))>
			<cfset stErrors.ReplaceComponent = "This is not a valid part number in ACCPAC">
        <cfelseif NOT isConfigurable(trim(Arguments.Record.ReplaceComponent))>
			<cfset stErrors.ReplaceComponent = "This part is not listed as 'configurable' or 'web-ready' ACCPAC">
		</cfif>
        
		<!--- ReplaceComponentWith --->
		<cfif validateRequired(Arguments.Record.ReplaceComponentWith) EQ 0>
			<cfset stErrors.ReplaceComponentWith = "Please enter a Part Number">
        <cfelseif NOT itemExists(trim(Arguments.Record.ReplaceComponentWith))>
			<cfset stErrors.ReplaceComponentWith = "This is not a valid part number in ACCPAC">
        <cfelseif NOT isConfigurable(trim(Arguments.Record.ReplaceComponentWith))>
			<cfset stErrors.ReplaceComponentWith = "This part is not listed as 'configurable' or 'web-ready' ACCPAC">
		</cfif>
        <!--- Make sure both parts have the same category --->
        <cfif NOT structKeyExists(stErrors, "ReplaceComponent") AND NOT structKeyExists(stErrors, "ReplaceComponentWith")>
            <cfquery datasource="#APPLICATION.DSN_AP#" name="qryCategory1">
            SELECT 	dbo.ICITEM.CATEGORY
            FROM 	dbo.ICITEM
            WHERE 	dbo.ICITEM.ITEMNO = '#Arguments.Record.ReplaceComponent#'
            </cfquery>
            <cfquery datasource="#APPLICATION.DSN_AP#" name="qryCategory2">
            SELECT 	dbo.ICITEM.CATEGORY
            FROM 	dbo.ICITEM
            WHERE 	dbo.ICITEM.ITEMNO = '#Arguments.Record.ReplaceComponentWith#'
            </cfquery>
            <cfif qryCategory1.RecordCount NEQ 0 AND qryCategory2.RecordCount NEQ 0 AND
				  qryCategory1.CATEGORY IS NOT qryCategory2.CATEGORY>
				<cfset stErrors.DifferentCategories = "These parts have different categories:<br>'#Arguments.Record.ReplaceComponent#' is '#qryCategory1.CATEGORY#', '#Arguments.Record.ReplaceComponentWith#' is '#qryCategory2.CATEGORY#'.<br>You can only replace a component with another component of the same category.">
			</cfif>
		</cfif>

        <!--- Make sure at least one of the systems was checked --->
        <cfset lstRecord = structKeyList(Arguments.Record)>
		<cfset FoundOneSystem = 0>
        <cfloop list="#lstRecord#" index="Column">
        	<cfif findNoCase('SYS|', Column) NEQ 0>
				<cfset FoundOneSystem = 1>
                <cfbreak>
			</cfif>        
        </cfloop>
        <cfif NOT FoundOneSystem>
			<cfset stErrors.Systems = "Select at least one of your systems to replace the component">
		</cfif>
        
		<cfreturn stErrors>
	</cffunction>

	<!--------------------------------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="validateBulkReplace2" access="public" returntype="struct" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
		<cfset var lstRecord = "">
        <cfset var FoundOneCategory = 0>
        <!--- Make sure at least one of the categories was checked --->
        <cfset lstRecord = structKeyList(Arguments.Record)>
		<cfset FoundOneCategory = 0>
        <cfloop list="#lstRecord#" index="Column">
        	<cfif findNoCase('CAT|', Column) NEQ 0>
				<cfset FoundOneCategory = 1>
                <cfbreak>
			</cfif>        
        </cfloop>
        <cfif NOT FoundOneCategory>
			<cfset stErrors.Categories = "Select at least one of the categories in which to replace the component">
		</cfif>
		<cfreturn stErrors>
	</cffunction>
	<!-------------------------------------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="validateBulkDelete" access="public" returntype="struct" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
		<cfset var lstRecord = "">
        <cfset var FoundOneSystem = 0>

		<cfif validateRequired(Arguments.Record.DeleteComponent) EQ 0>
			<cfset stErrors.DeleteComponent = "Please enter a Part Number">
        <cfelseif NOT itemExists(trim(Arguments.Record.DeleteComponent))>
			<cfset stErrors.DeleteComponent = "This is not a valid part number in ACCPAC">
        <cfelseif NOT isConfigurable(trim(Arguments.Record.DeleteComponent))>
			<cfset stErrors.DeleteComponent = "This part is not listed as 'configurable' or 'web-ready' ACCPAC">
		</cfif>
        <!--- Make sure at least one of the systems was checked --->
        <cfset lstRecord = structKeyList(Arguments.Record)>
		<cfset FoundOneSystem = 0>
        <cfloop list="#lstRecord#" index="Column">
        	<cfif findNoCase('SYS|', Column) NEQ 0>
				<cfset FoundOneSystem = 1>
                <cfbreak>
			</cfif>        
        </cfloop>
        <cfif NOT FoundOneSystem>
			<cfset stErrors.Systems = "Select at least one of your systems to delete the component from">
		</cfif>
        
		<cfreturn stErrors>
	</cffunction>

	<!--------------------------------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="validateBulkDelete2" access="public" returntype="struct" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
		<cfset var lstRecord = "">
        <cfset var FoundOneCategory = 0>
        <!--- Make sure at least one of the categories was checked --->
        <cfset lstRecord = structKeyList(Arguments.Record)>
		<cfset FoundOneCategory = 0>
        <cfloop list="#lstRecord#" index="Column">
        	<cfif findNoCase('CAT|', Column) NEQ 0>
				<cfset FoundOneCategory = 1>
                <cfbreak>
			</cfif>        
        </cfloop>
        <cfif NOT FoundOneCategory>
			<cfset stErrors.Categories = "Select at least one of the categories to delete the component from">
		</cfif>
		<cfreturn stErrors>
	</cffunction>

	<!----------------------------------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="bulkAddComponent" access="public" returntype="numeric" output="No">
	<cfargument name="strSystems" type="struct" required="Yes">
	<cfargument name="strCategories" type="struct" required="Yes">
	 	<cfset var SystemAddCount = 0>
        <cfset var qryConfigComponents = queryNew("")>
        <cfset var strConfigComponent = structNew()>
        <cfset var qryConfigComponentCategory = queryNew("")>
        <cfset var CURRENTConfigComponentCategoryID = "">
		<cfset var DefaultComponentStatus = 0>
		<cfset var lstSystems = "">
		<cfset var lstCategories = "">
        <cfset var SystemColumn = "">
        <cfset var CategoryColumn = "">
        <cfset var CURRENTConfigSystemID = "">
        <cfset var CURRENTComponentCategoryID = "">      
        <cfset var ConfigComponentID = "">  

		<cfset objConfigComponentCategories = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ConfigComponentCategories")>
		<cfset objComponentPrices = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ComponentPrices")>

		<cfset Arguments.strSystems.AddComponent = trim(Arguments.strSystems.AddComponent)>

		<cfset lstSystems = structKeyList(Arguments.strSystems)>
		<cfset lstCategories= structKeyList(Arguments.strCategories)>

        <cfloop list="#lstSystems#" index="SystemColumn">
        	<cfif findNoCase('SYS|', SystemColumn) NEQ 0>
            	<cfset CURRENTConfigSystemID = removeChars(SystemColumn, 1, 4)>
                
        		<cfloop list="#lstCategories#" index="CategoryColumn">
					<cfif findNoCase('CAT|', CategoryColumn) NEQ 0>
                        <cfset CURRENTComponentCategoryID = removeChars(CategoryColumn, 1, 4)>
                        
                        <!--- Does the component you're trying to add already exist in this system and this category? --->
                        <cfquery datasource="#This.DataSourceName#" name="qryConfigComponents">
                        SELECT	ConfigComponentID
                        FROM    tblConfigComponents
                                INNER JOIN tblConfigComponentCategories ON tblConfigComponents.ConfigComponentCategoryID = tblConfigComponentCategories.ConfigComponentCategoryID
                        WHERE   tblConfigComponents.ITEMNO = '#Arguments.strSystems.AddComponent#' AND
                        		tblConfigComponentCategories.ConfigSystemID = '#CURRENTConfigSystemID#' AND
                        		tblConfigComponentCategories.ComponentCategoryID = '#CURRENTComponentCategoryID#'
                        </cfquery>

						<!--- If not --->
						<cfif qryConfigComponents.RecordCount EQ 0>
                        
                            <!--- Does the Category Exist? --->
                            <cfquery datasource="#This.DataSourceName#" name="qryConfigComponentCategory">
                            SELECT	ConfigComponentCategoryID
                            FROM    tblConfigComponentCategories
                            WHERE   ConfigSystemID = '#CURRENTConfigSystemID#' AND
                                    ComponentCategoryID = '#CURRENTComponentCategoryID#'
                            </cfquery>
                        
                        	<!--- Category Exists --->
                            <cfif qryConfigComponentCategory.RecordCount NEQ 0>
                                <cfset CURRENTConfigComponentCategoryID = qryConfigComponentCategory.ConfigComponentCategoryID>
                                <cfset DefaultComponentStatus = 0>                        
							<!--- Category does not exist; add it --->
                            <cfelse>
                                <cfset strConfigComponentCategory = objConfigComponentCategories.newRecord()>
                                <cfset structInsert(strConfigComponentCategory, "ConfigSystemID", CURRENTConfigSystemID, True)>
                                <cfset structInsert(strConfigComponentCategory, "ComponentCategoryID", CURRENTComponentCategoryID, True)>
                                <cfset structInsert(strConfigComponentCategory, "MaximumQuantity", 1, True)>
                                <cfset structInsert(strConfigComponentCategory, "DefaultQuantity", 1, True)>
                                <cfset CURRENTConfigComponentCategoryID = objConfigComponentCategories.saveRecord(strConfigComponentCategory)>
                                <cfset DefaultComponentStatus = 1>                        
                            </cfif>
                        
                            <!--- Add the component --->
                            <cfset strConfigComponent = newRecord()>
                            <cfset structInsert(strConfigComponent, "ConfigComponentCategoryID", CURRENTConfigComponentCategoryID, True)>
                            <cfset structInsert(strConfigComponent, "ITEMNO", Arguments.strSystems.AddComponent, True)>
                            <cfset structInsert(strConfigComponent, "DESCRIPTION", getItemDescription(Arguments.strSystems.AddComponent), True)>
                            <cfset structInsert(strConfigComponent, "DefaultComponent", DefaultComponentStatus, True)>
                            <cfset ConfigComponentID = saveRecord(strConfigComponent)>
                            
                            <!--- Create price records in tblComponentPrices --->
                            <cfset objComponentPrices.createPricesForComponent(ConfigComponentID)>
                            
                            <cfset SystemAddCount = SystemAddCount + 1>
                        
                        </cfif>
                	</cfif>
              	</cfloop>
          	</cfif>
      	</cfloop>
                
        <cfreturn SystemAddCount>
	</cffunction>
        
	<!---------------------------------------------------------------------------------------------------------------------->
	<cffunction name="bulkAddComponentMaint" access="public" returntype="numeric" output="No">
	<!---
		If adding a component to default systems, add the component to all sales rep systems that are being maintained by these default systems
	--->
	<cfargument name="strRecord" type="struct" required="Yes">
	<cfargument name="strCategories" type="struct" required="Yes">
		<cfset var SystemAddCount = 0>
        <cfset var qryMaintainSystems = queryNew("")>
		<cfset var lstRecord = "">
        <cfset var Column = "">
        <cfset var CURRENTConfigSystemID = "">
        <cfset var strAddSystems = structNew()>
		<cfset objConfigSystems = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ConfigSystems")>       

		<cfset lstRecord = structKeyList(Arguments.strRecord)>
        <cfloop list="#lstRecord#" index="Column">
        	<cfif findNoCase('SYS|', Column) NEQ 0>
            	<cfset CURRENTConfigSystemID = removeChars(Column, 1, 4)>
				<cfif objConfigSystems.isDefaultSystem(CURRENTConfigSystemID)>
                
					<!--- Get a query of all sales rep systems that are being maintain automatically by this default system --->
                    <cfset qryMaintainSystems = objConfigSystems.getMaintenanceSystems(CURRENTConfigSystemID)>
                    
                    <cfif qryMaintainSystems.RecordCount NEQ 0>
						<cfset strAddSystems = structNew()>
                        <cfset structInsert(strAddSystems, "AddComponent", Arguments.strRecord.AddComponent, True)>
                        <cfloop query="qryMaintainSystems">
                            <cfset structInsert(strAddSystems, "SYS|#qryMaintainSystems.ConfigSystemID#", 1, True)>
                        </cfloop>
                        <cfset SystemAddCount = SystemAddCount + bulkAddComponent(strAddSystems, Arguments.strCategories)>
					</cfif>                        
                </cfif>
         	</cfif>
      	</cfloop>
        <cfreturn SystemAddCount>
	</cffunction>

	<!------------------------------------------------------------------------------------------------------------------------------------------------------------------>
	<cffunction name="bulkReplaceComponent" access="public" returntype="numeric" output="No">
	<cfargument name="strSystems" type="struct" required="Yes">
	<cfargument name="strCategories" type="struct" required="Yes">
	    <cfset var SystemReplaceCount = 0>
		<cfset var lstSystems = "">
		<cfset var lstCategories = "">
        <cfset var SystemColumn = "">
        <cfset var CategoryColumn = "">
        <cfset var CURRENTConfigSystemID = "">
        <cfset var CURRENTComponentCategoryID = "">        
        <cfset var qryConfigComponents1 = queryNew("")>
        <cfset var qryConfigComponents2 = queryNew("")>
		<cfset var NewComponentDescription = "">
		<cfset objComponentPrices = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ComponentPrices")>
        
		<cfset Arguments.strSystems.ReplaceComponent = trim(Arguments.strSystems.ReplaceComponent)>
		<cfset Arguments.strSystems.ReplaceComponentWith = trim(Arguments.strSystems.ReplaceComponentWith)>
       	<cfset NewComponentDescription = getItemDescription(Arguments.strSystems.ReplaceComponentWith)>

		<cfset lstSystems = structKeyList(Arguments.strSystems)>
		<cfset lstCategories= structKeyList(Arguments.strCategories)>
        
        <cfloop list="#lstSystems#" index="SystemColumn">
        	<cfif findNoCase('SYS|', SystemColumn) NEQ 0>
            	<cfset CURRENTConfigSystemID = removeChars(SystemColumn, 1, 4)>
                
        		<cfloop list="#lstCategories#" index="CategoryColumn">
					<cfif findNoCase('CAT|', CategoryColumn) NEQ 0>
                        <cfset CURRENTComponentCategoryID = removeChars(CategoryColumn, 1, 4)>
                        
                        <!--- Does the "New" component (ReplaceComponentWith) you're trying to replace already exist in this system and this category? --->
                        <cfquery datasource="#This.DataSourceName#" name="qryConfigComponents1">
                        SELECT	ConfigComponentID
                        FROM    tblConfigComponents
                                INNER JOIN tblConfigComponentCategories ON tblConfigComponents.ConfigComponentCategoryID = tblConfigComponentCategories.ConfigComponentCategoryID
                        WHERE   tblConfigComponents.ITEMNO = '#Arguments.strSystems.ReplaceComponentWith#' AND
                        		tblConfigComponentCategories.ConfigSystemID = '#CURRENTConfigSystemID#' AND
                        		tblConfigComponentCategories.ComponentCategoryID = '#CURRENTComponentCategoryID#'
                        </cfquery>
                        
						<!--- If not --->
						<cfif qryConfigComponents1.RecordCount EQ 0>

							<!--- Does the component you're trying to replace (ReplaceComponent) exist in this system and this category? --->
                            <cfquery datasource="#This.DataSourceName#" name="qryConfigComponents2">
                            SELECT	ConfigComponentID
                            FROM    tblConfigComponents
                                    INNER JOIN tblConfigComponentCategories ON tblConfigComponents.ConfigComponentCategoryID = tblConfigComponentCategories.ConfigComponentCategoryID
                            WHERE   tblConfigComponents.ITEMNO = '#Arguments.strSystems.ReplaceComponent#' AND
                                    tblConfigComponentCategories.ConfigSystemID = '#CURRENTConfigSystemID#' AND
                        			tblConfigComponentCategories.ComponentCategoryID = '#CURRENTComponentCategoryID#'
                            </cfquery>
                        
							<!--- If so --->
                            <cfif qryConfigComponents2.RecordCount NEQ 0>
                                <cfloop query="qryConfigComponents2">
                                    <cfquery datasource="#This.DataSourceName#">
                                    UPDATE	tblConfigComponents
                                    SET 	ITEMNO = '#Arguments.strSystems.ReplaceComponentWith#',
                                            DESCRIPTION = '#NewComponentDescription#'
                                    WHERE 	ConfigComponentID = '#qryConfigComponents2.ConfigComponentID#'
                                    </cfquery>
                                </cfloop>
                                
								<!--- Create price records in tblComponentPrices --->
                                <cfset objComponentPrices.createPricesForComponent(qryConfigComponents2.ConfigComponentID)>
                                
                                <cfset SystemReplaceCount = SystemReplaceCount + 1>
                            </cfif>
                    	</cfif>
                 	</cfif>
             	</cfloop>
          	</cfif>
       	</cfloop>
                            
        <cfreturn SystemReplaceCount>
	</cffunction>
    
	<!--------------------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="bulkReplaceComponentMaint" access="public" returntype="numeric" output="No">
	<!---
		If replacing a component in default systems, replace the component in all sales rep systems that are being maintained by these default systems
	--->
	<cfargument name="strRecord" type="struct" required="Yes">
	<cfargument name="strCategories" type="struct" required="Yes">
		<cfset var SystemReplaceCount = 0>
        <cfset var qryMaintainSystems = queryNew("")>
		<cfset var lstRecord = "">
        <cfset var Column = "">
        <cfset var CURRENTConfigSystemID = "">
        <cfset var strReplaceSystems = structNew()>
		<cfset objConfigSystems = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ConfigSystems")>       

		<cfset lstRecord = structKeyList(Arguments.strRecord)>
        <cfloop list="#lstRecord#" index="Column">
        	<cfif findNoCase('SYS|', Column) NEQ 0>
            	<cfset CURRENTConfigSystemID = removeChars(Column, 1, 4)>
				<cfif objConfigSystems.isDefaultSystem(CURRENTConfigSystemID)>
                
					<!--- Get a query of all sales rep systems that are being maintain automatically by this default system --->
                    <cfset qryMaintainSystems = objConfigSystems.getMaintenanceSystems(CURRENTConfigSystemID)>
                    
                    <cfif qryMaintainSystems.RecordCount NEQ 0>
						<cfset strReplaceSystems = structNew()>
                        <cfset structInsert(strReplaceSystems, "ReplaceComponent", Arguments.strRecord.ReplaceComponent, True)>
                        <cfset structInsert(strReplaceSystems, "ReplaceComponentWith", Arguments.strRecord.ReplaceComponentWith, True)>
                        <cfloop query="qryMaintainSystems">
                            <cfset structInsert(strReplaceSystems, "SYS|#qryMaintainSystems.ConfigSystemID#", 1, True)>
                        </cfloop>
                        <cfset SystemReplaceCount = SystemReplaceCount + bulkReplaceComponent(strReplaceSystems, Arguments.strCategories)>
					</cfif>                        
                </cfif>
         	</cfif>
      	</cfloop>
        <cfreturn SystemReplaceCount>
	</cffunction>

	<!------------------------------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="bulkDeleteComponent" access="public" returntype="struct" output="No">
	<cfargument name="strSystems" type="struct" required="Yes">
	<cfargument name="strCategories" type="struct" required="Yes">
	    <cfset var strBulkDelete = structNew()>
        <cfset var qrySystemsDeleted = queryNew("ConfigSystemID,ComponentCategoryID")>
        <cfset var qrySystemsNotDeleted = queryNew("ConfigSystemID,ComponentCategoryID")>
		<cfset var lstSystems = "">
		<cfset var lstCategories = "">
        <cfset var SystemColumn = "">
        <cfset var CategoryColumn = "">
        <cfset var CURRENTConfigSystemID = "">
        <cfset var CURRENTComponentCategoryID = "">        
        <cfset var qryConfigComponents = queryNew("")>

		<cfset objComponentPrices = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ComponentPrices")>
        
		<cfset Arguments.strSystems.DeleteComponent = trim(Arguments.strSystems.DeleteComponent)>

		<cfset lstSystems = structKeyList(Arguments.strSystems)>
		<cfset lstCategories= structKeyList(Arguments.strCategories)>

        <cfloop list="#lstSystems#" index="SystemColumn">
        	<cfif findNoCase('SYS|', SystemColumn) NEQ 0>
            	<cfset CURRENTConfigSystemID = removeChars(SystemColumn, 1, 4)>
                
        		<cfloop list="#lstCategories#" index="CategoryColumn">
					<cfif findNoCase('CAT|', CategoryColumn) NEQ 0>
                        <cfset CURRENTComponentCategoryID = removeChars(CategoryColumn, 1, 4)>
                
                        <!--- Does the component you're trying to delete exist in this system and this category? --->
                        <cfquery datasource="#This.DataSourceName#" name="qryConfigComponents">
                        SELECT	ConfigComponentID,DefaultComponent
                        FROM    tblConfigComponents
                                INNER JOIN tblConfigComponentCategories ON tblConfigComponents.ConfigComponentCategoryID = tblConfigComponentCategories.ConfigComponentCategoryID
                        WHERE   tblConfigComponents.ITEMNO = '#Arguments.strSystems.DeleteComponent#' AND
                        		tblConfigComponentCategories.ConfigSystemID = '#CURRENTConfigSystemID#' AND
                        		tblConfigComponentCategories.ComponentCategoryID = '#CURRENTComponentCategoryID#'
                        </cfquery>
                        
						<!--- If so --->
                        <cfif qryConfigComponents.RecordCount NEQ 0>
                            <cfif qryConfigComponents.DefaultComponent EQ 1>
                                <cfset queryAddRow(qrySystemsNotDeleted)>
                                <cfset querySetCell(qrySystemsNotDeleted, "ConfigSystemID", CURRENTConfigSystemID)>					
                                <cfset querySetCell(qrySystemsNotDeleted, "ComponentCategoryID", CURRENTComponentCategoryID)>					
                            <cfelse>
                                <cfquery datasource="#This.DataSourceName#">
                                DELETE FROM tblConfigComponents
                                WHERE 	ConfigComponentID = '#qryConfigComponents.ConfigComponentID#'
                                </cfquery>
                                
								<!--- Delete price records in tblComponentPrices --->
                                <cfset objComponentPrices.deletePricesForComponent(qryConfigComponents.ConfigComponentID)>
                                
                                <cfset queryAddRow(qrySystemsDeleted)>
                                <cfset querySetCell(qrySystemsDeleted, "ConfigSystemID", CURRENTConfigSystemID)>					
                                <cfset querySetCell(qrySystemsDeleted, "ComponentCategoryID", CURRENTComponentCategoryID)>					
                            </cfif>
                        </cfif>
                 	</cfif>
               	</cfloop>
            </cfif>
        </cfloop>

		<cfset structInsert(strBulkDelete, "qrySystemsDeleted", qrySystemsDeleted, True)>
		<cfset structInsert(strBulkDelete, "qrySystemsNotDeleted", qrySystemsNotDeleted, True)>

        <cfreturn strBulkDelete>
	</cffunction>

	<!--------------------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="bulkDeleteComponentMaint" access="public" returntype="numeric" output="No">
	<!---
		If deleting a component from default systems, delete the component from all sales rep systems that are being maintained by these default systems
	--->
	<cfargument name="strRecord" type="struct" required="Yes">
	<cfargument name="strCategories" type="struct" required="Yes">
		<cfset var SystemDeleteCount = 0>
        <cfset var qryMaintainSystems = queryNew("")>
		<cfset var lstRecord = "">
        <cfset var Column = "">
        <cfset var CURRENTConfigSystemID = "">
        <cfset var strDeleteSystems = structNew()>
	    <cfset var strBulkDelete = structNew()>
		<cfset objConfigSystems = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ConfigSystems")>       

		<cfset lstRecord = structKeyList(Arguments.strRecord)>
        <cfloop list="#lstRecord#" index="Column">
        	<cfif findNoCase('SYS|', Column) NEQ 0>
            	<cfset CURRENTConfigSystemID = removeChars(Column, 1, 4)>
				<cfif objConfigSystems.isDefaultSystem(CURRENTConfigSystemID)>
                
					<!--- Get a query of all sales rep systems that are being maintain automatically by this default system --->
                    <cfset qryMaintainSystems = objConfigSystems.getMaintenanceSystems(CURRENTConfigSystemID)>
                    
                    <cfif qryMaintainSystems.RecordCount NEQ 0>
						<cfset strDeleteSystems = structNew()>
                        <cfset structInsert(strDeleteSystems, "DeleteComponent", Arguments.strRecord.DeleteComponent, True)>
                        <cfloop query="qryMaintainSystems">
                            <cfset structInsert(strDeleteSystems, "SYS|#qryMaintainSystems.ConfigSystemID#", 1, True)>
                        </cfloop>
                        
                        <cfset strBulkDelete = bulkDeleteComponent(strDeleteSystems, Arguments.strCategories)>
                        <cfset SystemDeleteCount = SystemDeleteCount + strBulkDelete.qrySystemsDeleted.RecordCount>
					</cfif>                        
                </cfif>
         	</cfif>
      	</cfloop>
        <cfreturn SystemDeleteCount>
	</cffunction>

    
	<!---------------------------------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="isConfigurable" access="public" returntype="boolean" output="No">
	<cfargument name="ITEMNO" type="string" required="Yes">
		<cfset var isConfigurable = 0>
        <cfset var qryItem = queryNew("")>
		<cfquery datasource="#APPLICATION.DSN_AP#" name="qryItem">
		SELECT 	dbo.ICITEM.ITEMNO
		FROM 	dbo.ICITEM
		WHERE	dbo.ICITEM.ITEMNO = '#Arguments.ITEMNO#' AND 
        		dbo.ICITEM.ALLOWONWEB = 1
		</cfquery>
        <cfif qryItem.RecordCount NEQ 0>
			<cfset isConfigurable = 1>
		</cfif>
		<cfreturn isConfigurable>
	</cffunction>

	<!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="getDefaultQuantity" access="public" returntype="numeric" output="No">
	<cfargument name="ConfigComponentCategoryID" type="string" required="Yes">
		<cfset var DefaultQuantity = 1>
        <cfset var qryConfigComponentCategories = queryNew("")>
		<cfquery datasource="#This.DataSourceName#" name="qryConfigComponentCategories">
		SELECT	DefaultQuantity
		FROM    tblConfigComponentCategories 
		WHERE   ConfigComponentCategoryID = '#Arguments.ConfigComponentCategoryID#'
		</cfquery>
        <cfif qryConfigComponentCategories.RecordCount NEQ 0>
			<cfset DefaultQuantity = qryConfigComponentCategories.DefaultQuantity>
		</cfif>
		<cfreturn DefaultQuantity>
	</cffunction>

	<!------------------------------------------------------------------------------------------------------------------------------------------>
	<cffunction name="getCases" access="public" returntype="query" output="No">
	<cfargument name="ConfigSystemID" type="string" required="Yes">
        <cfset var qryConfigComponents = queryNew("")>

		<cfquery datasource="#This.DataSourceName#" name="qryConfigComponents">
		SELECT	ConfigComponentID, ITEMNO, Description, Case_ConfigPhotoID, DefaultComponent
		FROM    #This.ViewName# 
		WHERE   ConfigSystemID = '#Arguments.ConfigSystemID#' AND
        		Category = 'CS'
		</cfquery>

		<cfreturn qryConfigComponents>
	</cffunction>

	<!------------------------------------------------------------------------------------------------------------------------------------------>
	<cffunction name="validateCaseImages" access="public" returntype="struct" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
		<cfset var qryConfigComponents = queryNew("")>
		<cfset var FieldName = "">
		<cfset qryConfigComponents = getCases(Arguments.Record.ConfigSystemID)>

		<cfloop query="qryConfigComponents">
			<cfset FieldName = "IMAGE|" & qryConfigComponents.ConfigComponentID>
            <cfif NOT structKeyExists(Arguments.Record, FieldName)>
            	<cfset structInsert(stErrors, FieldName, "Pick an image by checking its radio button:", True)>
            </cfif>
        </cfloop>
		<cfreturn stErrors>
	</cffunction>                

	<!------------------------------------------------------------------------------------------------------------------------------------------>
	<cffunction name="saveCaseimages" access="public" output="No">
	<cfargument name="Record" type="struct" required="Yes">
    	<cfset var lstRecord = "">
        <cfset var Column = "">
        <cfset var ConfigComponentID = "">
        <cfset var ConfigPhotoID = "">
		<cfset lstRecord = structKeyList(Arguments.Record)>
        <cfloop list="#lstRecord#" index="Column">
        	<cfif findNoCase("IMAGE|", Column) NEQ 0>
            	<cfset ConfigComponentID = removeChars(Column, 1, 6)>
                <cfset ConfigPhotoID = Arguments.Record[Column]>
                <cfquery datasource="#This.DataSourceName#">
                UPDATE	tblConfigComponents
                SET 	Case_ConfigPhotoID = '#ConfigPhotoID#'
                WHERE 	ConfigComponentID = '#ConfigComponentID#'
                </cfquery>
            </cfif>
        </cfloop>
	</cffunction>                

</cfcomponent>