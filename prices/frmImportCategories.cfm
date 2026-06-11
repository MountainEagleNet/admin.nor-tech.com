<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/01/2007
	Function: 		Import Category Desciprions from ACCPAC
	Template:		frmImportCategories.cfm
	Task:			config_pricelists_import_categories_edit
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
		This function imports category descriptions from ACCPAC into all price lists, including the master price list.<br><br>
		
		You would generally run this after making changes to category descriptions in ACCPAC, so that category descriptions in
		the price lists could be updated appropriately.<br><br>
	
		<font color="FF0000">Please Note:</font> This process will take a short while to run.  Click the "Continue" button only once.
	</td>
</tr>
<tr><td>&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	<form action="index.cfm?task=config_pricelists_import_categories_act&RequestTimeout=6000" method="Post" name="detailform">

	<tr>
	<td valign="top" colspan="2" align="center">
		<table cellpadding="4" cellspacing="0" border="0" width="80%">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<!--- "CONTINUE" BUTTON --->
			<td align="right">
				<input type="submit" name="ButtonClicked" value="&nbsp;Continue -&raquo;">
			</td>
		</tr>
		</table>
	</td>
	</tr>

	</form>
	</table>
</td>
</tr>

</table>
</cfoutput>