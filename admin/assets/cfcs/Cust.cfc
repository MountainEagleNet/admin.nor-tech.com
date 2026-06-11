<cfcomponent extends="admin.assets.cfcs.Component" name="Cust" hint="I handle requests from the admin section dealing with customer accounts.">

	<cfif isDefined("APPLICATION.DSN_WWW")>
		<cfset THIS.DSN_WWW = APPLICATION.DSN_WWW>
	<cfelse>
		<cfset THIS.DSN_WWW = "NorTechWWW">
	</cfif>

<!--- RAB 11/15/2012 --->
<!---
	<cfset THIS.ColumnNames = "ID,CustomerID,username,passcode,acctno,company,firstname,lastname,email,PhoneNumber,salesrepid,pointssystem,pointsnotebook,pointsserver,accesslevel,AccessLevelNew,DateEmailSent,active,LogoDisplay,Logo,LogoAlign,MarkupType,PercentNotebooks,PercentWorkstations,PercentServers,PercentMiniMountablePCs,PercentComponents,SendShipmentConfirmation,PriceListID,PriceListAccess,GarageSaleAccess,ShippingAndTax,FreightEstimator,FreightEstimatorEXP,IntelIDNumber,UseClassifications">
--->    
	<cfset THIS.ColumnNames = "ID,CustomerID,username,passcode,acctno,company,firstname,lastname,email,PhoneNumber,salesrepID,pointssystem,pointsnotebook,pointsserver,accesslevel,AccessLevelNew,DateEmailSent,active,FontFamily,FontColor,FontColorOther,StandardFontSize,HeaderFontSize,LogoDisplay,Logo,LogoAlign,TitleDisplay,TitleAlign,TitleFontSize,RootURL,BackURL,EmailAddresses,MarkupType,PercentNotebooks,PercentWorkstations,PercentServers,PercentMiniMountablePCs,PercentComponents,SendShipmentConfirmation,PriceListID,PriceListAccess,GarageSaleAccess,ShippingAndTax,FreightEstimator,FreightEstimatorExp,ShippingChargeType,FlatRateWorkstations,FlatRateServers,FlatRateNotebooks,FlatRateMiniPCs,MarkupShippingCharges,IntelIDNumber,UseClassifications,DefaultAccount">


	<cfset This.Columns = THIS.ColumnNames>
	<cfset This.ViewColumns = This.Columns>

	<cfset THIS.TableName = "login">
	<Cfset This.ViewName = THIS.TableName>
	
	<cfset THIS.PriKey = "ID">
	
<!--- newRecord() --->
	<cffunction name="newRecord" access="public" output="no" returntype="struct">
		<cfset var stRecord = StructNew()>
		
		<cfloop list="#THIS.ColumnNames#" index="x">
			<cfif x IS "active" OR 
				  x IS "SendShipmentConfirmation" OR 
				  x IS "PriceListAccess" OR 
				  x IS "GarageSaleAccess" OR 
				  x IS "ShippingAndTax" OR 
				  x IS "FreightEstimator" OR 
				  x IS "UseClassifications">
				<cfset "stRecord.#x#" = 1>
			<cfelse>
				<cfset "stRecord.#x#" = "">
			</cfif>
		</cfloop>
		
		<cfreturn stRecord />
	</cffunction>
	
<!--- listRecords() --->
	<cffunction name="listRecords" access="public" output="no" returntype="query">
		<cfargument name="sortby" type="string" required="no" default="FirstName" />
		<cfargument name="ascdesc" type="string" required="no" default="ASC" />
		
		<cfquery name="qListRecords" datasource="#THIS.DSN_WWW#">
		SELECT
			#THIS.ColumnNames#
		FROM
			#THIS.TableName#
		ORDER BY
			#ARGUMENTS.SortBy# #AscDesc#
		;
		</cfquery>
		
		<cfreturn qListRecords />
	</cffunction>
<!--- searchRecords() --->
	<cffunction name="searchRecords" access="public" output="YES" returntype="query">
		<cfargument name="searchRecord" type="struct" required="yes" />
		<cfargument name="sortby" type="string" required="no" default="FirstName" />
		<cfargument name="ascdesc" type="string" required="no" default="ASC" />

		<cfquery name="qSearchRecords" datasource="#THIS.DSN_WWW#">
		SELECT
			#THIS.ColumnNames#
		FROM
			#THIS.TableName#
		WHERE
			1 = 1
			<cfloop collection="#searchRecord#" item="key">
				 AND
				#key# LIKE '%#searchRecord[key]#%'
			</cfloop>
			<cfif SESSION.Role IS "Sales Rep">
				AND salesrepID = #SESSION.SalesRepID#
			</cfif>
		ORDER BY
			#ARGUMENTS.SortBy# #AscDesc#
		;
		</cfquery>
		
		<cfreturn qSearchRecords />
	</cffunction>
	
	
	<cffunction name="searchRecordsALT" access="public" output="YES" returntype="query">
		<cfargument name="searchRecord" type="struct" required="yes" />
		<cfargument name="OrderByList" type="string" required="yes" />

		<cfquery name="qSearchRecords" datasource="#THIS.DSN_WWW#">
		SELECT	#THIS.ColumnNames#
		FROM	#THIS.TableName#
		WHERE
			1 = 1
			<cfloop collection="#searchRecord#" item="key">
				 AND
				#key# LIKE '%#searchRecord[key]#%'
			</cfloop>
			<cfif SESSION.Role IS "Sales Rep">
				AND salesrepID = #SESSION.SalesRepID#
			</cfif>
		ORDER BY
			#ARGUMENTS.OrderByList# 
		;
		</cfquery>
		
		<cfreturn qSearchRecords />
	</cffunction>
	
		
