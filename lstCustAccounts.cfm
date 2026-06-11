<cfsilent>
	<!---
	Coded By: Alternative Systems, Inc - Nicholas Tunney
	Create Date: 7/17/2005
	Edit Date: 
	Function: This page displays a list of customer accounts
	lstCustAccounts.cfm
	--->
	<cfset objCust = createObject("component", "admin.assets.cfcs.Cust")>
	<cfset objPriceLists = createObject("component", "admin.assets.cfcs.prices.PriceLists")>
		 
	<!--- set defaults for search criteria if coming from search form --->
	<cfif IsDefined("FORM.ProcessSearch")>
		<!--- delete and recreate the search struct if it exists --->
		<cfscript> 
			StructDelete(SESSION, "Search");
			SESSION.Search = StructNew();
		</cfscript>
		<cfloop collection="#FORM#" item="Field">
			<cfif Field NEQ "ProcessSearch" AND Field NEQ "FieldNames">
				<cfset "SESSION.Search.#Field#" = trim(evaluate(Field))>
			</cfif>
		</cfloop>
	<cfelseif NOT isDefined("SESSION.Search")>
		<cfset SESSION.Search = StructNew()>
	</cfif>
	
	<cfparam name="URL.qsr" default="1">
	<cfparam name="URL.qmr" default="20">
	<cfparam name="URL.sb" default="Company">
	<cfparam name="URL.ad" default="ASC">
	
<!---<cfset qCustAccts = objCust.searchRecords(SESSION.Search, URL.sb, URL.ad)>--->
	<cfset OrderByList = URL.sb & " " & URL.ad>
	<cfif URL.sb IS "PriceListID">
		<cfset OrderByList = URL.sb & " " & URL.ad & ", company " & URL.ad>
	</cfif>
	<cfset qCustAccts = objCust.searchRecordsALT(SESSION.Search, OrderByList)>
</cfsilent>

<!---<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">--->
<table width="575" border="0" align="center" cellpadding="3" cellspacing="1">
<!--- spacer --->
<tr>
	<td class="textsmall">&nbsp;</td>
</tr>

<cfif isDefined("URL.DeletedCustomer")>
	<tr>
		<td class="textmain">
			<font color="FF0000">
            	<cfoutput>
            	<cfif  URL.DeletedCustomer EQ 1>
                    The customer account has been successfully deleted.
<!---                    
            	<cfelseif  URL.DeletedCustomer EQ 2>
                	There are quotes attached to this customer, but a default customer was not found for Account Number '#qCustAccts.acctno#'.  We therefore don't have an account to reassign these quotes to, so you cannot delete this customer.
				<cfelse>
                    There are quotes attached to this customer, but more than 1 default customer was not found for Account Number '#qCustAccts.acctno#'.  We therefore don't know who to reassign these quotes to, so you cannot delete this customer.                
--->                
             	</cfif>
                </cfoutput>
			</font>
		</td>
	</tr>
</cfif>

<!--- links --->
<!---
<cfif NOT SESSION.UserOnVacation>
    <tr>
        <td class="textsmall" align="right">
            <strong><a href="index.cfm?task=admin_custaccounts_new">Add a new customer</a><br></strong>
        </td>
    </tr>
</cfif>
--->
    
