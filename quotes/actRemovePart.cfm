<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	10/28/2008
	Function: 		
	Template:		actRemovePart.cfm
	Task:			quotes_new4_removepart
--->
<cfset objMiscParts = createObject("component", "admin.assets.cfcs.parts.MiscParts")>

<cfset strQuoteScreen4 = objMiscParts.getSessionValue("QuoteScreen4")>

<cfif isStruct(strQuoteScreen4) AND structKeyExists(strQuoteScreen4, "qrySelectedParts")>
	<cfset qrySelectedParts = strQuoteScreen4.qrySelectedParts>
	<cfset qryNEWSelectedParts = queryNew("MiscPartID,PriceListComponentID,Quantity,SellingPrice,ACCPACPartID,ITEMNO")>
    <cfloop query="qrySelectedParts">
    	<cfif (qrySelectedParts.MiscPartID IS "" OR
			   qrySelectedParts.MiscPartID IS NOT URL.MiscPartID) AND
			  (qrySelectedParts.PriceListComponentID IS "" OR
			   qrySelectedParts.PriceListComponentID IS NOT URL.PriceListComponentID) AND
			  (qrySelectedParts.ACCPACPartID IS "" OR
			   qrySelectedParts.ACCPACPartID IS NOT URL.ACCPACPartID)>
			<cfset queryAddRow(qryNEWSelectedParts)>
            <cfset querySetCell(qryNEWSelectedParts, "MiscPartID", qrySelectedParts.MiscPartID)>
            <cfset querySetCell(qryNEWSelectedParts, "PriceListComponentID", qrySelectedParts.PriceListComponentID)>
            <cfset querySetCell(qryNEWSelectedParts, "Quantity", qrySelectedParts.Quantity)>
            <cfset querySetCell(qryNEWSelectedParts, "SellingPrice", qrySelectedParts.SellingPrice)>

            <cfset querySetCell(qryNEWSelectedParts, "ACCPACPartID", qrySelectedParts.ACCPACPartID)>
            <cfset querySetCell(qryNEWSelectedParts, "ITEMNO", qrySelectedParts.ITEMNO)>

		</cfif>			   
    </cfloop>

	<cfset structInsert(strQuoteScreen4, "qrySelectedParts", qryNEWSelectedParts, True)>
	<cfset objMiscParts.setSessionValue("QuoteScreen4", strQuoteScreen4)>
	<cfset objMiscParts.setMessage("The part was successfully removed.")>
    
<cfelse>
	<cfset objMiscParts.setMessage("An error prevented the part from being removed.")>
</cfif>

<cflocation url="index.cfm?task=quotes_new4&UserID=#urlEncodedFormat(URL.UserID)#&PriceListID=#urlEncodedFormat(URL.PriceListID)#&CopyingQuote=#URL.CopyingQuote#&CameFromScreen5=#URL.CameFromScreen5#&QuoteSystemID=#urlEncodedFormat(URL.QuoteSystemID)#">