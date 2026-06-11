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

	<cfset This.TableName = "tblConfigSystems">
	<cfset This.ViewName = "vConfigSystems">

	<cfset This.Columns = "ConfigSystemID,UserID,Name,SystemNumber,Description,Specs,ConfigPhotoID,Type,TypeSortOrder,ClassificationID,EnergystarApproved,PowerSupplyAutoSelect,SystemBasePrice,DefaultSystem,SortOrder,DefaultConfigSystemID,SalesRepPickDefaultCase">
	<cfset This.ViewColumns = "ConfigSystemID,UserID,FirstName,LastName,Email,MarkupPctWorkstations,MarkupPctNotebooks,MarkupPctServers,Name,SystemNumber,Description,Specs,ConfigPhotoID,DrivePath,PhotoImage,Type,TypeSortOrder,ClassificationID,ClassificationName,EnergystarApproved,SystemBasePrice,DefaultSystem,SortOrder,DefaultConfigSystemID,PowerSupplyAutoSelect,SalesRepPickDefaultCase">
	
	<cfset This.PrimaryKey = "ConfigSystemID">
	
	<cfset This.GenerateUUIDKey = 1>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "Name">
	<cfset This.SortOrder = "Asc">

	<cfset This.SortOrderList = "">
	<cfset This.SortKey = "SortOrder">
	<cfset This.ParentKey = "UserID">
	<cfset This.CreatedKey = "">
	<cfset This.ModifiedKey = "">
	<cfset This.ZipCode1Key = "">
	<cfset This.ZipCode2Key = "">
	<cfset This.SavePrimaryKey = 0>
	<cfset This.ExcludeInUpdates = "">
	<cfset This.ExcludeInInserts = "">

	<cffunction name="newRecord" access="public" returntype="struct" output="no">
		<cfset var stRecord = structNew()>
		<cfset stRecord = super.newRecord()>
		<!--- Fill in UserID --->
		<cfif isDefined("SESSION.adminuserid")>
			<cfset structInsert(stRecord, "UserID", SESSION.adminuserid, True)>
		</cfif>
		<cfset structInsert(stRecord, "SystemBasePrice", 0, True)>
		<cfreturn stRecord>
	</cffunction>

	<!---------------------------------------------------------------------------------------->
	<cffunction name="validateRecord" access="public" returntype="struct" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
		<cfif validateRequired(Arguments.Record.Name) EQ 0>
			<cfset stErrors.Name = "Please enter a name for the system">
		</cfif>

		<cfif Arguments.Record.EnergyStarApproved IS "1" OR 
			 (right(trim(Arguments.Record.Name), 2) IS "ES" AND right(trim(Arguments.Record.Name), 6) IS NOT "Series")>
			<cfif validateInteger(Arguments.Record.SystemNumber) EQ 0>
                <cfset stErrors.SystemNumber = "This appears to be an EnergyStar system: please enter only an integer as the system number.">
            </cfif>
        </cfif>
        
		<cfif validateRequired(Arguments.Record.Type) EQ 0>
			<cfset stErrors.Type = "Please choose one of the types">
		</cfif>
		<cfif validateRequired(Arguments.Record.EnergystarApproved) EQ 0>
			<cfset stErrors.EnergystarApproved = "Please choose one:">
		</cfif>
		<cfif validateRequired(Arguments.Record.ConfigPhotoID) EQ 0>
			<cfset stErrors.ConfigPhotoID = "Please choose one of the images">
		</cfif>
		<cfreturn stErrors>
	</cffunction>

	<!---------------------------------------------------------------------------------------->
	<cffunction name="validatePrice" access="public" returntype="struct" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
		<cfif validateInteger(Arguments.Record.SystemBasePrice) EQ 0>
			<cfset stErrors.SystemBasePrice = "Please enter an integer value">
		</cfif>
		<cfreturn stErrors>
	</cffunction>

	<cffunction name="validateAssignResellers" access="public" returntype="struct" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
		<cfif validateRequired(Arguments.Record.AssignAllResellers) EQ 0>
			<cfset stErrors.AssignAllResellers = "Please choose one of the radio buttons">
		</cfif>
		<cfreturn stErrors>
	</cffunction>

	<!------------------------------------------------------------------------------------------------------------------>
	<cffunction name="saveRecord" access="public" returntype="string" output="No">
	<cfargument name="Record" type="struct" required="No">
	<cfargument name="IgnoreSessionDefaultSystems" type="boolean" required="No" default="0">
		<cfset var RecordID = "">
        <cfset var stFormCopy = structNew()>
        
		<cfif structKeyExists(Arguments.Record, "Type")>
			<cfif Arguments.Record.Type IS "Workstation">
				<cfset structInsert(Arguments.Record, "TypeSortOrder", 1, True)>
			<cfelseif Arguments.Record.Type IS "Notebook">
				<cfset structInsert(Arguments.Record, "TypeSortOrder", 2, True)>
			<cfelseif Arguments.Record.Type IS "Server">
				<cfset structInsert(Arguments.Record, "TypeSortOrder", 3, True)>
			<cfelseif Arguments.Record.Type IS "MiniMountablePC">
				<cfset structInsert(Arguments.Record, "TypeSortOrder", 4, True)>
			</cfif>
		</cfif>
        
        <cfif NOT Arguments.IgnoreSessionDefaultSystems>
			<cfif getSessionValue("DefaultSystems")>
                <cfset structInsert(Arguments.Record, "DefaultSystem", 1, True)>
            <cfelse>
                <cfset structInsert(Arguments.Record, "DefaultSystem", 0, True)>
            </cfif>
        </cfif>

		<cfset RecordID = super.saveRecord(Arguments.Record)>

		<cfreturn RecordID>
	</cffunction>
    
	<!---------------------------------------------------------------------------------------------------------------------->
	<cffunction name="maintainSalesRepSystems1" access="public" output="No">
	<!---
		Page 1: System information
	--->
	<cfargument name="ConfigSystemID" type="string" required="Yes">
        <cfset var qrySavedSystem = queryNew("")>
        <cfset var qryMaintainSystems = queryNew("")>
		
        <cfquery datasource="#This.DataSourceName#" name="qrySavedSystem">
        SELECT	ConfigSystemID, Name, SystemNumber, Description, Specs, ConfigPhotoID, Type, TypeSortOrder, ClassificationID, DefaultSystem,
        		EnergystarApproved, PowerSupplyAutoSelect
        FROM 	tblConfigSystems
        WHERE	ConfigSystemID = '#Arguments.ConfigSystemID#'
        </cfquery>
        <!--- Was this a default system that you just saved? --->
		<cfif qrySavedSystem.RecordCount NEQ 0 AND qrySavedSystem.DefaultSystem EQ 1>
        
			<!--- Get a query of all sales rep systems that are being maintain automatically by this default system --->
            <cfset qryMaintainSystems = getMaintenanceSystems(qrySavedSystem.ConfigSystemID)>
            
			<cfloop query="qryMaintainSystems">
				<cfquery datasource="#This.DataSourceName#">
				UPDATE	tblConfigSystems
				SET 	Name = 				'#qrySavedSystem.Name#',
                		SystemNumber = 		'#qrySavedSystem.SystemNumber#',
                		Description =		'#qrySavedSystem.Description#',
                		Specs =				'#qrySavedSystem.Specs#',
                		ConfigPhotoID =		'#qrySavedSystem.ConfigPhotoID#',
                		Type =				'#qrySavedSystem.Type#',
                		TypeSortOrder =		'#qrySavedSystem.TypeSortOrder#',
                		ClassificationID =	'#qrySavedSystem.ClassificationID#',

                		EnergystarApproved =	'#qrySavedSystem.EnergystarApproved#',
                		PowerSupplyAutoSelect =	'#qrySavedSystem.PowerSupplyAutoSelect#'
                        
				WHERE 	ConfigSystemID = '#qryMaintainSystems.ConfigSystemID#'
				</cfquery>
			</cfloop>
        </cfif>
	</cffunction>

	<!---------------------------------------------------------------------------------------------------------------------->
	<cffunction name="maintainSalesRepSystems1a" access="public" output="No">
	<!---
		Page 1a: Server Option Selections
	--->
	<cfargument name="ConfigSystemID" type="string" required="Yes">
        <cfset var qryMaintainSystems = queryNew("")>
        <cfset var qryServerSelectionsSystems = queryNew("")>
   		<cfset var CURRENTConfigSystemID = "">
        
        <cfif isDefaultSystem(Arguments.ConfigSystemID)>
            <cfquery datasource="#This.DataSourceName#" name="qryServerSelectionsSystems">
            SELECT	ServerOptionSelectionID
            FROM 	tblServerSelectionsSystems
            WHERE	ConfigSystemID = '#Arguments.ConfigSystemID#'
            </cfquery>
<!---
qryServerSelectionsSystems:<cfdump var="#qryServerSelectionsSystems#"><br>
--->        
			<!--- Get a query of all sales rep systems that are being maintain automatically by this default system --->
            <cfset qryMaintainSystems = getMaintenanceSystems(Arguments.ConfigSystemID)>
<!---
qryMaintainSystems:<cfdump var="#qryMaintainSystems#"><br>
<cfabort>
--->
			<cfloop query="qryMaintainSystems">
            	<cfset CURRENTConfigSystemID = qryMaintainSystems.ConfigSystemID>
            
            
				<!--- Remove all server option selections for this system --->
                <cfquery datasource="#This.DataSourceName#">
                DELETE FROM tblServerSelectionsSystems
                WHERE 		ConfigSystemID = '#CURRENTConfigSystemID#'
                </cfquery>

				<!--- Create records in tblServerSelectionsSystems --->
                <cfloop query="qryServerSelectionsSystems">
                    <cfquery datasource="#This.DataSourceName#">
                    INSERT INTO tblServerSelectionsSystems (
                        ServerSelectionsSystemsID, 
                        ConfigSystemID,
                        ServerOptionSelectionID)
                    VALUES (
                        '#createUUID()#', 
                        '#CURRENTConfigSystemID#',
                        '#qryServerSelectionsSystems.ServerOptionSelectionID#')
                    </cfquery>
                </cfloop>
            
			</cfloop>
        </cfif>
	</cffunction>

	<!---------------------------------------------------------------------------------------------------------------------->
	<cffunction name="maintainSalesRepSystems2" access="public" output="No">
	<!---
		Page 2: Categories
	--->
	<cfargument name="strRecord" type="struct" required="Yes">
        <cfset var qryMaintainSystems = queryNew("")>
        <cfset var strMaintainanceSystem = structNew()>
		<cfset objConfigComponentCategories = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ConfigComponentCategories")>
        <cfif isDefaultSystem(Arguments.strRecord.ConfigSystemID)>
			<!--- Get a query of all sales rep systems that are being maintain automatically by this default system --->
            <cfset qryMaintainSystems = getMaintenanceSystems(Arguments.strRecord.ConfigSystemID)>
	        <cfset strMaintainanceSystem = duplicate(Arguments.strRecord)>
			<cfloop query="qryMaintainSystems">
            	<cfset structInsert(strMaintainanceSystem, "ConfigSystemID", qryMaintainSystems.ConfigSystemID, True)>
				<cfset objConfigComponentCategories.assignCategories(strMaintainanceSystem)>
			</cfloop>
        </cfif>
	</cffunction>

	<!---------------------------------------------------------------------------------------------------------------------->
	<cffunction name="maintainSalesRepSystems3" access="public" output="No">
	<!---
		Page 3: Components
	--->
	<cfargument name="strRecord" type="struct" required="Yes">
        <cfset var qryMaintainSystems = queryNew("")>
        <cfset var strMaintainanceSystem = structNew()>
        <cfset var NewConfigComponentCategoryID = "">
        <cfset var qryConfigComponentCategory = queryNew("")>
        <cfset var qryNewConfigComponentCategory = queryNew("")>
		<cfset objConfigComponents = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ConfigComponents")>
        
        <cfif isDefaultSystem(Arguments.strRecord.ConfigSystemID)>
			<!--- Get a query of all sales rep systems that are being maintain automatically by this default system --->
            <cfset qryMaintainSystems = getMaintenanceSystems(Arguments.strRecord.ConfigSystemID)>

			<!--- Get the ComponentCategoryID of the Default system we're saving --->
            <cfquery datasource="#This.DataSourceName#" name="qryConfigComponentCategory">
            SELECT	ComponentCategoryID
            FROM 	tblConfigComponentCategories
            WHERE	ConfigComponentCategoryID = '#Arguments.strRecord.ConfigComponentCategoryID#'
            </cfquery>
			<cfif qryConfigComponentCategory.RecordCount NEQ 0>

				<cfset strMaintainanceSystem = duplicate(Arguments.strRecord)>
                <cfset structInsert(strMaintainanceSystem, "OrigConfigComponentCategoryID", Arguments.strRecord.ConfigComponentCategoryID, True)>
                <cfloop query="qryMaintainSystems">
                
                    <cfquery datasource="#This.DataSourceName#" name="qryNewConfigComponentCategory">
                    SELECT	ConfigComponentCategoryID
                    FROM 	tblConfigComponentCategories
                    WHERE	ConfigSystemID = '#qryMaintainSystems.ConfigSystemID#' AND
                            ComponentCategoryID = '#qryConfigComponentCategory.ComponentCategoryID#'
                    </cfquery>
                    <cfif qryNewConfigComponentCategory.RecordCount NEQ 0>
                        <cfset NewConfigComponentCategoryID = qryNewConfigComponentCategory.ConfigComponentCategoryID>
                        <cfset structInsert(strMaintainanceSystem, "ConfigSystemID", qryMaintainSystems.ConfigSystemID, True)>
                        <cfset structInsert(strMaintainanceSystem, "ConfigComponentCategoryID", NewConfigComponentCategoryID, True)>
                        <cfset objConfigComponents.assignComponents(strMaintainanceSystem)>
                    </cfif>
                </cfloop>
                
         	</cfif>
        </cfif>
	</cffunction>

	<!---------------------------------------------------------------------------------------------------------------------->
	<cffunction name="maintainSalesRepSystems3a" access="public" output="No">
	<!---
		Page 3: Depot Warranty
	--->
	<cfargument name="strRecord" type="struct" required="Yes">
        <cfset var qryMaintainSystems = queryNew("")>
        <cfset var strMaintainanceSystem = structNew()>
        <cfset var NewConfigComponentCategoryID = "">
        <cfset var qryConfigComponentCategory = queryNew("")>
        <cfset var qryNewConfigComponentCategory = queryNew("")>
		<cfset objConfigWarranty = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ConfigWarranty")>
        
        <cfif isDefaultSystem(Arguments.strRecord.ConfigSystemID)>
			<!--- Get a query of all sales rep systems that are being maintain automatically by this default system --->
            <cfset qryMaintainSystems = getMaintenanceSystems(Arguments.strRecord.ConfigSystemID)>

			<!--- Get the ComponentCategoryID of the Default system we're saving --->
            <cfquery datasource="#This.DataSourceName#" name="qryConfigComponentCategory">
            SELECT	ComponentCategoryID
            FROM 	tblConfigComponentCategories
            WHERE	ConfigComponentCategoryID = '#Arguments.strRecord.ConfigComponentCategoryID#'
            </cfquery>
			<cfif qryConfigComponentCategory.RecordCount NEQ 0>

				<cfset strMaintainanceSystem = duplicate(Arguments.strRecord)>
                <cfset structInsert(strMaintainanceSystem, "OrigConfigComponentCategoryID", Arguments.strRecord.ConfigComponentCategoryID, True)>
                <cfloop query="qryMaintainSystems">
                
                    <cfquery datasource="#This.DataSourceName#" name="qryNewConfigComponentCategory">
                    SELECT	ConfigComponentCategoryID
                    FROM 	tblConfigComponentCategories
                    WHERE	ConfigSystemID = '#qryMaintainSystems.ConfigSystemID#' AND
                            ComponentCategoryID = '#qryConfigComponentCategory.ComponentCategoryID#'
                    </cfquery>
                    <cfif qryNewConfigComponentCategory.RecordCount NEQ 0>
                        <cfset NewConfigComponentCategoryID = qryNewConfigComponentCategory.ConfigComponentCategoryID>
                        <cfset structInsert(strMaintainanceSystem, "ConfigSystemID", qryMaintainSystems.ConfigSystemID, True)>
                        <cfset structInsert(strMaintainanceSystem, "ConfigComponentCategoryID", NewConfigComponentCategoryID, True)>
                        <cfset objConfigWarranty.assignWarranty(strMaintainanceSystem)>
                    </cfif>
                </cfloop>
                
         	</cfif>
        </cfif>
	</cffunction>

	<!---------------------------------------------------------------------------------------------------------------------->
	<cffunction name="maintainSalesRepSystems3b" access="public" output="No">
	<!---
		Page 3b: Case Images
	--->
	<cfargument name="strRecord" type="struct" required="Yes">
        <cfset var qryMaintainSystems = queryNew("")>      
		<cfset var qryConfigComponents_Maintenance = queryNew("")>
        <cfset var qryConfigComponents_Default = queryNew("")>
		<cfset objConfigComponents = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ConfigComponents")>

        <cfif isDefaultSystem(Arguments.strRecord.ConfigSystemID)>
        
			<!--- Get a query of all sales rep systems that are being maintain automatically by this default system --->
            <cfset qryMaintainSystems = getMaintenanceSystems(Arguments.strRecord.ConfigSystemID)>

			<cfloop query="qryMaintainSystems">
                <cfquery datasource="#This.DataSourceName#" name="qryConfigComponents_Maintenance">
                SELECT	ConfigComponentID, ITEMNO
                FROM 	vConfigComponents
                WHERE	ConfigSystemID = '#qryMaintainSystems.ConfigSystemID#' AND
                		CATEGORY = 'CS'
                </cfquery>
                <cfloop query="qryConfigComponents_Maintenance">
                    <cfquery datasource="#This.DataSourceName#" name="qryConfigComponents_Default">
                    SELECT	Case_ConfigPhotoID
                    FROM 	vConfigComponents
                    WHERE	ConfigSystemID = '#Arguments.strRecord.ConfigSystemID#' AND
                            CATEGORY = 'CS' AND
                            ITEMNO = '#qryConfigComponents_Maintenance.ITEMNO#'
                    </cfquery>
                    <cfif qryConfigComponents_Default.RecordCount NEQ 0>
                        <cfquery datasource="#This.DataSourceName#">
                        UPDATE	tblConfigComponents
                        SET 	Case_ConfigPhotoID = '#qryConfigComponents_Default.Case_ConfigPhotoID#'
                        WHERE 	ConfigComponentID = '#qryConfigComponents_Maintenance.ConfigComponentID#'
                        </cfquery>
                    </cfif>
                </cfloop>
            </cfloop>
        </cfif>
	</cffunction>
            
	<!---------------------------------------------------------------------------------------------------------------------->
	<cffunction name="maintainSalesRepSystems4" access="public" output="No">
	<!---
		Page 4: Default Quantity, Max Quantity, Default Components
	--->
	<cfargument name="strRecord" type="struct" required="Yes">
        <cfset var qryMaintainSystems = queryNew("")>
        <cfset var strMaintainanceSystem = structNew()>
        <cfset var lstRecord = "">
        <cfset var qryConfigComponentCategories = queryNew("")>
        <cfset var CURRENTConfigSystemID = "">
		<cfset var CURRENTConfigComponentCategoryID = "">
        <cfset var Column = "">
        <cfset var DEFCOMPValue = "">
        <cfset var qryConfigComponents = queryNew("")>
        <cfset var qryConfigComponents2 = queryNew("")>
        <cfset var DEFQTYValue = "">
        <cfset var MAXQTYValue = "">
        <cfset var ThisConfigComponentCategoryID = "">
        <cfset var qryConfigComponentCategories2 = queryNew("")>
        <cfset var QTYValue = "">
        <cfset var CURRENTSalesRepPickDefaultCase = "">
        
		<cfset objConfigComponents = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ConfigComponents")>
