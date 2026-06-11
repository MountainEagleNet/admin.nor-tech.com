<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	09/12/2007
	Function: 		Parts Ordering: Process Parts Order
	Template:		actProcess.cfm
	Task:			parts_process
--->

<cfset stFormCopy = duplicate(FORM)>

<cflocation url="index.cfm?task=quotes_new4&UserID=#urlEncodedFormat(stFormCopy.UserID)#&PriceListID=#urlEncodedFormat(stFormCopy.PriceListID)#&CopyingQuote=#stFormCopy.CopyingQuote#&CameFromScreen5=#stFormCopy.CameFromScreen5#&QuoteSystemID=#urlEncodedFormat(stFormCopy.QuoteSystemID)#">