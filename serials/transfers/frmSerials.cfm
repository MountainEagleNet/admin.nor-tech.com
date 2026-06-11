<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/05/2006
	Function: 		This page displays a form for entering serial numbers for a chosen transfer item
	Template:		frmSerials.cfm
	Task:			serials_transfers_serials_edit
--->
	<cfset objICTREH = createObject("component", "admin.assets.cfcs.ICTREH")>
	<cfset objICTRED = createObject("component", "admin.assets.cfcs.ICTRED")>
	<cfset objSerialsTransfers = createObject("component", "admin.assets.cfcs.SerialsTransfers")>
	<cfset objScannerBatchItems = createObject("component", "admin.assets.cfcs.ScannerBatchItems")>

	<cfif isDefined("URL.Validation") OR 
		  isDefined("URL.ConsecutiveOrder") OR 
		  isDefined("FORM.ConsecutiveQuantity") OR
		  isDefined("URL.Replicate")>
		<cfset stRecord = objSerialsTransfers.getDataRecord()>
		<cfset stErrors = objSerialsTransfers.getErrorRecord()>

		<!--- Get a structure of the Transfer header --->
		<cfset strHeader = objICTREH.getRecord(stRecord.TRANFENSEQ)>
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "TRANFENSEQ", stRecord.TRANFENSEQ, True)>
		<cfset structInsert(SearchRecord, "LINENO", stRecord.LINENO, True)>
		<!--- Get a query of the Transfer detail --->
		<cfset qryDetail = objICTRED.searchRecords(SearchRecord, "query")>
	
		<!--- CONSECUTIVE ORDER --->
		<cfif isDefined("URL.ConsecutiveOrder")>
			<cfset objSerialsAdministration = createObject("component", "admin.assets.cfcs.SerialsAdministration")>
			<cfset strSerialsAdministration = objSerialsAdministration.getRecord("RecordNumber1")>
			<cfif NOT structIsEmpty(strSerialsAdministration)>
				<cfset SerialNumberValue = strSerialsAdministration.NextConsecutiveOrderNumber>
				<cfset NumberOfBoxes = qryDetail.QUANTITY>
				<cfloop index="LoopCount" from="1" to="#NumberOfBoxes#">
					<cfset structInsert(stRecord, "SN_#LoopCount#", SerialNumberValue, True)>
					<cfset SerialNumberValue = SerialNumberValue + 1>
				</cfloop>
				<cfset structInsert(strSerialsAdministration, "NextConsecutiveOrderNumber", SerialNumberValue, True)>
				<cfset objSerialsAdministration.saveRecord(strSerialsAdministration)>
			</cfif>

		<!--- CONSECUTIVE ORDER 2 --->
		<cfelseif isDefined("FORM.ConsecutiveQuantity")>
			<cfset stRecord = objSerialsTransfers.consecutiveOrder2(stRecord, FORM.ConsecutiveQuantity)>

		<!--- REPLICATE --->
		<cfelseif isDefined("URL.Replicate")>
			<cfset stRecord = objSerialsTransfers.replicate(stRecord)>

		</cfif>

	<cfelse>
		<!--- Get a structure of the Transfer header --->
		<cfset strHeader = objICTREH.getRecord(URL.TRANFENSEQ)>
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "TRANFENSEQ", URL.TRANFENSEQ, True)>
		<cfset structInsert(SearchRecord, "LINENO", URL.LINENO, True)>
		<!--- Get a query of the Transfer detail --->
		<cfset qryDetail = objICTRED.searchRecords(SearchRecord, "query")>
		
		<!--- Get a query of the serial numbers already entered --->
		<cfset qrySerialsTransfers = objSerialsTransfers.searchRecords(SearchRecord, "query")>
		<cfset stRecord = structNew()>
		<cfset IndexCounter = 1>
		<cfloop query="qrySerialsTransfers">
			<cfset structInsert(stRecord, "SN_#IndexCounter#", qrySerialsTransfers.SerialNumber, True)>
			<cfset IndexCounter = IndexCounter + 1>
		</cfloop>
		<cfset structInsert(stRecord, "TRANFENSEQ", URL.TRANFENSEQ, True)>
		<cfset structInsert(stRecord, "LINENO", URL.LINENO, True)>
		<cfset stErrors = structNew()>
	</cfif>

	<cfset ThisIsABatchNumberItem = 0>
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "ITEMNO", qryDetail.ITEMNO, True)>
	<cfset qryScannerBatchItems = objScannerBatchItems.searchRecords(SearchRecord, "query")>
	<cfif qryScannerBatchItems.RecordCount GT 0>
		<cfset ThisIsABatchNumberItem = 1>
	</cfif>

</cfsilent>

<cfset strScanner = objSerialsTransfers.getScannerSettings("serials_transfers_serials_edit", qryDetail.ITEMNO)>

