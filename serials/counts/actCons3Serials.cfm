<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	01/06/2011
	Function: 		Consecutive Order 3 Function, Serial Number Action Page
	Template:		actCons3Serials.cfm
	Task:			serials_counts_consec3_serials_act
--->
<cfset objSerialsCounts = createObject("component", "admin.assets.cfcs.SerialsCounts")>

<cfset stFormCopy = duplicate(FORM)>

<cfset stErrors = objSerialsCounts.validateConsecutiveOrder3(stFormCopy)>

<cfif NOT structIsEmpty(stErrors)>
	<cfset objSerialsCounts.setDataRecord(stFormCopy)>
	<cfset objSerialsCounts.setErrorRecord(stErrors)>
	<cfset objSerialsCounts.setMessage("Please correct the errors indicated below.")>
	<cflocation url="index.cfm?task=serials_counts_consec3_serials&Validation=1">
<cfelse>

	<cfset stRecord = objSerialsCounts.consecutiveOrder3(stFormCopy)>

	<cfset structInsert(stRecord, "WhichButton", "Post", True)>
	<cfset structInsert(stRecord, "ReadyToPost", 1, True)>
	
	<cfset objSerialsCounts.setDataRecord(stRecord)>
	<cflocation url="index.cfm?task=serials_counts_serials_act&ConsecutiveOrder3=1&RequestTimeout=6000">
</cfif>