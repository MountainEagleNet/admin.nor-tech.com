<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/28/2008
	Function: 		
	Template:		frmQuote3.cfm
	Task:			quotes_new3
	
	Edits:
		6/13/2012: 
--->

<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>
<cfset objConfigComponentCategories = createObject("component", "admin.assets.cfcs.config.ConfigComponentCategories")>
<cfset objConfigComponents = createObject("component", "admin.assets.cfcs.config.ConfigComponents")>

<cfset objLogin = createObject("component", "admin.assets.cfcs.Cust")>
<cfset objQuoteSystem = createObject("component", "admin.assets.cfcs.config.QuoteSystem")>
<cfset objQuoteComponents = createObject("component", "admin.assets.cfcs.config.QuoteComponents")>

<cfset objPriceListComponents = createObject("component", "admin.assets.cfcs.prices.PriceListComponents")>

<cfset CopyingQuote = 0>
<cfset QuoteSystemID = "">
<cfif isDefined("URL.CopyingQuote")>
	<cfset strQuoteScreen3 = structNew()>
    <cfset strQuoteScreen4 = structNew()>
    <cfset objLogin.setSessionValue("QuoteScreen3", strQuoteScreen3)>
    <cfset objLogin.setSessionValue("QuoteScreen4", strQuoteScreen4)>
	<cfset strQuoteSystem = objQuoteSystem.getRecord(URL.QuoteSystemID)>
    <cfset URL.ConfigSystemID = strQuoteSystem.ConfigSystemID>
    <cfset URL.CustomerID = strQuoteSystem.CustomerID>
	<cfset URL.UserID = objQuoteSystem.getSessionValue("adminuserid")>
    <cfset CopyingQuote = 1>
	<cfset QuoteSystemID = URL.QuoteSystemID>
</cfif>

<!--- If "Edit Quote" was clicked on screen 5 --->
<cfif isDefined("URL.CameFromScreen5")>
	<cfset CameFromScreen5 = URL.CameFromScreen5>
<cfelse>
	<cfset CameFromScreen5 = 0>
</cfif>
<cfif CameFromScreen5>
	<cfset strQuoteScreen3 = objConfigSystems.getSessionValue("QuoteScreen3")>
	<cfset URL.UserID = strQuoteScreen3.UserID>
    <cfset URL.CustomerID = strQuoteScreen3.CustomerID>
    <cfset URL.ConfigSystemID = strQuoteScreen3.ConfigSystemID>
</cfif>


<!--- Get the PriceListID for this Customer --->
<cfset SearchRecord = structNew()>
<cfset structInsert(SearchRecord, "CustomerID", URL.CustomerID, True)>
<cfset qryLogin = objLogin.searchRecords(SearchRecord)>
<cfset Variables.PriceListID = qrylogin.PriceListID>
<!--- If this customer doesn't have a price list, use the Master price list --->
<cfif Variables.PriceListID IS "">
	<cfset Variables.PriceListID = "MASTERPRICELISTUUID">
</cfif>

<!--- skip this page if there's not a configuration associated with this quote --->
<cfif URL.ConfigSystemID IS "">
	<cfset strQuoteScreen3 = structNew()>
    <cfset structInsert(strQuoteScreen3, "ConfigSystemID", "", True)>
    <cfset structInsert(strQuoteScreen3, "CustomerID", URL.CustomerID, True)>
    <cfset structInsert(strQuoteScreen3, "PriceListID", Variables.PriceListID, True)>
    <cfset structInsert(strQuoteScreen3, "QuoteSystemID", QuoteSystemID, True)>
    <cfset structInsert(strQuoteScreen3, "UserID", URL.UserID, True)>
    <cfset structInsert(strQuoteScreen3, "SystemBasePrice", 0, True)>
	<cfset objConfigSystems.setSessionValue("QuoteScreen3", strQuoteScreen3)>
	<cflocation url="index.cfm?task=quotes_new4&UserID=#urlEncodedFormat(URL.UserID)#&CustomerID=#urlEncodedFormat(URL.CustomerID)#&ConfigSystemID=#urlEncodedFormat(URL.ConfigSystemID)#&PriceListID=#urlEncodedFormat(Variables.PriceListID)#&CopyingQuote=#CopyingQuote#&CameFromScreen5=#CameFromScreen5#&QuoteSystemID=#urlEncodedFormat(QuoteSystemID)#">
</cfif>

<!--- Get a structure of the system --->
<cfset strConfigSystem = objConfigSystems.getRecord_Config(URL.ConfigSystemID)>

<cfset PowerSupplyAutoSelect = objConfigSystems.isPowerSupplyAutoSelect(URL.ConfigSystemID)>

<!--- If updating (copying) a quote, and the configuration on that quote no longer exists, go to an error page --->
<cfif CopyingQuote AND structIsEmpty(strConfigSystem)>
	<cflocation url="index.cfm?task=quotes_error&QuoteSystemID=#urlEncodedFormat(QuoteSystemID)#">
</cfif>

<!--- Get a query of the component categories --->
<cfset qryConfigComponentCategories = objConfigComponentCategories.getCategories_Config(URL.ConfigSystemID, 0)>	<!--- 0=IncludeAdditionalWarranty --->


<!--- Get the Name of the Primary Image --->
<cfif CameFromScreen5>
	<cfset ImageName = objConfigSystems.getImageName2(strQuoteScreen3)>
<cfelseif CopyingQuote>
	<cfset ImageName = objConfigSystems.getImageName3(QuoteSystemID)>
