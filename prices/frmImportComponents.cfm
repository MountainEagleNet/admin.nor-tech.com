<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/18/2007
	Function: 		Import Components from ACCPAC
					When an administrator clicks this link on the left nav bar of the administration site, the following action 
					takes place.  All parts that are marked as “configurable” in ACCPAC are imported into all price lists, including 
					the master price list.  For each component, if the component is already represented in the price list, it is 
					ignored and not imported.  Otherwise, it is imported and left in the unchecked state.  Sales reps will then need 
					to go into each price list to check the box and activate them.
					
	Template:		frmImportComponents.cfm
	Task:			config_pricelists_import_edit
--->
	<cfset objPriceLists = createObject("component", "admin.assets.cfcs.prices.PriceLists")>
</cfsilent>


<cfif isDefined("URL.Validation")>
	<cfset stRecord = objPriceLists.getDataRecord()>
	<cfset stErrors = objPriceLists.getErrorRecord()>
<cfelse>
	<cfset stRecord = structNew()>
	<cfset stErrors = structNew()>
</cfif>


<cfoutput>

<!---
		<cfset objPriceListComponents = createObject("component", "admin.assets.cfcs.prices.PriceListComponents")>
		<cfset qryPriceListComponents = objPriceListComponents.listRecords()>
		qryPriceListComponents.RecordCount:#qryPriceListComponents.RecordCount#<br>

		<cfset objConfigComponents = createObject("component", "admin.assets.cfcs.config.ConfigComponents")>
		<cfset qryConfigComponents = objConfigComponents.listRecords()>
		qryConfigComponents.RecordCount:#qryConfigComponents.RecordCount#<br>
--->

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objPriceLists.getMessage()#</font></td>
</tr>
<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr><!--- Instructions --->
	<td valign="top" class="textmain">
		This function imports parts from ACCPAC into price lists as follows:<br><br>
		
		If you enter an item number below, it will try to import that part into all price lists.  If you leave the item number blank,
		all parts that are marked as "configurable" (or "web-ready") in ACCPAC are imported into all price lists, including the 
		master price list. <br>
<!---        
		<font color="FF0000"><em><strong>PLEASE NOTE:</strong></em></font> Leaving the Item Number blank and running the import process
		for all items should only be done after hours, as this process drains system resources.		
		<br><br>
--->		
		For each component, if the component is already represented in the price list, it is ignored and not 
		imported.  Otherwise, it is imported and left in the unchecked state.  Sales reps will then need to go into each price list 
		to check the box and activate them.<br><br>
		
		Additionally, if a part has been made "not-configurable" in ACCPAC (by setting the "web-ready" field to NO), then that part will 
		be removed from all price lists and all configurations.<br><br>
		
		<font color="FF0000">Note:</font> This process will take quite a while to run.  Click the "Continue" button only once.
	</td>
</tr>
<tr><td>&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	<form action="index.cfm?task=config_pricelists_import_act&RequestTimeout=12000" method="Post" name="detailform">

	<tr>
		<td valign="top" align="center">
			<table cellpadding="4" cellspacing="0" border="0" width="90%">
				<tr><td>&nbsp;</td></tr>

				<cfif structKeyExists(stErrors, "ITEMNO")>
                    <tr>
                        <td colspan="2" valign="bottom" class="textmain"><font color="FF0000">&raquo; #stErrors.ITEMNO#</font></td>
                    </tr>
                </cfif>

				<tr>
					<!--- ITEM NUMBER --->
					<td align="left" class="textmain" valign="middle">
						Item Number: <input name="ITEMNO" size="20" maxlength="50">
					</td>

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

<script language="JavaScript" type="text/JavaScript">
<!--
document.detailform['ITEMNO'].focus();document.detailform['ITEMNO'].select()
-->
</script>