<!---
Arguments.strRecord:<cfdump var="#Arguments.strRecord#"><br>
--->        
        <cfif isDefaultSystem(Arguments.strRecord.ConfigSystemID)>
			<!--- Get a query of all sales rep systems that are being maintain automatically by this default system --->
            <cfset qryMaintainSystems = getMaintenanceSystems(Arguments.strRecord.ConfigSystemID)>
<!---
qryMaintainSystems:<cfdump var="#qryMaintainSystems#"><br>
--->
			<cfset lstRecord = structKeyList(Arguments.strRecord)>
            <cfloop query="qryMaintainSystems">
                <cfset CURRENTConfigSystemID = qryMaintainSystems.ConfigSystemID>
                <cfset CURRENTSalesRepPickDefaultCase = qryMaintainSystems.SalesRepPickDefaultCase>

				<cfset strMaintainanceSystem = duplicate(Arguments.strRecord)>
                <cfset structInsert(strMaintainanceSystem, "ConfigSystemID", CURRENTConfigSystemID, True)>
   
               	<cfloop list="#lstRecord#" index="Column">
                	<cfif findNoCase("DEFQTY|", Column) NEQ 0 OR findNoCase("MAXQTY|", Column) NEQ 0>
                    	<cfset ThisConfigComponentCategoryID = removeChars(Column, 1, 7)>

                       	<cfset QTYValue = Arguments.strRecord[Column]>
                        <cfquery datasource="#This.DataSourceName#" name="qryConfigComponentCategories">
                        SELECT	ComponentCategoryID
                        FROM 	tblConfigComponentCategories
                        WHERE	ConfigComponentCategoryID = '#ThisConfigComponentCategoryID#'
                        </cfquery>
                        <cfquery datasource="#This.DataSourceName#" name="qryConfigComponentCategories2">
                        SELECT	ConfigComponentCategoryID
                        FROM 	tblConfigComponentCategories
                        WHERE	ComponentCategoryID = '#qryConfigComponentCategories.ComponentCategoryID#' AND
                        		ConfigSystemID = '#CURRENTConfigSystemID#'
                        </cfquery>
						<cfset structDelete(strMaintainanceSystem, Column)>
                        <cfif findNoCase("DEFQTY|", Column) NEQ 0>
							<cfset structInsert(strMaintainanceSystem, "DEFQTY|#qryConfigComponentCategories2.ConfigComponentCategoryID#", QTYValue, True)>
                        <cfelse>
							<cfset structInsert(strMaintainanceSystem, "MAXQTY|#qryConfigComponentCategories2.ConfigComponentCategoryID#", QTYValue, True)>
                        </cfif>

					<cfelseif findNoCase("DEFCOMP_", Column) NEQ 0>
                    	<cfset ThisConfigComponentCategoryID = removeChars(Column, 1, 8)>
                        <cfquery datasource="#This.DataSourceName#" name="qryConfigComponentCategories">
                        SELECT	ComponentCategoryID
                        FROM 	tblConfigComponentCategories
                        WHERE	ConfigComponentCategoryID = '#ThisConfigComponentCategoryID#'
                        </cfquery>
                        <cfquery datasource="#This.DataSourceName#" name="qryConfigComponentCategories2">
                        SELECT	ConfigComponentCategoryID,IsAdditionalWarranty, CategoryName
                        FROM 	vConfigComponentCategories
                        WHERE	ComponentCategoryID = '#qryConfigComponentCategories.ComponentCategoryID#' AND
                        		ConfigSystemID = '#CURRENTConfigSystemID#'
                        </cfquery>
<!---
qryConfigComponentCategories2:<cfdump var="#qryConfigComponentCategories2#"><br>
--->
                        <cfset DEFCOMPValue = Arguments.strRecord[Column]>
<!---
DEFCOMPValue:<cfdump var="#DEFCOMPValue#"><br>
--->
						<cfif qryConfigComponentCategories2.IsAdditionalWarranty EQ 1>
                    
                            <cfquery datasource="#This.DataSourceName#" name="qryConfigWarranty">
                            SELECT	AdditionalWarrantyID
                            FROM 	tblConfigWarranty
                            WHERE	ConfigWarrantyID = '#DEFCOMPValue#'
                            </cfquery>
    
                            <cfquery datasource="#This.DataSourceName#" name="qryConfigWarranty2">
                            SELECT	ConfigWarrantyID
                            FROM 	tblConfigWarranty
                            WHERE	AdditionalWarrantyID = '#qryConfigWarranty.AdditionalWarrantyID#' AND
                                    ConfigComponentCategoryID = '#qryConfigComponentCategories2.ConfigComponentCategoryID#'                                        
                            </cfquery>
                            <cfset structDelete(strMaintainanceSystem, Column)>
                            <cfset structInsert(strMaintainanceSystem, "DEFCOMP_#qryConfigComponentCategories2.ConfigComponentCategoryID#", qryConfigWarranty2.ConfigWarrantyID, True)>
                            
                        <cfelse>
                        
                        	<!--- Don't update the default case if the Sales Rep is picking the default case on this maintenance system --->
                            <cfif CURRENTSalesRepPickDefaultCase IS NOT "1" OR qryConfigComponentCategories2.CategoryName IS NOT "Case">

                                <cfquery datasource="#This.DataSourceName#" name="qryConfigComponents">
                                SELECT	ITEMNO
                                FROM 	tblConfigComponents
                                WHERE	ConfigComponentID = '#DEFCOMPValue#'
                                </cfquery>
        
                                <cfquery datasource="#This.DataSourceName#" name="qryConfigComponents2">
                                SELECT	ConfigComponentID
                                FROM 	tblConfigComponents
                                WHERE	ITEMNO = '#qryConfigComponents.ITEMNO#' AND
                                        ConfigComponentCategoryID = '#qryConfigComponentCategories2.ConfigComponentCategoryID#'                                        
                                </cfquery>
                                <cfset structDelete(strMaintainanceSystem, Column)>
                                <cfset structInsert(strMaintainanceSystem, "DEFCOMP_#qryConfigComponentCategories2.ConfigComponentCategoryID#", qryConfigComponents2.ConfigComponentID, True)>

                            </cfif>

                        </cfif>

                    </cfif>
                </cfloop>

				<cfset objConfigComponents.saveMarkups(strMaintainanceSystem)>
                
				<cfset objConfigComponents.savePowerSupplies(CURRENTConfigSystemID)>
                
                <cfset objConfigComponents.cleanUpPowerSupplyComponents(CURRENTConfigSystemID)>               
                
                <!--- Set System Image --->
				<cfset objConfigComponents.setSystemImage(CURRENTConfigSystemID)>

			</cfloop>

        </cfif>
	</cffunction>    
   
	<!---------------------------------------------------------------------------------------------------------------------->
	<cffunction name="maintainSalesRepSystems5" access="public" output="No">
	<!---
		Page 5: System Base Price
	--->
	<cfargument name="strRecord" type="struct" required="Yes">
        <cfset var qryMaintainSystems = queryNew("")>
        <cfif isDefaultSystem(Arguments.strRecord.ConfigSystemID)>
			<!--- Get a query of all sales rep systems that are being maintain automatically by this default system --->
            <cfset qryMaintainSystems = getMaintenanceSystems(Arguments.strRecord.ConfigSystemID)>
			<cfloop query="qryMaintainSystems">
				<cfquery datasource="#This.DataSourceName#">
				UPDATE	tblConfigSystems
				SET 	SystemBasePrice = '#Arguments.strRecord.SystemBasePrice#'
				WHERE 	ConfigSystemID = '#qryMaintainSystems.ConfigSystemID#'
				</cfquery>
			</cfloop>
        </cfif>
	</cffunction>
    
	<!---------------------------------------------------------------------------------------------------------------------->
	<cffunction name="isDefaultSystem" access="public" returntype="boolean" output="No">
	<cfargument name="ConfigSystemID" type="string" required="Yes">
        <cfset var isDefaultSystem = 0>
        <cfset var qryConfigSystem = queryNew("")>
        <cfquery datasource="#This.DataSourceName#" name="qryConfigSystem">
        SELECT	DefaultSystem
        FROM 	tblConfigSystems
        WHERE	ConfigSystemID = '#Arguments.ConfigSystemID#'
        </cfquery>
		<cfif qryConfigSystem.RecordCount NEQ 0 AND qryConfigSystem.DefaultSystem EQ 1>
        	<cfset isDefaultSystem = 1>
        </cfif>
        <cfreturn isDefaultSystem>
	</cffunction>

	<!---------------------------------------------------------------------------------------------------------------------->
	<cffunction name="isPowerSupplyAutoSelect" access="public" returntype="boolean" output="No">
	<cfargument name="ConfigSystemID" type="string" required="Yes">
        <cfset var isPowerSupplyAutoSelect = 0>
        <cfset var qryConfigSystem = queryNew("")>
        <cfquery datasource="#This.DataSourceName#" name="qryConfigSystem">
		SELECT 	PowerSupplyAutoSelect
		FROM 	tblConfigSystems
        WHERE	ConfigSystemID = '#Arguments.ConfigSystemID#'
        </cfquery>
		<cfif qryConfigSystem.RecordCount NEQ 0 AND qryConfigSystem.PowerSupplyAutoSelect EQ 1>
        	<cfset isPowerSupplyAutoSelect = 1>
        </cfif>
        <cfreturn isPowerSupplyAutoSelect>
	</cffunction>

	<!---------------------------------------------------------------------------------------------------------------------->
	<cffunction name="getShowPowerSupplyWhenPageLoads" access="public" returntype="boolean" output="No">
	<cfargument name="PowerSupplyAutoSelect" type="boolean" required="Yes">
	<cfargument name="ConfigSystemID" type="string" required="Yes">        
        <cfset var ShowPowerSupplyWhenPageLoads = 0>
        <cfset var qryConfigComponentCategory_CASE = queryNew("")>
        <cfset var qryDefaultComponent = queryNew("")>
		<cfset objConfigComponents = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ConfigComponents")>
        
		<cfif Arguments.PowerSupplyAutoSelect>
            <cfquery datasource="#This.DataSourceName#" name="qryConfigComponentCategory_CASE">
            SELECT 	ConfigComponentCategoryID
            FROM 	vConfigComponentCategories
            WHERE	ConfigSystemID = '#Arguments.ConfigSystemID#' AND
                    CATEGORY = 'CS'
            </cfquery>
<!---            
qryConfigComponentCategory_CASE:<cfdump var="#qryConfigComponentCategory_CASE#"><br>
--->            
            <cfif qryConfigComponentCategory_CASE.RecordCount NEQ 0>
                <cfset qryDefaultComponent = objConfigComponents.getDefaultComponentItemno(qryConfigComponentCategory_CASE.ConfigComponentCategoryID)>
<!---
qryDefaultComponent:<cfdump var="#qryDefaultComponent#"><br>
--->

				<!--- 07/12/2011 --->
<!---
                <cfif trim(qryDefaultComponent.ITEMNO) IS "CS-EV-E4252-BLACK-NPS" OR trim(qryDefaultComponent.ITEMNO) IS "CS-LO-ST951B-VOY/NP">
                    <cfset ShowPowerSupplyWhenPageLoads = 1>
                </cfif>
--->

				<!--- RAB 04/30/2012 --->
<!---           <cfif trim(qryDefaultComponent.ITEMNO) IS "CS-EV-E4252-BLACK-NPS" OR 	--->
                <cfif trim(qryDefaultComponent.ITEMNO) IS "CS-EV-4572B-S2" OR 
				
					  trim(qryDefaultComponent.ITEMNO) IS "CS-LO-ST951B-VOY/NP" OR 
					  trim(qryDefaultComponent.ITEMNO) IS "CS-CE-FX629MBKH" OR 
					  trim(qryDefaultComponent.ITEMNO) IS "CS-CE-TLA397/NP">
                    <cfset ShowPowerSupplyWhenPageLoads = 1>
                </cfif>
                
                
            </cfif>
        </cfif>
