<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	11/09/2006
	Function: 		Serial Number Deletion Page
	Template:		actDeleteSerials.cfm
	Task:			serials_transfers_serials_delete
--->

<cfset objSerialsTransfers = createObject("component", "admin.assets.cfcs.SerialsTransfers")>
<cfset objSerialNumberAuditTrail = createObject("component", "admin.assets.cfcs.SerialNumberAuditTrail")>
<cfset objSerials = createObject("component", "admin.assets.cfcs.Serials")>

<cfset stFormCopy = duplicate(FORM)>

<!--- Get a query of the Transfer detail --->
<cfif isDefined("stFormCopy.TRANFENSEQ") AND isDefined("stFormCopy.LINENO")>
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "TRANFENSEQ", stFormCopy.TRANFENSEQ, True)>
	<cfset structInsert(SearchRecord, "LINENO", stFormCopy.LINENO, True)>

	<cfset qrySerialsTransfers = objSerialsTransfers.searchRecords(SearchRecord, "query")>
	<cfloop query="qrySerialsTransfers">
		
		<!--- Retrieve entries in audit trail --->
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "SerialTable", "tblSerialsTransfers", True)>
		<cfset structInsert(SearchRecord, "SerialTableIDField", "SerialsTransfersID", True)>
		<cfset structInsert(SearchRecord, "SerialTableIDValue", qrySerialsTransfers.SerialsTransfersID, True)>
		<cfset qrySerialNumberAuditTrail = objSerialNumberAuditTrail.searchRecords(SearchRecord, "query")>
		<cfloop query="qrySerialNumberAuditTrail">
			<!--- Change the Location back to what it was --->
			<cfif qrySerialNumberAuditTrail.AddorRemove IS "Remove">
				<cfset FromLocation = qrySerialNumberAuditTrail.LOCATION>
				<cfset NewAddorRemove = "Add">
			<cfelse>
				<cfset ToLocation = qrySerialNumberAuditTrail.LOCATION>
				<cfset NewAddorRemove = "Remove">
			</cfif>
<!---		
			<!--- Delete the record from tblSerialNumberAuditTrail --->
			<cfset objSerialNumberAuditTrail.deleteRecord(qrySerialNumberAuditTrail.SerialNumberAuditTrailID)>
--->
			<!--- Create a "deletion" record in tblSerialNumberAuditTrail --->
			<cfset objSerialNumberAuditTrail.createAuditTrailDeletion(qrySerialNumberAuditTrail.SerialNumber, qrySerialNumberAuditTrail.ITEMNO, qrySerialNumberAuditTrail.LOCATION, qrySerialNumberAuditTrail.TransactionNumber, "Trans Deletion", NewAddorRemove, qrySerialsTransfers.SerialsTransfersID)>

		</cfloop>

		<cfif isDefined("FromLocation") AND isDefined("ToLocation")>
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "SerialNumber", qrySerialNumberAuditTrail.SerialNumber, True)>
			<cfset structInsert(SearchRecord, "ITEMNO", qrySerialNumberAuditTrail.ITEMNO, True)>
			<cfset structInsert(SearchRecord, "LOCATION", ToLocation, True)>
			<cfset qrySerials = objSerials.searchRecords(SearchRecord, "query")>
			<cfloop query="qrySerials">
				<cfset strSerial = objSerials.getRecord(qrySerials.SerialID)>
				<cfset structInsert(strSerial, "LOCATION", FromLocation, True)>
				<cfset objSerials.saveRecord(strSerial)>
			</cfloop>
		</cfif>
			
		<!--- Delete the record from tblSerialsTransfers --->
		<cfset objSerialsTransfers.deleteRecord(qrySerialsTransfers.SerialsTransfersID)>
	
	</cfloop>

	<cfset objSerialsTransfers.setMessage("Serial Numbers were successfully deleted, and all entries that were previously made in the master list of serial numbers and serial number audit trail were reversed.")>
	
</cfif>

<!--- Go to item list page --->
<cflocation url="index.cfm?task=serials_transfers_items_list&TRANFENSEQ=#urlEncodedFormat(stFormCopy.TRANFENSEQ)#">