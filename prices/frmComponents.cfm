<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/18/2007
	Function: 		Third page in the price list edit wizard: Components
	Template:		frmComponents.cfm	
	Task:			config_pricelists_components_edit
--->
<cfset objPriceLists = createObject("component", "admin.assets.cfcs.prices.PriceLists")>
<cfset objPriceListCategories = createObject("component", "admin.assets.cfcs.prices.PriceListCategories")>
<cfset objPriceListComponents = createObject("component", "admin.assets.cfcs.prices.PriceListComponents")>
<cfset objPartsAdmin = createObject("component", "admin.assets.cfcs.parts.PartsAdmin")>

<!---<cfset MasterPriceList = objPriceListCategories.getSessionValue("MasterPriceList")>--->

<cfparam name="URL.SearchComponents" default="0">
<cfparam name="URL.SearchText" default="">


<cfif isDefined("URL.Validation")>
	<cfset stRecord = objPriceListComponents.getDataRecord()>
	<cfset stErrors = objPriceListComponents.getErrorRecord()>
	<cfset Variables.PriceListCategoryID = stRecord.PriceListCategoryID>
<cfelse>



	<cfset Variables.PriceListCategoryID = URL.PriceListCategoryID>
	<cfset stRecord = objPriceListCategories.getRecord(Variables.PriceListCategoryID, "struct")>

    <cfset structInsert(stRecord, "SearchComponents", URL.SearchComponents, True)>
    <cfset structInsert(stRecord, "SearchText", URL.SearchText, True)>

	<cfif isDefined("URL.PriceListID")>
    	<cfset Variables.PriceListID = URL.PriceListID>
	<cfelse>        
    	<cfset Variables.PriceListID = stRecord.PriceListID>
    </cfif>
    <cfset structInsert(stRecord, "PriceListID", Variables.PriceListID, True)>

	<cfset stErrors = structNew()>


</cfif>

<cfset strPriceList = objPriceLists.getRecord(stRecord.PriceListID)>

<cfparam name="URL.SortColumn" default="ITEMNO">
<cfparam name="URL.SortOrder" default="Asc">

<cfif URL.SortOrder IS "Asc">
	<cfset Variables.NewSortOrder = "Desc">
<cfelse>
	<cfset Variables.NewSortOrder = "Asc">
</cfif>

<cfif URL.SortColumn IS "ITEMNO">
	<cfset OrderByList = "Active DESC, ITEMNO " & URL.SortOrder>
<cfelseif URL.SortColumn IS "SellPrice">
	<cfset OrderByList = "Active DESC, SellPrice " & URL.SortOrder & ", ITEMNO " & URL.SortOrder>
<cfelseif URL.SortColumn IS "AmountAvailable">
	<cfset OrderByList = "Active DESC, AmountAvailable " & URL.SortOrder & ", ITEMNO " & URL.SortOrder>
<cfelseif URL.SortColumn IS "ItemCost">
	<cfset OrderByList = "Active DESC, ItemCost " & URL.SortOrder & ", ITEMNO " & URL.SortOrder>
</cfif>
<!---
Variables.PriceListCategoryID:<cfdump var="#Variables.PriceListCategoryID#"><br />
stRecord.PriceListID:<cfdump var="#stRecord.PriceListID#"><br />
--->
<cfif NOT stRecord.SearchComponents>
	<cfset qryPriceListComponents = objPriceListComponents.listComponents(Variables.PriceListCategoryID, OrderByList)>
<cfelse>
    <cfset qryPriceListComponents = objPriceListComponents.searchComponentsPrices(stRecord.PriceListID, Variables.PriceListCategoryID, stRecord.SearchText, OrderByList)>
</cfif>
    
<!---
qryPriceListComponents:<cfdump var="#qryPriceListComponents#"><br />
<cfabort>
--->
<cfoutput>

