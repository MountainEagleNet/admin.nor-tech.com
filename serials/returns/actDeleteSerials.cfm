<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	11/09/2006
	Function: 		Serial Number Deletion Page
	Template:		actDeleteSerials.cfm
	Task:			serials_returns_serials_delete
--->

<cfset objSerialsReturns = createObject("component", "admin.assets.cfcs.SerialsReturns")>
<cfset objSerialNumberAuditTrail = createObject("component", "admin.assets.cfcs.SerialNumberAuditTrail")>
<cfset objSerials = createObject("component", "admin.assets.cfcs.Serials")>

<cfset stFormCopy = duplicate(FORM)>

<!--- Get a query of the Serial Numbers --->
<cfif isDefined("stFormCopy.RMAUNIQ") AND isDefined("stFormCopy.LINENUM")>
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "RMAUNIQ", stFormCopy.RMAUNIQ, True)>
	<cfset structInsert(SearchRecord, "LINENUM", stFormCopy.LINENUM, True)>
	<cfset qrySerialsReturns = objSerialsReturns.searchRecords(SearchRecord, "query")>
	<cfloop query="qrySerialsReturns">
		
		<!--- Retrieve entries in audit trail --->
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "SerialTable", "tblSerialsReturns", True)>
		<cfset structInsert(SearchRecord, "SerialTableIDField", "SerialsReturnsID", True)>
		<cfset structInsert(SearchRecord, "SerialTableIDValue", qrySerialsReturns.SerialsReturnsID, True)>
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
			<cfset objSerialNumberAuditTrail.createAuditTrailDeletion(qrySerialNumberAuditTrail.SerialNumber, qrySerialNumberAuditTrail.ITEMNO, qrySerialNumberAuditTrail.LOCATION, qrySerialNumberAuditTrail.TransactionNumber, "Return Deletion", "Remove", qrySerialsReturns.SerialsReturnsID)>
	
		</cfloop>
		
		<!--- Delete the record from tblSerialsReturns --->
		<cfset objSerialsReturns.deleteRecord(qrySerialsReturns.SerialsReturnsID)>
	
	</cfloop>

	<cfset objSerialsReturns.setMessage("Serial Numbers were successfully deleted, and all entries that were previously made in the master list of serial numbers and serial number audit trail were reversed.")>

</cfif>

<!--- Go to item list page --->
<cflocation url="index.cfm?task=serials_returns_items_list&RMAUNIQ=#urlEncodedFormat(stFormCopy.RMAUNIQ)#&RMAAction=#stFormCopy.RMAAction#">