<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/03/2006
	Function: 		Action page, executed when any of the buttons is clicked on the serial number page
	Template:		actSerials.cfm
	Task:			serials_returnsvendor_serials_act
--->
<cfset objSerialsVendorReturns = createObject("component", "admin.assets.cfcs.SerialsVendorReturns")>
<cfset objSerialBatch2 = createObject("component", "admin.assets.cfcs.SerialBatch2")>

<cfset stFormCopy = duplicate(FORM)>

<!--- If this is a "Batch 2" Item, strip all non-numeric characters from the serial numbers --->
<cfset stFormCopy = objSerialBatch2.formatSerialNumbers(stFormCopy)>

<cfif NOT isDefined("stFormCopy.WhichButton")>
	<cflocation url="index.cfm?task=serials_returnsvendor_serials_edit&RETHSEQ=#urlEncodedFormat(stFormCopy.RETHSEQ)#&RETLREV=#urlEncodedFormat(stFormCopy.RETLREV)#">
</cfif>

<!--- CONSECUTIVE ORDER 2 was clicked --->
<cfif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Consecutive Order 2">
	<!--- Make sure the last SN box filled contains a numeric value --->
	<cfset stErrors = objSerialsVendorReturns.validateConsecutiveOrder2(stFormCopy)>
	<cfset objSerialsVendorReturns.setDataRecord(stFormCopy)>
	<cfset objSerialsVendorReturns.setErrorRecord(stErrors)>
	<cfif NOT structIsEmpty(stErrors)>
		<cflocation url="index.cfm?task=serials_returnsvendor_serials_edit&Validation=1">
	<cfelse>
		<cflocation url="index.cfm?task=serials_returnsvendor_consec_qty">
	</cfif>

<!--- REPLICATE was clicked --->
<cfelseif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Replicate">
	<!--- Make sure the first SN box is not empty --->
	<cfset stErrors = objSerialsVendorReturns.validateReplicate(stFormCopy)>
	<cfset objSerialsVendorReturns.setDataRecord(stFormCopy)>
	<cfset objSerialsVendorReturns.setErrorRecord(stErrors)>
	<cfif NOT structIsEmpty(stErrors)>
		<cflocation url="index.cfm?task=serials_returnsvendor_serials_edit&Validation=1">
	<cfelse>
		<cflocation url="index.cfm?task=serials_returnsvendor_serials_edit&Replicate=1">
	</cfif>

<!--- SAVE & POSTPONE was clicked --->
<cfelseif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Save & Postpone">
	<cfset objSerialsVendorReturns.saveSerialNumberInput(stFormCopy)>
	<cfset objSerialsVendorReturns.setMessage("Serial Numbers were successfully saved (but not posted).")>
	<cflocation url="index.cfm?task=serials_returnsvendor_items_list&RETHSEQ=#urlEncodedFormat(stFormCopy.RETHSEQ)#">

<!--- CLEAR ALL was clicked --->
<cfelseif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Clear All">
	<cfset objSerialsVendorReturns.deleteSerialNumbers(stFormCopy)>
	<cflocation url="index.cfm?task=serials_returnsvendor_serials_edit&RETHSEQ=#urlEncodedFormat(stFormCopy.RETHSEQ)#&RETLREV=#urlEncodedFormat(stFormCopy.RETLREV)#&NumberOfBoxes=#stFormCopy.NumberOfBoxes#">

<!--- ADD was clicked --->
<cfelseif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Add">
	<cfset stErrors = structNew()>
	<cfset objSerialsVendorReturns.setDataRecord(stFormCopy)>
	<cfset objSerialsVendorReturns.setErrorRecord(stErrors)>
	<cflocation url="index.cfm?task=serials_returnsvendor_serials_add">

<!--- CANCEL was clicked --->
<cfelseif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Cancel">
	<cflocation url="index.cfm?task=serials_returnsvendor_list">

<!--- POST was clicked --->
<cfelse>

	<!--- Check for Errors --->
<!--- 6/5/06: removing this code; duplicates are now being checked by the scanning JavaScript --->
<!---	
	<cfset stErrors = objSerialsVendorReturns.checkForErrors(stFormCopy)>
	<cfif NOT structIsEmpty(stErrors)>
		<cfset objSerialsVendorReturns.setDataRecord(stFormCopy)>
		<cfset objSerialsVendorReturns.setErrorRecord(stErrors)>
		<cflocation url="index.cfm?task=serials_returnsvendor_serials_edit&Validation=1">
	</cfif>
--->
	<!--- Check for Batch Item Error:  Make sure that the same entry is made in all of the serial number input boxes  --->
	<cfset stErrors = objSerialsVendorReturns.checkForBatchItemError(stFormCopy)>
	<cfif NOT structIsEmpty(stErrors)>
		<cfset objSerialsVendorReturns.setDataRecord(stFormCopy)>
		<cfset objSerialsVendorReturns.setErrorRecord(stErrors)>
		<cflocation url="index.cfm?task=serials_returnsvendor_serials_edit&Validation=1">
	</cfif>

	<!--- Check for Warnings --->
	<cfset stWarnings = objSerialsVendorReturns.checkForWarnings(stFormCopy)>
	<cfif NOT structIsEmpty(stWarnings)>
		<cfset objSerialsVendorReturns.setDataRecord(stFormCopy)>
		<cfset objSerialsVendorReturns.setErrorRecord(stWarnings)>
		<cflocation url="index.cfm?task=serials_returnsvendor_warning">
	</cfif>
	<cfset objSerialsVendorReturns.setDataRecord(stFormCopy)>
	<cflocation url="index.cfm?task=serials_returnsvendor_serials_post&RequestTimeout=6000">
	
</cfif>