<!---<table width="575" border="0" align="center" cellpadding="3" cellspacing="1">--->
<table width="800" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">
		Component Pricing
	</td>
	<td valign="top" class="textsmall" align="right">
		<a href="index.cfm?task=config_pricelists_categories_edit&PriceListID=#urlEncodedFormat(stRecord.PriceListID)#">
			Back to Category List Page
		</a>
	</td>

</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain" colspan="2"><font color="FF0000">#objPriceListComponents.getMessage()#</font></td>
</tr>


<tr><!--- Instructions --->
	<td valign="top" class="textsmall" colspan="2">
		<cfif NOT SESSION.UserOnVacation>
            The checkboxes in the left column of the list indicate whether or not a part is active for this price list. &nbsp; 
            Check or uncheck the boxes and click "Save Component" to make your selections. &nbsp; 
            To update an individual component's selling price, click the number in the "Sell Price" column (or the word "[none]" if the component currently has no sell price entered). &nbsp; 
            To set a fixed selling price for a part, enter the amount in the fixed price box and update the component's selling price (as described above). &nbsp; 
            Entering an amount in the Fixed Markup box and updating the component's selling price (as described above) will add the fixed markup to the ACCPAC cost and set that as the Sell Price. &nbsp; 
		</cfif>
		Click the list headings to sort the list by that column.
	</td>
</tr>


<tr>
    <td class="textsmall" align="left" valign="middle" colspan="2">

        <br />
        You can search for specific items by entering part of the item description in the field below and clicking "Search". 
        This will find all items in this category that match the description that you enter.

        <cfif isDefined("URL.SearchTextError")>
            <font color="FF0000">
                <br /><br />
                Enter something in the text box before clicking "Search"<br>
            </font>
        </cfif>

        <form action="index.cfm?task=config_pricelists_actSearch" method="Post" name="detailformsearch">
            <input type="hidden" name="PriceListID" value="#stRecord.PriceListID#" />
            <input type="hidden" name="PriceListCategoryID" value="#Variables.PriceListCategoryID#" />
            <input type="hidden" name="task_CameFrom" value="config_pricelists_components_edit" />
<!---        
            <input type="hidden" name="CategoryDescription" value="#stRecord.CategoryDescription#">

            <input type="hidden" name="GarageSaleItems" value="#GarageSaleItems#">
            <input type="hidden" name="UserID" value="#URL.UserID#">
            <input type="hidden" name="CopyingQuote" value="#URL.CopyingQuote#">
            <input type="hidden" name="QuoteSystemID" value="#URL.QuoteSystemID#">
            <input type="hidden" name="CameFromScreen5" value="#URL.CameFromScreen5#">
--->
            
            <input type="text" name="SearchText" size="40" maxlength="50" value="#stRecord.SearchText#" class="textsmall" 
                <cfif isDefined("URL.SearchTextError")>style="border:1px solid red;"</cfif>                        
            >
            <input type="submit" name="ButtonClicked" value="Search" onClick="document.detailformsearch.ButtonClicked.disabled=1;document.detailformsearch.submit()">
        </form>
    </td>
</tr>
<tr><td colspan="2"><hr /></td></tr>


<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<td colspan="2">	
		<table cellpadding="2" cellspacing="0" width="100%" border="0">
			<tr>
				<td valign="middle" class="textmain" width="37%"><b>Price List Name:</b></td>
				<td valign="top" class="textmain">#strPriceList.Name#</td>
			</tr>
			<tr>
				<td valign="middle" class="textmain"><b>Description:</b></td>
				<td valign="top" class="textmain">#strPriceList.Description#</td>
			</tr>
			<tr>
				<td valign="middle" class="textmain"><b>Global Markup Percentage:</b></td>
				<td valign="top" class="textmain">
					<cfif trim(strPriceList.MarkupPercent) IS NOT "">
						#strPriceList.MarkupPercent# %
					<cfelse>
						<i>[none]</i>
					</cfif>
				</td>
			</tr>
            
            <cfif Variables.PriceListCategoryID IS NOT "">
                <tr>
                    <td valign="middle" class="textmain"><b>Category:</b></td>
                    <td valign="top" class="textmain">#stRecord.CATEGORY# - #stRecord.CategoryDescription#</td>
                </tr>
                <tr>
                    <td valign="middle" class="textmain"><b>Category Markup Percentage:</b></td>
                    <td valign="top" class="textmain">
                        <cfif trim(stRecord.MarkupPercent) IS NOT "">
                            #stRecord.MarkupPercent# %
                        <cfelse>
                            <i>[none]</i>
                        </cfif>
                    </td>
                </tr>
            </cfif>
            
		</table>
	</td>
