<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	02/26/2008
	Function: 		Copy Serial Numbers from Another Order, Action Page
	Template:		actSerialsOrderApply.cfm
	Task:			serials_shipments_orderapply_act
--->
<cfset objOEORDH = createObject("component", "admin.assets.cfcs.OEORDH")>
<!---<cfset objSerialsReceipts = createObject("component", "admin.assets.cfcs.SerialsReceipts")>--->
<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>

<cfif NOT isDefined("FORM.OrderNumber") OR trim(FORM.OrderNumber) IS "">
	<!--- Order Number not entered (blank) --->
	<cflocation url="index.cfm?task=serials_shipments_orderapply_edit&ORDUNIQ=#urlEncodedFormat(FORM.ORDUNIQ)#&Error=Blank">
<cfelse>

	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "ORDNUMBER", trim(FORM.OrderNumber), True)>
	<cfset qryOrders = objOEORDH.searchRecords(SearchRecord, "query")>
	
	<!--- Order not found --->
	<cfif qryOrders.RecordCount EQ 0>
		<cflocation url="index.cfm?task=serials_shipments_orderapply_edit&ORDUNIQ=#urlEncodedFormat(FORM.ORDUNIQ)#&Error=NotFound&OrderNumber=#FORM.OrderNumber#">

	<!--- Multiple Orders found for this Order number --->
	<cfelseif qryOrders.RecordCount GT 1>
		<cflocation url="index.cfm?task=serials_shipments_orderapply_edit&ORDUNIQ=#urlEncodedFormat(FORM.ORDUNIQ)#&Error=MultipleFound&OrderNumber=#FORM.OrderNumber#">

	<!--- Order Found --->
	<cfelse>

		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ORDUNIQ", trim(qryOrders.ORDUNIQ), True)>
		<cfset structInsert(SearchRecord, "Posted", 1, True)>		
		<cfset qrySerialsShipments = objSerialsShipments.searchRecords(SearchRecord, "query")>

		<!--- Order has no posted serial numbers --->
		<cfif qrySerialsShipments.RecordCount EQ 0>
		
			<cflocation url="index.cfm?task=serials_shipments_orderapply_edit&ORDUNIQ=#urlEncodedFormat(FORM.ORDUNIQ)#&Error=OrderNoSNs&OrderNumber=#FORM.OrderNumber#">

		<!--- Process It --->
		<cfelse>

			<cfset AtLeastOneSNApplied = objSerialsShipments.applySerialNumbersFromOrder(FORM.ORDUNIQ, qryOrders.ORDUNIQ)>
			<cfif AtLeastOneSNApplied>
				<cfset objSerialsShipments.setMessage("Serial Numbers were successfully applied to this order from Order number #trim(FORM.OrderNumber)#.")>
			<cfelse>
				<cfset objSerialsShipments.setMessage("** SERIAL NUMBERS WERE NOT APPLIED **<br>No Serial Numbers were available to be applied to this order from Order number #trim(FORM.OrderNumber)#.")>
			</cfif>
			<cflocation url="index.cfm?task=serials_orders_items_list&ORDUNIQ=#urlEncodedFormat(FORM.ORDUNIQ)#">
		
		</cfif>
	
	</cfif>
	
</cfif>