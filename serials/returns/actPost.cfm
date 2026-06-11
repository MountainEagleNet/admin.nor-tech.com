<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/28/2006
	Function: 		Serial Number Posting Page
	Template:		actPost.cfm
	Task:			serials_returns_serials_post
--->
<cfset objSerialsReturns = createObject("component", "admin.assets.cfcs.SerialsReturns")>

<cfset stRecord = objSerialsReturns.getDataRecord()>

<cfset objRAHEAD = createObject("component", "admin.assets.cfcs.RAHEAD")>
<cfset strRAHEAD = objRAHEAD.getRecord(stRecord.RMAUNIQ)>
<cfset structInsert(stRecord, "TransactionNumber", strRAHEAD.RMANUMBER, True)>
<cfset structInsert(stRecord, "CUSTOMER", strRAHEAD.CUSTOMER, True)>
<cfset structInsert(stRecord, "BILNAME", strRAHEAD.BILNAME, True)>

<!--- Save Serial Numbers to tblSerialsReturns --->
<cfset objSerialsReturns.saveSerialNumberInput(stRecord)>

<!--- Set the "posted" flag for all records in tblSerialsReturns --->
<cfset objSerialsReturns.setPosted(stRecord)>

<!--- Add Serial Numbers to tblSerials --->
<cfset objSerialsReturns.addSerialNumbers(stRecord)>

<!--- Create Audit Trail entries in tblSerialNumberAuditTrail --->
<cfset objSerialsReturns.createAuditTrail(stRecord, "Return")>

<cfset objSerialsReturns.setMessage("Serial Numbers were posted successfully.")>

<!--- Print Bar Code Labels --->
<cfif structKeyExists(stRecord, "PrintBarCodeLabels") AND stRecord.PrintBarCodeLabels EQ 1>
	<cfset Success = objSerialsReturns.printBarCodeLabels(stRecord)>
	<cfif Success>
		<cfset objSerialsReturns.setMessage("Serial Numbers were posted successfully, and bar code labels were printed.")>
	<cfelse>
		<cfset objSerialsReturns.setMessage("Serial Numbers were posted successfully, but there was a problem with the printing process; bar code labels were NOT printed.")>
	</cfif>
</cfif>

<!--- If not all items for this RMA have been posted, find the first non-posted one and go directly to frmSerials --->
<cfset FirstUnpostedLINENUM = objSerialsReturns.getFirstUnpostedItem(stRecord.RMAUNIQ, stRecord.LINENUM, stRecord.RMAACTION)>
<cfif FirstUnpostedLINENUM IS NOT "">
	<cfif stRecord.RMAACTION IS "Authorization">
		<cfset SerialTask = "serials_returns_serialsauth_edit">
	<cfelse>
		<cfset SerialTask = "serials_returns_serialsrcv_edit">
	</cfif>
	<cflocation url="index.cfm?task=#SerialTask#&RMAUNIQ=#urlEncodedFormat(stRecord.RMAUNIQ)#&LINENUM=#urlEncodedFormat(FirstUnpostedLINENUM)#&RMAAction=#stRecord.RMAAction#">

<!--- Otherwise, go directly to the display page --->
<cfelse>
	<cflocation url="index.cfm?task=serials_returns_serials_view&RMAUNIQ=#urlEncodedFormat(stRecord.RMAUNIQ)#&LINENUM=#urlEncodedFormat(stRecord.LINENUM)#&RMAAction=#stRecord.RMAAction#&PostingAll=1">
</cfif>