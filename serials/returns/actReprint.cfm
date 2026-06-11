<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	10/26/2006
	Function: 		Reprint Serial Numbers Page
	Template:		actReprint.cfm
	Task:			serials_receipts_serials_reprint
--->
<cfset objSerialsReturns = createObject("component", "admin.assets.cfcs.SerialsReturns")>

<cfset stFormCopy = duplicate(Form)>

<cfset stRecord = structNew()>
<cfset structInsert(stRecord, "RMAUNIQ", stFormCopy.RMAUNIQ, True)>
<cfset structInsert(stRecord, "LINENUM", stFormCopy.LINENUM, True)>

<!--- Print Bar Code Labels --->
<cfset Success = objSerialsReturns.printBarCodeLabels(stRecord)>
<cfif Success>
	<cfset objSerialsReturns.setMessage("Bar code labels were successfully printed.")>
<cfelse>
	<cfset objSerialsReturns.setMessage("There was a problem with the printing process; bar code labels were NOT printed.")>
</cfif>

<!--- Go to the display page --->
<cflocation url="index.cfm?task=serials_returns_serials_view&RMAUNIQ=#urlEncodedFormat(stRecord.RMAUNIQ)#&LINENUM=#urlEncodedFormat(stRecord.LINENUM)#&RMAAction=#stFormCopy.RMAAction#">