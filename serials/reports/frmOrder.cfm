<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/11/2006
	Function: 		This page prompts the user to enter an order number
	Template:		frmOrder.cfm
	Task:			serials_reports_order_enter
--->
	<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>

	<cfset Error = 0>
	
	<cfif isDefined("FORM.ORDNUMBER")>
		<cfif trim(FORM.ORDNUMBER) IS "">
			<cfset Error = 1>
		<cfelse>
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "ORDNUMBER", FORM.ORDNUMBER, True)>
			<cfset qrySerialsShipments = objSerialsShipments.searchRecords(SearchRecord, "query")>
			<cfif qrySerialsShipments.RecordCount EQ 0>
				<cfset Error = 1>
			<cfelse>
				<cflocation url="index.cfm?task=serials_reports_order_disp&ORDNUMBER=#urlEncodedFormat(qrySerialsShipments.ORDNUMBER)#&RequestTimeout=6000">
			</cfif>
		</cfif>
	</cfif>

</cfsilent>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<form name="OrderNumberSearch" action="index.cfm?task=serials_reports_order_enter" method="post">
	<tr>
		<td class="textmain" align="left">
			<strong>Order Number:</strong>
			<input name="ORDNUMBER" size="20" maxlength="50"
				<cfif isDefined("FORM.ORDNUMBER")>
					value="#FORM.ORDNUMBER#"
				</cfif>
			>
			<input type="submit" name="ProcessSearch" value="Search">
		</td>
	</tr>
</form>
<cfif Error>
	<tr>
		<td class="textmain" align="left">
			<font color="FF0000">
				<cfif trim(FORM.ORDNUMBER) IS "">
					Please enter an Order Number before clicking "Search".
				<cfelseif qrySerialsShipments.RecordCount EQ 0>
					No serial numbers were found <cfif isDefined("FORM.ORDNUMBER")>for Order Number '#FORM.ORDNUMBER#'</cfif>.
				</cfif>
			</font>
		</td>
	</tr>
</cfif>

<tr><td class="textsmall">&nbsp;</td></tr>
</cfoutput>

</table>

<script language="JavaScript" type="text/JavaScript">
<!--
document.OrderNumberSearch['ORDNUMBER'].focus();document.OrderNumberSearch['ORDNUMBER'].select()
-->
</script>