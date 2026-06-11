<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/28/2008
	Function: 		
	Template:		frmQuote4.cfm
	Task:			quotes_new4
--->
<cfset objMiscParts = createObject("component", "admin.assets.cfcs.parts.MiscParts")>
<cfset objPriceLists = createObject("component", "admin.assets.cfcs.prices.PriceLists")>
<cfset objQuoteSystem = createObject("component", "admin.assets.cfcs.config.QuoteSystem")>
<cfset objPriceListComponents = createObject("component", "admin.assets.cfcs.prices.PriceListComponents")>
<cfset objComponentCategories = createObject("component", "admin.assets.cfcs.config.ComponentCategories")>

<cfif isDefined("URL.UserID")>
	<cfset Variables.UserID = URL.UserID>
<cfelseif isDefined("FORM.UserID")>
	<cfset Variables.UserID = FORM.UserID>
</cfif>
<cfif isDefined("URL.PriceListID")>
	<cfset Variables.PriceListID = URL.PriceListID>
<cfelseif isDefined("FORM.PriceListID")>
	<cfset Variables.PriceListID = FORM.PriceListID>
</cfif>

<!---
<cfif isDefined("URL.CustomerID")>
	<cfset Variables.CustomerID = URL.CustomerID>
<cfelseif isDefined("FORM.CustomerID")>
	<cfset Variables.CustomerID = FORM.CustomerID>
</cfif>
--->

<cfset SearchRecord = structNew()>
<cfset structInsert(SearchRecord, "UserID", Variables.UserID, True)>
<cfset qryMiscParts = objMiscParts.searchRecords(SearchRecord, "query", "MfgrPartNumber", 1)>

<cfset strQuoteScreen4 = objMiscParts.getSessionValue("QuoteScreen4")>

<!--- If Creating a quote from an ACCPAC invoice --->
<cfif isDefined("URL.INVUNIQ") AND trim(URL.INVUNIQ) IS NOT "">
	<cfset strQuoteScreen4 = objQuoteSystem.createQuoteFromACCPAC(URL.INVUNIQ,Variables.PriceListID)>
	<cfset objQuoteSystem.setSessionValue("QuoteScreen4", strQuoteScreen4)>
    <cfset objMiscParts.setMessage("Parts have been added to this quote from the invoice you selected as outlined below.")>
</cfif>

<!--- If Copying a Quote to a New Customer --->
<cfif isDefined("URL.CopyQuoteNewCustomer") AND URL.CopyQuoteNewCustomer EQ 1>
	<cfset strQuoteScreen4 = objQuoteSystem.copyQuoteNewCustomer(URL.QuoteSystemID,Variables.PriceListID)>
	<cfset objQuoteSystem.setSessionValue("QuoteScreen4", strQuoteScreen4)>
</cfif>

<!---
strQuoteScreen4:<cfdump var="#strQuoteScreen4#"><br>
URL.CopyingQuote:<cfdump var="#URL.CopyingQuote#"><br>
--->

<cfparam name="URL.CopyingQuote" default="0">
<cfparam name="URL.QuoteSystemID" default="">
<cfparam name="URL.INVUNIQ" default="">

<cfif isStruct(strQuoteScreen4) AND structKeyExists(strQuoteScreen4, "qrySelectedParts")>
	<cfset qrySelectedParts = strQuoteScreen4.qrySelectedParts>
<cfelse>
	<cfif isDefined("URL.CopyingQuote") AND URL.CopyingQuote EQ 1>
		<cfset qrySelectedParts = objQuoteSystem.copyComponents(URL.QuoteSystemID)>
		<cfset strQuoteScreen4 = structNew()>
		<cfset structInsert(strQuoteScreen4, "qrySelectedParts", qrySelectedParts, True)>
		<cfset objMiscParts.setSessionValue("QuoteScreen4", strQuoteScreen4)>
	<cfelse>
		<cfset qrySelectedParts = queryNew("MiscPartID,PriceListComponentID,SellingPrice,Quantity,ACCPACPartID,ITEMNO")>
	</cfif>
</cfif>

<cfset strPriceList = objPriceLists.getRecord(Variables.PriceListID)>

<!---qryMiscParts:<cfdump var="#qryMiscParts#"><br>
qrySelectedParts:<cfdump var="#qrySelectedParts#"><br>
--->

