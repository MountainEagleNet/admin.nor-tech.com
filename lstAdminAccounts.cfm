<cfsilent>
	<!---
	Coded By: Alternative Systems, Inc - Nicholas Tunney
	Create Date: 7/16/2005
	Edit Date: 
	Function: This page displays a list of admin accounts
	lstAdminAccounts.cfm
	--->
<!---<cfset objAdmin = createObject("component", "admin.assets.cfcs.Admin")>--->
	<cfset objAdmin = createObject("component", "admin.assets.cfcs.Admin")>

	<cfset qAdminAccts = objAdmin.listRecords()>
	
	<cfparam name="URL.qsr" default="1">
	<cfparam name="URL.qmr" default="20">
</cfsilent>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<!--- spacer --->
<tr>
	<td class="textsmall">&nbsp;</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000"><cfoutput>#objAdmin.getMessage()#</cfoutput></font></td>
</tr>

<!--- links --->
<tr>
	<td class="textsmall" align="right">
		<strong><a href="index.cfm?task=admin_accounts_new">Add a new account</a><br></strong>
	</td>
</tr>
<tr>
	<td class="textmain" align="left">
		<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
		<tr>
			<td colspan="3" class="textmain"><cf_nextprev queryname="qAdminAccts" actionstring="index.cfm?task=admin_accounts_list" querystartrow="#URL.qsr#" querymaxrows="#URL.qmr#"></td>
		</tr>
		<tr>
			<td height="18" bgcolor="#006633" class="productTitle" width="25%"><div align="center" class="style4"><font color="#FFFFFF">Employee</font></div></td>
			<td height="18" bgcolor="#006633" class="productTitle" width="30%"><div align="center" class="style4"><font color="#FFFFFF">Email</font></div></td>
			<td height="18" bgcolor="#006633" class="productTitle" width="10%"><div align="center" class="style4"><font color="#FFFFFF">Active</font></div></td>
			<td height="18" bgcolor="#006633" class="productTitle" width="15%"><div align="center" class="style4"><font color="#FFFFFF">Role</font></div></td>
			<td height="18" bgcolor="#006633" class="productTitle" width="20%"><div align="center" class="style4"><font color="#FFFFFF">Edit Account</font></div></td>
		</tr>
		<cfoutput query="qAdminAccts" maxrows="#URL.qmr#" startrow="#URL.qsr#">
			<tr<cfif qAdminAccts.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
				<td class="textsmall" align="left">#FName# #Lname#</td>
				<td class="textsmall" align="left">#EmailAddress#</td>
				<td class="textsmall" align="center"><cfif Active EQ 1>Yes<cfelse>No</cfif></td>
				<td class="textsmall" align="left">#Role#</td>
				<td class="textsmall" align="center"><a href="index.cfm?task=admin_accounts_edit&uid=#URLEncodedFormat(UserID)#">Edit</a></td>
			</tr>
		</cfoutput>
		</table>
	</td>
</tr>

</table>
