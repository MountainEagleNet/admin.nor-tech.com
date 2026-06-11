<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	01/08/2013
	Template:		frmComponentsSearch.cfm	
	Task:			quotes_new4_frmComponentsSearch
--->

<cfset objPriceListComponents = createObject("component", "admin.assets.cfcs.prices.PriceListComponents")>
<cfset objPartsAdmin = createObject("component", "admin.assets.cfcs.parts.PartsAdmin")>

<cfset stRecord = structNew()>

<cfparam name="URL.SortColumn" default="ITEMNO">
<cfparam name="URL.SortOrder" default="Asc">

<cfif NOT isDefined("PriceListID") AND isDefined("URL.PriceListID")>
	<cfset PriceListID = URL.PriceListID>
</cfif>

<cfif NOT isDefined("PriceListCategoryID")>
	<cfif isDefined("URL.PriceListCategoryID")>
		<cfset PriceListCategoryID = URL.PriceListCategoryID>
	<cfelse>        
		<cfset PriceListCategoryID = "">
  	</cfif>
</cfif>

<cfif NOT isDefined("SearchText") AND isDefined("URL.SearchText")>
	<cfset SearchText = URL.SearchText>
</cfif>
<!---
<cfif URL.SortOrder IS "Asc">
	<cfset Variables.NewSortOrder = "Desc">
<cfelse>
	<cfset Variables.NewSortOrder = "Asc">
</cfif>
--->
<!---
<cfif URL.SortColumn IS "ITEMNO">
	<cfset OrderByList = "Active DESC, ITEMNO " & URL.SortOrder>
<cfelseif URL.SortColumn IS "SellPrice">
	<cfset OrderByList = "Active DESC, SellPrice " & URL.SortOrder & ", ITEMNO " & URL.SortOrder>
<cfelse>
--->
	<cfset OrderByList = "ITEMNO">
<!---	
</cfif>
--->
<cfset qryPriceListComponents = objPriceListComponents.searchComponents(PriceListID, PriceListCategoryID, SearchText, OrderByList)>

<!---
qryPriceListComponents:<cfdump var="#qryPriceListComponents#"><Br />
--->

<cfoutput>
<!---
<cfset ThisSessionID = objComponent.getSessionValue("SessionID")>
--->
<!--- Display only the top 50 --->
<cfset NumberToDisplay = 50>
<cfset NumberDisplayed = 0>

<table width="575" border="0" align="center" cellpadding="3" cellspacing="1">
<form action="index.cfm?task=quotes_new4_components_act" method="Post" name="detailform">


<input type="hidden" name="PriceListCategoryID" value="#PriceListCategoryID#">
<!---
<input type="hidden" name="CategoryDescription" value="#stRecord.CategoryDescription#">
--->
<!---<input type="hidden" name="SessionID" value="#ThisSessionID#">--->
<!---
<input type="hidden" name="GarageSaleItems" value="#GarageSaleItems#">
--->
<input type="hidden" name="UserID" value="#URL.UserID#">
<input type="hidden" name="PriceListID" value="#URL.PriceListID#">
<input type="hidden" name="CopyingQuote" value="#URL.CopyingQuote#">
<input type="hidden" name="QuoteSystemID" value="#URL.QuoteSystemID#">
<input type="hidden" name="CameFromScreen5" value="#URL.CameFromScreen5#">


<!---
<input type="hidden" name="SessionID" value="#ThisSessionID#">
<input type="hidden" name="SearchText" value="#SearchText#">
<input type="hidden" name="PriceListID" value="#PriceListID#">
--->
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
    	<cfif qryPriceListComponents.RecordCount LE NumberToDisplay>
            This page diplays all items that match the search criteria you entered on the previous page.<br /><br />
        <cfelse>
            Your search returned #qryPriceListComponents.RecordCount# items that match the search criteria you entered on the previous page.
            This page diplays the first #NumberToDisplay# of those items.<br /><br />
        </cfif>

		Choose the items you would like to add to the quote by checking their checkboxes. &nbsp;
		If a "Go to Website" link appears for an item, click it to view more details about the item. &nbsp;
		Click "Continue" when you're done.
	</td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<td colspan="2">	
		<table cellpadding="2" cellspacing="0" width="100%" border="0">
			<tr>
            	<cfif PriceListCategoryID IS NOT "">
					<td valign="middle" class="textmain" width="15%"><b>Category:</b></td>
					<td valign="middle" class="textmain" width="50%">
                    	#objPartsAdmin.getCategoryDescription(qryPriceListComponents.ITEMNO)#
                  	</td>
                </cfif>
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

		<cfset TabValue = 1>
		<!--- LIST HEADINGS --->
		<tr>

			<td height="18" bgcolor="006633" class="productTitle">
