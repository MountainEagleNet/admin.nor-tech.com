<cfcomponent displayname="Orders" hint="I handle AccPac Order retreival">
	<cfset THIS.DSN = APPLICATION.DSN_AP>
<!---<cfset THIS.DSN = "nortechAP">	--->
	

	<!------------------------------------------------------------------------------------------------------>
	<!--- getCustOrders() --->
	<cffunction name="getCustOrders" access="public" returntype="query" output="yes">
		<cfargument name="AcctNo" type="string" required="yes" />
		<cfargument name="OrderBy" type="string" required="no" default="InvNumber"/>
		<cfargument name="AscDesc" type="string" required="no" default="ASC"/>
		<cfquery name="qGetCustOrders" datasource="#THIS.DSN#">
		SELECT	InvUniq,
                OrdNumber,
                OrdDate,
                rtrim(PONumber) AS PONumber,
                InvNumber,
                rtrim(ShipTrack) AS ShipTrack,
                ShipVia
		FROM	dbo.OEINVH
		WHERE	Customer = '#ARGUMENTS.AcctNo#'
		ORDER BY #ARGUMENTS.OrderBy# #ARGUMENTS.AscDesc#
		;
		</cfquery>
		<cfreturn qGetCustOrders />
	</cffunction>
    
	<!------------------------------------------------------------------------------------------------------>
	<cffunction name="orderContainsMC0010" access="public" returntype="boolean" output="yes">
	<cfargument name="INVUNIQ" type="numeric" required="yes" />
		<cfset var orderContainsMC0010 = 0>
		<cfset var qryOEINVD = queryNew("")>        
		<cfquery name="qryOEINVD" datasource="#THIS.DSN#">
		SELECT	INVUNIQ
		FROM	dbo.OEINVD
		WHERE	INVUNIQ = '#ARGUMENTS.INVUNIQ#' AND
        		ITEM = 'MC0010'
		</cfquery>
		<cfif qryOEINVD.RecordCount NEQ 0>
			<cfset orderContainsMC0010 = 1>
        </cfif>
        <cfreturn orderContainsMC0010>
	</cffunction>

	<!------------------------------------------------------------------------------------------------------>
	<cffunction name="getCustomerName" access="public" returntype="string" output="yes">
	<cfargument name="AcctNo" type="string" required="yes" />
		<cfset var CustomerName = "">
		<cfset var qry_login = queryNew("")> 
        
		<cfquery name="qry_login" datasource="#APPLICATION.DSN_WWW#">
		SELECT	company, AcctNo
		FROM	login
		WHERE	AcctNo = '#Arguments.AcctNo#' 
		</cfquery>
		<cfif qry_login.RecordCount NEQ 0>
			<cfset CustomerName = qry_login.company & ", Account Number " & qry_login.AcctNo>
		<cfelse>
			<cfset CustomerName = "[unknown]">
        </cfif>
        <cfreturn CustomerName>
	</cffunction>

    
	<!------------------------------------------------------------------------------------------------------>
	<!--- dateFix() --->
	<cffunction name="dateFix" access="public" returntype="string" output="No">
		<cfargument name="theDate" type="string" required="yes" />
		
		<cfset var dateFormatted = "">
		<cfset var varMonth = left(right(ARGUMENTS.theDate, 4), 2)>
		<cfset var varDay = right(ARGUMENTS.theDate, 2)>
		<cfset var varYear = left(ARGUMENTS.theDate, 4)>
		
		<cftry>
			<cfset dateFormatted = DateFormat("#varMonth#/#varDay#/#varYear#", "mm/dd/yyyy")>
			<cfcatch>
				<cfset dateFormatted = "">
			</cfcatch>
		</cftry>
		
		<cfreturn dateFormatted />
	</cffunction>
<!--- dateFix() --->

	<!------------------------------------------------------------------------------------------------------>
	<cffunction name="dateUnFix" access="public" returntype="string" output="No">
		<cfargument name="theDate" type="string" required="yes" />
		
		<cftry>
			<cfset dateFormatted = DateFormat(ARGUMENTS.theDate, "YYYYMMDD")>
			<cfcatch>
				<cfset dateFormatted = 0>
			</cfcatch>
		</cftry>
		
		<cfreturn dateFormatted />
	</cffunction>
    
	<!------------------------------------------------------------------------------------------------------>
