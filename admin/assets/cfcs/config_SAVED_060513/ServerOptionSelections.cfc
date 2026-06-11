<cfcomponent extends="admin.assets.cfcs.Component">

	<cfif isDefined("APPLICATION.DSN_WWW")>
		<cfset This.DataSourceName = APPLICATION.DSN_WWW>
	<cfelse>
		<cfset This.DataSourceName = "NorTechWWW">
	</cfif>

	<cfif isDefined("APPLICATION.DSN_AP")>
		<cfset This.APDataSourceName = APPLICATION.DSN_AP>
	<cfelse>
		<cfset This.APDataSourceName = "NorTechAP">
	</cfif>

	<cfif isDefined("APPLICATION.AdminLocation")>
		<cfset CURRENT_AdminLocation = APPLICATION.AdminLocation>
	<cfelse>
		<cfset CURRENT_AdminLocation = "admin">
	</cfif>


	<cfset This.Columns = "ServerOptionSelectionID,ServerOptionID,Name,SortOrder">
	<cfset This.ViewColumns = This.Columns>
	
	<cfset This.TableName = "tblServerOptionSelections">
	<cfset This.ViewName = This.TableName>
	
	<cfset This.PrimaryKey = "ServerOptionSelectionID">
	<cfset This.ForeignHeaderKey = "">
	<cfset This.ForeignDetailKey = "">
	
	<cfset This.ITEMNOKey = "">	

	<cfset This.GenerateUUIDKey = 1>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "SortOrder">
	<cfset This.SortOrder = "Asc">

	<cfset This.SortOrderList = "">
	<cfset This.SortKey = "SortOrder">
	<cfset This.ParentKey = "">
	<cfset This.CreatedKey = "">
	<cfset This.ModifiedKey = "">
	<cfset This.ZipCode1Key = "">
	<cfset This.ZipCode2Key = "">
	<cfset This.SavePrimaryKey = 0>
	<cfset This.ExcludeInUpdates = "">
	<cfset This.ExcludeInInserts = "">


	<cffunction name="validateRecord" access="public" returntype="struct" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
		<cfif validateRequired(Arguments.Record.Name) EQ 0>
			<cfset stErrors.Name = "Please enter the Server Option Selection Name">
		</cfif>
		<cfreturn stErrors>
	</cffunction>

	<!----------------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="validateServerOptions" access="public" returntype="struct" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
		<cfset var lstRecord = structKeyList(Arguments.Record)>
		<cfset objServerOptions = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.config.ServerOptions")>

		<cfset qryServerOptions = objServerOptions.listRecords()>

		<cfloop query="qryServerOptions">
			<cfset FieldName = "SERVOPT_" & qryServerOptions.ServerOptionID>
            <cfif listFindNoCase(lstRecord, FieldName) EQ 0>
                <cfset structInsert(stErrors, FieldName, "Please make a selection for server option '#qryServerOptions.Name#'", True)>
            </cfif>
		</cfloop>
<!---
<cfdump var="#Arguments.Record#">
<cfdump var="#stErrors#">
<cfabort>
--->
		<cfreturn stErrors>
	</cffunction>
    


    
	<!----------------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="getSelections" access="public" returntype="query" output="No">
	<cfargument name="RecordID" type="string" required="Yes">
		<cfset var qryRecords = queryNew(This.ViewColumns)>
		<cfquery datasource="#This.DataSourceName#" name="qryRecords">
		SELECT 	#This.ViewColumns#
		FROM 	#This.ViewName#
		WHERE 	ServerOptionID = '#Arguments.RecordID#'
		ORDER BY SortOrder
		</cfquery>
		<cfreturn qryRecords>
	</cffunction>

	<!----------------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="getServerOptionName" access="public" returntype="string" output="No">
	<cfargument name="ServerOptionID" type="string" required="Yes">
    	<cfset var ServerOptionName = "">
		<cfset var qryRecords = queryNew(This.ViewColumns)>
		<cfquery datasource="#This.DataSourceName#" name="qryRecords">
		SELECT 	Name
		FROM 	tblServerOptions
		WHERE 	ServerOptionID = '#Arguments.ServerOptionID#'
		</cfquery>
        <cfif qryRecords.RecordCount NEQ 0>
			<cfset ServerOptionName = qryRecords.Name>
        </cfif>
		<cfreturn ServerOptionName>
	</cffunction>


	<!----------------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="sortSelections" access="public" output="No">
	<cfargument name="ServerOptionID" type="string" required="Yes">
		<cfset var qryRecords = queryNew("")>
        <cfset var NewSortOrder = 1>
		<cfquery datasource="#This.DataSourceName#" name="qryRecords">
		SELECT 	ServerOptionSelectionID
		FROM 	tblServerOptionSelections
		WHERE 	ServerOptionID = '#Arguments.ServerOptionID#'
        ORDER BY SortOrder
		</cfquery>
        <cfloop query="qryRecords">
            <cfquery datasource="#This.DataSourceName#">
            UPDATE 	tblServerOptionSelections
            SET 	SortOrder = '#NewSortOrder#'
            WHERE 	ServerOptionSelectionID = '#qryRecords.ServerOptionSelectionID#'
            </cfquery>
			<cfset NewSortOrder = NewSortOrder + 1>
        </cfloop>
	</cffunction>

	
</cfcomponent>