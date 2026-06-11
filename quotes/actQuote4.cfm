<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/29/2008
	Function: 		
	Template:		actQuote4.cfm
	Task:			quotes_new4_act
--->
<cfset objMiscParts = createObject("component", "admin.assets.cfcs.parts.MiscParts")>

<cfset stFormCopy = duplicate(FORM)>
<!---
stFormCopy:<cfdump var="#stFormCopy#"><br />
--->

<!--- ===================================== --->
<!--- 			   ADD NEW PART 			--->
<!--- ===================================== --->
<cfif structKeyExists(stFormCopy, "ButtonClicked") AND stFormCopy.ButtonClicked IS "Add New Part">
	<!--- Validate --->
	<cfset ValidationError = 0>
	<cfif objMiscParts.validateRequired(stFormCopy.NEWMfgrPartNumber) EQ 0>
		<cfset ValidationError = 1>
	</cfif>
	<cfif objMiscParts.validateRequired(stFormCopy.NEWDescription) EQ 0>
		<cfset ValidationError = 1>
	</cfif>
	<cfif objMiscParts.validateRequired(stFormCopy.NEWCost) EQ 0>
		<cfset ValidationError = 1>
	<cfelseif objMiscParts.validateZeroDecimal(stFormCopy.NEWCost) EQ 0>
		<cfset ValidationError = 1>
	</cfif>
	<cfif ValidationError>
		<cflocation url="index.cfm?task=quotes_new4&UserID=#urlEncodedFormat(stFormCopy.UserID)#&PriceListID=#urlEncodedFormat(stFormCopy.PriceListID)#&ValidationError=1">
	<cfelse>
		<cfset strMiscPart = objMiscParts.newRecord()>
		<cfset structInsert(strMiscPart, "UserID", stFormCopy.UserID, True)>
		<cfset structInsert(strMiscPart, "MfgrPartNumber", stFormCopy.NEWMfgrPartNumber, True)>
		<cfset structInsert(strMiscPart, "Description", stFormCopy.NEWDescription, True)>
		<cfset structInsert(strMiscPart, "Cost", stFormCopy.NEWCost, True)>
		<cfset structInsert(strMiscPart, "Notes", stFormCopy.NEWNotes, True)>
		<cfset structInsert(strMiscPart, "ComponentCategoryID", stFormCopy.NEWComponentCategoryID, True)>
		<cfset MiscPartID = objMiscParts.saveRecord(strMiscPart)>
		
		<cfset structInsert(stFormCopy, "ButtonClicked", "Add Part", True)>
		<cfset structInsert(stFormCopy, "MiscPartID", MiscPartID, True)>
	</cfif>
</cfif>

<!--- ===================================== --->
<!--- 				ADD PART 				--->
<!--- ===================================== --->
<cfif structKeyExists(stFormCopy, "ButtonClicked") AND stFormCopy.ButtonClicked IS "Add Part">
	<cfset strQuoteScreen4 = objMiscParts.getSessionValue("QuoteScreen4")>
    <cfif NOT isStruct(strQuoteScreen4)>
        <cfset strQuoteScreen4 = structNew()>
    </cfif>

    <cfif structKeyExists(strQuoteScreen4, "qrySelectedParts")>
        <cfset qrySelectedParts = strQuoteScreen4.qrySelectedParts>
    <cfelse>
        <cfset qrySelectedParts = queryNew("MiscPartID,PriceListComponentID,SellingPrice,Quantity,ACCPACPartID,ITEMNO")>
    </cfif>
