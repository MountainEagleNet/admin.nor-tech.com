<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/26/2006
	Edit Date: 		10/12/2006
	Function: 		Action page, executed when any of the buttons is clicked on the serial number page
	Template:		actSerials.cfm
	Task:			serials_shipments_serials_act
--->
<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>
<cfset objSerialBatch2 = createObject("component", "admin.assets.cfcs.SerialBatch2")>

<cfset stFormCopy = duplicate(FORM)>

<!--- If this is a "Batch 2" Item, strip all non-numeric characters from the serial numbers --->
<cfset stFormCopy = objSerialBatch2.formatSerialNumbers(stFormCopy)>

<cfif NOT isDefined("stFormCopy.WhichButton")>
	<cflocation url="index.cfm?task=serials_shipments_serials_edit&ORDUNIQ=#urlEncodedFormat(stFormCopy.ORDUNIQ)#&LINENUM=#urlEncodedFormat(stFormCopy.ORDLINENUM)#">
</cfif>

<!--- CONSECUTIVE ORDER 2 was clicked --->
<cfif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Consecutive Order 2">
	<!--- Make sure the last SN box filled contains a numeric value --->
	<cfset stErrors = objSerialsShipments.validateConsecutiveOrder2(stFormCopy)>
	<cfset objSerialsShipments.setDataRecord(stFormCopy)>
	<cfset objSerialsShipments.setErrorRecord(stErrors)>
	<cfif NOT structIsEmpty(stErrors)>
		<cflocation url="index.cfm?task=serials_shipments_serials_edit&Validation=1">
	<cfelse>
		<cflocation url="index.cfm?task=serials_shipments_consec_qty">
	</cfif>

<!--- CONSECUTIVE ORDER 3 was clicked --->
<cfelseif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Consecutive Order 3">
	<!--- Make sure all SN boxes are blank --->
	<cfset stErrors = objSerialsShipments.validateConsecutiveOrder(stFormCopy)>
	<cfset objSerialsShipments.setDataRecord(stFormCopy)>
	<cfset objSerialsShipments.setErrorRecord(stErrors)>
	<cfif NOT structIsEmpty(stErrors)>
		<cflocation url="index.cfm?task=serials_shipments_serials_edit&Validation=1">
	<cfelse>
		<cflocation url="index.cfm?task=serials_shipments_consec3_qty">
	</cfif>

<!--- REPLICATE was clicked --->
<cfelseif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Replicate">
	<!--- Make sure the first SN box is not empty --->
	<cfset stErrors = objSerialsShipments.validateReplicate(stFormCopy)>
	<cfset objSerialsShipments.setDataRecord(stFormCopy)>
	<cfset objSerialsShipments.setErrorRecord(stErrors)>
	<cfif NOT structIsEmpty(stErrors)>
		<cflocation url="index.cfm?task=serials_shipments_serials_edit&Validation=1">
	<cfelse>
<!---	<cflocation url="index.cfm?task=serials_shipments_serials_edit&Replicate=1">	--->
		<cflocation url="index.cfm?task=serials_shipments_replicate_qty">
	</cfif>

<!--- SAVE & POSTPONE was clicked --->
<cfelseif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Save & Postpone">
	<cfset objSerialsShipments.saveSerialNumberInput(stFormCopy, 1)>	<!--- 1=UnpostedOnly --->
	<cfset objSerialsShipments.setMessage("Serial Numbers were successfully saved (but not posted).")>
<!---<cflocation url="index.cfm?task=serials_orders_items_list&ORDUNIQ=#urlEncodedFormat(stFormCopy.ORDUNIQ)#">	--->
	<cflocation url="index.cfm?task=serials_orders_enter">

<!--- CLEAR ALL was clicked --->
<cfelseif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Clear All">
	<cfset objSerialsShipments.deleteSerialNumbers(stFormCopy, 1)>	<!--- 1=UnpostedOnly --->
	<cflocation url="index.cfm?task=serials_shipments_serials_edit&ORDUNIQ=#urlEncodedFormat(stFormCopy.ORDUNIQ)#&LINENUM=#urlEncodedFormat(stFormCopy.ORDLINENUM)#">

<!--- CANCEL was clicked --->
<cfelseif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Cancel">
	<cflocation url="index.cfm?task=serials_orders_enter">

<!--- POST or CONTINUE was clicked --->
<cfelse>

	<!--- Check for Errors --->
<!--- 6/5/06: removing this code; duplicates are now being checked by the scanning JavaScript --->
<!---	
	<cfset stErrors = objSerialsShipments.checkForErrors(stFormCopy)>
	<cfif NOT structIsEmpty(stErrors)>
		<cfset objSerialsShipments.setDataRecord(stFormCopy)>
		<cfset objSerialsShipments.setErrorRecord(stErrors)>
		<cflocation url="index.cfm?task=serials_shipments_serials_edit&Validation=1">
	</cfif>
--->

	<!--- Check for Batch Item Error:  Make sure that the same entry is made in all of the serial number input boxes  --->
	<cfset stErrors = objSerialsShipments.checkForBatchItemError(stFormCopy)>
	<cfif NOT structIsEmpty(stErrors)>
		<cfset objSerialsShipments.setDataRecord(stFormCopy)>
		<cfset objSerialsShipments.setErrorRecord(stErrors)>
		<cflocation url="index.cfm?task=serials_shipments_serials_edit&Validation=1">
	</cfif>

	<!--- Check for Warnings --->
	<cfset stWarnings = objSerialsShipments.checkForWarnings(stFormCopy)>
	<cfif NOT structIsEmpty(stWarnings)>
		<cfset objSerialsShipments.setDataRecord(stFormCopy)>
		<cfset objSerialsShipments.setErrorRecord(stWarnings)>
		<cflocation url="index.cfm?task=serials_shipments_warning">
	</cfif>

	<cfset objSerialsShipments.setDataRecord(stFormCopy)>
	<cflocation url="index.cfm?task=serials_shipments_serials_post&RequestTimeout=6000">

</cfif>