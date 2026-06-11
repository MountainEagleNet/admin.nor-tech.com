<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/18/2007
	Function: 		This page validates the New page, and creates the new price list
	Template:		actNew.cfm
	Task:			config_pricelists_new_act
--->
<cfset objPriceLists = createObject("component", "admin.assets.cfcs.prices.PriceLists")>

<cfset stFormCopy = duplicate(FORM)>

<cfset stErrors = objPriceLists.validate_frmNew(stFormCopy)>

<cfif NOT structIsEmpty(stErrors)>
	<cfset objPriceLists.setDataRecord(stFormCopy)>
	<cfset objPriceLists.setErrorRecord(stErrors)>
	<cfset objPriceLists.setMessage("Please correct the fields indicated below.")>
	<cflocation url="index.cfm?task=config_pricelists_new_edit&Validation=1">
<cfelse>
	<cfset PriceListID = objPriceLists.createNewPriceList(stFormCopy)>	
	<cflocation url="index.cfm?task=config_pricelists_name_edit&PriceListID=#urlEncodedFormat(PriceListID)#">
</cfif>