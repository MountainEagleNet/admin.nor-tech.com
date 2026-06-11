<!---<cfsilent>--->
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/08/2006
	Function: 		This page displays a form for entering serial numbers for the count
	Template:		frmSerials.cfm
	Task:			serials_counts_serials_edit
--->
	<cfset objSerialsCounts = createObject("component", "admin.assets.cfcs.SerialsCounts")>
	<cfset objCounts = createObject("component", "admin.assets.cfcs.Counts")>
	<cfset objScannerBatchItems = createObject("component", "admin.assets.cfcs.ScannerBatchItems")>

<!---	<cfset stRecord = objSerialsCounts.getDataRecord()>	--->

	<cfif isDefined("URL.Validation") OR 
		  isDefined("FORM.NumberToAdd") OR 
		  isDefined("FORM.ConsecutiveQuantity") OR
		  isDefined("URL.Replicate") OR
		  isDefined("URL.ConsecutiveOrder3")>
		<cfset stRecord = objSerialsCounts.getDataRecord()>
		<cfset stErrors = objSerialsCounts.getErrorRecord()>

		<cfset StartBoxNumber = stRecord.StartBoxNumber>
		<cfset EndBoxNumber = stRecord.EndBoxNumber>
		<cfset NumberOfBoxes = stRecord.NumberOfBoxes>

		<!--- "Add" was clicked to add more serial number boxes --->
		<cfif isDefined("FORM.NumberToAdd") AND isNumeric(FORM.NumberToAdd) AND FORM.NumberToAdd GT 0>
			<cfset NumberOfBoxes = NumberOfBoxes + int(FORM.NumberToAdd)>
			<cfset EndBoxNumber = EndBoxNumber + int(FORM.NumberToAdd)>
		</cfif>
		
		<cfset TotalNumberOfSNs = stRecord.QUANTITY>

		<!--- CONSECUTIVE ORDER 2 --->
		<cfif isDefined("FORM.ConsecutiveQuantity")>
			<cfset stRecord = objSerialsCounts.consecutiveOrder2(stRecord, FORM.ConsecutiveQuantity)>

		<!--- CONSECUTIVE ORDER 3 --->
		<cfelseif isDefined("URL.ConsecutiveOrder3")>
			<cfset stRecord = objSerialsCounts.consecutiveOrder3(stRecord)>
		</cfif>

		<!--- REPLICATE --->
		<cfif isDefined("URL.Replicate")>
			<cfset stRecord = objSerialsCounts.replicate(stRecord)>
		</cfif>
		
	<cfelse>
		<cfset stErrors = structNew()>
		<cfif isDefined("URL.CountsID")>
			<cfset stRecord = objCounts.getRecord(URL.CountsID)>

<!---			
			<!--- Get a query of the serial numbers already entered --->
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "CountsID", URL.CountsID, True)>
			<cfset qrySerialsCounts = objSerialsCounts.searchRecords(SearchRecord, "query", "SortOrder")>
			<cfset IndexCounter = 1>
			<cfloop query="qrySerialsCounts">
				<cfset structInsert(stRecord, "SN_#IndexCounter#", qrySerialsCounts.SerialNumber, True)>
				<cfset IndexCounter = IndexCounter + 1>
			</cfloop>

			<cfif qrySerialsCounts.RecordCount GT stRecord.Quantity>
				<cfset NumberOfBoxes = qrySerialsCounts.RecordCount>
			<cfelseif isDefined("URL.NumberOfBoxes")>
				<cfset NumberOfBoxes = URL.NumberOfBoxes>
			<cfelse>
				<cfset NumberOfBoxes = stRecord.Quantity>
			</cfif>
--->
			
		<cfelse>
			<cfset stRecord = objSerialsCounts.getDataRecord()>
<!---		<cfset NumberOfBoxes = stRecord.QUANTITY>	--->
		</cfif>

		
<!--- 3/22/07 --->		
		<cfset StartBoxNumber = 1>
		<cfif isDefined("URL.StartBoxNumber")>
			<cfset StartBoxNumber = URL.StartBoxNumber>
		</cfif>
		<cfset EndBoxNumber = StartBoxNumber + 199>
<!---	<cfset EndBoxNumber = StartBoxNumber + 9>	--->
		<cfset TotalNumberOfSNs = stRecord.QUANTITY>
		<cfif EndBoxNumber GT TotalNumberOfSNs>
			<cfset EndBoxNumber = TotalNumberOfSNs>
		</cfif>
		<cfset NumberOfBoxes = EndBoxNumber - StartBoxNumber + 1>
		<!--- Get a query of the serial numbers already entered --->
