<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	07/19/2007
	Function: 		Apply serial numbers from receipt: Enter receipt number
	Template:		frmSerialsCopy.cfm
	Task:			serials_adjustments_serials_copy_edit
--->
	<cfset objSerialsAdjustments = createObject("component", "admin.assets.cfcs.SerialsAdjustments")>
	<cfset objICADEH = createObject("component", "admin.assets.cfcs.ICADEH")>
	
</cfsilent>

<script language="javascript">
	function disableGoButton() {
		document.ReceiptNumberSearch.ProcessSearch.disabled = true;
		document.getElementById("Processing").style.visibility = "visible";		
		window.document.ReceiptNumberSearch.submit();
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
	<td valign="top" class="textmain"><font color="FF0000">#objSerialsAdjustments.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>
<tr>
<td valign="top" class="textmain">
	<!--- Get a structure of the Order header --->
	<cfset strHeader = objICADEH.getRecord(URL.ADJENSEQ)>
	<!--- ORDER INFORMATION --->
	<cfinclude template="headerInfo.cfm">
</td>
</tr>
<tr><td>&nbsp;</td></tr>

<tr><!--- Instructions --->
	<td valign="top" class="textmain">
		Enter the Receipt Number that contains the serial numbers that you want to apply to this adjustment.
	</td>
</tr>

<form name="ReceiptNumberSearch" action="index.cfm?task=serials_adjustments_serials_copy_act&RequestTimeout=6000" method="post">
<input type="hidden" name="ADJENSEQ" value="#URL.ADJENSEQ#">
	<tr>
		<td class="textmain" align="left">
			<strong>Receipt Number:</strong>
			<input name="ReceiptNumber" size="20" maxlength="50"
				<cfif isDefined("URL.ReceiptNumber")>
					value="#URL.ReceiptNumber#"
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
					Please enter a Receipt Number before clicking "Go".
				<cfelseif URL.Error IS "NotFound">
					Receipt Number <cfif isDefined("URL.ReceiptNumber")>'#URL.ReceiptNumber#'</cfif> was not found.
				<cfelseif URL.Error IS "MultipleFound">
					Multiple matches were found for Receipt Number <cfif isDefined("URL.ReceiptNumber")>'#URL.ReceiptNumber#'</cfif>.
				<cfelseif URL.Error IS "ReceiptNoSNs">
					No serial numbers have been scanned and posted yet for Receipt Number <cfif isDefined("URL.ReceiptNumber")>'#URL.ReceiptNumber#'</cfif>.
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
document.ReceiptNumberSearch['ReceiptNumber'].focus();document.ReceiptNumberSearch['ReceiptNumber'].select()
-->
</script>