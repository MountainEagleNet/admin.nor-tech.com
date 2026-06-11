<cfcomponent extends="admin.assets.cfcs.Component">
	<cfset This.DataSourceName = APPLICATION.DSN_WWW>

	<cfset This.Columns = "CountsID,CountDate,PostedDate,UserName,ITEMNO,ITEMDESC,LOCATION,LOCATIONDESC,Quantity,Posted">
	<cfset This.ViewColumns = This.Columns>

	<cfset This.TableName = "tblCounts">
	<cfset This.ViewName = This.TableName>
	
	<cfset This.PrimaryKey = "CountsID">
	<cfset This.ITEMNOKey = "">
	<cfset This.GenerateUUIDKey = 1>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "CountsID">
	<cfset This.SortOrder = "Asc">

	<cfset This.SortOrderList = "">
	<cfset This.SortKey = "">
	<cfset This.ParentKey = "">
	<cfset This.CreatedKey = "CountDate">
	<cfset This.ModifiedKey = "">
	<cfset This.ZipCode1Key = "">
	<cfset This.ZipCode2Key = "">
	<cfset This.SavePrimaryKey = 0>
	<cfset This.ExcludeInUpdates = "">
	<cfset This.ExcludeInInserts = "">

	<cfset This.DataRecordName = "CountsDataRecord">
	<cfset This.ErrorRecordName = "CountsErrorRecord">

	<cffunction name="validateRecord" access="public" returntype="struct" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
		<!--- ITEM NUMBER --->
		<cfif trim(Arguments.Record.ITEMNO) IS "">
			<cfset stErrors.ITEMNO = "Please enter an Item Number:">
		<cfelseif NOT itemExists(trim(Arguments.Record.ITEMNO))>
			<cfset stErrors.ITEMNO = "Please enter a valid Item Number:">
		<cfelseif NOT itemIsSerialized(trim(Arguments.Record.ITEMNO))>
			<cfset stErrors.ITEMNO = "This is not a serialized item:">
		</cfif>
		<!--- QUANTITY --->
		<cfif NOT isNumeric(Arguments.Record.QUANTITY) OR 
			  findNoCase(".", Arguments.Record.QUANTITY) NEQ 0 OR 
			  Arguments.Record.QUANTITY LT 0>
			<cfset stErrors.QUANTITY = "Please enter an integer greater than or equal to zero:">
		</cfif>
		<!--- LOCATION --->
		<cfif trim(Arguments.Record.LOCATION) IS "">
			<cfset stErrors.LOCATION = "Please select a Warehouse Location:">
		</cfif>
		<cfreturn stErrors>
	</cffunction>

<!---
	<cffunction name="saveRecord" access="public" returntype="string" output="No">
	<cfargument name="Record" type="struct" required="No">
		<cfset var RecordID = "">
		<cfif isDefined("Arguments.Record") EQ 0>
			<cfset Arguments.Record = Request.Settings.getValue(getRecordKey())>
		</cfif>
		<cfset objAdmin = createObject("component", "admin.assets.cfcs.Admin")>
		<cfset qryUser = objAdmin.getRecordAsQuery(SESSION.adminuserid)>
		<cfset structInsert(Arguments.Record, "PostedDate", now(), True)>
		<cfset structInsert(Arguments.Record, "UserName", qryUser.fname & " " & qryUser.lname, True)>
		<cfset structInsert(Arguments.Record, "ITEMDESC", getItemDescription(Arguments.Record.ITEMNO), True)>
		<cfset structInsert(Arguments.Record, "LOCATIONDESC", getLocationDescription(Arguments.Record.LOCATION), True)>
		<cfset structInsert(Arguments.Record, "Posted", 1, True)>
		<cfset RecordID = super.saveRecord(Arguments.Record)>
		<cfreturn RecordID>
	</cffunction>
