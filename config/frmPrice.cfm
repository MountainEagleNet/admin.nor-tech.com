<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/14/2006
	Function: 		This page displays a form for adjusting the total price of the system
	Template:		frmPrice.cfm	
	Task:			config_setup_price_edit
--->

<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>
<cfset objConfigComponents = createObject("component", "admin.assets.cfcs.config.ConfigComponents")>
<cfset objConfigWarranty = createObject("component", "admin.assets.cfcs.config.ConfigWarranty")>
<cfset objAdditionalWarranty = createObject("component", "admin.assets.cfcs.config.AdditionalWarranty")>

<cfset objPriceLists = createObject("component", "admin.assets.cfcs.prices.PriceLists")>
<cfset objPriceListComponents = createObject("component", "admin.assets.cfcs.prices.PriceListComponents")>

<cfset stRecord = objConfigSystems.getRecord(URL.ConfigSystemID, "struct")>
<cfif stRecord.DefaultSystem>
	<cfset structInsert(stRecord, "PriceListID", "MASTERPRICELISTUUID", True)>
<cfelseif isDefined("URL.PriceListID")>
	<cfset structInsert(stRecord, "PriceListID", URL.PriceListID, True)>
<cfelse>
	<cfset structInsert(stRecord, "PriceListID", objPriceLists.getDefaultPriceListID(), True)>
</cfif>
<cfset structInsert(stRecord, "DefaultComponentsOnly", 1, True)>
<cfset stErrors = structNew()>
	
<cfset qryPriceLists = objPriceLists.listSalesRepPriceLists("DefaultPriceList DESC, Name")>
<cfset qryConfigComponents = objConfigComponents.listDefaultComponents(stRecord.ConfigSystemID)>
<cfset qryConfigWarranty = objConfigWarranty.listDefaultWarranty(stRecord.ConfigSystemID)>
<cfset isMaintainedByDefault = objConfigSystems.isMaintainedByDefault(stRecord.ConfigSystemID)>

<cfoutput>

<table width="570" border="0" align="center" cellpadding="3" cellspacing="1">
<form action="index.cfm?task=config_setup_price_save&RequestTimeout=6000" method="Post" name="detailform">
<input type="hidden" name="ConfigSystemID" value="#stRecord.ConfigSystemID#">
<input type="hidden" name="Name" value='#stRecord.Name#'>
<input type="hidden" name="DefaultSystem" value="#stRecord.DefaultSystem#">
<cfset TabValue = 1>

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">Default Pricing</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objConfigSystems.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<td>	
		<table cellpadding="2" cellspacing="2" width="100%" border="0">
			<tr>
				<td valign="middle" class="textmain" width="20%"><b>System Name:</b></td>
				<td valign="middle" class="textmain">#stRecord.Name#</td>
			</tr>
			<tr>
				<td valign="middle" class="textmain"><b>Price List:</b></td>
				<td valign="middle" class="textmain">
					<cfloop query="qryPriceLists">
					<cfif stRecord.PriceListID IS qryPriceLists.PriceListID>
						#qryPriceLists.Name# <cfif qryPriceLists.DefaultPriceList>(default)</cfif>
						<cfbreak>
					</cfif>				
					</cfloop>
					<input type="hidden" name="PriceListID" value="#stRecord.PriceListID#">
				</td>
			</tr>
		</table>
	</td>
</tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	
	<!--- LIST HEADINGS --->
	<tr>
		<td height="18" bgcolor="006633" class="productTitle" width="15%"><font color="FFFFFF">Category</font></td>
		<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Component</font></td>
		<td width="5%" height="18" bgcolor="006633" class="productTitle" align="center"><font color="FFFFFF">Default<br />Qty</font></td>
		<td height="18" bgcolor="006633" class="productTitle" align="right"><font color="FFFFFF">Cost</font></td>
		<td height="18" bgcolor="006633" class="productTitle" align="right"><font color="FFFFFF">Sell Price</font></td>
	</tr>
	
	<!--- DATA --->
	<cfif qryConfigComponents.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="5" class="productTitle"><font color="FF0000">There are no Components defined for this system.</font></td>
		</tr>
	</cfif>

	<!--- COMPONENTS --->
	<cfset TotalCost = 0>
	<cfset TotalSellPrice = 0>
	<cfloop query="qryConfigComponents">
		<cfset ItemCost = objConfigComponents.getItemCost(qryConfigComponents.ITEMNO)>
		<cfset ItemSellPrice = objPriceListComponents.getSellingPrice(stRecord.PriceListID, qryConfigComponents.ITEMNO)>
		<tr>
        <td class="textsmall" valign="top">#qryConfigComponents.CategoryName#</td>
		<td class="textsmall" valign="top">#objConfigSystems.getItemDescription(qryConfigComponents.ITEMNO)#</td>
		<cfset DefaultQuantity = objConfigComponents.getDefaultQuantity(qryConfigComponents.ConfigComponentCategoryID)>
		<td class="textsmall" valign="top" align="center">#DefaultQuantity#</td>
        <cfset ExtendedCost = ItemCost * DefaultQuantity>
		<td class="textsmall" align="right" valign="top">#numberFormat(ExtendedCost, '$.99')#</td>
		<td class="textsmall" align="right" valign="top">
		<cfif isNumeric(ItemSellPrice)>
      		<cfset ExtendedPrice = ItemSellPrice * DefaultQuantity>
			#numberFormat(ExtendedPrice, '$.99')#
		<cfelse>
			<font color="FF0000"><em><strong>[Unknown]</strong></em></font>
		</cfif>
		</td>
		</tr>
		<cfset TotalCost = TotalCost + ExtendedCost>
		<cfif isNumeric(ItemSellPrice)>
			<cfset TotalSellPrice = TotalSellPrice + ExtendedPrice>
		</cfif>
	</cfloop>

	<cfset TotalCostOfItems = TotalCost>
	<cfloop query="qryConfigWarranty">
  		<cfset DepotWarrantyMarkUp = objAdditionalWarranty.getMarkUp(TotalCostOfItems, qryConfigWarranty.AdditionalWarrantyID)>

		<tr>
            <td class="textsmall" valign="top">#qryConfigWarranty.CategoryName#</td>
			<td class="textsmall" valign="top">#qryConfigWarranty.Name#</td>
			<td class="textsmall" valign="top" align="center">1</td>
			<td class="textsmall" align="right" valign="top">#numberFormat(DepotWarrantyMarkUp, '$.99')#</td>
			<td class="textsmall" align="right" valign="top">#numberFormat(DepotWarrantyMarkUp, '$.99')#</td>
		</tr>
		<cfset TotalCost = TotalCost + DepotWarrantyMarkUp>
		<cfset TotalSellPrice = TotalSellPrice + DepotWarrantyMarkUp>
	</cfloop>
	
	<tr>
	<td class="textsmall" colspan="5"><hr /></td>
	</tr>
	<tr>
		<td class="textmain" colspan="3">TOTALS:</td>
		<td class="textsmall" align="right">#numberFormat(TotalCost, '$.99')#</td>
		<td class="textsmall" align="right">#numberFormat(TotalSellPrice, '$.99')#</td>
	</tr>
	
	<tr>
	<td class="textmain" colspan="5">
		System Base Price / Additional Amount: &nbsp;&nbsp; 
        $ #stRecord.SystemBasePrice#
		<input type="hidden" name="SystemBasePrice" value="#stRecord.SystemBasePrice#">
	</td>
	</tr>

	<cfif isNumeric(stRecord.SystemBasePrice)>
		<cfset SystemTotalCost = TotalCost + stRecord.SystemBasePrice>
		<cfset SystemTotalSellPrice = TotalSellPrice + stRecord.SystemBasePrice>
	<cfelse>
		<cfset SystemTotalCost = TotalCost>
		<cfset SystemTotalSellPrice = TotalSellPrice>
	</cfif>
	<tr style="background-color:##e5e5e6">
		<td class="textmain" colspan="3">System Total:</td>
		<td class="textmain" align="right">#dollarFormat(SystemTotalCost)#</td>
		<td class="textmain" align="right">#dollarFormat(SystemTotalSellPrice)#</td>
	</tr>
	

	<tr>
		<td valign="top" colspan="5" align="center">
			<table cellpadding="4" cellspacing="0" border="0" width="60%">
			<tr><td>&nbsp;</td></tr>
			<tr>
			<td align="right"><!--- "CONTINUE" BUTTON --->
				<input type="submit" name="ButtonClicked" value="&nbsp;Continue -&raquo;" tabindex="#TabValue#">
				<cfset TabValue = TabValue + 1>
			</td>
			</tr>
			</table>
		</td>
	</tr>

	</table>
</td>
</tr>
</form>
</table>
</cfoutput>