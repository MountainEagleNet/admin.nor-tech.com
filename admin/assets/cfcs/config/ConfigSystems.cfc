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
		<cfif isDefined("SESSION.adminuserid")>
			<cfset structInsert(stRecord, "UserID", SESSION.adminuserid, True)>
		</cfif>
		<cfset structInsert(stRecord, "SystemBasePrice", 0, True)>
		<cfreturn stRecord>
	</cffunction>

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
    
	<cffunction name="maintainSalesRepSystems1" access="public" output="No">
	<cfargument name="ConfigSystemID" type="string" required="Yes">
        <cfset var qrySavedSystem = queryNew("")>
        <cfset var qryMaintainSystems = queryNew("")>		
        <cfquery datasource="#This.DataSourceName#" name="qrySavedSystem">
        SELECT	ConfigSystemID, Name, SystemNumber, Description, Specs, ConfigPhotoID, Type, TypeSortOrder, ClassificationID, DefaultSystem,
        		EnergystarApproved, PowerSupplyAutoSelect
        FROM 	tblConfigSystems
        WHERE	ConfigSystemID = '#Arguments.ConfigSystemID#'
        </cfquery>
		<cfif qrySavedSystem.RecordCount NEQ 0 AND qrySavedSystem.DefaultSystem EQ 1>
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

	<cffunction name="maintainSalesRepSystems1a" access="public" output="No">
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
            <cfset qryMaintainSystems = getMaintenanceSystems(Arguments.ConfigSystemID)>
			<cfloop query="qryMaintainSystems">
            	<cfset CURRENTConfigSystemID = qryMaintainSystems.ConfigSystemID>
                <cfquery datasource="#This.DataSourceName#">
                DELETE FROM tblServerSelectionsSystems
                WHERE 		ConfigSystemID = '#CURRENTConfigSystemID#'
                </cfquery>
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

	<cffunction name="maintainSalesRepSystems2" access="public" output="No">
	<cfargument name="strRecord" type="struct" required="Yes">
        <cfset var qryMaintainSystems = queryNew("")>
        <cfset var strMaintainanceSystem = structNew()>
		<cfset objConfigComponentCategories = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ConfigComponentCategories")>
        <cfif isDefaultSystem(Arguments.strRecord.ConfigSystemID)>
            <cfset qryMaintainSystems = getMaintenanceSystems(Arguments.strRecord.ConfigSystemID)>
	        <cfset strMaintainanceSystem = duplicate(Arguments.strRecord)>
			<cfloop query="qryMaintainSystems">
            	<cfset structInsert(strMaintainanceSystem, "ConfigSystemID", qryMaintainSystems.ConfigSystemID, True)>
				<cfset objConfigComponentCategories.assignCategories(strMaintainanceSystem)>
			</cfloop>
        </cfif>
	</cffunction>

	<cffunction name="maintainSalesRepSystems3" access="public" output="No">
	<cfargument name="strRecord" type="struct" required="Yes">
        <cfset var qryMaintainSystems = queryNew("")>
        <cfset var strMaintainanceSystem = structNew()>
        <cfset var NewConfigComponentCategoryID = "">
        <cfset var qryConfigComponentCategory = queryNew("")>
        <cfset var qryNewConfigComponentCategory = queryNew("")>
		<cfset objConfigComponents = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ConfigComponents")>
        
        <cfif isDefaultSystem(Arguments.strRecord.ConfigSystemID)>
			<cfset qryMaintainSystems = getMaintenanceSystems(Arguments.strRecord.ConfigSystemID)>
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

	<cffunction name="maintainSalesRepSystems3a" access="public" output="No">
	<cfargument name="strRecord" type="struct" required="Yes">
        <cfset var qryMaintainSystems = queryNew("")>
        <cfset var strMaintainanceSystem = structNew()>
        <cfset var NewConfigComponentCategoryID = "">
        <cfset var qryConfigComponentCategory = queryNew("")>
        <cfset var qryNewConfigComponentCategory = queryNew("")>
		<cfset objConfigWarranty = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ConfigWarranty")>
        
        <cfif isDefaultSystem(Arguments.strRecord.ConfigSystemID)>
            <cfset qryMaintainSystems = getMaintenanceSystems(Arguments.strRecord.ConfigSystemID)>
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

	<cffunction name="maintainSalesRepSystems3b" access="public" output="No">
	<cfargument name="strRecord" type="struct" required="Yes">
        <cfset var qryMaintainSystems = queryNew("")>      
		<cfset var qryConfigComponents_Maintenance = queryNew("")>
        <cfset var qryConfigComponents_Default = queryNew("")>
		<cfset objConfigComponents = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ConfigComponents")>

        <cfif isDefaultSystem(Arguments.strRecord.ConfigSystemID)>
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
            
	<cffunction name="maintainSalesRepSystems4" access="public" output="No">
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
        <cfif isDefaultSystem(Arguments.strRecord.ConfigSystemID)>
            <cfset qryMaintainSystems = getMaintenanceSystems(Arguments.strRecord.ConfigSystemID)>
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
                        <cfset DEFCOMPValue = Arguments.strRecord[Column]>
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
				<cfset objConfigComponents.setSystemImage(CURRENTConfigSystemID)>
			</cfloop>
        </cfif>
	</cffunction>    
   
	<cffunction name="maintainSalesRepSystems5" access="public" output="No">
	<cfargument name="strRecord" type="struct" required="Yes">
        <cfset var qryMaintainSystems = queryNew("")>
        <cfif isDefaultSystem(Arguments.strRecord.ConfigSystemID)>
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
            <cfif qryConfigComponentCategory_CASE.RecordCount NEQ 0>
                <cfset qryDefaultComponent = objConfigComponents.getDefaultComponentItemno(qryConfigComponentCategory_CASE.ConfigComponentCategoryID)>
                <cfif trim(qryDefaultComponent.ITEMNO) IS "CS-EV-4572B-S2" OR 
				
					  trim(qryDefaultComponent.ITEMNO) IS "CS-LO-ST951B-VOY/NP" OR 
					  trim(qryDefaultComponent.ITEMNO) IS "CS-CE-FX629MBKH" OR 
					  trim(qryDefaultComponent.ITEMNO) IS "CS-CE-TLA397/NP">
                    <cfset ShowPowerSupplyWhenPageLoads = 1>
                </cfif>                
            </cfif>
        </cfif>
        <cfreturn ShowPowerSupplyWhenPageLoads>
	</cffunction>

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

	<cffunction name="copyConfigSystem" access="public" returntype="string" output="No">
	<cfargument name="ConfigSystemID" type="string" required="Yes">
		<cfset var NewConfigSystemID = "">
     	<cfset var qryServerSelectionsSystems = queryNew("")>        
		<cfset objConfigComponentCategories = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ConfigComponentCategories")>
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
       	<cfset objConfigComponentCategories.copyConfigComponentCategories(strOldSystem.ConfigSystemID, NewConfigSystemID)>
		<cfreturn NewConfigSystemID>
	</cffunction>

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
			<cfset assignResellers(Variables.ConfigSystemID)>  
            <cfset objComponentPrices.createPricesForSystem(Variables.ConfigSystemID)>            
		</cfloop>
	</cffunction>

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
        
		<cfset NewSortOrder = 10000>
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
                <cfset MaintainField = "MAINTAIN|" & DefaultConfigSystemID>
                <cfif structKeyExists(Arguments.Record, MaintainField)>
					<cfset structInsert(strNewConfigSystem, "DefaultConfigSystemID", DefaultConfigSystemID, True)>
					<cfset structInsert(strNewConfigSystem, "Name", strDefaultSystem.Name, True)>
                </cfif>

				<cfset Variables.ConfigSystemID = saveRecord(strNewConfigSystem)>
				<cfset assignResellers(Variables.ConfigSystemID)>    
                <cfset objComponentPrices.createPricesForSystem(Variables.ConfigSystemID)>

				<cfset ImportedAtLeastOne = 1>
			</cfif>
		</cfloop>
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

	<cffunction name="importSalesRepSystems" access="public" returntype="boolean" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var ImportedAtLeastOne = 0>
		<cfset NewSortOrder = 10000>
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
                <cfset copyMaintainSystemDefault(Variables.ConfigSystemID, SalesRepConfigSystemID)>               
			</cfif>
		</cfloop>
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

	<cffunction name="copyMaintainSystemDefault" access="public" output="No">
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
        <cfquery datasource="#This.DataSourceName#" name="qryConfigSystems_Type">
        SELECT	Type
        FROM 	tblConfigSystems
        WHERE	ConfigSystemID = '#Arguments.OrigSalesRepConfigSystemID#'
        </cfquery>
        <cfloop query="qryAdminAccts">
            <cfquery datasource="#This.DataSourceName#" name="qryConfigSystems">
            SELECT	ConfigSystemID
            FROM 	tblConfigSystems
            WHERE	UserID = '#qryAdminAccts.UserID#' AND
            		ConfigSystemID = '#Arguments.OrigSalesRepConfigSystemID#'
            </cfquery>
            <cfif qryConfigSystems.RecordCount EQ 0>
                <cfquery datasource="#This.DataSourceName#" name="qryConfigSystems_Name">
                SELECT	Name
                FROM 	tblConfigSystems
                WHERE	ConfigSystemID = '#Arguments.NewDefaultConfigSystemID#'
                </cfquery>

				<cfset NewConfigSystemID = copyConfigSystem(Arguments.NewDefaultConfigSystemID)>

				<cfset strNewConfigSystem = getRecord(NewConfigSystemID)>
				<cfset structInsert(strNewConfigSystem, "UserID", qryAdminAccts.UserID, True)>
				<cfset structInsert(strNewConfigSystem, "Name", qryConfigSystems_Name.Name, True)>
				<cfset structInsert(strNewConfigSystem, "DefaultSystem", 0, True)>
                
                <cfquery datasource="#This.DataSourceName#" name="qryConfigSystems_SortOrder">
                SELECT	TOP 1 SortOrder
                FROM 	tblConfigSystems
                WHERE	UserID = '#qryAdminAccts.UserID#' AND
                		Type = '#qryConfigSystems_Type.Type#'
				ORDER BY SortOrder DESC                        
                </cfquery>
                <cfif qryConfigSystems_SortOrder.RecordCount NEQ 0>
					<cfset NewSortOrder = qryConfigSystems_SortOrder.SortOrder + 1> 
                <cfelse>
                	<cfset NewSortOrder = 1>
                </cfif>
                
				<cfset structInsert(strNewConfigSystem, "SortOrder", NewSortOrder, True)>
				<cfset structInsert(strNewConfigSystem, "DefaultConfigSystemID", Arguments.NewDefaultConfigSystemID, True)>
				<cfset Variables.ConfigSystemID = saveRecord(strNewConfigSystem, 1)>
				<cfset assignResellers(Variables.ConfigSystemID, qryAdminAccts.UserID)>     
                <cfset objComponentPrices.createPricesForSystem(Variables.ConfigSystemID)>
            </cfif>
        </cfloop>

	</cffunction>


	<cffunction name="assignResellers" access="public" output="No">
	<cfargument name="ConfigSystemID" type="string" required="Yes">
	<cfargument name="SalesRepUserID" type="string" required="No" default="">
    	<cfset var qryResellers = queryNew("")>
        <cfset var qryResellerSystems = queryNew("")>
        <cfset var strResellerSystem = structNew()> 
		<cfset objResellerSystems = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ResellerSystems")>
		<cfset objConfigComponentsResellers = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ConfigComponentsResellers")>
		<cfset objComponentPrices = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ComponentPrices")>

		<cfset qryResellers = objConfigComponentsResellers.listResellersForSalesRep(Arguments.SalesRepUserID)>


        <cfloop query="qryResellers">
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
                <cfset objResellerSystems.saveRecord(strResellerSystem)>
            </cfif>
        </cfloop>

	</cffunction>

	<cffunction name="removeResellers" access="public" output="No">
	<cfargument name="ConfigSystemID" type="string" required="Yes">
		<cfset objResellerSystems = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ResellerSystems")>
		<cfset qryResellerSystems = objResellerSystems.listRecordsForParent("ConfigSystemID", Arguments.ConfigSystemID)>
		<cfloop query="qryResellerSystems">
			<cfset objResellerSystems.deleteRecord(qryResellerSystems.ResellerSystemID)>
		</cfloop>
	</cffunction>
	
	<cffunction name="assignCheckedResellers" access="public" output="No">
	<cfargument name="Record" type="struct" required="Yes">
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
			<cfif InDatabase AND NOT CheckedOnForm>
				<cfset objResellerSystems.deleteRecord(qryResellerSystems.ResellerSystemID)>
			<cfelseif NOT InDatabase AND CheckedOnForm>
				<cfset strResellerSystem = objResellerSystems.newRecord()>
				<cfset structInsert(strResellerSystem, "ConfigSystemID", ConfigSystemID, True)>
				<cfset structInsert(strResellerSystem, "CustomerID", qryResellers.CustomerID, True)>
				<cfset objResellerSystems.saveRecord(strResellerSystem)>
				<cfset objComponentPrices.createPricesForSystem(ConfigSystemID)>  
			</cfif>
		</cfloop>
	</cffunction>	
	
	<cffunction name="deleteRecord" access="public" output="No">
	<cfargument name="RecordID" type="string" required="Yes">
		<cfset var qryConfigSystemOLD = queryNew("")>
        <cfset var qryRemainingOnes = queryNew("")>
		<cfset objConfigComponentCategories = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ConfigComponentCategories")>
		<cfset objResellerSystems = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ResellerSystems")>
		<cfset objComponentPrices = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ComponentPrices")>

		<cfquery datasource="#This.DataSourceName#" name="qryConfigSystemOLD">
		SELECT	DefaultSystem,UserID,Type
		FROM 	tblConfigSystems
		WHERE	ConfigSystemID = '#Arguments.RecordID#'
		</cfquery>


		<cfset super.deleteRecord(Arguments.RecordID)>

		<cfif qryConfigSystemOLD.DefaultSystem EQ 1>
			 <cfquery datasource="#This.DataSourceName#" name="qryRemainingOnes">
            SELECT	ConfigSystemID
            FROM 	tblConfigSystems
            WHERE	DefaultSystem = 1 AND
            		Type = '#qryConfigSystemOLD.Type#'
           	ORDER BY SortOrder
            </cfquery>
            
		<cfelse>
			<cfquery datasource="#This.DataSourceName#" name="qryRemainingOnes">
            SELECT	ConfigSystemID
            FROM 	tblConfigSystems
            WHERE	DefaultSystem = 0 AND
            		UserID = '#qryConfigSystemOLD.UserID#' AND
            		Type = '#qryConfigSystemOLD.Type#'
           	ORDER BY SortOrder
            </cfquery>
		</cfif>
		<cfset NewSortOrder = 1>
		<cfloop query="qryRemainingOnes">
            <cfquery datasource="#This.DataSourceName#">
            UPDATE	tblConfigSystems
            SET 	SortOrder = '#NewSortOrder#'
            WHERE 	ConfigSystemID = '#qryRemainingOnes.ConfigSystemID#'
            </cfquery>
            
			<cfset NewSortOrder = NewSortOrder + 1>
		</cfloop>
		
		<cfset qryConfigComponentCategories = objConfigComponentCategories.listRecordsForParent("ConfigSystemID",Arguments.RecordID)>
		<cfloop query="qryConfigComponentCategories">
			<cfset objConfigComponentCategories.deleteRecord(qryConfigComponentCategories.ConfigComponentCategoryID)>
		</cfloop>
        
		<cfquery datasource="#This.DataSourceName#">
        DELETE FROM tblResellerSystems
        WHERE 		ConfigSystemID = '#Arguments.RecordID#'
        </cfquery>       
        <cfset objComponentPrices.deletePricesForSystem(Arguments.RecordID)>
        
		<cfreturn>
	</cffunction>


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

	<cffunction name="getSystemTotalPriceDefault" access="public" returntype="numeric" output="YES">
	<cfargument name="ConfigSystemID" type="string" required="Yes">
	<cfargument name="PriceListID" type="string" required="Yes">
	<cfargument name="ExportableConfigurator" type="boolean" required="No" default="0">
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
			<cfif ExportableConfigurator>
				<cfset qryLogin = objCust.getLoginRecord(Variables.CustomerID)>
				<cfif qryLogin.RecordCount NEQ 0>
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
			</cfif>
			<cfif ExportableConfigurator>
				<cfset PriceOfThisComponent = objPriceListComponents.markUpSellingPrice(Variables.CustomerID, qryConfigComponents.ConfigComponentID, PriceOfThisComponent)>
			</cfif>
			<cfset SystemTotal = SystemTotal + (PriceOfThisComponent * qryConfigComponents.DefaultQuantity)>
		</cfloop>
        <cfset SystemTotal = round(SystemTotal)>
		<cfreturn SystemTotal>
	</cffunction>

	<cffunction name="getSystemPrice" access="public" returntype="numeric" output="YES">
        <cfargument name="ConfigSystemID" type="string" required="Yes">
        <cfargument name="SystemBasePrice" type="numeric" required="Yes" default="0">
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

		<cfquery datasource="#This.DataSourceName#" name="qryComponentPrices">
		SELECT 
		a.category_defqty,
		a.component_price,
		b.component_sellprice
		FROM iscl.dbo.vsystems_categories_components a, iscl.dbo.vpricelists_categories_components b
		WHERE a.component_default = 1
		AND a.category_system = '#Arguments.ConfigSystemID#'
		AND a.component_item = b.component_item
		AND a.category_code = b.category_code
		AND b.category_pricelist = '#Arguments.PriceListID#' 
		</cfquery>
		<cfoutput query="qryComponentPrices">
			<cfif isNumeric(component_price) EQ 1 AND component_price GT 1>
				<cfset SystemTotal = SystemTotal + (component_price * category_defqty)>
			<cfelse>
				<cfset SystemTotal = SystemTotal + (component_sellprice * category_defqty)>
			</cfif>
		</cfoutput>
		<cfset SystemTotal = ceiling(SystemTotal)>
			   
     
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
		<cfloop query="qryQuoteComponents">
			<cfset PriceOfThisComponent = objPriceListComponents.getSellingPrice(Variables.PriceListID, qryQuoteComponents.ITEMNO)>
            <cfif isNumeric(qryQuoteComponents.Quantity)>
                <cfset PriceOfThisComponent = PriceOfThisComponent * qryQuoteComponents.Quantity>
            </cfif>

			<cfset SystemTotal = SystemTotal + PriceOfThisComponent>
		</cfloop>
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
		<cfloop list="#lstRecord#" index="Column">
        	<cfif findNoCase("CAT_", Column) NEQ 0>
            
            	<cfset CURRENT_ID = removeChars(Column, 1, 4)>
            
            	<cfset FieldValue = Arguments.Record[Column]>            
                <cfset ThisPrice = removeChars(FieldValue, 1, findNoCase('|', FieldValue))>
                <cfset ThisPrice = left(trim(ThisPrice), findNoCase('|', ThisPrice)-1)>
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
		
		<!--- Ron Barth, 9/9/2013 --->
        <cfif isDefined("Arguments.Record.SystemBasePrice") AND isNumeric(Arguments.Record.SystemBasePrice)>
			<cfset SystemTotal = SystemTotal + Arguments.Record.SystemBasePrice>
        </cfif>
		<cfreturn SystemTotal>
    </cffunction>


	<cffunction name="getSystemTotalPrice" access="public" returntype="numeric" output="No">
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
		<cfset lstRecord = structKeyList(Arguments.Record)>
		<cfloop list="#lstRecord#" index="Column">
			<cfif findNoCase("CAT_", Column) NEQ 0>
				<cfset ThisColumnValue = trim(Arguments.Record[Column])>
				<cfset ConfigComponentID = listFirst(ThisColumnValue, "|")>
				<cfset strConfigComponent = objConfigComponents.getRecord(ConfigComponentID)>
				<cftry>
					<cfif strConfigComponent.FixedPrice GT 1>
						<cfset PriceOfThisComponent = strConfigComponent.FixedPrice>
					<cfelse>
						<cfset PriceOfThisComponent = objPriceListComponents.getSellingPrice(Variables.PriceListID, strConfigComponent.ITEMNO)>
					</cfif>
					<cfcatch type="any">
						ConfigComponentID <b><cfoutput>#ConfigComponentID#</cfoutput></b> Not Found!
						<cfabort>
					</cfcatch>
				</cftry>
                
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


	<cffunction name="getSystemBaseMarkedUp" access="public" returntype="numeric" output="no">
	<cfargument name="ConfigSystemID" type="string" required="Yes">
	<cfargument name="CustomerID" type="string" required="Yes">
		<cfset var SystemBaseMarkedUp = 0>
		<cfset objCust = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.Cust")>

		<cfset strConfigSystem = getRecord(Arguments.ConfigSystemID)>
		<cfset SystemBaseMarkedUp = strConfigSystem.SystemBasePrice>

		<cfset qryLogin = objCust.getLoginRecord(Arguments.CustomerID)>
		<cfif qryLogin.RecordCount NEQ 0>
        
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
			<cfquery dbType="query" name="qryHigher">
			SELECT #This.PrimaryKey#
			FROM qryGroup
			WHERE #This.SortKey# = #NewSortOrder#
			</cfquery>
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
		<cfset MaxSortOrder = getMaxSortOrder(ParentID,Arguments.Type,stRecord.DefaultSystem)>

		<cfif OldSortOrder NEQ MaxSortOrder>
			<cfset NewSortOrder = (OldSortOrder + 1)>
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
			<cfquery dbType="query" name="qryHigher">
			SELECT #This.PrimaryKey#
			FROM qryGroup
			WHERE #This.SortKey# = #NewSortOrder#
			</cfquery>
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
			<cfelseif qryConfigComponents.RecordCount EQ 0 AND qryConfigComponents_ALL.RecordCount GT 1>
				<cfset Success = 0>
                <cfset queryAddRow(qryCategoryErrors)>
                <cfset querySetCell(qryCategoryErrors, "Category", qryConfigComponentCategories.Category)>
                <cfset querySetCell(qryCategoryErrors, "Name", qryConfigComponentCategories.Name)>
			</cfif>
		</cfloop>

		<cfif NOT Success>
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

	<cffunction name="saveSalesRepDefaultCase" access="public" output="No">
	<cfargument name="Record" type="struct" required="Yes">
    	<cfset var qryConfigComponents = queryNew("")>
		<cfset CURRENTSalesRepPickDefaultCase = 0>
		<cfset CURRENTSRDefaultCaseID = "">
		<cfset qryConfigSystem = queryNew("")>
		<cfset qryConfigComponentsMASTER = queryNew("")>
		<cfset qryConfigComponentsSALESREP = queryNew("")>
        <cfif structKeyExists(Arguments.Record, "SalesRepPickDefaultCase") AND Arguments.Record.SRDefaultCaseID IS NOT "">
			<cfset CURRENTSalesRepPickDefaultCase = 1>
            <cfset CURRENTSRDefaultCaseID = Arguments.Record.SRDefaultCaseID>

		<cfelse>
			<cfset CURRENTSalesRepPickDefaultCase = 0>
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

        <cfquery datasource="#This.DataSourceName#">
        UPDATE	tblConfigSystems
        SET 	SalesRepPickDefaultCase = #CURRENTSalesRepPickDefaultCase#
        WHERE 	ConfigSystemID = '#Arguments.Record.ConfigSystemID#'
        </cfquery>
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