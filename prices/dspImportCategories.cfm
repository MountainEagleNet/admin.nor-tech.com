<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/01/2007
	Function: 		Import Category Descriptions from ACCPAC, Display Page
	Template:		dspImportCategories.cfm
	Task:			config_pricelists_import_categories_view
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
		The Category Description Import Process has completed successfully!
	</td>
</tr>
<tr><td>&nbsp;</td></tr>

</table>
</cfoutput>