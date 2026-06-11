<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	10/17/2006
	Function: 		Remove receipt from the list
	Template:		actRemove.cfm
	Task:			serials_receipts_list_remove
--->

<cfset objSerialsReceipts = createObject("component", "admin.assets.cfcs.SerialsReceipts")>
<cfset objSerialsReceiptsExclude = createObject("component", "admin.assets.cfcs.SerialsReceiptsExclude")>

<cfset stFormCopy = duplicate(FORM)>

<!--- BACK was clicked --->
<cfif NOT isDefined("stFormCopy.WhichButton") OR stFormCopy.WhichButton IS "Back">
	<cflocation url="index.cfm?task=serials_receipts_list&ShowReceiptsList=1&RequestTimeout=6000">

<!--- CONTINUE was clicked --->
<cfelse>
	<cfset strSerialsReceiptsExclude = objSerialsReceiptsExclude.newRecord()>
	<cfset structInsert(strSerialsReceiptsExclude, "RCPHSEQ", stFormCopy.RCPHSEQ, True)>
	<cfset structInsert(strSerialsReceiptsExclude, "RemoveComment", stFormCopy.RemoveComment, True)>
	<cfset objSerialsReceiptsExclude.saveRecord(strSerialsReceiptsExclude)>
	<cfset objSerialsReceipts.setMessage("The receipt was successfully removed from the list.")>
	<cflocation url="index.cfm?task=serials_receipts_list">
</cfif>