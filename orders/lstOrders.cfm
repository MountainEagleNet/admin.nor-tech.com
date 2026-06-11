<!---
Coded By: Alternative Systems, Inc - Ron Barth
Create Date: 05/21/2010
--->
<!---
APPLICATION.AdminLocation:<cfdump var="#APPLICATION.AdminLocation#"><br />
url.AcctNo:<cfdump var="#url.AcctNo#"><br />
--->

<cfset objOrders = createObject("component", "admin.assets.cfcs.orders.Orders")>

<cfparam name="URL.qsr" default="1">
<cfparam name="URL.qmr" default="20">
<cfparam name="URL.sb" default="OrdDate">
<cfparam name="URL.ad" default="DESC">

<cfset qryOrders = objOrders.getCustOrders(URL.AcctNo, URL.sb, URL.ad)>

<!---
<script language="JavaScript">
	function checkAll (currField)
	{
		for (i=0;i<currField.length;i++)
    	currField[i].checked=true;
	}
	function uncheckAll (currField)
	{
		for (i=0;i<currField.length;i++)
    	currField[i].checked=false;
	}
	function doCheck (currField,checkfield)
	{
		if (checkfield.checked == true)
		{
			checkAll(currField);
		}
		else
		{
			uncheckAll(currField);
		}
	}
</script>
--->

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<cfoutput>

<!---
<form name="exportOrders" action="index.cfm?task=cust_orders_export" method="post">
--->


<tr>
	<td colspan="7" class="pagetitle">
		Orders for #objOrders.getCustomerName(URL.AcctNo)#
	</td>
</tr>

<tr>
	<td colspan="7" class="textmain">The following list displays all orders for this customer.  Click a heading to re-sort the list.  Click an order number to view details about that order.<!---To export your orders, please check the appropriate orders and click the export button.---><br><br></td>
</tr>

<!--- Search Orders --->
<tr>
	<td class="textmain" align="right" colspan="7">
        <a href="index.cfm?task=admin_orders_frmOrderSearch&AcctNo=#URLEncodedFormat(URL.AcctNo)#">
            <strong>Search Orders</strong>
        </a>
	</td>
</tr>


<tr>
	<!--- [NEXT 20] --->
    <td colspan="7" class="textmain">
        <cf_nextprev queryname="qryOrders" actionstring="index.cfm?task=admin_orders_lstOrders&AcctNo=#URL.AcctNo#&sb=#URL.sb#&ad=#URL.ad#" querystartrow="#URL.qsr#" querymaxrows="#URL.qmr#">
    </td>
</tr>
<!---
<tr>
	<td colspan="7" class="textmain"><input type="checkbox" name="handleChecks" value="1" onClick="javascript: doCheck(document.exportOrders.InvUniqList,document.exportOrders.handleChecks)">&nbsp;Select All Orders on Page</td>
</tr>
--->

<!--- LIST HEADER --->
<tr>

<!---
	<td height="18" bgcolor="##006633" class="productTitle"><div align="center" class="style4"><font color="##FFFFFF">Export</font></div></td>
--->    

	<td height="18" bgcolor="##006633" class="productTitle">
    	<div align="center" class="style4">
            <a href="index.cfm?task=admin_orders_lstOrders&AcctNo=#URL.AcctNo#&sb=ordnumber&ad=<cfif lcase(URL.sb) EQ 'ordnumber'><cfif lcase(URL.ad) EQ 'asc'>desc<cfelse>asc</cfif><cfelse>asc</cfif>" class="menuwh">Order</a>
       	</div>
   	</td>
    
	<td height="18" bgcolor="##006633" class="productTitle">
    	<div align="center" class="style4">
        	<a href="index.cfm?task=admin_orders_lstOrders&AcctNo=#URL.AcctNo#&sb=orddate&ad=<cfif lcase(URL.sb) EQ 'orddate'><cfif lcase(URL.ad) EQ 'asc'>desc<cfelse>asc</cfif><cfelse>asc</cfif>" class="menuwh">Date</a>
       	</div>
   	</td>
    
	<td height="18" bgcolor="##006633" class="productTitle">
    	<div align="center" class="style4">
        	<a href="index.cfm?task=admin_orders_lstOrders&AcctNo=#URL.AcctNo#&sb=invnumber&ad=<cfif lcase(URL.sb) EQ 'invnumber'><cfif lcase(URL.ad) EQ 'asc'>desc<cfelse>asc</cfif><cfelse>asc</cfif>" class="menuwh">Invoice</a>
       	</div>
   	</td>
    
	<td height="18" bgcolor="##006633" class="productTitle">
    	<div align="center" class="style4">
        	<a href="index.cfm?task=admin_orders_lstOrders&AcctNo=#URL.AcctNo#&sb=ponumber&ad=<cfif lcase(URL.sb) EQ 'ponumber'><cfif lcase(URL.ad) EQ 'asc'>desc<cfelse>asc</cfif><cfelse>asc</cfif>" class="menuwh">PO</a>
       	</div>
  	</td>
    
