<cfsilent>
	<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/29/2007
	Function: 		Export Price List Page
	Template:		actExport.cfm
	Task:			config_pricelists_export
	--->
	<cfset objPriceListComponents = createObject("component", "admin.assets.cfcs.prices.PriceListComponents")>

	<cfset textHeader = "Price List Name,Category,Category Description,Item Number,Sell Price#chr(10)#">

	<cfset qryPriceListComponents = objPriceListComponents.listRecordsForParent("PriceListID", URL.PriceListID, "CATEGORY, ITEMNO")>
</cfsilent>

<!--- loop over all components --->
<cfloop query="qryPriceListComponents">
	<cfif qryPriceListComponents.Active EQ 1>
		<cfoutput>
			<!--- header file --->
			<cfsavecontent variable="tmpHeader">#qryPriceListComponents.PriceListName#,#trim(qryPriceListComponents.Category)#,#trim(qryPriceListComponents.CategoryDescription)#,#trim(qryPriceListComponents.ITEMNO)#,#qryPriceListComponents.SellPrice##chr(13)##chr(10)#</cfsavecontent>
			<cfset textHeader = textHeader & tmpHeader>
		</cfoutput>
	</cfif>
</cfloop>

<!--- create the files --->
<cffile action="write" file="c:\wwwexport\pricelist-#URL.PriceListID#.csv" output="#textHeader#">

<cfheader name="Content-Disposition" value="attachment; filename=c:\wwwexport\pricelist-#URL.PriceListID#.csv" />
<cfcontent type="text/plain" file="c:\wwwexport\pricelist-#URL.PriceListID#.csv" />
