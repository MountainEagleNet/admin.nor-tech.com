<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/20/2006
	Function: 		This page finds a receipt after entering a receipt number and clicking "Go"
	Template:		findReceipt.cfm
	Task:			serials_receipts_find
--->
<cfset objPORCPH1 = createObject("component", "admin.assets.cfcs.PORCPH1")>

<cfif NOT isDefined("Form.ReceiptNumber") OR trim(Form.ReceiptNumber) IS "">
	<!--- Receipt Number not entered (blank) --->
	<cflocation url="index.cfm?task=serials_receipts_list&Error=Blank">
<cfelse>
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "RCPNUMBER", trim(Form.ReceiptNumber), True)>
	<cfset qryReceipts = objPORCPH1.searchRecords(SearchRecord, "query")>
	
	<!--- Receipt not found --->
	<cfif qryReceipts.RecordCount EQ 0>
		<cflocation url="index.cfm?task=serials_receipts_list&Error=NotFound&ReceiptNumber=#Form.ReceiptNumber#">

	<!--- Multiple receipts found for this receipt number --->
	<cfelseif qryReceipts.RecordCount GT 1>
		<cflocation url="index.cfm?task=serials_receipts_list&Error=MultipleFound&ReceiptNumber=#Form.ReceiptNumber#">

	<!--- Receipt Found --->
	<cfelse>
		<cflocation url="index.cfm?task=serials_receipts_items_list&RCPHSEQ=#urlEncodedFormat(qryReceipts.RCPHSEQ)#">
	</cfif>
	
</cfif>