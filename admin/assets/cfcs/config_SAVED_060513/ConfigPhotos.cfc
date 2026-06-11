<cfcomponent extends="admin.assets.cfcs.Component">
	<cfset This.DataSourceName = APPLICATION.DSN_WWW>

	<cfset This.TableName = "tblConfigPhotos">
	<cfset This.ViewName = This.TableName>

	<cfset This.Columns = "ConfigPhotoID,DrivePath,Name,PhotoImage,Description,CaseImage">
	<cfset This.ViewColumns = This.Columns>
	
	<cfset This.PrimaryKey = "ConfigPhotoID">
	
	<cfset This.GenerateUUIDKey = 1>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "PhotoImage">
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

	<!---------------------------------------------------------------------------------------------------------------------->
	<cffunction name="listPrimaryPhotos" access="public" output="No">
        <cfset var qryConfigPhotos = queryNew("")>
        <cfquery datasource="#This.DataSourceName#" name="qryConfigPhotos">
        SELECT	#This.ViewColumns#
        FROM 	#This.ViewName#
        ORDER BY #This.SortColumn# #This.SortOrder#
        </cfquery>
		<cfreturn qryConfigPhotos>
	</cffunction>

	<!---------------------------------------------------------------------------------------------------------------------->
	<cffunction name="listCasePhotos" access="public" output="No">
        <cfset var qryConfigPhotos = queryNew("")>
        <cfquery datasource="#This.DataSourceName#" name="qryConfigPhotos">
        SELECT	#This.ViewColumns#
        FROM 	#This.ViewName#
        WHERE	CaseImage = 1
        ORDER BY #This.SortColumn# #This.SortOrder#
        </cfquery>
		<cfreturn qryConfigPhotos>
	</cffunction>

	<!---------------------------------------------------------------------------------------------------------------------->
	<cffunction name="getPhotoImage" access="public" returntype="string" output="No">
	<cfargument name="ConfigPhotoID" type="string" required="Yes">
		<cfset var PhotoImage = "">
        <cfset var qryConfigPhotos = queryNew("")>
        <cfquery datasource="#This.DataSourceName#" name="qryConfigPhotos">
        SELECT	PhotoImage
        FROM 	#This.TableName#
        WHERE	ConfigPhotoID = '#Arguments.ConfigPhotoID#'
        </cfquery>
		<cfif qryConfigPhotos.RecordCount NEQ 0>
        	<cfset PhotoImage = qryConfigPhotos.PhotoImage>
        </cfif>
		<cfreturn PhotoImage>
	</cffunction>

    
</cfcomponent>