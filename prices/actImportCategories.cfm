<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/01/2007
	Function: 		Import Category Descriptions from ACCPAC, Action Page
	Template:		actImportCategories.cfm
	Task:			config_pricelists_import_categories_act
--->
<cfset objPriceLists = createObject("component", "admin.assets.cfcs.prices.PriceLists")>

<cfset objPriceLists.importCategoryDescriptions()>

<cflocation url="index.cfm?task=config_pricelists_import_categories_view">