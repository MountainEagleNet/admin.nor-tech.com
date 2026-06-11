<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/28/2008
	Function: 		
	Template:		frmQuote5.cfm
	Task:			quotes_new5
--->
<cfset objMiscParts = createObject("component", "admin.assets.cfcs.parts.MiscParts")>
<cfset objConfigComponentCategories = createObject("component", "admin.assets.cfcs.config.ConfigComponentCategories")>
<cfset objConfigComponents = createObject("component", "admin.assets.cfcs.config.ConfigComponents")>
<cfset objCust = createObject("component", "admin.assets.cfcs.Cust")>
<cfset objQuoteSystem = createObject("component", "admin.assets.cfcs.config.QuoteSystem")>
<cfset objSalesRep = createObject("component", "admin.assets.cfcs.SalesRep")>
<cfset objPriceListComponents = createObject("component", "admin.assets.cfcs.prices.PriceListComponents")>
<cfset objAdditionalWarranty = createObject("component", "admin.assets.cfcs.config.AdditionalWarranty")>
<cfset objConfigWarranty = createObject("component", "admin.assets.cfcs.config.ConfigWarranty")>

<cfset strQuoteScreen3 = objMiscParts.getSessionValue("QuoteScreen3")>
<cfset strQuoteScreen4 = objMiscParts.getSessionValue("QuoteScreen4")>
<cfset strQuoteScreen5 = objMiscParts.getSessionValue("QuoteScreen5")>
<!---
strQuoteScreen3:<cfdump var="#strQuoteScreen3#"><br>
strQuoteScreen4:<cfdump var="#strQuoteScreen4#"><br>
strQuoteScreen5:<cfdump var="#strQuoteScreen5#"><br>
<cfabort>
--->
<cfset qrySalesRep = objSalesRep.getRecordAsQuery(objQuoteSystem.getSessionValue("salesrepid"))>
<cfset SalesRepEmail = qrySalesRep.repemail>

<cfset strReseller = objCust.getLoginRecord(strQuoteScreen3.CustomerID)>
<cfset ResellerEmailAddress = strReseller.email>

<!---
strReseller:<cfdump var="#strReseller#"><br>
<cfabort>
--->

<cfif NOT isDefined("URL.ShippingCharge")>
	<cfset stErrors = structNew()>
<cfelse>
	<cfset stErrors = objCust.getErrorRecord()>
</cfif>

<cfset qryAdditionalWarranty = objAdditionalWarranty.listRecords()>

<cfif strQuoteScreen3.ConfigSystemID IS NOT "">
	<cfset SearchRecord = structNew()>
    <cfset structInsert(SearchRecord, "ConfigSystemID", strQuoteScreen3.ConfigSystemID, True)>
    <cfset qryConfigWarranty = objConfigWarranty.searchRecords(SearchRecord, "query", "SortOrder")>
</cfif>

<script language="JavaScript">
<!-- Hide script from old browsers
	function calculateTotal() {
		var TotalExtention = eval(document.detailform.QuoteTotalPrice.value * document.detailform.Quantity.value).toFixed(2);
		var TotalExtention2 = "$" + TotalExtention
		
		document.all["Extension"].innerHTML = TotalExtention2;
	}
// End hiding script from old browsers -->
</script>


<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<form action="index.cfm?task=quotes_new5_act&RequestTimeout=6000" method="Post" name="detailform">
<input type="hidden" name="ConfigSystemID" value="#strQuoteScreen3.ConfigSystemID#">
<input type="hidden" name="CustomerID" value="#strQuoteScreen3.CustomerID#">
<input type="hidden" name="SalesRepEmail" value="#SalesRepEmail#">
<input type="hidden" name="ResellerEmailAddress" value="#ResellerEmailAddress#">
<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objMiscParts.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>


<cfset qryConfigParts = queryNew("SellPrice")>

<!--- ======================= --->
<!--- CONFIGUTATOR COMPONENTS --->
<!--- ======================= --->

<cfif strQuoteScreen3.ConfigSystemID IS NOT "">
	<!--- Get a query of the component categories --->
    <cfset qryConfigComponentCategories = objConfigComponentCategories.getCategories_Config(strQuoteScreen3.ConfigSystemID)>