<cfset qryComponentCategories = objComponentCategories.listRecords()>

<cfif isDefined("URL.CameFromScreen5")>
	<cfset CameFromScreen5 = URL.CameFromScreen5>
<cfelse>
	<cfset CameFromScreen5 = 0>
</cfif>
<!---
qrySelectedParts:<cfdump var="#qrySelectedParts#"><br />
--->
<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<form action="index.cfm?task=quotes_new4_act&RequestTimeout=6000" method="Post" name="detailform">
<input type="hidden" name="UserID" value="#Variables.UserID#">
<input type="hidden" name="PriceListID" value="#Variables.PriceListID#">
<input type="hidden" name="CopyingQuote" value="#URL.CopyingQuote#">
<input type="hidden" name="QuoteSystemID" value="#URL.QuoteSystemID#">
<input type="hidden" name="CameFromScreen5" value="#CameFromScreen5#">
<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objMiscParts.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall"><hr /></td></tr>

<!--- ADD EXISTING MISC PARTS --->
<tr>
	<td>
		<table cellpadding="2" cellspacing="4" width="100%" border="0">
			<tr>
				<td valign="middle" class="textmain" colspan="2"><b>Add Existing Misc Parts:</b></td>
			</tr>
			<tr>
				<td valign="middle" class="textmain" width="40%">
					<select name="MiscPartID" size="1">
						<option value="">- Select -</option>
						<cfloop query="qryMiscParts">
							<option value="#qryMiscParts.MiscPartID#"> 
								#qryMiscParts.MfgrPartNumber# - #qryMiscParts.Description# 
							</option>
						</cfloop>
					</select>
				</td>
				<td valign="middle" class="textmain">
					<input type="submit" name="ButtonClicked" value="Add Part">
				</td>
			</tr>
		</table>	
	</td>
</tr>

<tr><td class="textsmall"><hr /></td></tr>

<!--- ADD A NEW MISC PART --->
<tr>
	<td valign="top" class="textmain">
		<table cellpadding="0" cellspacing="0" width="100%" border="0">

            <tr>
                <td valign="middle" class="textmain" colspan="3"><b>Add a New Misc Part:</b></td>
            </tr>	


            

			<!--- MfgrPartNumber --->
            <tr>
            	<td width="25%">&nbsp;</td>
                <td valign="middle" class="textmain" width="25%"><b>MFGR Part ##:</b> *</td>
                <td valign="top" class="textmain">
                    <input name="NEWMfgrPartNumber" size="35" maxlength="50" tabindex="1" value="">
                </td>
            </tr>
        
            <!--- Description --->
            <tr>
            	<td>&nbsp;</td>
                <td valign="top" class="textmain"><b>Description:</b> *</td>
                <td valign="top" class="textmain">
                    <input name="NEWDescription" size="35" maxlength="50" tabindex="2" value="">
                </td>
            </tr>
        
            <!--- ComponentCategoryID --->
            <tr>
            	<td>&nbsp;</td>
                <td valign="top" class="textmain"><b>Category:</b></td>
                <td valign="top" class="textmain">
                    <select name="NEWComponentCategoryID" tabindex="3">
                        <option value="">- None -</option>
                        <cfloop query="qryComponentCategories">
                            <option value="#qryComponentCategories.ComponentCategoryID#">
                                #qryComponentCategories.Name#
                            </option>
                        </cfloop>
                    </select>
                </td>
            </tr>
        
            <!--- Cost --->
            <tr>
            	<td>&nbsp;</td>
                <td valign="middle" class="textmain"><b>Cost:</b> *</td>
                <td valign="bottom" class="textmain">
                    $<input name="NEWCost" size="5" maxlength="50" tabindex="4" value="" >
                </td>
            </tr>
            
            <!--- Notes --->
            <tr>
            	<td>&nbsp;</td>
                <td valign="top" class="textmain"><b>Notes:</b></td>
                <td valign="top" class="textmain">
                    <textarea name="NEWNotes" wrap="virtual" cols="35" rows="3" tabindex="5" class="textmain"></textarea>
                </td>
            </tr>

