<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	10/12/2006
	Function: 		This page prompts the user to enter an order number
	Template:		enterAttachOrder.cfm
	Task:			serials_attach_order_enter
--->
	<cfset objOEORDH = createObject("component", "admin.assets.cfcs.OEORDH")>
</cfsilent>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<form name="OrderNumberSearch" action="index.cfm?task=serials_attach_order_find&RequestTimeout=6000" method="post">
	<tr>
		<td class="textmain" align="left">
			<strong>Order Number:</strong>
			<input name="OrderNumber" size="20" maxlength="50"
				<cfif isDefined("URL.OrderNumber")>
					value="#URL.OrderNumber#"
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
					Please enter an Order Number before clicking "Go".
				<cfelseif URL.Error IS "NotFound">
					Order Number <cfif isDefined("URL.OrderNumber")>'#URL.OrderNumber#'</cfif> was not found.
				<cfelseif URL.Error IS "MultipleFound">
					Multiple matches were found for Order Number <cfif isDefined("URL.OrderNumber")>'#URL.OrderNumber#'</cfif>.
				<cfelseif URL.Error IS "NoSerialNumbers">
					No serial numbers have been scanned for Order Number <cfif isDefined("URL.OrderNumber")>'#URL.OrderNumber#'</cfif>.
				<cfelseif URL.Error IS "NoUnattachedSerialNumbers">
					There are no serial numbers waiting to be attached on any of the lines of Order Number <cfif isDefined("URL.OrderNumber")>'#URL.OrderNumber#'</cfif>.
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
document.OrderNumberSearch['OrderNumber'].focus();document.OrderNumberSearch['OrderNumber'].select()
-->
</script>
