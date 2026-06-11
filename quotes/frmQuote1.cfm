<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/28/2008
	Function: 		This page prompts the user to enter a Customer Number
	Template:		frmQuote1.cfm
	Task:			quotes_new1
--->
<!---<cfset objOEORDH = createObject("component", "admin.assets.cfcs.OEORDH")>	--->
	<cfset objLogin = createObject("component", "admin.assets.cfcs.Cust")>
	<cfset objQuoteSystem = createObject("component", "admin.assets.cfcs.config.QuoteSystem")>
</cfsilent>

<!---
<cfif isDefined("URL.CreateQuoteFromScratch")>
	<cfset objLogin.setSessionValue("CreateQuoteINVUNIQ", "")>
</cfif>
--->

<cfparam name="URL.INVUNIQ" default="">
<cfparam name="URL.CopyingQuote" default="0">
<cfparam name="URL.Cpyx" default="0">
<cfparam name="URL.QuoteSystemID" default="">

<cfset strQuoteScreen3 = structNew()>
<cfset strQuoteScreen4 = structNew()>
<cfset strQuoteScreen5 = structNew()>

<cfset objLogin.setSessionValue("QuoteScreen3", strQuoteScreen3)>
<cfset objLogin.setSessionValue("QuoteScreen4", strQuoteScreen4)>
<cfset objLogin.setSessionValue("QuoteScreen5", strQuoteScreen5)>

<cfif isDefined("URL.acctno")>
	<cfset acctno = URL.acctno>
<cfelseif URL.CopyingQuote>
	<cfset acctno = objQuoteSystem.getAcctno(URL.QuoteSystemID)>
<cfelse>
	<cfset acctno = "">
</cfif>

<cfif isDefined("URL.company")>
	<cfset company = URL.company>
<cfelseif URL.CopyingQuote>
	<cfset company = objQuoteSystem.getCompany(URL.QuoteSystemID)>
<cfelse>
	<cfset company = "">
</cfif>


<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<tr><!--- Display Message --->
	<td valign="top" class="textmain" colspan="2"><font color="FF0000">#objLogin.getMessage()#</font></td>
</tr>
<tr><!--- Instructions --->
    <td valign="top" class="textmain" colspan="2">
        Identify the customer you are <cfif URL.CopyingQuote>copying<cfelse>creating</cfif> this quote for by entering information in either of the fields below and clicking "Continue".
    </td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<form name="CustomerNumberSearch" action="index.cfm?task=quotes_new1_act&RequestTimeout=6000" method="post">
<input type="hidden" name="INVUNIQ" value="#URL.INVUNIQ#">
<input type="hidden" name="QuoteSystemID" value="#URL.QuoteSystemID#">
<input type="hidden" name="CopyingQuote" value="#URL.CopyingQuote#">
<input type="hidden" name="Cpyx" value="#URL.Cpyx#">
	<tr>
		<td class="textmain" align="left" width="25%">
			<strong>Customer Number:</strong>
		</td>
		<td class="textmain" align="left">
			<input name="acctno" size="20" maxlength="50" value="#acctno#">
		</td>
	</tr>                  

	<tr>
		<td class="textmain" align="left">
			<strong>Customer Name:</strong>
		</td>
		<td class="textmain" align="left">
			<input name="company" size="20" maxlength="50" value="#company#">
		</td>
	</tr>
    <tr>
    	<td>&nbsp;</td>
    	<td>
			<input type="submit" name="Continue" value="Continue">
		</td>
	</tr>
</form>
<cfif isDefined("URL.Error")>
	<tr>
		<td class="textmain" align="left" colspan="2">
			<font color="FF0000">
				<cfif URL.Error IS "Blank">
					Please enter a Customer Number or part of the Customer Name before clicking "Continue".
				<cfelseif URL.Error IS "NotFound">
                	<cfif URL.acctno IS NOT "" AND URL.company IS NOT "">
                    	A customer was not found that matches your criteria.  Please try again.
                	<cfelseif URL.acctno IS NOT "">
						Customer Number <cfif isDefined("URL.acctno")>'#URL.acctno#'</cfif> was not found.
					<cfelseif URL.company IS NOT "">
						Customer <cfif isDefined("URL.company")>'#URL.company#'</cfif> was not found.
                    <cfelse>
						Customer was not found.
					</cfif>
<!---
				<cfelseif URL.Error IS "MultipleFound">
					Multiple matches were found for Customer Number <cfif isDefined("URL.acctno")>'#URL.acctno#'</cfif>.
--->
				</cfif>
			</font>
		</td>
	</tr>
</cfif>

<tr><td class="textsmall">&nbsp;</td></tr>
</cfoutput>

<cfif isDefined("URL.MultipleFound")>
	<cfset qryLoginAccounts = objLogin.getSessionValue("qryLoginAccounts")>
	<cfset Variables.UserID = objLogin.getSessionValue("adminuserid")>    
	<tr>
		<td class="textmain" align="left" colspan="2">
			<font color="FF0000">
            	More than one customer was found for the criteria you entered.<br />Pick the one that you want by clicking [SELECT]:
            </font>
		</td>
	</tr>                    

    <tr>
    	<td colspan="2">
        	<table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
                <tr>
                    <td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Company</font></td>
                    <td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Account</font></td>
                    <td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Name</font></td>
                    <td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Email</font></td>
                    <td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">&nbsp;</font></td>
                </tr>
                <cfoutput query="qryLoginAccounts" startrow="1" maxrows="20">
                    <tr<cfif qryLoginAccounts.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
                        <td class="textsmall">#qryLoginAccounts.company#</td>
                        <td class="textsmall">#qryLoginAccounts.acctno#</td>
                        <td class="textsmall">#qryLoginAccounts.FirstName# #qryLoginAccounts.LastName#</td>
                        <td class="textsmall">#qryLoginAccounts.Email#</td>
                        <td class="textsmall">
							<a href="index.cfm?task=quotes_new2&UserID=#urlEncodedFormat(Variables.UserID)#&CustomerID=#urlEncodedFormat(qryLoginAccounts.CustomerID)#&INVUNIQ=#urlEncodedFormat(URL.INVUNIQ)#&CopyingQuote=#URL.CopyingQuote#&Cpyx=#URL.Cpyx#&QuoteSystemID=#urlEncodedFormat(URL.QuoteSystemID)#">
                                [SELECT]
                            </a>
                        </td>
                    </tr>
                </cfoutput>
			</table>
        </td>
    </tr>

</cfif>

</table>

<cfif NOT URL.CopyingQuote OR isDefined("URL.acctno")>
	<script language="JavaScript" type="text/JavaScript">
    <!--
    document.CustomerNumberSearch['acctno'].focus();document.CustomerNumberSearch['acctno'].select()
    -->
    </script>
</cfif>