<!---            	
            <tr>
                <td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF">MFGR<br>Part ##</td>			
                <td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF">Description</td>			
                <td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" align="center">Nor-Tech<br>Cost</td>			
                <td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" align="center">Notes</td>			
            </tr>
            <tr>
                <td class="textsmall" align="left" valign="top">
                    <input name="NEWMfgrPartNumber" size="12" maxlength="50" tabindex="1" class="textsmall" value="">
                </td>
                <td class="textsmall" align="left" valign="top">
                    <input name="NEWDescription" size="19" maxlength="50" tabindex="2" class="textsmall" value="">
                </td>
                <td class="textsmall" align="center" valign="top">
                    $<input name="NEWCost" size="5" maxlength="50" tabindex="3" class="textsmall" value="">
                </td>
                <td class="textsmall" align="center" valign="top">
                    <textarea name="NEWNotes" wrap="virtual" cols="60" rows="3" tabindex="4" class="textsmall"></textarea>
                </td>
            </tr>
--->
            <tr>
                <td valign="middle" class="textmain" align="right" colspan="3">
                    <input type="submit" name="ButtonClicked" value="Add New Part">
                </td>
            </tr>
            
        </table>
	</td>
</tr>            

<tr><td><hr /></td></tr>

<!--- ADD PARTS FROM CUSTOMER PRICE LIST --->
<tr>
	<td valign="top" class="textmain">
		<table cellpadding="0" cellspacing="0" width="100%" border="0">
            <tr>
                <td valign="middle" class="textmain">
<!---                
                	<a href="index.cfm?task=quotes_new4_categories&UserID=#urlEncodedFormat(Variables.UserID)#&PriceListID=#urlEncodedFormat(Variables.PriceListID)#&CopyingQuote=#URL.CopyingQuote#&CameFromScreen5=#CameFromScreen5#&QuoteSystemID=#urlEncodedFormat(URL.QuoteSystemID)#">
                        <b>Add Parts from Customer Price List</b>
                    </a>
--->                    
					<input type="submit" name="ButtonClicked" value="Add Parts from Customer Price List">
                    
                </td>
            </tr>		
		</table>
	</td>
</tr>            

<tr><td class="textsmall"><hr /></td></tr>

<!--- LIST OF PARTS ADDED TO THIS QUOTE --->
<tr>
	<td valign="top" class="textmain">
		<table cellpadding="0" cellspacing="0" width="100%" border="0">
				
			<!--- LIST HEADINGS --->
            <tr>
                <td valign="middle" class="textmain" colspan="6"><b>Misc Parts <em>and</em> Price List Parts Selected for This Quote:</b></td>
            </tr>
            <cfif isDefined("URL.Validation")>
                <tr>
                    <td valign="middle" class="textmain" colspan="6">
                    	<font color="FF0000">
                        	Enter only numeric values (greater than or equal to zero) in all selling price and quantity fields:
						</font>
                    </td>
                </tr>
			</cfif>
            <tr>
                <td width="22%" height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF">MFGR<br>Part ##</td>			
                <td width="40%" height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF">Description / Notes</td>			
                <td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" align="center">Nor-Tech<br>Cost</td>			
                <td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" align="center">Selling<br>Price</td>			
                <td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" align="center">Qty</td>			
                <td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF">&nbsp;</td>			
            </tr>
        
            <!--- LIST DATA --->	
            <cfif qrySelectedParts.RecordCount EQ 0>
                <tr>
                    <td align="center" colspan="6" class="productTitle">
                        <font color="FF0000">This quote has no misc parts attached to it.</font>
                    </td>
                </tr>
            </cfif>
            
            <cfloop query="qrySelectedParts">
                
                <cfif trim(qrySelectedParts.PriceListComponentID) IS NOT "">
                    <cfset PartType = "Price List Part">
                    <cfset strPriceListComponent = objPriceListComponents.getRecord(qrySelectedParts.PriceListComponentID)>
                <cfelseif trim(qrySelectedParts.MiscPartID) IS NOT "">
                    <cfset PartType = "Misc Part">
                    <cfset strMiscPart = objMiscParts.getRecord(qrySelectedParts.MiscPartID)>
				<cfelse>
                    <cfset PartType = "ACCPAC Misc Part">
                </cfif>

				<cfif PartType IS "Misc Part">
                    <cfset PriceFieldName = "COST|" & qrySelectedParts.MiscPartID>
                <cfelseif PartType IS "Price List Part">
                    <cfset PriceFieldName = "COST|" & qrySelectedParts.PriceListComponentID>
				<cfelse>
                    <cfset PriceFieldName = "COST|" & qrySelectedParts.ACCPACPartID>                
                </cfif>	
                
				<cfif PartType IS "Misc Part">
                    <cfset QuantityFieldName = "QTY|" & qrySelectedParts.MiscPartID>
                <cfelseif PartType IS "Price List Part">
                    <cfset QuantityFieldName = "QTY|" & qrySelectedParts.PriceListComponentID>
				<cfelse>
                    <cfset QuantityFieldName = "QTY|" & qrySelectedParts.ACCPACPartID>
                </cfif>	
                
                <!--- Get Nor-Tech Cost --->
				<cfif PartType IS "Misc Part">
                    <cfset CurrentCost = strMiscPart.Cost>
                <cfelseif PartType IS "Price List Part">
                    <cfset CurrentCost = objPriceListComponents.getItemCost(strPriceListComponent.ITEMNO)>
                <cfelse>
                    <cfset CurrentCost = objPriceListComponents.getItemCost(qrySelectedParts.ITEMNO)>
                </cfif>                  
                
                <!--- Get Selling Price --->
				<cfif CameFromScreen5 AND structKeyExists(strQuoteScreen4, PriceFieldName)>
                	<cfset CurrentSellingPrice = strQuoteScreen4[PriceFieldName]>
                <cfelse>
                
