<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/26/2006
	Edit Date: 		10/12/2006
	Function: 		Serial Number Posting Page
	Template:		actPost.cfm
	Task:			serials_shipments_serials_post
--->
<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>
<cfset objBackOrderReceipts = createObject("component", "admin.assets.cfcs.BackOrderReceipts")>

<!--- SERIAL NUMBER CORRECTION --->
<cfif isDefined("URL.CorrectingSerialNumber")>
	<!--- Correct the Serial Number --->
	<cfset stFormCopy = objSerialsShipments.getDataRecord()>
	<cfset objSerialsShipments.correctSerialNumber(stFormCopy)>
	<cfset objSerialsShipments.setMessage("Serial Number was corrected successfully.")>
	<cflocation url="index.cfm?task=serials_shipments_serials_view&ORDUNIQ=#urlEncodedFormat(stFormCopy.ORDUNIQ)#&LINENUM=#urlEncodedFormat(stFormCopy.ORDLINENUM)#">
</cfif>

<cfset stRecord = objSerialsShipments.getDataRecord()>

<cfif isDefined("URL.Password")>
	<cfset structInsert(stRecord, "Password", URL.Password, True)>
</cfif>

<cfset objOEORDH = createObject("component", "admin.assets.cfcs.OEORDH")>
<cfset strOEORDH = objOEORDH.getRecord(stRecord.ORDUNIQ)>
<cfset structInsert(stRecord, "CUSTOMER", strOEORDH.CUSTOMER, True)>
<cfset structInsert(stRecord, "BILNAME", strOEORDH.BILNAME, True)>
<cfset structInsert(stRecord, "TransactionNumber", stRecord.ORDNUMBER, True)>

<!--- Bug Fix: Make sure the structure doesn't contain more SN's than the remaining quantity --->
<cfset lstRecord = structKeyList(stRecord)>
<cfloop list="#lstRecord#" index="Column">
	<cfif findNoCase("SN_", Column) NEQ 0>
		<cfset SNNumber = removeChars(Column, 1, 3)>
		<cfif isNumeric(SNNumber) AND isDefined("stRecord.RemainingQuantity") AND SNNumber GT stRecord.RemainingQuantity>
			<cfset structDelete(stRecord, Column)>
		</cfif>
	</cfif>
</cfloop>

<!--- Save Serial Numbers to tblSerialsShipments --->
<cfset objSerialsShipments.saveSerialNumberInput(stRecord, 1)>	<!--- 1=UnpostedOnly --->

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

<!---
SerialNumberCount:<cfdump var="#SerialNumberCount#"><br />
stRecord<cfdump var="#stRecord#"><br />
--->

<!--- RAB 8/22/2012 --->
<cfset stRecord.ReadyToPost = 1>



<cfif stRecord.ReadyToPost EQ 1>
	<!--- Remove Serial Numbers from tblSerials --->
    <cfset objSerialsShipments.removeSerialNumbers(stRecord, 1, 1)>	<!--- 1=UnattachedOnly, 1=UnpostedOnly --->
    
    <!---	<cfset objSerialsShipments.checkForBug(stRecord, 2)>	--->	<!--- POSTLOCATION 2 --->
    
    <!--- Create Audit Trail entries in tblSerialNumberAuditTrail --->
    <cfset objSerialsShipments.createAuditTrail(stRecord, "Order", 1, 1)>	<!--- 1=UnattachedOnly, 1=UnpostedOnly --->
    
    <!---	<cfset objSerialsShipments.checkForBug(stRecord, 3)>	--->	<!--- POSTLOCATION 3 --->
    
    <!--- Set the "posted" flag for all records in tblSerialsShipments --->
    <cfset objSerialsShipments.setPosted(stRecord)>	
    
        <cfset objSerialsShipments.checkForBug(stRecord, 4)>	<!--- POSTLOCATION 4 --->
    
    <!--- If this is a Batch Number Item, save the serial number in tblScannerBatchItemSNs --->
    <cfset objSerialsShipments.addBatchNumberSN(stRecord)>
    
    <cfset objSerialsShipments.setMessage("Serial Numbers were posted successfully.")>
    
    <!--- Apply these to back order receipts --->
    <cfset objBackOrderReceipts.applyOrderToBackOrders(stRecord)>

<cfelse>
	<cfset objSerialsShipments.setMessage("Serial Numbers were saved.  Please scan the next set of serial numbers.")>
</cfif>

<cfif stRecord.ReadyToPost EQ 1>
    
    <!--- If not all items for this order have been posted, find the first non-posted one and go directly to frmSerials --->
    <cfset FirstUnpostedLINENUM = objSerialsShipments.getFirstUnpostedItem(stRecord.ORDUNIQ, stRecord.ORDLINENUM)>
    <cfif FirstUnpostedLINENUM IS NOT "">
        <cflocation url="index.cfm?task=serials_shipments_serials_edit&ORDUNIQ=#urlEncodedFormat(stRecord.ORDUNIQ)#&LINENUM=#urlEncodedFormat(FirstUnpostedLINENUM)#">
    
    <!--- Otherwise, go directly to the display page --->
    <cfelse>
        <cflocation url="index.cfm?task=serials_shipments_serials_view&ORDUNIQ=#urlEncodedFormat(stRecord.ORDUNIQ)#&LINENUM=#urlEncodedFormat(stRecord.ORDLINENUM)#&PostingAll=1">
    </cfif>
	
<!--- If this is a "large quantity" receipt (processing 200 at a time), go back to frmSerials for the next batch of 200 --->
<cfelse>
	<cfset StartBoxNumber = stRecord.EndBoxNumber + 1>
	<cflocation url="index.cfm?task=serials_shipments_serials_edit&ORDUNIQ=#urlEncodedFormat(stRecord.ORDUNIQ)#&LINENUM=#urlEncodedFormat(stRecord.ORDLINENUM)#&StartBoxNumber=#StartBoxNumber#">
</cfif>