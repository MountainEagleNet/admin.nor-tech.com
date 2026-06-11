<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	11/09/2006
	Function: 		Serial Number Deletion Page
	Template:		actDeleteSerials.cfm
	Task:			serials_shipments_serials_delete
--->

<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>
<cfset objSerialNumberAuditTrail = createObject("component", "admin.assets.cfcs.SerialNumberAuditTrail")>
<cfset objSerials = createObject("component", "admin.assets.cfcs.Serials")>

<cfset stFormCopy = duplicate(FORM)>

<!--- Get a query of the Serial Numbers --->
<cfif isDefined("stFormCopy.ORDUNIQ") AND isDefined("stFormCopy.LINENUM")>
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "ORDUNIQ", stFormCopy.ORDUNIQ, True)>
	<cfset structInsert(SearchRecord, "ORDLINENUM", stFormCopy.LINENUM, True)>
	<cfset qrySerialsShipments = objSerialsShipments.searchRecords(SearchRecord, "query")>
	<cfloop query="qrySerialsShipments">
		
		<!--- Retrieve entries in audit trail --->
		<cfset SearchRecord = structNew()>
<!---
		<cfset structInsert(SearchRecord, "SerialTable", "tblSerialsShipments", True)>
		<cfset structInsert(SearchRecord, "SerialTableIDField", "SerialsShipmentsID", True)>
--->
		<cfset structInsert(SearchRecord, "SerialTableIDValue", qrySerialsShipments.SerialsShipmentsID, True)>
		<cfset structInsert(SearchRecord, "AddOrRemove", "Remove", True)>
		<cfset qrySerialNumberAuditTrail = objSerialNumberAuditTrail.searchRecords(SearchRecord, "query", "CreationDate DESC")>
				
<!---	<cfloop query="qrySerialNumberAuditTrail">	--->
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
			<cfset objSerialNumberAuditTrail.createAuditTrailDeletion(qrySerialNumberAuditTrail.SerialNumber, qrySerialNumberAuditTrail.ITEMNO, qrySerialNumberAuditTrail.LOCATION, qrySerialNumberAuditTrail.TransactionNumber, "Order Deletion", "Add", qrySerialsShipments.SerialsShipmentsID)>

<!---	</cfloop>	--->
		
		<!--- Delete the record from tblSerialsShipments --->
		<cfset objSerialsShipments.deleteRecord(qrySerialsShipments.SerialsShipmentsID)>
	
	</cfloop>

	<cfset objSerialsShipments.setMessage("Serial Numbers were successfully deleted, and all entries that were previously made in the master list of serial numbers and serial number audit trail were reversed.")>

</cfif>

<!--- Go to item list page --->
<cflocation url="index.cfm?task=serials_orders_items_list&ORDUNIQ=#urlEncodedFormat(stFormCopy.ORDUNIQ)#">