<cfelse>
	<cfset ImageName = objConfigSystems.getImageName(URL.ConfigSystemID)>
</cfif>



<!--- ================================= --->
<!--- SHOW POWER SUPPLY WHEN PAGE LOADS --->
<!--- ================================= --->
<cfset ShowPowerSupplyWhenPageLoads = objConfigSystems.getShowPowerSupplyWhenPageLoads(PowerSupplyAutoSelect, URL.ConfigSystemID)>
<cfif isDefined("strQuoteScreen3") AND structKeyExists(strQuoteScreen3, "PowerSupplyDeleted") AND strQuoteScreen3.PowerSupplyDeleted EQ 1>
	<cfset ShowPowerSupplyWhenPageLoads = 0>
    <cfset PowerSupplyDeleted = 1>
<cfelse>
    <cfset PowerSupplyDeleted = 0>
</cfif>
<!--- If we're looping back from Screen 5 (Edit Quote) and the Case that was selected is CS-LO-BK202-80PLUS-VOY, 
	  don't display the power supply row initially, because the power supply is integrated in the case --->
<cfif CameFromScreen5>
	<cfset lstQuoteScreen3 = structKeyList(strQuoteScreen3)>
	<cfloop list="#lstQuoteScreen3#" index="Column">
    	<cfif findNoCase("CAT_", Column) NEQ 0>
        	<cfset CatFieldValue = strQuoteScreen3[Column]>

<!--- 07/12/2011 --->
<!---            
            <cfif findNoCase("CS-LO-BK202-80PLUS-VOY", CatFieldValue) NEQ 0 OR
				  findNoCase("CS-CE-FX629MBKH", CatFieldValue) NEQ 0 OR
				  findNoCase("CS-CE-TLA397/NP", CatFieldValue) NEQ 0>
--->
            <cfif findNoCase("CS-LO-BK202-80PLUS-VOY", CatFieldValue) NEQ 0>
                  
				<cfset ShowPowerSupplyWhenPageLoads = 0>
                <cfbreak>
            </cfif>
        </cfif>
    </cfloop>
</cfif>

<!--- If Updating (Copying) the quote, and the case on the quote you're copying is CS-LO-BK202-80PLUS-VOY, don't display power supply --->
<cfif CopyingQuote AND objQuoteComponents.isSelectedComponent(QuoteSystemID, "CS-LO-BK202-80PLUS-VOY", "Case")>
	<cfset ShowPowerSupplyWhenPageLoads = 0>
</cfif>

<!---
ShowPowerSupplyWhenPageLoads:<cfdump var="#ShowPowerSupplyWhenPageLoads#">
--->
<script language="javascript">
function openWindow(url_string, width, height)	{
	var options = "status=1,scrollbars=1,resizable=1,height="+height+",width="+width;
	new_window = window.open(url_string, "newwin", options );
	return false;
}	
</script>

<script language="JavaScript1.2">
<cfif ShowPowerSupplyWhenPageLoads>
	window.onload = showpowersupplyrow;
</cfif>

function trimstring(str){
 if (str.trim)
  return str.trim()
 else
  return str.replace(/(^\s*)|(\s*$)/g, "") //find and remove spaces from left and right hand side of string
}

function showpowersupplyrow() {
	document.getElementById("powersupplyrow").style.visibility = "visible";
}

function totalprice(IsCase, SelectBoxName) { 
	var totalval = parseFloat(document.detailform.SystemBasePrice.value);
	var totalvaldec = totalval.toFixed(2);
	var PhotoImageName = "";

	<cfif PowerSupplyAutoSelect AND NOT PowerSupplyDeleted>
		var JSPowerSupplyAutoSelect = "yes";
	<cfelse>
		var JSPowerSupplyAutoSelect = "no";
	</cfif>

	if(IsCase == "Case" && JSPowerSupplyAutoSelect == "yes") {
		var ItemNumber = trimstring(document.detailform.elements[SelectBoxName].value.split('|')[3]);

/* 07/12/2011 */
//		if (ItemNumber == "CS-EV-E4252-BLACK-NPS" || ItemNumber == "CS-LO-ST951B-VOY/NP") {
	
/* RAB 04/30/2012 */
//		if (ItemNumber == "CS-EV-E4252-BLACK-NPS" || ItemNumber == "CS-LO-ST951B-VOY/NP" || ItemNumber == "CS-CE-TLA397/NP" || ItemNumber == "CS-CE-FX629MBKH") {			
		if (ItemNumber == "CS-EV-4572B-S2" || ItemNumber == "CS-LO-ST951B-VOY/NP" || ItemNumber == "CS-CE-TLA397/NP" || ItemNumber == "CS-CE-FX629MBKH") {			
		
			document.getElementById("powersupplyrow").style.visibility = "visible";
		}
		else {
			document.getElementById("powersupplyrow").style.visibility = "hidden";
		}
	}


	if(IsCase == "Case") {
		var PhotoImageName = document.detailform.elements[SelectBoxName].value.split('|')[2];
	}

	<cfloop query="qryConfigComponentCategories">
		<cfif qryConfigComponentCategories.CategoryName IS NOT "EnergyStar">
			var CurrentSelectBoxName = "CAT_" + "<cfoutput>#qryConfigComponentCategories.ConfigComponentCategoryID#</cfoutput>";
			var CurrentAmount = document.detailform.elements[CurrentSelectBoxName].value.split('|')[1];
			var CurrentAmountDec = eval(CurrentAmount).toFixed(2);
			var CurrentQuantityBox = "QTY|" + "<cfoutput>#qryConfigComponentCategories.ConfigComponentCategoryID#</cfoutput>";
			var CurrentQuantityAmount = document.detailform.elements[CurrentQuantityBox].value;
			var CurrentQuantityAmountDec = eval(CurrentQuantityAmount).toFixed(2);
			
			totalvaldec = eval(totalvaldec) + (eval(CurrentAmountDec) * eval(CurrentQuantityAmountDec)); 
	//		totalvaldec = eval(totalvaldec) + eval(CurrentAmountDec);
		</cfif>
	</cfloop>

	totalvaldec = totalvaldec.toFixed(2);

	if(document.all) {
		document.all["total"].innerHTML = totalvaldec;
	}
	else {
		document.getElementById("total").childNodes[0].nodeValue=totalvaldec;
	}
	
	if(IsCase == "Case") {
		if(document.images) 
		{ 
			if (PhotoImageName == ""){
				document.iljswitch.src = "https://partners.nor-tech.com/images/systems/" + "<cfoutput>#ImageName#</cfoutput>"; 
			}
			else
			{
				document.iljswitch.src = "https://partners.nor-tech.com/images/systems/" + PhotoImageName; 
			}
		} 
	}
	
}
</script>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objConfigSystems.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr><!--- Page Title --->
	<td valign="top" class="pagetitle">
		<cfif NOT isDefined("strConfigSystem.Type")>
			Nor-Tech Configurator
		<cfelseif strConfigSystem.Type IS "Workstation">
			Workstation Configurator
		<cfelseif strConfigSystem.Type IS "Notebook">
			Notebook Configurator
		<cfelseif strConfigSystem.Type IS "Server">
			Server Configurator
		</cfif>
	</td>
