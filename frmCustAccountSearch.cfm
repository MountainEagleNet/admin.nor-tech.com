<cfsilent>
	<!---
	Coded By: Alternative Systems, Inc - Nicholas Tunney
	Create Date: 7/17/2005
	Edit Date: 
	Function: Allows searchign for a customer account
	frmCustAccountSearch.cfm 
	--->
</cfsilent>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<!--- spacer --->
<tr>
	<td class="textsmall">&nbsp;</td>
</tr>
<form name="CustSearchForm" action="index.cfm?task=admin_custaccounts_list" method="post">
	<tr>
		<td class="textmain" align="left">
			<strong>Account Number:</strong><br>
			<input name="AcctNo" size="20" maxlength="50"><br><br>
			<strong>Company Name:</strong><br>
			<input name="Company" size="20" maxlength="50"><br><br>
			<strong>First Name:</strong><br>
			<input name="FirstName" size="20" maxlength="50"><br><br>
			<strong>Last Name:</strong><br>
			<input name="LastName" size="20" maxlength="50"><br><br>
			<strong>Email Address:</strong><br>
			<input name="Email" size="20" maxlength="50"><br><br>
			<input type="submit" name="ProcessSearch" value="Search Customers">
		</td>
	</tr>
</form>
</table>
