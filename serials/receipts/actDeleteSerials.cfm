<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	11/09/2006
	Function: 		Serial Number Deletion Page
	Template:		actDeleteSerials.cfm
	Task:			serials_receipts_serials_delete
--->

<cfsetting requesttimeout="12000">

<cfset objSerialsReceipts = createObject("component", "admin.assets.cfcs.SerialsReceipts")>
<cfset objSerialNumberAuditTrail = createObject("component", "admin.assets.cfcs.SerialNumberAuditTrail")>
<cfset objSerials = createObject("component", "admin.assets.cfcs.Serials")>

<cfset stFormCopy = duplicate(FORM)>

<!--- Get a query of the Serial Numbers --->
<cfif isDefined("stFormCopy.RCPHSEQ") AND isDefined("stFormCopy.RCPLREV")>
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "RCPHSEQ", stFormCopy.RCPHSEQ, True)>
	<cfset structInsert(SearchRecord, "RCPLREV", stFormCopy.RCPLREV, True)>
	<cfset qrySerialsReceipts = objSerialsReceipts.searchRecords(SearchRecord, "query")>
	<cfloop query="qrySerialsReceipts">
		
		<!--- Retrieve entries in audit trail --->
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "SerialTable", "tblSerialsReceipts", True)>
		<cfset structInsert(SearchRecord, "SerialTableIDField", "SerialsReceiptsID", True)>
		<cfset structInsert(SearchRecord, "SerialTableIDValue", qrySerialsReceipts.SerialsReceiptsID, True)>
		<cfset qrySerialNumberAuditTrail = objSerialNumberAuditTrail.searchRecords(SearchRecord, "query")>
		<cfloop query="qrySerialNumberAuditTrail">
		
			<!--- We added the serial number, so now we have to remove it --->
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "SerialNumber", qrySerialNumberAuditTrail.SerialNumber, True)>
			<cfset structInsert(SearchRecord, "ITEMNO", qrySerialNumberAuditTrail.ITEMNO, True)>
			<cfset structInsert(SearchRecord, "LOCATION", qrySerialNumberAuditTrail.LOCATION, True)>
			<cfset qrySerials = objSerials.searchRecords(SearchRecord, "query")>
			<cfloop query="qrySerials">
				<cfset objSerials.deleteRecord(qrySerials.SerialID)>
			</cfloop>
<!---	
			<!--- Delete the record from tblSerialNumberAuditTrail --->
			<cfset objSerialNumberAuditTrail.deleteRecord(qrySerialNumberAuditTrail.SerialNumberAuditTrailID)>
--->
			<!--- Create a "deletion" record in tblSerialNumberAuditTrail --->
			<cfset objSerialNumberAuditTrail.createAuditTrailDeletion(qrySerialNumberAuditTrail.SerialNumber, qrySerialNumberAuditTrail.ITEMNO, qrySerialNumberAuditTrail.LOCATION, qrySerialNumberAuditTrail.TransactionNumber, "Recpt Deletion", "Remove", qrySerialsReceipts.SerialsReceiptsID)>
	
		</cfloop>
		
		<!--- Delete the record from tblSerialsReceipts --->
		<cfset objSerialsReceipts.deleteRecord(qrySerialsReceipts.SerialsReceiptsID)>
	
	</cfloop>

	<cfset objSerialsReceipts.setMessage("Serial Numbers were successfully deleted, and all entries that were previously made in the master list of serial numbers and serial number audit trail were reversed.")>

</cfif>

<!--- Go to item list page --->
<cflocation url="index.cfm?task=serials_receipts_items_list&RCPHSEQ=#urlEncodedFormat(stFormCopy.RCPHSEQ)#">