<!---            
				<a href="index.cfm?task=parts_frmComponentsSearch&SortColumn=ITEMNO&SortOrder=#Variables.NewSortOrder#&PriceListID=#urlEncodedFormat(PriceListID)#&SearchText=#urlEncodedFormat(SearchText)#" class="menuwh">
--->                
					<font color="FFFFFF">Part ##</font>
<!---                    
				</a>
--->                
			</td>
            

			<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Description</font></td>

			<td height="18" bgcolor="006633" class="productTitle" align="center">
<!---            
				<a href="index.cfm?task=parts_frmComponentsSearch&SortColumn=SellPrice&SortOrder=#Variables.NewSortOrder#&PriceListID=#urlEncodedFormat(PriceListID)#&SearchText=#urlEncodedFormat(SearchText)#" class="menuwh">
--->                
					<font color="FFFFFF">Price</font>
<!---                    
				</a>
--->                
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
						Sorry, no components were found that match the text you entered.		
					</font>
				</td>
			</tr>
		</cfif>

		<cfset SavedCategory = "">
        <cfset SavedItemNO = "">
        <cfset GrayLine = 0>
       		
		<cfloop query="qryPriceListComponents">
<!---        
        	<cfif qryPriceListComponents.ITEMNO IS NOT SavedItemNO>
				<cfset SavedItemNO = qryPriceListComponents.ITEMNO>
--->            
        		<cfif GrayLine EQ 0>
					<cfset GrayLine = 1>
                <cfelse>
					<cfset GrayLine = 0>
                </cfif>
        
                <cfset CURRENTPriceListComponentID = qryPriceListComponents.PriceListComponentID>
                
                <cfset Category = objPartsAdmin.getCategoryDescription(qryPriceListComponents.ITEMNO)>
                <cfif Category IS NOT SavedCategory AND PriceListCategoryID IS "">
                    <tr>
                        <td height="18" bgcolor="006633" class="productTitle" colspan="5">
                            <font color="FFFFFF">#Category#</font>
                        </td>
                    </tr>
                    <cfset SavedCategory = Category>
                </cfif>

                <tr<cfif GrayLine> style="background-color:##e5e5e6"</cfif>>

                    <!--- PART NUMBER / VENDOR URL LINK --->
                    <cfset VendorURL = objPartsAdmin.getVendorURL(qryPriceListComponents.ITEMNO)>
                    <td class="textsmall">
                        <cfif VendorURL IS NOT "">
                            <a target="_blank" href="#trim(VendorURL)#">
                                #qryPriceListComponents.ITEMNO#
                            </a>
                        <cfelse>
                            #qryPriceListComponents.ITEMNO#
                        </cfif>
                    </td>
        
                    <!--- PART DESCRIPTION --->
                    <cfset ItemDescription = trim(qryPriceListComponents.DESCRIPTION)>
                    <cfif len(ItemDescription) GT 53>
                        <cfset ItemDescription = left(ItemDescription,50) & "...">
                    </cfif>
                    <td class="textsmall">#ItemDescription#</td>
        
                    <!--- SELLING PRICE --->
                    <td class="textsmall" align="center">
                        <cfif qryPriceListComponents.SellPrice LE 0>
                            <font color="FF0000"><i>#dollarFormat(qryPriceListComponents.SellPrice)#</i></font>
                        <cfelse>
                            #dollarFormat(qryPriceListComponents.SellPrice)#
                        </cfif>
                    </td>
        
        
        			<!--- CURRENT AVAILABILITY --->
					<td class="textsmall" align="center">#objPriceListComponents.getCurrentAvailability(qryPriceListComponents.ITEMNO)#</td>

					<!--- CHECK BOX --->
					<cfset FieldName = "CHECKED|" & CURRENTPriceListComponentID>
					<td class="textsmall" align="center">
                        <input type="checkbox" name="#FieldName#" value="1" tabindex="#TabValue#">						
						<cfset TabValue = TabValue + 1>
					</td>
 
                </tr>
           		<cfset NumberDisplayed = NumberDisplayed + 1>
<!---
            </cfif>
--->            
            <cfif NumberDisplayed GE NumberToDisplay>
            	<cfbreak>
            </cfif>
		</cfloop>

	</table>
</td>
</tr>


</form>
</table>

</cfoutput>