<!---                    
                <cfelseif PartType IS "Price List Part">
                    <cfset CurrentSellingPrice = strPriceListComponent.SellPrice>
                <cfelse>
--->                
                    <cfif qrySelectedParts.SellingPrice IS NOT "" AND isNumeric(qrySelectedParts.SellingPrice)>
                        <cfset CurrentSellingPrice = qrySelectedParts.SellingPrice>
					<cfelseif PartType IS "Price List Part">
                        <cfset CurrentSellingPrice = strPriceListComponent.SellPrice>
                        
                    <cfelse>
                    	<cfset CurrentSellingPrice = CurrentCost>
<!---
                    	<cfif PartType IS "Misc Part">
							<cfset CurrentSellingPrice = strMiscPart.Cost>
                        <cfelse>
							<cfset CurrentSellingPrice = qrySelectedParts.Cost>                        
                        </cfif>
--->                        
                        <cfif structKeyExists(strPriceList, "MarkupPercent") AND isNumeric(strPriceList.MarkupPercent)>
                            <cfset CurrentSellingPrice = CurrentCost + (CurrentCost * strPriceList.MarkupPercent / 100)>
                        </cfif>
                    </cfif>          
                </cfif>
    
                <!--- Get Quantity --->
				<cfif CameFromScreen5 AND structKeyExists(strQuoteScreen4, QuantityFieldName)>
                	<cfset CurrentQuantity = strQuoteScreen4[QuantityFieldName]>
                <cfelseif qrySelectedParts.Quantity IS NOT "" AND isNumeric(qrySelectedParts.Quantity)>
                    <cfset CurrentQuantity = qrySelectedParts.Quantity>
                <cfelse>
                    <cfset CurrentQuantity = 1>
                </cfif>          
    
                <tr<cfif qrySelectedParts.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
    
					<!--- PART NUMBER --->
                    <td class="textsmall" align="left" valign="middle">
                        <cfif PartType IS "Misc Part">
                            #strMiscPart.MfgrPartNumber#
        		        <cfelseif PartType IS "Price List Part">
                            #strPriceListComponent.ITEMNO#
						<cfelse>
                        	#qrySelectedParts.ITEMNO#
                        </cfif>                  
                    </td>
                    
					<!--- DESCRIPTION --->
                    <td class="textsmall" align="left" valign="middle">
                        <cfif PartType IS "Misc Part">
                            <cfset PartDescription = strMiscPart.Description>
        		        <cfelseif PartType IS "Price List Part">
                            <cfset PartDescription = objPriceListComponents.getItemDescription(strPriceListComponent.ITEMNO)>
						<cfelse>
                            <cfset PartDescription = objPriceListComponents.getItemDescription(qrySelectedParts.ITEMNO)>
                        </cfif>                  
<!---                    
                        <cfif len(trim(PartDescription)) GT 35>
                            #left(trim(PartDescription), 35)#...
                        <cfelse>
