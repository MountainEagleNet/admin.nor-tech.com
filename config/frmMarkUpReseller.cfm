<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/13/2006
	Function: 		This page displays a form for entering reseller markup percentages and fixed prices
	Template:		frmMarkUpReseller.cfm	
	Task:			config_setup_markupreseller_edit
--->
<!---
<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>
<cfset objConfigComponentCategories = createObject("component", "admin.assets.cfcs.config.ConfigComponentCategories")>
--->
<cfset objConfigComponents = createObject("component", "admin.assets.cfcs.config.ConfigComponents")>
<cfset objConfigComponentsResellers = createObject("component", "admin.assets.cfcs.config.ConfigComponentsResellers")>

<cfif isDefined("URL.Validation")>
	<cfset stRecord = objConfigComponents.getDataRecord()>
	<cfset stErrors = objConfigComponents.getErrorRecord()>
<!---<cfset Variables.ConfigSystemID = stRecord.ConfigSystemID>--->
<cfelse>
<!---	
	<cfset Variables.ConfigSystemID = URL.ConfigSystemID>
	<cfset stRecord = objConfigSystems.getRecord(Variables.ConfigSystemID, "struct")>
--->	
	<cfset stRecord = structNew()>
	<cfset structInsert(stRecord, "ConfigComponentID", URL.ConfigComponentID, True)>
	<cfset stErrors = structNew()>
</cfif>	

<cfset strConfigComponent = objConfigComponents.getRecord(stRecord.ConfigComponentID)>

<cfset qryConfigComponentsResellers = objConfigComponentsResellers.listRecordsForParent("ConfigComponentID", stRecord.ConfigComponentID, "CustCompany")>

<!---
stRecord:<cfdump var="#stRecord#">
stErrors:<cfdump var="#stErrors#">
--->

<script language="javascript">
	function openWindow(url_string, width, height)	{
		var options = "scrollbars=1,resizable=1,height="+height+",width="+width;
		new_window = window.open(url_string, "newwin", options );
		return false;
	}	
	function confirmDelete() {
		var msg = "Are you sure you would like to delete this record?";
		if(confirm(msg)) { return true; }
		else { return false; }
	}
</script>


<cfoutput>

<!---<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">--->
<table width="575" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">Reseller Markup Information</td>
	<td valign="top" class="textsmall" align="right">
		<a href="javascript:void(0)" onclick="openWindow('config/markupHelpSystems.cfm',450,300)" class="textsmall">Click Here for Help</a>
	</td>
</tr>
<tr><!--- Link back to Markup % Page --->
	<td valign="top" class="textsmall" colspan="2" align="right">
		<a href="index.cfm?task=config_setup_markup_edit&ConfigSystemID=#urlEncodedFormat(strConfigComponent.ConfigSystemID)#">
			Back to Markup % Page
		</a>
	</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain" colspan="2"><font color="FF0000">#objConfigComponents.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall" colspan="2">&nbsp;</td></tr>

<tr>
	<td colspan="2">	
		<table cellpadding="2" cellspacing="0" width="100%" border="0">
			<tr>
				<td valign="middle" class="textmain" width="30%"><b>System Name:</b></td>
				<td valign="top" class="textmain">#strConfigComponent.SystemName#</td>
			</tr>
			<tr>
				<td valign="middle" class="textmain"><b>Component Category:</b></td>
				<td valign="top" class="textmain">#strConfigComponent.CategoryName#</td>
			</tr>
			<tr>
				<td valign="middle" class="textmain"><b>Component:</b></td>
				<td valign="top" class="textmain">#objConfigComponents.getItemDescription(strConfigComponent.ITEMNO)#</td>
			</tr>
		</table>
	</td>
</tr>