<!---
<tr>
<td>
strQuoteScreen3:<cfdump var="#strQuoteScreen3#"><br />
qryConfigComponentCategories:<cfdump var="#qryConfigComponentCategories#"><br />
</td>
</tr>
--->

    
    <!---<cfdump var="#qryConfigComponentCategories#">--->
    <tr><td class="textsmall"><hr /></td></tr>
    
    <tr>
        <td>
            <table cellpadding="2" cellspacing="4" width="100%" border="0">
                <tr>
                    <td valign="middle" class="textmain" colspan="4"><b>Configurator Components:</b></td>
                    <td width="20%" valign="middle" class="textmain" align="right">Price</td>
                </tr>
                <tr>
                    <!--- SYSTEM BASE PRICE --->
                    <td align="right" valign="top" width="25%" colspan="2" class="systemCategory">System Base Price:</td>
                    <td align="left" valign="top" class="textsmall" colspan="2">&nbsp;</td>
                    <!--- SELLING PRICE --->
                    <td align="right" valign="top" class="textsmall">
                        <cfif isNumeric(strQuoteScreen3.SystemBasePrice)>
                            #dollarFormat(strQuoteScreen3.SystemBasePrice)#
                        <cfelse>
                            $0.00                               
                        </cfif>
                    </td>
                </tr>


                <tr>
                    <td valign="bottom" align="right" class="systemCategory" style="color:000099">Category</td>
                    <td valign="bottom" align="center" class="systemCategory" style="color:000099">Quantity</td>
                    <td valign="bottom" align="left" class="systemCategory" style="color:000099">Component</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                
                <cfset lstForm = structKeyList(strQuoteScreen3)>

                <cfloop query="qryConfigComponentCategories">
                
					<cfif qryConfigComponentCategories.CategoryName IS "EnergyStar">
						<cfset IgnoreCategory = 0>
                        <cfset IgnoreField = "IGNORE|" & qryConfigComponentCategories.ConfigComponentCategoryID>
                        <cfif listFindNoCase(lstForm, IgnoreField) NEQ 0>
                            <cfset IgnoreCategory = 1>
                        </cfif>
                    	<cfif IgnoreCategory>
                            <input type="hidden" name="IgnoreEnergyStar" value="yes">
                        <cfelse>
                            <tr>
                                <!--- CATEGORY LABEL --->
                                <td valign="middle" align="right" width="30%" class="systemCategory">
                                    #qryConfigComponentCategories.CategoryName#:
                                </td>
                                <!--- QUANTITY --->
                                <td valign="middle" align="center" width="7%" class="systemCategory">&nbsp;</td>
                                <!--- SELECTED COMPONENT --->
                                <td valign="middle" align="left" class="textsmall">
                                    ENERGY STAR COMPLIANT SYSTEM
                                </td>
                            </tr>
                        </cfif>
        
                    <cfelse>
                	
						<cfset SelectBoxName = "CAT_" & qryConfigComponentCategories.ConfigComponentCategoryID>
                        <cfif listFindNoCase(lstForm, SelectBoxName) NEQ 0>
                            <cfset SelecBoxValue = strQuoteScreen3[SelectBoxName]>
                            <cfset ConfigComponentID = left(SelecBoxValue, FindNoCase("|",SelecBoxValue)-1)>
                            
        <!---                    
                            <cfset strConfigComponent = objConfigComponents.getRecord(ConfigComponentID)>
                            
        <cfdump var="#strConfigComponent#">
        --->
                            <cfset strConfigComponent = objConfigComponents.fillComponentOptions_QUOTE(qryConfigComponentCategories.ConfigComponentCategoryID,strQuoteScreen3.PriceListID,ConfigComponentID)>
        
        <!---<cfdump var="#strConfigComponent#">--->
        
                           
        <!---				<cfset ComponentDescription = objConfigComponents.getItemDescription(strConfigComponent.ITEMNO)>	--->
                            <cfif structKeyExists(strConfigComponent, "Description") neq 0>
								<cfset ComponentDescription = strConfigComponent.Description>
							<cfelse>
								<cfset ComponentDescription = "">
							</cfif>
                            <cfset IgnoreCategory = 0>
                            <cfset IgnoreField = "IGNORE|" & qryConfigComponentCategories.ConfigComponentCategoryID>
                            <cfif listFindNoCase(lstForm, IgnoreField) NEQ 0>
                                <cfset IgnoreCategory = 1>
                            </cfif>
                            
                            <cfif trim(ConfigComponentID) IS NOT "" AND trim(ComponentDescription) IS NOT "" AND NOT IgnoreCategory>
                                <tr>
                                    <!--- CATEGORY LABEL --->
                                    <td align="right" valign="top" width="25%" class="systemCategory">
                                        #qryConfigComponentCategories.CategoryName#:
                                    </td>
                                    
                                    <!--- QUANTITY --->
                                    <cfset QuantityField = "QTY|" & qryConfigComponentCategories.ConfigComponentCategoryID>
                                    <cfset QuantityValue = 1>
                                    <cfif structKeyExists(strQuoteScreen3, QuantityField)>
                                      <cfset QuantityValue = strQuoteScreen3[QuantityField]>
                                    </cfif>
                                    <td valign="top" align="center" width="7%" class="systemCategory">
                                        #QuantityValue#
                                        <input type="hidden" name="#QuantityField#" value="#QuantityValue#">
                                    </td>
    
                                    <!--- SELECTED COMPONENT --->
                                    <td align="left" valign="top" class="textsmall">
                                        #ComponentDescription#
                                        <input type="hidden" name="#SelectBoxName#" value="#ConfigComponentID#">
                                    </td>
                                    
                                    <!--- REMOVE POWER SUPPLY LINK --->
                                    <td align="right" valign="top" class="textsmall">
                                    	<cfif qryConfigComponentCategories.CategoryName IS "Power Supply">
                                            <a href="index.cfm?task=quotes_new5_act&RemovePS=1&ConfigComponentCategoryID=#urlEncodedFormat(qryConfigComponentCategories.ConfigComponentCategoryID)#">
                                                <b>[remove]</b>
                                            </a>
                                       	<cfelse>
                                        	&nbsp;     
                                    	</cfif>
                                    </td>
                                    
                                    <!--- SELLING PRICE --->
                                    <td align="right" valign="top" class="textsmall">
                                        <cfif isNumeric(strConfigComponent.SellPrice)>
                                            <cfset SellingPrice = strConfigComponent.SellPrice>
                                        <cfelse>
                                            <cfset SellingPrice = round(objPriceListComponents.getSellingPrice(strQuoteScreen3.PriceListID, strConfigComponent.ITEMNO))>
                                        </cfif>
                                        #dollarFormat(SellingPrice * QuantityValue)#
    
    
    <!---                                
                                        <cfif isNumeric(strConfigComponent.SellPrice)>
                                            #dollarFormat(strConfigComponent.SellPrice)#
                                        <cfelse>
                                            #dollarFormat(
                                                round(objPriceListComponents.getSellingPrice(strQuoteScreen3.PriceListID, strConfigComponent.ITEMNO))  
                                            )#
    
    <!---
                                        <cfelse>
                                            $0.00                               
    --->                                        
                                        </cfif>
    --->                                    
                                        <input type="hidden" name="SELLPRICE|#qryConfigComponentCategories.ConfigComponentCategoryID#" value="#strConfigComponent.SellPrice#">
                                    </td>
                                </tr>
                                <cfset queryAddRow(qryConfigParts)>
                                <cfset querySetCell(qryConfigParts, "SellPrice", (SellingPrice*QuantityValue))>
                            </cfif>
                        </cfif>
                    </cfif>
                </cfloop>			
                
            </table>	
        </td>
    </tr>
