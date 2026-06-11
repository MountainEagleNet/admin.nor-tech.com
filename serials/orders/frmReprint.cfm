<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	12/28/2006
	Edit Date: 		
	Function: 		This page displays the form for entering company and customer information for the serial number list
	Template:		frmReprint.cfm
	Task:			serials_attach_reprint
--->
	<cfset objOEORDH = createObject("component", "admin.assets.cfcs.OEORDH")>
	<cfset objOEINVH = createObject("component", "admin.assets.cfcs.OEINVH")>
	<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>

	<!--- Get a structure of the Order header --->
	<cfset strHeader = objOEORDH.getRecord(URL.ORDUNIQ)>

	<!--- Get a structure of the Invoice header --->
	<cfset strOEINVH = objOEINVH.getRecord(URL.INVUNIQ)>

	<cfset stRecord = structNew()>
	<cfset structInsert(stRecord, "ORDUNIQ", URL.ORDUNIQ, True)>
	<cfset structInsert(stRecord, "INVUNIQ", URL.INVUNIQ, True)>
	<cfset structInsert(stRecord, "Company", "", True)>
	<cfset structInsert(stRecord, "Customer", trim(strHeader.BILNAME), True)>
	<cfset stErrors = structNew()>

</cfsilent>

<script language="JavaScript" type="text/JavaScript">
<!--
function disableButton() {
  document.detailform.ButtonClicked.disabled = true;
  document.getElementById("Posting").style.visibility = "visible";					
  window.document.detailform.submit();
}
//-->
</script>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<td valign="top" class="textmain" style="font-size:16px"><b>Reprint Serial Number List</b></td>
</tr>

<tr>
<td valign="top" class="textmain">
	<!--- ORDER INFORMATION --->
	<cfinclude template="headerInfo.cfm">
	<!--- INVOICE INFORMATION --->
	<table cellpadding="1" cellspacing="0" width="100%" border="0">
		<tr>
			<td class="textmain" align="left" width="30%"><b>Invoice Number:</b></td>
			<td class="textmain" align="left">#strOEINVH.INVNUMBER#</td>
		</tr>
		<tr>
			<td class="textmain" align="left"><b>Invoice Date:</b></td>
			<td class="textmain" align="left">#objOEINVH.formatDate(strOEINVH.INVDATE)#</td>
		</tr>
	</table>
</td>
</tr>
<tr><td>&nbsp;</td></tr>

<tr>
	<td valign="top" class="textmain">
	Please choose the company and customer to appear on the serial number list:<br> 
	</td>
</tr>

<tr>
<td valign="top" class="textmain">
	<form action="index.cfm?task=serials_attach_print&RequestTimeout=6000" method="Post" name="detailform">
	<input type="hidden" name="ORDUNIQ" value="#stRecord.ORDUNIQ#">
	<input type="hidden" name="INVUNIQ" value="#stRecord.INVUNIQ#">

	<cfset TabValue = 1>
	<table cellpadding="2" cellspacing="0" width="100%" border="0">

	<!--- COMPANY --->
	<tr>
		<td width="20%" class="textmain" align="left"><strong>Company:</strong></td>
		<td class="textmain" align="left">
			<input type="radio" name="Company" value="Nor-Tech" tabindex="#TabValue#"
				<cfif stRecord.Company IS "Nor-Tech" OR stRecord.Company IS "">checked</cfif>
				>Nor-Tech &nbsp;&nbsp;
			<input type="radio" name="Company" value="Reason"
				<cfif stRecord.Company IS "Reason">checked</cfif>
				>Reason &nbsp;&nbsp;
			<cfset TabValue = TabValue + 1>
		</td>
	</tr>

	<!--- CUSTOMER --->
	<cfif structKeyExists(stErrors, "Customer")>
		<tr>
			<td>&nbsp;</td>
			<td valign="bottom" class="textmain"><font color="FF0000">&raquo; #stErrors.Customer#</font></td>
		</tr>
	</cfif>
	<tr>
		<td class="textmain" align="left"><strong>Customer:</strong></td>
		<td class="textmain" align="left">
			<input name="Customer" size="50" maxlength="80" tabindex="#TabValue#" value="#stRecord.Customer#" 
				<cfif structKeyExists(stErrors, "Customer")>style="border:1px solid red;"</cfif>
			>
			<cfset TabValue = TabValue + 1>
		</td>
	</tr>
	
	</table>
	
	<table cellpadding="4" cellspacing="0" border="0" width="80%" align="center">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<!--- "CONTINUE" BUTTON --->
			<td align="right">
				<input type="submit" name="ButtonClicked" value="&nbsp;Continue -&raquo;" tabindex="#TabValue#"  onclick="return disableButton()">
			</td>
		</tr>
		<tr id="Posting" style="visibility:hidden;">
			<td valign="top" colspan="2" align="center" class="textmain">
				<font color="FF0000">Creating Serial Number List - Please Wait</font>
			</td>
		</tr>
	</table>
	</form>
</td>
</tr>

</table>
</cfoutput>