<tr>
<td valign="top" class="textmain" colspan="2">
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	<form action="index.cfm?task=config_setup_markupreseller_save" method="Post" name="detailform">
	<input type="hidden" name="ConfigComponentID" value="#stRecord.ConfigComponentID#">
	<cfset TabValue = 1>
	
	<!--- LIST HEADINGS --->
	<tr>
		<td height="18" bgcolor="006633" class="productTitle" width="40%"><font color="FFFFFF">Reseller</font></td>
		<td height="18" bgcolor="006633" class="productTitle" width="15%" align="right"><font color="FFFFFF">Markup %</font></td>
		<td height="18" bgcolor="006633" class="productTitle" width="15%" align="right"><font color="FFFFFF">Fixed Price</font></td>
		<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">&nbsp;</font></td>
	</tr>

	<!--- DATA --->
	<cfif qryConfigComponentsResellers.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="4" class="productTitle"><font color="FF0000">There are no resellers currently assigned to this component.</font></td>
		</tr>
	</cfif>

	<!--- Resellers --->
	<cfloop query="qryConfigComponentsResellers">
		<tr<cfif qryConfigComponentsResellers.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
			<td class="textsmall">#qryConfigComponentsResellers.CustCompany#</td>
			<td class="textsmall" align="right">
				<cfif qryConfigComponentsResellers.MarkupPercentage IS NOT "">
					#qryConfigComponentsResellers.MarkupPercentage#%
				</cfif>
			</td>
			<td class="textsmall" align="right">
				<cfif isNumeric(qryConfigComponentsResellers.FixedPrice) AND qryConfigComponentsResellers.FixedPrice GT 0>
					#dollarFormat(qryConfigComponentsResellers.FixedPrice)#
				</cfif>
			</td>
			<td class="textsmall" align="center">
				<a href="index.cfm?task=config_setup_markupreseller_delete&ConfigComponentsResellersID=#urlEncodedFormat(qryConfigComponentsResellers.ConfigComponentsResellersID)#" onclick="return confirmDelete()">
					[delete]
				</a>
			</td>
		</tr>
	</cfloop>
	
	<tr><td colspan="4">&nbsp;</td></tr>


	<cfset qryResellers = objConfigComponentsResellers.listResellers(stRecord.ConfigComponentID)>
	<cfif qryResellers.RecordCount GT 0>
		<tr>
			<td class="textsmall" colspan="4">Add a New Reseller:</td>
		</tr>
	
		<cfif NOT structIsEmpty(stErrors)>
			<tr>
				<td valign="bottom" class="textmain">
					<font color="FF0000">
						<cfif structKeyExists(stErrors, "CustomerID")>
							&raquo; #stErrors.CustomerID#
						<cfelse>
							&nbsp;
						</cfif>
					</font>
				</td>
				<td valign="top" class="textmain" valign="bottom" colspan="3">
					<font color="FF0000">
						<cfif structKeyExists(stErrors, "MarkupFixed")>
							&raquo; #stErrors.MarkupFixed#
						<cfelse>
							<cfif structKeyExists(stErrors, "MarkupPercentage")>
								&raquo; #stErrors.MarkupPercentage#
							</cfif>
							<cfif structKeyExists(stErrors, "FixedPrice")>
								&raquo; #stErrors.FixedPrice#
							</cfif>
						</cfif>
					</font>
				</td>
			</tr>
		</cfif>
		
		<tr>
			<td class="textsmall">
				<select name="CustomerID" size="1" tabindex="#TabValue#">
					<option value="">- Select -</option>
					<cfloop query="qryResellers">
						<option value="#qryResellers.CustomerID#" 
							<cfif structKeyExists(stRecord, "CustomerID") AND stRecord.CustomerID IS qryResellers.CustomerID>
								selected
							</cfif>
							> #qryResellers.company#
						</option>
					</cfloop>
				</select>
				<cfset TabValue = TabValue + 1>
			</td>
			
			<td class="textsmall">
				<input name="MarkupPercentage" size="2" maxlength="50" tabindex="#TabValue#" 
					<cfif structKeyExists(stRecord, "MarkupPercentage")>
						value="#stRecord.MarkupPercentage#" 
					</cfif>
					<cfif structKeyExists(stErrors, "MarkupPercentage")>style="border:1px solid red;"</cfif>
				>%
				<cfset TabValue = TabValue + 1>
			</td>
	
			<td class="textsmall">
				$<input name="FixedPrice" size="2" maxlength="50" tabindex="#TabValue#" 
					<cfif structKeyExists(stRecord, "FixedPrice")>
						value="#stRecord.FixedPrice#" 
					</cfif>
					<cfif structKeyExists(stErrors, "FixedPrice")>style="border:1px solid red;"</cfif>
				>
				<cfset TabValue = TabValue + 1>
			</td>
			<td align="center"><!--- "ADD" BUTTON --->
				<input type="submit" name="ButtonClicked" value="Add" tabindex="#TabValue#">
			</td>
			
		</tr>
	</cfif>
	</form>
	</table>
</td>
</tr>
</table>
</cfoutput>