</tr>

<!---
URL.ConfigSystemID:<cfdump var="#URL.ConfigSystemID#"><br />
Variables.PriceListID:<cfdump var="#Variables.PriceListID#"><br />
--->

<!---
<cfif NOT CopyingQuote>
	<cfset SystemTotal = ceiling(objConfigSystems.getSystemTotalPriceDefault(URL.ConfigSystemID, Variables.PriceListID))>		<!---102908--->
<cfelse>
<!---<cfset SystemTotal = strQuoteSystem.ResellerPrice>	--->
	<cfset SystemTotal = ceiling(objConfigSystems.getSystemTotalPriceDefaultCopy(URL.ConfigSystemID, Variables.PriceListID, URL.QuoteSystemID))>		<!---102908--->
<!---<cfset SystemTotal = ceiling(objConfigSystems.getSystemTotalPriceFromQuote(URL.ConfigSystemID, URL.QuoteSystemID))>	--->	<!---102908--->
</cfif>
<!---SystemTotal:<cfdump var="#SystemTotal#"><br />--->
--->


<cfif CameFromScreen5>
	<cfset SystemTotal = objConfigSystems.getSystemTotalPriceEdit(strQuoteScreen3)>		
<cfelseif CopyingQuote>
	<cfset SystemTotal = objConfigSystems.getSystemTotalPriceDefaultCopy(URL.ConfigSystemID, Variables.PriceListID, URL.QuoteSystemID)>		
<cfelse>
	<cfset SystemTotal = objConfigSystems.getSystemPrice(URL.ConfigSystemID, strConfigSystem.SystemBasePrice, Variables.PriceListID)>

	<!--- (The old way) --->
    <cfif SystemTotal EQ 0>
		<cfset SystemTotal = ceiling(objConfigSystems.getSystemTotalPriceDefault(URL.ConfigSystemID, Variables.PriceListID))>		<!---102908--->
	</cfif>	

</cfif>

<tr>
	<td valign="top">
	<table width="100%" border="0" align="center" cellpadding="3" cellspacing="6">
		<tr>
			<!--- SYSTEM PHOTO --->

            <!--- If the default case has an image associated with it, use that image. Otherwise, use the system image --->

			<td align="center" valign="middle" width="50%" height="200px" class="listSystemDescription">
				<img name="iljswitch" src="http://partners.nor-tech.com/images/systems/#ImageName#">
                <br />
                <a href="javascript:void(0)" 
                    onclick="openWindow('quotes/popupPhoto.cfm?ConfigSystemID=#urlEncodedFormat(URL.ConfigSystemID)#',450,650)">					
                    <strong><em>(Click Here for specs)</em></strong>
                </a>                                            
			</td>
			<!--- SYSTEM NAME, TOTAL PRICE --->
			<td valign="middle">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td align="center" height="25px" class="systemName">
							#strConfigSystem.Name#
						</td>
					</tr>
					<tr>
						<td align="center" class="systemPrice">
							Total Price:
						</td>
					</tr>
					<tr>
						<td align="center">
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td align="right" class="systemPriceLarge" width="40%">$</td>
								<td align="left" class="systemPriceLarge" id="total">
									#numberFormat(SystemTotal, '.99')#
								</td>
							</tr>
						</table>						
						</td>
					</tr>
					
					<cfif isDefined("qrylogin.ShippingAndTax") AND qrylogin.ShippingAndTax EQ 1>
						<tr>
							<td align="center" class="textBlueSmall">
								(shipping and tax not included)
							</td>
						</tr>
					</cfif>
					
				</table>
			</td>
		</tr>
	</table>
	</td>
</tr>

<tr>
	<td valign="top" class="textmain">
		#strConfigSystem.Description#
	</td>
</tr>