<!--- getRecordAsQuery() --->
	<cffunction name="getRecordAsQuery" access="public" output="no" returntype="query">
		<cfargument name="RecordID" required="yes" type="string" />
		<cfquery name="qGetRecord" datasource="#THIS.DSN_WWW#">
		SELECT
			#THIS.ColumnNames#
		FROM
			#THIS.TableName#
		WHERE
			#THIS.PriKey# = '#ARGUMENTS.RecordID#'
		;
		</cfquery>
		
		<cfreturn qGetRecord />
	</cffunction>
	
	<cffunction name="getRecordAsQueryByCustomerID" access="public" output="no" returntype="query">
		<cfargument name="CustomerID" required="yes" type="string" />
		
		<cfquery name="qGetRecord" datasource="#THIS.DSN_WWW#">
		SELECT
			#THIS.ColumnNames#
		FROM
			#THIS.TableName#
		WHERE
			CustomerID = '#ARGUMENTS.CustomerID#'
		;
		</cfquery>
		
		<cfreturn qGetRecord />
	</cffunction>

	<!---------------------------------------------------------------------------------------------------------------->
	<cffunction name="getFreightEstimatorInfo" access="public" output="no" returntype="query">
		<cfargument name="CustomerID" required="yes" type="string" />
        <cfset var qryLogin = queryNew("")>
		<cfquery name="qryLogin" datasource="#THIS.DSN_WWW#">
		SELECT	FreightEstimator,FreightEstimatorExp,ShippingChargeType,FlatRateWorkstations,FlatRateServers,FlatRateNotebooks,FlatRateMiniPCs,MarkupShippingCharges
		FROM	login
		WHERE	CustomerID = '#Arguments.CustomerID#'
		</cfquery>
		<cfreturn qryLogin>
	</cffunction>

	<!---------------------------------------------------------------------------------------------------------------->
	<cffunction name="getRecordByAcctno" access="public" output="no" returntype="query">
		<cfargument name="AcctNo" required="yes" type="string" />
		<cfquery name="qryLogin" datasource="#THIS.DSN_WWW#">
			SELECT	#THIS.ColumnNames#
			FROM	#THIS.TableName#
			WHERE	acctno = '#trim(ARGUMENTS.AcctNo)#'
		</cfquery>
		<cfreturn qryLogin />
	</cffunction>


	<cffunction name="getLoginRecord" access="public" output="no" returntype="query">
	<!--- 7/11/06, RAB --->
		<cfargument name="CustomerID" required="yes" type="string" />
		<cfquery name="qGetRecord" datasource="#THIS.DSN_WWW#">
		SELECT	*
		FROM	#THIS.TableName#
		WHERE	CustomerID = '#ARGUMENTS.CustomerID#'
		;
		</cfquery>
		<cfreturn qGetRecord />
	</cffunction>

	
<!--- getRecordAsStruct() --->
	<cffunction name="getRecordAsStruct" access="public" output="no" returntype="struct">
		<cfargument name="RecordID" required="yes" type="string" />
		
		<cfset var stRecord = newRecord()>
		
		<cfset qRecord = getRecordAsQuery(ARGUMENTS.RecordID)>
		<cfloop list="#THIS.ColumnNames#" index="Column">
			<cfset "stRecord.#Column#" = evaluate("qRecord.#Column#")>
		</cfloop>
		
		<cfreturn stRecord />
	</cffunction>
	