<!---
stFormCopy:<cfdump var="#stFormCopy#"><br />
qrySelectedParts:<cfdump var="#qrySelectedParts#"><br />
<cfabort>
--->
    <!--- Save selling prices and quantities --->
    <cfloop query="qrySelectedParts">
        <cfset CostKey = "COST|" & qrySelectedParts.MiscPartID>
        <cfif structKeyExists(stFormCopy, CostKey) AND stFormCopy[CostKey] IS NOT "" AND isNumeric(stFormCopy[CostKey])>
            <cfset querySetCell(qrySelectedParts, "SellingPrice", stFormCopy[CostKey], CurrentRow)>
        </cfif>
        <cfset CostKey = "COST|" & qrySelectedParts.PriceListComponentID>
        <cfif structKeyExists(stFormCopy, CostKey) AND stFormCopy[CostKey] IS NOT "" AND isNumeric(stFormCopy[CostKey])>
            <cfset querySetCell(qrySelectedParts, "SellingPrice", stFormCopy[CostKey], CurrentRow)>
        </cfif>
        
        <cfset QuantityKey = "QTY|" & qrySelectedParts.MiscPartID>
        <cfif structKeyExists(stFormCopy, QuantityKey) AND stFormCopy[QuantityKey] IS NOT "" AND isNumeric(stFormCopy[QuantityKey])>
            <cfset querySetCell(qrySelectedParts, "Quantity", stFormCopy[QuantityKey], CurrentRow)>
        </cfif>
        <cfset QuantityKey = "QTY|" & qrySelectedParts.PriceListComponentID>
        <cfif structKeyExists(stFormCopy, QuantityKey) AND stFormCopy[QuantityKey] IS NOT "" AND isNumeric(stFormCopy[QuantityKey])>
            <cfset querySetCell(qrySelectedParts, "Quantity", stFormCopy[QuantityKey], CurrentRow)>
        </cfif>
    </cfloop>
<!---
qrySelectedParts:<cfdump var="#qrySelectedParts#"><br />
--->
<!---<cfabort>--->
    
    <cfif structKeyExists(stFormCopy, "MiscPartID") AND trim(stFormCopy.MiscPartID) IS NOT "">
        <cfquery dbtype="query" name="qryFound">
        SELECT 	*
        FROM 	qrySelectedParts
        WHERE 	MiscPartID = '#stFormCopy.MiscPartID#'
        </cfquery>
        <cfif qryFound.RecordCount EQ 0>
            <cfset queryAddRow(qrySelectedParts)>
            <cfset querySetCell(qrySelectedParts, "MiscPartID", stFormCopy.MiscPartID)>
            <cfset querySetCell(qrySelectedParts, "PriceListComponentID", "")>
            <cfset querySetCell(qrySelectedParts, "SellingPrice", "")>
            <cfset querySetCell(qrySelectedParts, "Quantity", "")>
            <cfset querySetCell(qrySelectedParts, "ACCPACPartID", "")>
            <cfset querySetCell(qrySelectedParts, "ITEMNO", "")>
        </cfif>
    </cfif>

    <cfset structInsert(strQuoteScreen4, "qrySelectedParts", qrySelectedParts, True)>
    
    <cfset objMiscParts.setSessionValue("QuoteScreen4", strQuoteScreen4)>
	<cflocation url="index.cfm?task=quotes_new4&UserID=#urlEncodedFormat(stFormCopy.UserID)#&PriceListID=#urlEncodedFormat(stFormCopy.PriceListID)#&CopyingQuote=#stFormCopy.CopyingQuote#&CameFromScreen5=#stFormCopy.CameFromScreen5#&QuoteSystemID=#urlEncodedFormat(stFormCopy.QuoteSystemID)#">
</cfif>



