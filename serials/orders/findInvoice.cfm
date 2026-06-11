<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	01/18/2007
	Function: 		This page finds an invoice after entering an invoice number and clicking "Go"
	Template:		findInvoice.cfm
	Task:			serials_reprint_invoice_find
--->
<cfset objOEINVH = createObject("component", "admin.assets.cfcs.OEINVH")>
<cfset objOEORDH = createObject("component", "admin.assets.cfcs.OEORDH")>
<cfset objOEINVD = createObject("component", "admin.assets.cfcs.OEINVD")>
<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>

<cfif NOT isDefined("Form.InvoiceNumber") OR trim(Form.InvoiceNumber) IS "">
	<!--- Invoice Number not entered (blank) --->
	<cflocation url="index.cfm?task=serials_reprint_invoice_enter&Error=Blank">
<cfelse>
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "INVNUMBER", trim(Form.InvoiceNumber), True)>
	<cfset qryInvoices = objOEINVH.searchRecords(SearchRecord, "query")>
	
	<!--- Invoice not found --->
	<cfif qryInvoices.RecordCount EQ 0>
		<cflocation url="index.cfm?task=serials_reprint_invoice_enter&Error=NotFound&InvoiceNumber=#Form.InvoiceNumber#">

	<!--- Multiple Invoices found for this Invoice number --->
	<cfelseif qryInvoices.RecordCount GT 1>
		<cflocation url="index.cfm?task=serials_reprint_invoice_enter&Error=MultipleFound&InvoiceNumber=#Form.InvoiceNumber#">

	<!--- Invoice Found --->
	<cfelse>

		<!--- Get the Order --->
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ORDNUMBER", trim(qryInvoices.ORDNUMBER), True)>
		<cfset qryOrder = objOEORDH.searchRecords(SearchRecord, "query")>

		<!--- Does this invoice already has serial numbers attached? --->
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ORDUNIQ", qryOrder.ORDUNIQ, True)>
		<cfset structInsert(SearchRecord, "INVUNIQ", qryInvoices.INVUNIQ, True)>
		<cfset structInsert(SearchRecord, "AttachedToInvoice", 1, True)>
		<cfset qrySerialsShipmentsAttached = objSerialsShipments.searchRecords(SearchRecord, "query")>
		<cfif qrySerialsShipmentsAttached.RecordCount EQ 0>
			<cflocation url="index.cfm?task=serials_reprint_invoice_enter&Error=NoAttachedSerialNumbers&InvoiceNumber=#Form.InvoiceNumber#">
		<cfelse>
			<cflocation url="index.cfm?task=serials_attach_reprint&ORDUNIQ=#urlEncodedFormat(qryOrder.ORDUNIQ)#&INVUNIQ=#urlEncodedFormat(qryInvoices.INVUNIQ)#">
		</cfif>
	</cfif>
</cfif>