<!---
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "CountsID", URL.CountsID, True)>
		<cfset qrySerialsCounts = objSerialsCounts.searchRecords(SearchRecord, "query", "SortOrder")>
--->
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "StartBoxNumber", StartBoxNumber, True)>
		<cfset structInsert(SearchRecord, "EndBoxNumber", EndBoxNumber, True)>
		<cfset structInsert(SearchRecord, "CountsID", stRecord.CountsID, True)>
		<cfset qrySerialsCounts = objSerialsCounts.getSerialNumbers(SearchRecord)>

<!---	<cfset IndexCounter = 1>	--->
		<cfset IndexCounter = StartBoxNumber>
		<cfloop query="qrySerialsCounts">
			<cfset structInsert(stRecord, "SN_#IndexCounter#", qrySerialsCounts.SerialNumber, True)>
			<cfset IndexCounter = IndexCounter + 1>
		</cfloop>
		
	</cfif>

	<cfif EndBoxNumber LT TotalNumberOfSNs>
		<cfset ReadyToPost = 0>
	<cfelse>
		<cfset ReadyToPost = 1>
	</cfif>
	
	<cfset ThisIsABatchNumberItem = 0>
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "ITEMNO", stRecord.ITEMNO, True)>
	<cfset qryScannerBatchItems = objScannerBatchItems.searchRecords(SearchRecord, "query")>
	<cfif qryScannerBatchItems.RecordCount GT 0>
		<cfset ThisIsABatchNumberItem = 1>
	</cfif>
	
<!---</cfsilent>--->

<cfset strScanner = objSerialsCounts.getScannerSettings("serials_counts_serials_edit", stRecord.ITEMNO)>

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
		document.detailform.ConsecutiveOrder2.disabled = true;
		document.detailform.ConsecutiveOrder3.disabled = true;
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
	<td valign="top" class="textmain"><font color="FF0000">#objSerialsCounts.getMessage()#</font></td>
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
	<form action="index.cfm?task=serials_counts_serials_act&RequestTimeout=6000" method="Post" name="detailform">
	<input type="hidden" name="CountsID" value="#stRecord.CountsID#">
	<input type="hidden" name="ITEMNO" value="#stRecord.ITEMNO#">
	<input type="hidden" name="Quantity" value="#stRecord.Quantity#">
	<input type="hidden" name="LOCATION" value="#stRecord.LOCATION#">
	<input type="hidden" name="NumberOfBoxes" value="#NumberOfBoxes#">
	<input type="hidden" name="StartBoxNumber" value="#StartBoxNumber#">
	<input type="hidden" name="EndBoxNumber" value="#EndBoxNumber#">
	<input type="hidden" name="ReadyToPost" value="#ReadyToPost#">
	<input type="hidden" name="WhichButton" value="">

	<tr>
		<td valign="middle" class="textmain" colspan="3">
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
					Duplicate Serial Numbers were found.<br>
					The red box(es) below indicates the serial number was already scanned in a previous pass. This must be fixed before posting.<br>
				</font>
			</td>
		</tr>
	</cfif>
	<cfif structKeyExists(stErrors, "BatchItemError")>
		<tr>
			<td valign="top" class="textmain" colspan="3">
				<font color="FF0000">
					The item you are counting is identified as a "Batch Number Item".  Therefore, all serial number boxes must contain the same value.  This must be corrected before posting.
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
<!---<cfloop index="LoopCount" from="1" to="#NumberOfBoxes#">--->
	<cfloop index="LoopCount" from="#StartBoxNumber#" to="#EndBoxNumber#">
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
		<table cellpadding="4" cellspacing="0" border="0" width="75%">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<!--- "POST" BUTTON --->
			<td width="30%">
				<cfif ReadyToPost>
					<input type="submit" name="ButtonClicked" value="Post" onclick="return confirmPost()">
				<cfelse>
					<input type="submit" name="ButtonClicked" value="&nbsp;Continue -&raquo;" onclick="return confirmPost()">
				</cfif>
			</td>

			<!--- "SAVE & POSTPONE" BUTTON --->
			<td>
				<input type="submit" name="ButtonClicked" value="Save & Postpone" onclick="return saveAndPostpone()">
			</td>
			
			<!--- "ADD" BUTTON --->
			<td align="center">
				<input type="submit" name="ButtonClicked" value="Add" onclick="return addButton()">
			</td>
			<!--- "CANCEL" BUTTON --->
			<td align="right">
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
<div id="settings" style="display:none;">#objSerialsCounts.jsonEncode(strScanner)#</div>
</cfoutput>