<!--- insertRecord() --->
	<cffunction name="insertRecord" access="public" output="no" returntype="any">
		<cfargument name="Record" type="struct" required="yes" />

		<cfset var CustomerID = createUUID()>

		<cfquery name="qInsertRecord" datasource="#THIS.DSN_WWW#">
		INSERT INTO
			#THIS.TableName#
		(
			CustomerID,
			username,
			passcode,
			acctno,
			company,
			firstname,
			lastname,
			email,
			salesrepid,
			pointssystem,
			pointsnotebook,
			pointsserver,
			accesslevel,
			AccessLevelNew,
			PriceListID
			<cfif isDefined("Record.SendShipmentConfirmation")>
				,SendShipmentConfirmation
			</cfif>
			<cfif isDefined("Record.ShippingAndTax")>
				,ShippingAndTax
			</cfif>
			<cfif isDefined("Record.PriceListAccess")>
				,PriceListAccess
			</cfif>
			<cfif isDefined("Record.GarageSaleAccess")>
				,GarageSaleAccess
			</cfif>
			<cfif isDefined("Record.IntelIDNumber")>
				,IntelIDNumber
			</cfif>			
			<cfif isDefined("Record.PhoneNumber")>
				,PhoneNumber
			</cfif>			
			<cfif isDefined("Record.FreightEstimator")>
				,FreightEstimator
			</cfif>
			<cfif isDefined("Record.UseClassifications")>
				,UseClassifications
			</cfif>
			<cfif isDefined("Record.DefaultAccount")>
				,DefaultAccount
			</cfif>
		)
		VALUES
		(
			'#CustomerID#',
			'#Record.username#',
			'#Record.passcode#',
			'#Record.acctno#',
			'#Record.company#',
			'#Record.firstname#',
			'#Record.lastname#',
			'#Record.email#',
			'#Record.salesrepid#',
			'#Record.pointssystem#',
			'#Record.pointsnotebook#',
			'#Record.pointsserver#',
			'#Record.accesslevel#',
			'#Record.AccessLevelNew#',
			'#Record.PriceListID#'
			<cfif isDefined("Record.SendShipmentConfirmation")>
				,'#Record.SendShipmentConfirmation#'
			</cfif>
			<cfif isDefined("Record.ShippingAndTax")>
				,'#Record.ShippingAndTax#'
			</cfif>
			<cfif isDefined("Record.PriceListAccess")>
				,'#Record.PriceListAccess#'
			</cfif>
			<cfif isDefined("Record.GarageSaleAccess")>
				,'#Record.GarageSaleAccess#'
			</cfif>
			<cfif isDefined("Record.IntelIDNumber")>
				,'#Record.IntelIDNumber#'
			</cfif>
			<cfif isDefined("Record.PhoneNumber")>
				,'#Record.PhoneNumber#'
			</cfif>
			<cfif isDefined("Record.FreightEstimator")>
				,'#Record.FreightEstimator#'
			</cfif>
			<cfif isDefined("Record.UseClassifications")>
				,'#Record.UseClassifications#'
			</cfif>
			<cfif isDefined("Record.DefaultAccount")>
				,'#Record.DefaultAccount#'
			</cfif>
		)
		;
		</cfquery>

		<cfreturn CustomerID>
		
	</cffunction>
<!--- updateRecord() --->
	<cffunction name="updateRecord" access="public" output="no" returntype="any">
		<cfargument name="Record" type="struct" required="yes" />
		<cfset var CustomerID = "">

		<cfif Arguments.Record.CustomerID IS "">
			<cfset Arguments.Record.CustomerID = createUUID()>
		</cfif>

		<cfif Record.DateEmailSent IS NOT "">
			<cfset FormattedDate = dateFormat(Record.DateEmailSent, 'mm/dd/yyyy') & " " & timeFormat(Record.DateEmailSent, 'h:mm tt')>
		<cfelse>
			<cfset FormattedDate = "">
		</cfif>

		<cfquery name="qUpdateRecord" datasource="#THIS.DSN_WWW#">
		UPDATE
			#THIS.TableName#
		SET
			CustomerID = '#Record.CustomerID#',
			username = '#Record.username#',
			passcode = '#Record.passcode#',
			acctno = '#Record.acctno#',
			company = '#Record.company#',
			firstname = '#Record.firstname#',
			lastname = '#Record.lastname#',
			email = '#Record.email#',
			salesrepid = #Record.salesrepid#,
			pointssystem = '#Record.pointssystem#',
			pointsnotebook = '#Record.pointsnotebook#',
			pointsserver = '#Record.pointsserver#',
			accesslevel = '#Record.accesslevel#',
			AccessLevelNew = '#Record.AccessLevelNew#',
			<cfif isDate(FormattedDate)>
				DateEmailSent = '#FormattedDate#',
			</cfif>
			<cfif isDefined("Record.SendShipmentConfirmation")>
				SendShipmentConfirmation = #Record.SendShipmentConfirmation#,
			</cfif>
			<cfif isDefined("Record.ShippingAndTax")>
				ShippingAndTax = #Record.ShippingAndTax#,
			</cfif>
			<cfif isDefined("Record.FreightEstimator")>
				FreightEstimator = #Record.FreightEstimator#,
			</cfif>
			<cfif isDefined("Record.UseClassifications")>
				UseClassifications = #Record.UseClassifications#,
			</cfif>
			active = #Record.active#,
			PriceListID = '#Record.PriceListID#',
			PriceListAccess = '#Record.PriceListAccess#',
			GarageSaleAccess = '#Record.GarageSaleAccess#',
			IntelIDNumber = '#Record.IntelIDNumber#',
			PhoneNumber = '#Record.PhoneNumber#'
            
            
			<cfif isDefined("Record.DefaultAccount")>
				,DefaultAccount = #Record.DefaultAccount#
			</cfif>
            
		WHERE
			#THIS.PriKey# = '#Record.ID#'
		;
		</cfquery>
		<cfset CustomerID = Record.CustomerID>
		<cfreturn CustomerID>
		
	</cffunction>
