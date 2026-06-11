<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/26/2006
	Function: 		This page finds an order after entering an order number and clicking "Go"
	Template:		findOrder.cfm
	Task:			serials_orders_find
--->
<cfset objOEORDH = createObject("component", "admin.assets.cfcs.OEORDH")>

<cfif NOT isDefined("Form.OrderNumber") OR trim(Form.OrderNumber) IS "">
	<!--- Order Number not entered (blank) --->
	<cflocation url="index.cfm?task=serials_orders_enter&Error=Blank&RequestTimeout=6000">
<cfelse>
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "ORDNUMBER", trim(Form.OrderNumber), True)>
	<cfset qryOrders = objOEORDH.searchRecords(SearchRecord, "query")>
	
	<!--- Order not found --->
	<cfif qryOrders.RecordCount EQ 0>
		<cflocation url="index.cfm?task=serials_orders_enter&Error=NotFound&OrderNumber=#Form.OrderNumber#&RequestTimeout=6000">

	<!--- Multiple Orders found for this Order number --->
	<cfelseif qryOrders.RecordCount GT 1>
		<cflocation url="index.cfm?task=serials_orders_enter&Error=MultipleFound&OrderNumber=#Form.OrderNumber#&RequestTimeout=6000">

	<!--- Order Found --->
	<cfelse>
<!---	<cflocation url="index.cfm?task=serials_orders_items_list&ORDUNIQ=#urlEncodedFormat(qryOrders.ORDUNIQ)#&ORDNUMBER=#urlEncodedFormat(qryOrders.ORDNUMBER)#">	--->
		<cflocation url="index.cfm?task=serials_orders_items_list&ORDUNIQ=#urlEncodedFormat(qryOrders.ORDUNIQ)#&RequestTimeout=6000">
	</cfif>
	
</cfif>