<!---
ShowPowerSupplyWhenPageLoads:<cfdump var="#ShowPowerSupplyWhenPageLoads#"><br />
--->        
        <cfreturn ShowPowerSupplyWhenPageLoads>
	</cffunction>


	<!---------------------------------------------------------------------------------------------------------------------->
	<cffunction name="isMaintainedByDefault" access="public" returntype="boolean" output="No">
	<cfargument name="ConfigSystemID" type="string" required="Yes">
        <cfset var isMaintainedByDefault = 0>
        <cfset var qryConfigSystem = queryNew("")>
        <cfset var qryConfigSystem2 = queryNew("")>
        <cfif Arguments.ConfigSystemID IS NOT "">
            <cfquery datasource="#This.DataSourceName#" name="qryConfigSystem">
            SELECT	DefaultSystem, DefaultConfigSystemID
            FROM 	tblConfigSystems
            WHERE	ConfigSystemID = '#Arguments.ConfigSystemID#'
            </cfquery>
            <cfif qryConfigSystem.RecordCount NEQ 0 AND NOT qryConfigSystem.DefaultSystem AND qryConfigSystem.DefaultConfigSystemID IS NOT "">
                <cfquery datasource="#This.DataSourceName#" name="qryConfigSystem2">
                SELECT	ConfigSystemID
                FROM 	tblConfigSystems
                WHERE	ConfigSystemID = '#qryConfigSystem.DefaultConfigSystemID#'
                </cfquery>
                <cfif qryConfigSystem2.RecordCount NEQ 0>
                    <cfset isMaintainedByDefault = 1>
                </cfif>
            </cfif>        
        </cfif>
        <cfreturn isMaintainedByDefault>
	</cffunction>

	<!---------------------------------------------------------------------------------------------------------------------->
	<cffunction name="getMaintenanceSystems" access="public" returntype="query" output="No">
	<cfargument name="ConfigSystemID" type="string" required="Yes">
        <cfset var qryMaintainSystems = queryNew("")>
        <cfquery datasource="#This.DataSourceName#" name="qryMaintainSystems">
        SELECT	ConfigSystemID, SalesRepPickDefaultCase
        FROM 	tblConfigSystems
        WHERE	DefaultConfigSystemID = '#Arguments.ConfigSystemID#' AND
                DefaultSystem = 0
        </cfquery>
        <cfreturn qryMaintainSystems>
	</cffunction>

	<!---------------------------------------------------------------------------------------------------------------------->
	<cffunction name="copyConfigSystem" access="public" returntype="string" output="No">
	<cfargument name="ConfigSystemID" type="string" required="Yes">
		<cfset var NewConfigSystemID = "">
     	<cfset var qryServerSelectionsSystems = queryNew("")>
        
		<cfset objConfigComponentCategories = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ConfigComponentCategories")>

		<!--- Make copy of tblConfigSystems --->
		<cfset strOldSystem = getRecord(Arguments.ConfigSystemID)>
		<cfset strNewSystem = newRecord()>
		<cfloop list="#This.Columns#" index="Column">
			<cfif Column IS "Name">
            	<cfif isMaintainedByDefault(Arguments.ConfigSystemID)>
                    <cfset structInsert(strNewSystem, "Name", strOldSystem.Name, True)>
                <cfelse>
					<cfset NewName = strOldSystem.Name & " [copy]">
                    <cfset structInsert(strNewSystem, "Name", NewName, True)>
                </cfif>
                
			<cfelseif Column IS NOT "ConfigSystemID">
				<cfset structInsert(strNewSystem, Column, strOldSystem[Column], True)>
			</cfif>
		</cfloop>
		<cfset NewConfigSystemID = saveRecord(strNewSystem)>
        
        
        <!--- Create records in tblServerSelectionsSystems --->
        <cfquery datasource="#This.DataSourceName#" name="qryServerSelectionsSystems">
        SELECT	ServerOptionSelectionID
        FROM 	tblServerSelectionsSystems
        WHERE	ConfigSystemID = '#Arguments.ConfigSystemID#'
        </cfquery>
        <cfloop query="qryServerSelectionsSystems">
            <cfquery datasource="#This.DataSourceName#">
            INSERT INTO tblServerSelectionsSystems (
                ServerSelectionsSystemsID, 
                ConfigSystemID,
                ServerOptionSelectionID)
            VALUES (
                '#createUUID()#', 
                '#NewConfigSystemID#',
                '#qryServerSelectionsSystems.ServerOptionSelectionID#')
            </cfquery>
        </cfloop>
        

		<!--- Create records in tblConfigComponentCategories --->
		<cfset objConfigComponentCategories.copyConfigComponentCategories(strOldSystem.ConfigSystemID, NewConfigSystemID)>

		<cfreturn NewConfigSystemID>
	</cffunction>

	<!--------------------------------------------------------------------------------------------------------------------->
	<cffunction name="copyDefaultSystems" access="public" output="No">
		<cfset objComponentPrices = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ComponentPrices")>
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "DefaultSystem", 1, True)>
		<cfset qryDefaultSystems = searchRecords(SearchRecord, "query", "TypeSortOrder, Name")>
		<cfloop query="qryDefaultSystems">
			<cfset NewConfigSystemID = copyConfigSystem(qryDefaultSystems.ConfigSystemID)>
			<cfset strNewConfigSystem = getRecord(NewConfigSystemID)>
			<cfset structInsert(strNewConfigSystem, "UserID", getSessionValue("adminuserid"), True)>
			<cfset structInsert(strNewConfigSystem, "Name", qryDefaultSystems.Name, True)>
			<cfset structInsert(strNewConfigSystem, "DefaultSystem", 0, True)>
			<cfset structInsert(strNewConfigSystem, "SortOrder", qryDefaultSystems.SortOrder, True)>
			<cfset Variables.ConfigSystemID = saveRecord(strNewConfigSystem)>
			
			<!--- Assign this system to all of this sales rep's resellers --->
			<cfset assignResellers(Variables.ConfigSystemID)>
            
			<!--- Create entries in tblComponentPrices for this System if this is a new system --->         
            <cfset objComponentPrices.createPricesForSystem(Variables.ConfigSystemID)>
            
		</cfloop>
	</cffunction>

	<!--------------------------------------------------------------------------------------------------------------------->
	<cffunction name="importSystems" access="public" returntype="boolean" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var ImportedAtLeastOne = 0>
        <cfset var NewSortOrder = 0>
        <cfset var lstRecord = "">
        <cfset var DefaultConfigSystemID = "">
        <cfset var strDefaultSystem = structNew()>
        <cfset var NewConfigSystemID = "">
        <cfset var ImportedName = "">
        <cfset var strNewConfigSystem = structNew()>
        <cfset var MaintainField = "">
		<cfset objComponentPrices = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ComponentPrices")>
        
		<cfset NewSortOrder = 10000>	<!--- Put them at the bottom of the list --->
		<cfset lstRecord = structKeyList(Arguments.Record)>
		<cfloop list="#lstRecord#" index="Column">
			<cfif findNoCase("SYSTEM|", Column) NEQ 0>
				<cfset DefaultConfigSystemID = removeChars(Column,1,7)>
				<cfset strDefaultSystem = getRecord(DefaultConfigSystemID)>
                
				<cfset NewConfigSystemID = copyConfigSystem(DefaultConfigSystemID)>
                <cfset ImportedName = strDefaultSystem.Name & " [imported]">
				<cfset strNewConfigSystem = getRecord(NewConfigSystemID)>
				<cfset structInsert(strNewConfigSystem, "UserID", getSessionValue("adminuserid"), True)>
				<cfset structInsert(strNewConfigSystem, "Name", ImportedName, True)>
				<cfset structInsert(strNewConfigSystem, "DefaultSystem", 0, True)>
				<cfset structInsert(strNewConfigSystem, "SortOrder", strDefaultSystem.SortOrder + NewSortOrder, True)>
                
                <!--- If maintaining the new system from the default, set DefaultConfigSystemID --->
                <cfset MaintainField = "MAINTAIN|" & DefaultConfigSystemID>
                <cfif structKeyExists(Arguments.Record, MaintainField)>
					<cfset structInsert(strNewConfigSystem, "DefaultConfigSystemID", DefaultConfigSystemID, True)>
					<cfset structInsert(strNewConfigSystem, "Name", strDefaultSystem.Name, True)>
                </cfif>

				<cfset Variables.ConfigSystemID = saveRecord(strNewConfigSystem)>
                
				<!--- Assign this system to all of this sales rep's resellers --->
				<cfset assignResellers(Variables.ConfigSystemID)>
                       
				<!--- Create entries in tblComponentPrices for this System if this is a new system --->         
                <cfset objComponentPrices.createPricesForSystem(Variables.ConfigSystemID)>

				<cfset ImportedAtLeastOne = 1>
			</cfif>
		</cfloop>
		<!--- resort all of this rep's systems --->
		<cfif ImportedAtLeastOne>

			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "DefaultSystem", 0, True)>
			<cfset structInsert(SearchRecord, "UserID", getSessionValue("adminuserid"), True)>
			<cfset structInsert(SearchRecord, "Type", "Workstation", True)>
			<cfset qryConfigSystems = searchRecords(SearchRecord, "query", "SortOrder")>
			<cfset NewestSortOrder = 1>
			<cfloop query="qryConfigSystems">
				<cfset strConfigSystem = getRecord(qryConfigSystems.ConfigSystemID)>
				<cfset structInsert(strConfigSystem, "SortOrder", NewestSortOrder, True)>
				<cfset NewestSortOrder = NewestSortOrder + 1>
				<cfset saveRecord(strConfigSystem)>
			</cfloop>

			<cfset structInsert(SearchRecord, "Type", "Notebook", True)>
			<cfset qryConfigSystems = searchRecords(SearchRecord, "query", "SortOrder")>
			<cfset NewestSortOrder = 1>
			<cfloop query="qryConfigSystems">
				<cfset strConfigSystem = getRecord(qryConfigSystems.ConfigSystemID)>
				<cfset structInsert(strConfigSystem, "SortOrder", NewestSortOrder, True)>
				<cfset NewestSortOrder = NewestSortOrder + 1>
				<cfset saveRecord(strConfigSystem)>
			</cfloop>

			<cfset structInsert(SearchRecord, "Type", "Server", True)>
			<cfset qryConfigSystems = searchRecords(SearchRecord, "query", "SortOrder")>
			<cfset NewestSortOrder = 1>
			<cfloop query="qryConfigSystems">
				<cfset strConfigSystem = getRecord(qryConfigSystems.ConfigSystemID)>
				<cfset structInsert(strConfigSystem, "SortOrder", NewestSortOrder, True)>
				<cfset NewestSortOrder = NewestSortOrder + 1>
				<cfset saveRecord(strConfigSystem)>
			</cfloop>
		</cfif>
		
		<cfreturn ImportedAtLeastOne>
	</cffunction>

	<!--------------------------------------------------------------------------------------------------------------------->
	<cffunction name="importSalesRepSystems" access="public" returntype="boolean" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var ImportedAtLeastOne = 0>
		<cfset NewSortOrder = 10000>	<!--- Put them at the bottom of the list --->
<!---
Arguments.Record:<cfdump var="#Arguments.Record#"><br>
<cfabort>
--->
		<cfset lstRecord = structKeyList(Arguments.Record)>
		<cfloop list="#lstRecord#" index="Column">
			<cfif findNoCase("SYSTEM|", Column) NEQ 0>
				<cfset SalesRepConfigSystemID = removeChars(Column,1,7)>
				<cfset strSalesRepSystem = getRecord(SalesRepConfigSystemID)>
				<cfset NewConfigSystemID = copyConfigSystem(SalesRepConfigSystemID)>
				<cfset strNewConfigSystem = getRecord(NewConfigSystemID)>
				<cfset structInsert(strNewConfigSystem, "UserID", getSessionValue("adminuserid"), True)>
				<cfset structInsert(strNewConfigSystem, "Name", strSalesRepSystem.Name, True)>
				<cfset structInsert(strNewConfigSystem, "DefaultSystem", 1, True)>
				<cfset structInsert(strNewConfigSystem, "SortOrder", strSalesRepSystem.SortOrder + NewSortOrder, True)>
				<cfset structInsert(strNewConfigSystem, "DefaultConfigSystemID", "", True)>
				<cfset Variables.ConfigSystemID = saveRecord(strNewConfigSystem)>
				<cfset ImportedAtLeastOne = 1>
                
                
                <!--- Copy this system to all sales reps that have the "MaintainSystemDefault" flag checked --->
                <cfset copyMaintainSystemDefault(Variables.ConfigSystemID, SalesRepConfigSystemID)>
                
                
			</cfif>
		</cfloop>
		<!--- resort all default systems --->
		<cfif ImportedAtLeastOne>
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "DefaultSystem", 1, True)>
			<cfset structInsert(SearchRecord, "Type", "Workstation", True)>
			<cfset qryConfigSystems = searchRecords(SearchRecord, "query", "SortOrder")>
			<cfset NewestSortOrder = 1>
			<cfloop query="qryConfigSystems">
				<cfset strConfigSystem = getRecord(qryConfigSystems.ConfigSystemID)>
				<cfset structInsert(strConfigSystem, "SortOrder", NewestSortOrder, True)>
				<cfset NewestSortOrder = NewestSortOrder + 1>
				<cfset saveRecord(strConfigSystem)>
			</cfloop>

			<cfset structInsert(SearchRecord, "Type", "Notebook", True)>
			<cfset qryConfigSystems = searchRecords(SearchRecord, "query", "SortOrder")>
			<cfset NewestSortOrder = 1>
			<cfloop query="qryConfigSystems">
				<cfset strConfigSystem = getRecord(qryConfigSystems.ConfigSystemID)>
				<cfset structInsert(strConfigSystem, "SortOrder", NewestSortOrder, True)>
				<cfset NewestSortOrder = NewestSortOrder + 1>
				<cfset saveRecord(strConfigSystem)>
			</cfloop>

			<cfset structInsert(SearchRecord, "Type", "Server", True)>
			<cfset qryConfigSystems = searchRecords(SearchRecord, "query", "SortOrder")>
			<cfset NewestSortOrder = 1>
			<cfloop query="qryConfigSystems">
				<cfset strConfigSystem = getRecord(qryConfigSystems.ConfigSystemID)>
				<cfset structInsert(strConfigSystem, "SortOrder", NewestSortOrder, True)>
				<cfset NewestSortOrder = NewestSortOrder + 1>
				<cfset saveRecord(strConfigSystem)>
			</cfloop>
		</cfif>
		
		<cfreturn ImportedAtLeastOne>
	</cffunction>



	<!--------------------------------------------------------------------------------------------------------------------->
	<cffunction name="copyMaintainSystemDefault" access="public" output="No">
    <!---
		Created By:	Ron Barth
		Created On: 12/14/2012
	--->
	<cfargument name="NewDefaultConfigSystemID" type="string" required="Yes">
	<cfargument name="OrigSalesRepConfigSystemID" type="string" required="Yes">
		<cfset var qryAdminAccts = queryNew("")>
		<cfset var qryConfigSystems_Type = queryNew("")>
		<cfset var qryConfigSystems = queryNew("")>
		<cfset var qryConfigSystems_SortOrder = queryNew("")>
		<cfset var strDefaultSystem = structNew()>
		<cfset var strNewConfigSystem = structNew()>
		<cfset var NewConfigSystemID = "">
		<cfset var qryConfigSystems_Name = queryNew("")>
		<cfset var NewSortOrder = 0>	

		<cfset objComponentPrices = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ComponentPrices")>

        <cfquery datasource="#This.DataSourceName#" name="qryAdminAccts">
        SELECT	UserID
        FROM 	tblAdminAccts
        WHERE	Role = 'Sales Rep' AND
        		MaintainSystemDefault = 1
        ORDER BY UserID
        </cfquery>
<!---
qryAdminAccts:<cfdump var="#qryAdminAccts#"><br>
--->
		<!--- Get the type of the original sales rep system --->
        <cfquery datasource="#This.DataSourceName#" name="qryConfigSystems_Type">
        SELECT	Type
        FROM 	tblConfigSystems
        WHERE	ConfigSystemID = '#Arguments.OrigSalesRepConfigSystemID#'
        </cfquery>
<!---
qryConfigSystems_Type:<cfdump var="#qryConfigSystems_Type#"><br>
--->
        <cfloop query="qryAdminAccts">
        	<!--- Is this system already assigned to this sales rep? --->
            <cfquery datasource="#This.DataSourceName#" name="qryConfigSystems">
            SELECT	ConfigSystemID
            FROM 	tblConfigSystems
            WHERE	UserID = '#qryAdminAccts.UserID#' AND
            		ConfigSystemID = '#Arguments.OrigSalesRepConfigSystemID#'
            </cfquery>
<!---            
qryConfigSystems:<cfdump var="#qryConfigSystems#"><br>
--->            
            <cfif qryConfigSystems.RecordCount EQ 0>
            
            	<!--- Import the newly-created default system into the sales rep's systems --->
                <cfquery datasource="#This.DataSourceName#" name="qryConfigSystems_Name">
                SELECT	Name
                FROM 	tblConfigSystems
                WHERE	ConfigSystemID = '#Arguments.NewDefaultConfigSystemID#'
                </cfquery>

				<cfset NewConfigSystemID = copyConfigSystem(Arguments.NewDefaultConfigSystemID)>

				<cfset strNewConfigSystem = getRecord(NewConfigSystemID)>
<!---
strNewConfigSystem:<cfdump var="#strNewConfigSystem#"><br>
--->
				<cfset structInsert(strNewConfigSystem, "UserID", qryAdminAccts.UserID, True)>
				<cfset structInsert(strNewConfigSystem, "Name", qryConfigSystems_Name.Name, True)>
				<cfset structInsert(strNewConfigSystem, "DefaultSystem", 0, True)>
                
                <!--- Get the new sort order --->
                <cfquery datasource="#This.DataSourceName#" name="qryConfigSystems_SortOrder">
                SELECT	TOP 1 SortOrder
                FROM 	tblConfigSystems
                WHERE	UserID = '#qryAdminAccts.UserID#' AND
                		Type = '#qryConfigSystems_Type.Type#'
				ORDER BY SortOrder DESC                        
                </cfquery>
<!---
qryConfigSystems_SortOrder:<cfdump var="#qryConfigSystems_SortOrder#"><br>
--->
                <cfif qryConfigSystems_SortOrder.RecordCount NEQ 0>
					<cfset NewSortOrder = qryConfigSystems_SortOrder.SortOrder + 1> 
                <cfelse>
                	<cfset NewSortOrder = 1>
                </cfif>
                
				<cfset structInsert(strNewConfigSystem, "SortOrder", NewSortOrder, True)>
				<cfset structInsert(strNewConfigSystem, "DefaultConfigSystemID", Arguments.NewDefaultConfigSystemID, True)>
