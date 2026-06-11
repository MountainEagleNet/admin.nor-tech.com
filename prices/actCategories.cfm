<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/07/2007
	Function: 		When one of the "Update Category Prices" links is clicked, this page is called.  
					It saves the category markup percentage (if one was entered), and recalculates the selling prices
					of all active components for this category.
	Template:		actCategories.cfm
	Task:			config_pricelists_categories_act	
--->
<cfset objPriceListCategories = createObject("component", "admin.assets.cfcs.prices.PriceListCategories")>
<cfset objComponentPrices = createObject("component", "admin.assets.cfcs.config.ComponentPrices")>
<cfset stFormCopy = duplicate(FORM)>

<!--- SORT CATEGORIES --->
<cfif isDefined("stFormCopy.ButtonClicked") AND stFormCopy.ButtonClicked IS "Update Categories">
	<!---
	<cfset objPriceListCategories.removeCategories(stFormCopy)>
	<cfset objPriceListCategories.sortCategories(stFormCopy)>
	<cfset PriceListCategoryID = objPriceListCategories.saveMarkupPercentages(stFormCopy)>
	--->
	<cfset objPriceListCategories.updateCategories(stFormCopy)>
	<cfset objPriceListCategories.setMessage("Categories have been successfully resorted.")>
	<cflocation url="index.cfm?task=config_pricelists_categories_edit&PriceListID=#urlEncodedFormat(stFormCopy.PriceListID)#&updated=1">	
</cfif>

<!--- UPDATE COMPONENT PRICES --->	
<!---
<cfif PriceListCategoryID IS "ERROR|MARKUP_PERCENT">
	<cfset objPriceListCategories.setMessage("Please correct the fields indicated below.")>
	<cflocation url="index.cfm?task=config_pricelists_categories_edit&PriceListID=#urlEncodedFormat(stFormCopy.PriceListID)#&ErrorMarkupPercent=1">	
<cfelse>
	<cfset objPriceListCategories.calculateSellingPrices(PriceListCategoryID)>
	<cfset PriceListCategoryID = objPriceListCategories.saveMarkupPercentage(stFormCopy)>
	<cfset strPriceListCategory = objPriceListCategories.getRecord(PriceListCategoryID)>
	<cfset objPriceListCategories.setMessage("All selling prices were successfully updated for category '#trim(strPriceListCategory.CategoryDescription)#'")>
	<cflocation url="index.cfm?task=config_pricelists_categories_edit&PriceListID=#urlEncodedFormat(stFormCopy.PriceListID)#">	
</cfif>
--->