<!--- Determine if there are any categories on the quote that are no longer available in the configurator --->
<!---
<cfif CopyingQuote>
	<cfset qryCategoriesMissing = queryNew("Category")>
	<cfset SearchRecord = structNew()>
    <cfset structInsert(SearchRecord, "QuoteSystemID", URL.QuoteSystemID, True)>
    <cfset qryQuoteComponents = objQuoteComponents.searchRecords(SearchRecord, "query", "TypeName", 1)>
	<cfset TypeNameSaved = "">
	<cfloop query="qryQuoteComponents">
    	<cfif TypeNameSaved IS NOT qryQuoteComponents.TypeName>
	    	<cfset TypeNameSaved = qryQuoteComponents.TypeName>
			<cfset SearchRecord = structNew()>
            <cfset structInsert(SearchRecord, "ConfigSystemID", URL.ConfigSystemID, True)>
            <cfset structInsert(SearchRecord, "CategoryName", TypeNameSaved, True)>
            <cfset qryConfigComponents = objConfigComponents.searchRecords(SearchRecord)>
            <cfif qryConfigComponents.RecordCount EQ 0>
				<cfset queryAddRow(qryCategoriesMissing)>
                <cfset querySetCell(qryCategoriesMissing, "Category", TypeNameSaved)>
			</cfif>
		</cfif>
    </cfloop>
	<cfif qryCategoriesMissing.RecordCount NEQ 0>
        <tr>
            <td valign="top" class="textsmall" style="color:FF0000; font-style:italic">
                <strong>NOTE</strong>: 
                One or more categories were included on the quote you are copying, but are no longer listed as categories on this configuration, so they have not been included below.
                The missing <cfif qryCategoriesMissing.RecordCount EQ 1>category is<cfelse>categories are as follows:</cfif> 
                <cfloop query="qryCategoriesMissing">
					<cfif qryCategoriesMissing.CurrentRow IS NOT 1>, </cfif>
                	#qryCategoriesMissing.Category#
                </cfloop>
            </td>
    	</tr>
	</cfif>
</cfif>
--->
<!---
<tr>
<td>
qryConfigComponentCategories:<cfdump var="#qryConfigComponentCategories#"><br />
</td>
</tr>
--->

<tr>
	<td valign="top" class="textmain">
	<table width="100%" border="0" align="center" cellpadding="5" cellspacing="1">
	<form action="index.cfm?task=quotes_new3_act&RequestTimeout=6000" method="Post" name="detailform">
	<input type="hidden" name="UserID" value="#URL.UserID#">
	<input type="hidden" name="CustomerID" value="#URL.CustomerID#">
	<input type="hidden" name="ConfigSystemID" value="#URL.ConfigSystemID#">
	<input type="hidden" name="PriceListID" value="#Variables.PriceListID#">
	<input type="hidden" name="SystemBasePrice" value="#strConfigSystem.SystemBasePrice#">
	<input type="hidden" name="CopyingQuote" value="#CopyingQuote#">
	<input type="hidden" name="QuoteSystemID" value="#QuoteSystemID#">
	<input type="hidden" name="CameFromScreen5" value="#CameFromScreen5#">
	<input type="hidden" name="PowerSupplyDeleted" value="#PowerSupplyDeleted#">

    	<tr>
			<td valign="bottom" class="systemCategory" style="color:000099"><b>Ignore<br>Category?</b></td>		
			<td valign="bottom" align="right" class="systemCategory" style="color:000099">Category</td>
			<td valign="bottom" align="center" class="systemCategory" style="color:000099">Quantity</td>
			<td valign="bottom" align="left" class="systemCategory" style="color:000099">Component</td>
        </tr>
		<tr><td colspan="4"><hr /></td></tr>

		<cfset TabValue = 1>
		<cfset PowerSupply_ConfigComponentCategoryID = "">            	


		<cfloop query="qryConfigComponentCategories">
        	<cfset CURRENTConfigComponentCategoryID = qryConfigComponentCategories.ConfigComponentCategoryID>
            <cfset CURRENTCategoryName = qryConfigComponentCategories.CategoryName>
        	<cfset CURRENTCATEGORY = trim(qryConfigComponentCategories.CATEGORY)>

			<cfif CURRENTCategoryName IS "Power Supply">
				<cfset PowerSupply_ConfigComponentCategoryID = CURRENTConfigComponentCategoryID>            	
            </cfif>
            
			<cfif NOT PowerSupplyAutoSelect OR CURRENTCategoryName IS NOT "Power Supply">
                <tr>
                
                
                
                    <!--- "IGNORE" CHECKBOX --->
                    <cfset CheckTheBox = 0>
                    <cfif CopyingQuote AND objQuoteComponents.ignoreComponent(URL.QuoteSystemID,CURRENTCategoryName)>
                        <cfset CheckTheBox = 1>
                    </cfif>
                    <cfif CameFromScreen5 AND structKeyExists(strQuoteScreen3, "IGNORE|#qryConfigComponentCategories.ConfigComponentCategoryID#")>
                        <cfset CheckTheBox = 1>
                    </cfif>
                    
                    <td width="5%" valign="top">
<!---                    
                        <cfif CURRENTCategoryName IS NOT "EnergyStar" <!---AND CURRENTCategoryName IS NOT "Power Supply"--->>
--->                        
                            <input type="checkbox" name="IGNORE|#qryConfigComponentCategories.ConfigComponentCategoryID#" value="1" 
                                <cfif CheckTheBox>
                                     checked="checked"
                                </cfif>
                             >		
<!---                             		
                        </cfif>
--->                        
                    </td>
                    
                    
                    
                
                    <!--- CATEGORY LABEL --->
                    <td valign="top" align="right" width="25%" class="systemCategory">
