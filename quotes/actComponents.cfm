<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	09/07/2007
	Function: 		Parts Ordering: save the quantities or parts entered
	Template:		savComponents.cfm
	Task:			parts_components_save
--->
<cfset objPartsOrdersItems= createObject("component", "admin.assets.cfcs.parts.PartsOrdersItems")>
<cfset stFormCopy = duplicate(FORM)>

<cfset strQuoteScreen4 = objPartsOrdersItems.getSessionValue("QuoteScreen4")>
<cfif NOT isStruct(strQuoteScreen4)>
	<cfset strQuoteScreen4 = structNew()>
</cfif>

<cfif structKeyExists(strQuoteScreen4, "qrySelectedParts")>
	<cfset qrySelectedParts = strQuoteScreen4.qrySelectedParts>
<cfelse>
	<cfset qrySelectedParts = queryNew("MiscPartID,PriceListComponentID,SellingPrice,Quantity,ACCPACPartID,ITEMNO")>
</cfif>

<cfset lstForm = structKeyList(stFormCopy)>

<cfloop list="#lstForm#" index="Column">
	<cfif findNoCase('CHECKED|', Column) NEQ 0>
		<cfset PriceListComponentID = removeChars(Column, 1, 8)>
        
		<cfquery dbtype="query" name="qryFound">
		SELECT 	*
		FROM 	qrySelectedParts
		WHERE 	PriceListComponentID = '#PriceListComponentID#'
		</cfquery>
		<cfif qryFound.RecordCount EQ 0>
			<cfset queryAddRow(qrySelectedParts)>
            <cfset querySetCell(qrySelectedParts, "MiscPartID", "")>
            <cfset querySetCell(qrySelectedParts, "PriceListComponentID", PriceListComponentID)>
            <cfset querySetCell(qrySelectedParts, "SellingPrice", "")>
            <cfset querySetCell(qrySelectedParts, "Quantity", "")>
            <cfset querySetCell(qrySelectedParts, "ACCPACPartID", "")>
            <cfset querySetCell(qrySelectedParts, "ITEMNO", "")>
		</cfif>
	</cfif>
</cfloop>


<cfset structInsert(strQuoteScreen4, "qrySelectedParts", qrySelectedParts, True)>
<cfset objPartsOrdersItems.setSessionValue("QuoteScreen4", strQuoteScreen4)>


<cflocation url="index.cfm?task=quotes_new4_categories&UserID=#urlEncodedFormat(stFormCopy.UserID)#&PriceListID=#urlEncodedFormat(stFormCopy.PriceListID)#&CopyingQuote=#stFormCopy.CopyingQuote#&CameFromScreen5=#stFormCopy.CameFromScreen5#&QuoteSystemID=#urlEncodedFormat(stFormCopy.QuoteSystemID)#">