</cfif>


<!--- ========== --->
<!--- MISC PARTS --->
<!--- ========== --->

<tr><td class="textsmall"><hr /></td></tr>

<cfset qryMiscParts = strQuoteScreen4.qrySelectedParts>

<!---
qryMiscParts:<cfdump var="#qryMiscParts#"><br />
--->

<tr>
	<td>
		<table cellpadding="2" cellspacing="4" width="100%" border="0">
			<tr>
				<td valign="middle" class="textmain" colspan="2"><b>Misc Parts:</b></td>
				<td width="12%" valign="middle" class="textmain" align="right">Price</td>
				<td width="12%" valign="middle" class="textmain" align="center">Quantity</td>
				<td width="12%" valign="middle" class="textmain" align="right">Total</td>
			</tr>
			<cfloop query="qryMiscParts">
				<cfif qryMiscParts.MiscPartID IS NOT "">
                    <cfset PartType = "Misc Part">
                    <cfset strMiscPart = objMiscParts.getRecord(qryMiscParts.MiscPartID)>
                <cfelseif qryMiscParts.PriceListComponentID IS NOT "">
                    <cfset PartType = "Price List Part">
                    <cfset strPriceListComponent = objPriceListComponents.getRecord(qryMiscParts.PriceListComponentID)>
				<cfelse>
                    <cfset PartType = "ACCPAC Misc Part">
                </cfif>
            	<cfif PartType IS "Misc Part">
                    <input type="hidden" name="MISCPART|#qryMiscParts.MiscPartID#" value="#qryMiscParts.MiscPartID#">
				<cfelseif PartType IS "Price List Part">
                    <input type="hidden" name="PRICELISTPART|#qryMiscParts.PriceListComponentID#" value="#qryMiscParts.PriceListComponentID#">
				<cfelse>
                    <input type="hidden" name="ACCPACPART|#qryMiscParts.ACCPACPartID#" value="#qryMiscParts.ITEMNO#">
                </cfif>

				<tr>
					<!--- MfgrPartNumber --->
					<td align="right" valign="top" width="25%" class="systemCategory">
						<cfif PartType IS "Misc Part">
                            #strMiscPart.MfgrPartNumber#
                        <cfelseif PartType IS "Price List Part">
                            #strPriceListComponent.ITEMNO#
						<cfelse>
                        	#qryMiscParts.ITEMNO#
                        </cfif>                  
					</td>
                    
					<!--- Description --->
					<cfif PartType IS "Misc Part">
	                	<cfset PartDescription = strMiscPart.Description>
					<cfelseif PartType IS "Price List Part">
	                	<cfset PartDescription = objPriceListComponents.getItemDescription(strPriceListComponent.ITEMNO)>
					<cfelse>
                        <cfset PartDescription = objPriceListComponents.getItemDescription(qryMiscParts.ITEMNO)>
                    </cfif>                  
					<td valign="top" align="left" class="textsmall">
						#PartDescription#
					</td>
                    
					<!--- SELLING PRICE --->
                    <td valign="top" align="right" class="textsmall">
						<cfif PartType IS "Misc Part">
							<cfset CostKey = "COST|" & qryMiscParts.MiscPartID>
							<input type="hidden" name="SELLPRICE|#qryMiscParts.MiscPartID#" value="#strQuoteScreen4[CostKey]#">
                        <cfelseif PartType IS "Price List Part">
							<cfset CostKey = "COST|" & qryMiscParts.PriceListComponentID>
							<input type="hidden" name="SELLPRICE|#qryMiscParts.PriceListComponentID#" value="#strQuoteScreen4[CostKey]#">
                        <cfelse>
							<cfset CostKey = "COST|" & qryMiscParts.ACCPACPartID>
							<input type="hidden" name="SELLPRICE|#qryMiscParts.ACCPACPartID#" value="#strQuoteScreen4[CostKey]#">
                        </cfif>
                        
                    	<cfif structKeyExists(strQuoteScreen4, CostKey)>
							<cfif isNumeric(strQuoteScreen4[CostKey])>
                                #dollarFormat(strQuoteScreen4[CostKey])#
                            <cfelse>
                                $0.00                               
                            </cfif>
						</cfif>
                    </td>
                    
                    <!--- QUANTITY --->
                    <td valign="top" align="center" class="textsmall">
						<cfif PartType IS "Misc Part">
	                    	<cfset QuantityKey = "QTY|" & qryMiscParts.MiscPartID>
							<input type="hidden" name="QUANTITY|#qryMiscParts.MiscPartID#" value="#strQuoteScreen4[QuantityKey]#">
						<cfelseif PartType IS "Price List Part">
	                    	<cfset QuantityKey = "QTY|" & qryMiscParts.PriceListComponentID>
							<input type="hidden" name="QUANTITY|#qryMiscParts.PriceListComponentID#" value="#strQuoteScreen4[QuantityKey]#">
						<cfelse>
	                    	<cfset QuantityKey = "QTY|" & qryMiscParts.ACCPACPartID>
							<input type="hidden" name="QUANTITY|#qryMiscParts.ACCPACPartID#" value="#strQuoteScreen4[QuantityKey]#">
                        </cfif>                            
                    	<cfif structKeyExists(strQuoteScreen4, QuantityKey)>
							<cfif isNumeric(strQuoteScreen4[QuantityKey])>
                                #numberFormat(strQuoteScreen4[QuantityKey])#
                            <cfelse>
                                1                               
                            </cfif>
						</cfif>
                    </td>

                    <!--- EXTENSION --->
                    <cfset MiscPartExtension = strQuoteScreen4[CostKey] * strQuoteScreen4[QuantityKey]>
                    <td valign="top" align="right" class="textsmall">
                    	#dollarFormat(MiscPartExtension)#
                    </td>
                    
				</tr>
				<cfset queryAddRow(qryConfigParts)>