</tr>

<tr>
<td valign="top" class="textmain" colspan="2">
	<table cellpadding="0" cellspacing="0" width="100%" border="0">
		<form action="index.cfm?task=config_pricelists_components_act&RequestTimeout=6000" method="Post" name="detailform">
		<input type="hidden" name="PriceListCategoryID" value="#Variables.PriceListCategoryID#">
		<input type="hidden" name="PriceListID" value="#stRecord.PriceListID#">
		<cfif Variables.PriceListCategoryID IS NOT "">
            <input type="hidden" name="CATEGORY" value="#stRecord.CATEGORY#">
            <input type="hidden" name="CategoryDescription" value="#stRecord.CategoryDescription#">
            <input type="hidden" name="MarkupPercent" value="#stRecord.MarkupPercent#">
        </cfif>
		<input type="hidden" name="SortColumn" value="#URL.SortColumn#">
		<input type="hidden" name="SortOrder" value="#URL.SortOrder#">

		<input type="hidden" name="SearchComponents" value="#stRecord.SearchComponents#">
		<input type="hidden" name="SearchText" value="#stRecord.SearchText#">

		<!---
		<cfif NOT SESSION.UserOnVacation AND stRecord.PriceListID IS NOT "MASTERPRICELISTUUID">
			<tr>
				<td colspan="9">
					<input type="submit" name="ButtonClicked" value="Save Components">
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
		</cfif>
		--->

		<cfif isDefined("URL.ErrorFixedPrice")>
			<tr>
				<td colspan="9" class="textmain">
					<font color="FF0000">
						Please enter only Numeric values greater than or equal to zero in the Fixed Price fields.<br>&nbsp;
					</font>
				</td>
			</tr>
		</cfif>
		<cfif isDefined("URL.ErrorFixedMarkup")>
			<tr>
				<td colspan="9" class="textmain">
					<font color="FF0000">
						Please enter only Numeric values greater than or equal to zero in the Fixed Markup fields.<br>&nbsp;
					</font>
				</td>
			</tr>
		</cfif>
		<cfif isDefined("URL.ErrorPercentMarkup")>
			<tr>
				<td colspan="9" class="textmain">
					<font color="FF0000">
						Please enter only Numeric values greater than or equal to zero in the Percent Markup fields.<br>&nbsp;
					</font>
				</td>
			</tr>
		</cfif>
		
		<cfset TabValue = 1>
		<!--- LIST HEADINGS --->
		<tr>
			<cfif stRecord.PriceListID IS NOT "MASTERPRICELISTUUID">
				<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">&nbsp;</font></td>
			</cfif>
			<td height="18" bgcolor="006633" class="productTitle">
				<a href="index.cfm?task=config_pricelists_components_edit&
						SortColumn=ITEMNO&SortOrder=#Variables.NewSortOrder#&
						PriceListCategoryID=#urlEncodedFormat(Variables.PriceListCategoryID)#" class="menuwh">
					<font color="FFFFFF">Part ##</font>
				</a>
			</td>
			
			<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Description</font></td>

			<td height="18" bgcolor="006633" class="productTitle" align="center">
				<a href="index.cfm?task=config_pricelists_components_edit&
						SortColumn=AmountAvailable&SortOrder=#Variables.NewSortOrder#&
						PriceListCategoryID=#urlEncodedFormat(Variables.PriceListCategoryID)#" class="menuwh">
					<font color="FFFFFF">Curr<br>Avail</font>
				</a>
			</td>

			<td height="18" bgcolor="006633" class="productTitle" align="center">
				<a href="index.cfm?task=config_pricelists_components_edit&
						SortColumn=ItemCost&SortOrder=#Variables.NewSortOrder#&
						PriceListCategoryID=#urlEncodedFormat(Variables.PriceListCategoryID)#" class="menuwh">
					<font color="FFFFFF">ACCPAC<br>Cost</font>
				</a>
			</td>

			<td height="18" bgcolor="006633" class="productTitle" align="center">
				<a href="index.cfm?task=config_pricelists_components_edit&
						SortColumn=SellPrice&SortOrder=#Variables.NewSortOrder#&
						PriceListCategoryID=#urlEncodedFormat(Variables.PriceListCategoryID)#" class="menuwh">
					<font color="FFFFFF">Sell<br>Price</font>
				</a>
			</td>

			<td height="18" bgcolor="006633" class="productTitle" align="center"><font color="FFFFFF">Fixed<br>Price</font></td>

			<td height="18" bgcolor="006633" class="productTitle" align="center"><font color="FFFFFF">Fixed<br>Markup</font></td>

			<td height="18" bgcolor="006633" class="productTitle" align="center"><font color="FFFFFF">%<br>Markup</font></td>