<!---                   <cfif CURRENTCategoryName IS NOT "Power Supply">	--->
                            #CURRENTCategoryName#
<!---                   </cfif>		--->
                    </td>
    
                    <!--- QUANTITY SELECT BOX --->
                    <td valign="middle" align="center" class="textsmall">
                    
<!---                    
                         <cfif CURRENTCategoryName IS NOT "EnergyStar" <!---AND CURRENTCategoryName IS NOT "Power Supply"--->>
--->
                    	<cfif CURRENTCategoryName IS "EnergyStar">
							1
                       	<cfelse>
                            <cfset SelectBoxName = "QTY|" & qryConfigComponentCategories.ConfigComponentCategoryID>
                            
                            <cfif qryConfigComponentCategories.MaximumQuantity EQ 1>
                                <input type="hidden" name="#SelectBoxName#" value="1" />
                                1
                            <cfelse>
                                <select name="#SelectBoxName#" size="1" tabindex="#TabValue#" class="textsmall" onChange="totalprice('NotCase','')">
                                    <cfloop from="1" to="#qryConfigComponentCategories.MaximumQuantity#" step="1" index="QuantityAmount">
                                        <option value="#QuantityAmount#" 
                                            <cfif CopyingQuote AND objQuoteComponents.isQuantity(URL.QuoteSystemID,CURRENTCategoryName,QuantityAmount)>
                                                selected="selected"
                                            <cfelseif CameFromScreen5 AND structKeyExists(strQuoteScreen3, "QTY|#qryConfigComponentCategories.ConfigComponentCategoryID#") AND 
                                                  strQuoteScreen3["QTY|#qryConfigComponentCategories.ConfigComponentCategoryID#"] IS QuantityAmount>
                                                selected="selected"
                                            <cfelseif NOT CopyingQuote AND NOT CameFromScreen5 AND qryConfigComponentCategories.DefaultQuantity IS QuantityAmount>
                                                selected="selected"
                                            </cfif>                                    
                                        >#QuantityAmount#</option>
                                    </cfloop>
                                </select>
                            </cfif>
                        </cfif>
                    </td>
    
                    <!--- COMPONENT SELECT BOX --->
                    <td valign="top" align="left" class="textsmall">
    <!---                
    CURRENTCategoryName:<cfdump var="#CURRENTCategoryName#"><br />
    --->
                        <!--- This is EnergyStar (Entrgy Star); don't display the select box --->
                        <cfif CURRENTCategoryName IS "EnergyStar">
                            ENERGY STAR COMPLIANT SYSTEM 
                            
<!---                            
                        <cfelseif CURRENTCategoryName IS "Power Supply">
                            &nbsp;
--->

    <!---                        
                            POWER SUPPLY
    --->                        
    <!---                        
                        <cfelseif CURRENTCategoryName IS "Power Supply" AND NOT isDefined("URL.PickPowerSupply")>
                            INCLUDED WITH CASE
                            <input type="hidden" name="#SelectBoxName#" value="#qryConfigComponents.ConfigComponentID#|#qryConfigComponents.Price#|#qryConfigComponents.PhotoImage#">
    --->                        
                        <cfelse>
                        
                            <cfset SelectBoxName = "CAT_" & qryConfigComponentCategories.ConfigComponentCategoryID>
        <!---    
                            <cfset qryConfigComponents = objConfigComponents.fillComponentOptions_Config(qryConfigComponentCategories.ConfigComponentCategoryID, Variables.PriceListID)>
        --->
                            <cfset qryConfigComponents = objConfigComponents.fillComponentOptions_Config_NEW(qryConfigComponentCategories.ConfigComponentCategoryID, Variables.PriceListID)>
                            
<!---                            
qryConfigComponents:<cfdump var="#qryConfigComponents#"><br />
--->
                            <cfset SelectDefaultComponent = 1>
                            <cfif CameFromScreen5>
                                <cfset SelectDefaultComponent = 0>
                            <cfelseif CopyingQuote>
                                <cfloop query="qryConfigComponents">
                                    <cfset SearchRecord = structNew()>
                                    <cfset structInsert(SearchRecord, "QuoteSystemID", URL.QuoteSystemID, True)>
                                    <cfset structInsert(SearchRecord, "ITEMNO", qryConfigComponents.ITEMNO, True)>
                                    <cfset qryQuoteComponents = objQuoteComponents.searchRecords(SearchRecord)>
                                    <cfif qryQuoteComponents.RecordCount NEQ 0>
                                        <cfset SelectDefaultComponent = 0>
                                        <cfbreak>
                                    </cfif>
                                </cfloop>
                            </cfif>
        
                            <cfset PartNotUsed = "">
                            <cfif CopyingQuote AND SelectDefaultComponent>
                                <cfset SearchRecord = structNew()>
                                <cfset structInsert(SearchRecord, "QuoteSystemID", URL.QuoteSystemID, True)>
                                <cfset structInsert(SearchRecord, "TypeName", CURRENTCategoryName, True)>
                                <cfset qryQuoteComponentNOT_USED = objQuoteComponents.searchRecords(SearchRecord)>
                                <cfif qryQuoteComponentNOT_USED.RecordCount NEQ 0>
                                    <cfset PartNotUsed = qryQuoteComponentNOT_USED.ITEMNO & " (" & qryQuoteComponentNOT_USED.ITEMDESC & ")">
                                </cfif>
                            </cfif>
        
                            <!--- Only 1 option OR this is EnergyStar (Entrgy Star); don't display the select box --->
                            <cfif qryConfigComponents.RecordCount EQ 1 OR CURRENTCategoryName IS "EnergyStar" <!---OR 
                                 (CURRENTCategoryName IS "Power Supply" AND NOT isDefined("URL.PickPowerSupply"))--->>

								<!--- 6/13/2012 RAB: The description that's appearing is not the current one in ACCPAC.  Fix this --->