--->                        
                            #trim(PartDescription)#
<!---                   </cfif>	--->
                    </td>
                    
					<!--- NOR-TECH COST --->
                    <td class="textsmall" align="center" valign="middle">
                        #dollarFormat(CurrentCost)#
<!---
                        <cfif PartType IS "Misc Part">
                            #dollarFormat(strMiscPart.Cost)#
        		        <cfelseif PartType IS "Price List Part">
                            #dollarFormat(objPriceListComponents.getItemCost(strPriceListComponent.ITEMNO))#
						<cfelse>
                            #dollarFormat(objPriceListComponents.getItemCost(qrySelectedParts.ITEMNO))#
                        </cfif>                  
--->
                    </td>
    
    				<!--- SELLING PRICE --->
                    <td class="textsmall" align="center" valign="middle">
                        $<input name="#PriceFieldName#" size="5" maxlength="50" value="#numberFormat(CurrentSellingPrice, '.99')#" class="textsmall">
                    </td>
    
    				<!--- QUANTITY --->
                    <td class="textsmall" align="center" valign="middle">
                        <input name="#QuantityFieldName#" size="1" maxlength="50" value="#CurrentQuantity#" class="textsmall">
                    </td>

					<!--- "REMOVE" LINK --->                    
                    <td class="textsmall" align="left" valign="middle">
                        <a href="index.cfm?task=quotes_new4_removepart&MiscPartID=#urlEncodedFormat(qrySelectedParts.MiscPartID)#&PriceListComponentID=#urlEncodedFormat(qrySelectedParts.PriceListComponentID)#&ACCPACPartID=#urlEncodedFormat(qrySelectedParts.ACCPACPartID)#&UserID=#urlEncodedFormat(Variables.UserID)#&PriceListID=#urlEncodedFormat(Variables.PriceListID)#&CopyingQuote=#URL.CopyingQuote#&CameFromScreen5=#CameFromScreen5#&QuoteSystemID=#urlEncodedFormat(URL.QuoteSystemID)#">
                            <b>[remove]</b>
                        </a>
                    </td>

                </tr>
				<cfif PartType IS "Misc Part" AND trim(strMiscPart.Notes) IS NOT "">
                    <tr<cfif qrySelectedParts.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
	                    <td>&nbsp;</td>                        
                        <td class="textsmall" align="left" valign="top" colspan="5">
                            #strMiscPart.Notes#
                        </td>
                    </tr>
                </cfif>
                    
            </cfloop>
            <tr><td>&nbsp;</td></tr>

<!---            
            <!--- Parts that couldn't be added to this quote from the invoice --->
			<cfif isDefined("strQuoteScreen4.qryUnSelectedParts")>
                <tr>
                    <td colspan="6">
               			<table cellpadding="0" cellspacing="0" width="100%" border="0">
							<!--- LIST HEADINGS --->
                            <tr>
                                <td valign="middle" class="textmain" colspan="2">
                             		<font color="FF0000">
										<b>NOTE: The following parts could not be added to this quote because they were not found on this customer's price list:</b>
                                    </font>
                              	</td>
                            </tr>
                            <tr>
                                <td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF">Item</td>			
                                <td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF">Description</td>			
                            </tr>
           					<cfloop query="strQuoteScreen4.qryUnSelectedParts">
                                <tr<cfif strQuoteScreen4.qryUnSelectedParts.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
                                    <td class="textsmall" align="left" valign="middle">
                                    	#strQuoteScreen4.qryUnSelectedParts.ITEM#
                                    </td>
                                    <td class="textsmall" align="left" valign="middle">
                                    	#objQuoteSystem.getItemDescription(strQuoteScreen4.qryUnSelectedParts.ITEM)#
                                    </td>
								</tr>                                    
                            </cfloop>                        
						</table>
                    </td>
                </tr>
            </cfif>
--->            
    
            <!--- "CONTINUE" BUTTON --->
            <tr>
                <td colspan="6" valign="middle" align="right" class="textsmall">
                    <input type="submit" name="ButtonClicked" value="Continue">
                </td>
            </tr>		
            
            <tr><td>&nbsp;</td></tr>
    
	
		</table>
	</td>
</tr>
</form>
</table>
</cfoutput>