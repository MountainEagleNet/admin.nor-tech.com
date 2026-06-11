<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	07/10/2006
	Function: 		Dynamic Configurator: Response page
	Template:		dspReceipt.cfm
	Task:			config_dyn_receipt
--->
<cfset objQuoteSystem = createObject("component", "admin.assets.cfcs.config.QuoteSystem")>
<cfset objSalesRep = createObject("component", "admin.assets.cfcs.SalesRep")>

<!--- Get a structure of the quote --->
<cfset strQuoteSystem = objQuoteSystem.getRecord(URL.QuoteSystemID)>

<!--- Get a structure of the sales rep --->
<cfset strSalesRep = objSalesRep.getRecordAsStruct(strQuoteSystem.SalesRepID)>

<cfoutput>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">

	<tr><!--- Page Title --->
		<td valign="top" class="pagetitle">
			Quote Submitted
		</td>
	</tr>
	
	<tr><td>&nbsp;</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td class="textmain">
			<cfif isDefined("URL.QuoteSubmitted") AND URL.QuoteSubmitted EQ 1>
				Thank you! Your quote has been sent to <strong>#strSalesRep.repname#</strong>.
			<cfelseif isDefined("URL.QuoteEmailed") AND URL.QuoteEmailed EQ 1>
				Thank you! Your quote has been saved and emailed to the address you entered: #URL.EmailAddressForQuote#.  You may submit your quote at another time by accessing the quote from the "View Quotes" section and clicking "Submit Quote".
			<cfelse>
				Thank you! Your quote has been saved.  You may submit your quote at another time by accessing the quote from the "View Quotes" section and clicking "Submit Quote".
			</cfif>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	
	<tr>
		<td class="textmain">
			Your quote number is: <strong><font color="0033CC">#strQuoteSystem.QuoteNumber#</font></strong>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	
	<cfif isDefined("URL.QuoteSubmitted") AND URL.QuoteSubmitted EQ 1>
		<tr>
			<td class="textmain">
				A copy of your quote has also been forwarded to your email address.
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	</cfif>
	
	<tr>
		<td class="textmain">
			<cfif isDefined("URL.QuoteSubmitted") AND URL.QuoteSubmitted EQ 1>
				Please remember that the quote is an estimate only. Your sales representative will contact you with exact pricing.
			<cfelse>
				Please remember that the quote is an estimate only. When you submit the quote your sales representative will contact you with exact pricing.
			</cfif>
		</td>
	</tr>

</table>
</cfoutput>