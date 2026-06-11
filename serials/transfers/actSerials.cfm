<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/05/2006
	Function: 		Action page, executed when any of the buttons is clicked on the serial number page
	Template:		actSerials.cfm
	Task:			serials_transfers_serials_act
--->
<cfset objSerialsTransfers = createObject("component", "admin.assets.cfcs.SerialsTransfers")>
<cfset objSerialBatch2 = createObject("component", "admin.assets.cfcs.SerialBatch2")>

<cfset stFormCopy = duplicate(FORM)>

<!--- If this is a "Batch 2" Item, strip all non-numeric characters from the serial numbers --->
<cfset stFormCopy = objSerialBatch2.formatSerialNumbers(stFormCopy)>

<cfif NOT isDefined("stFormCopy.WhichButton")>
	<cflocation url="index.cfm?task=serials_transfers_serials_edit&TRANFENSEQ=#urlEncodedFormat(stFormCopy.TRANFENSEQ)#&LINENO=#urlEncodedFormat(stFormCopy.LINENO)#">
</cfif>

<!--- CONSECUTIVE ORDER was clicked --->
<cfif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Consecutive Order">
	<!--- Make sure no serial number boxes are filled in --->
	<cfset stErrors = objSerialsTransfers.validateConsecutiveOrder(stFormCopy)>
	<cfset objSerialsTransfers.setDataRecord(stFormCopy)>
	<cfset objSerialsTransfers.setErrorRecord(stErrors)>
	<cfif NOT structIsEmpty(stErrors)>
		<cflocation url="index.cfm?task=serials_transfers_serials_edit&Validation=1">
	<cfelse>
		<cflocation url="index.cfm?task=serials_transfers_serials_edit&ConsecutiveOrder=1">
	</cfif>

<!--- CONSECUTIVE ORDER 2 was clicked --->
<cfelseif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Consecutive Order 2">
	<!--- Make sure the last SN box filled contains a numeric value --->
	<cfset stErrors = objSerialsTransfers.validateConsecutiveOrder2(stFormCopy)>
	<cfset objSerialsTransfers.setDataRecord(stFormCopy)>
	<cfset objSerialsTransfers.setErrorRecord(stErrors)>
	<cfif NOT structIsEmpty(stErrors)>
		<cflocation url="index.cfm?task=serials_transfers_serials_edit&Validation=1">
	<cfelse>
		<cflocation url="index.cfm?task=serials_transfers_consec_qty">
	</cfif>

<!--- REPLICATE was clicked --->
<cfelseif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Replicate">
	<!--- Make sure the first SN box is not empty --->
	<cfset stErrors = objSerialsTransfers.validateReplicate(stFormCopy)>
	<cfset objSerialsTransfers.setDataRecord(stFormCopy)>
	<cfset objSerialsTransfers.setErrorRecord(stErrors)>
	<cfif NOT structIsEmpty(stErrors)>
		<cflocation url="index.cfm?task=serials_transfers_serials_edit&Validation=1">
	<cfelse>
		<cflocation url="index.cfm?task=serials_transfers_serials_edit&Replicate=1">
	</cfif>

<!--- SAVE & POSTPONE was clicked --->
<cfelseif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Save & Postpone">
	<cfset objSerialsTransfers.saveSerialNumberInput(stFormCopy)>
	<cfset objSerialsTransfers.setMessage("Serial Numbers were successfully saved (but not posted).")>
	<cflocation url="index.cfm?task=serials_transfers_items_list&TRANFENSEQ=#urlEncodedFormat(stFormCopy.TRANFENSEQ)#">

<!--- CLEAR ALL was clicked --->
<cfelseif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Clear All">
	<cfset objSerialsTransfers.deleteSerialNumbers(stFormCopy)>
	<cflocation url="index.cfm?task=serials_transfers_serials_edit&TRANFENSEQ=#urlEncodedFormat(stFormCopy.TRANFENSEQ)#&LINENO=#urlEncodedFormat(stFormCopy.LINENO)#">

<!--- CANCEL was clicked --->
<cfelseif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Cancel">
	<cflocation url="index.cfm?task=serials_transfers_list">

<!--- POST was clicked --->
<cfelse>

	<!--- Check for Errors --->
<!--- 6/5/06: removing this code; duplicates are now being checked by the scanning JavaScript --->
<!---	
	<cfset stErrors = objSerialsTransfers.checkForErrors(stFormCopy)>
	<cfif NOT structIsEmpty(stErrors)>
		<cfset objSerialsTransfers.setDataRecord(stFormCopy)>
		<cfset objSerialsTransfers.setErrorRecord(stErrors)>
		<cflocation url="index.cfm?task=serials_transfers_serials_edit&Validation=1">
	</cfif>
--->
	<!--- Check for Batch Item Error:  Make sure that the same entry is made in all of the serial number input boxes  --->
	<cfset stErrors = objSerialsTransfers.checkForBatchItemError(stFormCopy)>
	<cfif NOT structIsEmpty(stErrors)>
		<cfset objSerialsTransfers.setDataRecord(stFormCopy)>
		<cfset objSerialsTransfers.setErrorRecord(stErrors)>
		<cflocation url="index.cfm?task=serials_transfers_serials_edit&Validation=1">
	</cfif>

	<!--- Check for Warnings --->
	<cfset stWarnings = objSerialsTransfers.checkForWarnings(stFormCopy)>
	<cfif NOT structIsEmpty(stWarnings)>
		<cfset objSerialsTransfers.setDataRecord(stFormCopy)>
		<cfset objSerialsTransfers.setErrorRecord(stWarnings)>
		<cflocation url="index.cfm?task=serials_transfers_warning">
	</cfif>

	<cfset objSerialsTransfers.setDataRecord(stFormCopy)>
	<cflocation url="index.cfm?task=serials_transfers_serials_post&RequestTimeout=6000">
	
</cfif>