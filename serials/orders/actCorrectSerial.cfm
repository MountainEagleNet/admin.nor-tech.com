<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	10/30/2006
	Function: 		Correct Serial Number, Action Page
	Template:		actCorrectSerial.cfm
	Task:			serials_shipments_correct_act
--->
<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>
<cfset objSerialNumberAuditTrail = createObject("component", "admin.assets.cfcs.SerialNumberAuditTrail")>
<cfset objSerials = createObject("component", "admin.assets.cfcs.Serials")>
<cfset objOEORDD = createObject("component", "admin.assets.cfcs.OEORDD")>
<!---
<cfset objSerialNumberAuditTrail = createObject("component", "admin.assets.cfcs.SerialNumberAuditTrail")>
<cfset objSerials = createObject("component", "admin.assets.cfcs.Serials")>
--->

<cfif isDefined("URL.ManualDeletion") AND URL.ManualDeletion IS "yes">

	<!--- Create a "deletion" record in tblSerialNumberAuditTrail --->
	<cfset strSerialsShipment = objSerialsShipments.getRecord(URL.SerialsShipmentsID)>
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "ORDUNIQ", URL.ORDUNIQ, True)>
	<cfset structInsert(SearchRecord, "LINENUM", URL.ORDLINENUM, True)>
	<cfset qryOEORDD = objOEORDD.searchRecords(SearchRecord, "query")>
	<cfset objSerialNumberAuditTrail.createAuditTrailDeletion(strSerialsShipment.SerialNumber, qryOEORDD.ITEM, qryOEORDD.LOCATION, strSerialsShipment.OrdNumber, "Order [DELETE]", "Remove")>

	<!--- Delete the record from tblSerialsShipments --->
	<cfset objSerialsShipments.deleteRecord(URL.SerialsShipmentsID)>
	
	<!--- Delete record from tblSerialNumberAuditTrail --->
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "SerialTableIDValue", URL.SerialsShipmentsID, True)>
	<cfset qrySerialNumberAuditTrail = objSerialNumberAuditTrail.searchRecords(SearchRecord, "query", "CreationDate DESC")>
	<cfset objSerialNumberAuditTrail.deleteRecord(qrySerialNumberAuditTrail.SerialNumberAuditTrailID)>

	<cflocation url="index.cfm?task=serials_shipments_serials_view&ORDUNIQ=#urlEncodedFormat(URL.ORDUNIQ)#&LINENUM=#urlEncodedFormat(URL.ORDLINENUM)#">
</cfif>

<cfset stFormCopy = duplicate(FORM)>

<!---stFormCopy:<cfdump var="#stFormCopy#">--->

<!--- BACK was clicked --->
<cfif structKeyExists(stFormCopy, "ButtonClicked") AND findNoCase("Back", stFormCopy.ButtonClicked) NEQ 0>
	<cflocation url="index.cfm?task=serials_shipments_serials_view&ORDUNIQ=#urlEncodedFormat(stFormCopy.ORDUNIQ)#&LINENUM=#urlEncodedFormat(stFormCopy.ORDLINENUM)#">

<!--- DELETE was clicked --->
<cfelseif structKeyExists(stFormCopy, "DeleteButton") AND stFormCopy.DeleteButton IS "Delete">

	<cfset strSerialsShipment = objSerialsShipments.getRecord(stFormCopy.SerialsShipmentsID)>
		
	<!--- Retrieve entries in audit trail --->
	<cfset SearchRecord = structNew()>
<!---
	<cfset structInsert(SearchRecord, "SerialTable", "tblSerialsShipments", True)>
	<cfset structInsert(SearchRecord, "SerialTableIDField", "SerialsShipmentsID", True)>
--->
	<cfset structInsert(SearchRecord, "SerialTableIDValue", strSerialsShipment.SerialsShipmentsID, True)>
	<cfset structInsert(SearchRecord, "AddOrRemove", "Remove", True)>
	<cfset qrySerialNumberAuditTrail = objSerialNumberAuditTrail.searchRecords(SearchRecord, "query", "CreationDate DESC")>


<!---<cfloop query="qrySerialNumberAuditTrail">--->
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
		<cfset objSerialNumberAuditTrail.createAuditTrailDeletion(qrySerialNumberAuditTrail.SerialNumber, qrySerialNumberAuditTrail.ITEMNO, qrySerialNumberAuditTrail.LOCATION, qrySerialNumberAuditTrail.TransactionNumber, "Order Deletion", "Add", strSerialsShipment.SerialsShipmentsID)>

<!---</cfloop>--->
	
	<!--- Delete the record from tblSerialsShipments --->
	<cfset objSerialsShipments.deleteRecord(strSerialsShipment.SerialsShipmentsID)>

	<cflocation url="index.cfm?task=serials_shipments_serials_view&ORDUNIQ=#urlEncodedFormat(stFormCopy.ORDUNIQ)#&LINENUM=#urlEncodedFormat(stFormCopy.ORDLINENUM)#">
	
<!--- CONTINUE was clicked --->
<cfelse>
	<cfif trim(stFormCopy.NewSerialNumber) IS "">
		<cfset objSerialsShipments.setMessage("Serial Number was NOT corrected:<br>'New Serial Number' field was not filled in.")>
		<cflocation url="index.cfm?task=serials_shipments_serials_view&ORDUNIQ=#urlEncodedFormat(stFormCopy.ORDUNIQ)#&LINENUM=#urlEncodedFormat(stFormCopy.ORDLINENUM)#">
	<cfelse>
	
		<!--- Validate the serial number entered --->
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ORDUNIQ", stFormCopy.ORDUNIQ, True)>
		<cfset structInsert(SearchRecord, "LINENUM", stFormCopy.ORDLINENUM, True)>
		<cfset qryOEORDD = objOEORDD.searchRecords(SearchRecord, "query")>

		<cfset structInsert(stFormCopy, "ITEM", qryOEORDD.ITEM, True)>
		<cfset structInsert(stFormCopy, "SN_1", NewSerialNumber, True)>
	
		<!--- Check for Warnings --->
		<cfset stWarnings = objSerialsShipments.checkForWarnings(stFormCopy)>

<!---
<cfdump var="#stWarnings#">
<cfabort>
--->

		<cfif NOT structIsEmpty(stWarnings)>
			<cfset objSerialsShipments.setDataRecord(stFormCopy)>
			<cfset objSerialsShipments.setErrorRecord(stWarnings)>
			<cflocation url="index.cfm?task=serials_shipments_warning&CorrectingSerialNumber=1">
		<cfelse>
			<cfset objSerialsShipments.setDataRecord(stFormCopy)>
			<cflocation url="index.cfm?task=serials_shipments_serials_post&CorrectingSerialNumber=1&RequestTimeout=6000">
		</cfif>

	</cfif>

<!---<cflocation url="index.cfm?task=serials_shipments_serials_view&ORDUNIQ=#urlEncodedFormat(stFormCopy.ORDUNIQ)#&LINENUM=#urlEncodedFormat(stFormCopy.ORDLINENUM)#">--->

</cfif>