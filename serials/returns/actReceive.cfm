<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	10/9/2007
	Function: 		
	Template:		actReceive.cfm
	Task:			serials_returns_serials_receive
--->
<cfset objRAHEAD = createObject("component", "admin.assets.cfcs.RAHEAD")>
<cfset objRADET = createObject("component", "admin.assets.cfcs.RADET")>
<cfset objSerialsReturns = createObject("component", "admin.assets.cfcs.SerialsReturns")>

<cfset stFormCopy = duplicate(FORM)>

<cfset SearchRecord = structNew()>
<cfset structInsert(SearchRecord, "RMAUNIQ", stFormCopy.RMAUNIQ, True)>
<!--- Get a query of the Return detail --->
<cfset qryRADET = objRADET.searchRecords(SearchRecord, "query")>

<cfloop query="qryRADET">
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "RMAUNIQ", qryRADET.RMAUNIQ, True)>
	<cfset structInsert(SearchRecord, "LINENUM", qryRADET.LINENUM, True)>
	<cfset structInsert(SearchRecord, "Posted", 0, True)>
	<cfset qrySerialsReturns = objSerialsReturns.searchRecords(SearchRecord, "query")>
	<cfif qrySerialsReturns.RecordCount GT 0>
	
		<cfset stRecord = structNew()>
		<cfset structInsert(stRecord, "RMAUNIQ", stFormCopy.RMAUNIQ, True)>
		<cfset strRAHEAD = objRAHEAD.getRecord(stFormCopy.RMAUNIQ)>
		<cfset structInsert(stRecord, "TransactionNumber", strRAHEAD.RMANUMBER, True)>
		<cfset structInsert(stRecord, "CUSTOMER", strRAHEAD.CUSTOMER, True)>
		<cfset structInsert(stRecord, "BILNAME", strRAHEAD.BILNAME, True)>
		<cfset structInsert(stRecord, "PrintBarCodeLabels", 0, True)>
		<cfset structInsert(stRecord, "RMAACTION", "Receiving", True)>
		<cfset structInsert(stRecord, "ITEM", qryRADET.ITEM, True)>
		<cfset structInsert(stRecord, "LINENUM", qryRADET.LINENUM, True)>
		<cfset structInsert(stRecord, "LOCATION", qryRADET.LOCATION, True)>
		<cfset structInsert(stRecord, "NumberOfBoxes", qrySerialsReturns.RecordCount, True)>
		<cfset structInsert(stRecord, "StartBoxNumber", 1, True)>
		<cfset SNCounter = 1>
		<cfloop query="qrySerialsReturns">
			<cfset FieldName = "SN_" & SNCounter>
			<cfset SNCounter = SNCounter + 1>
			<cfset structInsert(stRecord, FieldName, qrySerialsReturns.SerialNumber, True)>
		</cfloop>

		<!--- Save Serial Numbers to tblSerialsReturns --->
		<cfset objSerialsReturns.saveSerialNumberInput(stRecord)>
		
		<!--- Set the "posted" flag for all records in tblSerialsReturns --->
		<cfset objSerialsReturns.setPosted(stRecord)>
		
		<!--- Add Serial Numbers to tblSerials --->
		<cfset objSerialsReturns.addSerialNumbers(stRecord)>
		
		<!--- Create Audit Trail entries in tblSerialNumberAuditTrail --->
		<cfset objSerialsReturns.createAuditTrail(stRecord, "Return")>

	</cfif>
</cfloop>

<cflocation url="index.cfm?task=serials_returns_serials_view&RMAUNIQ=#urlEncodedFormat(stFormCopy.RMAUNIQ)#&LINENUM=0&RMAAction=Receiving&PostingAll=1">