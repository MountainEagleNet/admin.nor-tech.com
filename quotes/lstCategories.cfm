<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	09/07/2007
	Function: 		Parts Ordering: list categories
	Template:		lstCategories.cfm	
	Task:			quotes_new4_categories
--->
<cfset objPriceListCategories = createObject("component", "admin.assets.cfcs.prices.PriceListCategories")>
<cfset objPartsAdmin = createObject("component", "admin.assets.cfcs.parts.PartsAdmin")>

<cfset objComponent = createObject("component", "admin.assets.cfcs.Component")>
<cfset objCust = createObject("component", "admin.assets.cfcs.Cust")>
<cfset objSalesRep = createObject("component", "admin.assets.cfcs.SalesRep")>




<cfset strSalesRep = objSalesRep.getRecord(objComponent.getSessionValue("salesrepid"))>

<!---<cfdump var="#strSalesRep#">--->

<cfset strQuoteScreen3 = objComponent.getSessionValue("QuoteScreen3")>

<!---<cfdump var="#strQuoteScreen3#">--->


<!---
<cfset SearchRecord = structNew()>
<cfset structInsert(SearchRecord, "CustomerID", strQuoteScreen3.CustomerID, True)>
<cfset strLogin = objCust.searchRecords(SearchRecord)>
--->


<!---strLogin:<cfdump var="#strLogin#">--->


<!---
<cfset SessionUserID = objComponent.getSessionValue("id")>
<cfset strLogin = objCust.getRecordAsStruct(URLDecode(SessionUserID))>
<cfset strSalesRep = objSalesRep.getRecord(strLogin.salesrepID)>
--->
<!---
URL.PriceListID:<cfdump var="#URL.PriceListID#"><br />
--->
<cfset qryPriceListCategories = objPriceListCategories.getPriceListCategories(URL.PriceListID)>

<cfset qryGarageSaleItems = objPartsAdmin.getGarageSaleItems()>

<cfoutput>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<!---
<form action="index.cfm?task=quotes_new4_categories_act" method="Post" name="detailform">
<input type="hidden" name="UserID" value="#URL.UserID#">
<input type="hidden" name="PriceListID" value="#URL.PriceListID#">
<input type="hidden" name="CopyingQuote" value="#URL.CopyingQuote#">
<input type="hidden" name="QuoteSystemID" value="#URL.QuoteSystemID#">
<input type="hidden" name="CameFromScreen5" value="#URL.CameFromScreen5#">
--->
<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle" colspan="2">
		Parts from Customer Price List
	</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain" colspan="2"><font color="FF0000">#objPriceListCategories.getMessage()#</font></td>
</tr>

<tr><!--- Instructions --->
	<td>
		<table width="100%" border="0" align="center" cellpadding="3" cellspacing="3">
			<tr>
				<td valign="top" class="textmain">
<!---				Welcome to the parts ordering section of the Nor-Tech Partners Website!  From here you can place an order with your sales rep for individual parts, including parts that are tagged as "Nor-Tech Closeout Specials".<br><br>	--->
					
					Click on any category in the list below.  From there you can indicate which items you would like to add to the quote.<br><br>
					
                    You can search for specific items by entering part of the item description in the field below and clicking "Search". <br /><br />
                    
					When you're done, click the "Back To Quote" button to the right.
				</td>
<!---                
				<td valign="bottom" class="textmain" align="right" width="18%">
					<input type="submit" name="ButtonClicked" value="Back To Quote" onClick="document.detailform.ButtonClicked.disabled=1;document.detailform.submit()">
				</td>
