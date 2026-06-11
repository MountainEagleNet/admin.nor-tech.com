<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	07/19/2007
	Function: 		Apply serial numbers from receipt: Action Page
	Template:		actSerialsCopy.cfm
	Task:			serials_adjustments_serials_copy_act
--->
<cfset objPORCPH1 = createObject("component", "admin.assets.cfcs.PORCPH1")>
<cfset objSerialsReceipts = createObject("component", "admin.assets.cfcs.SerialsReceipts")>
<cfset objSerialsAdjustments = createObject("component", "admin.assets.cfcs.SerialsAdjustments")>

<cfif NOT isDefined("FORM.ReceiptNumber") OR trim(FORM.ReceiptNumber) IS "">
	<!--- Receipt Number not entered (blank) --->
	<cflocation url="index.cfm?task=serials_adjustments_serials_copy_edit&ADJENSEQ=#urlEncodedFormat(FORM.ADJENSEQ)#&Error=Blank">
<cfelse>

	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "RCPNUMBER", trim(FORM.ReceiptNumber), True)>
	<cfset qryReceipts = objPORCPH1.searchRecords(SearchRecord, "query")>
	
	<!--- Receipt not found --->
	<cfif qryReceipts.RecordCount EQ 0>
		<cflocation url="index.cfm?task=serials_adjustments_serials_copy_edit&ADJENSEQ=#urlEncodedFormat(FORM.ADJENSEQ)#&Error=NotFound&ReceiptNumber=#FORM.ReceiptNumber#">

	<!--- Multiple receipts found for this receipt number --->
	<cfelseif qryReceipts.RecordCount GT 1>
		<cflocation url="index.cfm?task=serials_adjustments_serials_copy_edit&ADJENSEQ=#urlEncodedFormat(FORM.ADJENSEQ)#&Error=MultipleFound&ReceiptNumber=#FORM.ReceiptNumber#">

	<!--- Receipt Found --->
	<cfelse>

		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "RCPHSEQ", trim(qryReceipts.RCPHSEQ), True)>
		<cfset structInsert(SearchRecord, "Posted", 1, True)>		
		<cfset qrySerialsReceipts = objSerialsReceipts.searchRecords(SearchRecord, "query")>

		<!--- Receipt has no posted serial numbers --->
		<cfif qrySerialsReceipts.RecordCount EQ 0>
		
			<cflocation url="index.cfm?task=serials_adjustments_serials_copy_edit&ADJENSEQ=#urlEncodedFormat(FORM.ADJENSEQ)#&Error=ReceiptNoSNs&ReceiptNumber=#FORM.ReceiptNumber#">

		<!--- Process It --->
		<cfelse>

			<cfset AtLeastOneSNApplied = objSerialsAdjustments.applySerialNumbersFromReceipt(FORM.ADJENSEQ, qryReceipts.RCPHSEQ)>
			<cfif AtLeastOneSNApplied>
				<cfset objSerialsAdjustments.setMessage("Serial Numbers were successfully copied to this adjustment from receipt number #trim(FORM.ReceiptNumber)#.")>
			<cfelse>
				<cfset objSerialsAdjustments.setMessage("** SERIAL NUMBERS WERE NOT COPIED **<br>No Serial Numbers were available to be copied to this adjustment from receipt number #trim(FORM.ReceiptNumber)#.")>
			</cfif>
			<cflocation url="index.cfm?task=serials_adjustments_items_list&ADJENSEQ=#urlEncodedFormat(FORM.ADJENSEQ)#">
		
		</cfif>
	
	</cfif>
	
</cfif>