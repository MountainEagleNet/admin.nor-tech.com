<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/29/2008
	Function: 		
	Template:		actQuote4.cfm
	Task:			quotes_new4_act
--->
<cfset objQuoteSystem = createObject("component", "admin.assets.cfcs.config.QuoteSystem")>


<!--- REMOVE POWER SUPPLY --->
<cfif isDefined("URL.RemovePS")>
	<cfset strQuoteScreen3 = objQuoteSystem.getSessionValue("QuoteScreen3")>
	<cfset FieldName = "CAT_" & URL.ConfigComponentCategoryID>
	<cfset structDelete(strQuoteScreen3, FieldName)>
    <cfset structInsert(strQuoteScreen3, "PowerSupplyDeleted", 1, True)>
	<cfset objQuoteSystem.setSessionValue("QuoteScreen3", strQuoteScreen3)>
    <cflocation url="index.cfm?task=quotes_new5&CopyingQuote=#strQuoteScreen3.CopyingQuote#&QuoteSystemID=#urlEncodedFormat(strQuoteScreen3.QuoteSystemID)#&RequestTimeout=6000">
</cfif>




<cfset stFormCopy = duplicate(FORM)>

<!---
<cfdump var="#stFormCopy#">
<cfabort>
--->

<!--- Estimate Freight Charges --->
<cfif structKeyExists(stFormCopy, "ButtonClicked") AND stFormCopy.ButtonClicked IS "Estimate">
	<cfset stErrors = objQuoteSystem.validateShipping(stFormCopy)>
	<cfif structIsEmpty(stErrors)>
    	<!--- Get Shipping Charge --->
        <cfset strResult = objQuoteSystem.getEstimatedFreight(stFormCopy)>
        <cfset structInsert(stFormCopy, "ShippingEstimate", strResult.EstimatedFreight, True)>
        <cfset structInsert(stFormCopy, "ErrorMessage", strResult.ErrorMessage, True)>
		<cfif strResult.Success>
			<cfset objQuoteSystem.setMessage("The shipping charge has been estimated.  Please see below.")>    
        <cfelse>
			<cfset objQuoteSystem.setMessage("The shipping charge could not be determined.  Please see below.")>    
        </cfif>
	<cfelse>
		<cfset objQuoteSystem.setMessage("Please correct the fields indicated below.")>    
    </cfif>
	<cfset objQuoteSystem.setSessionValue("QuoteScreen5", stFormCopy)>
	<cfset objQuoteSystem.setErrorRecord(stErrors)>
	<cflocation url="index.cfm?task=quotes_new5&ShippingCharge=1&RequestTimeout=6000">
</cfif>

<!--- Clear Shipping Charges --->
<cfif structKeyExists(stFormCopy, "ButtonClicked") AND stFormCopy.ButtonClicked IS "Clear">
	<cfset structDelete(stFormCopy, "ShippingEstimate")>
	<cfset objQuoteSystem.setMessage("The shipping charge has been removed.")>    
	<cfset stErrors = structNew()>
	<cfset objQuoteSystem.setSessionValue("QuoteScreen5", stFormCopy)>
	<cfset objQuoteSystem.setErrorRecord(stErrors)>
	<cflocation url="index.cfm?task=quotes_new5&ShippingCharge=1&RequestTimeout=6000">
</cfif>

<cfif NOT structKeyExists(stFormCopy, "SendToCustomer")>
	<cfset structInsert(stFormCopy, "SendToCustomer", 0, True)>	
</cfif>
<cfif NOT structKeyExists(stFormCopy, "SendToSalesRep")>
	<cfset structInsert(stFormCopy, "SendToSalesRep", 0, True)>	
</cfif>

<cfif stFormCopy.Quantity IS "" OR NOT isNumeric(stFormCopy.Quantity)>
	<cfset structInsert(stFormCopy, "Quantity", 1, True)>	
</cfif>

<cfset structInsert(stFormCopy, "ResellerPrice", stFormCopy.QuoteTotalPrice, True)>	

<cfif isNumeric(stFormCopy.ResellerPrice)>
	<cfset structInsert(stFormCopy, "ResellerTotal", (stFormCopy.ResellerPrice * stFormCopy.Quantity), True)>	
</cfif>

<!--- EDIT QUOTE --->
<cfif structKeyExists(stFormCopy, "ButtonClicked") AND stFormCopy.ButtonClicked IS "Edit Quote">
	<cfset structDelete(stFormCopy, "ShippingEstimate")>
	<cfset objQuoteSystem.setSessionValue("QuoteScreen5", stFormCopy)>
	<cflocation url="index.cfm?task=quotes_new3&CameFromScreen5=1&RequestTimeout=6000">

<cfelse>

	<!--- Select the Energy Star part number --->
    <cfset stFormCopy = objQuoteSystem.selectEnergyStar(stFormCopy)>

	<!--- SAVE QUOTE --->
	<cfset QuoteSystemID = objQuoteSystem.saveSalesRepQuote(stFormCopy)>
    
    <cfset objQuoteSystem.setMessage("Your Quote was successfully saved, but was <em><strong>not</strong></em> emailed.")>
    
    <cfif structKeyExists(stFormCopy, "ButtonClicked") AND stFormCopy.ButtonClicked IS "Email Quote">
		<!--- EMAIL QUOTE --->
        <cfset Success = objQuoteSystem.sendQuoteToReseller(QuoteSystemID,stFormCopy)>
        <cfif Success>
            <cfset objQuoteSystem.setMessage("Your Quote was successfully saved and emailed!")>
        <cfelse>
            <cfset objQuoteSystem.setMessage("Your Quote was successfully saved, but a problem prevented it from being emailed.")>
        </cfif>
    </cfif>
    
    <cflocation url="index.cfm?task=quotes_view">

</cfif>    