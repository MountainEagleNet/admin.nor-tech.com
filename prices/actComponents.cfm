<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/18/2007
	Function: 		This page saves the components for the price list
	Template:		actComponents.cfm
	Task:			config_pricelists_components_act
--->
<cfset objPriceLists = createObject("component", "admin.assets.cfcs.prices.PriceLists")>
<cfset objPriceListComponents = createObject("component", "admin.assets.cfcs.prices.PriceListComponents")>
<cfset objComponentPrices = createObject("component", "admin.assets.cfcs.config.ComponentPrices")>
<cfset stFormCopy = duplicate(FORM)>
<!---
<cfdump var="#stFormCopy#">
<cfabort>
--->
<cfparam name="stFormCopy.SortColumn" default="ITEMNO">
<cfparam name="stFormCopy.SortOrder" default="Asc">

<!--- SAVE COMPONENTS --->
<cfif isDefined("stFormCopy.ButtonClicked") AND stFormCopy.ButtonClicked IS "Save Components">

	<!--- Assign Components --->
	<cfset objPriceListComponents.assignComponents(stFormCopy)>
	<cfset objPriceListComponents.setMessage("The components have been saved.")>
    
    <cfif stFormCopy.PriceListCategoryID IS NOT "">
        <cflocation url="index.cfm?task=config_pricelists_components_edit&PriceListCategoryID=#urlEncodedFormat(stFormCopy.PriceListCategoryID)#&SortColumn=#stFormCopy.SortColumn#&SortOrder=#stFormCopy.SortOrder#">	
	<cfelse>
        <cflocation url="index.cfm?task=config_pricelists_components_edit&SearchText=#urlEncodedFormat(stFormCopy.SearchText)#&PriceListID=#urlEncodedFormat(stFormCopy.PriceListID)#&PriceListCategoryID=#urlEncodedFormat(PriceListCategoryID)#&SearchComponents=1">
        
    </cfif>
	
<!--- UPDATE COMPONENT PRICES --->	
<cfelse>
	<cfset PriceListComponentID = objPriceListComponents.saveFixedPrice(stFormCopy)>
<!---<cfif PriceListComponentID IS "ERROR|FIXED_PRICE">--->
	<cfif findNoCase('ERROR|FIXED_MRKUP', PriceListComponentID) NEQ 0 OR 
		  findNoCase('ERROR|FIXED_PRICE', PriceListComponentID) NEQ 0 OR 
		  findNoCase('ERROR|FIXED_PRCNT', PriceListComponentID) NEQ 0>

		<cfset stErrors = structNew()>
		<cfset ErrorPriceListComponentID = removeChars(PriceListComponentID, 1, 18)>
		
		<cfif findNoCase('ERROR|FIXED_MRKUP', PriceListComponentID) NEQ 0>
			<cfset structInsert(stErrors, "MRK|#ErrorPriceListComponentID#", 1, True)>
		<cfelseif findNoCase('ERROR|FIXED_PRICE', PriceListComponentID) NEQ 0>
			<cfset structInsert(stErrors, "FIX|#ErrorPriceListComponentID#", 1, True)>
		<cfelse>
			<cfset structInsert(stErrors, "PCT|#ErrorPriceListComponentID#", 1, True)>
		</cfif>
		
		<cfset objPriceListComponents.setErrorRecord(stErrors)>
		<cfset objPriceListComponents.setDataRecord(stFormCopy)>

		<cfset objPriceListComponents.setMessage("Please correct the fields indicated below.")>

		<cfif findNoCase('ERROR|FIXED_MRKUP', PriceListComponentID) NEQ 0>
        
			<cflocation url="index.cfm?task=config_pricelists_components_edit&PriceListCategoryID=#urlEncodedFormat(stFormCopy.PriceListCategoryID)#&ErrorFixedMarkup=1&SortColumn=#stFormCopy.SortColumn#&SortOrder=#stFormCopy.SortOrder#&Validation=1">	
            
		<cfelseif findNoCase('ERROR|FIXED_PRICE', PriceListComponentID) NEQ 0>
			<cflocation url="index.cfm?task=config_pricelists_components_edit&PriceListCategoryID=#urlEncodedFormat(stFormCopy.PriceListCategoryID)#&ErrorFixedPrice=1&SortColumn=#stFormCopy.SortColumn#&SortOrder=#stFormCopy.SortOrder#&Validation=1">	
            
		<cfelse>
			<cflocation url="index.cfm?task=config_pricelists_components_edit&PriceListCategoryID=#urlEncodedFormat(stFormCopy.PriceListCategoryID)#&ErrorPercentMarkup=1&SortColumn=#stFormCopy.SortColumn#&SortOrder=#stFormCopy.SortOrder#&Validation=1">	
            
		</cfif>
		
	<cfelse>
		<cfset objPriceListComponents.calculateSellingPrice(PriceListComponentID)>
        
		<cfset strPriceListComponent = objPriceListComponents.getRecord(PriceListComponentID)>
		<cfset objPriceListComponents.setMessage("The selling price was successfully updated for component '#trim(strPriceListComponent.ITEMNO)#'")>
        
		<cfif stFormCopy.PriceListCategoryID IS NOT "">
            <cflocation url="index.cfm?task=config_pricelists_components_edit&PriceListCategoryID=#urlEncodedFormat(stFormCopy.PriceListCategoryID)#&SortColumn=#stFormCopy.SortColumn#&SortOrder=#stFormCopy.SortOrder#">	
		<cfelse>
            <cflocation url="index.cfm?task=config_pricelists_components_edit&SearchText=#urlEncodedFormat(stFormCopy.SearchText)#&PriceListID=#urlEncodedFormat(stFormCopy.PriceListID)#&PriceListCategoryID=#urlEncodedFormat(PriceListCategoryID)#&SearchComponents=1">
        </cfif>            
            
	</cfif>
</cfif>