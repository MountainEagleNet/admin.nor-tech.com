<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/10/2006
	Function: 		This page prompts the user to enter a serial number
	Template:		frmHistory.cfm
	Task:			serials_reports_history_enter
--->
	<cfset objSerialNumberAuditTrail = createObject("component", "admin.assets.cfcs.SerialNumberAuditTrail")>
	<cfif NOT isDefined("URL.NumberOfBoxes")>
		<cfset NumberOfBoxes = 1>
	<cfelse>
		<cfset NumberOfBoxes = URL.NumberOfBoxes>
	</cfif>
	<cfif NOT isNumeric(NumberOfBoxes)>
		<cfset NumberOfBoxes = 1>
	</cfif>
</cfsilent>

<cfset strScanner = objSerialNumberAuditTrail.getScannerSettings("serials_reports_history2_enter")>

<script language="javascript">
	window.onload = init;
	function init() {
		window.scanner = new Scanner();
		window.scanner.setSettingsID("settings");
		window.scanner.init();
	}
</script>

<cfoutput>
<!---<table width="549" border="1" align="center" cellpadding="3" cellspacing="1">--->
<table width="650" border="0" align="center" cellpadding="3" cellspacing="1">
<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<form name="SerialNumberSearch" action="index.cfm?task=serials_reports_history2_disp&RequestTimeout=6000" method="post">
<!---<form name="detailform" action="index.cfm?task=serials_reports_history2_disp" method="post">--->
<input type="hidden" name="NumberOfBoxes" value="#NumberOfBoxes#">
	<tr>
		<td class="textmain" align="left">
			<table border="0">
				<cfloop index="i" from="1" to="#NumberOfBoxes#">
					<tr>
						<td class="textmain" width="35%"><strong>Serial Number:</strong></td>
						<cfset SNStyle = "border:1px solid lightgrey;background-color:white;color:black;font-family:arial;font-size:11px;font-weight:normal;">
						<td>
							<input name="SerialNumber_#i#" size="20" maxlength="50" onkeydown="return window.scanner.doKeyDown();" onkeypress="return window.scanner.doKeyPress();" onkeyup="return window.scanner.doKeyUp();" style="#SNStyle#">
						</td>
					</tr>
				</cfloop>

				<tr>
					<td class="textmain">
						<strong>Beginning Date:</strong>
					</td>
					<td class="textmain">
						<input name="BeginningDate" size="16" maxlength="50"
<!---
							<cfif isDefined("FORM.BeginningDate")>
								value="#FORM.BeginningDate#"
							</cfif>
--->							
						> <i>(mm/dd/yyyy)</i>
					</td>
				</tr>
				<tr>
					<td class="textmain">
						<strong>End Date:</strong>
					</td>
					<td class="textmain">
						<input name="EndingDate" size="16" maxlength="50"
<!---
							<cfif isDefined("FORM.EndingDate")>
								value="#FORM.EndingDate#"
							</cfif>
--->
						> <i>(mm/dd/yyyy)</i>
					</td>
				</tr>

				
			</table>
		</td>
		<td valign="top">
			<table border="0">
				<tr>
					<td valign="top">
						<select name="AddBoxes" size="1" onChange="document.SerialNumberSearch.submit()">
							<option value="">- Increase Number of Fields -</option>
							<option value="10">10 Fields</option>
							<option value="20">20 Fields</option>
							<option value="50">50 Fields</option>
							<option value="100">100 Fields</option>
						</select>
									
						<input type="submit" name="ProcessSearch" value="Search">
<!---					<input type="submit" name="ButtonClicked" value="Search">	--->
					</td>
				</tr>
			</table>
		</td>
	</tr>

</form>

<tr><td class="textsmall">&nbsp;</td></tr>
<bgsound id="soundconsole" src="sounds/Nada.wav" loop="1"/>
<div id="settings" style="display:none;">#objSerialNumberAuditTrail.jsonEncode(strScanner)#</div>

</cfoutput>

</table>
<script language="JavaScript" type="text/JavaScript">
<!--
document.SerialNumberSearch['SerialNumber_1'].focus();document.SerialNumberSearch['SerialNumber_1'].select()
-->
</script>