--->


	<cffunction name="saveRecord" access="public" returntype="string" output="No">
	<cfargument name="Record" type="struct" required="No">
	<cfargument name="SaveAndPostpone" type="string" required="No">
		<cfset var RecordID = "">
		<cfset objAdmin = createObject("component", "admin.assets.cfcs.Admin")>

		<cfif isDefined("Arguments.Record") EQ 0>
			<cfset Arguments.Record = Request.Settings.getValue(getRecordKey())>
		</cfif>
		<cfif isDefined("Arguments.SaveAndPostpone") EQ 0>
			<cfset Arguments.SaveAndPostpone = 0>
		</cfif>

		<!--- Updating an existing record --->
		<cfif isDefined("Arguments.Record.CountsID") AND Arguments.Record.CountsID IS NOT "">
			<cfset strCount = getRecord(Arguments.Record.CountsID)>
		<!--- Creating a new record --->
		<cfelse>
<!---		<cfset strCount = duplicate(Arguments.Record)>	--->
			<cfset strCount = newRecord()>
			<cfset structInsert(strCount, "ITEMNO", Arguments.Record.ITEMNO, True)>
			<cfset structInsert(strCount, "ITEMDESC", getItemDescription(Arguments.Record.ITEMNO), True)>
			<cfset structInsert(strCount, "LOCATION", Arguments.Record.LOCATION, True)>
			<cfset structInsert(strCount, "LOCATIONDESC", getLocationDescription(Arguments.Record.LOCATION), True)>
			<cfset structInsert(strCount, "Quantity", Arguments.Record.Quantity, True)>
		</cfif>
		
		<cfset qryUser = objAdmin.getRecordAsQuery(SESSION.adminuserid)>
		<cfset structInsert(strCount, "UserName", qryUser.fname & " " & qryUser.lname, True)>

		<cfif Arguments.SaveAndPostpone EQ 1>
			<cfset structInsert(strCount, "Posted", 0, True)>
		<cfelse>
			<cfset structInsert(strCount, "Posted", 1, True)>
			<cfset structInsert(strCount, "PostedDate", now(), True)>
		</cfif>
		
		<cfset RecordID = super.saveRecord(strCount)>
		<cfreturn RecordID>
	</cffunction>

	<cffunction name="setPosted" access="public" output="No">
	<!--- Set the posted flag --->
	<cfargument name="Record" type="struct" required="Yes">
		<cfset CurrentPostedDate = createODBCDateTime(now())>
		<cfquery datasource="#This.DataSourceName#">
			UPDATE 	tblCounts 
			SET		Posted = 1, 
					PostedDate = #CurrentPostedDate#
			WHERE 	CountsID = '#Arguments.Record.CountsID#'
		</cfquery>
	</cffunction>

	<cffunction name="checkQuantity" access="public" returntype="boolean" output="no">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var QuantityMatches = 0>
		<cfset objSerials = createObject("component", "admin.assets.cfcs.Serials")>
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ITEMNO", trim(Arguments.Record.ITEMNO), True)>
		<cfset structInsert(SearchRecord, "LOCATION", trim(Arguments.Record.LOCATION), True)>
		<cfset qrySerials = objSerials.searchRecords(SearchRecord, "query")>
		<cfif qrySerials.RecordCount EQ Arguments.Record.Quantity>
			<cfset QuantityMatches = 1>
		</cfif>
		<cfreturn QuantityMatches>
	</cffunction>

	<cffunction name="deleteCount" access="public" output="no">
	<cfargument name="CountsID" type="string" required="Yes">
		<cfquery datasource="#This.DataSourceName#">
		DELETE FROM	tblSerialsCounts
		WHERE 	CountsID = '#Arguments.CountsID#'
		</cfquery>
		<cfquery datasource="#This.DataSourceName#">
		DELETE FROM	tblCounts
		WHERE 	CountsID = '#Arguments.CountsID#'
		</cfquery>
	</cffunction>

</cfcomponent>