<!--- ===================================== --->
<!---  ADD PARTS FROM CUSTOMER PRICE LIST   --->
<!--- ===================================== --->
<cfif structKeyExists(stFormCopy, "ButtonClicked") AND stFormCopy.ButtonClicked IS "Add Parts from Customer Price List">

	<cfset strQuoteScreen4 = objMiscParts.getSessionValue("QuoteScreen4")>
    <cfif NOT isStruct(strQuoteScreen4)>
        <cfset strQuoteScreen4 = structNew()>
    </cfif>

    <cfif structKeyExists(strQuoteScreen4, "qrySelectedParts")>
        <cfset qrySelectedParts = strQuoteScreen4.qrySelectedParts>
    <cfelse>
        <cfset qrySelectedParts = queryNew("MiscPartID,PriceListComponentID,SellingPrice,Quantity,ACCPACPartID,ITEMNO")>
    </cfif>

    <!--- Save selling prices and quantities --->
    <cfloop query="qrySelectedParts">
        <cfset CostKey = "COST|" & qrySelectedParts.MiscPartID>
        <cfif structKeyExists(stFormCopy, CostKey) AND stFormCopy[CostKey] IS NOT "" AND isNumeric(stFormCopy[CostKey])>
            <cfset querySetCell(qrySelectedParts, "SellingPrice", stFormCopy[CostKey], CurrentRow)>
        </cfif>
        <cfset CostKey = "COST|" & qrySelectedParts.PriceListComponentID>
        <cfif structKeyExists(stFormCopy, CostKey) AND stFormCopy[CostKey] IS NOT "" AND isNumeric(stFormCopy[CostKey])>
            <cfset querySetCell(qrySelectedParts, "SellingPrice", stFormCopy[CostKey], CurrentRow)>
        </cfif>
        
        <cfset QuantityKey = "QTY|" & qrySelectedParts.MiscPartID>
        <cfif structKeyExists(stFormCopy, QuantityKey) AND stFormCopy[QuantityKey] IS NOT "" AND isNumeric(stFormCopy[QuantityKey])>
            <cfset querySetCell(qrySelectedParts, "Quantity", stFormCopy[QuantityKey], CurrentRow)>
        </cfif>
        <cfset QuantityKey = "QTY|" & qrySelectedParts.PriceListComponentID>
        <cfif structKeyExists(stFormCopy, QuantityKey) AND stFormCopy[QuantityKey] IS NOT "" AND isNumeric(stFormCopy[QuantityKey])>
            <cfset querySetCell(qrySelectedParts, "Quantity", stFormCopy[QuantityKey], CurrentRow)>
        </cfif>
    </cfloop>

    <cfset structInsert(strQuoteScreen4, "qrySelectedParts", qrySelectedParts, True)>
    
    <cfset objMiscParts.setSessionValue("QuoteScreen4", strQuoteScreen4)>

    <cflocation url="index.cfm?task=quotes_new4_categories&UserID=#urlEncodedFormat(stFormCopy.UserID)#&PriceListID=#urlEncodedFormat(stFormCopy.PriceListID)#&CopyingQuote=#stFormCopy.CopyingQuote#&CameFromScreen5=#stFormCopy.CameFromScreen5#&QuoteSystemID=#urlEncodedFormat(stFormCopy.QuoteSystemID)#">
</cfif>



<!--- CONTINUE--->
<!---
strQuoteScreen4:<cfdump var="#objMiscParts.getSessionValue('QuoteScreen4')#"><br>
stFormCopy:<cfdump var="#stFormCopy#"><br>
<cfabort>
--->

<cfset strQuoteScreen4_SAVED = objMiscParts.getSessionValue("QuoteScreen4")>
<cfif isStruct(strQuoteScreen4_SAVED) AND structKeyExists(strQuoteScreen4_SAVED, "qrySelectedParts")>
	<cfset qrySelectedParts = strQuoteScreen4_SAVED.qrySelectedParts>
<cfelse>
	<cfset qrySelectedParts = queryNew("MiscPartID,PriceListComponentID,SellingPrice,Quantity,ACCPACPartID,ITEMNO")>
</cfif>

<cfset strQuoteScreen4 = duplicate(stFormCopy)>
<cfset structInsert(strQuoteScreen4, "qrySelectedParts", qrySelectedParts, True)>

<cfset objMiscParts.setSessionValue("QuoteScreen4", strQuoteScreen4)>


<!--- VALIDATION ERRORS --->
<cfset ValidationError = 0>
<cfset lstRecord = structKeyList(stFormCopy)>
<cfloop list="#lstRecord#" index="Column">
	<cfif findNoCase('COST|', Column) NEQ 0 OR findNoCase('QTY|', Column) NEQ 0>
		<cfif NOT isNumeric(stFormCopy[Column]) OR stFormCopy[Column] LT 0>        
			<cfset ValidationError = 1>
            <cfbreak>
		</cfif>
	</cfif>
</cfloop>

<cfif ValidationError>
	<cfset objMiscParts.setMessage("Please correct the errors below.")>
    <cflocation url="index.cfm?task=quotes_new4&CopyingQuote=#stFormCopy.CopyingQuote#&QuoteSystemID=#urlEncodedFormat(stFormCopy.QuoteSystemID)#&UserID=#urlEncodedFormat(stFormCopy.UserID)#&PriceListID=#urlEncodedFormat(stFormCopy.PriceListID)#&Validation=1">
<cfelse>
    <cflocation url="index.cfm?task=quotes_new5&CopyingQuote=#stFormCopy.CopyingQuote#&QuoteSystemID=#urlEncodedFormat(stFormCopy.QuoteSystemID)#&RequestTimeout=6000">
</cfif>