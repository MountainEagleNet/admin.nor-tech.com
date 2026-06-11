<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	10/26/2006
	Function: 		Reprint Serial Numbers Page
	Template:		actReprint.cfm
	Task:			serials_receipts_serials_reprint
--->
<cfset objSerialsReceipts = createObject("component", "admin.assets.cfcs.SerialsReceipts")>

<cfset stFormCopy = duplicate(Form)>

<cfset stRecord = structNew()>
<cfset structInsert(stRecord, "RCPHSEQ", stFormCopy.RCPHSEQ, True)>
<cfset structInsert(stRecord, "RCPLREV", stFormCopy.RCPLREV, True)>

<!---
stRecord:<cfdump var="#stRecord#"><br>
<cfabort>
--->

<!--- Print Bar Code Labels --->
<cfset Success = objSerialsReceipts.printBarCodeLabels(stRecord)>
<cfif Success>
	<cfset objSerialsReceipts.setMessage("Bar code labels were successfully printed.")>
<cfelse>
	<cfset objSerialsReceipts.setMessage("There was a problem with the printing process; bar code labels were NOT printed.")>
</cfif>

<!--- Go to the display page --->
<cflocation url="index.cfm?task=serials_receipts_serials_view&RCPHSEQ=#urlEncodedFormat(stRecord.RCPHSEQ)#&RCPLREV=#urlEncodedFormat(stRecord.RCPLREV)#">