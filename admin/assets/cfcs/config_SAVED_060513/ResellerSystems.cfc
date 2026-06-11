<cfcomponent extends="admin.assets.cfcs.Component">
	<cfset This.DataSourceName = APPLICATION.DSN_WWW>

	<cfset This.TableName = "tblResellerSystems">
	<cfset This.ViewName = "vResellerSystems">

	<cfset This.Columns = "ResellerSystemID,CustomerID,ConfigSystemID,SystemAlias,SystemPrice,SystemPriceEXP">
	<cfset This.ViewColumns = "ResellerSystemID,CustomerID,SystemAlias,SystemPrice,SystemPriceEXP,CustCompany,CustFirstName,CustLastName,CustEmail,SalesRepFirstName,SalesRepLastName,SalesRepEmail,ConfigSystemID,SystemName,SystemType,SystemSortOrder,SystemTypeSortOrder,EnergystarApproved,SystemClassificationName">
	
	<cfset This.PrimaryKey = "ResellerSystemID">
	
	<cfset This.GenerateUUIDKey = 1>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "ResellerSystemID">
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

	<!------------------------------------------------------------------------------------------------------------------------>
	<cffunction name="assignSystems" access="public" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var CustomerID = Arguments.Record.CustomerID>
<!---        
        <cfset var SystemTotal = 0>
        <cfset var SystemTotalEXP = 0>
--->        
        <cfset var qry_login = queryNew("")>
		<cfset var qryComponentPrices = queryNew("")>

		<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>
		<cfset objComponentPrices = createObject("component", "admin.assets.cfcs.config.ComponentPrices")>
<!---	<cfset lstRecord = structKeyList(Arguments.Record)>--->

		<!--- Get the PriceListID for this customer --->
        <cfquery datasource="#This.DataSourceName#" name="qry_login">
        SELECT	PriceListID
        FROM    login
        WHERE 	CustomerID = '#CustomerID#' 
        </cfquery>

		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "DefaultSystem", 0, True)>
		<cfset structInsert(SearchRecord, "UserID", objConfigSystems.getSessionValue("adminuserid"), True)>
		<cfset qryConfigSystems = objConfigSystems.searchRecords(SearchRecord, "query", "TypeSortOrder, Name")>

		<cfloop query="qryConfigSystems">
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "CustomerID", CustomerID, True)>
			<cfset structInsert(SearchRecord, "ConfigSystemID", qryConfigSystems.ConfigSystemID, True)>
			<cfset qryResellerSystems = searchRecords(SearchRecord, "query")>
			<cfset InDatabase = 0>
			<cfif qryResellerSystems.RecordCount GT 0>
				<cfset InDatabase = 1>
			</cfif>
			<cfset CheckedOnForm = 0>
<!---		<cfif listContainsNoCase(lstRecord, "SYS_#qryConfigSystems.ConfigSystemID#") NEQ 0>	--->
			<cfif listContainsNoCase(Arguments.Record.SystemList, "#qryConfigSystems.ConfigSystemID#") NEQ 0>
				<cfset CheckedOnForm = 1>
			</cfif>
			<!--- The user unchecked this system on the form --->
			<cfif InDatabase AND NOT CheckedOnForm>
				<!--- Delete it --->
				<cfset deleteRecord(qryResellerSystems.ResellerSystemID)>
			<!--- The user checked this system on the form --->
			<cfelseif NOT InDatabase AND CheckedOnForm>
				<!--- Add it --->
				<cfset strResellerSystem = newRecord()>
				<cfset structInsert(strResellerSystem, "CustomerID", CustomerID, True)>
				<cfset structInsert(strResellerSystem, "ConfigSystemID", qryConfigSystems.ConfigSystemID, True)>

				<!--- Calculate the Sell prices --->
