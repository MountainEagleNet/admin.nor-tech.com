<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/26/2006
	Function: 		This page prompts the user to enter an order number
	Template:		enterOrder.cfm
	Task:			serials_orders_enter
--->
	<cfset objOEORDH = createObject("component", "admin.assets.cfcs.OEORDH")>
	<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>
</cfsilent>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objSerialsShipments.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<form name="OrderNumberSearch" action="index.cfm?task=serials_orders_find&RequestTimeout=6000" method="post">
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