<tr>
	<td class="textmain" align="left">
		<table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
		<tr>
		<td colspan="7" class="textmain"><cf_nextprev queryname="qCustAccts" actionstring="index.cfm?task=admin_custaccounts_list" querystartrow="#URL.qsr#" querymaxrows="#URL.qmr#"></td>
		</tr>
		<tr>
		<td height="18" bgcolor="#006633"><div align="center"><a href="index.cfm?task=admin_custaccounts_list&sb=acctno&ad=<cfif lcase(URL.sb) EQ 'acctno'><cfif lcase(URL.ad) EQ 'asc'>desc<cfelse>asc</cfif><cfelse>asc</cfif>" class="menuwh">Cust No</a></font></div></td>
		<td height="18" bgcolor="#006633"><div align="center"><a href="index.cfm?task=admin_custaccounts_list&sb=company&ad=<cfif lcase(URL.sb) EQ 'company'><cfif lcase(URL.ad) EQ 'asc'>desc<cfelse>asc</cfif><cfelse>asc</cfif>" class="menuwh">Company</a></font></div></td>
		<td height="18" bgcolor="#006633"><div align="center"><a href="index.cfm?task=admin_custaccounts_list&sb=firstname&ad=<cfif lcase(URL.sb) EQ 'firstname'><cfif lcase(URL.ad) EQ 'asc'>desc<cfelse>asc</cfif><cfelse>asc</cfif>" class="menuwh">Name</a></font></div></td>
		<td height="18" bgcolor="#006633"><div align="center"><a href="index.cfm?task=admin_custaccounts_list&sb=email&ad=<cfif lcase(URL.sb) EQ 'email'><cfif lcase(URL.ad) EQ 'asc'>desc<cfelse>asc</cfif><cfelse>asc</cfif>" class="menuwh">Email</a></font></div></td>
		<td height="18" bgcolor="#006633"><div align="center"><a href="index.cfm?task=admin_custaccounts_list&sb=active&ad=<cfif lcase(URL.sb) EQ 'active'><cfif lcase(URL.ad) EQ 'asc'>desc<cfelse>asc</cfif><cfelse>asc</cfif>" class="menuwh">Active</a></font></div></td>
		<td height="18" bgcolor="#006633"><div align="center"><a href="index.cfm?task=admin_custaccounts_list&sb=DefaultAccount&ad=<cfif lcase(URL.sb) EQ 'DefaultAccount'><cfif lcase(URL.ad) EQ 'asc'>desc<cfelse>asc</cfif><cfelse>asc</cfif>" class="menuwh">Default<br />Account</a></font></div></td>
		<td height="18" bgcolor="#006633"><div align="center"><a href="index.cfm?task=admin_custaccounts_list&sb=PriceListID&ad=<cfif lcase(URL.sb) EQ 'PriceListID'><cfif lcase(URL.ad) EQ 'asc'>desc<cfelse>asc</cfif><cfelse>asc</cfif>" class="menuwh">Price<br>List</a></font></div></td>
		</tr>
		<cfif qCustAccts.RecordCount EQ 0>
			<tr>
			<td class="textmain" align="center" colspan="7"><font color="FF0000">Sorry, no customers were found</font></td>
			</tr>
		</cfif>
		
		<cfoutput query="qCustAccts" maxrows="#URL.qmr#" startrow="#URL.qsr#">
			<tr<cfif qCustAccts.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
				<td class="textsmall" align="left"><a href="index.cfm?task=admin_custaccounts_view&uid=#URLEncodedFormat(ID)#">#AcctNo#</a></td>
				<td class="textsmall" align="left">#Company#</td>
				<td class="textsmall" align="left">#FirstName# #Lastname#</td>
				<td class="textsmall" align="left">#Email#</td>
				<td class="textsmall" align="center"><cfif Active EQ 1>Yes<cfelse>No</cfif></td>
				<td class="textsmall" align="center"><cfif DefaultAccount EQ 1><span style="color:##F00">Yes</span><!---<cfelse>No---></cfif></td>
				<td class="textsmall" align="center">
					<cfset strPriceList = objPriceLists.getRecord(qCustAccts.PriceListID)>
					<cfif qCustAccts.PriceListID IS "" or NOT structKeyExists(strPriceList, "Name")><font color="FF0000"><i>[none]</i></font><cfelse>#strPriceList.Name#</cfif>
				</td>
			</tr>
		</cfoutput>
		<tr>
		<td colspan="7" class="textmain"><cf_nextprev queryname="qCustAccts" actionstring="index.cfm?task=admin_custaccounts_list" querystartrow="#URL.qsr#" querymaxrows="#URL.qmr#"></td>
		</tr>
		</table>
	</td>
</tr>

</table>
