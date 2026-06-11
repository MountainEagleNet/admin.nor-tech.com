<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	10/16/2006
	Function: 		This is the response page that appears upon a successfull attachment
	Template:		dspAttach.cfm
	Task:			serials_attach_confirm_view
--->
	<cfset objOEORDH = createObject("component", "admin.assets.cfcs.OEORDH")>
	<cfset objOEINVH = createObject("component", "admin.assets.cfcs.OEINVH")>
	<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>

	<!--- Get a structure of the Order header --->
	<cfset strHeader = objOEORDH.getRecord(URL.ORDUNIQ)>

	<!--- Get a structure of the Invoice header --->
	<cfset strOEINVH = objOEINVH.getRecord(URL.INVUNIQ)>
</cfsilent>

<script language="javascript">
	window.onload = init;
	function init() {
		var ref = document.getElementById("LinkPrint");
		ref.focus();
	}
</script>

<cfoutput>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objSerialsShipments.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<!--- link back --->
<tr>
	<td class="textsmall" align="right">
		<a href="index.cfm?task=serials_attach_order_enter">
			Back to Order Number Entry Page
		</a>
	</td>
</tr>

<!--- "Print Serial Number List" link --->
<tr>
	<td class="textsmall" align="right">
		<a href="serials/orders/index.cfm?task=serials_attach_print&ORDUNIQ=#urlEncodedFormat(URL.ORDUNIQ)#&INVUNIQ=#urlEncodedFormat(URL.INVUNIQ)#" id="LinkPrint" target="_blank">
			<font style="background-color:FFFFCC; text-decoration:underline">Print Serial Number List</font>
		</a>
	</td>
</tr>

<td valign="top" class="textmain">
	<!--- ORDER INFORMATION --->
	<cfinclude template="headerInfo.cfm">

	<!--- INVOICE INFORMATION --->
	<cfinclude template="invoiceInfo.cfm">

</td>
</tr>
<tr><td>&nbsp;</td></tr>

<tr>
	<td valign="top" class="textmain">
		Serial numbers for Order Number '#strHeader.ORDNUMBER#' have been successfully attached to Invoice Number '#strOEINVH.INVNUMBER#'.<br><br>
		Click "Print Serial Number List" in the upper-right corner or <a href="serials/orders/index.cfm?task=serials_attach_print&ORDUNIQ=#urlEncodedFormat(URL.ORDUNIQ)#&INVUNIQ=#urlEncodedFormat(URL.INVUNIQ)#" target="_blank">click here</a> to print the serial number list. 
	</td>
</tr>

</table>
</cfoutput>