<!---
strNewConfigSystem:<cfdump var="#strNewConfigSystem#"><br>
--->
				<cfset Variables.ConfigSystemID = saveRecord(strNewConfigSystem, 1)>	<!--- 1=IgnoreSessionDefaultSystems --->

				<!--- Assign this system to all of this sales rep's resellers --->
				<cfset assignResellers(Variables.ConfigSystemID, qryAdminAccts.UserID)>

				<!--- Create entries in tblComponentPrices for this System if this is a new system --->         
                <cfset objComponentPrices.createPricesForSystem(Variables.ConfigSystemID)>

            </cfif>
        </cfloop>

	</cffunction>




	<!--------------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="assignResellers" access="public" output="No">
	<cfargument name="ConfigSystemID" type="string" required="Yes">
	<cfargument name="SalesRepUserID" type="string" required="No" default="">
    	<cfset var qryResellers = queryNew("")>
        <cfset var qryResellerSystems = queryNew("")>
        <cfset var strResellerSystem = structNew()>
<!---        
        <cfset var SystemTotal = 0>
        <cfset var SystemTotalEXP = 0>
--->        
		<cfset objResellerSystems = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ResellerSystems")>
		<cfset objConfigComponentsResellers = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ConfigComponentsResellers")>
		<cfset objComponentPrices = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ComponentPrices")>

		<cfset qryResellers = objConfigComponentsResellers.listResellersForSalesRep(Arguments.SalesRepUserID)>


        <cfloop query="qryResellers">
<!---
			<cfif isDefined("qryResellers.PriceListID") AND qryResellers.PriceListID IS NOT "">
                <cfset SystemTotal = ceiling(getSystemTotalPriceDefault(Arguments.ConfigSystemID, qryResellers.PriceListID))>                
                <cfset SystemTotalEXP = ceiling(getSystemTotalPriceDefault(Arguments.ConfigSystemID, qryResellers.PriceListID, 1, qryResellers.CustomerID))>
            <cfelse>
                <cfset SystemTotal = 0>
                <cfset SystemTotalEXP = 0>
            </cfif>
--->            
            <cfquery datasource="#This.DataSourceName#" name="qryResellerSystems">
            SELECT	ResellerSystemID
            FROM 	tblResellerSystems
            WHERE	ConfigSystemID = '#Arguments.ConfigSystemID#' AND
                    CustomerID = '#qryResellers.CustomerID#'
            </cfquery>

            <cfif qryResellerSystems.RecordCount EQ 0>
                <cfset strResellerSystem = objResellerSystems.newRecord()>
                <cfset structInsert(strResellerSystem, "CustomerID", qryResellers.CustomerID, True)>
                <cfset structInsert(strResellerSystem, "ConfigSystemID", Arguments.ConfigSystemID, True)>
<!---                
                <cfset structInsert(strResellerSystem, "SystemPrice", SystemTotal, True)>
                <cfset structInsert(strResellerSystem, "SystemPriceEXP", SystemTotalEXP, True)>
--->                
                <cfset objResellerSystems.saveRecord(strResellerSystem)>
                
				<!--- Create entries in tblComponentPrices for this System --->
<!---                
				<cfset objComponentPrices.createPricesForSystem(Arguments.ConfigSystemID)>
--->                
<!---                
			<cfelse>
				<cfset strResellerSystem = objResellerSystems.getRecord(qryResellerSystems.ResellerSystemID)>
                <cfset structInsert(strResellerSystem, "SystemPrice", SystemTotal, True)>
                <cfset structInsert(strResellerSystem, "SystemPriceEXP", SystemTotalEXP, True)>
                <cfset objResellerSystems.saveRecord(strResellerSystem)>
--->                
            </cfif>
        </cfloop>

	</cffunction>

	<!--------------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="removeResellers" access="public" output="No">
	<cfargument name="ConfigSystemID" type="string" required="Yes">
		<cfset objResellerSystems = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ResellerSystems")>
		<cfset qryResellerSystems = objResellerSystems.listRecordsForParent("ConfigSystemID", Arguments.ConfigSystemID)>
		<cfloop query="qryResellerSystems">
			<cfset objResellerSystems.deleteRecord(qryResellerSystems.ResellerSystemID)>
		</cfloop>
	</cffunction>
	
	<!--------------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="assignCheckedResellers" access="public" output="No">
	<cfargument name="Record" type="struct" required="Yes">
<!---    
        <cfset var SystemTotal = 0>
    	<cfset var SystemTotalEXP = 0>
--->        
		<cfset var ConfigSystemID = Arguments.Record.ConfigSystemID>
		<cfset var lstRecord = structKeyList(Arguments.Record)>
        
		<cfset objResellerSystems = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ResellerSystems")>
		<cfset objConfigComponentsResellers = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ConfigComponentsResellers")>
		<cfset objComponentPrices = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ComponentPrices")>

		<cfset qryResellers = objConfigComponentsResellers.listResellersForSalesRep()>

		<cfloop query="qryResellers">
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "ConfigSystemID", ConfigSystemID, True)>
			<cfset structInsert(SearchRecord, "CustomerID", qryResellers.CustomerID, True)>
			<cfset qryResellerSystems = objResellerSystems.searchRecords(SearchRecord, "query")>
			<cfset InDatabase = 0>
			<cfif qryResellerSystems.RecordCount GT 0>
				<cfset InDatabase = 1>
			</cfif>
			<cfset CheckedOnForm = 0>
			<cfif listContainsNoCase(lstRecord, "RESELLER_#qryResellers.CustomerID#") NEQ 0>
				<cfset CheckedOnForm = 1>
			</cfif>
			<!--- The user unchecked this reseller on the form --->
			<cfif InDatabase AND NOT CheckedOnForm>
				<!--- Delete it --->
				<cfset objResellerSystems.deleteRecord(qryResellerSystems.ResellerSystemID)>
			<!--- The user checked this reseller on the form --->
			<cfelseif NOT InDatabase AND CheckedOnForm>
				<!--- Add it --->
				<cfset strResellerSystem = objResellerSystems.newRecord()>
				<cfset structInsert(strResellerSystem, "ConfigSystemID", ConfigSystemID, True)>
				<cfset structInsert(strResellerSystem, "CustomerID", qryResellers.CustomerID, True)>
<!---                
				<cfif isDefined("qryResellers.PriceListID") AND qryResellers.PriceListID IS NOT "">
                    <cfset SystemTotal =    ceiling(getSystemTotalPriceDefault(ConfigSystemID, qryResellers.PriceListID))>  
               		<cfset SystemTotalEXP = ceiling(getSystemTotalPriceDefault(ConfigSystemID, qryResellers.PriceListID, 1, qryResellers.CustomerID))>
                <cfelse>
                    <cfset SystemTotal = 0>
                	<cfset SystemTotalEXP = 0>
                </cfif>
                <cfset structInsert(strResellerSystem, "SystemPrice", SystemTotal, True)>
                <cfset structInsert(strResellerSystem, "SystemPriceEXP", SystemTotalEXP, True)>
--->                
				<cfset objResellerSystems.saveRecord(strResellerSystem)>

				<!--- Create entries in tblComponentPrices for this System --->
				<cfset objComponentPrices.createPricesForSystem(ConfigSystemID)>
            
            <!--- The user did nothing; update the prices anyway --->
<!---            
            <cfelseif InDatabase>
            
				<cfset strResellerSystem = objResellerSystems.getRecord(qryResellerSystems.ResellerSystemID)>
				<cfif isDefined("qryResellers.PriceListID") AND qryResellers.PriceListID IS NOT "">
                    <cfset SystemTotal =    ceiling(getSystemTotalPriceDefault(ConfigSystemID, qryResellers.PriceListID))>  
               		<cfset SystemTotalEXP = ceiling(getSystemTotalPriceDefault(ConfigSystemID, qryResellers.PriceListID, 1, qryResellers.CustomerID))>
                <cfelse>
                    <cfset SystemTotal = 0>
                	<cfset SystemTotalEXP = 0>
                </cfif>
                <cfset structInsert(strResellerSystem, "SystemPrice", SystemTotal, True)>
                <cfset structInsert(strResellerSystem, "SystemPriceEXP", SystemTotalEXP, True)>
				<cfset objResellerSystems.saveRecord(strResellerSystem)>
--->                
			</cfif>
		</cfloop>
	</cffunction>	
	
	<!--------------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="deleteRecord" access="public" output="No">
	<cfargument name="RecordID" type="string" required="Yes">
		<cfset var qryConfigSystemOLD = queryNew("")>
        <cfset var qryRemainingOnes = queryNew("")>
		<cfset objConfigComponentCategories = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ConfigComponentCategories")>
		<cfset objResellerSystems = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ResellerSystems")>
		<cfset objComponentPrices = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ComponentPrices")>

		<!---<cfset strConfigSystemOLD = getRecord(Arguments.RecordID)>--->
		<cfquery datasource="#This.DataSourceName#" name="qryConfigSystemOLD">
		SELECT	DefaultSystem,UserID,Type
		FROM 	tblConfigSystems
		WHERE	ConfigSystemID = '#Arguments.RecordID#'
		</cfquery>


		<cfset super.deleteRecord(Arguments.RecordID)>

		<!--- Resort the remaining ones --->
		<!---<cfset SearchRecord = structNew()>--->
		<cfif qryConfigSystemOLD.DefaultSystem EQ 1>
			<!---<cfset structInsert(SearchRecord, "DefaultSystem", 1, True)>--->

            <cfquery datasource="#This.DataSourceName#" name="qryRemainingOnes">
            SELECT	ConfigSystemID
            FROM 	tblConfigSystems
            WHERE	DefaultSystem = 1 AND
            		Type = '#qryConfigSystemOLD.Type#'
           	ORDER BY SortOrder
            </cfquery>
            
		<cfelse>
			<!---<cfset structInsert(SearchRecord, "UserID", qryConfigSystemOLD.UserID, True)>--->
            
            <cfquery datasource="#This.DataSourceName#" name="qryRemainingOnes">
            SELECT	ConfigSystemID
            FROM 	tblConfigSystems
            WHERE	DefaultSystem = 0 AND
            		UserID = '#qryConfigSystemOLD.UserID#' AND
            		Type = '#qryConfigSystemOLD.Type#'
           	ORDER BY SortOrder
            </cfquery>
		</cfif>
<!---        
		<cfset structInsert(SearchRecord, "Type", qryConfigSystemOLD.Type, True)>
		<cfset qryRemainingOnes = searchRecords(SearchRecord, "query", "SortOrder")>
--->        
        
		<cfset NewSortOrder = 1>
		<cfloop query="qryRemainingOnes">
        
<!---        
			<cfset strRemainingOne = getRecord(qryRemainingOnes.ConfigSystemID)>
			<cfset structInsert(strRemainingOne, "SortOrder", NewSortOrder, True)>
			<cfset saveRecord(strRemainingOne)>
--->
            <cfquery datasource="#This.DataSourceName#">
            UPDATE	tblConfigSystems
            SET 	SortOrder = '#NewSortOrder#'
            WHERE 	ConfigSystemID = '#qryRemainingOnes.ConfigSystemID#'
            </cfquery>
            
			<cfset NewSortOrder = NewSortOrder + 1>
		</cfloop>
		
		<!--- Delete children records in tblConfigComponentCategories --->
		<cfset qryConfigComponentCategories = objConfigComponentCategories.listRecordsForParent("ConfigSystemID",Arguments.RecordID)>
		<cfloop query="qryConfigComponentCategories">
			<cfset objConfigComponentCategories.deleteRecord(qryConfigComponentCategories.ConfigComponentCategoryID)>
		</cfloop>
        
		<!--- Delete children records in tblResellerSystems --->
        <cfquery datasource="#This.DataSourceName#">
        DELETE FROM tblResellerSystems
        WHERE 		ConfigSystemID = '#Arguments.RecordID#'
        </cfquery>       
<!---        
		<cfset qryResellerSystems = objResellerSystems.listRecordsForParent("ConfigSystemID",Arguments.RecordID)>
		<cfloop query="qryResellerSystems">
			<cfset objResellerSystems.deleteRecord(qryResellerSystems.ResellerSystemID)>
		</cfloop>
--->              
        
        <!--- DELETE RECORDS IN tblComponentPrices --->
        <cfset objComponentPrices.deletePricesForSystem(Arguments.RecordID)>
        
		<cfreturn>
	</cffunction>


	<!--------------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="deleteMaintainSystemDefault" access="public" output="No">
	<cfargument name="RecordID" type="string" required="Yes">
		<cfset var qryAdminAccts = queryNew("")>
		<cfset var qryConfigSystems = queryNew("")>
            
        <cfquery datasource="#This.DataSourceName#" name="qryAdminAccts">
        SELECT	UserID
        FROM 	tblAdminAccts
        WHERE	MaintainSystemDefault = 1
        </cfquery>
		
        <cfloop query="qryAdminAccts">
            <cfquery datasource="#This.DataSourceName#" name="qryConfigSystems">
            SELECT	ConfigSystemID
            FROM 	tblConfigSystems
            WHERE	UserID = '#qryAdminAccts.UserID#' AND
            		DefaultConfigSystemID = '#Arguments.RecordID#' AND
                    DefaultSystem = 0
            </cfquery>
            <cfloop query="qryConfigSystems">
            	<cfset deleteRecord(qryConfigSystems.ConfigSystemID)>
            </cfloop>
        </cfloop>
	</cffunction>
    
