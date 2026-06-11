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


	<cfset This.Columns = "ClassificationID,Name,Type,SortOrder,DefaultClassification">
	<cfset This.ViewColumns = This.Columns>
	
	<cfset This.TableName = "tblClassifications">
	<cfset This.ViewName = This.TableName>
	
	<cfset This.PrimaryKey = "ClassificationID">
	<cfset This.ForeignHeaderKey = "">
	<cfset This.ForeignDetailKey = "">
	
	<cfset This.ITEMNOKey = "">	

	<cfset This.GenerateUUIDKey = 1>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "SortOrder">
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
	
	<cffunction name="validateRecord" access="public" returntype="struct" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
		<cfif validateRequired(Arguments.Record.Name) EQ 0>
			<cfset stErrors.Name = "Please enter a  name">
		</cfif>
		<cfif validateRequired(Arguments.Record.Type) EQ 0>
			<cfset stErrors.Type = "Please select a type">
		</cfif>
		<cfif validateRequired(Arguments.Record.SortOrder) EQ 0>
			<cfset stErrors.SortOrder = "You must enter a sort order.">
		<cfelseif validateZeroDecimal(Arguments.Record.SortOrder) EQ 0>
			<cfset stErrors.SortOrder = "Please enter a numeric value greater than or equal to zero.">
		</cfif>
		<cfreturn stErrors>
	</cffunction>

	<cffunction name="saveRecord" access="public" returntype="string" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var ClassificationID = "">
		<cfset var qryClassifications = queryNew("")>        
		<cfset var CurrentSortOrder = 1>
        <cfif Arguments.Record.DefaultClassification EQ 1>
            <cfquery datasource="#This.DataSourceName#">
            UPDATE	#This.TableName# 
            SET		DefaultClassification = 0
            WHERE	Type = '#Arguments.Record.Type#'            
            </cfquery>
        </cfif>
        <cfset ClassificationID = super.saveRecord(Arguments.Record)>
        <cfquery name="qryClassifications" datasource="#This.DataSourceName#">
        SELECT	*
        FROM	#This.TableName# 
        WHERE	Type = '#Arguments.Record.Type#'            
        ORDER BY SortOrder
        </cfquery>
        <cfloop query="qryClassifications">
            <cfquery datasource="#This.DataSourceName#">
            UPDATE	#This.TableName# 
            SET		SortOrder = '#CurrentSortOrder#'
            WHERE	ClassificationID = '#qryClassifications.ClassificationID#'            
            </cfquery>
			<cfset CurrentSortOrder = CurrentSortOrder + 1>
		</cfloop>
		<cfreturn ClassificationID>
	</cffunction>
	
	<cffunction name="getDefault" access="public" returntype="query" output="No">
	<cfargument name="Type" type="string" required="Yes">
		<cfset var qryDefaultClassification = queryNew("")>
        <cfquery name="qryDefaultClassification" datasource="#This.DataSourceName#">
        SELECT	Name, SortOrder, ClassificationID
        FROM	#This.TableName# 
        WHERE	Type = '#Arguments.Type#' AND
        		DefaultClassification = 1
        </cfquery>
		<cfreturn qryDefaultClassification>
	</cffunction>
    
    <!------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="getClassificationList" access="public" returntype="string" output="No">
	<cfargument name="SystemType" type="string" required="Yes">
	<cfargument name="LoginID" type="string" required="No" default="">
		<cfset var ClassificationList = "">
		<cfset var qryDefaultClassification = queryNew("")>
        <cfset var CURRENTClassificationID = "">
        <cfset var qryResellerSystems = queryNew("")>
		<cfset objResellerSystems = createObject("component", "admin.assets.cfcs.config.ResellerSystems")>
		<cfset qryResellerSystems = objResellerSystems.getResellerSystems(Arguments.SystemType, "", 0, Arguments.LoginID)>
        <cfloop query="qryResellerSystems">
        	<cfset CURRENTClassificationID = qryResellerSystems.ClassificationID>
        	<cfif CURRENTClassificationID IS NOT "">
            	<cfif listContainsNoCase(ClassificationList, CURRENTClassificationID) EQ 0>
                	<cfset ClassificationList = listAppend(ClassificationList, CURRENTClassificationID)>
                </cfif>
			<cfelse>
            	<cfset qryDefaultClassification = getDefault(Arguments.SystemType)>
                <cfif qryDefaultClassification.ClassificationID IS NOT "">                
					<cfif listContainsNoCase(ClassificationList, qryDefaultClassification.ClassificationID) EQ 0>
                        <cfset ClassificationList = listAppend(ClassificationList, qryDefaultClassification.ClassificationID)>
                    </cfif>
              	</cfif>                      
            </cfif>
        </cfloop>
		<cfreturn ClassificationList>
	</cffunction>
	
</cfcomponent>