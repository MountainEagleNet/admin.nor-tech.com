<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	10/12/2006
	Function: 		This page finds an order after entering an order number and clicking "Go"
	Template:		findAttachOrder.cfm
	Task:			serials_attach_order_find
--->
<cfset objOEORDH = createObject("component", "admin.assets.cfcs.OEORDH")>
<cfset objOEORDD = createObject("component", "admin.assets.cfcs.OEORDD")>
<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>

<cfif NOT isDefined("Form.OrderNumber") OR trim(Form.OrderNumber) IS "">
	<!--- Order Number not entered (blank) --->
	<cflocation url="index.cfm?task=serials_attach_order_enter&Error=Blank">
<cfelse>
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "ORDNUMBER", trim(Form.OrderNumber), True)>
	<cfset qryOrders = objOEORDH.searchRecords(SearchRecord, "query")>
	
	<!--- Order not found --->
	<cfif qryOrders.RecordCount EQ 0>
		<cflocation url="index.cfm?task=serials_attach_order_enter&Error=NotFound&OrderNumber=#Form.OrderNumber#">

	<!--- Multiple Orders found for this Order number --->
	<cfelseif qryOrders.RecordCount GT 1>
		<cflocation url="index.cfm?task=serials_attach_order_enter&Error=MultipleFound&OrderNumber=#Form.OrderNumber#">

	<!--- Order Found --->
	<cfelse>
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ORDUNIQ", qryOrders.ORDUNIQ, True)>
		<cfset qrySerialsShipments = objSerialsShipments.searchRecords(SearchRecord, "query")>
		<!--- No Serial Numbers scanned for this order --->
		<cfif qrySerialsShipments.RecordCount EQ 0>
			<cflocation url="index.cfm?task=serials_attach_order_enter&Error=NoSerialNumbers&OrderNumber=#Form.OrderNumber#">
		<cfelse>
		
			<!--- See if there are any "unattached" serial numbers for this order --->
			<cfset FoundAtLeastOne = 0>
			<cfset qryDetail = objOEORDD.getSerializedLines(qryOrders.ORDUNIQ)>
			<cfloop query="qryDetail">
				<!--- Get a query of the serial numbers entered --->
				<cfset SearchRecord = structNew()>
				<cfset structInsert(SearchRecord, "ORDUNIQ", qryDetail.ORDUNIQ, True)>
				<cfset structInsert(SearchRecord, "ORDLINENUM", qryDetail.LINENUM, True)>
				<cfset structInsert(SearchRecord, "AttachedToInvoice", 0, True)>
				<cfset qrySerialsShipments = objSerialsShipments.searchRecords(SearchRecord, "query")>
				<cfif qrySerialsShipments.RecordCount GT 0>
					<cfset FoundAtLeastOne = 1>
					<cfbreak>
				</cfif>
			</cfloop>
			<cfif NOT FoundAtLeastOne>
				<cflocation url="index.cfm?task=serials_attach_order_enter&Error=NoUnattachedSerialNumbers&OrderNumber=#Form.OrderNumber#">
			<cfelse>
				<cflocation url="index.cfm?task=serials_attach_confirm&ORDUNIQ=#urlEncodedFormat(qryOrders.ORDUNIQ)#&RequestTimeout=6000">
			</cfif>
		
		</cfif>
	</cfif>
</cfif>