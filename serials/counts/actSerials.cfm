<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/08/2006
	Function: 		Action page, executed when any of the buttons is clicked on the serial number page
	Template:		actSerials.cfm
	Task:			serials_adjustments_serials_act
--->
<cfset objSerialsCounts = createObject("component", "admin.assets.cfcs.SerialsCounts")>
<cfset objCounts = createObject("component", "admin.assets.cfcs.Counts")>
<cfset objSerialBatch2 = createObject("component", "admin.assets.cfcs.SerialBatch2")>

<cfif isDefined("URL.ConsecutiveOrder3")>
	<cfset stFormCopy = objSerialsCounts.getDataRecord()>
<cfelse>
	<cfset stFormCopy = duplicate(FORM)>
</cfif>

<!--- If this is a "Batch 2" Item, strip all non-numeric characters from the serial numbers --->
<cfset stFormCopy = objSerialBatch2.formatSerialNumbers(stFormCopy)>

<cfif NOT isDefined("stFormCopy.WhichButton")>
	<cflocation url="index.cfm?task=serials_counts_serials_edit">
</cfif>

<!--- CONSECUTIVE ORDER 2 was clicked --->
<cfif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Consecutive Order 2">
	<!--- Make sure the last SN box filled contains a numeric value --->
	<cfset stErrors = objSerialsCounts.validateConsecutiveOrder2(stFormCopy)>
	<cfset objSerialsCounts.setDataRecord(stFormCopy)>
	<cfset objSerialsCounts.setErrorRecord(stErrors)>
	<cfif NOT structIsEmpty(stErrors)>
		<cflocation url="index.cfm?task=serials_counts_serials_edit&Validation=1">
	<cfelse>
		<cflocation url="index.cfm?task=serials_counts_consec_qty">
	</cfif>

<!--- CONSECUTIVE ORDER 3 was clicked --->
<cfelseif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Consecutive Order 3">
	<!--- Make sure all SN boxes are blank --->
	<cfset stErrors = objSerialsCounts.validateConsecutiveOrder(stFormCopy)>
	<cfset objSerialsCounts.setDataRecord(stFormCopy)>
	<cfset objSerialsCounts.setErrorRecord(stErrors)>
	<cfif NOT structIsEmpty(stErrors)>
		<cflocation url="index.cfm?task=serials_counts_serials_edit&Validation=1">
	<cfelse>
		<cflocation url="index.cfm?task=serials_counts_consec3_qty">
	</cfif>

<!--- REPLICATE was clicked --->
<cfelseif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Replicate">
	<!--- Make sure the first SN box is not empty --->
	<cfset stErrors = objSerialsCounts.validateReplicate(stFormCopy)>
	<cfset objSerialsCounts.setDataRecord(stFormCopy)>
	<cfset objSerialsCounts.setErrorRecord(stErrors)>
	<cfif NOT structIsEmpty(stErrors)>
		<cflocation url="index.cfm?task=serials_counts_serials_edit&Validation=1">
	<cfelse>
		<cflocation url="index.cfm?task=serials_counts_serials_edit&Replicate=1">
	</cfif>

<!--- SAVE & POSTPONE was clicked --->
<cfelseif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Save & Postpone">

	<!--- Save data to tblCounts --->
	<cfset CountsID = objCounts.saveRecord(stFormCopy, 1)>		<!--- 1=SaveAndPostpone --->

	<!--- Save Serial Numbers to tblSerialsCounts --->
	<cfset structInsert(stFormCopy, "CountsID", CountsID, True)>
	<cfset objSerialsCounts.saveSerialNumberInput(stFormCopy, 1)>	<!--- 1=SaveAndPostpone --->
	
	<cfset objSerialsCounts.setMessage("Serial Numbers were successfully saved (but not posted).")>
	<cflocation url="index.cfm?task=serials_counts_enter">

<!--- ADD was clicked --->
<cfelseif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Add">
	<cfset stErrors = structNew()>
	<cfset objSerialsCounts.setDataRecord(stFormCopy)>
	<cfset objSerialsCounts.setErrorRecord(stErrors)>
	<cflocation url="index.cfm?task=serials_counts_serials_add">

<!--- CANCEL was clicked --->
<cfelseif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Cancel">
	<cflocation url="index.cfm?task=serials_counts_enter">

<!--- POST or CONTINUE was clicked --->
<cfelse>

	<!--- Check for Errors --->
<!--- 6/5/06: removing this code; duplicates are now being checked by the scanning JavaScript --->
<!---	
	<cfset stErrors = objSerialsCounts.checkForErrors(stFormCopy)>
	<cfif NOT structIsEmpty(stErrors)>
		<cfset objSerialsCounts.setDataRecord(stFormCopy)>
		<cfset objSerialsCounts.setErrorRecord(stErrors)>
		<cflocation url="index.cfm?task=serials_counts_serials_edit&Validation=1">
	</cfif>
--->
	<!--- Check for Batch Item Error:  Make sure that the same entry is made in all of the serial number input boxes  --->
	<cfset stErrors = objSerialsCounts.checkForBatchItemError(stFormCopy)>
	<cfif NOT structIsEmpty(stErrors)>
		<cfset objSerialsCounts.setDataRecord(stFormCopy)>
		<cfset objSerialsCounts.setErrorRecord(stErrors)>
		<cflocation url="index.cfm?task=serials_counts_serials_edit&Validation=1">
	</cfif>

	<!--- Check for Duplicates --->
	<cfset stErrors = objSerialsCounts.checkForDuplicates(stFormCopy)>
	<cfif NOT structIsEmpty(stErrors)>
		<cfset objSerialsCounts.setDataRecord(stFormCopy)>
		<cfset objSerialsCounts.setErrorRecord(stErrors)>
		<cflocation url="index.cfm?task=serials_counts_serials_edit&Validation=1">
	</cfif>

	<!--- Check for Warnings --->
	<cfset stWarnings = objSerialsCounts.checkForWarnings(stFormCopy)>
	<cfif NOT structIsEmpty(stWarnings)>
		<cfset objSerialsCounts.setDataRecord(stFormCopy)>
		<cfset objSerialsCounts.setErrorRecord(stWarnings)>
		<cfif isDefined("URL.ConsecutiveOrder3")>
			<cfset CameFromConsecutiveOrder3 = 1>
		<cfelse>
			<cfset CameFromConsecutiveOrder3 = 0>
		</cfif>
		<cflocation url="index.cfm?task=serials_counts_warning&CameFromConsecutiveOrder3=#CameFromConsecutiveOrder3#">
	</cfif>

	<cfset objSerialsCounts.setDataRecord(stFormCopy)>
<!---<cflocation url="index.cfm?task=serials_counts_serials_confirm&RequestTimeout=6000">--->
	<cflocation url="index.cfm?task=serials_counts_serials_post&RequestTimeout=6000">

</cfif>