<!---           <cfset querySetCell(qryConfigParts, "SellPrice", strQuoteScreen4[CostKey])>	--->
                <cfset querySetCell(qryConfigParts, "SellPrice", MiscPartExtension)>
                
			</cfloop>
		</table>
	</td>
</tr>

<tr><td class="textsmall"><hr /></td></tr>

<!--- TOTAL PRICE --->
<cfset QuoteTotalCost = objQuoteSystem.getQuoteTotalCost(strQuoteScreen3, strQuoteScreen4)>

<cfset QuoteTotalPrice = objQuoteSystem.getQuoteTotalPrice(qryConfigParts, strQuoteScreen3.ConfigSystemID)>
<cfset CurrentQuantity = 1>

<cfif isDefined("URL.CopyingQuote") AND URL.CopyingQuote>
	<cfset strQuoteSystem = objQuoteSystem.getRecord(URL.QuoteSystemID)>
	<cfif isDefined("strQuoteSystem.Quantity")>
	    <cfset CurrentQuantity = strQuoteSystem.Quantity>	
	</cfif>
	<cfif isDefined("strQuoteSystem.ResellerPONumber")>
	    <cfset CurrentResellerPONumber = strQuoteSystem.ResellerPONumber>	
	</cfif>
	<cfif isDefined("strQuoteSystem.ResellerComments")>
	    <cfset CurrentResellerComments = strQuoteSystem.ResellerComments>	
	</cfif>
	<cfif isDefined("strQuoteSystem.AdditionalWarrantyID")>
	    <cfset CurrentAdditionalWarrantyID = strQuoteSystem.AdditionalWarrantyID>	
	</cfif>
