<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/09/2006
	Function: 		This page displays a form for correcting the chosen serial number
	Template:		frmSerial.cfm
	Task:			serials_corrections_serials_edit
--->
	<cfset objSerials = createObject("component", "admin.assets.cfcs.Serials")>
	<cfset objICITEM = createObject("component", "admin.assets.cfcs.ICITEM")>

	<cfif isDefined("URL.Validation")>
		<cfset stRecord = objSerials.getDataRecord()>
		<cfset stErrors = objSerials.getErrorRecord()>
	<cfelse>
		<cfset stRecord = objSerials.getRecord(URL.SerialID)>
		<cfset structInsert(stRecord, "NewSerialNumber", "", True)>
		<cfset stErrors = structNew()>
	</cfif>
	<cfset strHeader = objICITEM.getRecord(stRecord.ITEMNO)>

</cfsilent>

<cfset strScanner = objSerials.getScannerSettings("serials_corrections_serials_edit")>

<script language="javascript">
	window.onload = init;
	function init() {
		window.scanner = new Scanner();
		window.scanner.setSettingsID("settings");
		window.scanner.init();
	}
	function disableButton() {
	  document.detailform.ButtonClicked[1].disabled = true;
	  document.getElementById("Posting").style.visibility = "visible";					
	  window.document.detailform.submit();
	}
	
</script>

<cfoutput>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">Serial Number Entry</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objSerials.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<!--- HEADER INFORMATION --->
	<cfinclude template="headerInfo.cfm">
</td>
</tr>
<tr><td>&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	<form action="index.cfm?task=serials_corrections_serials_confirm" method="Post" name="detailform">
	<input type="hidden" name="SerialID" value="#stRecord.SerialID#">
	<input type="hidden" name="ITEMNO" value="#stRecord.ITEMNO#">
	<input type="hidden" name="SerialNumber" value="#stRecord.SerialNumber#">

	<tr>
		<td valign="top" class="textmain" width="35%"><b>Current Serial Number:</b></td>
		<td valign="top" class="textmain">#stRecord.SerialNumber#</td>
	</tr>


	<cfif structKeyExists(stErrors, "NewSerialNumber")>
		<tr>
			<td>&nbsp;</td>
			<td valign="top" class="textmain"><font color="FF0000">&raquo; #stErrors.NewSerialNumber#</font></td>
		</tr>
	</cfif>
	<tr>
		<td valign="middle" class="textmain"><b>New Serial Number:</b></td>

		<!--- RJP 6/5/2006 - determine style for form field --->
		<cfif structKeyExists(stErrors, "NewSerialNumber")>
			<cfset SNStyle = "border:1px solid red;color:red;background-color:white;font-family:arial;font-size:11px;font-weight:normal;">
		<cfelse>
			<cfif trim(stRecord.NewSerialNumber) IS "">
				<cfset SNStyle = "border:1px solid lightgrey;background-color:white;color:black;font-family:arial;font-size:11px;font-weight:normal;">
			<cfelse>
				<cfset SNStyle = "border:1px solid green;color:green;background-color:white;font-family:arial;font-size:11px;font-weight:normal;">
			</cfif>
		</cfif>
		
		<td valign="top" class="textmain">
			<input name="NewSerialNumber" value="#stRecord.NewSerialNumber#" size="50" maxlength="50" onkeydown="return window.scanner.captureKey();" onkeypress="return window.scanner.negateKey();" onkeyup="return window.scanner.negateKey();" style="#SNStyle#"/>
		</td>
	</tr>

	<tr>
	<td valign="top" colspan="2" align="center">
		<table cellpadding="4" cellspacing="0" border="0" width="80%">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<!--- "QUIT" BUTTON --->
				<td width="50%">
					<input type="submit" name="ButtonClicked" value="Quit">
				</td>
				<!--- "CONTINUE" BUTTON --->
				<td>
					<input type="submit" name="ButtonClicked" value="&nbsp;Continue -&raquo;" onclick="return disableButton()">
				</td>
			</tr>
			<tr id="Posting" style="visibility:hidden;">
				<td valign="top" colspan="2" align="center" class="textmain">
					<font color="FF0000">Posting Serial Number - Please Wait</font>
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

<bgsound id="soundconsole" src="sounds/Nada.wav" loop="1"/>
<div id="error" style="display:none;z-order:10000;position:absolute;left:0px;top:0px;"></div>
<div id="settings" style="display:none;">#objSerials.jsonEncode(strScanner)#</div>
</cfoutput>