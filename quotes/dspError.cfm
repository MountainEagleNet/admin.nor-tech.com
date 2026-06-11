<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	11/06/2008
	Function: 		Error Page
	Template:		dspError.cfm
	Task:			quotes_error
--->
<cfset objQuoteSystem = createObject("component", "admin.assets.cfcs.config.QuoteSystem")>

<!--- Get a structure of the quote --->
<cfset strQuoteSystem = objQuoteSystem.getRecord(URL.QuoteSystemID)>

<cfoutput>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">

	<tr><!--- Page Title --->
		<td valign="top" class="pagetitle">
			Quote Update Warning
		</td>
	</tr>
	
	<tr><td>&nbsp;</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td class="textmain" style="color:FF0000; font-style:italic">
			Sorry, you can’t update quote #strQuoteSystem.QuoteNumber# because system '#strQuoteSystem.SystemName#' no longer exists.
		</td>
	</tr>

	<tr><td>&nbsp;</td></tr>
	<tr>
		<td class="textmain">
			<a href="index.cfm?task=quotes_list">Click here</a> to go back to your list of quotes.
		</td>
	</tr>
	
</table>
</cfoutput>