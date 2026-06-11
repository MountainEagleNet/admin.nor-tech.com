<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/09/2006
	Function: 		Serial Number action Page
	Template:		savSerial.cfm
	Task:			serials_corrections_serials_save
--->
<cfset objSerials = createObject("component", "admin.assets.cfcs.Serials")>
<cfset stFormCopy = duplicate(FORM)>

<!--- QUIT was clicked --->
<cfif isDefined("stFormCopy.ButtonClicked") AND findNoCase("Quit", stFormCopy.ButtonClicked) NEQ 0>
	<cfset objSerials.setDataRecord(stFormCopy)>
	<cflocation url="index.cfm?task=serials_corrections_serials_edit&Validation=1">

<!--- CONTINUE was clicked --->
<cfelse>
	
	<cfset strSerial = objSerials.getRecord(stFormCopy.SerialID)>
	<cfset OldSerialNumber = strSerial.SerialNumber>
	<cfset structInsert(strSerial, "SerialNumber", ucase(stFormCopy.NewSerialNumber), True)>
	<cfset objSerials.saveRecord(strSerial)>

	<!--- Create Audit Trail entries in tblSerialNumberAuditTrail --->
	<cfset objSerials.createAuditTrailCorrection(stFormCopy.SerialID, OldSerialNumber, "Remove")>
	<cfset objSerials.createAuditTrailCorrection(stFormCopy.SerialID, stFormCopy.NewSerialNumber, "Add")>
	
	<cfset objSerials.setMessage("The Serial Number was changed successfully.")>
	
	<!--- Go to the display page --->
	<cflocation url="index.cfm?task=serials_corrections_serials_view&SerialID=#urlEncodedFormat(stFormCopy.SerialID)#&OldSerialNumber=#urlEncodedFormat(OldSerialNumber)#">

</cfif>