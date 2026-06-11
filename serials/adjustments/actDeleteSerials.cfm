<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	11/09/2006
	Function: 		Serial Number Deletion Page
	Template:		actDeleteSerials.cfm
	Task:			serials_adjustments_serials_delete
--->

<cfset objSerialsAdjustments = createObject("component", "admin.assets.cfcs.SerialsAdjustments")>
<cfset objICADEH = createObject("component", "admin.assets.cfcs.ICADEH")>
<cfset objICADED = createObject("component", "admin.assets.cfcs.ICADED")>
<cfset objSerialNumberAuditTrail = createObject("component", "admin.assets.cfcs.SerialNumberAuditTrail")>
<cfset objSerials = createObject("component", "admin.assets.cfcs.Serials")>

<cfset stFormCopy = duplicate(FORM)>

<!--- Get a query of the Adjustment detail --->
<cfif isDefined("stFormCopy.ADJENSEQ") AND isDefined("stFormCopy.LINENO")>
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "ADJENSEQ", stFormCopy.ADJENSEQ, True)>
	<cfset structInsert(SearchRecord, "LINENO", stFormCopy.LINENO, True)>
	<cfset qryDetail = objICADED.searchRecords(SearchRecord, "query")>
	<cfif qryDetail.RecordCount NEQ 0>
		<cfif qryDetail.TRANSTYPE EQ 1 OR qryDetail.TRANSTYPE EQ 3 OR qryDetail.TRANSTYPE EQ 5>
			<cfset AdjustmentType = "Increase">
		<cfelse>
			<cfset AdjustmentType = "Decrease">
		</cfif>

		<cfset qrySerialsAdjustments = objSerialsAdjustments.searchRecords(SearchRecord, "query", "SortOrder")>
		<cfloop query="qrySerialsAdjustments">
			
			<!--- Retrieve entries in audit trail --->
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "SerialTable", "tblSerialsAdjustments", True)>
			<cfset structInsert(SearchRecord, "SerialTableIDField", "SerialsAdjustmentsID", True)>
			<cfset structInsert(SearchRecord, "SerialTableIDValue", qrySerialsAdjustments.SerialsAdjustmentsID, True)>
			<cfset qrySerialNumberAuditTrail = objSerialNumberAuditTrail.searchRecords(SearchRecord, "query")>
			<cfloop query="qrySerialNumberAuditTrail">
				<cfif AdjustmentType IS "Increase">
					<!--- We added the serial number, so now we have to remove it --->
					<cfset SearchRecord = structNew()>
					<cfset structInsert(SearchRecord, "SerialNumber", qrySerialNumberAuditTrail.SerialNumber, True)>
					<cfset structInsert(SearchRecord, "ITEMNO", qryDetail.ITEMNO, True)>
					<cfset structInsert(SearchRecord, "LOCATION", qryDetail.LOCATION, True)>
					<cfset qrySerials = objSerials.searchRecords(SearchRecord, "query")>
					<cfloop query="qrySerials">
						<cfset objSerials.deleteRecord(qrySerials.SerialID)>
					</cfloop>

					<!--- Create a "deletion" record in tblSerialNumberAuditTrail --->
					<cfset objSerialNumberAuditTrail.createAuditTrailDeletion(qrySerialNumberAuditTrail.SerialNumber, qrySerialNumberAuditTrail.ITEMNO, qrySerialNumberAuditTrail.LOCATION, qrySerialNumberAuditTrail.TransactionNumber, "Adj Deletion", "Remove", qrySerialsAdjustments.SerialsAdjustmentsID)>
					
				<cfelse>
					<!--- We removed the serial number, so now we have to add it back --->
					<cfset strSerial = objSerials.newRecord()>
					<cfset structInsert(strSerial, "ITEMNO", qryDetail.ITEMNO, True)>
					<cfset structInsert(strSerial, "LOCATION", qryDetail.LOCATION, True)>
					<cfset structInsert(strSerial, "SerialNumber", qrySerialNumberAuditTrail.SerialNumber, True)>
					<cfset objSerials.saveRecord(strSerial)>
					
					<!--- Create a "deletion" record in tblSerialNumberAuditTrail --->
					<cfset objSerialNumberAuditTrail.createAuditTrailDeletion(qrySerialNumberAuditTrail.SerialNumber, qrySerialNumberAuditTrail.ITEMNO, qrySerialNumberAuditTrail.LOCATION, qrySerialNumberAuditTrail.TransactionNumber, "Adj Deletion", "Add", qrySerialsAdjustments.SerialsAdjustmentsID)>
				</cfif>
<!---		
				<!--- Delete the record from tblSerialNumberAuditTrail --->
				<cfset objSerialNumberAuditTrail.deleteRecord(qrySerialNumberAuditTrail.SerialNumberAuditTrailID)>
--->		
			</cfloop>
			
			<!--- Delete the record from tblSerialsAdjustments --->
			<cfset objSerialsAdjustments.deleteRecord(qrySerialsAdjustments.SerialsAdjustmentsID)>
		
		</cfloop>

		<cfset objSerialsAdjustments.setMessage("Serial Numbers were successfully deleted, and all entries that were previously made in the master list of serial numbers and serial number audit trail were reversed.")>
		
	</cfif>
	
</cfif>

<!--- Go to item list page --->
<cflocation url="index.cfm?task=serials_adjustments_items_list&ADJENSEQ=#urlEncodedFormat(stFormCopy.ADJENSEQ)#">