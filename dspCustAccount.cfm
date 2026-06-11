<cfsilent>
	<!---
	Coded By: Alternative Systems, Inc - Ron Barth
	Create Date: 9/26/2005
	Edit Date: 
	Function: Allows viewing of a customer account
	dspCustAccount.cfm 
	--->
	<cfset objCust = createObject("component", "admin.assets.cfcs.Cust")>
	<cfset objSalesRep = createObject("component", "admin.assets.cfcs.SalesRep")>
	<cfset objResellerSystems = createObject("component", "admin.assets.cfcs.config.ResellerSystems")>
	<cfset objPriceLists = createObject("component", "admin.assets.cfcs.prices.PriceLists")>
	
	<cfset stRecord = objCust.getRecordAsStruct(URL.uid)>
	<cfset strSalesRep = objSalesRep.getRecordAsStruct(stRecord.salesrepID)>
</cfsilent>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Display Message --->
	<td valign="top" class="textmain" colspan="2"><font color="FF0000">#objResellerSystems.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall" colspan="2">&nbsp;</td></tr>

<cfif NOT isDefined("URL.JustAddedNewCustomer")>
	<!--- CUSTOMER ORDERS --->
	<tr>
		<td class="textmain" align="right" colspan="2">
            <a href="index.cfm?task=admin_orders_lstOrders&AcctNo=#URLEncodedFormat(stRecord.AcctNo)#">
                <strong>Customer Orders</strong>
            </a>
		</td>
	</tr>
</cfif>

<tr>
	<td class="textmain" align="left" width="35%"><strong>Account number:</strong></td>
	<td class="textmain" align="left">#stRecord.AcctNo#</td>
</tr>
<tr>
	<td class="textmain" align="left"><strong>Company:</strong></td>
	<td class="textmain" align="left">#stRecord.Company#</td>
</tr>
<tr>
	<td class="textmain" align="left"><strong>First name:</strong></td>
	<td class="textmain" align="left">#stRecord.FirstName#</td>
</tr>
<tr>
	<td class="textmain" align="left"><strong>Last name:</strong></td>
	<td class="textmain" align="left">#stRecord.LastName#</td>
</tr>
<tr>
	<td class="textmain" align="left"><strong>Email address / Username:</strong></td>
	<td class="textmain" align="left">#stRecord.Email#</td>
</tr>

	<!---<strong>Username:</strong>			#stRecord.Username#--->
	
<tr>
	<td class="textmain" align="left"><strong>Password:</strong></td>
	<td class="textmain" align="left">*****<!--- #stRecord.Passcode# ---></td>
</tr>
<tr>
	<td class="textmain" align="left"><strong>SalesRep:</strong></td>
	<td class="textmain" align="left">#strSalesRep.repname#</td>
</tr>


<!--- 7/20/06: The new configurator is not using the old "points" system, therefore I'm removing this code. -Ron Barth --->
<!---
	<strong>Points system:</strong>		#stRecord.PointsSystem#
	<strong>Points notebook:</strong>	#stRecord.PointsNotebook#
	<strong>Points sever:</strong>		#stRecord.PointsServer#
--->

<!---
<tr>
	<td class="textmain" align="left"><strong>Access level:</strong></td>
	<td class="textmain" align="left">#stRecord.AccessLevel#</td>
</tr>
--->
<tr>
	<td class="textmain" align="left"><strong>Access level:</strong></td>
	<td class="textmain" align="left">#stRecord.AccessLevelNew#</td>
</tr>

<cfset strPriceList = objPriceLists.getRecord(stRecord.PriceListID)>
<tr>
	<td class="textmain" align="left"><strong>Price List:</strong></td>
	<td class="textmain" align="left">
		<cfif stRecord.PriceListID IS "" or NOT structKeyExists(strPriceList, "Name")>
			[none]
		<cfelse>
			#strPriceList.Name#
		</cfif>
	</td>
</tr>

<tr><td>&nbsp;</td></tr>
<tr>
	<td class="textmain" align="left" colspan="2">
		<strong>Access price list and parts ordering?</strong>&nbsp;&nbsp; 
		#yesNoFormat(stRecord.PriceListAccess)#
	</td>
</tr>
<tr>
	<td class="textmain" align="left" colspan="2">
		<strong>Has access to "Nor-Tech Closeout Specials"?</strong>&nbsp;&nbsp;
		#yesNoFormat(stRecord.GarageSaleAccess)#
	</td>
</tr>
<tr>
	<td class="textmain" align="left" colspan="2">
		<strong>Is this Account Active?</strong>&nbsp;&nbsp;  #yesNoFormat(stRecord.Active)#
	</td>
</tr>
<tr>
	<td class="textmain" align="left" colspan="2">
		<strong>Send Shipment Confirmation Emails?</strong>&nbsp;&nbsp;  #yesNoFormat(stRecord.SendShipmentConfirmation)#
	</td>
</tr>
<tr>
	<td class="textmain" align="left" colspan="2">
		<strong>Date Last Email Sent:</strong>&nbsp;&nbsp; 
		<cfif stRecord.DateEmailSent IS NOT "" AND stRecord.DateEmailSent IS NOT "1/1/1900">
			#dateFormat(stRecord.DateEmailSent, 'mm/dd/yyyy')# at 
			#timeFormat(stRecord.DateEmailSent, 'h:mm tt')#
		<cfelse>
			Never
		</cfif>
	</td>
</tr>
<tr>
	<td class="textmain" align="left" colspan="2">
		<strong>Display "(shipping and tax not included)" on configurator?</strong>&nbsp;&nbsp;  #yesNoFormat(stRecord.ShippingAndTax)#
	</td>
</tr>
<tr>
	<td class="textmain" align="left" colspan="2">
		<strong>Uses UPS Freight Calculator on configurator?</strong>&nbsp;&nbsp;  #yesNoFormat(stRecord.FreightEstimator)#
	</td>
</tr>
<tr>
	<td class="textmain" align="left" colspan="2">
		<strong>Uses classifications on configurator?</strong>&nbsp;&nbsp;  #yesNoFormat(stRecord.UseClassifications)#
	</td>
</tr>
<tr><td>&nbsp;</td></tr>

<tr>
	<td class="textmain" align="left" colspan="2"><strong>Assigned Systems:</strong></td>
</tr>

<cfset qryResellerSystems = objResellerSystems.listRecordsForParent("CustomerID", stRecord.CustomerID)>
<cfquery dbtype="query" name="qryResellerSystems">
SELECT * FROM qryResellerSystems
ORDER BY SystemType, SystemName
</cfquery>

<tr>
<td valign="top" class="textmain" colspan="2">
	<table cellpadding="2" cellspacing="0" width="100%" border="0">

	<!--- LIST HEADINGS --->
	<tr>
		<td height="18" bgcolor="006633" class="productTitle" width="25%"><font color="FFFFFF">System Type</font></td>
		<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">System Name</font></td>
	</tr>
	
	<!--- DATA --->
	<cfif qryResellerSystems.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="2" class="productTitle"><font color="FF0000">There are no systems assigned to this reseller.</font></td>
		</tr>
	</cfif>

	<cfloop query="qryResellerSystems">
		<cfif trim(qryResellerSystems.SystemType) IS NOT "" AND trim(qryResellerSystems.SystemName) IS NOT "">
			<tr>
			<td class="textsmall">#qryResellerSystems.SystemType#</td>
			<td class="textsmall">#qryResellerSystems.SystemName#</td>
			</tr>
		</cfif>
	</cfloop>

	</table>
</td>
</tr>

<tr><td>&nbsp;</td></tr>

</table>
</cfoutput>