<!---
	<td height="18" bgcolor="##006633" class="productTitle"><div align="center" class="style4"><font color="##FFFFFF">RMA</font></div></td>
--->

	<td height="18" bgcolor="##006633" class="productTitle">
    	<div align="center" class="style4">
        	<a href="index.cfm?task=admin_orders_lstOrders&AcctNo=#URL.AcctNo#&sb=shiptrack&ad=<cfif lcase(URL.sb) EQ 'shiptrack'><cfif lcase(URL.ad) EQ 'asc'>desc<cfelse>asc</cfif><cfelse>asc</cfif>" class="menuwh">Track</a>
       	</div>
  	</td>

</tr>
</cfoutput>

<cfset RowCounter = 1>
<cfoutput query="qryOrders" maxrows="#URL.qmr#" startrow="#URL.qsr#">

	<!--- Don't diplay orders that contain item "MC0010" on any line of the order --->
	<cfif NOT objOrders.orderContainsMC0010(qryOrders.INVUNIQ)>
    
        <tr<cfif RowCounter mod 2> style="background-color:##e5e5e6"</cfif>>
<!---
            <td class="textsmall" align="center">
            	<input type="checkbox" name="InvUniqList" value="#InvUniq#">            
            </td>
--->            
            <td class="textsmall" align="center">
            	<a href="index.cfm?task=admin_orders_dspOrderDetail&iid=#InvUniq#">
					<cfif len(trim(OrdNumber))>#OrdNumber#<cfelse>None</cfif>
               	</a>
          	</td>
            <td class="textsmall" align="center">#objOrders.DateFix(OrdDate)#</td>
            <td class="textsmall" align="center">#InvNumber#</td>
            <td class="textsmall" align="center">#PONumber#</td>
<!---            
            <td class="textsmall" align="center">
            	<a href="index.cfm?task=cust_orders_rma&iid=#InvUniq#">Request RMA</a>
           	</td>
--->            
            <td class="textsmall" align="center">
				<cfif len(ShipTrack)>
					<cfif FindNoCase("ups", ShipVia)>
                    	<a href="http://www.ups.com/WebTracking/track?loc=en_US">
					<cfelseif FindNoCase("fed", ShipVia)>
                    	<a href="http://fedex.com/Tracking?link=1&cntry_code=us&lid=//Track//Pack+Track+Corp">
                   	</cfif>
                    Track
					<cfif FindNoCase("fed", ShipVia) OR FindNoCase("ups", ShipVia)>
                    	</a>
                   	</cfif>
               	<cfelse>
                	N/A
               	</cfif>
           	</td>
        </tr>
        
		<cfset RowCounter = RowCounter + 1>

	</cfif>        
    
</cfoutput>
<!---
<tr>
	<td colspan="7" class="textmain">
		<input type="submit" value="Export"><br><br>
		<div class="textsmall">NOTE: Exporting orders will only export the orders checked on THIS<br>page.  If you wish to include more orders in the same export, please<br>use the <a href="https://partners.nor-tech.com/orders/index.cfm?task=cust_orders_search&EID=#SESSION.ID#">order search</a> and select "All Orders" under "Orders per Page".</div><br>
	</td>
</tr>
--->
<tr>
	<cfoutput>
    
		<!--- [NEXT 20] --->
		<td colspan="7" class="textmain">
			<cf_nextprev queryname="qryOrders" actionstring="index.cfm?task=admin_orders_lstOrders&AcctNo=#URL.AcctNo#&sb=#URL.sb#&ad=#URL.ad#" querystartrow="#URL.qsr#" querymaxrows="#URL.qmr#">
		</td>
	</cfoutput>
	
</tr>
<!---
</form>
--->	
</table>