<!---    
	<cfif isDefined("strQuoteSystem.ResellerPrice")>
	    <cfset QuoteTotalPrice = strQuoteSystem.ResellerPrice>	
	</cfif>
--->
</cfif>

<cfif isStruct(strQuoteScreen5) AND structKeyExists(strQuoteScreen5, "Quantity")>
	<cfset CurrentQuantity = strQuoteScreen5.Quantity>	
</cfif>
<cfif isStruct(strQuoteScreen5) AND structKeyExists(strQuoteScreen5, "ResellerPONumber")>
	<cfset CurrentResellerPONumber = strQuoteScreen5.ResellerPONumber>	
</cfif>
<cfif isStruct(strQuoteScreen5) AND structKeyExists(strQuoteScreen5, "ResellerComments")>
	<cfset CurrentResellerComments = strQuoteScreen5.ResellerComments>	
</cfif>
<cfif isStruct(strQuoteScreen5) AND structKeyExists(strQuoteScreen5, "AdditionalWarrantyID")>
	<cfset CurrentAdditionalWarrantyID = strQuoteScreen5.AdditionalWarrantyID>	
</cfif>

<cfif isStruct(strQuoteScreen5) AND structKeyExists(strQuoteScreen5, "ZipCode")>
	<cfset CurrentZipCode = strQuoteScreen5.ZipCode>	
</cfif>
<cfif isStruct(strQuoteScreen5) AND structKeyExists(strQuoteScreen5, "State")>
	<cfset CurrentState = strQuoteScreen5.State>	
</cfif>
<cfif isStruct(strQuoteScreen5) AND structKeyExists(strQuoteScreen5, "ShippingMethod")>
	<cfset CurrentShippingMethod = strQuoteScreen5.ShippingMethod>	
</cfif>
<cfif isStruct(strQuoteScreen5) AND structKeyExists(strQuoteScreen5, "ResidentialDelivery")>
	<cfset CurrentResidentialDelivery = strQuoteScreen5.ResidentialDelivery>	
</cfif>
<cfif isStruct(strQuoteScreen5) AND structKeyExists(strQuoteScreen5, "SignatureRequired")>
	<cfset CurrentSignatureRequired = strQuoteScreen5.SignatureRequired>	
</cfif>
<cfif isStruct(strQuoteScreen5) AND structKeyExists(strQuoteScreen5, "ShippingEstimate")>
	<cfset CurrentShippingEstimate = strQuoteScreen5.ShippingEstimate>	
</cfif>
<cfif isStruct(strQuoteScreen5) AND structKeyExists(strQuoteScreen5, "ErrorMessage")>
	<cfset CurrentErrorMessage = strQuoteScreen5.ErrorMessage>	
</cfif>
<cfset TabValue = 1>
<tr>
	<td>
		<table cellpadding="2" cellspacing="4" width="85%" border="0" align="center">
			<tr>
				<td valign="middle" class="textmain"><b>Total Cost:</b></td>
				<td valign="middle" class="textmain">#dollarFormat(QuoteTotalCost)#</td>
            </tr>            
			<tr>
				<td valign="middle" class="textmain" width="30%"><b>Quote Price:</b></td>
				<td valign="middle" class="textmain">
                    $<input name="QuoteTotalPrice" size="10" maxlength="50" class="textmain" tabindex="#TabValue#" 
						<cfif isNumeric(QuoteTotalPrice)>
	                    	value="#numberFormat(QuoteTotalPrice, '.99')#"
						<cfelse>
	                    	value="#QuoteTotalPrice#"
						</cfif>
                      onblur="calculateTotal()">
