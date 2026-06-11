<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	07/17/2007
	Function: 		orphaned serial numbers - enter date range
	Template:		frmOrphans.cfm
	Task:			serials_admin_orphans_form
--->
	<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>

	<cfif isDefined("URL.Validation")>
		<cfset stRecord = objSerialsShipments.getDataRecord()>
		<cfset stErrors = objSerialsShipments.getErrorRecord()>
	<cfelse>
		<cfset stRecord = structNew()>
		<cfset stErrors = structNew()>
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
	<td valign="top" class="textmain"><font color="FF0000">#objSerialsShipments.getMessage()#</font></td>
</tr>
<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<td class="textmain" style="font-size:16px; color:0033CC" height="18">
		<strong>Delete Orphaned Serial Numbers</strong>
	<td>
</tr>

<tr><!--- Instructions --->
	<td valign="top" class="textmain">
		This function deletes orphaned serial numbers.  Enter a date range below, then click "Continue".  The system will search for all orphaned serial numbers that were scanned within the date range you entered.  A list of orphaned serial numbers will then appear, giving you a chance to approve of the list before performing the actual deletion process.<br><br>

		<font color="FF0000">Please Note:</font> Entering a narrow date range will allow this process to run much more quickly.  Click the "Continue" button only once.
	</td>
</tr>
<tr><td>&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	<form action="index.cfm?task=serials_admin_orphans_list&RequestTimeout=6000" method="Post" name="detailform">
	<cfset TabValue = 1>
	<tr><td>&nbsp;</td></tr>

	<cfif structKeyExists(stErrors, "StartDate")>
		<tr>
			<td>&nbsp;</td>
			<td valign="bottom" class="textmain" colspan="2"><font color="FF0000">&raquo; #stErrors.StartDate#</font></td>
		</tr>
	</cfif>
	<tr>
		<td width="30%" class="textmain" align="left" valign="middle">
			<strong>Beginning Date:</strong>
		</td>
		<td class="textmain" align="left">
			<input name="StartDate" 
				<cfif isDefined("stRecord.StartDate")>
					value="#stRecord.StartDate#" 				
				</cfif>
			size="20" maxlength="50" tabindex="#TabValue#">
			<cfset TabValue = TabValue + 1>
		</td>
	</tr>
	
	<cfif structKeyExists(stErrors, "EndDate")>
		<tr>
			<td>&nbsp;</td>
			<td valign="bottom" class="textmain" colspan="2"><font color="FF0000">&raquo; #stErrors.EndDate#</font></td>
		</tr>
	</cfif>	
	<tr>
		<td class="textmain" align="left" valign="middle">
			<strong>Ending Date:</strong>
		</td>
		<td class="textmain" align="left">
			<input name="EndDate" 
				<cfif isDefined("stRecord.EndDate")>
					value="#stRecord.EndDate#" 				
				</cfif>
			size="20" maxlength="50" tabindex="#TabValue#">
			<cfset TabValue = TabValue + 1>
		</td>
	</tr>
	
	<tr><td>&nbsp;</td></tr>

	<tr>
	<td valign="top" colspan="2" align="center">
		<table cellpadding="4" cellspacing="0" border="0" width="80%">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<!--- "CONTINUE" BUTTON --->
			<td align="right">
				<input type="submit" name="ButtonClicked" value="&nbsp;Continue -&raquo;" onclick="return continueButton()" tabindex="#TabValue#">
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

<cfif isDefined("stErrors.EndDate") AND trim(stErrors.EndDate) IS NOT "">
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['EndDate'].focus();document.detailform['EndDate'].select()
	-->
	</script>
<cfelse>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['StartDate'].focus();document.detailform['StartDate'].select()
	-->
	</script>
</cfif>