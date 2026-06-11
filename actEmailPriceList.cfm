<!---
Coded By: 		Alternative Systems, Inc - Ron Barth
Create Date: 	5/15/2007
Edit Date: 
Function: 		Email price list to Customer
				
Template:		actEmailPriceList.cfm
Task:			admin_custaccounts_emailpricelist
--->
<cfset objCust = createObject("component", "admin.assets.cfcs.Cust")>
<cfset objPriceLists = createObject("component", "admin.assets.cfcs.prices.PriceLists")>
<cfset objSalesRep = createObject("component", "admin.assets.cfcs.SalesRep")>

<cfset ReplyToAddress = "info@nor-tech.com">

<cfif isDefined("URL.uid")>
	<cfset strCustomer = objCust.getRecordAsStruct(URLDecode(URL.uid))>
	<cfset Variables.PriceListID = strCustomer.PriceListID>
	<cfset ToAddress = strCustomer.email>
	<cfset ReplyToAddress = objSalesRep.getReplyToAddress(strCustomer.CustomerID)>
<cfelseif isDefined("URL.PriceListID") AND isDefined("URL.ToAddress")>
	<cfset Variables.PriceListID = URL.PriceListID>
	<cfset ToAddress = URL.ToAddress>
<cfelse>
	ERROR. 
	<cfabort>
</cfif>

<cfset PriceListText = objPriceLists.customerFormattedPriceList(Variables.PriceListID)>

<!--- Send the Email --->
<cfmail from=	"info@nor-tech.com"		
		to=		"#ToAddress#"
		replyto="#ReplyToAddress#"
		subject="Nor-Tech Customer Price List, #dateFormat(now(), 'mmmm d, yyyy')#" 
		
		
		type="html">
<html>
<head>
	<style type="text/css">
		BODY	{font-family: Verdana, Arial, Helvetica, sans-serif;}
	</style>
</head>
<body>
<!---
<div style="font-size:12px">
Greetings!<br><br>

Here is your Nor-Tech price list.<br><br>
</div>
--->

#PriceListText#
</body>
</html>	
</cfmail>
	
<!--- send the user back to the customer edit page --->
<cfif isDefined("URL.uid")>
	<cflocation url="index.cfm?task=admin_custaccounts_edit&uid=#URLEncodedFormat(strCustomer.ID)#&PriceListEmailed=1">
<cfelse>
	<cflocation url="index.cfm?task=config_pricelists_name_edit&PriceListID=#URLEncodedFormat(Variables.PriceListID)#&PriceListEmailed=1">
</cfif>