<!---		<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">&nbsp;</font></td>	--->
		</tr>
		<!--- LIST DATA --->	
		<cfif qryPriceListComponents.RecordCount EQ 0>
			<tr>
				<td align="center" colspan="9" class="productTitle">
					<font color="FF0000">
						<cfif NOT stRecord.SearchComponents>
							There are no components defined for this category.
                      	<cfelse>
                        	No components were found matching your search criteria: '<strong>#stRecord.SearchText#</strong>'
                        </cfif>
					</font>
				</td>
			</tr>
		</cfif>
		<cfset ActiveSaved = 1>
		<cfloop query="qryPriceListComponents">
			<cfset CURRENTPriceListComponentID = qryPriceListComponents.PriceListComponentID>
			<cfif qryPriceListComponents.Active NEQ ActiveSaved>
				<tr><td colspan="9"><hr></td></tr>
                <tr><td colspan="9" valign="middle" class="textmain" align="center"><em><strong>Inactive Components</strong></em></td></tr>
				<cfset ActiveSaved = 0>
			</cfif>
			<tr<cfif qryPriceListComponents.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
	
    			<input name="ITEMNO|#CURRENTPriceListComponentID#" type="hidden" value="" />
                
				<!--- "ACTIVE" CHECKBOX --->
				<cfif stRecord.PriceListID IS NOT "MASTERPRICELISTUUID">
					<td class="textsmall">
						<!---
						<cfif NOT SESSION.UserOnVacation>
                            <input type="checkbox" name="ACTIVE|#CURRENTPriceListComponentID#" value="1" 
                                <cfif qryPriceListComponents.Active EQ 1>
                                    checked
                                </cfif>
                            >				
						<cfelse>
                            <input type="hidden" name="ACTIVE|#CURRENTPriceListComponentID#" value="#qryPriceListComponents.Active#">
						</cfif>
						--->
						<input type="hidden" name="ACTIVE|#CURRENTPriceListComponentID#" value="#qryPriceListComponents.Active#">
					</td>
				</cfif>
								
				<!--- PART NUMBER --->
				<cfset VendorURL = objPartsAdmin.getVendorURL(qryPriceListComponents.ITEMNO)>
				<td class="textsmall">
					<cfif VendorURL IS NOT "">
						<a target="_blank" href="#trim(VendorURL)#">#qryPriceListComponents.ITEMNO#</a>
					<cfelse>
						#qryPriceListComponents.ITEMNO#
					</cfif>
				</td>
				
				<!--- PART DESCRIPTION --->
				<cfset ItemDescription = trim(objPriceListComponents.getItemDescription(qryPriceListComponents.ITEMNO))>
