<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/05/2006
	Function: 		Serial Number Posting Page
	Template:		actPost.cfm
	Task:			serials_transfers_serials_post
--->
<cfset objSerialsTransfers = createObject("component", "admin.assets.cfcs.SerialsTransfers")>

<cfset stRecord = objSerialsTransfers.getDataRecord()>

<cfset objICTREH = createObject("component", "admin.assets.cfcs.ICTREH")>
<cfset strICTREH = objICTREH.getRecord(stRecord.TRANFENSEQ)>
<cfset structInsert(stRecord, "TransactionNumber", strICTREH.DOCNUM, True)>

<!--- Save Serial Numbers to tblSerialsTransfers --->
<cfset objSerialsTransfers.saveSerialNumberInput(stRecord)>

<!--- Set the "posted" flag for all records in tblSerialsTransfers --->
<cfset objSerialsTransfers.setPosted(stRecord)>

<!--- Update Serial Number Location --->
<cfset objSerialsTransfers.updateSerialNumbers(stRecord)>

<!--- Create Audit Trail entries in tblSerialNumberAuditTrail --->
<cfset objSerialsTransfers.createAuditTrail(stRecord, "TransferDecrease")>
<cfset objSerialsTransfers.createAuditTrail(stRecord, "TransferIncrease")>

<cfset objSerialsTransfers.setMessage("Serial Numbers were posted successfully.")>

<!--- Go to the display page --->
<cflocation url="index.cfm?task=serials_transfers_serials_view&TRANFENSEQ=#urlEncodedFormat(stRecord.TRANFENSEQ)#&LINENO=#urlEncodedFormat(stRecord.LINENO)#">