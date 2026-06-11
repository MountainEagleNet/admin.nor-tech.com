<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/07/2007
	Function: 		Consecutive Order 3 Function, Serial Number Action Page
	Template:		actCons3Serials.cfm
	Task:			serials_receipts_consec3_serials_act
--->
<cfsetting requesttimeout="12000">

<cfset objSerialsReceipts = createObject("component", "admin.assets.cfcs.SerialsReceipts")>

<cfset stFormCopy = duplicate(FORM)>

<cfset stErrors = objSerialsReceipts.validateConsecutiveOrder3(stFormCopy)>

<cfif NOT structIsEmpty(stErrors)>
	<cfset objSerialsReceipts.setDataRecord(stFormCopy)>
	<cfset objSerialsReceipts.setErrorRecord(stErrors)>
	<cfset objSerialsReceipts.setMessage("Please correct the errors indicated below.")>
	<cflocation url="index.cfm?task=serials_receipts_consec3_serials&Validation=1">
<cfelse>
	<cfset stRecord = objSerialsReceipts.consecutiveOrder3(stFormCopy)>
	
	<cfset structInsert(stRecord, "WhichButton", "Post", True)>
	<cfset structInsert(stRecord, "ReadyToPost", 1, True)>
	
	<cfset objSerialsReceipts.setDataRecord(stRecord)>
	<cflocation url="index.cfm?task=serials_receipts_serials_act&ConsecutiveOrder3=1&RequestTimeout=12000">
</cfif>