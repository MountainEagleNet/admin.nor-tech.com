<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/03/2006
	Function: 		Action page, executed when any of the buttons is clicked on the serial number page
	Template:		actSerials.cfm
	Task:			serials_adjustments_serials_act
--->
<cfset objSerialsAdjustments = createObject("component", "admin.assets.cfcs.SerialsAdjustments")>
<cfset objSerialBatch2 = createObject("component", "admin.assets.cfcs.SerialBatch2")>

<cfset stFormCopy = duplicate(FORM)>

<!--- If this is a "Batch 2" Item, strip all non-numeric characters from the serial numbers --->
<cfset stFormCopy = objSerialBatch2.formatSerialNumbers(stFormCopy)>

<cfparam name="stFormCopy.PrintBarCodeLabels" default="">

<cfif NOT isDefined("stFormCopy.WhichButton")>
	<cflocation url="index.cfm?task=serials_adjustments_serials_edit&ADJENSEQ=#urlEncodedFormat(stFormCopy.ADJENSEQ)#&LINENO=#urlEncodedFormat(stFormCopy.LINENO)#">
</cfif>

<!--- CONSECUTIVE ORDER was clicked --->
<cfif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Consecutive Order">
	<!--- Make sure no serial number boxes are filled in --->
	<cfset stErrors = objSerialsAdjustments.validateConsecutiveOrder(stFormCopy)>
	<cfset objSerialsAdjustments.setDataRecord(stFormCopy)>
	<cfset objSerialsAdjustments.setErrorRecord(stErrors)>
	<cfif NOT structIsEmpty(stErrors)>
		<cflocation url="index.cfm?task=serials_adjustments_serials_edit&Validation=1">
	<cfelse>
		<cflocation url="index.cfm?task=serials_adjustments_serials_edit&ConsecutiveOrder=1">
	</cfif>

<!--- CONSECUTIVE ORDER 2 was clicked --->
<cfelseif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Consecutive Order 2">
	<!--- Make sure the last SN box filled contains a numeric value --->
	<cfset stErrors = objSerialsAdjustments.validateConsecutiveOrder2(stFormCopy)>
	<cfset objSerialsAdjustments.setDataRecord(stFormCopy)>
	<cfset objSerialsAdjustments.setErrorRecord(stErrors)>
	<cfif NOT structIsEmpty(stErrors)>
		<cflocation url="index.cfm?task=serials_adjustments_serials_edit&Validation=1">
	<cfelse>
		<cflocation url="index.cfm?task=serials_adjustments_consec_qty">
	</cfif>

<!--- REPLICATE was clicked --->
<cfelseif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Replicate">
	<!--- Make sure the first SN box is not empty --->
	<cfset stErrors = objSerialsAdjustments.validateReplicate(stFormCopy)>
	<cfset objSerialsAdjustments.setDataRecord(stFormCopy)>
	<cfset objSerialsAdjustments.setErrorRecord(stErrors)>
	<cfif NOT structIsEmpty(stErrors)>
		<cflocation url="index.cfm?task=serials_adjustments_serials_edit&Validation=1">
	<cfelse>
		<cflocation url="index.cfm?task=serials_adjustments_serials_edit&Replicate=1">
	</cfif>

<!--- SAVE & POSTPONE was clicked --->
<cfelseif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Save & Postpone">
	<cfset objSerialsAdjustments.saveSerialNumberInput(stFormCopy)>
	<cfset objSerialsAdjustments.setMessage("Serial Numbers were successfully saved (but not posted).")>
	<cflocation url="index.cfm?task=serials_adjustments_items_list&ADJENSEQ=#urlEncodedFormat(stFormCopy.ADJENSEQ)#">

<!--- CLEAR ALL was clicked --->
<cfelseif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Clear All">

	<cfset objSerialsAdjustments.deleteSerialNumbers(stFormCopy)>
	<cflocation url="index.cfm?task=serials_adjustments_serials_edit&ADJENSEQ=#urlEncodedFormat(stFormCopy.ADJENSEQ)#&LINENO=#urlEncodedFormat(stFormCopy.LINENO)#">

<!--- CANCEL was clicked --->
<cfelseif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Cancel">
	<cflocation url="index.cfm?task=serials_adjustments_list">

<!--- POST was clicked --->
<cfelse>

	<!--- Check for Errors --->
<!--- 6/5/06: removing this code; duplicates are now being checked by the scanning JavaScript --->
<!---
	<cfset stErrors = objSerialsAdjustments.checkForErrors(stFormCopy)>
	<cfif NOT structIsEmpty(stErrors)>
		<cfset objSerialsAdjustments.setDataRecord(stFormCopy)>
		<cfset objSerialsAdjustments.setErrorRecord(stErrors)>
		<cflocation url="index.cfm?task=serials_adjustments_serials_edit&Validation=1">
	</cfif>
--->
	<!--- Check for Batch Item Error:  Make sure that the same entry is made in all of the serial number input boxes  --->
	<cfset stErrors = objSerialsAdjustments.checkForBatchItemError(stFormCopy)>
	<cfif NOT structIsEmpty(stErrors)>
		<cfset objSerialsAdjustments.setDataRecord(stFormCopy)>
		<cfset objSerialsAdjustments.setErrorRecord(stErrors)>
		<cflocation url="index.cfm?task=serials_adjustments_serials_edit&Validation=1">
	</cfif>

	<!--- Check for Warnings --->
	<cfset stWarnings = objSerialsAdjustments.checkForWarnings(stFormCopy)>
	<cfif NOT structIsEmpty(stWarnings)>
		<cfset objSerialsAdjustments.setDataRecord(stFormCopy)>
		<cfset objSerialsAdjustments.setErrorRecord(stWarnings)>
		<cflocation url="index.cfm?task=serials_adjustments_warning">
	</cfif>

	<cfset objSerialsAdjustments.setDataRecord(stFormCopy)>
	<cflocation url="index.cfm?task=serials_adjustments_serials_confirm">

</cfif>