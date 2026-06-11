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


	<cfset This.TableName = "tblComponentPrices">
	<cfset This.ViewName = This.TableName>

	<cfset This.Columns = "ComponentPriceID,ConfigComponentID,ITEMNO,DESCRIPTION,DefaultComponent,ConfigComponentCategoryID,ConfigSystemID,PriceListID,Price">
<!---<cfset This.ViewColumns = "CustomerID,ConfigComponentCategoryID,ConfigComponentID,Price,AddDeductAmount,DESCRIPTION, DefaultComponent,ITEMNO">--->
	<cfset This.ViewColumns = This.Columns>
	
	<cfset This.PrimaryKey = "ComponentPriceID">
	
	<cfset This.GenerateUUIDKey = 1>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "Price">
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


	<!-------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="createPricesForAllSystems" access="public" output="No">
    	<cfset var qryAllSystems = queryNew("")>
		<cfquery datasource="#This.DataSourceName#" name="qryAllSystems">
		SELECT	ConfigSystemID
		FROM 	tblConfigSystems 
		</cfquery>	
		<cfloop query="qryAllSystems">
        	<cfset createPricesForSystem(qryAllSystems.ConfigSystemID)>
        </cfloop>
	</cffunction>

	<!-------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="createPricesForSystem" access="public" output="No">
    <!---
			Fill up tblComponentPrices for all prices for a given system.	
	--->
	<cfargument name="ConfigSystemID" type="string" required="Yes">
    	<cfset var qryPriceLists = queryNew("")>
	    <cfset var qryConfigComponents = queryNew("")>
        <cfset var PriceOfThisComponent = 0>
        <cfset var CURRENTConfigComponentID = "">
		<cfset var CURRENT_ITEMNO = "">
        <cfset var CURRENT_DESCRIPTION = "">
		<cfset var CURRENTDefaultComponent = "">
		<cfset var CURRENTConfigComponentCategoryID = "">
        <cfset var CURRENTConfigSystemID = "">
        <cfset var CURRENTPriceListID = "">
        
		<cfset objPriceListComponents = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.prices.PriceListComponents")>
        
		<cfset qryPriceLists = getPriceListsForSystem(Arguments.ConfigSystemID)>

		<!--- Delete all prices for this system --->
        <cfquery datasource="#This.DataSourceName#">
        DELETE FROM tblComponentPrices
        WHERE 	ConfigSystemID = '#Arguments.ConfigSystemID#' 
        </cfquery>

		<cfquery datasource="#This.DataSourceName#" name="qryConfigComponents">
		SELECT	tblConfigComponents.ConfigComponentID, tblConfigComponents.DefaultComponent, 
        		tblConfigComponents.ITEMNO, tblConfigComponents.DESCRIPTION,
        		tblConfigComponents.ConfigComponentCategoryID, 
        		tblConfigComponents.ITEMNO, tblConfigComponentCategories.ConfigSystemID
		FROM 	tblConfigComponents INNER JOIN 
        		tblConfigComponentCategories ON tblConfigComponents.ConfigComponentCategoryID = tblConfigComponentCategories.ConfigComponentCategoryID
        WHERE	tblConfigComponentCategories.ConfigSystemID = '#Arguments.ConfigSystemID#'
		</cfquery>	

		<cfloop query="qryConfigComponents">
        	<cfset CURRENTConfigComponentID = qryConfigComponents.ConfigComponentID>
        	<cfset CURRENT_ITEMNO = qryConfigComponents.ITEMNO>
        	<cfset CURRENT_DESCRIPTION = qryConfigComponents.DESCRIPTION>
        	<cfset CURRENTDefaultComponent = qryConfigComponents.DefaultComponent>
			<cfset CURRENTConfigComponentCategoryID = qryConfigComponents.ConfigComponentCategoryID>
            <cfset CURRENTConfigSystemID = qryConfigComponents.ConfigSystemID>
            
        	<cfloop query="qryPriceLists">  
				<cfset CURRENTPriceListID = qryPriceLists.PriceListID>                      
				<cfset PriceOfThisComponent = round(objPriceListComponents.getSellingPrice(CURRENTPriceListID, CURRENT_ITEMNO))>

                <cfquery datasource="#This.DataSourceName#">
                DELETE FROM tblComponentPrices
                WHERE 	ConfigComponentID = '#CURRENTConfigComponentID#' AND
                	 	PriceListID = '#CURRENTPriceListID#' 
				</cfquery>

                <cfquery datasource="#This.DataSourceName#">
                INSERT INTO tblComponentPrices (
                    ComponentPriceID, 
                    ConfigComponentID,
                    ITEMNO,
                    DESCRIPTION,
                    DefaultComponent,                   
                    ConfigComponentCategoryID,
                    ConfigSystemID,
                    PriceListID,
                    Price)
                VALUES (
                    '#createUUID()#', 
                    '#CURRENTConfigComponentID#',
                    '#CURRENT_ITEMNO#',
                    '#CURRENT_DESCRIPTION#',
                    '#CURRENTDefaultComponent#',
                    '#CURRENTConfigComponentCategoryID#',
                    '#CURRENTConfigSystemID#',
                    '#CURRENTPriceListID#',
                    '#PriceOfThisComponent#')
                </cfquery>

            </cfloop>
        </cfloop>

	</cffunction>

	<!-------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="createPricesForReseller" access="public" output="No">
    <!---
			Fill up tblComponentPrices for all prices for a given reseller/price list.	
	--->
	<cfargument name="CustomerID" type="string" required="Yes">
	    <cfset var qryConfigComponents = queryNew("")>
	    <cfset var qry_login = queryNew("")>
	    <cfset var qryResellerSystems = queryNew("")>
        <cfset var PriceOfThisComponent = 0>
        <cfset var CURRENTConfigComponentID = "">
		<cfset var CURRENT_ITEMNO = "">
        <cfset var CURRENT_DESCRIPTION = "">
		<cfset var CURRENTDefaultComponent = "">
		<cfset var CURRENTConfigComponentCategoryID = "">
        <cfset var CURRENTConfigSystemID = "">
        <cfset var CURRENTPriceListID = "">
		<cfset objPriceListComponents = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.prices.PriceListComponents")>

		<cfquery datasource="#This.DataSourceName#" name="qry_login">
		SELECT	PriceListID
		FROM 	login
        WHERE	CustomerID = '#Arguments.CustomerID#'
		</cfquery>	
		<cfif qry_login.RecordCount NEQ 0 AND qry_login.PriceListID IS NOT "">
           	<cfset CURRENTPriceListID = qry_login.PriceListID>                      

            <cfquery datasource="#This.DataSourceName#" name="qryResellerSystems">
            SELECT	ConfigSystemID
            FROM 	tblResellerSystems
            WHERE	CustomerID = '#Arguments.CustomerID#'
            </cfquery>	
            
            <cfloop query="qryResellerSystems">
                <cfquery datasource="#This.DataSourceName#" name="qryConfigComponents">
                SELECT	tblConfigComponents.ConfigComponentID, tblConfigComponents.DefaultComponent, 
                        tblConfigComponents.ITEMNO, tblConfigComponents.DESCRIPTION,
                        tblConfigComponents.ConfigComponentCategoryID, 
                        tblConfigComponents.ITEMNO, tblConfigComponentCategories.ConfigSystemID
                FROM 	tblConfigComponents INNER JOIN 
                        tblConfigComponentCategories ON tblConfigComponents.ConfigComponentCategoryID = tblConfigComponentCategories.ConfigComponentCategoryID
                WHERE	tblConfigComponentCategories.ConfigSystemID = '#qryResellerSystems.ConfigSystemID#'
                </cfquery>	
    
                <cfloop query="qryConfigComponents">
                    <cfset CURRENTConfigComponentID = qryConfigComponents.ConfigComponentID>
                    <cfset CURRENT_ITEMNO = qryConfigComponents.ITEMNO>
                    <cfset CURRENT_DESCRIPTION = qryConfigComponents.DESCRIPTION>
                    <cfset CURRENTDefaultComponent = qryConfigComponents.DefaultComponent>
                    <cfset CURRENTConfigComponentCategoryID = qryConfigComponents.ConfigComponentCategoryID>
                    <cfset CURRENTConfigSystemID = qryConfigComponents.ConfigSystemID>
                
                    <cfset PriceOfThisComponent = round(objPriceListComponents.getSellingPrice(CURRENTPriceListID, CURRENT_ITEMNO))>
    
                    <cfquery datasource="#This.DataSourceName#">
                    DELETE FROM tblComponentPrices
                    WHERE 	ConfigComponentID = '#CURRENTConfigComponentID#' AND
                            PriceListID = '#CURRENTPriceListID#' 
                    </cfquery>
    
                    <cfquery datasource="#This.DataSourceName#">
                    INSERT INTO tblComponentPrices (
                        ComponentPriceID, 
                        ConfigComponentID,
                        ITEMNO,
                        DESCRIPTION,
                        DefaultComponent,                   
                        ConfigComponentCategoryID,
                        ConfigSystemID,
                        PriceListID,
                        Price)
                    VALUES (
                        '#createUUID()#', 
                        '#CURRENTConfigComponentID#',
                        '#CURRENT_ITEMNO#',
                        '#CURRENT_DESCRIPTION#',
                        '#CURRENTDefaultComponent#',
                        '#CURRENTConfigComponentCategoryID#',
                        '#CURRENTConfigSystemID#',
                        '#CURRENTPriceListID#',
                        '#PriceOfThisComponent#')
                    </cfquery>
                </cfloop>
            </cfloop>
        </cfif>
	</cffunction>
    
	<!-------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="getPriceListsForSystem" access="public" returntype="query" output="No">
	<cfargument name="ConfigSystemID" type="string" required="Yes">
    	<cfset var qryPriceLists = queryNew("PriceListID")>
		<cfquery datasource="#This.DataSourceName#" name="qryPriceLists">
		SELECT	DISTINCT login.PriceListID
		FROM 	tblResellerSystems 
        		INNER JOIN login ON tblResellerSystems.CustomerID = login.CustomerID
        WHERE	ConfigSystemID = '#Arguments.ConfigSystemID#' AND
        		login.PriceListID <> '' AND login.PriceListID IS NOT NULL
		</cfquery>	
        <cfset queryAddRow(qryPriceLists)>
        <cfset querySetCell(qryPriceLists, "PriceListID", "MASTERPRICELISTUUID")>
		<cfreturn qryPriceLists>
	</cffunction>


	<!-------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="deletePricesForSystem" access="public" output="No">
	<cfargument name="ConfigSystemID" type="string" required="Yes">
        <cfquery datasource="#This.DataSourceName#">
        DELETE FROM tblComponentPrices
        WHERE 		ConfigSystemID = '#Arguments.ConfigSystemID#'
        </cfquery>       
	</cffunction>

	<!-------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="deletePricesForCategory" access="public" output="No">
	<cfargument name="ConfigComponentCategoryID" type="string" required="Yes">
        <cfquery datasource="#This.DataSourceName#">
        DELETE FROM tblComponentPrices
        WHERE 		ConfigComponentCategoryID = '#Arguments.ConfigComponentCategoryID#'
        </cfquery>       
	</cffunction>

	<!-------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="deletePricesForComponent" access="public" output="No">
	<cfargument name="ConfigComponentID" type="string" required="Yes">
        <cfquery datasource="#This.DataSourceName#">
        DELETE FROM tblComponentPrices
        WHERE 		ConfigComponentID = '#Arguments.ConfigComponentID#'
        </cfquery>       
	</cffunction>

	<!-------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="setComponentPriceAsDefault" access="public" output="No">
	<cfargument name="ConfigComponentID" type="string" required="Yes">
		<cfset var qryConfigComponent = queryNew("")>
		<cfif getSessionValue("newsystem") IS NOT "1">
            <cfquery datasource="#This.DataSourceName#">
            UPDATE	tblComponentPrices
            SET 	DefaultComponent = 1
            WHERE 	ConfigComponentID = '#Arguments.ConfigComponentID#'
            </cfquery>
    
            <cfquery datasource="#This.DataSourceName#" name="qryConfigComponent">
            SELECT	ConfigComponentCategoryID
            FROM	tblConfigComponents
            WHERE 	ConfigComponentID = '#Arguments.ConfigComponentID#'
            </cfquery>	
    
            <cfquery datasource="#This.DataSourceName#">
            UPDATE	tblComponentPrices
            SET 	DefaultComponent = 0
            WHERE 	ConfigComponentCategoryID = '#qryConfigComponent.ConfigComponentCategoryID#' AND
                    ConfigComponentID <> '#Arguments.ConfigComponentID#'
            </cfquery>
        </cfif>
	</cffunction>

	<!-------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="deletePricesForPriceList" access="public" output="No">
	<cfargument name="PriceListID" type="string" required="Yes">
        <cfquery datasource="#This.DataSourceName#">
        DELETE FROM tblComponentPrices
        WHERE 		PriceListID = '#Arguments.PriceListID#'
        </cfquery>       
	</cffunction>



	<!-------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="createPricesForComponent" access="public" output="No">
	<cfargument name="ConfigComponentID" type="string" required="Yes">
        <cfset var CURRENTConfigComponentID = "">
		<cfset var CURRENT_ITEMNO = "">
        <cfset var CURRENT_DESCRIPTION = "">
		<cfset var CURRENTDefaultComponent = "">
		<cfset var CURRENTConfigComponentCategoryID = "">
        <cfset var CURRENTConfigSystemID = "">
        <cfset var CURRENTPriceListID = "">
        <cfset var qryConfigComponents = queryNew("")>
		<cfset objPriceListComponents = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.prices.PriceListComponents")>
		<cfif getSessionValue("newsystem") IS NOT "1">
            <cfquery datasource="#This.DataSourceName#" name="qryConfigComponents">
            SELECT	ConfigSystemID, ConfigComponentID, ITEMNO, DESCRIPTION, DefaultComponent, ConfigComponentCategoryID
            FROM	vConfigComponents
            WHERE 	ConfigComponentID = '#Arguments.ConfigComponentID#'
            </cfquery>	
            <cfif qryConfigComponents.RecordCount NEQ 0>
                <cfset CURRENTConfigComponentID = qryConfigComponents.ConfigComponentID>
                <cfset CURRENT_ITEMNO = qryConfigComponents.ITEMNO>
                <cfset CURRENT_DESCRIPTION = qryConfigComponents.DESCRIPTION>
                <cfset CURRENTDefaultComponent = qryConfigComponents.DefaultComponent>
                <cfset CURRENTConfigComponentCategoryID = qryConfigComponents.ConfigComponentCategoryID>
                <cfset CURRENTConfigSystemID = qryConfigComponents.ConfigSystemID>
            
                <cfset qryPriceLists = getPriceListsForSystem(qryConfigComponents.ConfigSystemID)>
    
                <cfloop query="qryPriceLists">  
                    <cfset CURRENTPriceListID = qryPriceLists.PriceListID>                      
                    <cfset PriceOfThisComponent = round(objPriceListComponents.getSellingPrice(CURRENTPriceListID, CURRENT_ITEMNO))>
                    <cfquery datasource="#This.DataSourceName#">
                    DELETE FROM tblComponentPrices
                    WHERE 	ConfigComponentID = '#CURRENTConfigComponentID#' AND
                            PriceListID = '#CURRENTPriceListID#' 
                    </cfquery>
                    <cfquery datasource="#This.DataSourceName#">
                    INSERT INTO tblComponentPrices (
                        ComponentPriceID, 
                        ConfigComponentID,
                        ITEMNO,
                        DESCRIPTION,
                        DefaultComponent,                   
                        ConfigComponentCategoryID,
                        ConfigSystemID,
                        PriceListID,
                        Price)
                    VALUES (
                        '#createUUID()#', 
                        '#CURRENTConfigComponentID#',
                        '#CURRENT_ITEMNO#',
                        '#CURRENT_DESCRIPTION#',
                        '#CURRENTDefaultComponent#',
                        '#CURRENTConfigComponentCategoryID#',
                        '#CURRENTConfigSystemID#',
                        '#CURRENTPriceListID#',
                        '#PriceOfThisComponent#')
                    </cfquery>
                </cfloop>
            </cfif>
		</cfif>       
	</cffunction>
    
	<!-------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="pricesExist" access="public" returntype="boolean" output="No">
	<cfargument name="ConfigSystemID" type="string" required="Yes">
	<cfargument name="PriceListID" type="string" required="Yes">
		<cfset var pricesExist = 1>
        <cfset var qryComponentPrices = queryNew("")>
		<cfif Arguments.PriceListID IS NOT "">
            <cfquery datasource="#This.DataSourceName#" name="qryComponentPrices">
            SELECT	ComponentPriceID
            FROM    tblComponentPrices
            WHERE 	ConfigSystemID = '#Arguments.ConfigSystemID#' AND
                    PriceListID = '#Arguments.PriceListID#'
            </cfquery>
            <cfif qryComponentPrices.RecordCount EQ 0>
				<cfset pricesExist = 0>
            </cfif>
        </cfif>

        <cfreturn pricesExist>
	</cffunction>

	<!-------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="pricesExistForPriceList" access="public" returntype="boolean" output="No">
	<cfargument name="PriceListID" type="string" required="Yes">
		<cfset var pricesExist = 1>
        <cfset var qryComponentPrices = queryNew("")>
		<cfif Arguments.PriceListID IS NOT "">
            <cfquery datasource="#This.DataSourceName#" name="qryComponentPrices">
            SELECT	ComponentPriceID
            FROM    tblComponentPrices
            WHERE 	PriceListID = '#Arguments.PriceListID#'
            </cfquery>
            <cfif qryComponentPrices.RecordCount EQ 0>
				<cfset pricesExist = 0>
            </cfif>
        </cfif>
        <cfreturn pricesExist>
	</cffunction>

	<!-------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="searchComponents" access="public" returntype="query" output="No">
	<cfargument name="PriceListID" type="string" required="Yes">
	<cfargument name="SearchText" type="string" required="Yes">
	<cfargument name="OrderByList" type="string" required="No">
    	<cfset var qryComponents = queryNew("")>
        <cfif NOT isDefined("Arguments.OrderByList")>
        	<cfset Arguments.OrderByList = "ITEMNO">
        </cfif>
        <cfquery datasource="#This.DataSourceName#" name="qryComponents">
        SELECT	<!---TOP 100 ---> ComponentPriceID, ITEMNO, DESCRIPTION, Price
        FROM    tblComponentPrices
        WHERE 	PriceListID = '#Arguments.PriceListID#' AND
        		DESCRIPTION LIKE '%#trim(Arguments.SearchText)#%'
		ORDER BY #Arguments.OrderByList#                 
        </cfquery>
        <cfreturn qryComponents>
	</cffunction>


	
</cfcomponent>