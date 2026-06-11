<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/05/2006
	Function: 		This page finds a transfer after entering a transfer number and clicking "Go"
	Template:		findTransfer.cfm
	Task:			serials_transfers_find
--->
<cfset objICTREH = createObject("component", "admin.assets.cfcs.ICTREH")>

<cfif NOT isDefined("Form.TransferNumber") OR trim(Form.TransferNumber) IS "">
	<!--- Transfer Number not entered (blank) --->
	<cflocation url="index.cfm?task=serials_transfers_list&Error=Blank">
<cfelse>
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "DOCNUM", trim(Form.TransferNumber), True)>
	<cfset qryTransfers = objICTREH.searchRecords(SearchRecord, "query")>
	
	<!--- Transfer not found --->
	<cfif qryTransfers.RecordCount EQ 0>
		<cflocation url="index.cfm?task=serials_transfers_list&Error=NotFound&TransferNumber=#Form.TransferNumber#">

	<!--- Multiple transfers found for this transfer number --->
	<cfelseif qryTransfers.RecordCount GT 1>
		<cflocation url="index.cfm?task=serials_transfers_list&Error=MultipleFound&TransferNumber=#Form.TransferNumber#">

	<!--- Transfer Found --->
	<cfelse>
		<cflocation url="index.cfm?task=serials_transfers_items_list&TRANFENSEQ=#urlEncodedFormat(qryTransfers.TRANFENSEQ)#">
	</cfif>
	
</cfif>