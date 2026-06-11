<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	09/07/2007
	Function: 		Parts Ordering: list components, enter quantities
	Template:		frmComponents.cfm	
	Task:			quotes_new4_components
--->
<cfset objPriceListCategories = createObject("component", "admin.assets.cfcs.prices.PriceListCategories")>
<cfset objPriceListComponents = createObject("component", "admin.assets.cfcs.prices.PriceListComponents")>
<cfset objPartsOrdersItems = createObject("component", "admin.assets.cfcs.parts.PartsOrdersItems")>
<cfset objPartsAdmin = createObject("component", "admin.assets.cfcs.parts.PartsAdmin")>

<cfif isDefined("URL.GarageSaleItems")>
	<cfset GarageSaleItems = URL.GarageSaleItems>
<cfelse>
	<cfset GarageSaleItems = 0>
</cfif>

<cfif isDefined("URL.Validation")>
	<cfset stRecord = objPriceListComponents.getDataRecord()>
	<cfset stErrors = objPriceListComponents.getErrorRecord()>
	<cfset Variables.PriceListCategoryID = stRecord.PriceListCategoryID>
<cfelse>
	<cfif GarageSaleItems>
		<cfset stRecord = structNew()>
		<cfset structInsert(stRecord, "PriceListCategoryID", "", true)>
		<cfset structInsert(stRecord, "CategoryDescription", "NOR-TECH'S CLOSEOUT SPECIALS", true)>
		<cfset Variables.PriceListCategoryID = stRecord.PriceListCategoryID>
	<cfelse>
		<cfset Variables.PriceListCategoryID = URL.PriceListCategoryID>
		<cfset stRecord = objPriceListCategories.getRecord(Variables.PriceListCategoryID, "struct")>
	</cfif>
	<cfset stErrors = structNew()>
</cfif>

<cfparam name="URL.SortColumn" default="ITEMNO">
<cfparam name="URL.SortOrder" default="Asc">

<cfif URL.SortOrder IS "Asc">
	<cfset Variables.NewSortOrder = "Desc">
<cfelse>
	<cfset Variables.NewSortOrder = "Asc">
</cfif>

<cfif URL.SortColumn IS "ITEMNO" AND GarageSaleItems>
	<cfset OrderByList = "ITEMNO " & URL.SortOrder>
<cfelseif URL.SortColumn IS "ITEMNO" AND NOT GarageSaleItems>
	<cfset OrderByList = "Active DESC, ITEMNO " & URL.SortOrder>
<cfelseif URL.SortColumn IS "SellPrice" AND GarageSaleItems>
	<cfset OrderByList = "SellPrice " & URL.SortOrder & ", ITEMNO " & URL.SortOrder>
<cfelseif URL.SortColumn IS "SellPrice" AND NOT GarageSaleItems>
	<cfset OrderByList = "Active DESC, SellPrice " & URL.SortOrder & ", ITEMNO " & URL.SortOrder>
<cfelse>
	<cfset OrderByList = "ITEMNO">
</cfif>

<cfif GarageSaleItems>
	<cfset qryPriceListComponents = objPartsAdmin.getGarageSaleItems(OrderByList)>
<cfelse>
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "PriceListCategoryID", Variables.PriceListCategoryID, True)>
	<cfset structInsert(SearchRecord, "Active", 1, True)>
	<cfset qryPriceListComponents = objPriceListComponents.searchRecords(SearchRecord, "query", OrderByList)>
</cfif>

<cfoutput>

<!---<cfset ThisSessionID = objComponent.getSessionValue("SessionID")>--->

<table width="575" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle" colspan="2">
		Parts
	</td>
<!---
	<td valign="top" class="textsmall" align="right">
		<a href="index.cfm?task=parts_categories_list">
			Back to Category List Page
		</a>
	</td>
--->
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain" colspan="2"><font color="FF0000">#objPriceListComponents.getMessage()#</font></td>
</tr>

<tr><!--- Instructions --->
	<td valign="top" class="textmain" colspan="2">
		Choose the items you would like to add to the quote by checking their checkboxes. &nbsp;
		If a "Go to Website" link appears for an item, click it to view more details about the item. &nbsp;
		Click "Continue" when you're done.
	</td>
</tr>

