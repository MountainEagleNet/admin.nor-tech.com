<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/03/2006
	Function: 		This page finds an adjustment after entering an adjustment number and clicking "Go"
	Template:		findAdjustment.cfm
	Task:			serials_adjustments_find
--->
<cfset objICADEH = createObject("component", "admin.assets.cfcs.ICADEH")>

<cfif NOT isDefined("Form.AdjustmentNumber") OR trim(Form.AdjustmentNumber) IS "">
	<!--- Adjustment Number not entered (blank) --->
	<cflocation url="index.cfm?task=serials_adjustments_list&Error=Blank">
<cfelse>
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "DOCNUM", trim(Form.AdjustmentNumber), True)>
	<cfset qryAdjustments = objICADEH.searchRecords(SearchRecord, "query")>
	
	<!--- Adjustment not found --->
	<cfif qryAdjustments.RecordCount EQ 0>
		<cflocation url="index.cfm?task=serials_adjustments_list&Error=NotFound&AdjustmentNumber=#Form.AdjustmentNumber#">

	<!--- Multiple adjustments found for this adjustment number --->
	<cfelseif qryAdjustments.RecordCount GT 1>
		<cflocation url="index.cfm?task=serials_adjustments_list&Error=MultipleFound&AdjustmentNumber=#Form.AdjustmentNumber#">

	<!--- Adjustment Found --->
	<cfelse>
		<cflocation url="index.cfm?task=serials_adjustments_items_list&ADJENSEQ=#urlEncodedFormat(qryAdjustments.ADJENSEQ)#">
	</cfif>
	
</cfif>