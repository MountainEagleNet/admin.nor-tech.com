<!---<cfsilent>--->
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/21/2006
	Function: 		This page displays a form for entering serial numbers for a chosen receipt item
	Template:		frmSerials.cfm
	Task:			serials_receipts_serials_edit
--->
	<cfset objPORCPH1 = createObject("component", "admin.assets.cfcs.PORCPH1")>
	<cfset objPORCPL = createObject("component", "admin.assets.cfcs.PORCPL")>
	<cfset objSerialsReceipts = createObject("component", "admin.assets.cfcs.SerialsReceipts")>
	<cfset objPrintBarCodeItems = createObject("component", "admin.assets.cfcs.PrintBarCodeItems")>
	<cfset objScannerBatchItems = createObject("component", "admin.assets.cfcs.ScannerBatchItems")>

	<cfset ThePrintBarCodeBoxIsChecked = 0>
	<cfif isDefined("URL.Validation") OR 
		  isDefined("FORM.NumberToAdd") OR 
		  isDefined("URL.ConsecutiveOrder") OR 
		  isDefined("FORM.ConsecutiveQuantity") OR
		  isDefined("URL.Replicate") OR
		  isDefined("URL.ConsecutiveOrder3")>
		<cfset stRecord = objSerialsReceipts.getDataRecord()>
		<cfset stErrors = objSerialsReceipts.getErrorRecord()>
		
		<cfset StartBoxNumber = stRecord.StartBoxNumber>
		<cfset EndBoxNumber = stRecord.EndBoxNumber>
		<cfset NumberOfBoxes = stRecord.NumberOfBoxes>

		<!--- Print Bar Code Labels Checkbox --->
		<cfif structKeyExists(stRecord, "PrintBarCodeLabels") AND stRecord.PrintBarCodeLabels EQ 1> 
			<cfset ThePrintBarCodeBoxIsChecked = 1>
		</cfif>

		<!--- Get a structure of the Receipt header --->
		<cfset strHeader = objPORCPH1.getRecord(stRecord.RCPHSEQ)>
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "RCPHSEQ", stRecord.RCPHSEQ, True)>
		<cfset structInsert(SearchRecord, "RCPLREV", stRecord.RCPLREV, True)>
		
		<!--- Get a query of the Receipt detail --->
		<cfset qryDetail = objPORCPL.searchRecords(SearchRecord, "query")>

		<!--- "Add" was clicked to add more serial number boxes --->
		<cfif isDefined("FORM.NumberToAdd") AND isNumeric(FORM.NumberToAdd) AND FORM.NumberToAdd GT 0>
			<cfset NumberOfBoxes = NumberOfBoxes + int(FORM.NumberToAdd)>
			<cfset EndBoxNumber = EndBoxNumber + int(FORM.NumberToAdd)>
		</cfif>
		
		<cfset TotalNumberOfSNs = qryDetail.RQRECEIVED>
		
		<!--- CONSECUTIVE ORDER --->
		<cfif isDefined("URL.ConsecutiveOrder")>
			<cfset objSerialsAdministration = createObject("component", "admin.assets.cfcs.SerialsAdministration")>
			<cfset strSerialsAdministration = objSerialsAdministration.getRecord("RecordNumber1")>
			<cfif NOT structIsEmpty(strSerialsAdministration)>
				<cfset SerialNumberValue = strSerialsAdministration.NextConsecutiveOrderNumber>
				<cfloop index="LoopCount" from="#StartBoxNumber#" to="#EndBoxNumber#">
					<cfset structInsert(stRecord, "SN_#LoopCount#", SerialNumberValue, True)>
					<cfset SerialNumberValue = SerialNumberValue + 1>
				</cfloop>
				<cfset structInsert(strSerialsAdministration, "NextConsecutiveOrderNumber", SerialNumberValue, True)>
				<cfset objSerialsAdministration.saveRecord(strSerialsAdministration)>
			</cfif>

		<!--- CONSECUTIVE ORDER 2 --->
		<cfelseif isDefined("FORM.ConsecutiveQuantity")>
			<cfset stRecord = objSerialsReceipts.consecutiveOrder2(stRecord, FORM.ConsecutiveQuantity)>

		<!--- CONSECUTIVE ORDER 3 --->
		<cfelseif isDefined("URL.ConsecutiveOrder3")>
			<cfset stRecord = objSerialsReceipts.consecutiveOrder3(stRecord)>

		<!--- REPLICATE --->
		<cfelseif isDefined("URL.Replicate")>
			<cfset stRecord = objSerialsReceipts.replicate(stRecord)>


		</cfif>

	<cfelse>
		<!--- Get a structure of the Receipt header --->
		<cfset strHeader = objPORCPH1.getRecord(URL.RCPHSEQ)>
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "RCPHSEQ", URL.RCPHSEQ, True)>
		<cfset structInsert(SearchRecord, "RCPLREV", URL.RCPLREV, True)>
		
		<!--- Get a query of the Receipt detail --->
		<cfset qryDetail = objPORCPL.searchRecords(SearchRecord, "query")>
		
		<cfset BoxesPerPage = 200>
		
		<cfset StartBoxNumber = 1>
		<cfif isDefined("URL.StartBoxNumber")>
			<cfset StartBoxNumber = URL.StartBoxNumber>
		<cfelse>
			<!--- If serial numbers were previously saved with "Save and Postpone", set the starting box number appropriately --->
			<cfset structInsert(SearchRecord, "Posted", 0, True)>
			<cfset qrySavedSns = objSerialsReceipts.searchRecords(SearchRecord, "query")>
			<cfif qrySavedSns.RecordCount GT 0>
				<cfset CurrentPage = ceiling((qrySavedSns.RecordCount + 1)/BoxesPerPage)>
				<cfset StartBoxNumber = ((CurrentPage - 1) * BoxesPerPage) + 1>			
			</cfif>
		</cfif>
		