<script language="javascript">
	window.onload = init;
	function init() {
		window.scanner = new Scanner();
		window.scanner.setSettingsID("settings");
		window.scanner.init();
	}
	function consecutiveOrderButton() {
		disableAllButtons();
		document.detailform.WhichButton.value = "Consecutive Order";
		window.document.detailform.submit();
	}
	function consecutiveOrder2Button() {
		disableAllButtons();
		document.detailform.WhichButton.value = "Consecutive Order 2";
		window.document.detailform.submit();
	}
	function replicateButton() {
		disableAllButtons();
		document.detailform.WhichButton.value = "Replicate";
		window.document.detailform.submit();
	}
	function confirmPost() {
		var msg = "Are you sure you want to Post these serial numbers?";
		if(confirm(msg)) { 
			disableAllButtons();
			document.detailform.WhichButton.value = "Post";
			document.getElementById("Posting").style.visibility = "visible";		
		    window.document.detailform.submit();
		}
		else { return false; }
	}
	function saveAndPostpone() {
		disableAllButtons();
		document.detailform.WhichButton.value = "Save & Postpone";
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
		document.detailform.ConsecutiveOrder.disabled = true;
		document.detailform.ConsecutiveOrder2.disabled = true;
		document.detailform.Replicate.disabled = true;
		document.detailform.ButtonClicked[0].disabled = true;
		document.detailform.ButtonClicked[1].disabled = true;
		document.detailform.ButtonClicked[2].disabled = true;
		document.detailform.ButtonClicked[3].disabled = true;
		return true;
	}
</script>

<cfoutput>


<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">Serial Number Entry</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objSerialsTransfers.getMessage()#</font></td>
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

<cfset NumberOfBoxes = qryDetail.QUANTITY>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	<form action="index.cfm?task=serials_transfers_serials_act&RequestTimeout=6000" method="Post" name="detailform">
	<input type="hidden" name="TRANFENSEQ" value="#stRecord.TRANFENSEQ#">
	<input type="hidden" name="LINENO" value="#stRecord.LINENO#">
	<input type="hidden" name="ITEMNO" value="#qryDetail.ITEMNO#">
	<input type="hidden" name="NumberOfBoxes" value="#NumberOfBoxes#">
	<input type="hidden" name="FROMLOC" value="#qryDetail.FROMLOC#">
	<input type="hidden" name="FRLOCDESC" value="#qryDetail.FRLOCDESC#">
	<input type="hidden" name="TOLOC" value="#qryDetail.TOLOC#">
	<input type="hidden" name="TOLOCDESC" value="#qryDetail.TOLOCDESC#">
	<input type="hidden" name="WhichButton" value="">

	<tr>
		<td valign="middle" class="textmain" colspan="3">

			<input type="submit" name="ConsecutiveOrder" value="Consecutive Order" onclick="return consecutiveOrderButton()">
			<cfif NumberOfBoxes GT 1>
				<input type="submit" name="ConsecutiveOrder2" value="Consecutive Order 2" onclick="return consecutiveOrder2Button()">
			<cfelse>
				<input type="hidden" name="ConsecutiveOrder2" value="">
			</cfif>
			<cfif ThisIsABatchNumberItem AND NumberOfBoxes GT 1>
				<input type="submit" name="Replicate" value="Replicate" onclick="return replicateButton()">
			<cfelse>
				<input type="hidden" name="Replicate" value="">
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
					The item you are transferring is identified as a "Batch Number Item".  Therefore, all serial number boxes must contain the same value.  This must be corrected before posting.
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
	<cfif structKeyExists(stErrors, "Replicate")>
		<tr>
			<td valign="top" class="textmain" colspan="3">
				<font color="FF0000">
					#stErrors.Replicate#
				</font>
			</td>
		</tr>
	</cfif>

<!---<cfset NumberOfBoxes = qryDetail.QUANTITY>--->

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
			<td width="30%"><!--- "POST" BUTTON --->
				<input type="submit" name="ButtonClicked" value="Post" onclick="return confirmPost()">
			</td>
			<td><!--- "SAVE & POSTPONE" BUTTON --->
				<input type="submit" name="ButtonClicked" value="Save & Postpone" onclick="return saveAndPostpone()">
			</td>
			<td><!--- "CLEAR ALL" BUTTON --->
				<input type="submit" name="ButtonClicked" value="Clear All" onclick="return confirmClearAll()">
			</td>
			<td><!--- "CANCEL" BUTTON --->
				<input type="submit" name="ButtonClicked" value="Cancel" onclick="return confirmCancel()">
			</td>
		</tr>
		<tr id="Posting" style="visibility:hidden;">
			<td valign="top" colspan="4" align="center" class="textmain">
				<font color="FF0000">Posting Serial Numbers - Please Wait</font>
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
<div id="settings" style="display:none;">#objSerialsTransfers.jsonEncode(strScanner)#</div>
</cfoutput>