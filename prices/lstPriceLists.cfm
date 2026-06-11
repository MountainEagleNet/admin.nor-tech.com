<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/18/2007
	Function: 		This page displays a list of Price Lists
	Template:		lstPriceLists.cfm
	Task:			config_pricelists_list
--->
	<cfset objPriceLists = createObject("component", "admin.assets.cfcs.prices.PriceLists")>

	<!--- Sales Rep Price Lists --->
	<cfparam name="URL.SortOrder" type="string" default="Asc">

	<!--- set the new sort order for display --->
	<cfif URL.SortOrder IS "Desc">
		<cfset Variables.NewSortOrder = "Asc">
	<cfelse>
		<cfset Variables.NewSortOrder = "Desc">
	</cfif>
	
	<cfset OrderByList = "Name " & URL.SortOrder>
<!---	
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "MasterPriceList", 0, True)>
	<cfset structInsert(SearchRecord, "UserID", objPriceLists.getSessionValue("adminuserid"), True)>
	<cfset qryPriceLists = objPriceLists.searchRecords(SearchRecord, "query", "Name #URL.SortOrder#")>
--->
	<cfset qryPriceLists = objPriceLists.listSalesRepPriceLists(OrderByList)>


<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">Price Lists</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objPriceLists.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<!---
<cfif NOT SESSION.UserOnVacation>
    <tr>
        <!--- "Create a New System" link --->
        <td align="right" class="textmain">
            <a href="prices/index.cfm?task=config_pricelists_new_edit" target="_blank">
                Create a New Price List
            </a>
        </td>
    </tr>
</cfif>   
---> 

<tr>
<td valign="top" class="textmain">
	<table cellpadding="0" cellspacing="0" width="100%" border="0">
	
	<!--- LIST HEADINGS --->
	<tr>
		<td height="18" bgcolor="006633" class="productTitle" width="50%">
			<font color="FFFFFF">
				<a class="menuwh" href="index.cfm?task=config_pricelists_list&SortOrder=#NewSortOrder#">
					Price List Name
				</a>
			</font>
		</td>
		<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">&nbsp;</font></td>
	</tr>

	<!--- LIST DATA --->	
	<cfif qryPriceLists.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="2" class="productTitle"><font color="FF0000">You currently have no Price Lists defined.</font></td>
		</tr>
	</cfif>
	
	<cfloop query="qryPriceLists">
		<tr<cfif qryPriceLists.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>

			<td class="textsmall">
<!---			<a href="index.cfm?task=config_pricelists_name_edit&PriceListID=#urlEncodedFormat(qryPriceLists.PriceListID)#">--->
				<a href="prices/index.cfm?task=config_pricelists_name_edit&PriceListID=#urlEncodedFormat(qryPriceLists.PriceListID)#" target="_blank">
					#qryPriceLists.Name#
				</a>
			</td>
			<td class="textsmall" align="center">
				<cfif qryPriceLists.DefaultPriceList>
					default
				<cfelse>
					&nbsp;
				</cfif>
			</td>
		</tr>
	</cfloop>

	</table>
</td>
</tr>


</table>
</cfoutput>