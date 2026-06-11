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


	<cfset This.Columns = "ClassificationAliasID,ClassificationID,CustomerID,Name">
	<cfset This.ViewColumns = This.Columns>
	
	<cfset This.TableName = "tblClassificationAliases">
	<cfset This.ViewName = This.TableName>
	
	<cfset This.PrimaryKey = "ClassificationAliasID">
	<cfset This.ForeignHeaderKey = "">
	<cfset This.ForeignDetailKey = "">
	
	<cfset This.ITEMNOKey = "">	

	<cfset This.GenerateUUIDKey = 1>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "Name">
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
	
    <!--------------------------------------------------------------------------------------------->
	<cffunction name="getAlias" access="public" returntype="string" output="No">
	<cfargument name="CustomerID" type="string" required="Yes">
	<cfargument name="ClassificationID" type="string" required="Yes">
		<cfset var ClassAlias = "">
		<cfset var qryClassificationAlias = queryNew("")>
        <cfquery name="qryClassificationAlias" datasource="#This.DataSourceName#">
        SELECT	Name
        FROM	#This.TableName# 
        WHERE	CustomerID = '#Arguments.CustomerID#' AND
        		ClassificationID = '#Arguments.ClassificationID#' 
        </cfquery>
        <cfif qryClassificationAlias.RecordCount NEQ 0>
			<cfset ClassAlias = qryClassificationAlias.Name>
        </cfif>
		<cfreturn ClassAlias>
	</cffunction>

    <!--------------------------------------------------------------------------------------------->
	<cffunction name="getClassificationName" access="public" returntype="string" output="No">
	<cfargument name="CustomerID" type="string" required="Yes">
	<cfargument name="ClassificationID" type="string" required="Yes">
	<cfargument name="DontUseAlias" type="boolean" required="no" default="0">
		<cfset var ClassificationName = "">
        <cfset var strClassification = structNew()>
		<cfset objClassifications = createObject("component", "admin.assets.cfcs.config.Classifications")>
        <cfif NOT Arguments.DontUseAlias>
			<cfset ClassificationName = getAlias(Arguments.CustomerID, Arguments.ClassificationID)>
       	</cfif>
        <cfif ClassificationName IS "">
        	<cfset strClassification = objClassifications.getRecord(Arguments.ClassificationID)>
            <cfif structKeyExists(strClassification, "Name")>
            	<cfset ClassificationName = strClassification.Name>
            </cfif>
        </cfif>
		<cfreturn ClassificationName>
	</cffunction>

    <!--------------------------------------------------------------------------------------------->
	<cffunction name="saveAliasNames" access="public" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var lstRecord = structKeyList(Arguments.Record)>
        <cfset var Column = "">
        <cfset var ClassificationID = "">
        <cfset var Alias = "">
        <cfset var qryClassificationAlias = queryNew("")>
        <cfset var strClassificationAlias = structNew()>

		<cfloop list="#lstRecord#" index="Column">
        	<cfif findNoCase('ClassAlias|', Column) NEQ 0>
				<cfset ClassificationID = removeChars(Column, 1, 11)>
                <cfset Alias = trim(Arguments.Record[Column])>
                
				<cfset strClassificationAlias = newRecord()>
                <cfset structInsert(strClassificationAlias, "ClassificationID", ClassificationID, True)>
                <cfset structInsert(strClassificationAlias, "CustomerID", Arguments.Record.CustomerID, True)>
                <cfset structInsert(strClassificationAlias, "Name", Alias, True)>
                
                <cfquery name="qryClassificationAlias" datasource="#This.DataSourceName#">
                SELECT	ClassificationAliasID
                FROM	tblClassificationAliases
                WHERE	CustomerID = '#Arguments.Record.CustomerID#' AND
                        ClassificationID = '#ClassificationID#' 
                </cfquery>
                <cfif qryClassificationAlias.RecordCount NEQ 0>
                    <cfif Alias IS "">
                        <cfset deleteRecord(qryClassificationAlias.ClassificationAliasID)>
                    <cfelse>
	                    <cfset structInsert(strClassificationAlias, "ClassificationAliasID", qryClassificationAlias.ClassificationAliasID, True)>
                        <cfset saveRecord(strClassificationAlias)>
                    </cfif>
                <cfelseif Alias IS NOT "">
                    <cfset saveRecord(strClassificationAlias)>
                </cfif>
			</cfif>
        </cfloop>
	</cffunction>

    
</cfcomponent>