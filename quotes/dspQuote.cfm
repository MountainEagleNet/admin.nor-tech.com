<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/28/2008
	Function: 		Response Page
	Template:		dspQuote.cfm
	Task:			quotes_view
--->
</cfsilent>

<cfset objQuoteSystem = createObject("component", "admin.assets.cfcs.config.QuoteSystem")>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objQuoteSystem.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr><td class="textsmall">&nbsp;</td></tr>

</table>
</cfoutput>