<cfif NOT GarageSaleItems>
    <tr>
        <td class="textmain" align="left" valign="middle">
    
            <br />
            You can search for specific items by entering part of the item description in the field below and clicking "Search". 
            This will find all items in this category that match the description that you enter.

            <cfif isDefined("URL.SearchTextError")>
                <font color="FF0000">
                	<br /><br />
                    Enter something in the text box before clicking "Search"<br>
                </font>
            </cfif>
    
            <form action="index.cfm?task=quotes_new4_actSearch" method="Post" name="detailformsearch">
                <input type="hidden" name="PriceListID" value="#URL.PriceListID#" />
                <input type="hidden" name="PriceListCategoryID" value="#stRecord.PriceListCategoryID#" />
                <input type="hidden" name="CategoryDescription" value="#stRecord.CategoryDescription#">
                <input type="hidden" name="task_CameFrom" value="quotes_new4_components" />

                <input type="hidden" name="GarageSaleItems" value="#GarageSaleItems#">
                <input type="hidden" name="UserID" value="#URL.UserID#">
                <input type="hidden" name="CopyingQuote" value="#URL.CopyingQuote#">
                <input type="hidden" name="QuoteSystemID" value="#URL.QuoteSystemID#">
                <input type="hidden" name="CameFromScreen5" value="#URL.CameFromScreen5#">

                
                <input type="text" name="SearchText" size="40" maxlength="50" value="" class="textsmall" 
                    <cfif isDefined("URL.SearchTextError")>style="border:1px solid red;"</cfif>                        
                >
                <input type="submit" name="ButtonClicked" value="Search" onClick="document.detailformsearch.ButtonClicked.disabled=1;document.detailformsearch.submit()">
            </form>
        </td>
    </tr>
    <tr><td><hr /></td></tr>
</cfif>


<!--- spacer --->
<!---<tr><td class="textsmall">&nbsp;</td></tr>--->

<form action="index.cfm?task=quotes_new4_components_act" method="Post" name="detailform">
<input type="hidden" name="PriceListCategoryID" value="#stRecord.PriceListCategoryID#">
<input type="hidden" name="CategoryDescription" value="#stRecord.CategoryDescription#">
<!---<input type="hidden" name="SessionID" value="#ThisSessionID#">--->
<input type="hidden" name="GarageSaleItems" value="#GarageSaleItems#">

<input type="hidden" name="UserID" value="#URL.UserID#">
<input type="hidden" name="PriceListID" value="#URL.PriceListID#">
<input type="hidden" name="CopyingQuote" value="#URL.CopyingQuote#">
<input type="hidden" name="QuoteSystemID" value="#URL.QuoteSystemID#">
<input type="hidden" name="CameFromScreen5" value="#URL.CameFromScreen5#">

<tr>
	<td colspan="2">	
		<table cellpadding="2" cellspacing="0" width="100%" border="0">
			<tr>
				<td valign="middle" class="textmain" width="15%"><b>Category:</b></td>
				<td valign="middle" class="textmain" width="50%">#stRecord.CategoryDescription#</td>
				<td valign="middle" class="textmain" align="right">
					<input type="submit" name="ButtonClicked" value="Continue" onClick="document.detailform.ButtonClicked.disabled=1;document.detailform.submit()">
				</td>
			</tr>
		</table>
	</td>
</tr>
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain" colspan="2">
	<table cellpadding="0" cellspacing="0" width="100%" border="0">

		<cfif isDefined("stErrors.QuantityError")>
			<tr>
				<td colspan="8" class="textmain">
					<font color="FF0000">
						#stErrors.QuantityError#<br>&nbsp;
					</font>
				</td>
			</tr>
		</cfif>
		
		<cfset TabValue = 1>
		<!--- LIST HEADINGS --->
		<tr>

			<td height="18" bgcolor="006633" class="productTitle">
<!---			<a href="index.cfm?task=parts_components_edit&
						SortColumn=ITEMNO&SortOrder=#Variables.NewSortOrder#&
						PriceListCategoryID=#urlEncodedFormat(Variables.PriceListCategoryID)#&
						GarageSaleItems=#GarageSaleItems#" class="menuwh">	--->
					<font color="FFFFFF">Part ##</font>
<!---			</a>	--->
			</td>
			
			<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">&nbsp;</font></td>

			<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Description</font></td>

			<td height="18" bgcolor="006633" class="productTitle" align="center">
<!---			<a href="index.cfm?task=parts_components_edit&
						SortColumn=SellPrice&SortOrder=#Variables.NewSortOrder#&
						PriceListCategoryID=#urlEncodedFormat(Variables.PriceListCategoryID)#&
						GarageSaleItems=#GarageSaleItems#" class="menuwh">	--->
					<font color="FFFFFF">Price</font>
