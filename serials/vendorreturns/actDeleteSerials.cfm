<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	11/09/2006
	Function: 		Serial Number Deletion Page
	Template:		actDeleteSerials.cfm
	Task:			serials_returnsvendor_serials_delete
--->

<cfset objSerialsVendorReturns = createObject("component", "admin.assets.cfcs.SerialsVendorReturns")>
<cfset objSerialNumberAuditTrail = createObject("component", "admin.assets.cfcs.SerialNumberAuditTrail")>
<cfset objSerials = createObject("component", "admin.assets.cfcs.Serials")>

<cfset stFormCopy = duplicate(FORM)>

<!--- Get a query of the Serial Numbers --->
<cfif isDefined("stFormCopy.RETHSEQ") AND isDefined("stFormCopy.RETLREV")>
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "RETHSEQ", stFormCopy.RETHSEQ, True)>
	<cfset structInsert(SearchRecord, "RETLREV", stFormCopy.RETLREV, True)>
	<cfset qrySerialsVendorReturns = objSerialsVendorReturns.searchRecords(SearchRecord, "query")>
	<cfloop query="qrySerialsVendorReturns">
		
		<!--- Retrieve entries in audit trail --->
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "SerialTable", "tblSerialsVendorReturns", True)>
		<cfset structInsert(SearchRecord, "SerialTableIDField", "SerialsVendorReturnsID", True)>
		<cfset structInsert(SearchRecord, "SerialTableIDValue", qrySerialsVendorReturns.SerialsVendorReturnsID, True)>
		<cfset qrySerialNumberAuditTrail = objSerialNumberAuditTrail.searchRecords(SearchRecord, "query")>
		<cfloop query="qrySerialNumberAuditTrail">
			<!--- We removed the serial number, so now we have to add it back --->
			<cfset strSerial = objSerials.newRecord()>
			<cfset structInsert(strSerial, "ITEMNO", qrySerialNumberAuditTrail.ITEMNO, True)>
			<cfset structInsert(strSerial, "LOCATION", qrySerialNumberAuditTrail.LOCATION, True)>
			<cfset structInsert(strSerial, "SerialNumber", qrySerialNumberAuditTrail.SerialNumber, True)>
			<cfset objSerials.saveRecord(strSerial)>
<!---	
			<!--- Delete the record from tblSerialNumberAuditTrail --->
			<cfset objSerialNumberAuditTrail.deleteRecord(qrySerialNumberAuditTrail.SerialNumberAuditTrailID)>
--->	
			<!--- Create a "deletion" record in tblSerialNumberAuditTrail --->
			<cfset objSerialNumberAuditTrail.createAuditTrailDeletion(qrySerialNumberAuditTrail.SerialNumber, qrySerialNumberAuditTrail.ITEMNO, qrySerialNumberAuditTrail.LOCATION, qrySerialNumberAuditTrail.TransactionNumber, "VndRet Deletion", "Add", qrySerialsVendorReturns.SerialsVendorReturnsID)>

		</cfloop>
		
		<!--- Delete the record from tblSerialsVendorReturns --->
		<cfset objSerialsVendorReturns.deleteRecord(qrySerialsVendorReturns.SerialsVendorReturnsID)>
	
	</cfloop>

	<cfset objSerialsVendorReturns.setMessage("Serial Numbers were successfully deleted, and all entries that were previously made in the master list of serial numbers and serial number audit trail were reversed.")>

</cfif>

<!--- Go to item list page --->
<cflocation url="index.cfm?task=serials_returnsvendor_items_list&RETHSEQ=#urlEncodedFormat(stFormCopy.RETHSEQ)#">