<!---
				<cfif len(ItemDescription) GT 30>
					<cfset ItemDescription = left(ItemDescription,27) & "...">
				</cfif>
--->
				<td class="textsmall">#ItemDescription#</td>

				<!--- CURRENT AVAILABILITY --->
<!---			<cfset AmountAvailable = objPriceListComponents.getCurrentAvailability(qryPriceListComponents.ITEMNO)>	--->
				<td class="textsmall" align="center">#qryPriceListComponents.AmountAvailable#</td>
				
				<!--- ACCPAC COST --->
<!---			<cfset ItemCost = objPriceListComponents.getItemCost(qryPriceListComponents.ITEMNO)>	--->
				<td class="textsmall" align="center">#dollarFormat(qryPriceListComponents.ItemCost)#</td>

				<!--- SELLING PRICE --->
				<td class="textsmall" align="center">
					<!---
					<cfif qryPriceListComponents.Active AND NOT SESSION.UserOnVacation>
						<cfset UpdateField = "UPDATE|" & CURRENTPriceListComponentID>
						<input type="hidden" name="#UpdateField#">
						<a href="javascript: document.detailform['#UpdateField#'].value=1; document.detailform.submit(); void 0">
							<cfif trim(qryPriceListComponents.SellPrice) IS "">
								<font color="FF0000"><i>[none]</i></font>
							<cfelseif qryPriceListComponents.SellPrice LE 0>
								<font color="FF0000"><i>#dollarFormat(qryPriceListComponents.SellPrice)#</i></font>
							<cfelse>
								#dollarFormat(qryPriceListComponents.SellPrice)#
							</cfif>
						</a>
					<cfelse>
						<cfif trim(qryPriceListComponents.SellPrice) IS "">
							<font color="FF0000"><i>[none]</i></font>
						<cfelseif qryPriceListComponents.SellPrice LE 0>
							<font color="FF0000"><i>#dollarFormat(qryPriceListComponents.SellPrice)#</i></font>
						<cfelse>
							#dollarFormat(qryPriceListComponents.SellPrice)#
						</cfif>
					</cfif>
					--->
					<cfif trim(qryPriceListComponents.SellPrice) IS "">
						<font color="FF0000"><i>[none]</i></font>
					<cfelseif qryPriceListComponents.SellPrice LE 0>
						<font color="FF0000"><i>#dollarFormat(qryPriceListComponents.SellPrice)#</i></font>
					<cfelse>
						#dollarFormat(qryPriceListComponents.SellPrice)#
					</cfif>
				
<!---				
					<cfif trim(qryPriceListComponents.SellPrice) IS "">
						<font color="FF0000"><i>[none]</i></font>
					<cfelseif qryPriceListComponents.SellPrice LE 0>
						<font color="FF0000"><i>#dollarFormat(qryPriceListComponents.SellPrice)#</i></font>
					<cfelse>
						#dollarFormat(qryPriceListComponents.SellPrice)#
					</cfif>
