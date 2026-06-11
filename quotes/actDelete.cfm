<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/22/2007
	Function: 		Dynamic and Exportable Configurator: Delete Quote
	Template:		actDelete.cfm
	Task:			quote_delete
--->

<cfset stFormCopy = duplicate(FORM)>

<cfset objQuoteSystem = createObject("component", "admin.assets.cfcs.config.QuoteSystem")>
<cfset objQuoteComponents = createObject("component", "admin.assets.cfcs.config.QuoteComponents")>

<!--- Delete child records in tblQuoteComponents --->
<cfset qryQuoteComponents = objQuoteComponents.listRecordsForParent("QuoteSystemID", stFormCopy.QuoteSystemID)>
<cfloop query="qryQuoteComponents">
	<cfset objQuoteComponents.deleteRecord(qryQuoteComponents.QuoteComponentID)>
</cfloop>

<!--- Delete the record from tblQuoteSystem --->
<cfset objQuoteSystem.deleteRecord(stFormCopy.QuoteSystemID)>

<cfset objQuoteSystem.setMessage("The quote has been successfully deleted.")>
<cflocation url="index.cfm?task=quotes_list">