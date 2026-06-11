<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	07/14/2006
	Function: 		Dynamic Configurator: Submit Quote Response page
	Template:		dspReceipt.cfm
	Task:			quote_submit_response
--->
<cfset objQuoteSystem = createObject("component", "admin.assets.cfcs.config.QuoteSystem")>
<cfset objSalesRep = createObject("component", "admin.assets.cfcs.SalesRep")>

<!--- Get a structure of the quote --->
<cfset strQuoteSystem = objQuoteSystem.getRecord(URL.QuoteSystemID)>

<!--- Get a structure of the sales rep --->
<cfset strSalesRep = objSalesRep.getRecordAsStruct(strQuoteSystem.SalesRepID)>

<!--- Get an array of non matching parts --->
<cfset aNonmatches = objQuoteSystem.matchParts(URL.QuoteSystemID,1)>
<cfset actualpart = 0>
<cfloop from="1" to="#arrayLen(aNonmatches)#" step="1" index="a">
	<cfif findNoCase("[NONE]", aNonmatches[a]) eq 0>
		<cfset actualpart = 1>
		<cfbreak>
	</cfif>
</cfloop>

<cfoutput>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">


	<tr><!--- Page Title --->
		<td valign="top" class="pagetitle">
			Quote <cfif URL.SentToSalesRep eq 0 AND URL.SentToCustomer eq 0 AND URL.ACCPAC eq 0>NOT </cfif>Submitted
		</td>
	</tr>
	
	<tr><td>&nbsp;</td></tr>
	<tr><td>&nbsp;</td></tr>
    
    <cfif URL.SentToSalesRep eq 0 AND URL.SentToCustomer eq 0 AND URL.ACCPAC eq 0>
        <tr>
            <td class="textmain" style="color:F00">
                You didn't check either box on the previous page, so NO quote was submitted!!
            </td>
        </tr>
        <tr><td>&nbsp;</td></tr>
    </cfif>
    
    <cfif URL.SentToSalesRep eq 1>
        <tr>
            <td class="textmain">
                Thank you! Your quote has been sent to your email address<!---, <strong>#strSalesRep.repname#</strong>--->.
            </td>
        </tr>
        <tr><td>&nbsp;</td></tr>
   	</cfif>
        
	<tr>
		<td class="textmain">
			Your quote number is: <strong><font color="0033CC">#strQuoteSystem.QuoteNumber#</font></strong>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
    
	<cfif URL.SentToCustomer eq 1>
        <tr>
            <td class="textmain">
                A copy of your quote has also been forwarded to the customer's email address.
            </td>
        </tr>
        <tr><td>&nbsp;</td></tr>
  	</cfif> 
        
	<tr>
		<td class="textmain">
			<cfif URL.ACCPAC eq 1>
				<cfif arrayLen(aNonmatches) eq 0 OR actualpart eq 0>
					The quote can now be successfully imported into ACCPAC.
				<cfelse>
					The quote can now be successfully imported into ACCPAC, but the following line items 
					do not appear in the database and were not imported: 
					<ul>
					<cfloop from="1" to="#arrayLen(aNonmatches)#" step="1" index="a">
						<cfif findNoCase("[NONE]", aNonmatches[a]) eq 0><li>#aNonmatches[a]#</li></cfif>
					</cfloop>
					</ul>
				</cfif>
				<p><b>CSV file successfully generated</b>. <a href="/assets/files/#strQuoteSystem.QuoteNumber#.csv" target="_new">Click to Download</a>.</p>
			<cfelse>
				Please remember that the quote is an estimate only. Your sales representative will contact you with exact pricing.
			</cfif>
		</td>
	</tr>

</table>
</cfoutput>