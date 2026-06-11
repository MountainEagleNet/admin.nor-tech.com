<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	07/14/2006
	Function: 		Dynamic and Exportable Configurator: Submit Quote
	Template:		actSubmit.cfm
	Task:			quote_submit
--->

<cfset objQuoteSystem = createObject("component", "admin.assets.cfcs.config.QuoteSystem")>

<cfset stFormCopy = duplicate(FORM)>

<cfparam name="stFormCopy.SendToSalesRep" default="0">
<cfparam name="stFormCopy.SendToCustomer" default="0">
<cfparam name="stFormCopy.ACCPAC" default="0">

<!--- Send emails to Nor-Tech staff and to reseller --->
<cfif stFormCopy.SendToSalesRep eq 1>
	<cfset objQuoteSystem.sendEmailToNorTech(stFormCopy.QuoteSystemID, "order")>
</cfif>
<cfif stFormCopy.SendToCustomer eq 1>
	<cfset objQuoteSystem.sendEmailToReseller(stFormCopy.QuoteSystemID, "", "order")>
</cfif>
<cfif stFormCopy.ACCPAC eq 1>
	<cfset objQuoteSystem.sendQuoteToACCPAC(stFormCopy.QuoteSystemID)>
</cfif>
	
<!--- Set the "QuoteSubmitted" flag --->
<cfif stFormCopy.SendToSalesRep eq 1 OR stFormCopy.SendToCustomer eq 1 OR stFormCopy.ACCPAC eq 1>
	<cfset strQuoteSystem = objQuoteSystem.getRecord(stFormCopy.QuoteSystemID)>
    <cfset structInsert(strQuoteSystem, "QuoteSubmitted", 1, True)>
    <cfset objQuoteSystem.saveRecord(strQuoteSystem)>
</cfif>

<cflocation url="index.cfm?task=quote_submit_response&QuoteSystemID=#urlEncodedFormat(stFormCopy.QuoteSystemID)#&SentToSalesRep=#stFormCopy.SendToSalesRep#&SentToCustomer=#stFormCopy.SendToCustomer#&ACCPAC=#stFormCopy.ACCPAC#">