<!---                          	#qryConfigComponents.DESCRIPTION#	--->
								#objConfigComponents.getItemDescription(qryConfigComponents.ITEMNO)#


                                <input type="hidden" name="#SelectBoxName#" value="#qryConfigComponents.ConfigComponentID#|#qryConfigComponents.Price#|#qryConfigComponents.PhotoImage#|#qryConfigComponents.ITEMNO#">
        
        <!---                        
                                <cfset PriceOfThisComponent = 0>
                                <cfif isNumeric(qryConfigComponents.SellPrice)>
                                    <cfset PriceOfThisComponent = round(qryConfigComponents.SellPrice)>
                                <cfelse>		<!---102908--->
                                    <cfset PriceOfThisComponent = round(objPriceListComponents.getSellingPrice(Variables.PriceListID, qryConfigComponents.ITEMNO))>
                                </cfif>
                                <cfif trim(qryConfigComponents.DESCRIPTION) IS NOT "">
                                    #qryConfigComponents.DESCRIPTION#
                                <cfelse>
                                    #objConfigComponents.getItemDescription(qryConfigComponents.ITEMNO)#						
                                </cfif>						
                                <input type="hidden" name="#SelectBoxName#" value="#qryConfigComponents.ConfigComponentID#_#PriceOfThisComponent#">
                                <cfset PartReplacedWith = qryConfigComponents.ITEMNO & " (" & qryConfigComponents.DESCRIPTION & ")">
        --->
        
                            <!--- Option select box --->
                            <cfelse>
                                <!--- Get price of the default component --->
        <!---                           <cfset PriceOfDefaultComponent = objConfigComponents.getPriceOfDefaultComponent(qryConfigComponentCategories.ConfigComponentCategoryID, Variables.PriceListID)>--->
                                <cfif CURRENTCATEGORY IS "CS">
                                    <select name="#SelectBoxName#" size="1" tabindex="#TabValue#" class="textsmall" onChange="totalprice('Case','#SelectBoxName#')">
                                <cfelse>
                                    <select name="#SelectBoxName#" size="1" tabindex="#TabValue#" class="textsmall" onChange="totalprice('NotCase','')">
                                </cfif>
                                    <cfset PartReplacedWith = "">
                                    <cfloop query="qryConfigComponents">
                                        <cfset CURRENTConfigComponentID = qryConfigComponents.ConfigComponentID>
        <!---                                    
                                        <cfset PriceOfThisComponent = 0>
                                        <cfif isNumeric(qryConfigComponents.SellPrice)>
                                            <cfset PriceOfThisComponent = round(qryConfigComponents.SellPrice)>
                                        <cfelse>		<!---102908--->
                                            <cfset PriceOfThisComponent = round(objPriceListComponents.getSellingPrice(Variables.PriceListID, qryConfigComponents.ITEMNO))>
                                        </cfif>					
        ---> <!---                                       
                                        <cfif trim(qryConfigComponents.DESCRIPTION) IS NOT "">
                                            <cfset OptionDescription = qryConfigComponents.DESCRIPTION>
                                        <cfelse>
                                            <cfset OptionDescription = objConfigComponents.getItemDescription(qryConfigComponents.ITEMNO)>
                                        </cfif>	
        --->					


										<!--- 6/13/2012 RAB: The description that's appearing in the drop-down is not the current one in ACCPAC.  Fix this --->
