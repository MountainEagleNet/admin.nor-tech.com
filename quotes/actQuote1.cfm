<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/26/2006
	Function: 		This page finds an order after entering an order number and clicking "Go"
	Template:		findOrder.cfm
	Task:			serials_orders_find
--->
<cfset objLogin = createObject("component", "admin.assets.cfcs.Cust")>
<cfset objSalesRep = createObject("component", "admin.assets.cfcs.SalesRep")>

<cfif (NOT isDefined("Form.acctno") OR trim(Form.acctno) IS "") AND
	  (NOT isDefined("Form.company") OR trim(Form.company) IS "")>
	<!--- Account Number not entered (blank) --->
	<cflocation url="index.cfm?task=quotes_new1&Error=Blank&INVUNIQ=#urlEncodedFormat(FORM.INVUNIQ)#&CopyingQuote=#FORM.CopyingQuote#&Cpyx=#FORM.Cpyx#&QuoteSystemID=#urlEncodedFormat(FORM.QuoteSystemID)#">
<cfelse>
	<cfset SearchRecord = structNew()>
	<cfset Variables.UserID = objLogin.getSessionValue("adminuserid")>
	<cfset structInsert(SearchRecord, "UserID", Variables.UserID, True)>
	<cfset qrySalesRep = objSalesRep.searchRecords(SearchRecord, "query", "repname")>
	<cfif qrySalesRep.RecordCount EQ 0>
		<cflocation url="index.cfm?task=quotes_new1&Error=NotFound&acctno=#Form.acctno#&company=#Form.company#&INVUNIQ=#urlEncodedFormat(FORM.INVUNIQ)#&CopyingQuote=#FORM.CopyingQuote#&Cpyx=#FORM.Cpyx#&QuoteSystemID=#urlEncodedFormat(FORM.QuoteSystemID)#">
	<cfelse>

		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "SalesRepID", qrySalesRep.ID, True)>

		<cfif trim(Form.acctno) IS NOT "">
			<cfset structInsert(SearchRecord, "acctno", trim(Form.acctno), True)>
		</cfif>
        
		<cfif trim(Form.company) IS NOT "">
			<cfset structInsert(SearchRecord, "company", trim(Form.company), True)>
		</cfif>
        
		<cfset qryLogin = objLogin.searchRecords(SearchRecord)>
		
		<!--- Customer not found --->
		<cfif qryLogin.RecordCount EQ 0>
			<cflocation url="index.cfm?task=quotes_new1&Error=NotFound&acctno=#Form.acctno#&company=#Form.company#&INVUNIQ=#urlEncodedFormat(FORM.INVUNIQ)#&CopyingQuote=#FORM.CopyingQuote#&Cpyx=#FORM.Cpyx#&QuoteSystemID=#urlEncodedFormat(FORM.QuoteSystemID)#">
	
		<!--- Multiple customers found --->
		<cfelseif qryLogin.RecordCount GT 1>
        	<cfset objSalesRep.setSessionValue("qryLoginAccounts", qryLogin)>
        
<!---		<cflocation url="index.cfm?task=quotes_new1&Error=MultipleFound&acctno=#Form.acctno#">	--->
			<cflocation url="index.cfm?task=quotes_new1&MultipleFound=1&acctno=#Form.acctno#&company=#Form.company#&INVUNIQ=#urlEncodedFormat(FORM.INVUNIQ)#&CopyingQuote=#FORM.CopyingQuote#&Cpyx=#FORM.Cpyx#&QuoteSystemID=#urlEncodedFormat(FORM.QuoteSystemID)#">
	
		<!--- Customer Found --->
		<cfelse>
			<cflocation url="index.cfm?task=quotes_new2&UserID=#urlEncodedFormat(Variables.UserID)#&CustomerID=#urlEncodedFormat(qryLogin.CustomerID)#&INVUNIQ=#urlEncodedFormat(FORM.INVUNIQ)#&CopyingQuote=#FORM.CopyingQuote#&Cpyx=#FORM.Cpyx#&QuoteSystemID=#urlEncodedFormat(FORM.QuoteSystemID)#&RequestTimeout=6000">
		</cfif>

	</cfif>
	
</cfif>