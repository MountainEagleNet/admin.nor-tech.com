<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/18/2007
	Function: 		Action page for the Name page
	Template:		actName.cfm
	Task:			config_pricelists_name_act
--->
<cfsetting requesttimeout="6000">

<cfset objPriceLists = createObject("component", "admin.assets.cfcs.prices.PriceLists")>
<cfset objComponentPrices = createObject("component", "admin.assets.cfcs.config.ComponentPrices")>
<cfset stFormCopy = duplicate(FORM)>

<cfparam name="stFormCopy.DefaultPriceList" default="0">

<!--- DELETE --->
<cfif isDefined("stFormCopy.ButtonClicked") AND stFormCopy.ButtonClicked IS "Delete">
	<cflocation url="index.cfm?task=config_pricelists_delete&PriceListID=#urlEncodedFormat(stFormCopy.PriceListID)#&RequestTimeout=6000">

<!--- EXPORT PRICE LIST --->
<cfelseif isDefined("stFormCopy.ButtonClicked") AND stFormCopy.ButtonClicked IS "Export Price List">
	<cflocation url="index.cfm?task=config_pricelists_export&PriceListID=#urlEncodedFormat(stFormCopy.PriceListID)#&RequestTimeout=6000">

<!--- VALIDATE AND SAVE --->
<cfelseif isDefined("stFormCopy.ButtonClicked") AND findNoCase('Continue', stFormCopy.ButtonClicked) NEQ 0>

	<cfset stErrors = objPriceLists.validate_frmName(stFormCopy)>
	
	<cfif structIsEmpty(stErrors)>
		<cfset PriceListID = objPriceLists.saveRecord(stFormCopy)>
		<cfset objPriceLists.setDefaultPriceList(stFormCopy)>
		<cfif NOT SESSION.UserOnVacation>        
			<cfset objPriceLists.setMessage("The price list has been saved.")>
		</cfif>
		<cflocation url="index.cfm?task=config_pricelists_categories_edit&PriceListID=#urlEncodedFormat(PriceListID)#">
	<cfelse>
		<cfset objPriceLists.setDataRecord(stFormCopy)>
		<cfset objPriceLists.setErrorRecord(stErrors)>
		<cfset objPriceLists.setMessage("Please correct the fields indicated below.")>
		<cflocation url="index.cfm?task=config_pricelists_name_edit&Validation=1">
	</cfif>


<!--- UPDATE ALL PRICES --->
<cfelse>

	<cfset PriceListID = objPriceLists.saveMarkupPercentage(stFormCopy)>
	<cfif PriceListID IS "ERROR|MARKUP_PERCENT">
		<cfset objPriceLists.setMessage("Please correct the fields indicated below.")>
		<cflocation url="index.cfm?task=config_pricelists_name_edit&PriceListID=#urlEncodedFormat(stFormCopy.PriceListID)#&ErrorMarkupPercent=1">	
	<cfelse>
		<cfset objPriceLists.calculateSellingPrices(PriceListID)>
        
		<cfset objPriceLists.setMessage("All selling prices were successfully updated for this price list")>
		<cflocation url="index.cfm?task=config_pricelists_name_edit&PriceListID=#urlEncodedFormat(stFormCopy.PriceListID)#">	
	</cfif>

</cfif>	