<!---                                   <cfset OptionDescription = qryConfigComponents.DESCRIPTION>	--->
                                        <cfset OptionDescription = objConfigComponents.getItemDescription(qryConfigComponents.ITEMNO)>
                                        
                                        
                                        <cfif isNumeric(qryConfigComponents.AddDeductAmount)>
                                            <cfif qryConfigComponents.AddDeductAmount EQ 0>
                                                <cfset OptionDescription = OptionDescription & " (add $0.00)">
                                            <cfelseif qryConfigComponents.AddDeductAmount LT 0>
                                                <cfset OptionDescription = OptionDescription & " (deduct " & numberFormat(abs(qryConfigComponents.AddDeductAmount), '$.99') & ")">
                                            <cfelse>
                                                <cfset OptionDescription = OptionDescription & " (add " & numberFormat(abs(qryConfigComponents.AddDeductAmount), '$.99') & ")">
                                            </cfif>
                                        </cfif>
        <!---
                                        <cfif qryConfigComponents.DefaultComponent EQ 1>
                                            <cfset OptionDescription = OptionDescription & " (add $0.00)">
                                        <cfelse>
                                            <cfif PriceOfThisComponent LT PriceOfDefaultComponent>
                                                <cfset OptionDescription = OptionDescription & " (deduct ">
                                            <cfelse>
                                                <cfset OptionDescription = OptionDescription & " (add ">
                                            </cfif>
                                            <cfset OptionDescription = OptionDescription & numberFormat(abs(PriceOfDefaultComponent-PriceOfThisComponent), '$.99') & ")">
                                        </cfif>
        --->                                   
        
        
         
                                        <cfset SelectThisOption = 0>
                                        <cfif SelectDefaultComponent AND qryConfigComponents.DefaultComponent EQ 1>
                                            <cfset SelectThisOption = 1>
                                            <cfset PartReplacedWith = qryConfigComponents.ITEMNO & " (" & qryConfigComponents.DESCRIPTION & ")">
                                        <cfelseif CameFromScreen5>
                                            <cfset FieldName =  "CAT_" & CURRENTConfigComponentCategoryID <!--- qryConfigComponentCategories.ConfigComponentCategoryID ---> >
                                            <cfif structKeyExists(strQuoteScreen3, FieldName)>
                                                <cfset FieldValue = strQuoteScreen3[FieldName]>
                                                <cfif findNoCase(CURRENTConfigComponentID <!---qryConfigComponents.ConfigComponentID--->, FieldValue) NEQ 0>
                                                    <cfset SelectThisOption = 1>
                                                </cfif>
                                            </cfif>
                                        <cfelseif CopyingQuote AND objQuoteComponents.isSelectedComponent(URL.QuoteSystemID,qryConfigComponents.ITEMNO,CURRENTCategoryName)>
                                            <cfset SelectThisOption = 1>
                                        </cfif>                                	
        
    <!---                               <option value="#qryConfigComponents.ConfigComponentID#_#PriceOfThisComponent#" 	--->
    <!---                               <option value="#qryConfigComponents.ConfigComponentID#|#qryConfigComponents.Price#|#qryConfigComponents.PhotoImage#" --->
                                        <option value="#qryConfigComponents.ConfigComponentID#|#qryConfigComponents.Price#|#qryConfigComponents.PhotoImage#|#qryConfigComponents.ITEMNO#" 
                                            <cfif SelectThisOption>
                                                selected="selected"
                                            </cfif>
                                            > #OptionDescription#
                                        </option>
                                    </cfloop>
                                </select>
                                <cfset TabValue = TabValue + 1>
                                
                            </cfif>
        
                            <cfif PartNotUsed IS NOT "">
                                <br />
                                <font color="FF0000"><em>
                                    <strong>NOTE</strong>: The part number listed on this quote, #PartNotUsed#, is no longer available in this configuration.
                                    <cfif PartReplacedWith IS NOT "">
                                        The default component, #PartReplacedWith#, has been selected instead.
                                    </cfif>
                                </em></font>
                            </cfif>
                        </cfif>
                    </td>
                </tr>
			</cfif>                        
            
		</cfloop>



        <!--- **************** --->
		<!--- POWER SUPPLY ROW --->
        <!--- **************** --->

		<input type="hidden" name="PowerSupply_ConfigComponentCategoryID" value="#PowerSupply_ConfigComponentCategoryID#">

		<cfif PowerSupplyAutoSelect>
			<cfset qryTEMPConfigComponents = objConfigComponents.fillComponentOptions_Config_NEW(PowerSupply_ConfigComponentCategoryID, Variables.PriceListID)>
<!---            
qryTEMPConfigComponents:<cfdump var="#qryTEMPConfigComponents#"><br />
--->
            <cfset qryConfigComponents = queryNew("ADDDEDUCTAMOUNT,CONFIGCOMPONENTID,DEFAULTCOMPONENT,DESCRIPTION,ITEMNO,PHOTOIMAGE,PRICE")>
            <cfset PS_SS_350ET_Price = 0>
            <cfloop query="qryTEMPConfigComponents">

<!--- 07/11/2011 --->
<!---            
                <cfif trim(qryTEMPConfigComponents.ITEMNO) IS "PS-SS-350ET" OR trim(qryTEMPConfigComponents.ITEMNO) IS "PS-SS-400ET">
--->
                <cfif trim(qryTEMPConfigComponents.ITEMNO) IS "PS-SS-350ET" OR 
					  trim(qryTEMPConfigComponents.ITEMNO) IS "PS-SS-400ET" OR 
					  trim(qryTEMPConfigComponents.ITEMNO) IS "PS-SS-500ET">
                
                    <cfset queryAddRow(qryConfigComponents)>
                    <cfset querySetCell(qryConfigComponents, "CONFIGCOMPONENTID", qryTEMPConfigComponents.CONFIGCOMPONENTID)>
    
                    <cfif trim(qryTEMPConfigComponents.ITEMNO) IS "PS-SS-350ET">
                        <cfset querySetCell(qryConfigComponents, "DEFAULTCOMPONENT", 1)>
                        <cfset querySetCell(qryConfigComponents, "ADDDEDUCTAMOUNT", 0)>
                        <cfset PS_SS_350ET_Price = qryTEMPConfigComponents.Price>
                        
                    <cfelse>
                        <cfset querySetCell(qryConfigComponents, "DEFAULTCOMPONENT", 0)>
                        <cfset querySetCell(qryConfigComponents, "ADDDEDUCTAMOUNT", qryTEMPConfigComponents.Price - PS_SS_350ET_Price)>
                    </cfif>
                    
                    <cfset querySetCell(qryConfigComponents, "DESCRIPTION", qryTEMPConfigComponents.DESCRIPTION)>
                    <cfset querySetCell(qryConfigComponents, "ITEMNO", qryTEMPConfigComponents.ITEMNO)>
                    <cfset querySetCell(qryConfigComponents, "PHOTOIMAGE", qryTEMPConfigComponents.PHOTOIMAGE)>
                    <cfset querySetCell(qryConfigComponents, "PRICE", qryTEMPConfigComponents.PRICE)>
                </cfif>
            </cfloop>

            <tr id="powersupplyrow" style="visibility:hidden">
            
                <!--- "IGNORE" CHECKBOX --->
				<cfset CheckTheBox = 0>
