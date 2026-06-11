<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	01/06/2011
	Function: 		Consecutive Order 3 Function, Quantity Action Page
	Template:		actCons3Quantity.cfm
	Task:			serials_counts_consec3_qty_act
--->
<cfset objSerialsCounts = createObject("component", "admin.assets.cfcs.SerialsCounts")>

<cfset stFormCopy = duplicate(FORM)>

<!--- Make sure the quantity is numeric, and that it's not greater than the # of boxes on the first page --->
<cfset stErrors = objSerialsCounts.validateConsecutiveOrder3Qty(stFormCopy)>
<cfset objSerialsCounts.setDataRecord(stFormCopy)>
<cfset objSerialsCounts.setErrorRecord(stErrors)>
<cfif NOT structIsEmpty(stErrors)>
	<cflocation url="index.cfm?task=serials_counts_consec3_qty&Validation=1">
<cfelse>
	<cflocation url="index.cfm?task=serials_counts_consec3_serials">
</cfif>