<!--- getInvoiceMain() --->
	<cffunction name="getInvoiceMain" access="public" returntype="query" output="No">
		<cfargument name="InvUniq" type="numeric" required="yes" />
		
		<cfquery name="qGetInvoiceMain" datasource="#THIS.DSN#">
		SELECT
			InvUniq,
			<!--- general details --->
			rtrim(Customer) AS customer,rtrim(PONumber) AS PONumber,rtrim(InvNumber) AS InvNumber,rtrim(InvDate) AS InvDate,rtrim(OrdNumber) AS OrdNumber,rtrim(SHINUMBER) AS SHINUMBER,rtrim(OrdDate) AS OrdDate,rtrim(ShipDate) AS ShipDate,rtrim(InvWeight) AS InvWeight,rtrim(ShipTrack) AS ShipTrack,rtrim(ShipVia) AS ShipVia,rtrim(ViaDesc) AS ViaDesc,rtrim(Terms) AS Terms,rtrim(SalesPer1) AS SalesPer1,
			<!--- billing to --->
			rtrim(BilName) AS BilName,rtrim(BilAddr1) AS BilAddr1,rtrim(BilAddr2) AS BilAddr2,rtrim(BilAddr3) AS BilAddr3,rtrim(BilAddr4) AS BilAddr4,rtrim(BilCity) AS BilCity,rtrim(BilState) AS BilState,rtrim(BilZip) AS BilZip,rtrim(BilCountry) AS BilCountry,rtrim(BilPhone) AS BilPhone,rtrim(BilFax) AS BilFax,rtrim(BilContact) AS BilContact,
			<!--- ship to --->
			rtrim(ShipTo) AS ShipTo,rtrim(ShpName) AS ShpName,rtrim(ShpAddr1) AS ShpAddr1,rtrim(ShpAddr2) AS ShpAddr2,rtrim(ShpAddr3) AS ShpAddr3,rtrim(ShpAddr4) AS ShpAddr4,rtrim(ShpCity) AS ShpCity,rtrim(ShpState) AS ShpState,rtrim(ShpZip) AS ShpZip,rtrim(ShpCountry) AS ShpCountry,rtrim(ShpPhone) AS ShpPhone,rtrim(ShpFax) AS ShpFax,rtrim(ShpContact) AS ShpContact
		FROM
			dbo.OEINVH
		WHERE
			InvUniq = #ARGUMENTS.InvUniq#
		;
		</cfquery>
		
		<cfreturn qGetInvoiceMain />
	</cffunction>
    
	<!------------------------------------------------------------------------------------------------------>
<!--- getInvoiceDetails() --->
	<cffunction name="getInvoiceDetails" access="public" returntype="query" output="No">
		<cfargument name="InvUniq" type="numeric" required="yes" />
		<cfargument name="MinItemsShipped" type="numeric" required="no" />
		
		<cfquery name="qGetInvoiceDetails" datasource="#THIS.DSN#">
		SELECT
			InvUniq,
			LineNum,
			DetailNum,
			rtrim(Item) AS Item,
			rtrim("Desc") AS "Desc",
			QtyOrdered,
			QtyShipped,
			QtyBackOrd,
			UnitCost,
			UnitPrice,
			ExtInvMisc,
			<!--- (UnitPrice + ExtInvMisc) AS ItemPrice, --->
			(UnitPrice) AS ItemPrice,
			InvDisc,
			MiscCharge,
<!---            
			MiscAcct,
			HaveSerial,
--->            
			rtrim(ManItemNo) AS ManItemNo,
			InvUnit,
	  <!--- CASE WHEN QtyShipped <> 0 THEN (QtyShipped * (UnitPrice + ExtInvMisc)) ELSE (UnitPrice + ExtInvMisc) END AS TotalPriceForLine --->