<!---                
                <cfif CopyingQuote AND objQuoteComponents.ignoreComponent(URL.QuoteSystemID,"Power Supply")>
                    <cfset CheckTheBox = 1>
                </cfif>
--->                
                <cfif CameFromScreen5 AND structKeyExists(strQuoteScreen3, "IGNORE|#PowerSupply_ConfigComponentCategoryID#")>
                    <cfset CheckTheBox = 1>
                </cfif>
                <td>
                    <input type="checkbox" name="IGNORE|#PowerSupply_ConfigComponentCategoryID#" value="1" 
                        <cfif CheckTheBox>
                             checked="checked"
                        </cfif>
                     >		
                </td>

                <!--- CATEGORY LABEL --->
                <td valign="top" align="right" class="systemCategory">
                    Power Supply
                </td>
                <!--- QUANTITY SELECT BOX --->
                <td valign="middle" align="center" class="textsmall">
                    <cfset SelectBoxName = "QTY|" & PowerSupply_ConfigComponentCategoryID>
                    <input type="hidden" name="#SelectBoxName#" value="1" />
                    1
                </td>                
                <!--- COMPONENT SELECT BOX --->
                <td valign="top" align="left" class="textsmall">
                    <cfset SelectBoxName = "CAT_" & PowerSupply_ConfigComponentCategoryID>
<!---
qryConfigComponents:<cfdump var="#qryConfigComponents#"><br />
--->
                    <select name="#SelectBoxName#" size="1" tabindex="#TabValue#" class="textsmall" onChange="totalprice('NotCase','')">
    
                        <cfloop query="qryConfigComponents">
                            <cfset CURRENTConfigComponentID = qryConfigComponents.ConfigComponentID>
							
                          	<cfset SelectThisOption = 0>
							<cfif CameFromScreen5>
                            	<cfset PowerSupplyField = "CAT_" &    strQuoteScreen3.PowerSupply_ConfigComponentCategoryID>
                                <cfif structKeyExists(strQuoteScreen3, PowerSupplyField)>
									<cfset PowerSupplyFieldValue = strQuoteScreen3[PowerSupplyField]>
<!--- 07/11/2011 --->
<!---                                    
                                    <cfif (findNoCase("PS-SS-400ET", PowerSupplyFieldValue) NEQ 0 AND trim(qryConfigComponents.ITEMNO) IS "PS-SS-400ET") OR
                                          (findNoCase("PS-SS-350ET", PowerSupplyFieldValue) NEQ 0 AND trim(qryConfigComponents.ITEMNO) IS "PPS-SS-350ET")>
--->                                          
                                    <cfif (findNoCase("PS-SS-400ET", PowerSupplyFieldValue) NEQ 0 AND 
										   trim(qryConfigComponents.ITEMNO) IS "PS-SS-400ET") 				OR
                                          (findNoCase("PS-SS-350ET", PowerSupplyFieldValue) NEQ 0 AND 
										   trim(qryConfigComponents.ITEMNO) IS "PPS-SS-350ET")				OR
                                          (findNoCase("PS-SS-500ET", PowerSupplyFieldValue) NEQ 0 AND 
										   trim(qryConfigComponents.ITEMNO) IS "PS-SS-500ET")>

                                        <cfset SelectThisOption = 1>
                                    </cfif>
								</cfif>                                    
                            </cfif>
    
                            <cfset OptionDescription = qryConfigComponents.DESCRIPTION>
                            <cfif isNumeric(qryConfigComponents.AddDeductAmount)>
                                <cfif qryConfigComponents.AddDeductAmount EQ 0>
                                    <cfset OptionDescription = OptionDescription & " (add $0.00)">
                                <cfelseif qryConfigComponents.AddDeductAmount LT 0>
                                    <cfset OptionDescription = OptionDescription & " (deduct " & numberFormat(abs(qryConfigComponents.AddDeductAmount), '$.99') & ")">
                                <cfelse>
                                    <cfset OptionDescription = OptionDescription & " (add " & numberFormat(abs(qryConfigComponents.AddDeductAmount), '$.99') & ")">
                                </cfif>
                            </cfif>
    
                            <option value="#qryConfigComponents.ConfigComponentID#|#qryConfigComponents.Price#|#qryConfigComponents.PhotoImage#|#qryConfigComponents.ITEMNO#"
								<cfif SelectThisOption>
                                    selected="selected"
                                </cfif>
                                > #OptionDescription#
                            </option>
                        </cfloop>
                    </select>
                </td>
            </tr>
		</cfif>            









		<!--- QUANTITY --->
		<input type="hidden" name="Quantity" value="1">
<!---
		<tr>
			<td valign="middle" align="right" class="systemCategory">
				Quantity of Systems:
			</td>
			<td valign="middle" align="left" class="textsmall">
				<input name="Quantity" size="2" maxlength="50" tabindex="#TabValue#" 
					<cfif UpdatingQuote>
						value="#objQuoteSystem.getQuantityOfSystems(URL.QuoteSystemID)#"					
					<cfelse>
						value="1" 
					</cfif>
				class="textsmall">
				<cfset TabValue = TabValue + 1>
			</td>
		</tr>
--->		
		
		<!--- "CONFIRM QUOTE" BUTTON --->
		<tr>
			<td colspan="2">&nbsp;</td>
			<td colspan="2" valign="middle" align="left" class="textsmall">
				<input type="submit" name="Continue" value="Continue">
			</td>
		</tr>		
		
		<tr><td colspan="4">&nbsp;</td></tr>

	</form>
	</table>
	</td>
</tr>

</table>
</cfoutput>