--->                
			</tr>
            
            
            <tr><td>&nbsp;</td></tr>
            
            
            
            <tr>
				<td class="textmain" align="left" valign="middle">
					<cfif isDefined("URL.SearchTextError")>
                        <font color="FF0000">
                            Enter something in the text box before clicking "Search"<br>
                        </font>
                    </cfif>
                
                    <form action="index.cfm?task=quotes_new4_actSearch" method="Post" name="detailformsearch">
                        <input type="hidden" name="task_CameFrom" value="quotes_new4_categories" />
                        <input type="hidden" name="UserID" value="#URL.UserID#">
                        <input type="hidden" name="PriceListID" value="#URL.PriceListID#">
                        <input type="hidden" name="CopyingQuote" value="#URL.CopyingQuote#">
                        <input type="hidden" name="QuoteSystemID" value="#URL.QuoteSystemID#">
                        <input type="hidden" name="CameFromScreen5" value="#URL.CameFromScreen5#">
                        <input type="text" name="SearchText" size="40" maxlength="50" value="" class="textsmall" 
							<cfif isDefined("URL.SearchTextError")>style="border:1px solid red;"</cfif>                        
                        >
                        <input type="submit" name="SearchButtonClicked" value="Search" onClick="document.detailformsearch.SearchButtonClicked.disabled=1;document.detailformsearch.submit()">
                    </form>
				</td>
				<td class="textmain" align="right" valign="middle">
                

                    <form action="index.cfm?task=quotes_new4_categories_act" method="Post" name="detailform">
                        <input type="hidden" name="UserID" value="#URL.UserID#">
                        <input type="hidden" name="PriceListID" value="#URL.PriceListID#">
                        <input type="hidden" name="CopyingQuote" value="#URL.CopyingQuote#">
                        <input type="hidden" name="QuoteSystemID" value="#URL.QuoteSystemID#">
                        <input type="hidden" name="CameFromScreen5" value="#URL.CameFromScreen5#">
                        <input type="submit" name="ButtonClicked" value="Back To Quote" onClick="document.detailform.ButtonClicked.disabled=1;document.detailform.submit()">
                    </form>
				</td>
            </tr>
            
            
		</table>
	</td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain" colspan="2">
	<table cellpadding="0" cellspacing="0" width="100%" border="0">

		<!--- LIST HEADINGS --->
		<tr>
			<td height="18" bgcolor="006633" class="productTitle" width="5%">&nbsp;</td>
			<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Category</font></td>
		</tr>
		<!--- LIST DATA --->	
		<cfif qryPriceListCategories.RecordCount EQ 0>
			<tr>
				<td align="center" colspan="2" class="productTitle">
					<font color="FF0000">
						Sorry, there are no categories defined.<br>
						Please contact your sales rep<cfif isDefined("strSalesRep.repemail")>, <a href="mailto:#strSalesRep.repemail#">#strSalesRep.repname#</a>,</cfif> for more information.
					</font>
				</td>
			</tr>
		</cfif>
		
		<!--- GARAGE SALE ITEMS --->
<!---
		<cfif qryGarageSaleItems.RecordCount GT 0 AND strLogin.GarageSaleAccess EQ 1>
			<tr>
				<td class="textsmall">&nbsp;</td>
				<td class="textsmall">
					<a href="index.cfm?task=parts_components_edit&GarageSaleItems=1">
						<font color="FF0000">NOR-TECH'S CLOSEOUT SPECIALS</font>
					</a>
				</td>
			</tr>
		</cfif>
--->		
		<cfloop query="qryPriceListCategories">
			<cfset CURRENTPriceListCategoryID = qryPriceListCategories.PriceListCategoryID>
			
			<tr<cfif qryPriceListCategories.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
				<td class="textsmall">&nbsp;</td>
				<td class="textsmall">
					<a href="index.cfm?task=quotes_new4_components&PriceListCategoryID=#urlEncodedFormat(CURRENTPriceListCategoryID)#&UserID=#urlEncodedFormat(URL.UserID)#&PriceListID=#urlEncodedFormat(URL.PriceListID)#&CopyingQuote=#URL.CopyingQuote#&CameFromScreen5=#URL.CameFromScreen5#&QuoteSystemID=#urlEncodedFormat(URL.QuoteSystemID)#">
						#qryPriceListCategories.CategoryDescription#
					</a>
				</td>
			</tr>
		</cfloop>

	</table>
</td>
</tr>
<!---
</form>
--->
</table>
</cfoutput>