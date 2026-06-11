<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	1/16/2013
	Function: 		Price Lists: Seach Parts
	Template:		actSearch.cfm
	Task:			config_pricelists_actSearch
--->
<!---
<cfset objPartsOrdersItems= createObject("component", "admin.assets.cfcs.parts.PartsOrdersItems")>
--->
<cfset stFormCopy = duplicate(FORM)>
<!---
stFormCopy:<cfdump var="#stFormCopy#">
--->
<!---
<cfif isDefined("stFormCopy.PriceListCategoryID")>
	<cfset PriceListCategoryID = stFormCopy.PriceListCategoryID>
<cfelse>
	<cfset PriceListCategoryID = "">
</cfif>
--->

<cfif trim(stFormCopy.SearchText) IS "">
    <cflocation url="index.cfm?task=#stFormCopy.task_CameFrom#&SearchTextError=1&PriceListID=#urlEncodedFormat(stFormCopy.PriceListID)#&PriceListCategoryID=#urlEncodedFormat(stFormCopy.PriceListCategoryID)#">

<cfelse>

	<cflocation url="index.cfm?task=config_pricelists_components_edit&SearchText=#urlEncodedFormat(stFormCopy.SearchText)#&PriceListID=#urlEncodedFormat(stFormCopy.PriceListID)#&PriceListCategoryID=#urlEncodedFormat(PriceListCategoryID)#&SearchComponents=1">
   
</cfif>