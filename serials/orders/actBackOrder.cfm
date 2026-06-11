<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	07/18/2007
	Function: 		Report Backorders
	Template:		actBackOrder.cfm
	Task:			serials_shipments_report_backorders
	
	Function:		Report backordered items for this order
--->
<cfset objBackOrder = createObject("component", "admin.assets.cfcs.BackOrder")>

<!--- Find items that need to be backordered, create records in tblBackOrder --->
<cfset objBackOrder.findBackOrderItems(URL.ORDUNIQ)>

<cfset objBackOrder.setMessage("The backorder reporting function completed succesfully.")>

<cflocation url="index.cfm?task=serials_orders_items_list&ORDUNIQ=#urlEncodedFormat(URL.ORDUNIQ)#">