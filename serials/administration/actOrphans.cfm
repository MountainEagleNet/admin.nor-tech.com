<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	07/13/2007
	Function: 		Delete orphaned serial numbers
	Template:		actOrphans.cfm
	Task:			serials_admin_orphans_act
--->
<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>
<cfset objSerialNumberAuditTrail = createObject("component", "admin.assets.cfcs.SerialNumberAuditTrail")>
<cfset objSerials = createObject("component", "admin.assets.cfcs.Serials")>
<cfset objAdmin = createObject("component", "admin.assets.cfcs.Admin")>

<cfset stRecord = objSerialsShipments.getDataRecord()>
<cfset qyrOrphanedSerialNumbers = stRecord.qryOrphans>

<cfset NumberDeleted = 0>

<cfloop query="qyrOrphanedSerialNumbers">
	<cfset CURRENT_SerialsShipmentsID = qyrOrphanedSerialNumbers.SerialsShipmentsID>

	<!--- Retrieve entry in audit trail --->
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "SerialTable", "tblSerialsShipments", True)>
	<cfset structInsert(SearchRecord, "SerialTableIDField", "SerialsShipmentsID", True)>
	<cfset structInsert(SearchRecord, "SerialTableIDValue", CURRENT_SerialsShipmentsID, True)>
	<cfset qrySerialNumberAuditTrail = objSerialNumberAuditTrail.searchRecords(SearchRecord, "query")>

	<cfif qrySerialNumberAuditTrail.RecordCount EQ 1>

		<cfset Current_ITEMNO = qrySerialNumberAuditTrail.ITEMNO>
		<cfset Current_LOCATION = qrySerialNumberAuditTrail.LOCATION>
		<cfset Current_SerialNumber = qrySerialNumberAuditTrail.SerialNumber>

		<!--- Add the serial number back to the master list of serial numbers --->
		<cfset strSerial = objSerials.newRecord()>
		<cfset structInsert(strSerial, "ITEMNO", Current_ITEMNO, True)>
		<cfset structInsert(strSerial, "LOCATION", Current_LOCATION, True)>
		<cfset structInsert(strSerial, "SerialNumber", Current_SerialNumber, True)>
		<cfset objSerials.saveRecord(strSerial)>


		<!--- Create Audit Trail entry in tblSerialNumberAuditTrail --->
		<cfset strSerialNumberAuditTrail = structNew()>
		<cfset structInsert(strSerialNumberAuditTrail, "SerialNumberAuditTrailID", "", True)>
		<cfset structInsert(strSerialNumberAuditTrail, "TransactionType", "Orphan", True)>
		<cfset structInsert(strSerialNumberAuditTrail, "TransactionNumber", "", True)>
		<cfset structInsert(strSerialNumberAuditTrail, "CreationDate", "", True)>
		<cfset qryUser = objAdmin.getRecordAsQuery(SESSION.adminuserid)>
		<cfset structInsert(strSerialNumberAuditTrail, "UserFirstName", trim(qryUser.fname), True)>
		<cfset structInsert(strSerialNumberAuditTrail, "UserLastName", trim(qryUser.lname), True)>
		<cfset structInsert(strSerialNumberAuditTrail, "UserEmail", trim(qryUser.emailaddress), True)>
		<cfset structInsert(strSerialNumberAuditTrail, "ITEMNO", trim(Current_ITEMNO), True)>
		<cfset structInsert(strSerialNumberAuditTrail, "ITEMDESC", trim(objSerialsShipments.getItemDescription(Current_ITEMNO)), True)>
		<cfset structInsert(strSerialNumberAuditTrail, "SerialNumber", trim(Current_SerialNumber), True)>
		<cfset structInsert(strSerialNumberAuditTrail, "AddorRemove", "Add", True)>								
		<cfset structInsert(strSerialNumberAuditTrail, "LOCATION", trim(Current_LOCATION), True)>
		<cfset structInsert(strSerialNumberAuditTrail, "LOCATIONDESC", trim(objSerialsShipments.getLocationDescription(Current_LOCATION)), True)>
		<cfset objSerialNumberAuditTrail.saveRecord(strSerialNumberAuditTrail)>

		<!--- Delete the record from tblSerialsShipments --->
		<cfset objSerialsShipments.deleteRecord(CURRENT_SerialsShipmentsID)>

		<cfset NumberDeleted = NumberDeleted + 1>

	</cfif>

</cfloop>

<cflocation url="index.cfm?task=serials_admin_orphans_display&NumberDeleted=#NumberDeleted#">