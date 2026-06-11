<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/03/2006
	Function: 		Serial Number Posting Page
	Template:		actPost.cfm
	Task:			serials_adjustments_serials_post
--->

<!--- QUIT was clicked --->
<cfif isDefined("FORM.ButtonClicked") AND findNoCase("Quit", FORM.ButtonClicked) NEQ 0>
	<cflocation url="index.cfm?task=serials_adjustments_serials_edit&Validation=1">

<!--- CONTINUE was clicked --->
<cfelse>
	
	<cfset objSerialsAdjustments = createObject("component", "admin.assets.cfcs.SerialsAdjustments")>
	
	<cfset stRecord = objSerialsAdjustments.getDataRecord()>

	<cfset objICADEH = createObject("component", "admin.assets.cfcs.ICADEH")>
	<cfset strICADEH = objICADEH.getRecord(stRecord.ADJENSEQ)>
	<cfset structInsert(stRecord, "TransactionNumber", strICADEH.DOCNUM, True)>
	
	<!--- Save Serial Numbers to tblSerialsAdjustments --->
	<cfset objSerialsAdjustments.saveSerialNumberInput(stRecord)>
	
	<!--- Set the "posted" flag for all records in tblSerialsAdjustments --->
	<cfset objSerialsAdjustments.setPosted(stRecord)>
	
	<cfif stRecord.AdjustmentType IS "Increase">
		<!--- Add Serial Numbers to tblSerials --->
		<cfset objSerialsAdjustments.addSerialNumbers(stRecord)>
	<cfelse>
		<!--- Remove Serial Numbers from tblSerials --->
		<cfset objSerialsAdjustments.removeSerialNumbers(stRecord)>
	</cfif>
	
	<!--- Create Audit Trail entries in tblSerialNumberAuditTrail --->
	<cfif stRecord.AdjustmentType IS "Increase">
		<cfset objSerialsAdjustments.createAuditTrail(stRecord, "AdjustmentIncrease")>
	<cfelse>
		<cfset objSerialsAdjustments.createAuditTrail(stRecord, "AdjustmentDecrease")>
	</cfif>

	<!--- If this is a Batch Number Item, save the serial number in tblScannerBatchItemSNs --->
	<cfif stRecord.AdjustmentType IS "Increase">
		<cfset objSerialsAdjustments.addBatchNumberSN(stRecord)>
	</cfif>
	
	<cfset objSerialsAdjustments.setMessage("Serial Numbers were posted successfully.")>
	
	<!--- Print Bar Code Labels --->
	<cfif stRecord.AdjustmentType IS "Increase" AND structKeyExists(stRecord, "PrintBarCodeLabels") AND stRecord.PrintBarCodeLabels EQ 1>
		<cfset Success = objSerialsAdjustments.printBarCodeLabels(stRecord)>
		<cfif Success>
			<cfset objSerialsAdjustments.setMessage("Serial Numbers were posted successfully, and bar code labels were printed.")>
		<cfelse>
			<cfset objSerialsAdjustments.setMessage("Serial Numbers were posted successfully, but there was a problem with the printing process; bar code labels were NOT printed.")>
		</cfif>
	</cfif>
	
	<!--- Go to the display page --->
	<cflocation url="index.cfm?task=serials_adjustments_serials_view&ADJENSEQ=#urlEncodedFormat(stRecord.ADJENSEQ)#&LINENO=#urlEncodedFormat(stRecord.LINENO)#">

</cfif>