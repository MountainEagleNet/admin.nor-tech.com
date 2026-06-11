<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/03/2006
	Function: 		Serial Number Posting Page
	Template:		actPost.cfm
	Task:			serials_returnsvendor_serials_post
--->
<cfset objSerialsVendorReturns = createObject("component", "admin.assets.cfcs.SerialsVendorReturns")>

<cfset stRecord = objSerialsVendorReturns.getDataRecord()>

<cfset objPORETH1 = createObject("component", "admin.assets.cfcs.PORETH1")>
<cfset strPORETH1 = objPORETH1.getRecord(stRecord.RETHSEQ)>
<cfset structInsert(stRecord, "TransactionNumber", strPORETH1.RETNUMBER, True)>
<cfset structInsert(stRecord, "VDCODE", strPORETH1.VDCODE, True)>
<cfset structInsert(stRecord, "VDNAME", strPORETH1.VDNAME, True)>

<!--- Save Serial Numbers to tblSerialsVendorReturns --->
<cfset objSerialsVendorReturns.saveSerialNumberInput(stRecord)>

<!--- Set the "posted" flag for all records in tblSerialsVendorReturns --->
<cfset objSerialsVendorReturns.setPosted(stRecord)>

<!--- Remove Serial Numbers from tblSerials --->
<cfset objSerialsVendorReturns.removeSerialNumbers(stRecord)>

<!--- Create Audit Trail entries in tblSerialNumberAuditTrail --->
<cfset objSerialsVendorReturns.createAuditTrail(stRecord, "VendorReturn")>

<cfset objSerialsVendorReturns.setMessage("Serial Numbers were posted successfully.")>

<!--- If not all items for this vendor return have been posted, find the first non-posted one and go directly to frmSerials --->
<cfset FirstUnpostedRETLREV = objSerialsVendorReturns.getFirstUnpostedItem(stRecord.RETHSEQ, stRecord.RETLREV)>
<cfif FirstUnpostedRETLREV IS NOT "">
	<cflocation url="index.cfm?task=serials_returnsvendor_serials_edit&RETHSEQ=#urlEncodedFormat(stRecord.RETHSEQ)#&RETLREV=#urlEncodedFormat(FirstUnpostedRETLREV)#">

<!--- Otherwise, go directly to the display page --->
<cfelse>
	<cflocation url="index.cfm?task=serials_returnsvendor_serials_view&RETHSEQ=#urlEncodedFormat(stRecord.RETHSEQ)#&RETLREV=#urlEncodedFormat(stRecord.RETLREV)#&PostingAll=1">
</cfif>