<!---				<input type="hidden" name="QuoteTotalPrice" value="#QuoteTotalPrice#">	--->
					<cfset TabValue = TabValue + 1>
                </td>
			</tr>
			<tr>
				<td valign="middle" class="textmain"><b>Quantity:</b></td>
				<td valign="middle" class="textmain">
                    &nbsp;<input name="Quantity" size="10" maxlength="50" class="textmain" value="#CurrentQuantity#" onblur="calculateTotal()" tabindex="#TabValue#">
					<cfset TabValue = TabValue + 1>
                </td>
			</tr>
			<tr>
				<td valign="middle" class="textmain"><b>Quote Total:</b></td>
				<td valign="middle" class="textmain" id="Extension"></td>
            </tr>            
		</table>
	</td>
</tr>

<tr><td class="textsmall"><hr /></td></tr>

<tr>
	<td>
		<table cellpadding="2" cellspacing="4" width="85%" border="0" align="center">
			<tr>
				<td valign="middle" class="textmain" width="30%"><b>PO Number:</b></td>
				<td valign="middle" class="textmain">
                    <input name="ResellerPONumber" size="20" maxlength="50" class="textmain" tabindex="#TabValue#"
                    	<cfif isDefined("CurrentResellerPONumber")>
							value="#CurrentResellerPONumber#"
						</cfif>
                    >
					<cfset TabValue = TabValue + 1>
                </td>
			</tr>
			<tr>
				<td valign="top" class="textmain"><b>Notes:</b></td>
				<td valign="middle" class="textmain">
                	<textarea name="ResellerComments" cols="45" rows="5" class="textmain" tabindex="#TabValue#"><cfif isDefined("CurrentResellerComments")>#CurrentResellerComments#</cfif></textarea>
				<cfset TabValue = TabValue + 1>
                </td>
			</tr>
		</table>
	</td>
</tr>

<tr><td class="textsmall"><hr /></td></tr>


<!---
strQuoteScreen3:<cfdump var="#strQuoteScreen3#"><br />
<cfabort>
--->
<!--- DEPOT (ADDITIONAL) WARRANTY --->
<cfif strQuoteScreen3.ConfigSystemID IS NOT "" AND objAdditionalWarranty.SystemHasDepotWarranty(strQuoteScreen3.ConfigSystemID)>
    <cfset CostOfItems = objAdditionalWarranty.getCostOfItems(strQuoteScreen3)>
<!---    
    <!--- If you're updating (copying) a quote, get the AdditionalWarrantyID from the quote that you're copying --->
    <cfif isDefined("strQuoteSystem.AdditionalWarrantyID")>
        <cfset THIS_AdditionalWarrantyID = strQuoteSystem.AdditionalWarrantyID>
    <!--- Otherwise, see if you're looping back for validation --->
    <cfelseif structKeyExists(stFormCopy, "AdditionalWarrantyID")>
        <cfset THIS_AdditionalWarrantyID = stFormCopy.AdditionalWarrantyID>
    <cfelse>
        <cfset THIS_AdditionalWarrantyID = "">
    </cfif>
--->    
	<cfif NOT isDefined("CurrentAdditionalWarrantyID")>    
    	<cfset CurrentAdditionalWarrantyID = "">
    </cfif>
    
    <tr>
        <td>
            <table cellpadding="2" cellspacing="4" width="85%" border="0" align="center">
                <tr>
    
                    <td width="30%" valign="top" align="left" class="textmain">
                        <b>Depot Warranty:</b>
                    </td>
                    <td valign="middle" align="left" class="textsmall">
                        <cfloop query="qryConfigWarranty">
                            <cfset DepotWarrantyMarkUp = objAdditionalWarranty.getMarkUp(CostOfItems, qryConfigWarranty.AdditionalWarrantyID)>
                            <input type="radio" name="AdditionalWarrantyID" value="#qryConfigWarranty.AdditionalWarrantyID#"
                                <cfif CurrentAdditionalWarrantyID IS qryConfigWarranty.AdditionalWarrantyID OR
								  	  CurrentAdditionalWarrantyID IS "" AND qryConfigWarranty.DefaultComponent EQ 1>
                                    checked="checked"
                                </cfif>
                            tabindex="#TabValue#">#qryConfigWarranty.Name# (add #dollarFormat(DepotWarrantyMarkUp)#)<br />
                            <input type="hidden" name="DEPOT_AMOUNT|#qryConfigWarranty.AdditionalWarrantyID#" value="#DepotWarrantyMarkUp#">
                            <input type="hidden" name="DEPOT_NAME|#qryConfigWarranty.AdditionalWarrantyID#" value="#qryConfigWarranty.Name#">
                        </cfloop>
                    </td>    
              	</tr>
			</table>
		</td>                                    
    </tr>
    
    <tr><td class="textsmall"><hr /></td></tr>