<!---			</a>	--->                
			</td>

			<!--- CURRENT AVAIL --->
			<td height="18" bgcolor="006633" class="productTitle" align="center"><font color="FFFFFF">Curr<br />Avail</font></td>

			<td height="18" bgcolor="006633" class="productTitle" align="center"><font color="FFFFFF">Select</font></td>

		</tr>
		<!--- LIST DATA --->	
		<cfif qryPriceListComponents.RecordCount EQ 0>
			<tr>
				<td align="center" colspan="5" class="productTitle">
					<font color="FF0000">
						<cfif GarageSaleItems>
							Sorry, there are currently no Nor-Tech Specials.		
						<cfelse>
							Sorry, there are no components defined for this category.		
						</cfif>
					</font>
				</td>
			</tr>
		</cfif>

		<cfset SavedCategory = "">
		
		<cfloop query="qryPriceListComponents">
		
			<!--- If the page is not the Garage Sale Items page and this item is not a garage sale item, list it --->
			<cfif GarageSaleItems OR NOT objPartsAdmin.isGarageSaleItem(qryPriceListComponents.ITEMNO)>

				<cfif GarageSaleItems>
					<cfset CURRENTPriceListComponentID = qryPriceListComponents.PartsAdminID>
				<cfelse>
					<cfset CURRENTPriceListComponentID = qryPriceListComponents.PriceListComponentID>
				</cfif>
				
				<cfif GarageSaleItems>
					<cfset Category = objPartsAdmin.getCategoryDescription(qryPriceListComponents.ITEMNO)>
					<cfif Category IS NOT SavedCategory>
						<tr>
							<td height="18" bgcolor="006633" class="productTitle" colspan="5">
								<font color="FFFFFF">#Category#</font>
							</td>
						</tr>
						<cfset SavedCategory = Category>
					</cfif>
				</cfif>
				
				<tr<cfif qryPriceListComponents.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
		
					<!--- PART NUMBER --->
					<td class="textsmall">#qryPriceListComponents.ITEMNO#</td>
	
					<!--- VENDOR URL LINK --->
					<cfset VendorURL = objPartsAdmin.getVendorURL(qryPriceListComponents.ITEMNO)>
					<td class="textsmall" align="left">
						<cfif VendorURL IS NOT "">
							<a target="_blank" href="#trim(VendorURL)#">
								Go to Website
							</a>
						<cfelse>
							&nbsp;
						</cfif>
					</td>
					
					<!--- PART DESCRIPTION --->
					<cfset ItemDescription = trim(objPriceListComponents.getItemDescription(qryPriceListComponents.ITEMNO))>
					<cfif len(ItemDescription) GT 40>
						<cfset ItemDescription = left(ItemDescription,37) & "...">
					</cfif>
					<td class="textsmall">#ItemDescription#</td>
	
					<!--- SELLING PRICE --->
					<td class="textsmall" align="center">
						<cfset SellingPrice = objPartsAdmin.getSellPrice(qryPriceListComponents.ITEMNO)>
						<cfif SellingPrice IS "">
							<cfset SellingPrice = qryPriceListComponents.SellPrice>
						</cfif>
						<cfif SellingPrice LE 0>
							<font color="FF0000"><i>#dollarFormat(qryPriceListComponents.SellPrice)#</i></font>
						<cfelse>
							#dollarFormat(SellingPrice)#
						</cfif>
					</td>

					<!--- CURRENT AVAIL --->
					<td class="textsmall" align="center">#objPriceListComponents.getCurrentAvailability(qryPriceListComponents.ITEMNO)#</td>


<!---	
					<!--- QUANTITY --->
					<cfset FieldName = "QTY|" & CURRENTPriceListComponentID>
					<cfif structKeyExists(stRecord, FieldName)>
						<cfset FieldValue = stRecord[FieldName]>
					<cfelse>
						<cfset FieldValue = objPartsOrdersItems.getQuantity(qryPriceListComponents.ITEMNO)>
					</cfif>
	<!---
					<cfset FieldValueDisplay = FieldValue>
					<cfif trim(FieldValue) IS NOT "">
						<cfset FieldValueDisplay = numberFormat(FieldValue, '.99')>
					</cfif>
	--->				
					<td class="textsmall" align="center">
						<input name="#FieldName#" size="1" maxlength="50" tabindex="#TabValue#" value="#FieldValue#" class="textsmall" 
							<cfif structKeyExists(stErrors, FieldName)>style="border:1px solid red;"</cfif>
						>
						<cfset TabValue = TabValue + 1>
					</td>
--->

					<cfset FieldName = "CHECKED|" & CURRENTPriceListComponentID>
					<td class="textsmall" align="center">
                        <input type="checkbox" name="#FieldName#" value="1" tabindex="#TabValue#">						
						<cfset TabValue = TabValue + 1>
					</td>

				</tr>
			</cfif>
				
		</cfloop>

	</table>
</td>
</tr>

<cfif GarageSaleItems>
	<tr>
		<td valign="top" class="textsmall" colspan="2">
			***Nor-tech Closeout Items are sold on an "As IS" basis<br>
			***Nor-tech provides a 1 year warranty on all items except monitors;  90 days on monitors<br>
			***Prices good only while quantities last!!
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
</cfif>

</form>
</table>

</cfoutput>