<!---		CASE WHEN QtyShipped <> 0 THEN (QtyShipped * (UnitPrice)) ELSE (UnitPrice) END AS TotalPriceForLine--->
			CASE WHEN QtyShipped <> 0 THEN (QtyShipped * (UnitPrice)) ELSE (0) END AS TotalPriceForLine
			
		FROM
			dbo.OEINVD
		WHERE
			InvUniq = #ARGUMENTS.InvUniq#
			<cfif IsDefined("ARGUMENTS.MinItemsShipped")>
				 AND
				QtyShipped >= #ARGUMENTS.MinItemsShipped#
			</cfif>
		;
		</cfquery>
		
		<cfreturn qGetInvoiceDetails />
	</cffunction>
    
    
<!--- splitInvUniqLineNum() --->
<!--- returns pair sep by comma --->
	<cffunction name="splitInvUniqLineNum" access="private" returntype="array" output="no">
		<cfargument name="valuePair" type="string" required="yes" />
		
		<cfset var returnPair = replace(ARGUMENTS.valuePair, "-", chr(44))>
		
		<cfset returnArray = ListToArray(returnPair)>
		
		<cfreturn returnArray />
	</cffunction>
    
    
<!--- getInvLineDetail() --->
	<cffunction name="getInvLineDetail" access="public" returntype="query" output="no">
		<cfargument name="valuePair" type="string" required="yes">
		
		<cfset var commaPair = splitInvUniqLineNum(ARGUMENTS.valuePair)>
		
		<cfset InvUniq = commaPair[1]>
		<cfset LineNum = commaPair[2]>
		
		<cfquery name="qGetInvLineDetail" datasource="#THIS.DSN#">
		SELECT
			dbo.OEINVD.QtyShipped,
			dbo.OEINVD.LineNum,
			rtrim(dbo.OEINVD.Item) AS Item,
			dbo.OEINVH.InvNumber
		FROM
			dbo.OEINVD,
			dbo.OEINVH
		WHERE
			dbo.OEINVD.InvUniq = #InvUniq#
			 AND
			dbo.OEINVD.LineNum = #LineNum#
			 AND
			dbo.OEINVD.InvUniq = dbo.OEINVH.InvUniq
		;
		</cfquery>
		
		<cfreturn qGetInvLineDetail />
	</cffunction>

	<!------------------------------------------------------------------------------------------------------>	