<!---	<cfset EndBoxNumber = StartBoxNumber + 199>	--->
		<cfset EndBoxNumber = StartBoxNumber + BoxesPerPage - 1>
		<cfset TotalNumberOfSNs = qryDetail.RQRECEIVED>

		<cfset RemainingQuantity = objSerialsReceipts.getRemainingQuantity(URL.RCPHSEQ, URL.RCPLREV)>
		
<!---	<cfif EndBoxNumber GT TotalNumberOfSNs>	--->
		<cfif EndBoxNumber GT RemainingQuantity>
<!---		<cfset EndBoxNumber = TotalNumberOfSNs>	--->
			<cfset EndBoxNumber = RemainingQuantity>
		</cfif>
		<cfset NumberOfBoxes = EndBoxNumber - StartBoxNumber + 1>

		<!--- Get a query of the serial numbers already entered --->
		<cfset structInsert(SearchRecord, "StartBoxNumber", StartBoxNumber, True)>
		<cfset structInsert(SearchRecord, "EndBoxNumber", EndBoxNumber, True)>
		<cfset qrySerialsReceipts = objSerialsReceipts.getSerialNumbers(SearchRecord)>
		<cfset stRecord = structNew()>
		<cfset IndexCounter = StartBoxNumber>
		<cfloop query="qrySerialsReceipts">
			<cfif qrySerialsReceipts.Posted NEQ 1>
				<cfset structInsert(stRecord, "SN_#IndexCounter#", qrySerialsReceipts.SerialNumber, True)>
				<cfset IndexCounter = IndexCounter + 1>
			</cfif>
		</cfloop>
		<cfset structInsert(stRecord, "RCPHSEQ", URL.RCPHSEQ, True)>
		<cfset structInsert(stRecord, "RCPLREV", URL.RCPLREV, True)>



		<cfset stErrors = structNew()>
		
		<!--- Print Bar Code Labels Checkbox --->
		<cfif isDefined("URL.PrintBarCodeLabels") AND URL.PrintBarCodeLabels EQ 1> 
			<cfset ThePrintBarCodeBoxIsChecked = 1>
		<cfelse>
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "ITEMNO", qryDetail.ITEMNO, True)>
			<cfset qryPrintBarCodeItems = objPrintBarCodeItems.searchRecords(SearchRecord, "query")>
			<cfif qryPrintBarCodeItems.RecordCount GT 0>
				<cfset ThePrintBarCodeBoxIsChecked = 1>
			</cfif>
		</cfif>
		
	</cfif>

	<cfif NOT isDefined("RemainingQuantity")>
		<cfset RemainingQuantity = objSerialsReceipts.getRemainingQuantity(qryDetail.RCPHSEQ, qryDetail.RCPLREV)>
	</cfif>
	
