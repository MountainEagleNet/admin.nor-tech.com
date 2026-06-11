<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/21/2006
	Function: 		Serial Number Posting Page
	Template:		actPost.cfm
	Task:			serials_receipts_serials_post
--->
<cfset objSerialsReceipts = createObject("component", "admin.assets.cfcs.SerialsReceipts")>
<cfset objBackOrderReceipts = createObject("component", "admin.assets.cfcs.BackOrderReceipts")>

<cfset stRecord = objSerialsReceipts.getDataRecord()>

<cfif isDefined("URL.Password")>
	<cfset structInsert(stRecord, "Password", URL.Password, True)>
</cfif>

<cfset objPORCPH1 = createObject("component", "admin.assets.cfcs.PORCPH1")>
<cfset strPORCPH1 = objPORCPH1.getRecord(stRecord.RCPHSEQ)>
<cfset structInsert(stRecord, "TransactionNumber", strPORCPH1.RCPNUMBER, True)>
<cfset structInsert(stRecord, "VDCODE", strPORCPH1.VDCODE, True)>
<cfset structInsert(stRecord, "VDNAME", strPORCPH1.VDNAME, True)>

<!--- Save Serial Numbers to tblSerialsReceipts --->
<cfset objSerialsReceipts.saveSerialNumberInput(stRecord, 1)> 	<!--- 1=UnpostedOnly --->


<!--- If the number of serial numbers < 200, post them --->
<cfset SerialNumberCount = 0>
<cfset lstRecord = structKeyList(stRecord)>
<cfloop list="#lstRecord#" index="Column">
	<cfif findNoCase('SN_',Column) NEQ 0>
		<cfif trim(stRecord[Column]) IS NOT "">
			<cfset SerialNumberCount = SerialNumberCount + 1>
		</cfif>
	</cfif>
</cfloop>
<cfif SerialNumberCount LT stRecord.NumberOfBoxes>
	<cfset stRecord.ReadyToPost = 1>
</cfif>

<cfif stRecord.ReadyToPost EQ 1>
<!---
	<!--- Set the "posted" flag for all records in tblSerialsReceipts --->
	<cfset objSerialsReceipts.setPosted(stRecord)>
--->
	
	<!--- Add Serial Numbers to tblSerials --->
	<cfset objSerialsReceipts.addSerialNumbers(stRecord, 1)> 	<!--- 1=UnpostedOnly --->
	
	<!--- Create Audit Trail entries in tblSerialNumberAuditTrail --->
	<cfset objSerialsReceipts.createAuditTrail(stRecord, "Receipt", 0, 1)>

	<!--- ************* CHECK FOR BUG ************* --->
	<cfset objSerialsReceipts.checkForBug(stRecord, 4)>	<!--- POSTLOCATION 4 --->

	<!--- Set the "posted" flag for all records in tblSerialsReceipts --->
	<cfset objSerialsReceipts.setPosted(stRecord)>
	
	<!--- If this is a Batch Number Item, save the serial number in tblScannerBatchItemSNs --->
	<cfset objSerialsReceipts.addBatchNumberSN(stRecord)>

	<cfset objSerialsReceipts.setMessage("Serial Numbers were posted successfully.")>

	<!--- Print Bar Code Labels --->
	<cfif structKeyExists(stRecord, "PrintBarCodeLabels") AND stRecord.PrintBarCodeLabels EQ 1>
		<cfset Success = objSerialsReceipts.printBarCodeLabels(stRecord)>
		<cfif Success>
			<cfset objSerialsReceipts.setMessage("Serial Numbers were posted successfully, and bar code labels were printed.")>
		<cfelse>
			<cfset objSerialsReceipts.setMessage("Serial Numbers were posted successfully, but there was a problem with the printing process; bar code labels were NOT printed.")>
		</cfif>
	</cfif>

	<!--- See if this item was on backorder for system builds --->
	<cfset objBackOrderReceipts.findBackOrderReceipts(stRecord)>

	<!--- ************* CHECK FOR BUG ************* --->
	<cfset objSerialsReceipts.checkForBug2(stRecord)>	
	
<cfelse>
	<cfset objSerialsReceipts.setMessage("Serial Numbers were saved.  Please scan the next set of serial numbers.")>
</cfif>
	

<cfif stRecord.ReadyToPost EQ 1>

	<!--- If not all items for this receipt have been posted, find the first non-posted one and go directly to frmSerials --->
	<cfset FirstUnpostedRCPLREV = objSerialsReceipts.getFirstUnpostedItem(stRecord.RCPHSEQ, stRecord.RCPLREV)>
	<cfif FirstUnpostedRCPLREV IS NOT "">
		<cflocation url="index.cfm?task=serials_receipts_serials_edit&RCPHSEQ=#urlEncodedFormat(stRecord.RCPHSEQ)#&RCPLREV=#urlEncodedFormat(FirstUnpostedRCPLREV)#">

	<!--- Otherwise, go directly to the display page --->
	<cfelse>
		<cflocation url="index.cfm?task=serials_receipts_serials_view&RCPHSEQ=#urlEncodedFormat(stRecord.RCPHSEQ)#&RCPLREV=#urlEncodedFormat(stRecord.RCPLREV)#&PostingAll=1">
	</cfif>

<!--- If this is a "large quantity" receipt (processing 200 at a time), go back to frmSerials for the next batch of 200 --->
<cfelse>
	<cfset StartBoxNumber = stRecord.EndBoxNumber + 1>
	<cflocation url="index.cfm?task=serials_receipts_serials_edit&RCPHSEQ=#urlEncodedFormat(stRecord.RCPHSEQ)#&RCPLREV=#urlEncodedFormat(stRecord.RCPLREV)#&StartBoxNumber=#StartBoxNumber#&PrintBarCodeLabels=#stRecord.PrintBarCodeLabels#">
</cfif>