<!---                
                <cfif isDefined("qry_login.PriceListID") AND qry_login.PriceListID IS NOT "">
					<cfset SystemTotal = ceiling(objConfigSystems.getSystemTotalPriceDefault(qryConfigSystems.ConfigSystemID, qry_login.PriceListID))>
					<cfset SystemTotalEXP = ceiling(objConfigSystems.getSystemTotalPriceDefault(qryConfigSystems.ConfigSystemID, qry_login.PriceListID, 1, CustomerID))>
					<cfset structInsert(strResellerSystem, "SystemPrice", SystemTotal, True)>
					<cfset structInsert(strResellerSystem, "SystemPriceEXP", SystemTotalEXP, True)>
				</cfif>                
--->                
				<cfset saveRecord(strResellerSystem)>
                
			    <!--- Create entries in tblComponentPrices for this System --->
                <cfif NOT objComponentPrices.pricesExist(qryConfigSystems.ConfigSystemID,qry_login.PriceListID)>
<!---
                <cfif qry_login.PriceListID IS NOT "">
                    <cfquery datasource="#This.DataSourceName#" name="qryComponentPrices">
                    SELECT	ComponentPriceID
                    FROM    tblComponentPrices
                    WHERE 	ConfigSystemID = '#qryConfigSystems.ConfigSystemID#' AND
                            PriceListID = '#qry_login.PriceListID#'
                    </cfquery>
                    <cfif qryComponentPrices.RecordCount EQ 0>
--->                    
                        <cfset objComponentPrices.createPricesForSystem(qryConfigSystems.ConfigSystemID)>               
<!---
					</cfif>
                </cfif>
--->
                </cfif>
                
			</cfif>
		</cfloop>
	</cffunction>
    
	<!------------------------------------------------------------------------------------------------------------------------------------>
	<cffunction name="getResellerSystems" access="public" returntype="query" output="No">
	<cfargument name="SystemType" type="string" required="No" default="">
	<cfargument name="FilterClassificationID" type="string" required="No" default="">
	<cfargument name="SortByPrice" type="boolean" required="No" default="0">
	<cfargument name="LoginID" type="string" required="No" default="">
	<cfargument name="ExportableConfigurator" type="boolean" required="No" default="0">
    
		<cfset var qryResellerSystems = queryNew("")>
<!---        
        <cfset var qryFinal = queryNew("ConfigSystemID,SystemName,EnergystarApproved,PhotoImage,Description,SystemSortOrder,SystemClassificationName,ClassificationSortOrder,SystemTotal")>
        <cfset var qryFinalV2 = queryNew("ConfigSystemID,SystemName,EnergystarApproved,PhotoImage,Description,SystemSortOrder,SystemClassificationName,ClassificationSortOrder,SystemTotal")>
        <cfset var qryDefaultClassification = queryNew("")>
--->        
		<cfset var CURRENTloginID = "">
        <cfset var qrylogin = queryNew("")>

        
		<cfset objCust = createObject("component", "admin.assets.cfcs.Cust")>
		<!---<cfset objClassifications = createObject("component", "admin.assets.cfcs.config.Classifications")>--->
		<!---<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>--->

		<cfif Arguments.LoginID IS NOT "">
			<cfset CURRENTloginID = Arguments.LoginID>
       	<cfelse>
			<cfset CURRENTloginID = getSessionValue("ID")>         
        </cfif>
		<cfset qrylogin = objCust.getRecordAsQuery(CURRENTloginID)>
		<cfif qrylogin.RecordCount NEQ 0>

            <cfquery datasource="#This.DataSourceName#" name="qryResellerSystems">
            SELECT	
<!---            
            		tblResellerSystems.ResellerSystemID,
