<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/08/2007
	Function: 		Consecutive Order 3 Function, Quantity Action Page
	Template:		actCons3Quantity.cfm
	Task:			serials_shipments_consec3_qty_act
--->
<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>

<cfset stFormCopy = duplicate(FORM)>

<!--- Make sure the quantity is numeric, and that it's not greater than the # of boxes on the first page --->
<cfset stErrors = objSerialsShipments.validateConsecutiveOrder3Qty(stFormCopy)>
<cfset objSerialsShipments.setDataRecord(stFormCopy)>
<cfset objSerialsShipments.setErrorRecord(stErrors)>
<cfif NOT structIsEmpty(stErrors)>
	<cflocation url="index.cfm?task=serials_shipments_consec3_qty&Validation=1">
<cfelse>
	<cflocation url="index.cfm?task=serials_shipments_consec3_serials">
</cfif>