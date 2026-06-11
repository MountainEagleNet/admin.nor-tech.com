<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/20/2007
	Function: 		Delete a price list
	Template:		delPriceList.cfm
	Task:			config_pricelists_delete
--->
<cfset objPriceLists = createObject("component", "admin.assets.cfcs.prices.PriceLists")>

<cfset listIsAssignedToResellers = objPriceLists.checkPriceListAssigned(URL.PriceListID)>

<cfif listIsAssignedToResellers>
	<cfset objPriceLists.setMessage("The price list is currently assigned to one or more resellers.  It must be removed from all resellers before it can be deleted.")>
	<cflocation url="index.cfm?task=config_pricelists_name_edit&PriceListID=#urlEncodedFormat(URL.PriceListID)#">
<cfelse>
	<cfset objPriceLists.deleteRecord(URL.PriceListID)>
	<cfset objPriceLists.setMessage("The price list has been successfully deleted.")>
	<cflocation url="index.cfm?task=config_pricelists_list">
</cfif>