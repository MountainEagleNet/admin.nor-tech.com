<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	07/03/2007
	Function: 		Action page for the Replicate function
	Template:		actReplicate.cfm
	Task:			serials_shipments_replicate_act
--->

<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>

<cfset stRecord = objSerialsShipments.getDataRecord()>

<cfset stFormCopy = duplicate(FORM)>

<!--- Make sure a numeric value was entered in the Replicate Quantity field --->
<cfif NOT isDefined("stFormCopy.ReplicateQuantity")>
	<cfset stFormCopy.ReplicateQuantity = stRecord.RemainingQuantity>
</cfif>
<cfif NOT isNumeric(stFormCopy.ReplicateQuantity)>
	<cflocation url="index.cfm?task=serials_shipments_replicate_qty&QuantityError=1">

<!--- Make sure the Replicate Quantity is not greater than the quantity remaining --->
<cfelseif isNumeric(stRecord.RemainingQuantity) AND stFormCopy.ReplicateQuantity GT stRecord.RemainingQuantity>
	<cflocation url="index.cfm?task=serials_shipments_replicate_qty&TooMuchError=1">

</cfif>

<cfset stRecord = objSerialsShipments.replicate(stRecord, stFormCopy.ReplicateQuantity)>

<!--- Check for Batch Item Error:  Make sure that the same entry is made in all of the serial number input boxes  --->
<cfset stErrors = objSerialsShipments.checkForBatchItemError(stRecord)>
<cfif NOT structIsEmpty(stErrors)>
	<cfset objSerialsShipments.setDataRecord(stRecord)>
	<cfset objSerialsShipments.setErrorRecord(stErrors)>
	<cflocation url="index.cfm?task=serials_shipments_serials_edit&Validation=1">
</cfif>

<!--- Check for Warnings --->
<cfset stWarnings = objSerialsShipments.checkForWarnings(stRecord)>
<cfif NOT structIsEmpty(stWarnings)>
	<cfset objSerialsShipments.setDataRecord(stRecord)>
	<cfset objSerialsShipments.setErrorRecord(stWarnings)>
	<cflocation url="index.cfm?task=serials_shipments_warning">
</cfif>

<cfset objSerialsShipments.setDataRecord(stRecord)>
<cflocation url="index.cfm?task=serials_shipments_serials_post&RequestTimeout=6000">