</cfif>
        







<!--- Shipping Charges --->
<cfif strReseller.FreightEstimator EQ 1 AND strQuoteScreen3.ConfigSystemID IS NOT "">
	<tr>
		<td colspan="3">
			<table width="100%" border="0" align="center" cellpadding="2" cellspacing="2">
				<tr>
					<td colspan="3" valign="top" align="left" class="systemCategory">
						Estimate Shipping Charges (optional):
					</td>
				</tr>
				<tr>
					<td valign="bottom" class="textsmall" colspan="3">
						To get an estimate of the shipping charges, enter information in the fields below and click "Estimate".<br />
						<cfif isDefined("CurrentShippingEstimate") AND CurrentShippingEstimate IS NOT "">
	                    	If you've changed your mind and want to remove the shipping charge estimate, click "Clear".
						</cfif>
					</td>
				</tr>
				
				<cfif isDefined("CurrentErrorMessage") AND CurrentErrorMessage IS NOT "">
                    <tr>
                        <td colspan="3" valign="middle" align="left" class="textmain">
                            <font color="FF0000">
                                #CurrentErrorMessage#
                            </font>
                        </td>
                    </tr>
                </cfif>

				<cfif structKeyExists(stErrors, "ZipCode")>
					<tr>
						<td>&nbsp;</td>
						<td valign="bottom" class="textsmall" colspan="2"><font color="FF0000">&raquo; #stErrors.ZipCode#</font></td>
					</tr>
				</cfif>
				<tr>
					<td width="28%" valign="middle" align="right" class="systemCategory">
						Ship-To Zip Code:
					</td>
					<td colspan="2" valign="middle" align="left" class="textsmall">
						<input name="ZipCode" size="30" 
	                    	<cfif isDefined("CurrentZipCode")>
								value="#CurrentZipCode#" 
							</cfif>
							<cfif structKeyExists(stErrors, "ZipCode")>
								style="border-top: 2px solid maroon; border-left: 2px solid maroon; border-bottom: 1px solid maroon; border-right: 1px solid maroon;"
							</cfif>			
						maxlength="50" tabindex="#TabValue#" class="textsmall">
						<cfset TabValue = TabValue + 1>
					</td>
				</tr>
				
				<cfif structKeyExists(stErrors, "State")>
					<tr>
						<td>&nbsp;</td>
						<td valign="bottom" class="textsmall" colspan="2"><font color="FF0000">&raquo; #stErrors.State#</font></td>
					</tr>
				</cfif>                        
				<tr>
					<td valign="middle" align="right" class="systemCategory">
						Ship-To State:
					</td>
					<td colspan="2" valign="middle" align="left" class="textsmall">
						<input name="State" size="30"
	                    	<cfif isDefined("CurrentState")>
								value="#CurrentState#" 
							</cfif>                                
							<cfif structKeyExists(stErrors, "State")>
								style="border-top: 2px solid maroon; border-left: 2px solid maroon; border-bottom: 1px solid maroon; border-right: 1px solid maroon;"
							</cfif>			
						maxlength="50" tabindex="#TabValue#" class="textsmall">
						<cfset TabValue = TabValue + 1>
					</td>
				</tr>

				<cfif structKeyExists(stErrors, "ShippingMethod")>
					<tr>
						<td>&nbsp;</td>
						<td valign="bottom" class="textsmall" colspan="2"><font color="FF0000">&raquo; #stErrors.ShippingMethod#</font></td>
					</tr>
				</cfif>                        
				<tr>
					<td valign="middle" align="right" class="systemCategory">
						Shipping Method:
					</td>
					<td valign="middle" align="left" class="textsmall">
						<select name="ShippingMethod" size="1" tabindex="#TabValue#" class="textsmall">
							<option value="">- Select -</option> 
							<option value="Ground" <cfif isDefined("CurrentShippingMethod") AND CurrentShippingMethod IS "Ground">selected="selected"</cfif>>Ground</option> 
							<option value="2nd Day Air" <cfif isDefined("CurrentShippingMethod") AND CurrentShippingMethod IS "2nd Day Air">selected="selected"</cfif>>2nd Day Air</option> 
							<option value="Next Day Air" <cfif isDefined("CurrentShippingMethod") AND CurrentShippingMethod IS "Next Day Air">selected="selected"</cfif>>Next Day Air</option> 
							<option value="FGround" <cfif isDefined("CurrentShippingMethod") AND CurrentShippingMethod IS "FGround">selected="selected"</cfif>>Fedex Ground</option>
							<option value="FSovernight" <cfif isDefined("CurrentShippingMethod") AND CurrentShippingMethod IS "FSovernight">selected="selected"</cfif>>Fedex Two Day</option>
							<option value="Fpovernight" <cfif isDefined("CurrentShippingMethod") AND CurrentShippingMethod IS "FPovernight">selected="selected"</cfif>>Fedex Priority Overnight</option>
							<option value="FFovernight" <cfif isDefined("CurrentShippingMethod") AND CurrentShippingMethod IS "FFovernight">selected="selected"</cfif>>Fedex First Overnight</option>
						</select>
						<cfset TabValue = TabValue + 1>
					</td>
					<td valign="middle" align="left" class="textsmall">
						<input type="submit" name="ButtonClicked" value="Estimate">
					</td>
				</tr>

				<tr>
					<td valign="middle" align="right" class="systemCategory">
						Residential Delivery?
					</td>
					<td colspan="2" valign="middle" align="left" class="textsmall">
						<input type="checkbox" name="ResidentialDelivery" value="1" <cfif isDefined("CurrentResidentialDelivery") AND CurrentResidentialDelivery IS "1">checked="checked"</cfif>>				
					</td>
				</tr>
				<tr>
					<td valign="middle" align="right" class="systemCategory">
						Signature Required?
					</td>
					<td colspan="2" valign="middle" align="left" class="textsmall">
						<input type="checkbox" name="SignatureRequired" value="1" <cfif isDefined("CurrentSignatureRequired") AND CurrentSignatureRequired IS "1">checked="checked"</cfif>>				
					</td>
				</tr>
				<cfif isDefined("CurrentShippingEstimate") AND CurrentShippingEstimate IS NOT "">
						<tr>
							<td valign="middle" align="right" class="textMediumBold" style="color:000099">
								Shipping Charge:
							</td>
                            <td valign="middle" align="left" class="textMediumBold" style="color:000099">
                                <cfif isNumeric(CurrentShippingEstimate)>
                                    #dollarFormat(CurrentShippingEstimate)#
                                <cfelse>
                                    #CurrentShippingEstimate#
                                </cfif>
                            </td>
                            <input type="hidden" name="ShippingEstimate" value="#CurrentShippingEstimate#">
                            <td valign="middle" align="left" class="textsmall">
                                <input type="submit" name="ButtonClicked" value="Clear">
                            </td>
						</tr>
                        <tr>
                            <td colspan="3" valign="middle" align="left" class="textsmall">
                                <font color="FF0000">
                                   This charge is an estimate only; your actual shipping charge may vary.  Please note that UPS will add a $9 fee if this is a COD shipment.
                                </font>				
                            </td>
                        </tr>
				</cfif>
			</table>
		</td>
	</tr>
	<tr><td colspan="3"><hr /></td></tr>
