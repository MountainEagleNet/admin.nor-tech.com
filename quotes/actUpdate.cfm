<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	11/21/2007
	Function: 		Dynamic and Exportable Configurator: Update Quote
	Template:		actUpdate.cfm
	Task:			quote_update
--->

<cfset stFormCopy = duplicate(FORM)>
<!---
<cflocation url="index.cfm?task=config_dyn_configure&ConfigSystemID=#urlEncodedFormat(stFormCopy.ConfigSystemID)#&QuoteSystemID=#urlEncodedFormat(stFormCopy.QuoteSystemID)#&UpdateQuote=1&RequestTimeout=6000">
--->
<!---<cflocation url="index.cfm?task=quotes_new3&QuoteSystemID=#urlEncodedFormat(stFormCopy.QuoteSystemID)#&CopyingQuote=1&RequestTimeout=6000">--->
<cflocation url="index.cfm?task=quotes_new1&QuoteSystemID=#urlEncodedFormat(stFormCopy.QuoteSystemID)#&CopyingQuote=1&RequestTimeout=6000">