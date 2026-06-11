<cfcomponent extends="admin.assets.cfcs.Component">
	<cfset This.DataSourceName = APPLICATION.DSN_WWW>

	<cfset This.Columns = "SerialsAdministrationID,NextConsecutiveOrderNumber">
	<cfset This.ViewColumns = This.Columns>
	
	<cfset This.TableName = "tblSerialsAdministration">
	<cfset This.ViewName = This.TableName>
	
	<cfset This.PrimaryKey = "SerialsAdministrationID">
	<cfset This.ForeignHeaderKey = "">
	<cfset This.ForeignDetailKey = "">

	<cfset This.GenerateUUIDKey = 1>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "SerialsAdministrationID">
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
	
	<cffunction name="validateCreateRecord" access="public" returntype="struct" output="No">
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
			  Arguments.Record.QUANTITY LE 0>
			<cfset stErrors.QUANTITY = "Please enter an integer greater than zero:">
		</cfif>
		<cfreturn stErrors>
	</cffunction>

	<cffunction name="createAndPrintBarCodes" access="public" returntype="boolean" output="no">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var Success = 0>
		<cfset qryRecords = queryNew("SerialNumber")>
		<cfset strSerialsAdministration = getRecord("RecordNumber1")>
		<cfif NOT structIsEmpty(strSerialsAdministration)>
			<cfset SerialNumberValue = strSerialsAdministration.NextConsecutiveOrderNumber>
			<cfloop index="LoopCount" from="1" to="#Arguments.Record.Quantity#">
				<cfset queryAddRow(qryRecords)>
				<cfset querySetCell(qryRecords, "SerialNumber", SerialNumberValue)>
				<cfset SerialNumberValue = SerialNumberValue + 1>
			</cfloop>
			<cfset structInsert(strSerialsAdministration, "NextConsecutiveOrderNumber", SerialNumberValue, True)>
			<cfset saveRecord(strSerialsAdministration)>

			<cfif qryRecords.RecordCount GT 0>
				<cfset LabelFile = "#chr(34)#SerialNumber#chr(34)#,#chr(34)#Item Number#chr(34)##chr(13)##chr(10)#">
				<cfset ItemNumberValue = trim(Arguments.Record.ITEMNO)>
				<cfloop query="qryRecords">
					<cfoutput>
						<cfsavecontent variable="FieldData">"#qryRecords.SerialNumber#","#ItemNumberValue#"#chr(13)##chr(10)#</cfsavecontent>
						<cfset LabelFile = LabelFile & FieldData>
					</cfoutput>
				</cfloop>
				<!--- FTP the file to the Label Matrix computer --->
				<cfset Success = FTPLabelFile(LabelFile, "Manually_Generated")>
			</cfif>
		</cfif>
		<cfreturn Success>
	</cffunction>
	
</cfcomponent>