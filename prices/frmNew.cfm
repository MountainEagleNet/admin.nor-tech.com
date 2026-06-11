<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/18/2007
	Function: 		New Price List; prompt user to select the price list to copy
	Template:		frmNew.cfm
	Task:			config_pricelists_new_edit
--->
	<cfset objPriceLists = createObject("component", "admin.assets.cfcs.prices.PriceLists")>

	<cfif isDefined("URL.Validation")>
		<cfset stRecord = objPriceLists.getDataRecord()>
		<cfset stErrors = objPriceLists.getErrorRecord()>
	<cfelse>
		<cfset stRecord = structNew()>
		<cfset stErrors = structNew()>
	</cfif>	
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
		To create a new price list, you must select either one of your existing price lists or the master price list as a starting point.
		Please make your selection below.<br><br>
		
		<font color="FF0000">Please Note:</font> After clicking "Continue", this process takes a short while to run.
	</td>
</tr>
<tr><td>&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	<form action="index.cfm?task=config_pricelists_new_act&RequestTimeout=6000" method="Post" name="detailform">

	<!--- PRICE LIST TO COPY --->
	<cfif structKeyExists(stErrors, "COPYPriceListID")>
		<tr>
			<td>&nbsp;</td>
			<td valign="top" class="textmain"><font color="FF0000">&raquo; #stErrors.COPYPriceListID#</font></td>
		</tr>
	</cfif>
	<tr>
		<td valign="top" class="textmain" width="30%"><b>Price List to Copy:</b></td>
		<td valign="top" class="textmain">
		
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "MasterPriceList", 0, True)>
<!---		<cfset structInsert(SearchRecord, "UserID", objPriceLists.getSessionValue("adminuserid"), True)>	--->
			<cfset qryPriceLists = objPriceLists.searchRecords(SearchRecord, "query", "FirstName, LastName, Name")>
			<select name="COPYPriceListID" size="1">
				<option value="">- Select -</option>
				<option value="MASTERPRICELISTUUID">Master Price List</option>
				<cfloop query="qryPriceLists">
					<option value="#qryPriceLists.PriceListID#" 
						<cfif isDefined("stRecord.COPYPriceListID") AND stRecord.COPYPriceListID IS qryPriceLists.PriceListID>
							selected
						</cfif>
						> #qryPriceLists.Name# (#qryPriceLists.FirstName# #qryPriceLists.LastName#)
					</option>
				</cfloop>
			</select>
		</td>
	</tr>

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

<script language="JavaScript" type="text/JavaScript">
<!--
document.detailform['COPYPriceListID'].focus();
-->
</script>