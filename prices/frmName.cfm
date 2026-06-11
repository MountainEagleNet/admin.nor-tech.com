<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/18/2007
	Function: 		First page in the price list edit wizard: Name
	Template:		frmName.cfm	
	Task:			config_pricelists_name_edit
--->
<cfset objPriceLists = createObject("component", "admin.assets.cfcs.prices.PriceLists")>

<!---<cfset MasterPriceList = objPriceLists.getSessionValue("MasterPriceList")>--->

<cfif isDefined("URL.Validation")>
	<cfset stRecord = objPriceLists.getDataRecord()>
	<cfset stErrors = objPriceLists.getErrorRecord()>
<cfelse>
	<cfset stRecord = objPriceLists.getRecord(URL.PriceListID)>
	<cfset stErrors = structNew()>
</cfif>

<cfif structIsEmpty(stRecord)>
	<cfset objPriceLists.setMessage("The price list you have chosen cannot be found.  Please refresh the 'Price Lists' page.")>
	<cflocation url="index.cfm?task=config_pricelists_list">
</cfif>

<script language="javascript">
	function confirmDelete() {
		var msg = "Are you sure you want to Delete this price list?";
		if(confirm(msg)) { return true; }
		else { return false; }
	}
	function confirmExport() {
		var msg = "Are you sure you want to Export this price list?";
		if(confirm(msg)) { return true; }
		else { return false; }
	}
</script>

<cfoutput>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">
		<cfif NOT SESSION.UserOnVacation>Edit<cfelse>View</cfif> Price List
	</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objPriceLists.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="4" width="100%" border="0">
	<form action="index.cfm?task=config_pricelists_name_act&RequestTimeout=6000" method="Post" name="detailform">
	<input type="hidden" name="PriceListID" value="#stRecord.PriceListID#">
	<input type="hidden" name="UserID" value="#stRecord.UserID#">
	<cfset TabValue = 1>

	<!--- Name --->
	<cfif structKeyExists(stErrors, "Name")>
		<tr>
			<td>&nbsp;</td>
			<td valign="bottom" class="textmain" colspan="2"><font color="FF0000">&raquo; #stErrors.Name#</font></td>
		</tr>
	</cfif>
	<tr>
		<td valign="middle" class="textmain" width="30%"><b>Price List Name:</b> *</td>
		<td valign="top" class="textmain" colspan="2">
        	<!---
			<cfif NOT SESSION.UserOnVacation>
                <input name="Name" size="48" maxlength="50" tabindex="#TabValue#" value="#stRecord.Name#" 
                    <cfif structKeyExists(stErrors, "Name")>style="border:1px solid red;"</cfif>
                >
                <cfset TabValue = TabValue + 1>
			<cfelse>
				<input type="hidden" name="Name" value="#stRecord.Name#">
                #stRecord.Name#
			</cfif>   
			--->
			<input type="hidden" name="Name" value="#stRecord.Name#">
            #stRecord.Name#             
		</td>
	</tr>

	<!--- Description --->
	<cfif structKeyExists(stErrors, "Description")>
		<tr>
			<td>&nbsp;</td>
			<td valign="bottom" class="textmain" colspan="2"><font color="FF0000">&raquo; #stErrors.Description#</font></td>
		</tr>
	</cfif>
	<tr>
		<td valign="top" class="textmain"><b>Description:</b></td>
		<td valign="top" class="textmain" colspan="2">
        	<!---
			<cfif NOT SESSION.UserOnVacation>
                <textarea name="Description" wrap="virtual" cols="50" rows="3" tabindex="#TabValue#" class="textmain" <cfif structKeyExists(stErrors, "Description")>style="border:1px solid red;"</cfif>>#stRecord.Description#</textarea>
                <cfset TabValue = TabValue + 1>
			<cfelse>
				<input type="hidden" name="Description" value="#stRecord.Description#">
                #stRecord.Description#
			</cfif>    
			--->
			<input type="hidden" name="Description" value="#stRecord.Description#">
            #stRecord.Description#            
		</td>
	</tr>

	<!--- MarkUpPercent --->
	<cfif structKeyExists(stErrors, "MarkUpPercent")>
		<tr>
			<td>&nbsp;</td>
			<td valign="bottom" class="textmain" colspan="2"><font color="FF0000">&raquo; #stErrors.MarkUpPercent#</font></td>
		</tr>
	</cfif>
	<cfif isDefined("URL.ErrorMarkupPercent")>
		<tr>
			<td>&nbsp;</td>
			<td valign="bottom" class="textmain" colspan="2">
				<font color="FF0000">
					Please enter only a Numeric value greater than or equal to zero in the Global Markup Percentage field.
				</font>
			</td>
		</tr>
	</cfif>
	<tr>
		<td valign="middle" class="textmain" width="20%"><b>Price List Global Markup Percentage:</b></td>
		<td valign="bottom" class="textmain">
        	<!---
			<cfif NOT SESSION.UserOnVacation>
                <input name="MarkUpPercent" size="5" maxlength="50" tabindex="#TabValue#" value="#stRecord.MarkUpPercent#" 
                    <cfif structKeyExists(stErrors, "MarkUpPercent")>style="border:1px solid red;"</cfif>
                > %
                <cfset TabValue = TabValue + 1>
			<cfelse>
				<input type="hidden" name="MarkUpPercent" value="#stRecord.MarkUpPercent#">
                #stRecord.MarkUpPercent# %
			</cfif>   
			--->
			<input type="hidden" name="MarkUpPercent" value="#stRecord.MarkUpPercent#">
            #stRecord.MarkUpPercent# %             
		</td>
        
		<!---
		<cfif NOT SESSION.UserOnVacation>
            <td valign="bottom" class="textsmall">
                <a href="javascript: document.detailform.submit(); void 0">
                    Update All Prices
                </a>		
            </td>
		</cfif>
		--->
	</tr>
	
	<!--- DefaultPriceList --->
	<cfif stRecord.PriceListID IS NOT "MASTERPRICELISTUUID">	
		<tr>
			<td valign="middle" class="textmain" width="20%"><b>Default Price List?</b></td>
			<td valign="top" class="textmain">
				<!---
				<cfif NOT SESSION.UserOnVacation>
                    <input type="checkbox" name="DefaultPriceList" value="1" tabindex="#TabValue#"
                        <cfif stRecord.DefaultPriceList EQ 1>
                            checked
                        </cfif>
                    >
                    <cfset TabValue = TabValue + 1>
				<cfelse>
                    <input type="hidden" name="DefaultPriceList" value="#stRecord.DefaultPriceList#">
                    #yesNoFormat(stRecord.DefaultPriceList)#
                </cfif> 
				--->
				<input type="hidden" name="DefaultPriceList" value="#stRecord.DefaultPriceList#">
                #yesNoFormat(stRecord.DefaultPriceList)#               
			</td>
		</tr>
	</cfif>

	<!--- Email Price List --->
	<cfset objSalesRep = createObject("component", "admin.assets.cfcs.SalesRep")>
	<cfset qrysalesrep = objSalesRep.getRecordAsQuery(SESSION.SalesRepID)>
	<cfif isDefined("qrysalesrep.RepEmail") AND trim(qrysalesrep.RepEmail) IS NOT "">
		<cfif NOT SESSION.UserOnVacation>
            <tr>
                <td valign="middle" class="textmain" colspan="2">&nbsp;</td>
                <td valign="top" class="textsmall">
                    <a href="index.cfm?task=admin_custaccounts_emailpricelist&PriceListID=#urlEncodedFormat(stRecord.PriceListID)#&ToAddress=#urlEncodedFormat(qrysalesrep.RepEmail)#">
                        Email Price List to #qrysalesrep.RepEmail#
                    </a>
                </td>
            </tr>
			<cfif isDefined("URL.PriceListEmailed")>
                <tr>
                    <td class="textmain" colspan="3">
                        <font color="FF0000">
                            Price List '#stRecord.Name#' was successfully emailed to '#qrysalesrep.RepEmail#'.
                        </font>
                    </td>
                </tr>
            </cfif>
    	</cfif>
	</cfif>
	
	<tr>
	<td valign="top" colspan="3" align="center">
		<table cellpadding="4" cellspacing="0" border="0" width="80%">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<!---
			<td width="30%" align="center">
				<cfif NOT SESSION.UserOnVacation AND trim(stRecord.PriceListID) IS NOT ""> 
					<input type="submit" name="ButtonClicked" value="Export Price List" onclick="return confirmExport()">
				<cfelse>&nbsp;
				</cfif>
			</td>
			<cfif NOT SESSION.UserOnVacation AND stRecord.PriceListID IS NOT "MASTERPRICELISTUUID">
				<td width="30%" align="center">
					<cfif trim(stRecord.PriceListID) IS NOT "">
						<input type="submit" name="ButtonClicked" value="Delete" onclick="return confirmDelete()">
					<cfelse>&nbsp;
					</cfif>
				</td>
			</cfif>
			--->
			<td align="right"><!--- "CONTINUE" BUTTON --->
				<input type="submit" name="ButtonClicked" value="&nbsp;Continue -&raquo;" tabindex="#TabValue#">
			</td>
		</tr>
		</table>
	</td>
	</tr>

	</form>
	</table>