<!---<cfif EndBoxNumber LT TotalNumberOfSNs>--->
	<cfif EndBoxNumber LT RemainingQuantity>
		<cfset ReadyToPost = 0>
	<cfelse>
		<cfset ReadyToPost = 1>
	</cfif>
	
	<cfset ThisIsABatchNumberItem = 0>
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "ITEMNO", qryDetail.ITEMNO, True)>
	<cfset qryScannerBatchItems = objScannerBatchItems.searchRecords(SearchRecord, "query")>
	<cfif qryScannerBatchItems.RecordCount GT 0>
		<cfset ThisIsABatchNumberItem = 1>
	</cfif>

<!---</cfsilent>--->

<cfset strScanner = objSerialsReceipts.getScannerSettings("serials_receipts_serials_edit", qryDetail.ITEMNO)>

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
	function consecutiveOrder3Button() {
		disableAllButtons();
		document.detailform.WhichButton.value = "Consecutive Order 3";
		window.document.detailform.submit();
	}
	function replicateButton() {
		disableAllButtons();
		document.detailform.WhichButton.value = "Replicate";
		window.document.detailform.submit();
	}
	function clearDuplicatesButton() {
		disableAllButtons();
		document.detailform.WhichButton.value = "Clear Duplicates";
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
	function addButton() {
		disableAllButtons();
		document.detailform.WhichButton.value = "Add";
		window.document.detailform.submit();
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
		document.detailform.ConsecutiveOrder3.disabled = true;
		document.detailform.Replicate.disabled = true;
		document.detailform.ClearDuplicates.disabled = true;
		document.detailform.ButtonClicked[0].disabled = true;
		document.detailform.ButtonClicked[1].disabled = true;
		document.detailform.ButtonClicked[2].disabled = true;
		document.detailform.ButtonClicked[3].disabled = true;
		document.detailform.ButtonClicked[4].disabled = true;
		return true;
	}
</script>

<cfoutput>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">Serial Number Entry</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objSerialsReceipts.getMessage()#</font></td>
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

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	<form action="index.cfm?task=serials_receipts_serials_act&RequestTimeout=6000" method="Post" name="detailform">
	<input type="hidden" name="RCPHSEQ" value="#stRecord.RCPHSEQ#">
	<input type="hidden" name="RCPLREV" value="#stRecord.RCPLREV#">
	<input type="hidden" name="ITEMNO" value="#qryDetail.ITEMNO#">
	<input type="hidden" name="LOCATION" value="#qryDetail.LOCATION#">
	<input type="hidden" name="NumberOfBoxes" value="#NumberOfBoxes#">
	<input type="hidden" name="RQRECEIVED" value="#qryDetail.RQRECEIVED#">
	<input type="hidden" name="StartBoxNumber" value="#StartBoxNumber#">
	<input type="hidden" name="EndBoxNumber" value="#EndBoxNumber#">
	<input type="hidden" name="ReadyToPost" value="#ReadyToPost#">
	<input type="hidden" name="WhichButton" value="">

	<tr>
		<td valign="top" class="textmain" colspan="3">
			<b>Print bar codes labels for these items?</b>
			<input type="checkbox" name="PrintBarCodeLabels" value="1"
				<cfif ThePrintBarCodeBoxIsChecked> 
					checked
				</cfif>
			>
		</td>
	</tr>

	<tr>
		<td valign="middle" class="textmain" colspan="3">

			<input type="submit" name="ConsecutiveOrder" value="Consecutive Order" onClick="return consecutiveOrderButton()">			
			<cfif NumberOfBoxes GT 1>
				<input type="submit" name="ConsecutiveOrder2" value="Consecutive Order 2" onclick="return consecutiveOrder2Button()">
			<cfelse>
				<input type="hidden" name="ConsecutiveOrder2" value="">
			</cfif>
			<cfif NumberOfBoxes GT 1 AND NOT ThisIsABatchNumberItem>
				<input type="submit" name="ConsecutiveOrder3" value="Consecutive Order 3" onclick="return consecutiveOrder3Button()">
			<cfelse>
				<input type="hidden" name="ConsecutiveOrder3" value="">
			</cfif>
			<cfif ThisIsABatchNumberItem AND NumberOfBoxes GT 1>
				<input type="submit" name="Replicate" value="Replicate & Post" onclick="return replicateButton()">
			<cfelse>
				<input type="hidden" name="Replicate" value="">
			</cfif>
		</td>			
	</tr>
	<tr><td>&nbsp;</td></tr>
	
	<tr>
		<td valign="top" class="textmain" colspan="3"><b>Serial Numbers:</b></td>
	</tr>
	
	<cfif structKeyExists(stErrors, "DuplicatesFound")>
		<tr>
			<td valign="top" class="textmain" colspan="3">
				<font color="FF0000">
					Duplicate Serial Numbers were found.<br>
					The red box(es) below indicates the serial number was already scanned in a previous pass. This must be fixed before posting.<br>
					Click the following button to clear and rescan these fields:
				</font>
				<input type="submit" name="ClearDuplicates" value="Clear Duplicates" onclick="return clearDuplicatesButton()">
			</td>
		</tr>
	<cfelse>
		<input type="hidden" name="ClearDuplicates" value="">
	</cfif>
	<cfif structKeyExists(stErrors, "BatchItemError")>
		<tr>
			<td valign="top" class="textmain" colspan="3">
				<font color="FF0000">
					The item you are receiving is identified as a "Batch Number Item".  Therefore, all serial number boxes must contain the same value.  This must be corrected before posting.
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

	<cfset FirstSNField = "">
	<cfset FirstBlankSNField = "">
	<cfloop index="LoopCount" from="#StartBoxNumber#" to="#EndBoxNumber#">
		<tr>
			<td valign="middle" class="textmain" width="15%" align="center" style="font-size:8px">#LoopCount#</td>
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
			
			<td valign="middle" class="textmain">
				<input name="#SNColumn#" value="#SNColumnValue#" size="50" maxlength="50" tabindex="#LoopCount#" onkeydown="return window.scanner.doKeyDown();" onkeypress="return window.scanner.doKeyPress();" onkeyup="return window.scanner.doKeyUp();" style="#SNStyle#"/>
			</td>

			<cfif FirstSNField IS "">
				<cfset FirstSNField = SNColumn>
			</cfif>
			<cfif FirstBlankSNField IS "" AND SNColumnValue IS "">
				<cfset FirstBlankSNField = SNColumn>
			</cfif>
		</tr>
	</cfloop>

	<tr>
	<td valign="top" colspan="3" align="center">
		<table cellpadding="4" cellspacing="0" border="0" width="80%">
		<tr><td>&nbsp;</td></tr>
		<tr>
		
			<td width="30%"><!--- "POST"/"CONTINUE" BUTTON --->
				<cfif ReadyToPost>
					<input type="submit" name="ButtonClicked" value="Post" onclick="return confirmPost()">
				<cfelse>
					<input type="submit" name="ButtonClicked" value="&nbsp;Continue -&raquo;" onclick="return confirmPost()">
				</cfif>
			</td>

			<td><!--- "SAVE & POSTPONE" BUTTON --->
				<input type="submit" name="ButtonClicked" value="Save & Postpone" onclick="return saveAndPostpone()">
			</td>
			<td><!--- "CLEAR ALL" BUTTON --->
				<input type="submit" name="ButtonClicked" value="Clear All" onclick="return confirmClearAll()">
			</td>
			<td><!--- "ADD" BUTTON --->
				<input type="submit" name="ButtonClicked" value="Add" onclick="return addButton()">
			</td>
			<td><!--- "CANCEL" BUTTON --->
				<input type="submit" name="ButtonClicked" value="Cancel" onclick="return confirmCancel()">
			</td>
		</tr>
		<tr id="Posting" style="visibility:hidden;">
			<td valign="top" colspan="5" align="center" class="textmain">
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
<div id="settings" style="display:none;">#objSerialsReceipts.jsonEncode(strScanner)#</div>
</cfoutput>