<!---
	<cffunction name="getSystemTotalPriceDefault" access="public" returntype="numeric" output="YES">
	<!--- Returns the total system price for all of the default components.
		  DYNAMIC CONFIGURATOR (the one resellers use): 
		  	  Only the ConfigSystemID is passed in
	 	  EXPORTABLE CONFIGURATOR (the one that reseller's customers use):
		  	  ConfigSystemID, CustomerID, and ExportableConfigurator=1 are all passed in
		  --->
	<cfargument name="ConfigSystemID" type="string" required="Yes">
	<cfargument name="CustomerID" type="string" required="No">
	<cfargument name="ExportableConfigurator" type="boolean" required="No">
		<cfset var SystemTotal = 0>
		<cfset objConfigComponents = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ConfigComponents")>
		<cfset objCust = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.Cust")>
		<cfset objPriceListComponents = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.prices.PriceListComponents")>
		<cfset objPriceLists = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.prices.PriceLists")>

		<cfif isDefined("Arguments.ExportableConfigurator")>
			<cfset ExportableConfigurator = Arguments.ExportableConfigurator>
		<cfelse>
			<cfset ExportableConfigurator = 0>
		</cfif>

		<cfif isDefined("Arguments.CustomerID") AND trim(Arguments.CustomerID) IS NOT "">
			<cfset Variables.CustomerID = Arguments.CustomerID>
		<cfelse>
			<cfset loginID = getSessionValue("ID")>
			<cfset qrylogin = objCust.getRecordAsQuery(loginID)>
			<cfset Variables.CustomerID = qrylogin.CustomerID>
		</cfif>

		<cfset Variables.PriceListID = objPriceLists.getCustomerPriceListID(Variables.CustomerID)>

		<cfset strConfigSystem = getRecord(Arguments.ConfigSystemID)>
		<cfif isNumeric(strConfigSystem.SystemBasePrice)>
			<cfset SystemTotal = SystemTotal + strConfigSystem.SystemBasePrice>

			<!--- For the Exportable Configurator, markup the System Base Price by the reseller's markup percentage --->		
			<cfif ExportableConfigurator>
				<cfset qryLogin = objCust.getLoginRecord(Variables.CustomerID)>
				<cfif qryLogin.RecordCount NEQ 0>
					<cfif strConfigSystem.Type IS "Workstation" AND isNumeric(qryLogin.PercentWorkstations)>
						<cfset SystemTotal = SystemTotal + SystemTotal * qryLogin.PercentWorkstations>
					<cfelseif strConfigSystem.Type IS "Notebook" AND isNumeric(qryLogin.PercentNotebooks)>
						<cfset SystemTotal = SystemTotal + SystemTotal * qryLogin.PercentNotebooks>
					<cfelseif strConfigSystem.Type IS "Server" AND isNumeric(qryLogin.PercentServers)>
						<cfset SystemTotal = SystemTotal + SystemTotal * qryLogin.PercentServers>
					</cfif>
					<cfset SystemTotal = round(SystemTotal)>
				</cfif>
			</cfif>
		</cfif>

		<cfset qryConfigComponents = objConfigComponents.listDefaultComponents(Arguments.ConfigSystemID)>
		<cfloop query="qryConfigComponents">
<!---		<cfif NOT ExportableConfigurator>	--->
<!---			<cfset PriceOfThisComponent = round(objConfigComponents.getItemCostMarkedUp(qryConfigComponents.ConfigComponentID, Variables.CustomerID))>	--->
				<cfset PriceOfThisComponent = objPriceListComponents.getSellingPrice(Variables.PriceListID, qryConfigComponents.ITEMNO)>
<!---		<cfelse>	--->
<!---			<cfset PriceOfThisComponent = round(objConfigComponents.getItemCostMarkedUp(qryConfigComponents.ConfigComponentID, Variables.CustomerID, 1))>	--->
<!---			<cfset PriceOfThisComponent = objPriceListComponents.getSellingPrice(Variables.PriceListID, qryConfigComponents.ITEMNO, 1, Variables.CustomerID)>	--->
				<!--- ^^ The "1" at the end indicates this is coming from the Exportable Configurator --->
<!---		</cfif>	--->
			
			<cfif ExportableConfigurator>
				<cfset PriceOfThisComponent = objPriceListComponents.markUpSellingPrice(Variables.CustomerID, qryConfigComponents.ConfigComponentID, PriceOfThisComponent)>
			</cfif>
			
			<cfset SystemTotal = SystemTotal + PriceOfThisComponent>
		</cfloop>
		<cfreturn SystemTotal>
	</cffunction>
--->

	<cffunction name="getSystemTotalPriceDefault" access="public" returntype="numeric" output="YES">
	<!--- Returns the total system price for all of the default components.
		  DYNAMIC CONFIGURATOR (the one resellers use): 
		  	  Only the ConfigSystemID is passed in
	 	  EXPORTABLE CONFIGURATOR (the one that reseller's customers use):
		  	  ConfigSystemID, CustomerID, and ExportableConfigurator=1 are all passed in
		  --->
	<cfargument name="ConfigSystemID" type="string" required="Yes">
	<cfargument name="PriceListID" type="string" required="Yes">
	<cfargument name="ExportableConfigurator" type="boolean" required="No">
	<cfargument name="CustomerID" type="string" required="No">
		<cfset var SystemTotal = 0>
		<cfset var qryConfigSystem = queryNew("")>
		<cfset objCust = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.Cust")>
		<cfset objPriceListComponents = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.prices.PriceListComponents")>

		<cfif isDefined("Arguments.ExportableConfigurator")>
			<cfset ExportableConfigurator = Arguments.ExportableConfigurator>
		<cfelse>
			<cfset ExportableConfigurator = 0>
		</cfif>

		<cfif ExportableConfigurator>
			<cfif isDefined("Arguments.CustomerID") AND trim(Arguments.CustomerID) IS NOT "">
				<cfset Variables.CustomerID = Arguments.CustomerID>
			<cfelse>
				<cfset loginID = getSessionValue("ID")>
				<cfset qrylogin = getLogin_Config(loginID)>
				<cfset Variables.CustomerID = qrylogin.CustomerID>
			</cfif>
		</cfif>

		<cfquery datasource="#This.DataSourceName#" name="qryConfigSystem">
		SELECT	SystemBasePrice,Type
		FROM 	tblConfigSystems
		WHERE	ConfigSystemID = '#Arguments.ConfigSystemID#'
		</cfquery>
		
		<cfif isNumeric(qryConfigSystem.SystemBasePrice)>
			<cfset SystemTotal = SystemTotal + round(qryConfigSystem.SystemBasePrice)>

			<!--- For the Exportable Configurator, markup the System Base Price by the reseller's markup percentage --->		
			<cfif ExportableConfigurator>
				<cfset qryLogin = objCust.getLoginRecord(Variables.CustomerID)>
				<cfif qryLogin.RecordCount NEQ 0>
                	
					<!--- MARGIN PERCENT --->
                    <cfif qryLogin.MarkupType IS "Margin">
						<cfif qryConfigSystem.Type IS "Workstation" AND isNumeric(qryLogin.PercentWorkstations)>
                            <cfset SystemTotal = SystemTotal / (1 - qryLogin.PercentWorkstations)>
                        <cfelseif qryConfigSystem.Type IS "Notebook" AND isNumeric(qryLogin.PercentNotebooks)>
                            <cfset SystemTotal = SystemTotal / (1 - qryLogin.PercentNotebooks)>
                        <cfelseif qryConfigSystem.Type IS "Server" AND isNumeric(qryLogin.PercentServers)>
                            <cfset SystemTotal = SystemTotal / (1 - qryLogin.PercentServers)>
                        <cfelseif qryConfigSystem.Type IS "MiniMountablePC" AND isNumeric(qryLogin.PercentMiniMountablePCs)>
                            <cfset SystemTotal = SystemTotal / (1 - qryLogin.PercentMiniMountablePCs)>
                        </cfif>
                    
                    <!--- MARKUP PERCENTAGES --->
                    <cfelse>
						<cfif qryConfigSystem.Type IS "Workstation" AND isNumeric(qryLogin.PercentWorkstations)>
                            <cfset SystemTotal = SystemTotal + SystemTotal * qryLogin.PercentWorkstations>
                        <cfelseif qryConfigSystem.Type IS "Notebook" AND isNumeric(qryLogin.PercentNotebooks)>
                            <cfset SystemTotal = SystemTotal + SystemTotal * qryLogin.PercentNotebooks>
                        <cfelseif qryConfigSystem.Type IS "Server" AND isNumeric(qryLogin.PercentServers)>
                            <cfset SystemTotal = SystemTotal + SystemTotal * qryLogin.PercentServers>
                        <cfelseif qryConfigSystem.Type IS "MiniMountablePC" AND isNumeric(qryLogin.PercentMiniMountablePCs)>
                            <cfset SystemTotal = SystemTotal + SystemTotal * qryLogin.PercentMiniMountablePCs>
                        </cfif>
                    </cfif>
                        
					<cfset SystemTotal = round(SystemTotal)>
				</cfif>
			</cfif>
		</cfif>
<!---
		<cfquery datasource="#This.DataSourceName#" name="qryConfigComponents">
		SELECT	tblConfigComponents.ITEMNO, tblConfigComponents.ConfigComponentID,
				(SELECT	TOP 1 tblPriceListComponents.SellPrice
				 FROM	tblPriceListComponents 
				 		INNER JOIN tblPriceListCategories ON 
							tblPriceListCategories.PriceListCategoryID = tblPriceListComponents.PriceListCategoryID
				 WHERE	tblPriceListComponents.ITEMNO = tblConfigComponents.ITEMNO AND 
						tblPriceListCategories.PriceListID = '#Arguments.PriceListID#') AS SellPrice, 
             	tblConfigComponentCategories.DefaultQuantity
		FROM 	tblConfigComponents
				INNER JOIN tblConfigComponentCategories ON 
					tblConfigComponents.ConfigComponentCategoryID = tblConfigComponentCategories.ConfigComponentCategoryID
		WHERE	tblConfigComponentCategories.ConfigSystemID = '#Arguments.ConfigSystemID#' AND
				tblConfigComponents.DefaultComponent = 1
		</cfquery>
--->
		<cfquery datasource="#This.DataSourceName#" name="qryConfigComponents">
		SELECT	tblConfigComponents.ITEMNO, tblConfigComponents.ConfigComponentID,
				(SELECT	TOP 1 tblPriceListComponents.SellPrice
				 FROM	tblPriceListComponents 
				 		INNER JOIN tblPriceListCategories ON tblPriceListCategories.PriceListCategoryID = tblPriceListComponents.PriceListCategoryID
				 WHERE	tblPriceListComponents.ITEMNO = tblConfigComponents.ITEMNO AND 
						tblPriceListCategories.PriceListID = '#Arguments.PriceListID#' AND
                        tblPriceListComponents.Active = 1) AS SellPrice, 
             	tblConfigComponentCategories.DefaultQuantity
		FROM 	tblConfigComponents
				INNER JOIN tblConfigComponentCategories ON tblConfigComponents.ConfigComponentCategoryID = tblConfigComponentCategories.ConfigComponentCategoryID
		WHERE	tblConfigComponentCategories.ConfigSystemID = '#Arguments.ConfigSystemID#' AND
				tblConfigComponents.DefaultComponent = 1 AND
                tblConfigComponents.ITEMNO <> '[NONE]'
		</cfquery>

		<cfloop query="qryConfigComponents">
			<cfif isNumeric(qryConfigComponents.SellPrice)>
				<cfset PriceOfThisComponent = round(qryConfigComponents.SellPrice)>
			<cfelse>
       			<cfset PriceOfThisComponent = round(objPriceListComponents.getSellingPrice(Arguments.PriceListID, qryConfigComponents.ITEMNO))>
<!---			<cfset PriceOfThisComponent = 0>	--->
			</cfif>
			<cfif ExportableConfigurator>
				<cfset PriceOfThisComponent = objPriceListComponents.markUpSellingPrice(Variables.CustomerID, qryConfigComponents.ConfigComponentID, PriceOfThisComponent)>
			</cfif>
			<cfset SystemTotal = SystemTotal + (PriceOfThisComponent * qryConfigComponents.DefaultQuantity)>
		</cfloop>
        <cfset SystemTotal = round(SystemTotal)>
		<cfreturn SystemTotal>
	</cffunction>

	<!------------------------------------------------------------------------------------------------------------>
	<cffunction name="getSystemPrice" access="public" returntype="numeric" output="YES">
        <cfargument name="ConfigSystemID" type="string" required="Yes">
        <cfargument name="SystemBasePrice" type="numeric" required="Yes">
        <cfargument name="PriceListID" type="string" required="No">
        <cfargument name="MarkupPercentage" type="string" required="No">
        <cfargument name="MarkupType" type="string" required="No">
        <cfargument name="LoginID" type="string" default="" required="No">
        <cfargument name="ExportableConfigurator" type="boolean" default="0" required="No">

		<cfset var SystemTotal = 0>
        <cfset var qryComponentPrices = queryNew("")>
        <cfset var qryLoginPrices = queryNew("")>
		<cfset var ThisMarkedUpPrice = 0>
		<cfset var qryLogin = queryNew("")>
        <cfset var ThisMarkupPercent = 0>
        <cfset var qryPriceListComponents = queryNew("")>
        <cfset var qryLoginCategories = queryNew("")>
        <cfset var ThereIsACustomMarkupPercent = 0>
        
        <cfif NOT isDefined("Arguments.LoginID")>
        	<cfset Arguments.LoginID = "">
        </cfif>
        <cfif NOT isDefined("Arguments.ExportableConfigurator")>
        	<cfset Arguments.ExportableConfigurator = 0>
        </cfif>
        
<!---        
		<cfset var ExportableConfigurator = 0>
--->
<!---
<table>
<tr>
<td>
Arguments.ConfigSystemID:<cfdump var="#Arguments.ConfigSystemID#"><br>
Arguments.SystemBasePrice:<cfdump var="#Arguments.SystemBasePrice#"><br>
Arguments.PriceListID:<cfdump var="#Arguments.PriceListID#"><br>
Arguments.MarkupPercentage:<cfdump var="#Arguments.MarkupPercentage#"><br>
Arguments.MarkupType:<cfdump var="#Arguments.MarkupType#"><br>
Arguments.ExportableConfigurator:<cfdump var="#Arguments.ExportableConfigurator#"><br>
Arguments.LoginID:<cfdump var="#Arguments.LoginID#"><br>
</td>
</tr>
</table>
--->
<!---
		<cfif isDefined("Arguments.MarkupPercentage") AND isNumeric(Arguments.MarkupPercentage) AND
			  isDefined("Arguments.MarkupType") AND trim(Arguments.MarkupType) IS NOT "">
        	<cfset ExportableConfigurator = 1>
        <cfelse>
        	<cfset ExportableConfigurator = 0>
        </cfif>
--->        
        
<!---
		<cfquery datasource="#This.DataSourceName#" name="qryComponentPrices">
        SELECT 	SUM(tblComponentPrices.Price) AS TotalPrice
        FROM    tblComponentPrices INNER JOIN
                tblConfigComponents ON dbo.tblComponentPrices.ConfigComponentID = dbo.tblConfigComponents.ConfigComponentID 
		WHERE 	tblConfigComponents.DefaultComponent = 1 AND
        		tblComponentPrices.ConfigSystemID = '#Arguments.ConfigSystemID#' AND 
        		tblComponentPrices.PriceListID = '#Arguments.PriceListID#'  
		</cfquery>		
--->


		<!--- REGULAR CONFIGURATOR --->
		<cfif NOT Arguments.ExportableConfigurator>
            <cfquery datasource="#This.DataSourceName#" name="qryComponentPrices">
            SELECT  SUM(tblComponentPrices.Price * tblConfigComponentCategories.DefaultQuantity) AS TotalPrice
    
            FROM    tblComponentPrices INNER JOIN
                    tblConfigComponents ON tblComponentPrices.ConfigComponentID = tblConfigComponents.ConfigComponentID INNER JOIN
                    tblConfigComponentCategories ON tblConfigComponents.ConfigComponentCategoryID = tblConfigComponentCategories.ConfigComponentCategoryID
    
            WHERE 	tblConfigComponents.DefaultComponent = 1 AND
                    tblComponentPrices.ConfigSystemID = '#Arguments.ConfigSystemID#' AND 
                    tblComponentPrices.PriceListID = '#Arguments.PriceListID#'  
            </cfquery>		
        
			<cfif qryComponentPrices.RecordCount NEQ 0 AND isNumeric(qryComponentPrices.TotalPrice)>
                <cfset SystemTotal = qryComponentPrices.TotalPrice>
                <cfif isNumeric(Arguments.SystemBasePrice)>
                    <cfset SystemTotal = SystemTotal + Arguments.SystemBasePrice>
                </cfif>
                <cfset SystemTotal = ceiling(SystemTotal)>
            </cfif>
        
        <!--- EXPORTABLE CONFIGURATOR --->
        <cfelse>
        
        	<!--- Get the markup percentage for components --->
<!---            
            <cfquery datasource="#This.DataSourceName#" name="qryLogin">
			SELECT	PercentComponents
            FROM	login
            WHERE	ID = '#Arguments.LoginID#'            
            </cfquery>
            <cfif qryLogin.RecordCount NEQ 0 AND isNumeric(qryLogin.PercentComponents)>
            	<cfset ThisMarkupPercent = qryLogin.PercentComponents>
			<cfelse>
--->            
            	<cfset ThisMarkupPercent = Arguments.MarkupPercentage>
<!---                
            </cfif>
--->            
        
			<cfif isNumeric(Arguments.SystemBasePrice)>
                <cfset SystemTotal = SystemTotal + Arguments.SystemBasePrice>
            </cfif>
            <cfif Arguments.MarkupType IS "Markup">
            	<cfset SystemTotal = SystemTotal + SystemTotal * Arguments.MarkupPercentage>
			<cfelseif Arguments.MarkupType IS "Margin">
				<cfset SystemTotal = SystemTotal / (1 - Arguments.MarkupPercentage)>
            </cfif>
            
        
            <cfquery datasource="#This.DataSourceName#" name="qryComponentPrices">
            SELECT  dbo.tblConfigComponents.ITEMNO, dbo.tblComponentPrices.Price, dbo.tblConfigComponentCategories.DefaultQuantity
    
            FROM    tblComponentPrices INNER JOIN
                    tblConfigComponents ON tblComponentPrices.ConfigComponentID = tblConfigComponents.ConfigComponentID INNER JOIN
                    tblConfigComponentCategories ON tblConfigComponents.ConfigComponentCategoryID = tblConfigComponentCategories.ConfigComponentCategoryID
    
            WHERE 	tblConfigComponents.DefaultComponent = 1 AND
                    tblComponentPrices.ConfigSystemID = '#Arguments.ConfigSystemID#' AND 
                    tblComponentPrices.PriceListID = '#Arguments.PriceListID#'  
            </cfquery>		
<!---
qryComponentPrices:<cfdump var="#qryComponentPrices#"><br>
--->    
            <cfloop query="qryComponentPrices">
                <!--- Is there a custom price in loginPrices? --->
                <cfquery datasource="#This.DataSourceName#" name="qryLoginPrices">
                SELECT	SellPrice
                FROM	vLoginPrices
                WHERE	ITEMNO = '#trim(qryComponentPrices.ITEMNO)#' AND
                		ID = '#Arguments.LoginID#'
                </cfquery>
                <cfif qryLoginPrices.RecordCount NEQ 0 AND isNumeric(qryLoginPrices.SellPrice)>
                	<cfset SystemTotal = SystemTotal + qryLoginPrices.SellPrice>
                    
				<cfelse>

                
					<!--- Is there a custom markup percentage in loginCategories? --->
                   	<cfset ThereIsACustomMarkupPercent = 0>
                    <cfquery datasource="#This.DataSourceName#" name="qryPriceListComponents">
                    SELECT	PriceListCategoryID
                    FROM	vPriceListComponents
                    WHERE	PriceListID = '#Arguments.PriceListID#' AND
                    		ITEMNO = '#trim(qryComponentPrices.ITEMNO)#' 
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
                    	<cfset ThisMarkedUpPrice = qryComponentPrices.Price + qryComponentPrices.Price * ThisMarkupPercent>
	                	<cfset SystemTotal = SystemTotal + ThisMarkedUpPrice>
                    <cfelse>
                        <cfif Arguments.MarkupType IS "Margin">
                            <cfset ThisMarkedUpPrice = qryComponentPrices.Price / (1 - ThisMarkupPercent)>
                        <cfelse>
                            <cfset ThisMarkedUpPrice = qryComponentPrices.Price + qryComponentPrices.Price * ThisMarkupPercent>
                        </cfif>
                        <cfset SystemTotal = SystemTotal + ThisMarkedUpPrice>
                    </cfif>
                </cfif>
            </cfloop>
			<cfset SystemTotal = ceiling(SystemTotal)>
        
        </cfif>



<!---
SystemTotal:<cfdump var="#SystemTotal#"><br>
--->

<!---
		<cfif qryComponentPrices.RecordCount NEQ 0 AND isNumeric(qryComponentPrices.TotalPrice)>
			<cfset SystemTotal = qryComponentPrices.TotalPrice>
			<cfif isNumeric(Arguments.SystemBasePrice)>
                <cfset SystemTotal = SystemTotal + Arguments.SystemBasePrice>
            </cfif>
            <cfif Arguments.ExportableConfigurator AND Arguments.MarkupType IS "Markup">
            	<cfset SystemTotal = SystemTotal + SystemTotal * Arguments.MarkupPercentage>
			<cfelseif Arguments.ExportableConfigurator AND Arguments.MarkupType IS "Margin">
				<cfset SystemTotal = SystemTotal / (1 - Arguments.MarkupPercentage)>
            </cfif>
            
            <cfset SystemTotal = ceiling(SystemTotal)>
		</cfif>
--->
		<cfreturn SystemTotal>
	</cffunction>



	<!------------------------------------------------------------------------------------------------------------>
	<cffunction name="getSystemTotalPriceDefaultCopy" access="public" returntype="numeric" output="YES">
	<!--- Returns the total system price for all of the components on this quote.  
		  If a component on the quote is no longer available in the configuration, it uses the default component.
	--->
	<cfargument name="ConfigSystemID" type="string" required="Yes">
	<cfargument name="PriceListID" type="string" required="Yes">
	<cfargument name="QuoteSystemID" type="string" required="Yes">
		<cfset var SystemTotal = 0>
		<cfset var qryConfigSystem = queryNew("")>
		<cfset var qryComponentPrices = queryNew("")>
<!---
        <cfset var qryQuoteComponents = queryNew("")>
		<cfset var qryConfigComponents = queryNew("")>
--->        

		<!--- GET SYSTEM BASE PRICE --->
		<cfquery datasource="#This.DataSourceName#" name="qryConfigSystem">
		SELECT	SystemBasePrice
		FROM 	tblConfigSystems
		WHERE	ConfigSystemID = '#Arguments.ConfigSystemID#'
		</cfquery>		
		<cfif isNumeric(qryConfigSystem.SystemBasePrice)>
			<cfset SystemTotal = SystemTotal + round(qryConfigSystem.SystemBasePrice)>
		</cfif>
	
		<!--- GET TOTAL PRICE OF COMPONENTS ON THIS QUOTE --->
		<cfquery datasource="#This.DataSourceName#" name="qryComponentPrices">
        SELECT	SUM(tblComponentPrices.Price * tblQuoteComponents.Quantity) AS ComponentsTotalPrice
        FROM   	tblComponentPrices INNER JOIN
                tblQuoteComponents ON tblQuoteComponents.ITEMNO = tblComponentPrices.ITEMNO
        WHERE   (tblComponentPrices.PriceListID = '#Arguments.PriceListID#') AND 
                (tblComponentPrices.ConfigSystemID = '#Arguments.ConfigSystemID#') AND 
                (tblQuoteComponents.ITEMNO <> '[NONE]') AND 
                (tblQuoteComponents.QuoteSystemID = '#Arguments.QuoteSystemID#')
		</cfquery>
		<cfif isNumeric(qryComponentPrices.ComponentsTotalPrice)>
			<cfset SystemTotal = SystemTotal + round(qryComponentPrices.ComponentsTotalPrice)>
		</cfif>

		<!--- THE OLD WAY --->
<!---
		<cfset objPriceListComponents = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.prices.PriceListComponents")>
		
		<cfquery datasource="#This.DataSourceName#" name="qryConfigSystem">
		SELECT	SystemBasePrice
		FROM 	tblConfigSystems
		WHERE	ConfigSystemID = '#Arguments.ConfigSystemID#'
		</cfquery>		
		<cfif isNumeric(qryConfigSystem.SystemBasePrice)>
			<cfset SystemTotal = SystemTotal + round(qryConfigSystem.SystemBasePrice)>
		</cfif>

		<cfquery datasource="#This.DataSourceName#" name="qryQuoteComponents">
		SELECT	*
		FROM 	tblQuoteComponents
		WHERE	QuoteSystemID = '#Arguments.QuoteSystemID#'
		</cfquery>
		<cfloop query="qryQuoteComponents">
			
            <cfquery datasource="#This.DataSourceName#" name="qryConfigComponents">
            SELECT	ITEMNO,
                    (SELECT	TOP 1 tblPriceListComponents.SellPrice
                     FROM	tblPriceListComponents 
                            INNER JOIN tblPriceListCategories ON 
                                tblPriceListCategories.PriceListCategoryID = tblPriceListComponents.PriceListCategoryID
                     WHERE	tblPriceListComponents.ITEMNO = vConfigComponents.ITEMNO AND 
                            tblPriceListCategories.PriceListID = '#Arguments.PriceListID#') AS SellPrice
            FROM 	vConfigComponents
            WHERE	ConfigSystemID = '#Arguments.ConfigSystemID#' AND
            		ITEMNO = '#qryQuoteComponents.ITEMNO#'
            </cfquery>
            
            <cfif qryConfigComponents.RecordCount EQ 0>
                <cfquery datasource="#This.DataSourceName#" name="qryConfigComponents">
                SELECT	ITEMNO,
                        (SELECT	TOP 1 tblPriceListComponents.SellPrice
                         FROM	tblPriceListComponents 
                                INNER JOIN tblPriceListCategories ON 
                                    tblPriceListCategories.PriceListCategoryID = tblPriceListComponents.PriceListCategoryID
                         WHERE	tblPriceListComponents.ITEMNO = vConfigComponents.ITEMNO AND 
                                tblPriceListCategories.PriceListID = '#Arguments.PriceListID#') AS SellPrice
                FROM 	vConfigComponents
                WHERE	ConfigSystemID = '#Arguments.ConfigSystemID#' AND
                        CategoryName = '#qryQuoteComponents.TypeName#' AND
                        DefaultComponent = 1
                </cfquery>
    		</cfif>
            
            <cfif qryConfigComponents.RecordCount NEQ 0>
				<cfif isNumeric(qryConfigComponents.SellPrice)>
                    <cfset PriceOfThisComponent = round(qryConfigComponents.SellPrice)>
                <cfelse>
                    <cfset PriceOfThisComponent = round(objPriceListComponents.getSellingPrice(Arguments.PriceListID, qryConfigComponents.ITEMNO))>
                </cfif>
                
				<!--- Multiply by Quantity --->
                <cfif isNumeric(qryQuoteComponents.Quantity)>
                    <cfset PriceOfThisComponent = PriceOfThisComponent * qryQuoteComponents.Quantity>
                </cfif>
                
				<cfset SystemTotal = SystemTotal + PriceOfThisComponent>
			</cfif>
        </cfloop>
        <cfset SystemTotal = round(SystemTotal)>
--->        

		<cfreturn SystemTotal>
	</cffunction>

	<!------------------------------------------------------------------------------------------------------------>
	<cffunction name="getSystemTotalPriceEdit" access="public" returntype="numeric" output="YES">
	<cfargument name="strQuoteScreen3" type="struct" required="Yes">
		<cfset var SystemTotal = 0>
		<cfset var lstRecord = "">
        <cfset var Column = "">
        <cfset var SellingPrice = 0>
        <cfset var ConfigComponentCategoryID = "">
        <cfset var QuantityField = "">

		<cfif isNumeric(Arguments.strQuoteScreen3.SystemBasePrice)>
			<cfset SystemTotal = SystemTotal + round(Arguments.strQuoteScreen3.SystemBasePrice)>
		</cfif>
		<cfset lstRecord = structKeyList(Arguments.strQuoteScreen3)>
		<cfloop list="#lstRecord#" index="Column">
        	<cfif findNoCase('CAT_', Column) NEQ 0>
				<cfset SellingPrice = removeChars(Arguments.strQuoteScreen3[Column], 1, findNoCase('|', Arguments.strQuoteScreen3[Column]))>
				<cfset SellingPrice = left(SellingPrice, findNoCase('|', SellingPrice)-1)>

				<cfif isNumeric(SellingPrice)>

					<!--- Multiply by Quantity --->
                    <cfset ConfigComponentCategoryID = removeChars(Column, 1, 4)>
                    <cfset QuantityField = "QTY|" & ConfigComponentCategoryID>
                    <cfif structKeyExists(Arguments.strQuoteScreen3, QuantityField) AND isNumeric(Arguments.strQuoteScreen3[QuantityField])>
                        <cfset SellingPrice = SellingPrice * Arguments.strQuoteScreen3[QuantityField]>
                    </cfif>
                
					<cfset SystemTotal = SystemTotal + round(SellingPrice)>
				</cfif>
			</cfif>
        </cfloop>
        <cfset SystemTotal = round(SystemTotal)>
		<cfreturn SystemTotal>
	</cffunction>



	<cffunction name="getSystemTotalPriceFromQuote" access="public" returntype="numeric" output="no">
	<!--- Returns the total system price for all of the components selected in the quote --->
	<cfargument name="ConfigSystemID" type="string" required="Yes">
	<cfargument name="QuoteSystemID" type="string" required="Yes">
		<cfset var SystemTotal = 0>
		<cfset objCust = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.Cust")>
		<cfset objPriceListComponents = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.prices.PriceListComponents")>
		<cfset objPriceLists = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.prices.PriceLists")>
		<cfset objQuoteComponents = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.QuoteComponents")>

		<cfset loginID = getSessionValue("ID")>
		<cfset qrylogin = objCust.getRecordAsQuery(loginID)>
		<cfset Variables.CustomerID = qrylogin.CustomerID>
		<cfset Variables.PriceListID = objPriceLists.getCustomerPriceListID(Variables.CustomerID)>

		<cfset strConfigSystem = getRecord(Arguments.ConfigSystemID)>
		<cfif isNumeric(strConfigSystem.SystemBasePrice)>
			<cfset SystemTotal = SystemTotal + strConfigSystem.SystemBasePrice>
		</cfif>

		<cfset qryQuoteComponents = objQuoteComponents.listRecordsForParent("QuoteSystemID", Arguments.QuoteSystemID)>
<!---
qryQuoteComponents:<cfdump var="#qryQuoteComponents#">
--->
		<cfloop query="qryQuoteComponents">
			<cfset PriceOfThisComponent = objPriceListComponents.getSellingPrice(Variables.PriceListID, qryQuoteComponents.ITEMNO)>
<!---
ITEMNO:<cfdump var="#qryQuoteComponents.ITEMNO#"> 
ITEMDESC:<cfdump var="#qryQuoteComponents.ITEMDESC#"> 
PriceOfThisComponent:<cfdump var="#PriceOfThisComponent#"><br>
--->
			<!--- Multiply by Quantity --->
            <cfif isNumeric(qryQuoteComponents.Quantity)>
                <cfset PriceOfThisComponent = PriceOfThisComponent * qryQuoteComponents.Quantity>
            </cfif>

			<cfset SystemTotal = SystemTotal + PriceOfThisComponent>
		</cfloop>
<!---
<cfabort>
--->
		<cfreturn SystemTotal>
	</cffunction>

	<!----------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="getSystemTotalPrice2" access="public" returntype="numeric" output="No">
	<cfargument name="Record" type="struct" required="yes">
		<cfset var SystemTotal = 0>
		<cfset var lstRecord = structKeyList(Arguments.Record)>
		<cfset var Column = "">
		<cfset var FieldValue = "">
		<cfset var CURRENT_ID = "">
		<cfset var QtyField = "">
		<cfset var ThisPrice = 0>
		<cfset var QuantityValue = 0>
<!---
Arguments.Record:<cfdump var="#Arguments.Record#"><br>
lstRecord:<cfdump var="#lstRecord#"><br>
--->
		<cfloop list="#lstRecord#" index="Column">
        	<cfif findNoCase("CAT_", Column) NEQ 0>
            
            	<cfset CURRENT_ID = removeChars(Column, 1, 4)>
            
            	<cfset FieldValue = Arguments.Record[Column]>
<!---
FieldValue:<cfdump var="#FieldValue#"><br>
--->                
                <cfset ThisPrice = removeChars(FieldValue, 1, findNoCase('|', FieldValue))>
<!---
ThisPrice:<cfdump var="#ThisPrice#"><br>
--->
                <cfset ThisPrice = left(trim(ThisPrice), findNoCase('|', ThisPrice)-1)>
<!---                
ThisPrice:<cfdump var="#ThisPrice#"><br>
--->
				<cfset QtyField = "QTY|" & CURRENT_ID>
				<cfset QuantityValue = Arguments.Record[QtyField]>

				<cfif isNumeric(ThisPrice)>
                	<cfif isNumeric(QuantityValue)>
                    	<cfset SystemTotal = SystemTotal + ThisPrice * QuantityValue>
                    <cfelse>
                    	<cfset SystemTotal = SystemTotal + ThisPrice>
                    </cfif>
                </cfif>                

            </cfif>
        </cfloop>
<!---
<br><br>
SystemTotal:<cfdump var="#SystemTotal#"><br>
--->
		<cfreturn SystemTotal>
    </cffunction>


	<!----------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="getSystemTotalPrice" access="public" returntype="numeric" output="No">
	<!--- Returns the total system price for the system based on the selected components 
		  DYNAMIC CONFIGURATOR (the one resellers use): 
		  	  Only the Record is passed in
	 	  EXPORTABLE CONFIGURATOR (the one that reseller's customers use):
		  	  Record and ExportableConfigurator=1 are passed in
	--->
	<cfargument name="Record" type="struct" required="yes">
	<cfargument name="ExportableConfigurator" type="boolean" required="No">
		<cfset var SystemTotal = 0>
		<cfset var ConfigComponentCategoryID = "">
        <cfset var QuantityField = "">        
        
		<cfset objConfigComponents = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ConfigComponents")>
		<cfset objCust = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.Cust")>
		<cfset objPriceLists = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.prices.PriceLists")>
		<cfset objPriceListComponents = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.prices.PriceListComponents")>
		<cfif isDefined("Arguments.ExportableConfigurator")>
			<cfset ExportableConfigurator = Arguments.ExportableConfigurator>
		<cfelse>
			<cfset ExportableConfigurator = 0>
		</cfif>

		<cfif isDefined("Arguments.Record.CustomerID")>
			<cfset Variables.CustomerID = Arguments.Record.CustomerID>
		<cfelse>
			<cfset loginID = getSessionValue("ID")>
			<cfset qrylogin = objCust.getRecordAsQuery(loginID)>
			<cfset Variables.CustomerID = qrylogin.CustomerID>
		</cfif>

		<cfset Variables.PriceListID = objPriceLists.getCustomerPriceListID(Variables.CustomerID)>

		<cfset strConfigSystem = getRecord(Arguments.Record.ConfigSystemID)>
		<cfif isNumeric(strConfigSystem.SystemBasePrice)>
			<cfset SystemTotal = SystemTotal + strConfigSystem.SystemBasePrice>
			
			<!--- For the Exportable Configurator, markup the System Base Price by the reseller's markup percentage --->		
			<cfif ExportableConfigurator>
				<cfset qryLogin = objCust.getLoginRecord(Variables.CustomerID)>
				<cfif qryLogin.RecordCount NEQ 0>
                
					<!--- MARGIN PERCENT --->
                    <cfif qryLogin.MarkupType IS "Margin">
						<cfif strConfigSystem.Type IS "Workstation" AND isNumeric(qryLogin.PercentWorkstations)>
                            <cfset SystemTotal = SystemTotal / (1 - qryLogin.PercentWorkstations)>
                        <cfelseif strConfigSystem.Type IS "Notebook" AND isNumeric(qryLogin.PercentNotebooks)>
                            <cfset SystemTotal = SystemTotal / (1 - qryLogin.PercentNotebooks)>
                        <cfelseif strConfigSystem.Type IS "Server" AND isNumeric(qryLogin.PercentServers)>
                            <cfset SystemTotal = SystemTotal / (1 - qryLogin.PercentServers)>
                        <cfelseif strConfigSystem.Type IS "MiniMountablePC" AND isNumeric(qryLogin.PercentMiniMountablePCs)>
                            <cfset SystemTotal = SystemTotal / (1 - qryLogin.PercentMiniMountablePCs)>
                        </cfif>
                    
                    <!--- MARKUP PERCENTAGES --->
                    <cfelse>
						<cfif strConfigSystem.Type IS "Workstation" AND isNumeric(qryLogin.PercentWorkstations)>
                            <cfset SystemTotal = SystemTotal + SystemTotal * qryLogin.PercentWorkstations>
                        <cfelseif strConfigSystem.Type IS "Notebook" AND isNumeric(qryLogin.PercentNotebooks)>
                            <cfset SystemTotal = SystemTotal + SystemTotal * qryLogin.PercentNotebooks>
                        <cfelseif strConfigSystem.Type IS "Server" AND isNumeric(qryLogin.PercentServers)>
                            <cfset SystemTotal = SystemTotal + SystemTotal * qryLogin.PercentServers>
                        <cfelseif strConfigSystem.Type IS "MiniMountablePC" AND isNumeric(qryLogin.PercentMiniMountablePCs)>
                            <cfset SystemTotal = SystemTotal + SystemTotal * qryLogin.PercentMiniMountablePCs>
                        </cfif>
                    </cfif>
                        
					<cfset SystemTotal = round(SystemTotal)>
				</cfif>
			</cfif>
		</cfif>

		<cfset lstRecord = structKeyList(Arguments.Record)>
		<cfloop list="#lstRecord#" index="Column">
			<cfif findNoCase("CAT_", Column) NEQ 0>
				<cfset ThisColumnValue = trim(Arguments.Record[Column])>
				<cfset ConfigComponentID = left(ThisColumnValue, FindNoCase("|",ThisColumnValue)-1)>

<!---
				<cfif NOT ExportableConfigurator>
					<cfset PriceOfThisComponent = round(objConfigComponents.getItemCostMarkedUp(ConfigComponentID, Variables.CustomerID))>
				<cfelse>
					<cfset PriceOfThisComponent = round(objConfigComponents.getItemCostMarkedUp(ConfigComponentID, Variables.CustomerID, 1))>
				</cfif>
--->
				<cfset strConfigComponent = objConfigComponents.getRecord(ConfigComponentID)>
				<cfset PriceOfThisComponent = objPriceListComponents.getSellingPrice(Variables.PriceListID, strConfigComponent.ITEMNO)>
				<cfif ExportableConfigurator>
					<cfset PriceOfThisComponent = objPriceListComponents.markUpSellingPrice(Variables.CustomerID, ConfigComponentID, PriceOfThisComponent)>
				</cfif>
                
				<!--- Multiply by Quantity --->
				<cfset ConfigComponentCategoryID = removeChars(Column, 1, 4)>
                <cfset QuantityField = "QTY|" & ConfigComponentCategoryID>
                <cfif structKeyExists(Arguments.Record, QuantityField) AND isNumeric(Arguments.Record[QuantityField])>
					<cfset PriceOfThisComponent = PriceOfThisComponent * Arguments.Record[QuantityField]>
				</cfif>

				<cfset SystemTotal = SystemTotal + PriceOfThisComponent>
			</cfif>
		</cfloop>
		
		<cfset SystemTotal = numberFormat(SystemTotal, '.99')>
		<cfreturn SystemTotal>
	</cffunction>


	<!----------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="getSystemBaseMarkedUp" access="public" returntype="numeric" output="no">
	<!--- Send in a ConfigSystemID, returns the marked-up system base price for that system --->
	<cfargument name="ConfigSystemID" type="string" required="Yes">
	<cfargument name="CustomerID" type="string" required="Yes">
		<cfset var SystemBaseMarkedUp = 0>
		<cfset objCust = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.Cust")>

		<cfset strConfigSystem = getRecord(Arguments.ConfigSystemID)>
		<cfset SystemBaseMarkedUp = strConfigSystem.SystemBasePrice>

		<!--- For the Exportable Configurator, markup the system base price by the reseller's markup percentage --->		
		<cfset qryLogin = objCust.getLoginRecord(Arguments.CustomerID)>
		<cfif qryLogin.RecordCount NEQ 0>
        
			<!--- MARGIN PERCENT --->
            <cfif qryLogin.MarkupType IS "Margin">
                <cfif strConfigSystem.Type IS "Workstation" AND isNumeric(qryLogin.PercentWorkstations)>
                    <cfset SystemBaseMarkedUp = SystemBaseMarkedUp / (1 - qryLogin.PercentWorkstations)>
                <cfelseif strConfigSystem.Type IS "Notebook" AND isNumeric(qryLogin.PercentNotebooks)>
                    <cfset SystemBaseMarkedUp = SystemBaseMarkedUp / (1 - qryLogin.PercentNotebooks)>
                <cfelseif strConfigSystem.Type IS "Server" AND isNumeric(qryLogin.PercentServers)>
                    <cfset SystemBaseMarkedUp = SystemBaseMarkedUp / (1 - qryLogin.PercentServers)>
                <cfelseif strConfigSystem.Type IS "MiniMountablePC" AND isNumeric(qryLogin.PercentMiniMountablePCs)>
                    <cfset SystemBaseMarkedUp = SystemBaseMarkedUp / (1 - qryLogin.PercentMiniMountablePCs)>
                </cfif>
            
            <!--- MARKUP PERCENTAGES --->
            <cfelse>
                <cfif strConfigSystem.Type IS "Workstation" AND isNumeric(qryLogin.PercentWorkstations)>
                    <cfset SystemBaseMarkedUp = SystemBaseMarkedUp + SystemBaseMarkedUp * qryLogin.PercentWorkstations>
                <cfelseif strConfigSystem.Type IS "Notebook" AND isNumeric(qryLogin.PercentNotebooks)>
                    <cfset SystemBaseMarkedUp = SystemBaseMarkedUp + SystemBaseMarkedUp * qryLogin.PercentNotebooks>
                <cfelseif strConfigSystem.Type IS "Server" AND isNumeric(qryLogin.PercentServers)>
                    <cfset SystemBaseMarkedUp = SystemBaseMarkedUp + SystemBaseMarkedUp * qryLogin.PercentServers>
                <cfelseif strConfigSystem.Type IS "MiniMountablePC" AND isNumeric(qryLogin.PercentMiniMountablePCs)>
                    <cfset SystemBaseMarkedUp = SystemBaseMarkedUp + SystemBaseMarkedUp * qryLogin.PercentMiniMountablePCs>
                </cfif>
            </cfif>
            
			<cfset SystemBaseMarkedUp = round(SystemBaseMarkedUp)>
		</cfif>
		<cfreturn SystemBaseMarkedUp>
	</cffunction>

	<cffunction name="sortUpSystem" access="public" returntype="numeric" output="No">
	<cfargument name="RecordID" type="string" required="Yes">
	<cfargument name="Type" type="string" required="Yes">
		<cfset var NewSortOrder = 1>
		<cfset var stSearch= structNew()>
		<cfset stRecord = getRecord(Arguments.RecordID)>

		<cfif isDefined("stRecord.DefaultSystem") AND stRecord.DefaultSystem EQ 1>
			<cfset GetDefaultSystems = 1>
		<cfelse>
			<cfset GetDefaultSystems = 0>
		</cfif>

		<cfif trim(This.ParentKey) IS NOT "">
			<cfset ParentID = stRecord[This.ParentKey]>
		<cfelse>
			<cfset ParentID = "">
		</cfif>
	
		<cfset OldSortOrder = stRecord[This.SortKey]>
		
		<cfif OldSortOrder NEQ 1 AND OldSortOrder NEQ 0>
			<cfset NewSortOrder = (OldSortOrder - 1)>
			
			<!--- first get all records with the same parent or foreign key --->
			<cfif GetDefaultSystems>
				<cfset structInsert(stSearch, "DefaultSystem", 1, True)>
				<cfset structInsert(stSearch, "Type", Arguments.Type, True)>
				<cfset qryGroup = searchRecords(stSearch)>
			<cfelseif ParentID IS NOT "">
				<cfset structInsert(stSearch, "DefaultSystem", 0, True)>
				<cfset structInsert(stSearch, This.ParentKey, ParentID, True)>
				<cfset structInsert(stSearch, "Type", Arguments.Type, True)>
				<cfset qryGroup = searchRecords(stSearch)>
			<cfelse>
				<cfset qryGroup = listRecords()>
			</cfif>
			
<!---			
			<cfif ParentID IS NOT "">
				<cfset structInsert(stSearch, This.ParentKey, ParentID, True)>
				<cfset structInsert(stSearch, "Type", Arguments.Type, True)>
				<cfset qryGroup = searchRecords(stSearch)>
			<cfelse>
				<cfset qryGroup = listRecords()>
			</cfif>
--->
			
			<!--- get the record this one will replace --->
			<cfquery dbType="query" name="qryHigher">
			SELECT #This.PrimaryKey#
			FROM qryGroup
			WHERE #This.SortKey# = #NewSortOrder#
			</cfquery>
			
			<!--- if it exists, knock it down --->
			<cfif qryHigher.RecordCount NEQ 0>
				<cfset PrimaryValue = "qryHigher." & This.PrimaryKey>
				<cfquery datasource="#This.DataSourceName#">
				UPDATE #This.TableName#
				SET #This.SortKey# = #OldSortOrder#
				WHERE #This.PrimaryKey# = '#evaluate(PrimaryValue)#'
				</cfquery>
			</cfif>
		<cfelse>
			<cfset NewSortOrder = OldSortOrder>
		</cfif>
		
		<!--- make this update to this record --->
		<cfquery datasource="#This.DataSourceName#">
		UPDATE #This.TableName#
		SET #This.SortKey# = #NewSortOrder#
		WHERE #This.PrimaryKey# = '#Arguments.RecordID#'
		</cfquery>
		<cfreturn NewSortOrder>
	</cffunction>
	
	<cffunction name="sortDownSystem" access="public" returntype="numeric" output="No">
	<cfargument name="RecordID" type="string" required="Yes">
	<cfargument name="Type" type="string" required="Yes">
		<cfset var NewSortOrder = 1>
		<cfset var MaxSortOrder = 1>
		<cfset var stSearch = structNew()>
		<!--- fetch information about this task --->
		<cfset stRecord = getRecord(Arguments.RecordID)>

		<cfif isDefined("stRecord.DefaultSystem") AND stRecord.DefaultSystem EQ 1>
			<cfset GetDefaultSystems = 1>
		<cfelse>
			<cfset GetDefaultSystems = 0>
		</cfif>

		<cfif trim(This.ParentKey) IS NOT "">
			<cfset ParentID = stRecord[This.ParentKey]>
		<cfelse>
			<cfset ParentID = "">
		</cfif>
		
		<cfset OldSortOrder = stRecord[This.SortKey]>
		
		<!--- get the highest sort order --->
		<cfset MaxSortOrder = getMaxSortOrder(ParentID,Arguments.Type,stRecord.DefaultSystem)>

		<cfif OldSortOrder NEQ MaxSortOrder>
			<cfset NewSortOrder = (OldSortOrder + 1)>
					
			<!--- first get all records with the same parent or foreign key --->
			<cfif GetDefaultSystems>
				<cfset structInsert(stSearch, "DefaultSystem", 1, True)>
				<cfset structInsert(stSearch, "Type", Arguments.Type, True)>
				<cfset qryGroup = searchRecords(stSearch)>
			<cfelseif ParentID IS NOT "">
				<cfset structInsert(stSearch, "DefaultSystem", 0, True)>
				<cfset structInsert(stSearch, This.ParentKey, ParentID, True)>
				<cfset structInsert(stSearch, "Type", Arguments.Type, True)>
				<cfset qryGroup = searchRecords(stSearch)>
			<cfelse>
				<cfset qryGroup = listRecords()>
			</cfif>

<!---
			<!--- first get all records with the same parent or foreign key --->
			<cfif ParentID IS NOT "">
				<cfset structInsert(stSearch, This.ParentKey, ParentID, True)>
				<cfset structInsert(stSearch, "Type", Arguments.Type, True)>
				<cfset qryGroup = searchRecords(stSearch)>
			<cfelse>
				<cfset qryGroup = listRecords()>
			</cfif>
--->
		
			<!--- get the record this one will replace --->
			<cfquery dbType="query" name="qryHigher">
			SELECT #This.PrimaryKey#
			FROM qryGroup
			WHERE #This.SortKey# = #NewSortOrder#
			</cfquery>
			
			<!--- if it exists, knock it up --->
			<cfif qryHigher.RecordCount NEQ 0>
				<cfset PrimaryValue = "qryHigher." & This.PrimaryKey>
				<cfquery datasource="#This.DataSourceName#">
				UPDATE #This.TableName#
				SET #This.SortKey# = #OldSortOrder#
				WHERE #This.PrimaryKey# = '#evaluate(PrimaryValue)#'
				</cfquery>
			</cfif>
		<cfelse>
			<cfset NewSortOrder = OldSortOrder>
		</cfif>
		
		<!--- make this update to this Record --->
		<cfquery datasource="#This.DataSourceName#">
		UPDATE #This.TableName#
		SET #This.SortKey# = #NewSortOrder#
		WHERE #This.PrimaryKey# = '#Arguments.RecordID#'
		</cfquery>
		<cfreturn NewSortOrder>
	</cffunction>

	<cffunction name="getMaxSortOrder" access="public" returntype="numeric" output="No">
	<cfargument name="ParentKeyID" type="string" required="No">
	<cfargument name="Type" type="string" required="No">
	<cfargument name="DefaultSystem" type="string" required="No">
		<cfset var MaxOrder = 0>
		<cfquery datasource="#This.DataSourceName#" name="qryMax">
		SELECT Max(#This.SortKey#) AS MaxSortOrder
		FROM #This.TableName#
		WHERE	0=0
			<cfif isDefined("Arguments.DefaultSystem") AND Arguments.DefaultSystem EQ 1>
				AND DefaultSystem = 1
			<cfelseif isDefined("Arguments.ParentKeyID") AND trim(This.ParentKey) IS NOT "">
				AND #This.ParentKey# = '#Arguments.ParentKeyID#' 
			</cfif>
			<cfif isDefined("Arguments.Type")>
				AND Type = '#Arguments.Type#'
			</cfif>
<!---		
		<cfif trim(This.ParentKey) IS NOT "" AND isDefined("Arguments.ParentKeyID")>
			WHERE #This.ParentKey# = '#Arguments.ParentKeyID#' 
				<cfif isDefined("Arguments.Type")>
					AND Type = '#Arguments.Type#'
				</cfif>
		</cfif> 
--->		
		</cfquery>
		<cfif qryMax.RecordCount GTE 1>
			<cfif isNumeric(qryMax.MaxSortOrder)>
				<cfset MaxOrder = qryMax.MaxSortOrder>
			</cfif>
		</cfif>
		<cfreturn MaxOrder>
	</cffunction>

	<cffunction name="getRecord_Config" access="public" returntype="struct" output="No">
	<cfargument name="ConfigSystemID" type="string" required="yes">
		<cfset var strConfigSystem = structNew()>
		<cfset var qryConfigSystem = queryNew("")>		
		<cfquery datasource="#This.DataSourceName#" name="qryConfigSystem">
		SELECT	Type, EnergystarApproved,
				(SELECT	tblConfigPhotos.PhotoImage
				 FROM   tblConfigPhotos
				 WHERE  tblConfigPhotos.ConfigPhotoID = tblConfigSystems.ConfigPhotoID) AS PhotoImage,			
				Name, Description, Specs, SystemBasePrice
		FROM 	tblConfigSystems
		WHERE	ConfigSystemID = '#Arguments.ConfigSystemID#'
		</cfquery>
		<cfoutput maxrows="1" query="qryConfigSystem">
			<cfloop list="#qryConfigSystem.ColumnList#" index="Column">
				<cfset structInsert(strConfigSystem, Column, evaluate(Column), True)>
			</cfloop>
		</cfoutput>
		<cfreturn strConfigSystem>
	</cffunction>

	<cffunction name="getLogin_Config" access="public" returntype="query" output="No">
	<cfargument name="loginID" type="string" required="yes">
		<cfset var qrylogin = queryNew("")>		
		<cfquery datasource="#This.DataSourceName#" name="qrylogin">
		SELECT	CustomerID, PriceListID, ShippingAndTax
		FROM 	login
		WHERE	ID = '#Arguments.loginID#'
		</cfquery>
		<cfreturn qrylogin>
	</cffunction>


	<!-------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="checkComponentDefaultsForAllSystems" access="public" output="No">
    	<cfset var qryAllSystems = queryNew("")>
		<cfquery datasource="#This.DataSourceName#" name="qryAllSystems">
		SELECT	ConfigSystemID
		FROM 	tblConfigSystems 
		</cfquery>	      
		<cfloop query="qryAllSystems">
        	<cfset checkComponentDefaults(qryAllSystems.ConfigSystemID)>
        </cfloop>
	</cffunction>


	<!------------------------------------------------------------------------------------------------------------------->
	<cffunction name="checkComponentDefaults" access="public" returntype="boolean" output="No">
	<cfargument name="ConfigSystemID" type="string" required="yes">
		<cfset var Success = 1>		
		<cfset var qryConfigComponentCategories = queryNew("")>
		<cfset var qryConfigComponents = queryNew("")>
        <cfset var qryConfigComponents_ALL = queryNew("")>
		<cfset var SalesRepEmail = "">
		<cfset var qryConfigSystem = queryNew("")>
		<cfset var CustomerCompany = "">
		<cfset var CustomerFirstName = "">
		<cfset var CustomerLastName = "">
		<cfset var CustomerEmail = "">
        <cfset var qryCategoryErrors = queryNew("Category,Name")>

		<cfquery datasource="#This.DataSourceName#" name="qryConfigComponentCategories">
        SELECT 	tblConfigComponentCategories.ConfigComponentCategoryID,tblComponentCategories.Category,tblComponentCategories.Name
        FROM    tblConfigComponentCategories INNER JOIN
                tblComponentCategories ON tblConfigComponentCategories.ComponentCategoryID = tblComponentCategories.ComponentCategoryID
		WHERE	(tblConfigComponentCategories.ConfigSystemID = '#Arguments.ConfigSystemID#') AND
                (tblComponentCategories.IsAdditionalWarranty = 0)		
    	</cfquery>
    
		<cfloop query="qryConfigComponentCategories">
			<cfquery datasource="#This.DataSourceName#" name="qryConfigComponents_ALL">
			SELECT	ConfigComponentID				,ConfigComponentCategoryID
			FROM 	tblConfigComponents
			WHERE	ConfigComponentCategoryID = '#qryConfigComponentCategories.ConfigComponentCategoryID#'
			</cfquery>
			<cfquery datasource="#This.DataSourceName#" name="qryConfigComponents">
			SELECT	ConfigComponentID				,ConfigComponentCategoryID
			FROM 	tblConfigComponents
			WHERE	ConfigComponentCategoryID = '#qryConfigComponentCategories.ConfigComponentCategoryID#' AND
					DefaultComponent = 1
			</cfquery>
            <!--- If there is only one component in this category and it's not marked as the default, mark it as the default --->
            <cfif qryConfigComponents_ALL.RecordCount EQ 1 AND qryConfigComponents.RecordCount EQ 0>
                <cfquery datasource="#This.DataSourceName#">
                UPDATE	tblConfigComponents
                SET		DefaultComponent = 1
                WHERE	ConfigComponentID = '#qryConfigComponents_ALL.ConfigComponentID#'
                </cfquery>
                
                <cfquery datasource="#This.DataSourceName#">
                UPDATE	tblComponentPrices
                SET 	DefaultComponent = 1
                WHERE 	ConfigComponentID = '#qryConfigComponents_ALL.ConfigComponentID#'
                </cfquery>
            
            <!--- If there is not a default for this category and there is more than one component in this category --->
			<cfelseif qryConfigComponents.RecordCount EQ 0 AND qryConfigComponents_ALL.RecordCount GT 1>
				<cfset Success = 0>
                <cfset queryAddRow(qryCategoryErrors)>
                <cfset querySetCell(qryCategoryErrors, "Category", qryConfigComponentCategories.Category)>
                <cfset querySetCell(qryCategoryErrors, "Name", qryConfigComponentCategories.Name)>
			</cfif>
		</cfloop>

		<cfif NOT Success>
			<!--- Send an email to the sales rep --->

			<cfquery datasource="#This.DataSourceName#" name="qryConfigSystem">
			SELECT	Name,Type,Email
			FROM 	vConfigSystems
			WHERE	ConfigSystemID = '#Arguments.ConfigSystemID#'
			</cfquery>
			<cfif qryConfigSystem.RecordCount NEQ 0 AND trim(qryConfigSystem.Email) IS NOT "">
				<cfmail from=	"info@nor-tech.com"		
						to=		"#trim(qryConfigSystem.Email)#"
						subject="Problem with one of your configurations" 
						type="html" 
						
						port="25">
					One of your systems in the configurator has a problem:<br>
                    A default component is missing for one or more of the component categories (every category must have a default component).<br><br>
                    
                    The details are outlined below:<br><br>
                    
					System: #qryConfigSystem.Name#<br>
					Type: #qryConfigSystem.Type#<br><br>


                    Categor<cfif qryCategoryErrors.RecordCount EQ 1>y<cfelse>ies</cfif> at fault:
                    <cfloop query="qryCategoryErrors">
                    	#qryCategoryErrors.Name# (#qryCategoryErrors.Category#)<cfif qryCategoryErrors.CurrentRow NEQ qryCategoryErrors.RecordCount>,</cfif>
                    </cfloop>
                    
				</cfmail>			
			</cfif>
		</cfif>
		<cfreturn Success>
	</cffunction>

	<!-------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="getImageName" access="public" returntype="string" output="No">
    <cfargument name="ConfigSystemID" type="string" required="yes">
    	<cfset var ImageName = "">
        <cfset var qryConfigComponents = queryNew("")>
        <cfset var qryConfigPhotos = queryNew("")>
		<cfset var qryConfigSystem = queryNew("")>
        
		<cfquery datasource="#This.DataSourceName#" name="qryConfigComponents">
		SELECT	Case_ConfigPhotoID
		FROM 	vConfigComponents
		WHERE 	ConfigSystemID = '#Arguments.ConfigSystemID#' AND
        		CATEGORY = 'CS' AND
                DefaultComponent = 1        
		</cfquery>	      
		
        <cfif qryConfigComponents.RecordCount NEQ 0>
            <cfquery datasource="#This.DataSourceName#" name="qryConfigPhotos">
            SELECT	PhotoImage
            FROM 	tblConfigPhotos
            WHERE 	ConfigPhotoID = '#qryConfigComponents.Case_ConfigPhotoID#' 
            </cfquery>
            <cfif qryConfigPhotos.RecordCount NEQ 0>
    			<cfset ImageName = qryConfigPhotos.PhotoImage>
            </cfif>
        </cfif>

		<cfif ImageName IS "">
            <cfquery datasource="#This.DataSourceName#" name="qryConfigSystem">
            SELECT	ConfigPhotoID
            FROM 	tblConfigSystems
            WHERE	ConfigSystemID = '#Arguments.ConfigSystemID#'
            </cfquery>
			<cfif qryConfigSystem.RecordCount NEQ 0>
                <cfquery datasource="#This.DataSourceName#" name="qryConfigPhotos">
                SELECT	PhotoImage
                FROM 	tblConfigPhotos
                WHERE 	ConfigPhotoID = '#qryConfigSystem.ConfigPhotoID#' 
                </cfquery>
                <cfif qryConfigPhotos.RecordCount NEQ 0>
                    <cfset ImageName = qryConfigPhotos.PhotoImage>
                </cfif>
            </cfif>
        </cfif>
        
        <cfreturn ImageName>
	</cffunction>

	<!-------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="getImageName2" access="public" returntype="string" output="No">
    <cfargument name="Record" type="struct" required="yes">
    	<cfset var ImageName = "">
        <cfset var Column = "">
        <cfset var lstRecord = structKeyList(Arguments.Record)>
        <cfset var qryConfigPhotos = queryNew("")>
		<cfset var qryConfigSystem = queryNew("")>
        
        <cfloop list="#lstRecord#" index="Column">
        	<cfif findNoCase("CAT_", Column) NEQ 0>
            	<cfset ImageName = removeChars(Arguments.Record[Column], 1, findNoCase("|", Arguments.Record[Column]))>
                <cfif findNoCase("|",ImageName) NEQ 0>
					<cfset ImageName = removeChars(ImageName, 1, findNoCase("|",ImageName))>
					<cfif findNoCase("|",ImageName) NEQ 0>
                        <cfset ImageName = removeChars(ImageName, findNoCase("|",ImageName), len(ImageName)-findNoCase("|",ImageName)  )>
					</cfif>
                </cfif>

                <cfif trim(ImageName) IS NOT "">
                    <cfbreak>
                </cfif>
            </cfif>
        </cfloop>

		<cfif trim(ImageName) IS "">
            <cfquery datasource="#This.DataSourceName#" name="qryConfigSystem">
            SELECT	ConfigPhotoID
            FROM 	tblConfigSystems
            WHERE	ConfigSystemID = '#Arguments.Record.ConfigSystemID#'
            </cfquery>
			<cfif qryConfigSystem.RecordCount NEQ 0>
                <cfquery datasource="#This.DataSourceName#" name="qryConfigPhotos">
                SELECT	PhotoImage
                FROM 	tblConfigPhotos
                WHERE 	ConfigPhotoID = '#qryConfigSystem.ConfigPhotoID#' 
                </cfquery>
                <cfif qryConfigPhotos.RecordCount NEQ 0>
                    <cfset ImageName = qryConfigPhotos.PhotoImage>
                </cfif>
            </cfif>
        </cfif>

        <cfreturn ImageName>
	</cffunction>

	<!-------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="getImageName3" access="public" returntype="string" output="No">
    <cfargument name="QuoteSystemID" type="string" required="yes">
    	<cfset var ImageName = "">
		<cfset var qryQuoteSystem = queryNew("")>
        <cfset var qryQuoteComponents = queryNew("")>
        <cfset var qryConfigComponents = queryNew("")>
        <cfset var qryConfigPhotos = queryNew("")>
        <cfset var qryConfigSystem = queryNew("")>
        
        <cfquery datasource="#This.DataSourceName#" name="qryQuoteSystem">
        SELECT	ConfigSystemID
        FROM 	tblQuoteSystem
        WHERE	QuoteSystemID = '#Arguments.QuoteSystemID#'
        </cfquery>
        <cfif qryQuoteSystem.RecordCount NEQ 0>
        
            <cfquery datasource="#This.DataSourceName#" name="qryQuoteComponents">
            SELECT	ITEMNO
            FROM 	tblQuoteComponents
            WHERE	QuoteSystemID = '#Arguments.QuoteSystemID#' AND
                    TypeName = 'Case'
            </cfquery>
			<cfif qryQuoteComponents.RecordCount NEQ 0>
                <cfquery datasource="#This.DataSourceName#" name="qryConfigComponents">
                SELECT	Case_ConfigPhotoID
                FROM 	vConfigComponents
                WHERE	ConfigSystemID = '#qryQuoteSystem.ConfigSystemID#' AND
                        ITEMNO = '#trim(qryQuoteComponents.ITEMNO)#'
                </cfquery>
				<cfif qryConfigComponents.RecordCount NEQ 0>
                    <cfquery datasource="#This.DataSourceName#" name="qryConfigPhotos">
                    SELECT	PhotoImage
                    FROM 	tblConfigPhotos
                    WHERE 	ConfigPhotoID = '#qryConfigComponents.Case_ConfigPhotoID#' 
                    </cfquery>
                    <cfif qryConfigPhotos.RecordCount NEQ 0>
                        <cfset ImageName = qryConfigPhotos.PhotoImage>
                    </cfif>
                </cfif>
 			</cfif>  
            
			<cfif ImageName IS "">
                <cfquery datasource="#This.DataSourceName#" name="qryConfigSystem">
                SELECT	ConfigPhotoID
                FROM 	tblConfigSystems
                WHERE	ConfigSystemID = '#qryQuoteSystem.ConfigSystemID#'
                </cfquery>
                <cfif qryConfigSystem.RecordCount NEQ 0>
                    <cfquery datasource="#This.DataSourceName#" name="qryConfigPhotos">
                    SELECT	PhotoImage
                    FROM 	tblConfigPhotos
                    WHERE 	ConfigPhotoID = '#qryConfigSystem.ConfigPhotoID#' 
                    </cfquery>
                    <cfif qryConfigPhotos.RecordCount NEQ 0>
                        <cfset ImageName = qryConfigPhotos.PhotoImage>
                    </cfif>
                </cfif>
            </cfif>
                 
        </cfif>

        <cfreturn ImageName>
	</cffunction>

	<!---------------------------------------------------------------------------------------->
	<cffunction name="saveSalesRepDefaultCase" access="public" output="No">
	<cfargument name="Record" type="struct" required="Yes">
    	<cfset var qryConfigComponents = queryNew("")>
		<cfset CURRENTSalesRepPickDefaultCase = 0>
		<cfset CURRENTSRDefaultCaseID = "">
		<cfset qryConfigSystem = queryNew("")>
		<cfset qryConfigComponentsMASTER = queryNew("")>
		<cfset qryConfigComponentsSALESREP = queryNew("")>
<!---
Arguments.Record:<cfdump var="#Arguments.Record#"><br>
<cfabort>
--->        
        <!--- The sales rep checked the box "Pick the Default Case?", and he selected one of the case radio buttons ---->
        <cfif structKeyExists(Arguments.Record, "SalesRepPickDefaultCase") AND Arguments.Record.SRDefaultCaseID IS NOT "">
			<cfset CURRENTSalesRepPickDefaultCase = 1>
            <cfset CURRENTSRDefaultCaseID = Arguments.Record.SRDefaultCaseID>

		<cfelse>
			<cfset CURRENTSalesRepPickDefaultCase = 0>

			<!--- Set the default case back to whatever is picked in the Master system --->

            <cfquery datasource="#This.DataSourceName#" name="qryConfigSystem">
            SELECT	DefaultConfigSystemID
            FROM 	tblConfigSystems
            WHERE 	ConfigSystemID = '#Arguments.Record.ConfigSystemID#'
            </cfquery>
            <cfif qryConfigSystem.RecordCount NEQ 0>

                <cfquery datasource="#This.DataSourceName#" name="qryConfigComponentsMASTER">
                SELECT	ITEMNO
                FROM 	vConfigComponents
                WHERE 	ConfigSystemID = '#qryConfigSystem.DefaultConfigSystemID#' AND
                        CategoryName = 'Case' AND
                        DefaultComponent = 1
                </cfquery>
				<cfif qryConfigComponentsMASTER.RecordCount NEQ 0>
                
                    <cfquery datasource="#This.DataSourceName#" name="qryConfigComponentsSALESREP">
                    SELECT	ConfigComponentID
                    FROM 	vConfigComponents
                    WHERE 	ConfigSystemID = '#Arguments.Record.ConfigSystemID#' AND
                            CategoryName = 'Case' AND
                            ITEMNO = '#trim(qryConfigComponentsMASTER.ITEMNO)#'
                    </cfquery>
					<cfif qryConfigComponentsSALESREP.RecordCount NEQ 0>
                		<cfset CURRENTSRDefaultCaseID = qryConfigComponentsSALESREP.ConfigComponentID>
                
                	</cfif>
                </cfif>
            </cfif>
		</cfif>

<!---
CURRENTSalesRepPickDefaultCase:<cfdump var="#CURRENTSalesRepPickDefaultCase#"><br>
CURRENTSRDefaultCaseID:<cfdump var="#CURRENTSRDefaultCaseID#"><br>
--->        
        <!--- SET SalesRepPickDefaultCase IN tblConfigSystems --->
        <cfquery datasource="#This.DataSourceName#">
        UPDATE	tblConfigSystems
        SET 	SalesRepPickDefaultCase = #CURRENTSalesRepPickDefaultCase#
        WHERE 	ConfigSystemID = '#Arguments.Record.ConfigSystemID#'
        </cfquery>

		<!--- SET THE DEFAULT CASE COMPONENT --->
        
		<cfif CURRENTSRDefaultCaseID IS NOT "">
            <cfquery datasource="#This.DataSourceName#" name="qryConfigComponents">
            SELECT	ConfigComponentID
            FROM 	vConfigComponents
            WHERE 	ConfigSystemID = '#Arguments.Record.ConfigSystemID#' AND
                    CategoryName = 'Case'
            </cfquery>
            <cfloop query="qryConfigComponents">
                <cfif qryConfigComponents.ConfigComponentID IS CURRENTSRDefaultCaseID>
                    <cfquery datasource="#This.DataSourceName#">
                    UPDATE	tblConfigComponents
                    SET 	DefaultComponent = 1
                    WHERE 	ConfigComponentID = '#qryConfigComponents.ConfigComponentID#'
                    </cfquery>

                    <cfquery datasource="#This.DataSourceName#">
                    UPDATE	tblComponentPrices
                    SET 	DefaultComponent = 1
                    WHERE 	ConfigComponentID = '#qryConfigComponents.ConfigComponentID#'
                    </cfquery>
                    
                <cfelse>
                    <cfquery datasource="#This.DataSourceName#">
                    UPDATE	tblConfigComponents
                    SET 	DefaultComponent = 0
                    WHERE 	ConfigComponentID = '#qryConfigComponents.ConfigComponentID#'
                    </cfquery>

                    <cfquery datasource="#This.DataSourceName#">
                    UPDATE	tblComponentPrices
                    SET 	DefaultComponent = 0
                    WHERE 	ConfigComponentID = '#qryConfigComponents.ConfigComponentID#'
                    </cfquery>
                </cfif>
            </cfloop>
		</cfif>
        
	</cffunction>


</cfcomponent>