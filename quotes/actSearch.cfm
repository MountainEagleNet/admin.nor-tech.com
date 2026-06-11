<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	07/13/2010
	Function: 		Parts Ordering: Seach Parts
	Template:		actSearch.cfm
	Task:			parts_actSearch
--->
<!---
<cfset objPartsOrdersItems= createObject("component", "admin.assets.cfcs.parts.PartsOrdersItems")>
--->
<cfset stFormCopy = duplicate(FORM)>
<!---
stFormCopy:<cfdump var="#stFormCopy#">
--->

<cfif isDefined("stFormCopy.PriceListCategoryID")>
	<cfset PriceListCategoryID = stFormCopy.PriceListCategoryID>
<cfelse>
	<cfset PriceListCategoryID = "">
</cfif>

<cfif trim(stFormCopy.SearchText) IS "">

	<cfif isDefined("stFormCopy.task_CameFrom")>
<!---    
		<cfset objPartsOrdersItems.setDataRecord(stFormCopy)>
        <cfset objPartsOrdersItems.setErrorRecord(structNew())>
--->
        <cflocation url="index.cfm?task=#task_CameFrom#&SearchTextError=1&UserID=#urlEncodedFormat(stFormCopy.UserID)#&PriceListID=#urlEncodedFormat(stFormCopy.PriceListID)#&CopyingQuote=#urlEncodedFormat(stFormCopy.CopyingQuote)#&QuoteSystemID=#urlEncodedFormat(stFormCopy.QuoteSystemID)#&CameFromScreen5=#urlEncodedFormat(stFormCopy.CameFromScreen5)#&PriceListCategoryID=#urlEncodedFormat(PriceListCategoryID)#">

    <cfelse>

        <cflocation url="index.cfm?task=quotes_new4_categories&SearchTextError=1&UserID=#urlEncodedFormat(stFormCopy.UserID)#&PriceListID=#urlEncodedFormat(stFormCopy.PriceListID)#&CopyingQuote=#urlEncodedFormat(stFormCopy.CopyingQuote)#&QuoteSystemID=#urlEncodedFormat(stFormCopy.QuoteSystemID)#&CameFromScreen5=#urlEncodedFormat(stFormCopy.CameFromScreen5)#&PriceListCategoryID=#urlEncodedFormat(PriceListCategoryID)#">

    </cfif>

<cfelse>

<!---
	<cfif isDefined("stFormCopy.PriceListCategoryID")>
    	<cfset PriceListCategoryID = stFormCopy.PriceListCategoryID>
    <cfelse>
    	<cfset PriceListCategoryID = "">
    </cfif>
--->
	<cflocation url="index.cfm?task=quotes_new4_frmComponentsSearch&SearchText=#urlEncodedFormat(stFormCopy.SearchText)#&UserID=#urlEncodedFormat(stFormCopy.UserID)#&PriceListID=#urlEncodedFormat(stFormCopy.PriceListID)#&CopyingQuote=#urlEncodedFormat(stFormCopy.CopyingQuote)#&QuoteSystemID=#urlEncodedFormat(stFormCopy.QuoteSystemID)#&CameFromScreen5=#urlEncodedFormat(stFormCopy.CameFromScreen5)#&PriceListCategoryID=#urlEncodedFormat(PriceListCategoryID)#">
   
</cfif>