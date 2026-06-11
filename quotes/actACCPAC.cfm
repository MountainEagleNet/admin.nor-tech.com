<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	12/11/2008
	Function: 		This page creates a quote from an invoice in ACCPAC
	Template:		actACCPAC.cfm
	Task:			quotes_new_actACCPAC
--->
<cfset objQuoteSystem = createObject("component", "admin.assets.cfcs.config.QuoteSystem")>

<cfset stFormCopy = duplicate(FORM)>

<!---<cfset objQuoteSystem.setSessionValue("CreateQuoteINVUNIQ", stFormCopy.INVUNIQ)>--->

<cflocation url="index.cfm?task=quotes_new1&INVUNIQ=#urlEncodedFormat(stFormCopy.INVUNIQ)#">