<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/18/2007
	Function: 		Import Components from ACCPAC, Display Page
					
	Template:		dspImportComponents.cfm
	Task:			config_pricelists_import_view
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
		The Import Process has completed successfully!
		
		<cfif isDefined("URL.ImportCount") AND isNumeric(URL.ImportCount)>
			<cfif URL.ImportCount EQ 0>
				<br><br>
				No items were imported; either the item number that you entered was not found in ACCPAC, or all price lists are 
				already up to date (and the item didn't need to be imported).
			<cfelseif URL.ImportCount EQ 1>
				<br><br>
				One item was imported from ACCPAC.
			<cfelse>
				<br><br>
				#URL.ImportCount# items were imported from ACCPAC.
			</cfif>
		
		</cfif>
	</td>
</tr>
<tr><td>&nbsp;</td></tr>

</table>
</cfoutput>