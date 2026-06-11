<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/28/2006
	Function: 		This page displays a form for entering serial numbers for a chosen return item, Authorization phase
	Template:		frmSerialsAuth.cfm
	Task:			serials_returns_serialsauth_edit
--->
	<cfset objRAHEAD = createObject("component", "admin.assets.cfcs.RAHEAD")>
	<cfset objRADET = createObject("component", "admin.assets.cfcs.RADET")>
	<cfset objSerialsReturns = createObject("component", "admin.assets.cfcs.SerialsReturns")>

	<cfif isDefined("URL.Validation") OR 
		  isDefined("FORM.ConsecutiveQuantity")>
		<cfset stRecord = objSerialsReturns.getDataRecord()>
		<cfset stErrors = objSerialsReturns.getErrorRecord()>

		<!--- Get a structure of the RMA header --->
		<cfset strHeader = objRAHEAD.getRecord(stRecord.RMAUNIQ)>
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "RMAUNIQ", stRecord.RMAUNIQ, True)>
		<cfset structInsert(SearchRecord, "LINENUM", stRecord.LINENUM, True)>
		<!--- Get a query of the RMA detail --->
		<cfset qryDetail = objRADET.searchRecords(SearchRecord, "query")>

		<!--- CONSECUTIVE ORDER 2 --->
		<cfif isDefined("FORM.ConsecutiveQuantity")>
			<cfset stRecord = objSerialsReturns.consecutiveOrder2(stRecord, FORM.ConsecutiveQuantity)>
		</cfif>
	
	<cfelse>
		<!--- Get a structure of the RMA header --->
		<cfset strHeader = objRAHEAD.getRecord(URL.RMAUNIQ)>
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "RMAUNIQ", URL.RMAUNIQ, True)>
		<cfset structInsert(SearchRecord, "LINENUM", URL.LINENUM, True)>
		<!--- Get a query of the RMA detail --->
		<cfset qryDetail = objRADET.searchRecords(SearchRecord, "query")>
		<!--- Get a query of the serial numbers already entered --->
		<cfset qrySerialsReturns = objSerialsReturns.searchRecords(SearchRecord, "query")>
		<cfset stRecord = structNew()>
		<cfset IndexCounter = 1>
		<cfloop query="qrySerialsReturns">
			<cfset structInsert(stRecord, "SN_#IndexCounter#", qrySerialsReturns.SerialNumber, True)>
			<cfset IndexCounter = IndexCounter + 1>
		</cfloop>
		<cfset structInsert(stRecord, "RMAUNIQ", URL.RMAUNIQ, True)>
		<cfset structInsert(stRecord, "LINENUM", URL.LINENUM, True)>
		<cfset structInsert(stRecord, "RMAAction", URL.RMAAction, True)>
		<cfset stErrors = structNew()>
	</cfif>

</cfsilent>

<cfset strScanner = objSerialsReturns.getScannerSettings("serials_returns_serialsauth_edit", qryDetail.ITEM)>

<script language="javascript">
	window.onload = init;
	function init() {
		window.scanner = new Scanner();
		window.scanner.setSettingsID("settings");
		window.scanner.init();
	}
	function consecutiveOrder2Button() {
		disableAllButtons();
		document.detailform.WhichButton.value = "Consecutive Order 2";
		window.document.detailform.submit();
	}
	function disableButton() {
		disableAllButtons();
		document.detailform.WhichButton.value = "Save";
		window.document.detailform.submit();
	}
	function confirmClearAll() {
		var msg = "All serial numbers on this page will be cleared.  Are you sure you want to continue?";
		if(confirm(msg)) { 
			disableAllButtons();
			document.detailform.WhichButton.value = "Clear All";
			window.document.detailform.submit();
		}
		else { return false; }
	}
	function confirmCancel() {
		var msg = "Are you sure you want to Cancel?";
		if(confirm(msg)) { 
			disableAllButtons();
			document.detailform.WhichButton.value = "Cancel";
		    window.document.detailform.submit();
		}
		else { return false; }
	}
	function disableAllButtons() {
		document.detailform.ConsecutiveOrder2.disabled = true;
		document.detailform.ButtonClicked[0].disabled = true;
		document.detailform.ButtonClicked[1].disabled = true;
		document.detailform.ButtonClicked[2].disabled = true;
		return true;
	}
</script>

<cfoutput>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">Authorization - Serial Number Entry</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objSerialsReturns.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<!--- HEADER INFORMATION --->
	<cfinclude template="headerInfo.cfm">
	
	<!--- DETAIL INFORMATION --->
	<cfinclude template="detailInfo.cfm">
</td>
</tr>
<tr><td>&nbsp;</td></tr>

