<cfcomponent extends="admin.assets.cfcs.Component">
	<cfset This.DataSourceName = APPLICATION.DSN_WWW>

	<cfset This.TableName = "tblQuoteComponents">
	<cfset This.ViewName = This.TableName>

	<cfset This.Columns = "QuoteComponentID,QuoteSystemID,ITEMNO,ITEMDESC,TypeName,TypeSortOrder,MiscPart,MiscPartID,PriceListComponentID,SellingPrice,Quantity">
	<cfset This.ViewColumns = This.Columns>
	
	<cfset This.PrimaryKey = "QuoteComponentID">
	
	<cfset This.GenerateUUIDKey = 1>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "QuoteComponentID">
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


	<cffunction name="isSelectedComponent" access="public" returntype="boolean" output="no">
	<cfargument name="QuoteSystemID" type="string" required="Yes">
	<cfargument name="ITEMNO" type="string" required="Yes">
	<cfargument name="CategoryName" type="string" required="Yes">
		<cfset var ThisIsSelectedComponent = 0>
		<cfset var qryQuoteComponent = queryNew("#This.PrimaryKey#")>       
		<cfquery datasource="#This.DataSourceName#" name="qryQuoteComponent">
		SELECT	#This.PrimaryKey#
		FROM 	#This.TableName#
		WHERE	QuoteSystemID = '#Arguments.QuoteSystemID#' AND
				ITEMNO = '#trim(Arguments.ITEMNO)#' AND
				TypeName = '#Arguments.CategoryName#'
		</cfquery>		
		<cfif qryQuoteComponent.RecordCount NEQ 0>
			<cfset ThisIsSelectedComponent = 1>
		</cfif>
		<cfreturn ThisIsSelectedComponent>
	</cffunction>


	<cffunction name="isQuantity" access="public" returntype="boolean" output="no">
	<cfargument name="QuoteSystemID" type="string" required="Yes">
	<cfargument name="CategoryName" type="string" required="Yes">
	<cfargument name="QuantityAmount" type="numeric" required="Yes">
		<cfset var ThisIsQuantity = 0>
		<cfset var qryQuoteComponent = queryNew("#This.PrimaryKey#")>
		<cfquery datasource="#This.DataSourceName#" name="qryQuoteComponent">
		SELECT	#This.PrimaryKey#
		FROM 	#This.TableName#
		WHERE	QuoteSystemID = '#Arguments.QuoteSystemID#' AND
				TypeName = '#Arguments.CategoryName#' AND
                Quantity = #Arguments.QuantityAmount#
		</cfquery>		
		<cfif qryQuoteComponent.RecordCount NEQ 0>
			<cfset ThisIsQuantity = 1>
		</cfif>
		<cfreturn ThisIsQuantity>
	</cffunction>

	<cffunction name="ignoreComponent" access="public" returntype="boolean" output="no">
	<cfargument name="QuoteSystemID" type="string" required="Yes">
	<cfargument name="CategoryName" type="string" required="Yes">
		<cfset var ComponentIsIgnored = 0>
		<cfset var qryQuoteComponent = queryNew("#This.PrimaryKey#")>
		<cfquery datasource="#This.DataSourceName#" name="qryQuoteComponent">
		SELECT	#This.PrimaryKey#
		FROM 	#This.TableName#
		WHERE	QuoteSystemID = '#Arguments.QuoteSystemID#' AND
				TypeName = '#Arguments.CategoryName#' AND
                (MiscPart = 0 OR MiscPart IS NULL)
		</cfquery>		
		<cfif qryQuoteComponent.RecordCount EQ 0>
			<cfset ComponentIsIgnored = 1>
		</cfif>
		<cfreturn ComponentIsIgnored>
	</cffunction>

</cfcomponent>