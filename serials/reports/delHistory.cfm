<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	02/06/2007
	Function: 		Delete entry from serial number history report
	Template:		delHistory.cfm
	Task:			serials_reports_history_delete
--->
<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>
<cfset objSerialNumberAuditTrail = createObject("component", "admin.assets.cfcs.SerialNumberAuditTrail")>
<cfset objSerials = createObject("component", "admin.assets.cfcs.Serials")>
<cfset objSerialsCounts = createObject("component", "admin.assets.cfcs.SerialsCounts")>

<!--- Retrieve entry in audit trail --->
<cfset strSerialNumberAuditTrail = objSerialNumberAuditTrail.getRecord(URL.SerialNumberAuditTrailID)>

<!--- COUNT --->
<cfif strSerialNumberAuditTrail.TransactionType IS "Count">
	<cfif strSerialNumberAuditTrail.AddorRemove IS "Remove">
		<!--- Add it back to tblSerials --->
		<cfset strSerial = objSerials.newRecord()>
		<cfset structInsert(strSerial, "ITEMNO", strSerialNumberAuditTrail.ITEMNO, True)>
		<cfset structInsert(strSerial, "LOCATION", strSerialNumberAuditTrail.LOCATION, True)>
		<cfset structInsert(strSerial, "SerialNumber", strSerialNumberAuditTrail.SerialNumber, True)>
		<cfset objSerials.saveRecord(strSerial)>

		<!--- Create "Count Reversal" entry in tblSerialNumberAuditTrail --->
		<cfset objSerialNumberAuditTrail.createAuditTrailDeletion(strSerialNumberAuditTrail.SerialNumber, strSerialNumberAuditTrail.ITEMNO, strSerialNumberAuditTrail.LOCATION, strSerialNumberAuditTrail.TransactionNumber, "Count Reversal", "Add")>

	<cfelse>
		<!--- Remove it from tblSerials --->
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "SerialNumber", strSerialNumberAuditTrail.SerialNumber, True)>
		<cfset structInsert(SearchRecord, "ITEMNO", strSerialNumberAuditTrail.ITEMNO, True)>
		<cfset structInsert(SearchRecord, "LOCATION", strSerialNumberAuditTrail.LOCATION, True)>
		<cfset qrySerials = objSerials.searchRecords(SearchRecord, "query")>
		<cfif qrySerials.RecordCount GT 0 AND trim(qrySerials.SerialID) IS NOT "">
			<cfset objSerials.deleteRecord(qrySerials.SerialID)>
		</cfif>
		
		<!--- Remove it from tblSerialsCounts --->
		<cfif trim(strSerialNumberAuditTrail.SerialTableIDValue) IS NOT "">
			<cfset objSerialsCounts.deleteRecord(strSerialNumberAuditTrail.SerialTableIDValue)>
		</cfif>
		
		<!--- Create "Count Reversal" entry in tblSerialNumberAuditTrail --->
		<cfset objSerialNumberAuditTrail.createAuditTrailDeletion(strSerialNumberAuditTrail.SerialNumber, strSerialNumberAuditTrail.ITEMNO, strSerialNumberAuditTrail.LOCATION, strSerialNumberAuditTrail.TransactionNumber, "Count Reversal", "Remove")>
		
	</cfif>



<!--- ORDER --->
<cfelse>

	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "SerialNumber", trim(URL.SerialNumber), True)>
	<cfset structInsert(SearchRecord, "TransactionType", "Order", True)>
	<cfset qryOrderRecords = objSerialNumberAuditTrail.searchRecords(SearchRecord, "query", "CreationDate DESC", 1)>
	<cfif qryOrderRecords.SerialNumberAuditTrailID IS URL.SerialNumberAuditTrailID>
		<cfset LastEntry = 1>
	<cfelse>
		<cfset LastEntry = 0>
	</cfif>
	
	<!---
	<!--- Retrieve entry in audit trail --->
	<cfset strSerialNumberAuditTrail = objSerialNumberAuditTrail.getRecord(URL.SerialNumberAuditTrailID)>
	--->
	
	<!--- If this is the Last entry: We removed the serial number, so now we have to add it back --->
	<cfif LastEntry EQ 1>
		<cfset strSerial = objSerials.newRecord()>
		<cfset structInsert(strSerial, "ITEMNO", strSerialNumberAuditTrail.ITEMNO, True)>
		<cfset structInsert(strSerial, "LOCATION", strSerialNumberAuditTrail.LOCATION, True)>
		<cfset structInsert(strSerial, "SerialNumber", strSerialNumberAuditTrail.SerialNumber, True)>
		<cfset objSerials.saveRecord(strSerial)>
	</cfif>
	
	<!--- Delete the record from tblSerialsShipments --->
	<cfset objSerialsShipments.deleteRecord(strSerialNumberAuditTrail.SerialTableIDValue)>
	
	<!--- Delete the record from tblSerialNumberAuditTrail --->
	<cfset objSerialNumberAuditTrail.deleteRecord(strSerialNumberAuditTrail.SerialNumberAuditTrailID)>

</cfif>	

<cflocation url="index.cfm?task=serials_reports_history_disp&SerialNumber=#urlEncodedFormat(URL.SerialNumber)#&ITEMNO=#urlEncodedFormat(URL.ITEMNO)#&BeginDate=#urlEncodedFormat(URL.BeginDate)#&EndDate=#urlEncodedFormat(URL.EndDate)#&TransactionType=#urlEncodedFormat(URL.TransactionType)#&Consolidate=#URL.Consolidate#&CameFromDeletion=1">