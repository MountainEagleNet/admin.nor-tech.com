<cfcomponent extends="admin.assets.cfcs.Component">

	<cfif isDefined("APPLICATION.DSN_WWW")>
		<cfset This.DataSourceName = APPLICATION.DSN_WWW>
	<cfelse>
		<cfset This.DataSourceName = "NorTechWWW">
	</cfif>

	<cfset This.Columns = "SerialID,ITEMNO,LOCATION,SerialNumber,CreationDate">
	<cfset This.ViewColumns = This.Columns>
	
	<cfset This.TableName = "tblSerials">
	<cfset This.ViewName = This.TableName>
	
	<cfset This.PrimaryKey = "SerialID">
	<cfset This.ForeignHeaderKey = "">
	<cfset This.ForeignDetailKey = "">

	<cfset This.GenerateUUIDKey = 1>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "SerialNumber">
	<cfset This.SortOrder = "Asc">

	<cfset This.SortOrderList = "">
	<cfset This.SortKey = "">
	<cfset This.ParentKey = "">
	<cfset This.CreatedKey = "CreationDate">
	<cfset This.ModifiedKey = "">
	<cfset This.ZipCode1Key = "">
	<cfset This.ZipCode2Key = "">
	<cfset This.SavePrimaryKey = 0>
	<cfset This.ExcludeInUpdates = "">
	<cfset This.ExcludeInInserts = "">
	
	<cffunction name="getOnHandAmount" access="public" returntype="numeric" output="no">
	<cfargument name="ITEMNO" type="string" required="Yes">
		<cfset var OnHandAmount = 0>
		<cfquery datasource="#This.DataSourceName#" name="qrySerials">
		SELECT 	#This.ViewColumns#
		FROM 	#This.ViewName#
		WHERE 	ITEMNO = '#Arguments.ITEMNO#' AND
				LOCATION <> '3'
		</cfquery>
		<cfset OnHandAmount = qrySerials.RecordCount>
		<cfreturn OnHandAmount>
	</cffunction>

	<cffunction name="findSerialNumberForCorrections" access="public" returntype="query" output="no">
	<cfargument name="Record" type="struct" required="Yes">
	<cfargument name="OrderByList" type="string" required="no">
		<cfset var qrySerials = queryNew(This.ViewColumns)>
		<cfquery datasource="#This.DataSourceName#" name="qrySerials">
		SELECT 	#This.ViewColumns#
		FROM 	#This.ViewName#
		WHERE 	ITEMNO = '#trim(Arguments.Record.ITEMNO)#' 
				<cfif trim(Arguments.Record.SerialNumber) IS NOT "">
					AND SerialNumber LIKE '%#trim(Arguments.Record.SerialNumber)#%'
				</cfif>
		ORDER BY #Arguments.OrderByList#
		</cfquery>
		<cfreturn qrySerials>
	</cffunction>
		
	<cffunction name="deleteDuplicates" access="public" returntype="numeric" output="no">
	<cfargument name="ITEMNO" type="string" required="no">
    	<cfset var DeletionCount = 0>
    	<cfset var qrySerials = queryNew("")>
        <cfset var SavedSerialNumber = "">
		<cfset var qryDuplicates = queryNew("")>
        
        <cfif trim(Arguments.ITEMNO) IS NOT "">		
            <cfquery datasource="#This.DataSourceName#" name="qrySerials">
            SELECT 	SerialID, SerialNumber
            FROM 	tblSerials
            WHERE 	ITEMNO = '#trim(Arguments.ITEMNO)#' 
            ORDER BY SerialNumber
            </cfquery>
    
            <cfset SavedSerialNumber = "">
            <cfloop query="qrySerials">
                <cfif SavedSerialNumber IS NOT trim(qrySerials.SerialNumber)>
                    <cfset SavedSerialNumber = trim(qrySerials.SerialNumber)>
                    <cfquery datasource="#This.DataSourceName#" name="qryDuplicates">
                    SELECT 	SerialID
                    FROM 	tblSerials
                    WHERE  	ITEMNO = '#trim(Arguments.ITEMNO)#' AND
                            SerialNumber = '#SavedSerialNumber#' AND
                            SerialID <> '#qrySerials.SerialID#'              
                    </cfquery>
                    <cfset DeletionCount = DeletionCount + qryDuplicates.RecordCount>
                    <cfquery datasource="#This.DataSourceName#">
                    DELETE FROM tblSerials
                    WHERE  ITEMNO = '#trim(Arguments.ITEMNO)#' AND
                           SerialNumber = '#SavedSerialNumber#' AND
                           SerialID <> '#qrySerials.SerialID#'              
                    </cfquery>
                </cfif>
            </cfloop>
		</cfif>
        <cfreturn DeletionCount>
	</cffunction>
		
</cfcomponent>