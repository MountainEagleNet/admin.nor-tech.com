<cfcomponent extends="admin.assets.cfcs.Component">
	<cfset This.DataSourceName = APPLICATION.DSN_WWW>

	<cfset This.TableName = "tblConfigComponentsResellers">
	<cfset This.ViewName = "vConfigComponentsResellers">

	<cfset This.Columns = "ConfigComponentsResellersID,ConfigComponentID,CustomerID,MarkupPercentage,FixedPrice">
	<cfset This.ViewColumns = "ConfigComponentsResellersID,ConfigComponentID,CategoryName,CategorySortOrder,SystemName,SystemType,SystemTypeSortOrder,CustomerID,CustCompany,CustFirstName,CustLastName,CustEmail,MarkupPercentage,FixedPrice">
	
	<cfset This.PrimaryKey = "ConfigComponentsResellersID">
	
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

	<!--------------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="listResellersForSalesRep" access="public" returntype="query" output="No">
   	<cfargument name="SalesRepUserID" type="string" required="No" default="">
		<cfset var UserID = "">
		<cfset qryResellers = queryNew("CustomerID,company")>
		<cfset objSalesRep = createObject("component", "admin.assets.cfcs.SalesRep")>
		<cfset objCust = createObject("component", "admin.assets.cfcs.Cust")>
        
		<!--- Get all resellers in table "login" for this sales rep --->
		<cfif Arguments.SalesRepUserID IS NOT "">
			<cfset UserID = Arguments.SalesRepUserID>
        <cfelse>
			<cfset UserID = getSessionValue("adminuserid")>
        </cfif>
        
		<cfset strSalesRep = objsalesrep.getSalesRepByUserID(UserID)>
		<cfif NOT structIsEmpty(strSalesRep) AND strSalesRep.ID IS NOT "">
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "salesrepID", strSalesRep.ID, True)>
			<cfset qryResellers = objCust.searchRecords(SearchRecord, "company")>
		</cfif>
		<cfreturn qryResellers>
	</cffunction>

	<!--------------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="listResellers" access="public" returntype="query" output="No">
	<cfargument name="ConfigComponentID" type="string" required="Yes">
		<cfset qryResellers = queryNew("CustomerID,company")>
		<cfset objSalesRep = createObject("component", "admin.assets.cfcs.SalesRep")>
		<cfset objCust = createObject("component", "admin.assets.cfcs.Cust")>

		<!--- Get all resellers in table "login" for this sales rep --->
		<cfset UserID = getSessionValue("adminuserid")>
		<cfset strSalesRep = objsalesrep.getSalesRepByUserID(UserID)>
		<cfif NOT structIsEmpty(strSalesRep) AND strSalesRep.ID IS NOT "">
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "salesrepID", strSalesRep.ID, True)>
			<cfset qrylogin = objCust.searchRecords(SearchRecord, "company")>
			<cfloop query="qrylogin">
				<cfset SearchRecord = structNew()>
				<cfset structInsert(SearchRecord, "CustomerID", qrylogin.CustomerID, True)>
				<cfset structInsert(SearchRecord, "ConfigComponentID", Arguments.ConfigComponentID, True)>
				<cfset qryConfigComponentsResellers = searchRecords(SearchRecord)>
				<cfif qryConfigComponentsResellers.RecordCount EQ 0>
					<cfset queryAddRow(qryResellers)>
					<cfset querySetCell(qryResellers, "CustomerID", qrylogin.CustomerID)>
					<cfset querySetCell(qryResellers, "company", qrylogin.company)>
				</cfif>
			</cfloop>
		</cfif>
		<cfreturn qryResellers>
	</cffunction>

	<cffunction name="validateRecord" access="public" returntype="struct" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
		<cfif validateRequired(Arguments.Record.CustomerID) EQ 0>
			<cfset stErrors.CustomerID = "Please select a reseller">
		</cfif>
		<cfif trim(Arguments.Record.MarkupPercentage) IS "" AND trim(Arguments.Record.FixedPrice) IS "" >
			<cfset stErrors.MarkupFixed = "Please enter a value in the markup percentage field or the fixed price field">
			<cfset stErrors.MarkupPercentage = "Error">
			<cfset stErrors.FixedPrice = "Error">
		<cfelseif trim(Arguments.Record.MarkupPercentage) IS NOT "" AND trim(Arguments.Record.FixedPrice) IS NOT "" >
			<cfset stErrors.MarkupFixed = "Please enter a value in the markup percentage field or the fixed price field, but not both">
			<cfset stErrors.MarkupPercentage = "Error">
			<cfset stErrors.FixedPrice = "Error">
		<cfelse>
			<cfif trim(Arguments.Record.MarkupPercentage) IS NOT "" AND validatePositiveDecimal(Arguments.Record.MarkupPercentage) EQ 0>
				<cfset stErrors.MarkupPercentage = "Please enter only a decimal value (greater than zero) in the markup percentage field">
			</cfif>
			<cfif trim(Arguments.Record.FixedPrice) IS NOT "" AND validatePositiveDecimal(Arguments.Record.FixedPrice) EQ 0>
				<cfset stErrors.FixedPrice = "Please enter only a decimal value (greater than zero) in the fixed price field">
			</cfif>
		</cfif>
		<cfreturn stErrors>
	</cffunction>

	<cffunction name="saveRecord" access="public" returntype="string" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var RecordID = "">
		<cfif structKeyExists(Arguments.Record, "MarkupPercentage") AND	trim(Arguments.Record.MarkupPercentage) IS "">
			<cfset structDelete(Arguments.Record, "MarkupPercentage")>
		</cfif>
		<cfif structKeyExists(Arguments.Record, "FixedPrice") AND	trim(Arguments.Record.FixedPrice) IS "">
			<cfset structDelete(Arguments.Record, "FixedPrice")>
		</cfif>
		<cfif NOT structKeyExists(Arguments.Record, "ConfigComponentsResellersID")>
			<cfset structInsert(Arguments.Record, "ConfigComponentsResellersID", "", True)>
		</cfif>
		<cfset RecordID = super.saveRecord(Arguments.Record)>
		<cfreturn RecordID>
	</cffunction>

</cfcomponent>