--->            
					<cfif NOT Arguments.ExportableConfigurator>
	            		tblResellerSystems.SystemPrice AS SystemTotal, 
    				<cfelse>                
	            		tblResellerSystems.SystemPriceEXP AS SystemTotal, 
    				</cfif>
                                    
                    tblResellerSystems.ConfigSystemID, tblResellerSystems.SystemAlias, 
            
            		tblConfigSystems.Name AS SystemName, tblConfigSystems.EnergystarApproved, tblConfigSystems.Type AS SystemType,

                    tblConfigPhotos.PhotoImage, 
                    
                    tblConfigSystems.Description, tblConfigSystems.Specs,
                    
                    tblConfigSystems.SortOrder AS SystemSortOrder,
                    
                    tblConfigSystems.ClassificationID,
                    
                    tblConfigSystems.SystemBasePrice,
                    
                    <!---tblClassifications.Name AS SystemClassificationName,---> 
                    tblClassifications.SortOrder AS ClassificationSortOrder

            FROM    tblResellerSystems LEFT OUTER JOIN
                    tblConfigSystems ON tblResellerSystems.ConfigSystemID = tblConfigSystems.ConfigSystemID LEFT OUTER JOIN
                    tblClassifications ON tblConfigSystems.ClassificationID = tblClassifications.ClassificationID LEFT OUTER JOIN
                    tblConfigPhotos ON tblConfigPhotos.ConfigPhotoID = tblConfigSystems.ConfigPhotoID
                    
            WHERE 	tblResellerSystems.CustomerID = '#qrylogin.CustomerID#' 
    				<cfif Arguments.SystemType IS NOT "">
	            		AND tblConfigSystems.Type = '#Arguments.SystemType#'                    
                    </cfif>
                    <cfif Arguments.FilterClassificationID IS NOT "">
                    	AND tblClassifications.ClassificationID = '#Arguments.FilterClassificationID#' 
                    </cfif>

				<cfif qrylogin.UseClassifications NEQ 1>
                    ORDER BY SystemSortOrder, SystemName
                <cfelseif Arguments.SortByPrice>
                    ORDER BY SystemTotal
                <cfelse>
                    ORDER BY ClassificationSortOrder, SystemSortOrder, SystemName
                </cfif>
                    
            </cfquery>
<!---            
<cfdump var="#qryResellerSystems#"><br>
<cfabort>
--->

<!---
            <cfloop query="qryResellerSystems">
            
				<cfset qryDefaultClassification = objClassifications.getDefault(qryResellerSystems.SystemType)>
            
                <cfif Arguments.FilterClassificationID IS "" OR
                      qryResellerSystems.SystemClassificationName IS Arguments.FilterClassificationID OR 
                     (qryResellerSystems.SystemClassificationName IS "" AND Arguments.FilterClassificationID IS qryDefaultClassification.Name)>
                    <cfset queryAddRow(qryFinal)>
                    <cfset querySetCell(qryFinal, "ConfigSystemID", qryResellerSystems.ConfigSystemID)>
                    
                    <cfif qryResellerSystems.SystemAlias IS NOT "">
                        <cfset querySetCell(qryFinal, "SystemName", qryResellerSystems.SystemAlias)>
					<cfelse>                    
						<cfset querySetCell(qryFinal, "SystemName", qryResellerSystems.SystemName)>
                   	</cfif>
                    
                    <cfset querySetCell(qryFinal, "EnergystarApproved", qryResellerSystems.EnergystarApproved)>
                    <cfset querySetCell(qryFinal, "PhotoImage", qryResellerSystems.PhotoImage)>
                    <cfset querySetCell(qryFinal, "Description", qryResellerSystems.Description)>
                    <cfset querySetCell(qryFinal, "SystemSortOrder", qryResellerSystems.SystemSortOrder)>
                    <cfif qryResellerSystems.SystemClassificationName IS NOT "">
                        <cfset querySetCell(qryFinal, "SystemClassificationName", qryResellerSystems.SystemClassificationName)>
                        <cfset querySetCell(qryFinal, "ClassificationSortOrder", qryResellerSystems.ClassificationSortOrder)>
                    <cfelse>
                        <cfset querySetCell(qryFinal, "SystemClassificationName", qryDefaultClassification.Name)>
                        <cfset querySetCell(qryFinal, "ClassificationSortOrder", qryDefaultClassification.SortOrder)>
                    </cfif>
<!---    
    				<!--- EXPORTABLE CONFIGURATOR --->
    				<cfif Arguments.ExportableConfigurator>
						<cfset SystemTotal = ceiling(objConfigSystems.getSystemTotalPriceDefault(qryResellerSystems.ConfigSystemID, qrylogin.PriceListID, 1, qrylogin.CustomerID))>
                    <!--- REGULAR (PARTNERS) CONFIGURATOR --->
                    <cfelse>
						<cfset SystemTotal = ceiling(objConfigSystems.getSystemTotalPriceDefault(qryResellerSystems.ConfigSystemID, qrylogin.PriceListID))>
                    </cfif>