<cfset NumberOfBoxes = qryDetail.QTY>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	<form action="index.cfm?task=serials_returns_serials_act&RequestTimeout=6000" method="Post" name="detailform">
	<input type="hidden" name="RMAUNIQ" value="#stRecord.RMAUNIQ#">
	<input type="hidden" name="LINENUM" value="#stRecord.LINENUM#">
	<input type="hidden" name="NumberOfBoxes" value="#NumberOfBoxes#">
	<input type="hidden" name="RMAAction" value="#stRecord.RMAAction#">
	<input type="hidden" name="ITEM" value="#qryDetail.ITEM#">
	<input type="hidden" name="WhichButton" value="">

	<tr>
		<td valign="middle" class="textmain" colspan="3">
			<cfif NumberOfBoxes GT 1>
				<input type="submit" name="ConsecutiveOrder2" value="Consecutive Order 2" onclick="return consecutiveOrder2Button()">
			<cfelse>
				<input type="hidden" name="ConsecutiveOrder2" value="">
			</cfif>
		</td>			
	</tr>
	<tr><td>&nbsp;</td></tr>

	<tr>
		<td valign="top" class="textmain" colspan="2"><b>Serial Numbers:</b></td>
	</tr>
	
	<cfif structKeyExists(stErrors, "DuplicatesFound")>
		<tr>
			<td valign="top" class="textmain" colspan="2">
				<font color="FF0000">
					Duplicate Serial Numbers were entered in two or more boxes.<br>These must be fixed before posting.
				</font>
			</td>
		</tr>
	</cfif>
	<cfif structKeyExists(stErrors, "BatchItemError")>
		<tr>
			<td valign="top" class="textmain" colspan="3">
				<font color="FF0000">
					The item you are returning is identified as a "Batch Number Item".  Therefore, all serial number boxes must contain the same value.  This must be corrected before posting.
				</font>
			</td>
		</tr>
	</cfif>
	<cfif structKeyExists(stErrors, "ConsecutiveOrder")>
		<tr>
			<td valign="top" class="textmain" colspan="3">
				<font color="FF0000">
					#stErrors.ConsecutiveOrder#
				</font>
			</td>
		</tr>
	</cfif>
	
<!---<cfset NumberOfBoxes = qryDetail.QTY>	--->

	<cfset FirstSNField = "">
	<cfloop index="LoopCount" from="1" to="#NumberOfBoxes#">
		<tr>
			<td valign="top" class="textmain" width="20%">&nbsp;</td>
			<cfset SNColumn = "SN_" & LoopCount>
			<cfif isDefined("stRecord") AND structKeyExists(stRecord, SNColumn)>
				<cfset SNColumnValue = stRecord[SNColumn]>	
			<cfelse>
				<cfset SNColumnValue = "">	
			</cfif>
			
			<!--- RJP 6/5/2006 - determine style for form field --->
			<cfif structKeyExists(stErrors, SNColumn)>
				<cfset SNStyle = "border:1px solid red;color:red;background-color:white;font-family:arial;font-size:11px;font-weight:normal;">
			<cfelse>
				<cfif trim(SNColumnValue) IS "">
					<cfset SNStyle = "border:1px solid lightgrey;background-color:white;color:black;font-family:arial;font-size:11px;font-weight:normal;">
				<cfelse>
					<cfset SNStyle = "border:1px solid green;color:green;background-color:white;font-family:arial;font-size:11px;font-weight:normal;">
				</cfif>
			</cfif>
			
			<td valign="top" class="textmain">
				<input name="#SNColumn#" value="#SNColumnValue#" size="50" maxlength="50" tabindex="#LoopCount#" onkeydown="return window.scanner.doKeyDown();" onkeypress="return window.scanner.doKeyPress();" onkeyup="return window.scanner.doKeyUp();" style="#SNStyle#"/>
			</td>
			<cfif FirstSNField IS "">
				<cfset FirstSNField = SNColumn>
			</cfif>
		</tr>
	</cfloop>

	<tr>
	<td valign="top" colspan="2" align="center">
		<table cellpadding="4" cellspacing="0" border="0" width="80%">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td width="30%"><!--- "SAVE" BUTTON --->
				<input type="submit" name="ButtonClicked" value="Save" onclick="return disableButton()">
			</td>
			<td><!--- "CLEAR ALL" BUTTON --->
				<input type="submit" name="ButtonClicked" value="Clear All" onclick="return confirmClearAll()">
			</td>
			<td><!--- "CANCEL" BUTTON --->
				<input type="submit" name="ButtonClicked" value="Cancel" onclick="return confirmCancel()">
			</td>
		</tr>
		<tr id="Posting" style="visibility:hidden;">
			<td valign="top" colspan="3" align="center" class="textmain">
				<font color="FF0000">Saving Serial Numbers - Please Wait</font>
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
<div id="settings" style="display:none;">#objSerialsReturns.jsonEncode(strScanner)#</div>
</cfoutput>