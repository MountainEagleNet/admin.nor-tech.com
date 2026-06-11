<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/05/2008
	Function: 		Remove parts from Price Lists that aren’t web-enabled in ACCPAC, Display Page
	Template:		dspWebDisabled.cfm
	Task:			config_pricelists_webdisabled_view
--->
	<cfset objPriceLists = createObject("component", "admin.assets.cfcs.prices.PriceLists")>
</cfsilent>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objPriceLists.getMessage()#</font></td>
</tr>
<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr><!--- Instructions --->
	<td valign="top" class="textmain">
		The process of removing item '#trim(URL.ITEMNO)#' from Price Lists and Confingurations has completed successfully!
	</td>
</tr>
<tr><td>&nbsp;</td></tr>

</table>
</cfoutput>