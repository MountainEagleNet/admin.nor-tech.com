<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	02/26/2008
	Function: 		Copy Serial Numbers from Another Order, Enter Order Number
	Template:		frmSerialsOrderApply.cfm
	Task:			serials_shipments_orderapply_edit
--->
	<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>
	<cfset objOEORDH = createObject("component", "admin.assets.cfcs.OEORDH")>
	
</cfsilent>

<script language="javascript">
	function disableGoButton() {
		document.OrderNumberSearch.ProcessSearch.disabled = true;
		document.getElementById("Processing").style.visibility = "visible";		
		window.document.OrderNumberSearch.submit();
	}
</script>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<!---
<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">Receipts List</td>
</tr>
--->

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objSerialsShipments.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>
<tr>
<td valign="top" class="textmain">
	<!--- Get a structure of the Order header --->
	<cfset strHeader = objOEORDH.getRecord(URL.ORDUNIQ)>
	<!--- ORDER INFORMATION --->
	<cfinclude template="headerInfo.cfm">
</td>
</tr>
<tr><td>&nbsp;</td></tr>

<tr><!--- Instructions --->
	<td valign="top" class="textmain">
		Enter the Order Number that contains the serial numbers that you want to copy from.
	</td>
</tr>

<form name="OrderNumberSearch" action="index.cfm?task=serials_shipments_orderapply_act&RequestTimeout=6000" method="post">
<input type="hidden" name="ORDUNIQ" value="#URL.ORDUNIQ#">
	<tr>
		<td class="textmain" align="left">
			<strong>Order Number:</strong>
			<input name="OrderNumber" size="20" maxlength="50"
				<cfif isDefined("URL.OrderNumber")>
					value="#URL.OrderNumber#"
				</cfif>
			>
			<input type="submit" name="ProcessSearch" value="Go" onclick="return disableGoButton()">
		</td>
	</tr>
	<tr id="Processing" style="visibility:hidden;">
		<td valign="top" colspan="4" align="center" class="textmain">
			<font color="FF0000">Applying Serial Numbers - Please Wait</font>
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
				<cfelseif URL.Error IS "OrderNoSNs">
					No serial numbers have been scanned and posted yet for Order Number <cfif isDefined("URL.OrderNumber")>'#URL.OrderNumber#'</cfif>.
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