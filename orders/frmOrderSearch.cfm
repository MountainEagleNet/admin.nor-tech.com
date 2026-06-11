<cfsilent>
	<!---
	Coded By: Alternative Systems, Inc - Ron Barth
	Create Date: 05/21/2010
	Edit Date: 
	Function: This page allows a customer to search their orders
	frmOrderSearch.cfm
	task: cust_orders_search
	--->
</cfsilent>

<cfset objOrders = createObject("component", "admin.assets.cfcs.orders.Orders")>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<!--- spacer --->
<tr>
	<td class="textsmall">&nbsp;</td>
</tr>

<tr>
	<td colspan="7" class="pagetitle">
		Orders for #objOrders.getCustomerName(URL.AcctNo)#
	</td>
</tr>

<tr>
	<td class="textmain">To search orders for this customer, enter criteria below and click 'Search Orders'.</td>
</tr>
<tr><td>&nbsp;</td></tr>

<form name="CustSearchForm" action="index.cfm?task=admin_orders_lstOrderSearch&RequestTimeout=6000" method="post">
<input type="hidden" name="AcctNo" value="#URL.AcctNo#" />

	<tr>
		<td class="textmain" align="left">
			<strong>Order date:</strong><br>
			<input name="OrdDate" size="10" maxlength="10"><br><br>
            
			<strong>Order number:</strong><br>
			<input name="OrdNumber" size="20" maxlength="22"><br><br>
            
			<strong>Invoice number:</strong><br>
			<input name="InvNumber" size="20" maxlength="22"><br><br>
            
			<strong>Part number:</strong><br>
			<input name="Item" size="20" maxlength="50"><br><br>
            
			<strong>Customer PO number:</strong><br>
			<input name="PONumber" size="20" maxlength="50"><br><br>
            			
			<strong>Serial Number:</strong><br>
			<input name="SerialNumber" size="20" maxlength="50"><br><br>
			
			<strong>Orders per page:</strong><br>
			<select name="qmr">
				<option value="20" selected>20 Orders</option>
				<option value="50">50 Orders</option>
				<option value="75">75 Orders</option>
				<option value="99999">All Orders</option>
			</select><br><br>
			<input type="submit" name="ProcessSearch" value="Search Orders">
		</td>
	</tr>
</form>
</table>
</cfoutput>