<!--- getSalesReps() --->
	<cffunction name="getSalesReps" access="public" output="no" returntype="query">
		
		<cfquery name="qGetSalesReps" datasource="#THIS.DSN_WWW#">
		SELECT
			ID,
			RepName
		FROM
			salesrep
		ORDER BY
			RepName ASC
		;
		</cfquery>
		
		<cfreturn qGetSalesReps />
	</cffunction>
<!--- createPasswd() --->
	<cffunction name="createPasswd" access="public" output="no" returntype="string">
		<cfargument name="PassLength" type="numeric" required="no" default="6" />
		
		<cfset var passwd = "">
		<cfset var set1 = "a,b,c,d,e,f,g,h,i,j,k,m,n,p,q,r,s,t,w,x,y,z">
		<cfset var set2 = "A,B,C,D,E,F,G,H,J,K,L,M,N,P,Q,R,S,T,W,X,Y,Z">
		<cfset var set3 = "1,2,3,4,5,6,7,8,9">
		
		<cfloop from="1" to="#ARGUMENTS.Passlength#" index="x">
			<cfset r = Randomize(RandRange(1,9999))>
			<cfset currSet = RandRange(1,3)>
			<cfset currChar = RandRange(1,ListLen(evaluate("set#currSet#")))>
			<cfset passChar = ListGetAt(evaluate("set#currSet#"), currChar)>
			<cfset passwd = passwd & passChar>
		</cfloop>
		
		<cfreturn passwd />
	</cffunction>
<!--- isEmail() --->
	<cffunction name="isEmail" access="public" output="no" returntype="numeric">
		<cfargument name="Email" type="string" required="yes" />
		
		<cfset var isEmail = 0>
		<cfif REFindNocase("^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.(([a-z]{2,3})|(aero|coop|info|museum|name))$", Email)>
			<cfset isEmail = 1>
		</cfif>
		
		<cfreturn isEmail />
	</cffunction>
<!--- getIncompleteAccounts() --->
	<cffunction name="getIncompleteAccounts" access="public" output="no" returntype="query">
		<cfargument name="sortby" type="string" required="no" default="FirstName" />
		<cfargument name="ascdesc" type="string" required="no" default="ASC" />

		<cfquery name="qSearchRecords" datasource="#THIS.DSN_WWW#">
		SELECT
			#THIS.ColumnNames#
		FROM
			#THIS.TableName#
		WHERE
			(FirstName IS NULL OR FirstName = '')
			<cfif SESSION.Role IS "Sales Rep">
				AND salesrepID = #SESSION.SalesRepID#
			</cfif>
		ORDER BY
			#ARGUMENTS.SortBy# #AscDesc#
		;
		</cfquery>
		
		<cfreturn qSearchRecords />
	</cffunction>

	<cffunction name="userNameTaken" access="public" output="no" returntype="numeric">
		<cfargument name="Username" type="string" required="yes">
		<cfargument name="ID" type="string" required="yes">
		<cfset InUseID = 0>
		
		<cfquery name="qryCustomers" datasource="#THIS.DSN_WWW#">
		SELECT
			#THIS.ColumnNames#
		FROM
			#THIS.TableName#
		WHERE
			username = '#Arguments.Username#'
			<cfif Arguments.ID IS NOT "">
				AND ID <> #Arguments.ID#
			</cfif> 
		;
		</cfquery>
		<cfif qryCustomers.RecordCount GT 0>
			<cfset InUseID = qryCustomers.ID>
		</cfif>
		
		<cfreturn InUseID>
	</cffunction>

	<!---------------------------------------------------------------------------------------------------------->
	<cffunction name="DeleteCustomer" access="public" output="No" returntype="numeric">
	<cfargument name="RecordID" type="string" required="Yes">
	    <cfset var DeleteCustomer = 1>
<!---        
    	<cfset var DeleteError = "">