--->                                    
                    <cfset querySetCell(qryFinal, "SystemTotal", qryResellerSystems.SystemTotal)>



                </cfif>
            </cfloop>
<!---
qryFinal:<cfdump var="#qryFinal#">
--->
			<cfquery dbtype="query" name="qryFinalV2">
            SELECT	*
            FROM	qryFinal
				<cfif qrylogin.UseClassifications NEQ 1>
                    ORDER BY SystemSortOrder, SystemName
                <cfelseif Arguments.SortByPrice>
                    ORDER BY SystemTotal
                <cfelse>
                    ORDER BY ClassificationSortOrder, SystemSortOrder, SystemName
                </cfif>
            </cfquery>
--->

<!---
qryFinalV2:<cfdump var="#qryFinalV2#">
--->
		</cfif>
		<cfreturn qryResellerSystems>
	</cffunction>
    
	<!------------------------------------------------------------------------------------------------------------------------------------>
	<cffunction name="getResellerSystems_LeftNav" access="public" returntype="query" output="No">
	<cfargument name="SystemType" type="string" required="Yes">
		<cfset var qryResellerSystems = queryNew("")>
		<cfset var CURRENTloginID = "">
        <cfset var qrylogin = queryNew("")>
		<cfset objCust = createObject("component", "admin.assets.cfcs.Cust")>
		<cfset CURRENTloginID = getSessionValue("ID")>         
		<cfset qrylogin = objCust.getRecordAsQuery(CURRENTloginID)>
		<cfif qrylogin.RecordCount NEQ 0>
            <cfquery datasource="#This.DataSourceName#" name="qryResellerSystems">
            SELECT	ConfigSystemID
            FROM    tblResellerSystems          
            WHERE 	tblResellerSystems.CustomerID = '#qrylogin.CustomerID#' 
            </cfquery>
		</cfif>
		<cfreturn qryResellerSystems>
	</cffunction>

    
	<!------------------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="getResellerSystemsEXP" access="public" returntype="query" output="No">
	<!--- EXPORTABLE CONFIGURATOR --->
	<cfargument name="SystemType" type="string" required="Yes">
	<cfargument name="loginID" type="string" required="Yes">
		<cfset var qryResellerSystems = queryNew(This.ViewColumns)>
		<cfset objCust = createObject("component", "admin.assets.cfcs.Cust")>
		<cfset qrylogin = objCust.getRecordAsQuery(Arguments.loginID)>
		<cfif qrylogin.RecordCount NEQ 0>
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "CustomerID", qrylogin.CustomerID, True)>
			<cfset structInsert(SearchRecord, "SystemType", Arguments.SystemType, True)>
			<cfset qryResellerSystems = searchRecords(SearchRecord, "query", "SystemSortOrder,SystemName")>
		</cfif>
		<cfreturn qryResellerSystems>
	</cffunction>

	<cffunction name="listSystemsForAlias" access="public" returntype="query" output="No">
	<cfargument name="CustomerID" type="string" required="Yes">
		<cfset var qryResellerSystems = queryNew("")>
		<cfquery datasource="#This.DataSourceName#" name="qryResellerSystems">
		SELECT 	ResellerSystemID, SystemType, SystemName, SystemAlias
		FROM 	vResellerSystems
        WHERE 	CustomerID = '#Arguments.CustomerID#'
        ORDER BY SystemTypeSortOrder, SystemName
        </cfquery>
		<cfreturn qryResellerSystems>
	</cffunction>

	<cffunction name="saveAliasNames" access="public" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var lstRecord = structKeyList(Arguments.Record)>
        <cfset var Column = "">
        <cfset var ResellerSystemID = "">
        <cfset var Alias = "">
		<cfloop list="#lstRecord#" index="Column">
        	<cfif findNoCase('Alias|', Column) NEQ 0>
				<cfset ResellerSystemID = removeChars(Column, 1, 6)>
                <cfset Alias = trim(Arguments.Record[Column])>
                <cfquery datasource="#This.DataSourceName#">
                UPDATE	tblResellerSystems
                SET 	SystemAlias = '#Alias#'
                WHERE 	ResellerSystemID = '#ResellerSystemID#'
                </cfquery>	
			</cfif>
        </cfloop>
	</cffunction>

	<cffunction name="getAlias" access="public" returntype="string" output="No">
	<cfargument name="CustomerID" type="string" required="Yes">
	<cfargument name="ConfigSystemID" type="string" required="Yes">
		<cfset var SystemName = "">
        <cfset var qryResellerSystems = queryNew("")>
        <cfset var qryConfigSystems = queryNew("")>
		<cfquery datasource="#This.DataSourceName#" name="qryResellerSystems">
		SELECT 	SystemAlias
		FROM 	tblResellerSystems
        WHERE 	CustomerID = '#Arguments.CustomerID#' AND
        		ConfigSystemID = '#Arguments.ConfigSystemID#'
        </cfquery>
		<cfif qryResellerSystems.RecordCount NEQ 0 AND trim(qryResellerSystems.SystemAlias) IS NOT "">
			<cfset SystemName = qryResellerSystems.SystemAlias>
		</cfif>
        <cfif SystemName IS "">
            <cfquery datasource="#This.DataSourceName#" name="qryConfigSystems">
            SELECT 	Name
            FROM 	tblConfigSystems
            WHERE 	ConfigSystemID = '#Arguments.ConfigSystemID#'
            </cfquery>
            <cfif qryConfigSystems.RecordCount NEQ 0>
				<cfset SystemName = qryConfigSystems.Name>
            </cfif>
		</cfif>
		<cfreturn SystemName>
	</cffunction>

	<!------------------------------------------------------------------------------------>
