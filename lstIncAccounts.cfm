<cfsilent>
	<!---
	Coded By: Alternative Systems, Inc - Nicholas Tunney
	Create Date: 7/17/2005
	Edit Date: 
	Function: This page displays a list of customer accounts
	lstCustAccounts.cfm
	--->
	<cfset objCust = createObject("component", "admin.assets.cfcs.Cust")>
	
	<cfparam name="URL.qsr" default="1">
	<cfparam name="URL.qmr" default="20">
	<cfparam name="URL.sb" default="Company">
	<cfparam name="URL.ad" default="ASC">
	
	<cfset qCustAccts = objCust.getIncompleteAccounts(URL.sb, URL.ad)>
</cfsilent>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<!--- spacer --->
<tr>
	<td class="textsmall">&nbsp;</td>
</tr>
<tr>
	<td class="textmain" align="left">
		<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
		<tr>
			<td colspan="3" class="textmain"><cf_nextprev queryname="qCustAccts" actionstring="index.cfm?task=admin_accounts_incomplete" querystartrow="#URL.qsr#" querymaxrows="#URL.qmr#"></td>
		</tr>
		<tr>
			<td height="18" bgcolor="#006633" width="5%"><div align="center"><a href="index.cfm?task=admin_custaccounts_list&sb=acctno&ad=<cfif lcase(URL.sb) EQ 'acctno'><cfif lcase(URL.ad) EQ 'asc'>desc<cfelse>asc</cfif><cfelse>asc</cfif>" class="menuwh">Cust No</a></font></div></td>
			<td height="18" bgcolor="#006633" width="20%"><div align="center"><a href="index.cfm?task=admin_custaccounts_list&sb=company&ad=<cfif lcase(URL.sb) EQ 'company'><cfif lcase(URL.ad) EQ 'asc'>desc<cfelse>asc</cfif><cfelse>asc</cfif>" class="menuwh">Company</a></font></div></td>
			<td height="18" bgcolor="#006633" width="20%"><div align="center"><a href="index.cfm?task=admin_custaccounts_list&sb=firstname&ad=<cfif lcase(URL.sb) EQ 'firstname'><cfif lcase(URL.ad) EQ 'asc'>desc<cfelse>asc</cfif><cfelse>asc</cfif>" class="menuwh">Name</a></font></div></td>
			<td height="18" bgcolor="#006633" width="30%"><div align="center"><a href="index.cfm?task=admin_custaccounts_list&sb=email&ad=<cfif lcase(URL.sb) EQ 'email'><cfif lcase(URL.ad) EQ 'asc'>desc<cfelse>asc</cfif><cfelse>asc</cfif>" class="menuwh">Email</a></font></div></td>
			<td height="18" bgcolor="#006633" width="10%"><div align="center"><a href="index.cfm?task=admin_custaccounts_list&sb=active&ad=<cfif lcase(URL.sb) EQ 'active'><cfif lcase(URL.ad) EQ 'asc'>desc<cfelse>asc</cfif><cfelse>asc</cfif>" class="menuwh">Active</a></font></div></td>
			<td height="18" bgcolor="#006633" class="productTitle" width="15%"><div align="center" class="style4"><font color="#FFFFFF">Edit Account</font></div></td>
		</tr>
		<cfoutput query="qCustAccts" maxrows="#URL.qmr#" startrow="#URL.qsr#">
			<tr<cfif qCustAccts.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
				<td class="textsmall" align="left">#AcctNo#</td>
				<td class="textsmall" align="left">#Company#</td>
				<td class="textsmall" align="left">#FirstName# #Lastname#</td>
				<td class="textsmall" align="left">#Email#</td>
				<td class="textsmall" align="center"><cfif Active EQ 1>Yes<cfelse>No</cfif></td>
				<td class="textsmall" align="center"><a href="index.cfm?task=admin_custaccounts_incomplete_edit&uid=#URLEncodedFormat(ID)#">Edit</a></td>
			</tr>
		</cfoutput>
		<tr>
			<td colspan="3" class="textmain"><cf_nextprev queryname="qCustAccts" actionstring="index.cfm?task=admin_custaccounts_list" querystartrow="#URL.qsr#" querymaxrows="#URL.qmr#"></td>
		</tr>
		</table>
	</td>
</tr>

</table>
