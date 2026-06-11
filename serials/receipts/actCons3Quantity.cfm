<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/07/2007
	Function: 		Consecutive Order 3 Function, Quantity Action Page
	Template:		actCons3Quantity.cfm
	Task:			serials_receipts_consec3_qty_act
--->
<cfset objSerialsReceipts = createObject("component", "admin.assets.cfcs.SerialsReceipts")>

<cfset stFormCopy = duplicate(FORM)>

<!--- Make sure the quantity is numeric, and that it's not greater than the # of boxes on the first page --->
<cfset stErrors = objSerialsReceipts.validateConsecutiveOrder3Qty(stFormCopy)>
<cfset objSerialsReceipts.setDataRecord(stFormCopy)>
<cfset objSerialsReceipts.setErrorRecord(stErrors)>
<cfif NOT structIsEmpty(stErrors)>
	<cflocation url="index.cfm?task=serials_receipts_consec3_qty&Validation=1">
<cfelse>
	<cflocation url="index.cfm?task=serials_receipts_consec3_serials">
</cfif>