<!--- searchCustOrders() --->
	<cffunction name="searchCustOrders" access="public" output="no" returntype="query">
		<cfargument name="IDCust" type="String" required="yes" />
		<cfargument name="searchRecord" type="struct" required="yes" />
		<cfargument name="sortby" type="string" required="no" default="InvNumber" />
		<cfargument name="ascdesc" type="string" required="no" default="ASC" />
		<cfset var qryFinal = queryNew("INVNUMBER,INVUNIQ,ORDDATE,ORDNUMBER,PONUMBER,SHIPTRACK,SHIPVIA")>
		<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>
		<cfset objOEINVH = createObject("component", "admin.assets.cfcs.OEINVH")>
		<cfset objOEINVD = createObject("component", "admin.assets.cfcs.OEINVD")>

		<!--- Serial Number Search --->
		<cfif isDefined("Arguments.searchRecord.SerialNumber") AND  trim(Arguments.searchRecord.SerialNumber) IS NOT "">

			<!--- break the date so we can search on it --->
			<cfif IsDefined("Arguments.searchRecord.OrdDate") AND isDate(Arguments.searchRecord.OrdDate)>
				<cfset Arguments.searchRecord.OrdDate = dateUnFix(Arguments.searchRecord.OrdDate)>
			</cfif>

			<cfset strSearch = structNew()>
			<cfset structInsert(strSearch, "SerialNumber", trim(Arguments.searchRecord.SerialNumber), True)>
			<cfset structInsert(strSearch, "Posted", 1, True)>
			<cfset structInsert(strSearch, "AttachedToInvoice", 1, True)>
			<cfset qrySerialsShipments = objSerialsShipments.searchRecords(strSearch, "query")>
			
			<cfloop query="qrySerialsShipments">
				<cfset AddIt = 1>
				<cfset strSearch = structNew()>
				<cfset structInsert(strSearch, "INVUNIQ", qrySerialsShipments.INVUNIQ, True)>
				<cfset qryOEINVH = objOEINVH.searchRecords(strSearch, "query")>
				<cfif qryOEINVH.RecordCount EQ 0>
					<cfset AddIt = 0>
				<cfelse>
					<cfif trim(qryOEINVH.CUSTOMER) IS NOT trim(Arguments.IDCust)>
						<cfset AddIt = 0>
					<cfelse>
						<cfif isDefined("Arguments.SearchRecord.OrdDate") AND trim(Arguments.SearchRecord.OrdDate) IS NOT "" AND
							  Arguments.SearchRecord.OrdDate IS NOT qryOEINVH.ORDDATE>
							<cfset AddIt = 0>
						<cfelseif isDefined("Arguments.SearchRecord.OrdNumber") AND trim(Arguments.SearchRecord.OrdNumber) IS NOT "" AND
							  Arguments.SearchRecord.OrdNumber IS NOT qryOEINVH.ORDNUMBER>
							<cfset AddIt = 0>
						<cfelseif isDefined("Arguments.SearchRecord.InvNumber") AND trim(Arguments.SearchRecord.InvNumber) IS NOT "" AND
							  Arguments.SearchRecord.InvNumber IS NOT qryOEINVH.INVNUMBER>
							<cfset AddIt = 0>
						<cfelseif isDefined("Arguments.SearchRecord.PONumber") AND trim(Arguments.SearchRecord.PONumber) IS NOT "" AND
							  Arguments.SearchRecord.PONumber IS NOT qryOEINVH.PONUMBER>
							<cfset AddIt = 0>
						<cfelseif isDefined("Arguments.SearchRecord.Item") AND trim(Arguments.SearchRecord.Item) IS NOT "">
							<cfset strSearch = structNew()>
							<cfset structInsert(strSearch, "INVUNIQ", qrySerialsShipments.INVUNIQ, True)>
							<cfset structInsert(strSearch, "LINENUM", qrySerialsShipments.INVLINENUM, True)>
							<cfset structInsert(strSearch, "ITEM", Arguments.SearchRecord.Item, True)>
							<cfset qryOEINVD = objOEINVD.searchRecords(strSearch, "query")>
							<cfif qryOEINVD.RecordCount EQ 0>
								<cfset AddIt = 0>
							</cfif>
						</cfif>
					</cfif>
				</cfif>

				<cfif AddIt>
					<cfset queryAddRow(qryFinal)>
					<cfset querySetCell(qryFinal, "INVNUMBER", qryOEINVH.INVNUMBER)>
					<cfset querySetCell(qryFinal, "INVUNIQ", qryOEINVH.INVUNIQ)>
					<cfset querySetCell(qryFinal, "ORDDATE", qryOEINVH.ORDDATE)>
					<cfset querySetCell(qryFinal, "ORDNUMBER", qryOEINVH.ORDNUMBER)>
					<cfset querySetCell(qryFinal, "PONUMBER", qryOEINVH.PONUMBER)>
					<cfset querySetCell(qryFinal, "SHIPTRACK", rtrim(qryOEINVH.ShipTrack))>
					<!--- RAB 10/17/2012 --->
					<cfset querySetCell(qryFinal, "SHIPVIA", qryOEINVH.SHIPVIA)>
				</cfif>
			
			</cfloop>


		<cfelse>
		
			<!--- break the date so we can search on it --->
			<cfif IsDefined("searchRecord.OrdDate") AND isDate(searchRecord.OrdDate)>
				<cfset searchRecord.OrdDate = dateUnFix(searchRecord.OrdDate)>
			</cfif>
			
			<cfquery name="qSearchCustOrders" datasource="#THIS.DSN#">
			SELECT
				a.InvUniq,
				a.OrdNumber,
				a.OrdDate,
				rtrim(a.PONumber) AS PONumber,
				a.InvNumber,
				rtrim(a.ShipTrack) AS ShipTrack
                
                <!--- RAB 10/17/2012 --->
                ,a.ShipVia
			FROM
				dbo.OEINVH a,
				dbo.OEINVD b
			WHERE
				a.InvUniq = b.InvUniq
				 AND
				Customer = '#ARGUMENTS.IDCust#'
				<cfloop collection="#searchRecord#" item="key">
					<cfif key IS NOT "SerialNumber" AND key IS NOT "AcctNo">
						 AND
						rtrim(<cfif lcase(key) EQ "item">b<cfelse>a</cfif>.#key#) LIKE '#trim(searchRecord[key])#%'
					</cfif>
				</cfloop>
				GROUP BY
					a.InvUniq,
					a.OrdNumber,
					a.OrdDate,
					a.PONumber,
					a.InvNumber,
					a.ShipTrack
               		<!--- RAB 10/17/2012 --->
					,a.ShipVia
			ORDER BY
				#ARGUMENTS.SortBy# #AscDesc#
			;
			</cfquery>
	
<!---
			<cfif isDefined("Arguments.searchRecord.SerialNumber") AND  trim(Arguments.searchRecord.SerialNumber) IS NOT "">
				<cfloop query="qSearchCustOrders">
					<cfset strSearch = structNew()>
					<cfset structInsert(strSearch, "INVUNIQ", qSearchCustOrders.INVUNIQ, True)>
					<cfset structInsert(strSearch, "SerialNumber", trim(Arguments.searchRecord.SerialNumber), True)>
					<cfset structInsert(strSearch, "Posted", 1, True)>
					<cfset qrySerialsShipments = objSerialsShipments.searchRecords(strSearch, "query")>
					<cfif qrySerialsShipments.RecordCount NEQ 0>
						<cfset queryAddRow(qryFinal)>
						<cfset querySetCell(qryFinal, "INVNUMBER", qSearchCustOrders.INVNUMBER)>
						<cfset querySetCell(qryFinal, "INVUNIQ", qSearchCustOrders.INVUNIQ)>
						<cfset querySetCell(qryFinal, "ORDDATE", qSearchCustOrders.ORDDATE)>
						<cfset querySetCell(qryFinal, "ORDNUMBER", qSearchCustOrders.ORDNUMBER)>
						<cfset querySetCell(qryFinal, "PONUMBER", qSearchCustOrders.PONUMBER)>
						<cfset querySetCell(qryFinal, "SHIPTRACK", qSearchCustOrders.SHIPTRACK)>
					</cfif>
				</cfloop>
			<cfelse>
--->
				<cfset qryFinal = qSearchCustOrders>		
<!---		</cfif>	--->
			
		</cfif>
			
<!---	<cfreturn qSearchCustOrders />	--->
		<cfreturn qryFinal />
	</cffunction>
	
	
	<cffunction name="getComment" access="public" returntype="string" output="No">
		<cfargument name="InvUniq" type="numeric" required="yes" />
		<cfargument name="DetailNum" type="numeric" required="yes" />

		<cfset Comment = "">

		<cfquery name="qryOECOINI" datasource="#THIS.DSN#">
		SELECT	Coin
		FROM	dbo.OECOINI
		WHERE	InvUniq = #ARGUMENTS.InvUniq# AND
				DetailNum = #ARGUMENTS.DetailNum#
		;
		</cfquery>



		<cfloop query="qryOECOINI">
			<cfif trim(qryOECOINI.Coin) IS NOT "">
				<cfset Comment = Comment & qryOECOINI.Coin>
			</cfif>
		</cfloop>
	
<!---		
		<cfif qryOECOINI.RecordCount GT 0>
			<cfset Comment = qryOECOINI.Coin>
		</cfif>
--->
		<cfreturn Comment />
	</cffunction>
	
	<cffunction name="getCustomerEmail" access="public" returntype="string" output="no">
	<cfargument name="AcctNo" type="string" required="yes">	
		<cfset local.email = "">
		<cfquery datasource="#APPLICATION.DSN_WWW#" name="local.qry">
		SELECT TOP 1 [email]
		FROM [SerialConfig].[dbo].[login]
		WHERE acctno = '#arguments.AcctNo#'
		ORDER BY DefaultAccount Desc
		</cfquery>
		<cfif local.qry.RecordCount neq 0><cfset local.email = local.qry.email></cfif>
		<cfreturn local.email>
	</cffunction>
		
</cfcomponent>
