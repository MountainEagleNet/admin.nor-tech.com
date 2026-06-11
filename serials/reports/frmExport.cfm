<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	07/20/2007
	Function: 		Export Serial Numbers to Excel - Enter date range and part numbers
	Template:		frmExport.cfm
	Task:			serials_reports_frmExport
--->
	<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>

	<cfif isDefined("URL.Validation")>
		<cfset stRecord = objSerialsShipments.getDataRecord()>
		<cfset stErrors = objSerialsShipments.getErrorRecord()>
	<cfelse>
		<cfset stRecord = structNew()>
		<cfset structInsert(stRecord, "BeginningDate", "", True)>
		<cfset structInsert(stRecord, "EndingDate", "", True)>
		<cfset structInsert(stRecord, "ITEMNO1", "", True)>
		<cfset structInsert(stRecord, "ITEMNO2", "", True)>
		<cfset stErrors = structNew()>
	</cfif>

</cfsilent>

<!---
<script language="javascript">
	function continueButton() {
		document.detailform.ButtonClicked.disabled = true;
		window.document.detailform.submit();
	}
</script>
--->
<cfoutput>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objSerialsShipments.getMessage()#</font></td>
</tr>
<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<td class="textmain" style="font-size:16px; color:0033CC" height="18">
		<strong>Export Serial Numbers to Excel</strong>
	<td>
</tr>

<tr><!--- Instructions --->
	<td valign="top" class="textmain">
		This function exports serial numbers to Excel.  <br><br>
		
		It searches the database retrieving all serial numbers scanned for comp builds that match the criteria entered below, and then exports the serial numbers to an Excel spreadsheet.<br><br>
		
		<font color="FF0000">Please Note:</font> Although entering a date range is not required, entering no dates (or entering a wide date range) could cause this function to take a long time to run.  Click the "Continue" button only once.
	</td>
</tr>
<tr><td>&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	<form action="index.cfm?task=serials_reports_actExport&RequestTimeout=6000" method="Post" name="detailform">

	<cfif structKeyExists(stErrors, "NoneFound")>
		<tr>
			<td valign="bottom" class="textmain" colspan="3"><font color="FF0000">&raquo; #stErrors.NoneFound#</font></td>
		</tr>
	</cfif>

	<!--- BEGINNING DATE --->
	<cfif structKeyExists(stErrors, "BeginningDate")>
		<tr>
			<td>&nbsp;</td>
			<td valign="bottom" class="textmain" colspan="2"><font color="FF0000">&raquo; #stErrors.BeginningDate#</font></td>
		</tr>
	</cfif>
	<tr>
		<td class="textmain" align="left" width="35%">
			<strong>Order Beginning Date:</strong>
		</td>
		<td class="textmain" align="left">
			<input name="BeginningDate" size="20" maxlength="50" value="#stRecord.BeginningDate#"> <i>(mm/dd/yyyy)</i>
		</td>
	</tr>

	<!--- ENDING DATE --->
	<cfif structKeyExists(stErrors, "EndingDate")>
		<tr>
			<td>&nbsp;</td>
			<td valign="bottom" class="textmain" colspan="2"><font color="FF0000">&raquo; #stErrors.EndingDate#</font></td>
		</tr>
	</cfif>
	<tr>
		<td class="textmain" align="left">
			<strong>Order Ending Date:</strong>
		</td>
		<td class="textmain" align="left">
			<input name="EndingDate" size="20" maxlength="50" value="#stRecord.EndingDate#"> <i>(mm/dd/yyyy)</i>
		</td>
	</tr>

	<!--- PART NUMBER 1 --->
	<cfif structKeyExists(stErrors, "ITEMNO1")>
		<tr>
			<td>&nbsp;</td>
			<td valign="bottom" class="textmain" colspan="2"><font color="FF0000">&raquo; #stErrors.ITEMNO1#</font></td>
		</tr>
	</cfif>
	<tr>
		<td class="textmain" align="left">
			<strong>Part Number 1:</strong>
		</td>
		<td class="textmain" align="left">
			<input name="ITEMNO1" size="20" maxlength="50" value="#stRecord.ITEMNO1#">
		</td>
	</tr>

	<!--- PART NUMBER 2 --->
	<cfif structKeyExists(stErrors, "ITEMNO2")>
		<tr>
			<td>&nbsp;</td>
			<td valign="bottom" class="textmain" colspan="2"><font color="FF0000">&raquo; #stErrors.ITEMNO2#</font></td>
		</tr>
	</cfif>
	<tr>
		<td class="textmain" align="left">
			<strong>Part Number 2:</strong>
		</td>
		<td class="textmain" align="left">
			<input name="ITEMNO2" size="20" maxlength="50" value="#stRecord.ITEMNO2#">
		</td>
	</tr>
	
	<tr>
	<td valign="top" colspan="2" align="center">
		<table cellpadding="4" cellspacing="0" border="0" width="80%">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<!--- "CONTINUE" BUTTON --->
			<td align="right">
				<input type="submit" name="ButtonClicked" value="&nbsp;Continue -&raquo;" <!---onclick="return continueButton()"--->>
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

<cfif structKeyExists(stErrors, "BeginningDate")>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['BeginningDate'].focus(); document.detailform['BeginningDate'].select()
	-->
	</script>
<cfelseif structKeyExists(stErrors, "EndingDate")>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['EndingDate'].focus(); document.detailform['EndingDate'].select()
	-->
	</script>
<cfelseif structKeyExists(stErrors, "ITEMNO1")>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['ITEMNO1'].focus(); document.detailform['ITEMNO1'].select()
	-->
	</script>
<cfelseif structKeyExists(stErrors, "ITEMNO2")>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['ITEMNO2'].focus(); document.detailform['ITEMNO2'].select()
	-->
	</script>
<cfelse>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['BeginningDate'].focus();document.detailform['BeginningDate'].select()
	-->
	</script>
</cfif>