<!--- Deprecated, 04/07/2010 --->
<!---    
	<cffunction name="updatePrices" access="public" output="YES" returntype="void">
		<cfargument name="CustomerID" type="string" required="yes" />
        <cfset var qryResellerSystems = queryNew("")>
        <cfset var CURRENTResellerSystemID = "">
        <cfset var SystemTotal = 0>
        <cfset var SystemTotalEXP = 0>
		<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>
       
        <cfquery name="qryResellerSystems" datasource="#This.DataSourceName#">
        SELECT	tblConfigSystems.Name, tblResellerSystems.ResellerSystemID, tblResellerSystems.CustomerID, tblResellerSystems.ConfigSystemID, 
                tblResellerSystems.SystemAlias, tblResellerSystems.SystemPrice, tblResellerSystems.SystemPriceEXP,
                tblResellerSystems.DateLastPriceUpdate,
                login.company, 
                login.firstname, login.lastname, login.PriceListID
        FROM    tblResellerSystems INNER JOIN
                login ON tblResellerSystems.CustomerID = login.CustomerID INNER JOIN
                tblConfigSystems ON tblResellerSystems.ConfigSystemID = tblConfigSystems.ConfigSystemID
        WHERE	login.CustomerID = '#Arguments.CustomerID#'
        </cfquery>
        
        <cfloop query="qryResellerSystems">
            <cfset CURRENTResellerSystemID = qryResellerSystems.ResellerSystemID>
            <cfset SystemTotal = ceiling(objConfigSystems.getSystemTotalPriceDefault(qryResellerSystems.ConfigSystemID, qryResellerSystems.PriceListID))>
            <cfset SystemTotalEXP = ceiling(objConfigSystems.getSystemTotalPriceDefault(qryResellerSystems.ConfigSystemID, qryResellerSystems.PriceListID, 1, qryResellerSystems.CustomerID))>
        
            <cfquery datasource="#This.DataSourceName#">
            UPDATE	tblResellerSystems 
            SET		SystemPrice = '#SystemTotal#',
                    SystemPriceEXP = '#SystemTotalEXP#',
                    DateLastPriceUpdate = #CreateODBCDateTime(now())#
            WHERE 	ResellerSystemID = '#CURRENTResellerSystemID#'
            </cfquery>		
        </cfloop>
	</cffunction>
--->
	
</cfcomponent>