--->        
        <cfset var qryLogin = queryNew("")>
        <cfset var qryQuoteSystem = queryNew("")>
        <cfset var qryLogin2 = queryNew("")>
        <cfset var qryLogin_Others = queryNew("")>


		<cfquery name="qryLogin" datasource="#THIS.DSN_WWW#">
		SELECT	CustomerID, acctno, salesrepID, DefaultAccount
		FROM	login
		WHERE	ID = '#Arguments.RecordID#'
		</cfquery>

        <cfif qryLogin.RecordCount NEQ 0>

            <!--- Get all of the quotes for this customer --->
            <cfquery name="qryQuoteSystem" datasource="#THIS.DSN_WWW#">
            SELECT	QuoteSystemID
            FROM	tblQuoteSystem
            WHERE	CustomerID = '#qryLogin.CustomerID#'
            </cfquery>
    
            <!--- if this customer has quotes entered --->
            <cfif qryQuoteSystem.RecordCount NEQ 0>

				<!--- Is there a default customer? --->
                <cfquery name="qryLogin2" datasource="#THIS.DSN_WWW#">
                SELECT	CustomerID
                FROM	login
                WHERE	acctno = '#trim(qryLogin.acctno)#' AND
                        salesrepID = '#trim(qryLogin.salesrepID)#' AND
                        CustomerID <> '#qryLogin.CustomerID#' AND
                        DefaultAccount = 1
                </cfquery>
				<!--- One other default account was found.  Reassign the quotes --->
                <cfif qryLogin2.RecordCount EQ 1>
                
                    <cfquery datasource="#THIS.DSN_WWW#">
                    UPDATE	tblQuoteSystem
                    SET		CustomerID = '#qryLogin2.CustomerID#'
                    WHERE	CustomerID = '#qryLogin.CustomerID#'
                    </cfquery>

				<!--- More than one default account was found (for some reason: shouldn't happen --->
                <cfelseif qryLogin2.RecordCount GT 1>
                    <cfset DeleteCustomer = 3>

				<cfelse>
                
					<!--- Are there any others under this AcctNo? --->
                    <cfquery name="qryLogin_Others" datasource="#THIS.DSN_WWW#">
                    SELECT	CustomerID
                    FROM	login
                    WHERE	acctno = '#trim(qryLogin.acctno)#' AND
                            salesrepID = '#trim(qryLogin.salesrepID)#' AND
                            CustomerID <> '#qryLogin.CustomerID#' 
                    </cfquery>
                    
					<cfif qryLogin_Others.RecordCount NEQ 0>
                        <cfset DeleteCustomer = 4>

					<!--- Delete all of the quotes assigned to this customer --->
                    <cfelse>

                        <cfquery datasource="#THIS.DSN_WWW#">
                        DELETE FROM 	tblQuoteSystem
                        WHERE			CustomerID = '#qryLogin.CustomerID#'
                        </cfquery>
                    
                    </cfif>
                </cfif>
            </cfif>
		</cfif>
    
    	<cfif DeleteCustomer EQ 1>
            <cfquery datasource="#THIS.DSN_WWW#">
                DELETE FROM 	#This.TableName#
                WHERE			#THIS.PriKey# = '#Arguments.RecordID#'
            </cfquery>
        </cfif>
        
        <cfreturn DeleteCustomer>
	</cffunction>

	<!---------------------------------------------------------------------------------------------------------->
	<cffunction name="getCustomersForSalesRep" access="public" output="no" returntype="query">
	<cfargument name="SalesRepID" required="yes" type="string">
		<cfquery name="qryLogin" datasource="#THIS.DSN_WWW#">
			SELECT	*
			FROM	#THIS.TableName#
			WHERE	salesrepID = '#ARGUMENTS.SalesRepID#'
		</cfquery>
		<cfreturn qryLogin>
	</cffunction>

	<!---------------------------------------------------------------------------------------------------------->
	<cffunction name="setFreightEstimator" access="public" returntype="string" output="no">
	<cfargument name="Record" required="yes" type="struct">
    	<cfset var Result = "">
        <cfset var lstRecord = "">
        <cfset var Column = "">
        <cfset var CustomerID = "">

		<cfif structKeyExists(Arguments.Record, "FreightEstimatorFunction")>
        
			<cfif Arguments.Record.FreightEstimatorFunction IS "Pick">
            	<cfset lstRecord = structKeyList(Arguments.Record)>
                <cfloop list="#lstRecord#" index="Column">
                	<cfif findNoCase("RESELLER|", Column) NEQ 0>
                    	<cfset CustomerID = removeChars(Column, 1, 9)>
                        <cfquery datasource="#THIS.DSN_WWW#">
                            UPDATE	login
                            SET		FreightEstimator = 1
                            WHERE	CustomerID = '#CustomerID#'
                        </cfquery>
		                <cfset Result = "TurnedOnPick">
                    </cfif>
                </cfloop>
            
            <cfelseif Arguments.Record.FreightEstimatorFunction IS "TurnOn">
                <cfquery datasource="#THIS.DSN_WWW#">
                    UPDATE	login
                    SET		FreightEstimator = 1
                    WHERE	salesrepID = #SESSION.SalesRepID#
                </cfquery>
                <cfset Result = "TurnedOn">

            <cfelseif Arguments.Record.FreightEstimatorFunction IS "TurnOff">
                <cfquery datasource="#THIS.DSN_WWW#">
                    UPDATE	login
                    SET		FreightEstimator = 0
                    WHERE	salesrepID = #SESSION.SalesRepID#
                </cfquery>
                <cfset Result = "TurnedOff">
            </cfif>
        <cfelse>
			<cfset Result = "NoActionTaken">
        </cfif>
        
		<cfreturn Result>
	</cffunction>

	<!----------------------------------------------------------------------------------------------------------->
	<cffunction name="customerUsesClassifications" access="public" output="no" returntype="boolean">
		<cfargument name="ID" type="string" required="yes">
        <cfset var customerUsesClassifications = 0>
        <cfset var qry_login = queryNew("")>
		<cfquery name="qry_login" datasource="#THIS.DSN_WWW#">
		SELECT	UseClassifications
		FROM	login
		WHERE	ID = '#Arguments.ID#'
		</cfquery>
        <cfif qry_login.RecordCount NEQ 0>
        	<cfset customerUsesClassifications = qry_login.UseClassifications>
        </cfif>
		<cfreturn customerUsesClassifications>
	</cffunction>

	<!----------------------------------------------------------------------------------------------------------->
	<cffunction name="setDefaultAccount" access="public" output="no">
		<cfargument name="CustomerID" type="string" required="yes">
        <cfset var qry_login = queryNew("")>

		<cfquery name="qry_login" datasource="#THIS.DSN_WWW#">
		SELECT	DefaultAccount, acctno, salesrepID
		FROM	login
		WHERE	CustomerID = '#Arguments.CustomerID#'
		</cfquery>
        
        <cfif qry_login.RecordCount NEQ 0 AND qry_login.DefaultAccount EQ 1>
            <cfquery datasource="#THIS.DSN_WWW#">
            UPDATE	login
            SET 	DefaultAccount = 0
            WHERE	acctno = '#trim(qry_login.acctno)#' AND
		            salesrepID = '#trim(qry_login.salesrepID)#' AND
		            CustomerID <> '#Arguments.CustomerID#'
            </cfquery>
        </cfif>

	</cffunction>









	<!----------------------------------------------------------------------------------------------------------->
	<cffunction name="getCustomerMarkupPercent" access="public" returntype="string" output="no">
        <cfargument name="loginID" type="string" required="yes">
        <cfargument name="PriceListCategoryID" type="string" required="yes">
	
       	<cfset var CustomerMarkupPercent = "">
        <cfset var qry_loginCategories = queryNew("")>

		<cfquery name="qry_loginCategories" datasource="#THIS.DSN_WWW#">
		SELECT	MarkupPercent
		FROM	loginCategories
		WHERE	ID = '#Arguments.loginID#' AND
        		PriceListCategoryID = '#Arguments.PriceListCategoryID#'
		</cfquery>
        <cfif qry_loginCategories.RecordCount NEQ 0>
			<cfset CustomerMarkupPercent = qry_loginCategories.MarkupPercent>
        </cfif>

		<cfreturn CustomerMarkupPercent>
	</cffunction>


	<!----------------------------------------------------------------------------------------------------------------------->
	<cffunction name="saveMarkupPercent" access="public" returntype="string" output="no">
        <cfargument name="Record" type="struct" required="Yes">

		<cfset var PriceListCategoryID = "">
		<cfset var stRecord = Arguments.Record>
		<cfset var lstRecord = structKeyList(stRecord)>
		<cfset var Column = "">
		<cfset var ColumnValue = "">
		<cfset var MarkupPercentField = "">
		<cfset var MarkupPercent = 0>
        
        <cfset var qry_loginCategories = queryNew("")>

		<cfloop list="#lstRecord#" index="Column">
			<cfif findNoCase("UPDATE|", Column) NEQ 0>
				<cfset ColumnValue = stRecord[Column]>
				<cfif ColumnValue IS "1">
					<cfset PriceListCategoryID = removeChars(Column, 1, 7)>
                    <cfset MarkupPercentField = "PCT|" & PriceListCategoryID>
                    <cfset MarkupPercent = stRecord[MarkupPercentField]>
					<cfbreak>
				</cfif>
			</cfif>
		</cfloop>
<!---
PriceListCategoryID:<cfdump var="#PriceListCategoryID#"><br>
stRecord.ID:<cfdump var="#stRecord.ID#"><br>
MarkupPercent:<cfdump var="#MarkupPercent#"><br>
--->
		<cfif trim(MarkupPercent) IS "">
        
        	<cfif getCustomerMarkupPercent(stRecord.ID, PriceListCategoryID) IS NOT "">
                <cfquery datasource="#THIS.DSN_WWW#">
                DELETE FROM loginCategories
                WHERE	ID = '#stRecord.ID#' AND
                        PriceListCategoryID = '#PriceListCategoryID#'
                </cfquery>
				<cfset PriceListCategoryID = "REMOVED|" & PriceListCategoryID>
            <cfelse>
				<cfset PriceListCategoryID = "ERROR|BLANK_PCNTG|" & PriceListCategoryID>
            </cfif>

		<cfelseif NOT isNumeric(MarkupPercent) OR MarkupPercent LT 0>
            <cfset PriceListCategoryID = "ERROR|MRKUP_PCNTG|" & PriceListCategoryID>

		<cfelse>
        
            <cfquery name="qry_loginCategories" datasource="#THIS.DSN_WWW#">
            SELECT	loginCategoryID
            FROM	loginCategories
            WHERE	ID = '#stRecord.ID#' AND
                    PriceListCategoryID = '#PriceListCategoryID#'
            </cfquery>
            <cfif qry_loginCategories.RecordCount NEQ 0>
                <cfquery datasource="#THIS.DSN_WWW#">
                UPDATE 	loginCategories
                SET		MarkupPercent = #MarkupPercent#
                WHERE 	loginCategoryID = '#qry_loginCategories.loginCategoryID#'
                </cfquery>
            
            <cfelse>
                
                <cfquery datasource="#THIS.DSN_WWW#">
                INSERT INTO	loginCategories (
                    loginCategoryID,
                    ID,
                    PriceListCategoryID,
                    MarkupPercent)
                VALUES (
                    '#createUUID()#',
                    '#stRecord.ID#',
                    '#PriceListCategoryID#',
                    #MarkupPercent#)	
                </cfquery>
            </cfif>

        </cfif>

		<cfreturn PriceListCategoryID>
	</cffunction>

	<!----------------------------------------------------------------------------------------------------------->
	<cffunction name="getCategoryDescription" access="public" returntype="string" output="no">
        <cfargument name="PriceListCategoryID" type="string" required="yes">
	
       	<cfset var CategoryDescription = "">
        <cfset var qryPriceListCategories = queryNew("")>

		<cfquery name="qryPriceListCategories" datasource="#THIS.DSN_WWW#">
		SELECT	CategoryDescription
		FROM	tblPriceListCategories
		WHERE	PriceListCategoryID = '#Arguments.PriceListCategoryID#'
		</cfquery>
        <cfif qryPriceListCategories.RecordCount NEQ 0>
			<cfset CategoryDescription = qryPriceListCategories.CategoryDescription>
        </cfif>

		<cfreturn CategoryDescription>
	</cffunction>




    
	<!----------------------------------------------------------------------------------------------------------->
	<cffunction name="getCustomerSellPrice" access="public" returntype="numeric" output="no">
        <cfargument name="loginID" type="string" required="yes">
        <cfargument name="PriceListComponentID" type="string" required="yes">
    	
        <cfset var CustomerSellingPrice = 0>
        <cfset var qry_loginPrices = queryNew("")>
        <cfset var qry_login = queryNew("")>
        <cfset var qryPriceListComponents = queryNew("")>

		<cfset var SellingPrice = "">
        <cfset var MarkupPercent = "">
        <cfset var strLogin = structNew()>
        
		<cfset objLogin = createObject("component", "admin.assets.cfcs.Cust")>

		<cfset SellingPrice =  getCustomerFixedPrice(Arguments.loginID, Arguments.PriceListComponentID)>
        

        <cfquery name="qryPriceListComponents" datasource="#THIS.DSN_WWW#">
        SELECT	PriceListCategoryID, SellPrice
        FROM	tblPriceListComponents
        WHERE	PriceListComponentID = '#Arguments.PriceListComponentID#' 
        </cfquery>

		<cfset strLogin = objLogin.getRecordAsStruct(Arguments.loginID)>
        
        <!--- Try to get the markup percentage for this category --->
        <cfif SellingPrice IS "">
        
            <cfset MarkupPercent = getCustomerMarkupPercent(Arguments.loginID, qryPriceListComponents.PriceListCategoryID)>
            <cfif isNumeric(MarkupPercent)>
                <cfif strLogin.MarkupType IS "Margin">
                    <cfset SellingPrice = ceiling(qryPriceListComponents.SellPrice / (1 - MarkupPercent/100))>
                <cfelse>
                    <cfset SellingPrice = ceiling(qryPriceListComponents.SellPrice + qryPriceListComponents.SellPrice * MarkupPercent/100)>
                </cfif>
            </cfif>
        </cfif>
        
        <!--- Mark up the price based on Component markup percentage --->
        <cfif SellingPrice IS "">
        	<cfif NOT isNumeric(strLogin.PercentComponents)>
            	<cfset strLogin.PercentComponents = 0>
            </cfif>
        
            <cfif strLogin.MarkupType IS "Margin">
                <cfset SellingPrice = ceiling(qryPriceListComponents.SellPrice / (1 - strLogin.PercentComponents))>
            <cfelse>
                <cfset SellingPrice = ceiling(qryPriceListComponents.SellPrice + qryPriceListComponents.SellPrice * strLogin.PercentComponents)>
            </cfif>
        </cfif>
        
        <cfset CustomerSellingPrice = SellingPrice>
        


<!---
		<cfquery name="qry_loginPrices" datasource="#THIS.DSN_WWW#">
		SELECT	SellPrice
		FROM	loginPrices
		WHERE	ID = '#Arguments.loginID#' AND
        		PriceListComponentID = '#Arguments.PriceListComponentID#'
		</cfquery>
        <cfif qry_loginPrices.RecordCount NEQ 0>
			<cfset CustomerSellingPrice = qry_loginPrices.SellPrice>
        <cfelse>
            <cfquery name="qry_login" datasource="#THIS.DSN_WWW#">
            SELECT	MarkupType, PercentComponents
            FROM	login
            WHERE	ID = '#Arguments.loginID#' 
            </cfquery>

            <cfquery name="qryPriceListComponents" datasource="#THIS.DSN_WWW#">
            SELECT	SellPrice
            FROM	tblPriceListComponents
            WHERE	PriceListComponentID = '#Arguments.PriceListComponentID#' 
            </cfquery>
        
			<cfif qry_login.MarkupType IS "Margin">
                <cfset CustomerSellingPrice = ceiling(qryPriceListComponents.SellPrice / (1 - qry_login.PercentComponents))>
            <cfelse>
                <cfset CustomerSellingPrice = ceiling(qryPriceListComponents.SellPrice + qryPriceListComponents.SellPrice * qry_login.PercentComponents)>
            </cfif>
        </cfif>
--->




		<cfreturn CustomerSellingPrice>
	</cffunction>

	<!----------------------------------------------------------------------------------------------------------->
	<cffunction name="getCustomerFixedPrice" access="public" returntype="string" output="no">
        <cfargument name="loginID" type="string" required="yes">
        <cfargument name="PriceListComponentID" type="string" required="yes">
	
       	<cfset var CustomerFixedPrice = "">
        <cfset var qry_loginPrices = queryNew("")>

		<cfquery name="qry_loginPrices" datasource="#THIS.DSN_WWW#">
		SELECT	SellPrice
		FROM	loginPrices
		WHERE	ID = '#Arguments.loginID#' AND
        		PriceListComponentID = '#Arguments.PriceListComponentID#'
		</cfquery>
        <cfif qry_loginPrices.RecordCount NEQ 0>
			<cfset CustomerFixedPrice = qry_loginPrices.SellPrice>
        </cfif>

		<cfreturn CustomerFixedPrice>
	</cffunction>

	<!----------------------------------------------------------------------------------------------------------------------->
	<cffunction name="saveFixedPrice" access="public" returntype="string" output="no">
        <cfargument name="Record" type="struct" required="Yes">

		<cfset var PriceListComponentID = "">
		<cfset var stRecord = Arguments.Record>
		<cfset var lstRecord = structKeyList(stRecord)>
		<cfset var Column = "">
		<cfset var ColumnValue = "">
		<cfset var FixedPriceField = "">
		<cfset var FixedPrice = 0>
        <cfset var qry_loginPrices = queryNew("")>

		<cfloop list="#lstRecord#" index="Column">
			<cfif findNoCase("UPDATE|", Column) NEQ 0>
				<cfset ColumnValue = stRecord[Column]>
				<cfif ColumnValue IS "1">
					<cfset PriceListComponentID = removeChars(Column, 1, 7)>
                    
                    <cfset FixedPriceField = "FIX|" & PriceListComponentID>
                    <cfset FixedPrice = stRecord[FixedPriceField]>
                    
					<cfbreak>
				</cfif>
			</cfif>
		</cfloop>
<!---
PriceListComponentID:<cfdump var="#PriceListComponentID#"><br>
stRecord.ID:<cfdump var="#stRecord.ID#"><br>
FixedPrice:<cfdump var="#FixedPrice#"><br>
--->
		<cfif trim(FixedPrice) IS "">
        
        	<cfif getCustomerFixedPrice(stRecord.ID, PriceListComponentID) IS NOT "">
                <cfquery datasource="#THIS.DSN_WWW#">
                DELETE FROM loginPrices
                WHERE	ID = '#stRecord.ID#' AND
                        PriceListComponentID = '#PriceListComponentID#'
                </cfquery>
				<cfset PriceListComponentID = "REMOVED|" & PriceListComponentID>
            <cfelse>
				<cfset PriceListComponentID = "ERROR|BLANK_PRICE|" & PriceListComponentID>
            </cfif>

		<cfelseif NOT isNumeric(FixedPrice) OR FixedPrice LT 0>
            <cfset PriceListComponentID = "ERROR|FIXED_PRICE|" & PriceListComponentID>

		<cfelse>
        
            <cfquery name="qry_loginPrices" datasource="#THIS.DSN_WWW#">
            SELECT	loginPriceID
            FROM	loginPrices
            WHERE	ID = '#stRecord.ID#' AND
                    PriceListComponentID = '#PriceListComponentID#'
            </cfquery>
            <cfif qry_loginPrices.RecordCount NEQ 0>
                <cfquery datasource="#THIS.DSN_WWW#">
                UPDATE 	loginPrices
                SET		SellPrice = #FixedPrice#
                WHERE 	loginPriceID = '#qry_loginPrices.loginPriceID#'
                </cfquery>
            
            <cfelse>
                
                <cfquery datasource="#THIS.DSN_WWW#">
                INSERT INTO	loginPrices (
                    loginPriceID,
                    ID,
                    PriceListComponentID,
                    SellPrice)
                VALUES (
                    '#createUUID()#',
                    '#stRecord.ID#',
                    '#PriceListComponentID#',
                    #FixedPrice#)	
                </cfquery>
            </cfif>

        </cfif>

		<cfreturn PriceListComponentID>
	</cffunction>


</cfcomponent>