</td>
</tr>


<!--- ASSIGNED RESELLER LIST --->
<cfif stRecord.PriceListID IS NOT "MASTERPRICELISTUUID" AND SESSION.Role IS NOT "Warehouse">	
	<cfset qryResellers = objPriceLists.listAssignedResellers(stRecord.PriceListID)>
	<tr>
	<td valign="top" class="textmain">
		<table cellpadding="0" cellspacing="0" width="100%" border="0">
		
		<!--- LIST HEADINGS --->
		<tr>
			<td height="18" bgcolor="006633" class="productTitle" width="50%">
				<font color="FFFFFF">
					Assigned Reseller List
				</font>
			</td>
			<td height="18" bgcolor="006633" class="productTitle" width="50%">&nbsp;</td>
		</tr>
	
		<!--- LIST DATA --->	
		<cfif qryResellers.RecordCount EQ 0>
			<tr>
				<td align="center" colspan="2" class="productTitle"><font color="FF0000">There are currently no Resellers assigned to this Price List.</font></td>
			</tr>
		</cfif>
		<cfloop query="qryResellers">
			<tr<cfif qryResellers.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
	
				<td class="textsmall">
					#qryResellers.Company#
				</td>
				<td class="textsmall">
					#qryResellers.firstname# #qryResellers.lastname#
				</td>
			</tr>
		</cfloop>
		</table>
	</td>
	</tr>
	
	<tr><td class="textsmall"><hr></td></tr>
	<tr><td class="textsmall">&nbsp;</td></tr>
</cfif>

</table>
</cfoutput>

<cfif structKeyExists(stErrors, "Name")>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['Name'].focus(); document.detailform['Name'].select()
	-->
	</script>
<cfelse>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['Name'].focus();
	-->
	</script>
</cfif>	