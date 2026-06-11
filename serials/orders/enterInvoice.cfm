<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	01/18/2007
	Function: 		This page prompts the user to enter an invoice number
	Template:		enterInvoice.cfm.cfm
	Task:			serials_reprint_invoice_enter
--->
</cfsilent>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<form name="InvoiceNumberSearch" action="index.cfm?task=serials_reprint_invoice_find&RequestTimeout=6000" method="post">
	<tr>
		<td class="textmain" align="left">
			<strong>Invoice Number:</strong>
			<input name="InvoiceNumber" size="20" maxlength="50"
				<cfif isDefined("URL.InvoiceNumber")>
					value="#URL.InvoiceNumber#"
				</cfif>
			>
			<input type="submit" name="ProcessSearch" value="Go">
		</td>
	</tr>
</form>
<cfif isDefined("URL.Error")>
	<tr>
		<td class="textmain" align="left">
			<font color="FF0000">
				<cfif URL.Error IS "Blank">
					Please enter an Invoice Number before clicking "Go".
				<cfelseif URL.Error IS "NotFound">
					Invoice Number <cfif isDefined("URL.InvoiceNumber")>'#URL.InvoiceNumber#'</cfif> was not found.
				<cfelseif URL.Error IS "MultipleFound">
					Multiple matches were found for Invoice Number <cfif isDefined("URL.InvoiceNumber")>'#URL.InvoiceNumber#'</cfif>.
				<cfelseif URL.Error IS "NoAttachedSerialNumbers">
					Invoice Number <cfif isDefined("URL.InvoiceNumber")>'#URL.InvoiceNumber#'</cfif> has no serial numbers attached to it.
				</cfif>
			</font>
		</td>
	</tr>
</cfif>

<tr><td class="textsmall">&nbsp;</td></tr>

</table>
</cfoutput>

<script language="JavaScript" type="text/JavaScript">
<!--
document.InvoiceNumberSearch['InvoiceNumber'].focus();document.InvoiceNumberSearch['InvoiceNumber'].select()
-->
</script>