<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/29/2008
	Function: 		
	Template:		actQuote3.cfm
	Task:			quotes_new3_act
--->
<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>
<cfset objQuoteSystem = createObject("component", "admin.assets.cfcs.config.QuoteSystem")>

<cfset stFormCopy = duplicate(FORM)>
<!---
stFormCopy:<cfdump var="#stFormCopy#">
<cfabort>
--->
<cfif NOT stFormCopy.PowerSupplyDeleted>
	<cfset stFormCopy = objQuoteSystem.selectPowerSupply(stFormCopy)>
<cfelse>
	<cfset FieldName = "CAT_" & stFormCopy.PowerSupply_ConfigComponentCategoryID>
	<cfset structDelete(stFormCopy, FieldName)>
</cfif>

<!--- Get the total price of the system --->
<!---
<cfset ResellerPrice = round(objConfigSystems.getSystemTotalPrice(stFormCopy))>
--->

<cfset objConfigSystems.setSessionValue("QuoteScreen3", stFormCopy)>

<cflocation url="index.cfm?task=quotes_new4&UserID=#urlEncodedFormat(FORM.UserID)#&CustomerID=#urlEncodedFormat(FORM.CustomerID)#&ConfigSystemID=#urlEncodedFormat(FORM.ConfigSystemID)#&PriceListID=#urlEncodedFormat(FORM.PriceListID)#&CopyingQuote=#stFormCopy.CopyingQuote#&CameFromScreen5=#stFormCopy.CameFromScreen5#&QuoteSystemID=#urlEncodedFormat(stFormCopy.QuoteSystemID)#&RequestTimeout=6000">