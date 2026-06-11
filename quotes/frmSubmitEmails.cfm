<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/15/2007
	Function: 		Select Email Addresses Form
	Template:		frmSubmitEmails.cfm
	Task:			quote_submit_selectEmails
--->


<cfset objQuoteSystem = createObject("component", "admin.assets.cfcs.config.QuoteSystem")>
<cfset objCust = createObject("component", "admin.assets.cfcs.Cust")>
<cfset objSalesRep = createObject("component", "admin.assets.cfcs.SalesRep")>
<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>

<cfset stFormCopy = duplicate(FORM)>

<cfif isDefined("URL.Validation")>
	<cfset stRecord = objQuoteSystem.getDataRecord()>
	<cfset stErrors = objQuoteSystem.getErrorRecord()>
<cfelse>
	<cfset stRecord = structNew()>
	<cfset stErrors = structNew()>
	<cfset structInsert(stRecord, "QuoteSystemID", stFormCopy.QuoteSystemID, True)>
</cfif>

<cfset strQuoteSystem = objQuoteSystem.getRecord(stRecord.QuoteSystemID)>

<cfset strReseller = objCust.getLoginRecord(strQuoteSystem.CustomerID)>
<cfset ResellerEmailAddress = strReseller.email>

<cfset qrySalesRep = objSalesRep.getRecordAsQuery(objQuoteSystem.getSessionValue("salesrepid"))>
<cfset SalesRepEmail = qrySalesRep.repemail>

<cfoutput>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">

<tr><!--- Page Title --->
	<td valign="top" class="pagetitle">
		Email Price Quote
	</td>
</tr>

<tr>
	<td valign="top">
	<table width="100%" border="0" align="center" cellpadding="3" cellspacing="6">
		<tr>
			<!--- SYSTEM PHOTO --->
			<td align="center" valign="bottom" width="40%">
               	<cfset ImageName = objConfigSystems.getImageName3(stRecord.QuoteSystemID)>
				<cfif ImageName IS NOT "">        
					<img src="https://partners.nor-tech.com/images/systems/#ImageName#">
				</cfif>                    
			</td>
			<!--- SYSTEM NAME, TOTAL PRICE --->
			<td valign="top">
				<table width="100%" border="0" cellpadding="2" cellspacing="0">
					<tr>
						<td align="center" height="25px" class="systemName" colspan="2">
							#strQuoteSystem.SystemName#
						</td>
					</tr>
					<tr>
						<td align="right" class="textMediumBold">System Cost:</td>
						<td align="left" class="textMediumBold">#dollarFormat(strQuoteSystem.ResellerPrice)#</td>
					</tr>
					<tr>
						<td align="right" class="textMediumBold">Quantity:</td>
						<td align="left" class="textMediumBold">#strQuoteSystem.Quantity#</td>
					</tr>
					<tr>
						<td align="right" class="systemPriceLarge">Your total cost:</td>
						<td align="left" class="systemPriceLarge">#dollarFormat(strQuoteSystem.ResellerTotal)#</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	</td>
</tr>

<tr>
	<td valign="top" class="textmain">
	<table width="100%" border="0" align="center" cellpadding="5" cellspacing="1">
		<form action="index.cfm?task=quote_submit" method="Post" name="detailform">
		<input type="hidden" name="QuoteSystemID" value="#stRecord.QuoteSystemID#">
	
		<tr><td>&nbsp;</td></tr>
        <tr>
            <td colspan="2" valign="middle" class="textmain" align="center"><b>Pick the Addresses you want to send this quote to:</b></td>
        </tr>
        <tr>
           	<td width="30%">&nbsp;</td>            
			<td valign="middle" class="textmain" align="left">
                <input type="checkbox" name="SendToCustomer" value="1" checked="checked"> Customer (#ResellerEmailAddress#)
            </td>
        </tr>
        <tr>
	      	<td>&nbsp;</td>    
			<td valign="middle" class="textmain" align="left">
                <input type="checkbox" name="SendToSalesRep" value="1" checked="checked"> Sales Rep (#SalesRepEmail#)
            </td>
        </tr>
		 <tr>
	      	<td>&nbsp;</td>    
			<td valign="middle" class="textmain" align="left">
                <input type="checkbox" name="ACCPAC" value="1" checked="checked"> ACCPAC (order entry)
			</td>
        </tr>
		<tr><td>&nbsp;</td></tr>

		<!--- BUTTON --->
		<tr>
			<td valign="middle" align="center" class="textsmall" colspan="2">
                <input name="" type="image" src="https://partners.nor-tech.com/images/submitQuote.gif" alt="Order" width="100" height="28">
           	</td>
		</tr>
		
		<tr><td>&nbsp;</td></tr>
		</form>
	</table>
	</td>
</tr>

</table>
</cfoutput>