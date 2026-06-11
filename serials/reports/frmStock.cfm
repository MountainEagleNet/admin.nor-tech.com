<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/22/2007
	Function: 		Out of Stock Report - Description Page
	Template:		frmStock.cfm
	Task:			serials_reports_frmStock
--->
	<cfset objBackOrder = createObject("component", "admin.assets.cfcs.BackOrder")>

	<cfif isDefined("URL.UpdateOnly")>
		<cfset UpdateOnly = 1>
	<cfelse>
		<cfset UpdateOnly = 0>
	</cfif>

</cfsilent>

<script language="javascript">
	function continueButton() {
		document.detailform.ButtonClicked.disabled = true;
		window.document.detailform.submit();
	}
</script>

<cfoutput>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objBackOrder.getMessage()#</font></td>
</tr>
<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<td class="textmain" style="font-size:16px; color:0033CC" height="18">
		<strong>Out of Stock Report</strong>
	<td>
</tr>

<tr><!--- Instructions --->
	<td valign="top" class="textmain">
		This function runs the out of stock report.  It searches through ACCPAC looking for items that are part of system builds that are out of stock and need to be reordered.  Please note that the system build must have been started on or after June 1st, 2007 for its parts to appear on this report.<br><br>
		
		<cfif NOT UpdateOnly>
			Two versions of the report are then generated and delivered by email:<br><br>
			
			<b>The "Purchasing" Format</b>:&nbsp; This version displays a list of all items and quantities that need to be backordered.  It is sent by email to the following addresses:<br>jeffo@nor-tech.com, larryh@nor-tech.com, robb@nor-tech.com,<br>
			todds@nor-tech.com, seanq@nor-tech.com.<br><br>
			<b>The "Sales Rep" Format</b>:&nbsp; This version is sent by email to each sales rep, and shows backordered items and quantities for orders for their customers only.<br><br>

		<cfelse>
			Since you clicked the "Update Only" option, the reports will not be delivered by email; only the information in the database will be updated.<br><br>

		</cfif>
	
		<font color="FF0000">Please Note:</font> This process will take a while to run.  Click the "Continue" button only once.
	</td>
</tr>
<tr><td>&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	<form action="index.cfm?task=serials_reports_actStock&RequestTimeout=6000" method="Post" name="detailform">
	<input type="hidden" name="UpdateOnly" value="#UpdateOnly#">
	<tr>
	<td valign="top" colspan="2" align="center">
		<table cellpadding="4" cellspacing="0" border="0" width="80%">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<!--- "CONTINUE" BUTTON --->
			<td align="right">
				<input type="submit" name="ButtonClicked" value="&nbsp;Continue -&raquo;" onclick="return continueButton()">
			</td>
		</tr>
		</table>
	</td>
	</tr>

	</form>
	</table>
</td>
</tr>

</table>
</cfoutput>