--->					
				</td>

				<!--- FIXED PRICE --->
				<cfset FieldName = "FIX|" & CURRENTPriceListComponentID>
				<cfif structKeyExists(stRecord, FieldName)>
					<cfset FieldValue = stRecord[FieldName]>
				<cfelse>
					<cfset FieldValue = qryPriceListComponents.FixedPrice>
				</cfif>
				<cfset FieldValueDisplay = FieldValue>
				<cfif trim(FieldValue) IS NOT "" AND isNumeric(FieldValue)>
					<cfset FieldValueDisplay = numberFormat(FieldValue, '.99')>
				</cfif>
				<td class="textsmall" align="center">
					<!---
					<cfif qryPriceListComponents.Active AND NOT SESSION.UserOnVacation>
						<input name="#FieldName#" size="1" maxlength="50" tabindex="#TabValue#" value="#FieldValueDisplay#" class="textsmall" 
							<cfif structKeyExists(stErrors, FieldName)>style="border:1px solid red;"</cfif>
						>
						<cfset TabValue = TabValue + 1>
					<cfelse>
						#FieldValue#
						<input type="hidden" name="#FieldName#" value="#FieldValue#">
					</cfif>
					--->
					#FieldValue#
					<input type="hidden" name="#FieldName#" value="#FieldValue#">
				</td>

				<!--- FIXED MARKUP --->
				<cfset FieldName = "MRK|" & CURRENTPriceListComponentID>
				<cfif structKeyExists(stRecord, FieldName)>
					<cfset FieldValue = stRecord[FieldName]>
				<cfelse>
					<cfset FieldValue = qryPriceListComponents.FixedMarkup>
				</cfif>
				<cfset FieldValueDisplay = FieldValue>
				<cfif trim(FieldValue) IS NOT "" AND isNumeric(FieldValue)>
					<cfset FieldValueDisplay = numberFormat(FieldValue, '.99')>
				</cfif>
				<td class="textsmall" align="center">
					<!---
					<cfif qryPriceListComponents.Active AND NOT SESSION.UserOnVacation>
						<input name="#FieldName#" size="1" maxlength="50" tabindex="#TabValue#" value="#FieldValueDisplay#" class="textsmall" 
							<cfif structKeyExists(stErrors, FieldName)>style="border:1px solid red;"</cfif>
						>
						<cfset TabValue = TabValue + 1>
					<cfelse>
						#FieldValue#
						<input type="hidden" name="#FieldName#" value="#FieldValue#">
					</cfif>
					--->
					#FieldValue#
					<input type="hidden" name="#FieldName#" value="#FieldValue#">
				</td>
				
				<!--- MARKUP % --->
				<cfset FieldName = "PCT|" & CURRENTPriceListComponentID>
				<cfif structKeyExists(stRecord, FieldName)>
					<cfset FieldValue = stRecord[FieldName]>
				<cfelse>
					<cfset FieldValue = qryPriceListComponents.PercentMarkup>
				</cfif>
				<cfset FieldValueDisplay = FieldValue>
				<cfif trim(FieldValue) IS NOT "" AND isNumeric(FieldValue)>
					<cfset FieldValueDisplay = numberFormat(FieldValue, '.99')>
				</cfif>
				<td class="textsmall" align="center">
					<!---
					<cfif qryPriceListComponents.Active AND NOT SESSION.UserOnVacation>
						<input name="#FieldName#" size="1" maxlength="50" tabindex="#TabValue#" value="#FieldValueDisplay#" class="textsmall" 
							<cfif structKeyExists(stErrors, FieldName)>style="border:1px solid red;"</cfif>
						>
						<cfset TabValue = TabValue + 1>
					<cfelse>
						#FieldValue#
						<input type="hidden" name="#FieldName#" value="#FieldValue#">
					</cfif>
					--->
					#FieldValue#
					<input type="hidden" name="#FieldName#" value="#FieldValue#">
				</td>
				
<!---				
				<!--- UPDATE PRICE LINK --->
				<td valign="middle" class="textsmall">
					<cfif qryPriceListComponents.Active>
<!---
						<a href="index.cfm?task=config_pricelists_updateprices&PriceListComponentID=#urlEncodedFormat(CURRENTPriceListComponentID)#&UpdateType=Component">
							Update
						</a>
--->
						<cfset UpdateField = "UPDATE|" & CURRENTPriceListComponentID>
						<input type="hidden" name="#UpdateField#">
						<a href="javascript: document.detailform['#UpdateField#'].value=1; document.detailform.submit(); void 0">
							Update
						</a>

					<cfelse>
						&nbsp;
					</cfif>
				</td>
--->				
			</tr>
		</cfloop>
		</form>

	</table>
</td>
</tr>

</table>
</cfoutput>