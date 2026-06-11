<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	7/19/2007
	Function: 		Copy Serial Numbers to Other Lines
	Template:		actCopySerials.cfm
	Task:			serials_adjustments_serials_copy
--->

<cfset objSerialsAdjustments = createObject("component", "admin.assets.cfcs.SerialsAdjustments")>
<!---<cfset objICADEH = createObject("component", "admin.assets.cfcs.ICADEH")>--->
<cfset objICADED = createObject("component", "admin.assets.cfcs.ICADED")>

<cfset SearchRecord = structNew()>
<cfset structInsert(SearchRecord, "ADJENSEQ", URL.ADJENSEQ, True)>
<cfset structInsert(SearchRecord, "LINENO", URL.LINENO, True)>
<cfset qrySerialsAdjustmentsScanned = objSerialsAdjustments.searchRecords(SearchRecord, "query", "SortOrder")>

<cfset SearchRecord = structNew()>
<cfset structInsert(SearchRecord, "ADJENSEQ", URL.ADJENSEQ, True)>
<cfset qryICADED = objICADED.searchRecords(SearchRecord, "query", "[LINENO]")>

<cfset TotalAmountCopied = 0>
<cfloop query="qryICADED">
	<cfset CURRENT_LINENO = qryICADED.LINENO>
	<cfset CURRENT_QUANTITY = qryICADED.QUANTITY>
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "ADJENSEQ", URL.ADJENSEQ, True)>
	<cfset structInsert(SearchRecord, "LINENO", CURRENT_LINENO, True)>
	<cfset qrySerialsAdjustments = objSerialsAdjustments.searchRecords(SearchRecord, "query", "SortOrder")>
	<cfif qrySerialsAdjustments.RecordCount EQ 0>
		<cfset SNCount = 0>
		<cfloop query="qrySerialsAdjustmentsScanned">
			<cfif SNCount LT CURRENT_QUANTITY>
				<cfset strSerialsAdjustments = objSerialsAdjustments.newRecord()>
				<cfset structInsert(strSerialsAdjustments, "ADJENSEQ", URL.ADJENSEQ, True)>
				<cfset structInsert(strSerialsAdjustments, "LINENO", CURRENT_LINENO, True)>
				<cfset structInsert(strSerialsAdjustments, "SerialNumber", qrySerialsAdjustmentsScanned.SerialNumber, True)>
				<cfset structInsert(strSerialsAdjustments, "Posted", 0, True)>
				<cfset structInsert(strSerialsAdjustments, "PostedDate", now(), True)>
				<cfset structInsert(strSerialsAdjustments, "BarCodesPrinted", 0, True)>
				<cfset structInsert(strSerialsAdjustments, "SortOrder", qrySerialsAdjustmentsScanned.SortOrder, True)>
				<cfset objSerialsAdjustments.saveRecord(strSerialsAdjustments)>
				<cfset SNCount = SNCount + 1>
				<cfset TotalAmountCopied = TotalAmountCopied + 1>
			</cfif>
		</cfloop>
	</cfif>
</cfloop>

<cfif TotalAmountCopied GT 0>
	<cfset objSerialsAdjustments.setMessage("Serial Numbers were successfully copied to all lines of this adjustment.")>
<cfelse>
	<cfset objSerialsAdjustments.setMessage("** No Serial Numbers Were Copied **<br>Each line of this adjustment already has one or more serial numbers scanned in.")>
</cfif>
		
<!--- Go to item list page --->
<cflocation url="index.cfm?task=serials_adjustments_items_list&ADJENSEQ=#urlEncodedFormat(URL.ADJENSEQ)#">