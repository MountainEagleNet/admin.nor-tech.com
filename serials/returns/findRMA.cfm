<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/28/2006
	Function: 		This page finds an RMA after entering an RMA number and clicking "Go"
	Template:		findRMA.cfm
	Task:			serials_returns_find
--->
<cfset objRAHEAD = createObject("component", "admin.assets.cfcs.RAHEAD")>

<cfif NOT isDefined("Form.RMANumber") OR trim(Form.RMANumber) IS "">
	<!--- RMA Number not entered (blank) --->
	<cflocation url="index.cfm?task=serials_returns_enter&Error=Blank&RMAAction=#FORM.RMAAction#">
<cfelse>
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "RMANUMBER", trim(Form.RMANumber), True)>
	<cfset qryRMAs = objRAHEAD.searchRecords(SearchRecord, "query")>
	
	<!--- RMA not found --->
	<cfif qryRMAs.RecordCount EQ 0>
		<cflocation url="index.cfm?task=serials_returns_enter&Error=NotFound&RMANumber=#Form.RMANumber#&RMAAction=#FORM.RMAAction#">

	<!--- Multiple RMAs found for this RMA number --->
	<cfelseif qryRMAs.RecordCount GT 1>
		<cflocation url="index.cfm?task=serials_returns_enter&Error=MultipleFound&RMANumber=#Form.RMANumber#&RMAAction=#FORM.RMAAction#">

	<!--- RMA Found --->
	<cfelse>
		<cflocation url="index.cfm?task=serials_returns_items_list&RMAUNIQ=#urlEncodedFormat(qryRMAs.RMAUNIQ)#&RMAAction=#FORM.RMAAction#">
	</cfif>
	
</cfif>