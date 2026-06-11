<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/15/2007
	Function: 		Dynamic Configurator: Email Quote Form
	Template:		frmEmailQuote.cfm
	Task:			config_dyn_email_form
--->

<cfset objQuoteSystem = createObject("component", "admin.assets.cfcs.config.QuoteSystem")>

<cfif isDefined("URL.Validation")>
	<cfset stRecord = objQuoteSystem.getDataRecord()>
	<cfset stErrors = objQuoteSystem.getErrorRecord()>
<cfelse>
	<cfset stRecord = structNew()>
	<cfset stErrors = structNew()>
	<cfset structInsert(stRecord, "QuoteSystemID", URL.QuoteSystemID, True)>
</cfif>

<cfset strQuoteSystem = objQuoteSystem.getRecord(stRecord.QuoteSystemID)>

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
				<img src="https://partners.nor-tech.com/images/systems/#strQuoteSystem.SystemPhoto#">
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
		<form action="index.cfm?task=config_dyn_email_act" method="Post" name="detailform">
		<input type="hidden" name="QuoteSystemID" value="#stRecord.QuoteSystemID#">
	
		<cfset TabValue = 1>

		<!--- TITLE --->
		<tr>
			<td width="50%" valign="middle" align="right" class="systemCategory">
				Enter a Title for this quote (optional):
			</td>
			<td valign="middle" align="left" class="textsmall">
				<input name="QuoteTitle" size="50" maxlength="50"
					<cfif isDefined("stRecord.QuoteTitle")>
						value="#stRecord.QuoteTitle#"
					</cfif>
				tabindex="#TabValue#" class="textsmall">
				<cfset TabValue = TabValue + 1>
			</td>
		</tr>
	
		<!--- EMAIL ADDRESS --->
		<cfif isDefined("stErrors.EmailAddressForQuote")>
			<tr>
				<td>&nbsp;</td>
				<td valign="bottom" class="textsmall" colspan="2" class="textmain">
					<font color="FF0000">&raquo; #stErrors.EmailAddressForQuote#</font>
				</td>
			</tr>
		</cfif>
		<tr>
			<td valign="middle" align="right" class="systemCategory">
				Enter Email Address to send this quote to:
			</td>
			<td valign="middle" align="left" class="textsmall">
				<input name="EmailAddressForQuote" size="50" maxlength="50" 
					<cfif isDefined("stRecord.EmailAddressForQuote")>
						value="#stRecord.EmailAddressForQuote#"
					</cfif>
				tabindex="#TabValue#" class="textsmall">
				<cfset TabValue = TabValue + 1>
			</td>
		</tr>

		<!--- "FROM" EMAIL ADDRESS --->
		<cfset LoginEmail = objQuoteSystem.getSessionValue("email")>
		<cfif trim(LoginEmail) IS "" OR FindNoCase("@", LoginEmail) EQ 0 OR FindNoCase(".", LoginEmail) EQ 0>
			<cfset LoginEmail = "info@nor-tech.com">
		</cfif>
		
		<cfif isDefined("stErrors.EmailAddressFrom")>
			<tr>
				<td>&nbsp;</td>
				<td valign="bottom" class="textsmall" colspan="2" class="textmain">
					<font color="FF0000">&raquo; #stErrors.EmailAddressFrom#</font>
				</td>
			</tr>
		</cfif>
		<tr>
			<td valign="middle" align="right" class="systemCategory">
				Enter your address (which will be the email's "From" address):
			</td>
			<td valign="middle" align="left" class="textsmall">
				<input name="EmailAddressFrom" size="50" maxlength="50" 
					<cfif isDefined("stRecord.EmailAddressFrom") AND trim(stRecord.EmailAddressFrom) IS NOT "">
						value="#stRecord.EmailAddressFrom#"
					<cfelse>
						value="#LoginEmail#"
					</cfif>
				tabindex="#TabValue#" class="textsmall">
				<cfset TabValue = TabValue + 1>
			</td>
		</tr>
			
		<!--- BUTTON --->
		<tr>
			<td valign="middle" align="left" class="textsmall" colspan="2">
			<table width="50%" border="0" align="center" cellpadding="0" cellspacing="0">
				<tr>
					<!--- "EMAIL QUOTE" BUTTON --->
					<td valign="middle" align="center" class="textsmall">
						<input name="Email" type="image" value="email" src="https://partners.nor-tech.com/images/emailquote.gif" alt="email quote" border="0" tabindex="#TabValue#" width="100" height="28">
					</td>
				</tr>
			</table>
			</td>
		</tr>
		
		<tr><td>&nbsp;</td></tr>
		</form>
	</table>
	</td>
</tr>

</table>
</cfoutput>

<cfif isDefined("stErrors.EmailAddressForQuote")>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['EmailAddressForQuote'].focus(); document.detailform['EmailAddressForQuote'].select()
	-->
	</script>

<cfelseif isDefined("stErrors.EmailAddressFrom")>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['EmailAddressFrom'].focus(); document.detailform['EmailAddressFrom'].select()
	-->
	</script>
	
<cfelse>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['QuoteTitle'].focus(); document.detailform['QuoteTitle'].select()
	-->
	</script>
</cfif>