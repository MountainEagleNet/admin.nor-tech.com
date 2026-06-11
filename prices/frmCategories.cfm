<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/18/2007
	Function: 		Second page in the price list edit wizard: Categories
	Template:		frmCategories.cfm	
	Task:			config_pricelists_categories_edit
--->
<cfparam name="url.updated" default="0">

<cfset objPriceLists = createObject("component", "admin.assets.cfcs.prices.PriceLists")>
<cfset objPriceListCategories = createObject("component", "admin.assets.cfcs.prices.PriceListCategories")>
<cfif isDefined("URL.Validation")>
	<cfset stRecord = objPriceListCategories.getDataRecord()>
	<cfset stErrors = objPriceListCategories.getErrorRecord()>
	<cfset Variables.PriceListID = stRecord.PriceListID>
<cfelse>
	<cfset Variables.PriceListID = URL.PriceListID>
	<cfset stRecord = objPriceLists.getRecord(Variables.PriceListID, "struct")>
	<cfset stErrors = structNew()>
</cfif>

<cfset qryPriceListCategories = objPriceListCategories.listRecordsForParent("PriceListID", Variables.PriceListID, "SortOrder")>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<tr>
<td valign="top" class="subpagetitle">Category List Page</td>
<td valign="top" class="textsmall" align="right"><a href="index.cfm?task=config_pricelists_name_edit&PriceListID=#urlEncodedFormat(stRecord.PriceListID)#">Back to Price List Name Page</a></td>
</tr>

<tr>
<td valign="top" class="textmain" colspan="2"><font color="FF0000">#objPriceListCategories.getMessage()#</font></td>
</tr>

<tr>
<td valign="top" class="textsmall" colspan="2">
	Click on any category code or description in the list to "drill down" to a list of components for that category. &nbsp; <br />
	<cfif NOT SESSION.UserOnVacation>
    	You may enter a markup percentage for a category in the appropriate box. &nbsp; <br />
        Clicking "Update Category Prices" calculates the selling price of all parts in that category. <br />
        To resort the categories, enter an integer (or decimal) value in any of the "Sort Order" boxes, then click "Sort Categories".
	</cfif>
</td>
</tr>

<tr>
<td class="textsmall" align="left" valign="middle" colspan="2">
	<br />
	You can search for specific items by entering part of the item description in the field below and clicking "Search". 
	This will find all items that match the description that you enter.
	
	<cfif isDefined("URL.SearchTextError")>
	<font color="FF0000">
	<br /><br />
	Enter something in the text box before clicking "Search"<br>
	</font>
	</cfif>
	<form action="index.cfm?task=config_pricelists_actSearch" method="Post" name="detailformsearch">
	<input type="hidden" name="PriceListID" value="#Variables.PriceListID#" />
	<input type="hidden" name="PriceListCategoryID" value="" />
	<input type="hidden" name="task_CameFrom" value="config_pricelists_categories_edit" />           
	<input type="text" name="SearchText" size="40" maxlength="50"<cfif isDefined("stRecord.SearchText")> value="#stRecord.SearchText#"</cfif> class="textsmall"<cfif isDefined("URL.SearchTextError")> style="border:1px solid red;"</cfif>>
	<input type="submit" name="ButtonClicked" value="Search" onClick="document.detailformsearch.ButtonClicked.disabled=1;document.detailformsearch.submit()">
	</form>
</td>
</tr>

<tr><td colspan="2"><hr /></td></tr>

<tr>
<td colspan="2">	
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	<tr>
	<td valign="middle" class="textmain" width="37%"><b>Price List Name:</b></td>
	<td valign="top" class="textmain">#stRecord.Name#</td>
	</tr>
	<tr>
	<td valign="middle" class="textmain"><b>Description:</b></td>
	<td valign="top" class="textmain">#stRecord.Description#</td>
	</tr>
	<tr>
	<td valign="middle" class="textmain"><b>Global Markup Percentage:</b></td>
	<td valign="top" class="textmain"><cfif trim(stRecord.MarkUpPercent) IS NOT "">#stRecord.MarkUpPercent# %<cfelse><i>[none]</i></cfif></td>
	</tr>
	</table>
</td>
</tr>

