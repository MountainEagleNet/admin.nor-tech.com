<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/29/2008
	Function: 		
	Template:		actCopyQuote.cfm
	Task:			quotes_copy
--->
<cfset objQuoteSystem = createObject("component", "admin.assets.cfcs.config.QuoteSystem")>

<cfset stFormCopy = duplicate(FORM)>

<cfdump var="#stFormCopy#">
<cfabort>

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

<cfset QuoteSystemID = objQuoteSystem.saveSalesRepQuote(stFormCopy)>

<cfset objQuoteSystem.setMessage("Your Quote was successfully saved, but was <em><strong>not</strong></em> emailed.")>

<cfif structKeyExists(stFormCopy, "ButtonClicked") AND stFormCopy.ButtonClicked IS "Email Quote">
	<cfset Success = objQuoteSystem.sendQuoteToReseller(QuoteSystemID,stFormCopy)>
	<cfif Success>
		<cfset objQuoteSystem.setMessage("Your Quote was successfully saved and emailed!")>
	<cfelse>
		<cfset objQuoteSystem.setMessage("Your Quote was successfully saved, but a problem prevented it from being emailed.")>
	</cfif>
</cfif>

<cflocation url="index.cfm?task=quotes_view">