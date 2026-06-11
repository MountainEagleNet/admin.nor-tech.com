<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/22/2007
	Function: 		Out of Stock Report - Action Page
	Template:		actStock.cfm
	Task:			serials_reports_actStock
	
	Function:
	
		Find all items that are part of comp builds that need to be backordered.  Selection criteria are as follows:
			[1] At least one serial number was scanned and posted today for any line of the order.
			[2] The order is a comp build ("ac-comp-build" or "ac-comp-server" is found on one of the lines of the order).
			[3] The order is not complete (at least one line has a backorder amount, or a discrepancy between the number of 
			   serial numbers scanned and the quantity on that line number).
			[4] The part is identified as a serialized item in ACCPAC.
		Also, check to make sure the order/item has not already been entered in tblBackOrder; it can only be entered once.	

		Generate and send two versions of the Out of Stock report, as follows:
			The "Sales Rep" Format:  
				This version is sent by email to each sales rep, and shows backordered items and quantities for orders 
				for their customers only.
			The "Purchasing" Format:  
				This version displays a list of all items and quantities that need to be backordered. 
				It is sent by email to the following addresses:
				jeffo@nor-tech.com, larryh@nor-tech.com, robb@nor-tech.com, todds@nor-tech.com, seanq@nor-tech.com.
--->
<cfsetting requesttimeout="6000">

<cfset objBackOrder = createObject("component", "admin.assets.cfcs.BackOrder")>

<!--- Find items that need to be backordered, create records in tblBackOrder --->
<cfset objBackOrder.findBackOrderItems()>

<!--- Send the "purchasing" and the "sales rep" versions of the out of stock report by email --->
<cfif NOT FORM.UpdateOnly>
	<cfset objBackOrder.emailOutOfStockReport()>
</cfif>

<cflocation url="index.cfm?task=serials_reports_dspStock&UpdateOnly=#FORM.UpdateOnly#">