</cfif>
        
<tr>
	<td>
		<table cellpadding="2" cellspacing="4" width="100%" border="0">
			<tr>
				<td colspan="2" valign="middle" class="textmain"><b>Pick the Addresses you want to send this quote to:</b></td>
            </tr>
            <tr>
            	<td width="10%">&nbsp;</td>
            	<td valign="middle" class="textmain">
                	<input type="checkbox" name="SendToCustomer" value="1" checked="checked"> Customer (#ResellerEmailAddress#)
                </td>
            </tr>
            <tr>
            	<td width="10%">&nbsp;</td>
            	<td valign="middle" class="textmain">
                	<input type="checkbox" name="SendToSalesRep" value="1"> Sales Rep (#SalesRepEmail#)
                </td>
            </tr>
			

		</table>    
    </td>
</tr>

<tr><td class="textsmall"><hr /></td></tr>

<tr>
	<td>
		<table cellpadding="2" cellspacing="4" width="100%" border="0">
            <tr>
                <!--- "EDIT QUOTE" BUTTON --->
                <td valign="middle" align="center" class="textsmall">
                    <input type="submit" name="ButtonClicked" value="Edit Quote">
                </td>

                <!--- "SAVE QUOTE" BUTTON --->
                <td valign="middle" align="center" class="textsmall">
                    <input type="submit" name="ButtonClicked" value="Save Quote">
                </td>

                <!--- "EMAIL QUOTE" BUTTON --->
                <td valign="middle" align="center" class="textsmall">
                    <input type="submit" name="ButtonClicked" value="Email Quote">
                </td>
            </tr>	
		</table>
	</td>                    
</tr>            
                        	
<tr><td>&nbsp;</td></tr>

</form>
</table>
</cfoutput>

<script language="JavaScript" type="text/JavaScript">
<!--
calculateTotal();
-->
</script>
