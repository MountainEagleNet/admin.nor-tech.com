<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/12/2007
	Function: 		Apply serial numbers from receipt: Action Page
	Template:		actSerialsApply.cfm
	Task:			serials_shipments_apply_act
--->
<cfset objPORCPH1 = createObject("component", "admin.assets.cfcs.PORCPH1")>
<cfset objSerialsReceipts = createObject("component", "admin.assets.cfcs.SerialsReceipts")>
<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>

<cfif NOT isDefined("FORM.ReceiptNumber") OR trim(FORM.ReceiptNumber) IS "">
	<!--- Receipt Number not entered (blank) --->
	<cflocation url="index.cfm?task=serials_shipments_apply_edit&ORDUNIQ=#urlEncodedFormat(FORM.ORDUNIQ)#&Error=Blank">
<cfelse>

	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "RCPNUMBER", trim(FORM.ReceiptNumber), True)>
	<cfset qryReceipts = objPORCPH1.searchRecords(SearchRecord, "query")>
	
	<!--- Receipt not found --->
	<cfif qryReceipts.RecordCount EQ 0>
		<cflocation url="index.cfm?task=serials_shipments_apply_edit&ORDUNIQ=#urlEncodedFormat(FORM.ORDUNIQ)#&Error=NotFound&ReceiptNumber=#FORM.ReceiptNumber#">

	<!--- Multiple receipts found for this receipt number --->
	<cfelseif qryReceipts.RecordCount GT 1>
		<cflocation url="index.cfm?task=serials_shipments_apply_edit&ORDUNIQ=#urlEncodedFormat(FORM.ORDUNIQ)#&Error=MultipleFound&ReceiptNumber=#FORM.ReceiptNumber#">

	<!--- Receipt Found --->
	<cfelse>

		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "RCPHSEQ", trim(qryReceipts.RCPHSEQ), True)>
		<cfset structInsert(SearchRecord, "Posted", 1, True)>		
		<cfset qrySerialsReceipts = objSerialsReceipts.searchRecords(SearchRecord, "query")>

		<!--- Receipt has no posted serial numbers --->
		<cfif qrySerialsReceipts.RecordCount EQ 0>
		
			<cflocation url="index.cfm?task=serials_shipments_apply_edit&ORDUNIQ=#urlEncodedFormat(FORM.ORDUNIQ)#&Error=ReceiptNoSNs&ReceiptNumber=#FORM.ReceiptNumber#">

		<!--- Process It --->
		<cfelse>

			<cfset AtLeastOneSNApplied = objSerialsShipments.applySerialNumbersFromReceipt(FORM.ORDUNIQ, qryReceipts.RCPHSEQ)>
			<cfif AtLeastOneSNApplied>
				<cfset objSerialsShipments.setMessage("Serial Numbers were successfully applied to this order from receipt number #trim(FORM.ReceiptNumber)#.")>
			<cfelse>
				<cfset objSerialsShipments.setMessage("** SERIAL NUMBERS WERE NOT APPLIED **<br>No Serial Numbers were available to be applied to this order from receipt number #trim(FORM.ReceiptNumber)#.")>
			</cfif>
			<cflocation url="index.cfm?task=serials_orders_items_list&ORDUNIQ=#urlEncodedFormat(FORM.ORDUNIQ)#">
		
		</cfif>
	
	</cfif>
	
</cfif>