<tr>
<td valign="top" class="textmain" colspan="2">
	<table cellpadding="0" cellspacing="0" width="100%" border="0">
	<form action="index.cfm?task=config_pricelists_categories_act&RequestTimeout=6000" method="Post" name="detailform">
	<input type="hidden" name="PriceListID" value="#Variables.PriceListID#">
	<!---
	<cfif NOT SESSION.UserOnVacation>
    	<tr>
        <td colspan="4" align="left"><input type="submit" name="ButtonClicked" value="Update Categories" style="margin-bottom:5px;"></td>
        </tr>
	</cfif>
	--->
        
	<cfif url.updated eq 1>
		<tr>
		<td colspan="4" class="textmain"><font color="green"><em>The price list categories have been successfully updated.</em></font></td>
		</tr>
	</cfif>

	<cfset TabValue = 1>
	<tr>
	<td bgcolor="006633" class="productTitle"><font color="FFFFFF">Display</font></td>
	<td bgcolor="006633" class="productTitle"><font color="FFFFFF">Category</font></td>
	<td bgcolor="006633" class="productTitle" align="center"><font color="FFFFFF">Sort<br>Order</font></td>
	<td bgcolor="006633" class="productTitle" align="center"><font color="FFFFFF">Markup<br>Percentage</font></td>
	</tr>
	<cfif qryPriceListCategories.RecordCount EQ 0>
		<tr>
		<td align="center" colspan="4" class="productTitle"><font color="FF0000">There are no categories defined for this price list.</font></td>
		</tr>
	</cfif>
	<cfset variables.inactive = structNew()>
	<cfset variables.crow = 0>
	<cfloop query="qryPriceListCategories">
		<cfset CURRENTPriceListCategoryID = qryPriceListCategories.PriceListCategoryID>
		<cfset UpdateField = "UPDATE|" & CURRENTPriceListCategoryID>
		<cfset DisplayName = "DSP|" & CURRENTPriceListCategoryID>
		<cfset SortName = "SRT|" & CURRENTPriceListCategoryID>
		<cfset PctName = "PCT|" & CURRENTPriceListCategoryID>
		<cfif structKeyExists(stRecord, DisplayName)><cfset DisplayValue = stRecord[DisplayName]><cfelseif qryPriceListCategories.SortOrder eq 0><cfset DisplayValue = 0><cfelse><cfset DisplayValue = 1></cfif>
		<cfif structKeyExists(stRecord, SortName)><cfset SortValue = stRecord[SortName]><cfelse><cfset SortValue = qryPriceListCategories.SortOrder></cfif>
		<cfif structKeyExists(stRecord, PctName)><cfset PctValue = stRecord[PctName]><cfelse><cfset PctValue = qryPriceListCategories.MarkupPercent></cfif>
		
		<cfif DisplayValue eq 0>
			<cfset variables.inactive[CURRENTPriceListCategoryID] = {Category=qryPriceListCategories.CATEGORY,CategoryDescription=qryPriceListCategories.CategoryDescription,DisplayName=variables.DisplayName,DisplayValue=variables.DisplayValue,SortName=variables.SortName,SortValue=variables.SortValue,PctName=variables.PctName,PctValue=variables.PctValue}>
		<cfelse>	
			<cfset variables.crow = val(variables.crow + 1)>	
			<tr<cfif variables.crow mod 2> style="background-color:##e5e5e6"</cfif>>				
			<td class="textsmall">#yesNoFormat(DisplayValue)#<!--- <input type="checkbox" name="#DisplayName#" value="#DisplayValue#"<cfif DisplayValue neq 0> checked</cfif>/> ---></td>
			<td class="textsmall"><a href="index.cfm?task=config_pricelists_components_edit&PriceListCategoryID=#urlEncodedFormat(CURRENTPriceListCategoryID)#">#qryPriceListCategories.CATEGORY# - #qryPriceListCategories.CategoryDescription#</a></td>
	           <td class="textsmall" align="center">
				<!---
				<cfif SESSION.UserOnVacation eq 0 AND SortValue GTE 1>
					<input name="#SortName#" size="1" maxlength="50" tabindex="#TabValue#" value="#SortValue#"<cfif structKeyExists(stErrors, SortName)> style="border:1px solid red;"</cfif>>
					<cfset TabValue = TabValue + 1>
				<cfelse>
					<input type="hidden" name="#SortName#" value="#SortValue#">
					<cfif SortValue EQ 0><font color="gray">#SortValue#</font><cfelse>#SortValue#</cfif>
				</cfif>
				--->
				<input type="hidden" name="#SortName#" value="#SortValue#">
				<cfif SortValue EQ 0><font color="gray">#SortValue#</font><cfelse>#SortValue#</cfif>
			</td>
			<td class="textsmall" align="center">
				<!---
				<cfif SESSION.UserOnVacation eq 0 AND SortValue GTE 1>
					<input type="text" name="#PctName#" size="3" maxlength="50" tabindex="#TabValue#" value="#PctValue#"<cfif structKeyExists(stErrors, PctName)> style="border:1px solid red;"</cfif>> %
					<cfset TabValue = TabValue + 1>
				<cfelse>
					<input type="hidden" name="#PctName#" value="#PctValue#">
					<cfif SortValue EQ 0><font color="gray">#PctValue#</font><cfelse>#PctValue#</cfif>
				</cfif>
				--->
				<input type="hidden" name="#PctName#" value="#PctValue#">
				<cfif SortValue EQ 0><font color="gray">#PctValue#</font><cfelse>#PctValue#</cfif>
			</td>
			</tr>
		</cfif>
	</cfloop>
	<cfset InactiveKeys = structKeyList(variables.inactive)>
	<cfloop list="#InactiveKeys#" index="iKey">
		<cfset iRecord = variables.inactive[iKey]>
		<cfset variables.crow = val(variables.crow + 1)>
		<tr<cfif variables.crow mod 2> style="background-color:##e5e5e6"</cfif>>				
			<td class="textsmall">#yesNoFormat(iRecord.DisplayValue)# <!--- <input type="checkbox" name="#iRecord.DisplayName#" value="#iRecord.DisplayValue#"<cfif iRecord.DisplayValue neq 0> checked</cfif>/> ---></td>
			<td class="textsmall"><a href="index.cfm?task=config_pricelists_components_edit&PriceListCategoryID=#urlEncodedFormat(iKey)#">#iRecord.CATEGORY# - #iRecord.CategoryDescription#</a></td>
	           <td class="textsmall" align="center">
				<!---
				<cfif SESSION.UserOnVacation eq 0 AND iRecord.SortValue GTE 1>
					<input name="#iRecord.SortName#" size="1" maxlength="50" tabindex="#TabValue#" value="#iRecord.SortValue#"<cfif structKeyExists(stErrors, iRecord.SortName)> style="border:1px solid red;"</cfif>>
					<cfset TabValue = TabValue + 1>
				<cfelse>
					<input type="hidden" name="#iRecord.SortName#" value="#iRecord.SortValue#">
					<cfif iRecord.SortValue EQ 0><font color="gray">#iRecord.SortValue#</font><cfelse>#iRecord.SortValue#</cfif>
				</cfif>
				--->
				<input type="hidden" name="#iRecord.SortName#" value="#iRecord.SortValue#">
				<cfif iRecord.SortValue EQ 0><font color="gray">#iRecord.SortValue#</font><cfelse>#iRecord.SortValue#</cfif>
			</td>
			<td class="textsmall" align="center">
				<!---
				<cfif SESSION.UserOnVacation eq 0 AND iRecord.SortValue GTE 1>
					<input type="text" name="#iRecord.PctName#" size="3" maxlength="50" tabindex="#TabValue#" value="#iRecord.PctValue#"<cfif structKeyExists(stErrors, iRecord.PctName)> style="border:1px solid red;"</cfif>> %
					<cfset TabValue = TabValue + 1>
				<cfelse>
					<input type="hidden" name="#iRecord.PctName#" value="#iRecord.PctValue#">
					<cfif iRecord.SortValue EQ 0><font color="gray">#iRecord.PctValue#</font><cfelse>#iRecord.PctValue#</cfif>
				</cfif>
				--->
				<input type="hidden" name="#iRecord.PctName#" value="#iRecord.PctValue#">
				<cfif iRecord.SortValue EQ 0><font color="gray">#iRecord.PctValue#</font><cfelse>#iRecord.PctValue#</cfif>
			</td>
			</tr>
	</cfloop>
	
	<!---
	<cfif NOT SESSION.UserOnVacation>
    	<tr>
        <td colspan="4" align="left"><input type="submit" name="ButtonClicked" value="Update Categories" style="margin-top:5px;"></td>
        </tr>
	</cfif>
	--->
	</form>
	</table>
</td>
</tr>
</table>
</cfoutput>