
<!--- TEMP --->
<!---
<cfsilent>
--->
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/26/2006
	Edit Date: 		10/12/2006
	Function: 		This page displays a form for entering serial numbers for a chosen order item
	Template:		frmSerials.cfm
	Task:			serials_shipments_serials_edit
--->
	<cfset objOEORDH = createObject("component", "admin.assets.cfcs.OEORDH")>
	<cfset objOEORDD = createObject("component", "admin.assets.cfcs.OEORDD")>
	<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>
	<cfset objScannerBatchItems = createObject("component", "admin.assets.cfcs.ScannerBatchItems")>

	<cfif isDefined("URL.Validation") OR 
		  isDefined("FORM.ConsecutiveQuantity") 
<!---
		  OR
		  isDefined("URL.Replicate")	
		  isDefined("FORM.ReplicateQuantity")
--->
		  OR
		  isDefined("URL.ConsecutiveOrder3")>
		  
		<cfset stRecord = objSerialsShipments.getDataRecord()>
		<cfset stErrors = objSerialsShipments.getErrorRecord()>

		<cfif isDefined("URL.ConsecutiveOrder3")>
			<cfset StartBoxNumber = stRecord.StartBoxNumberCons3>
            <cfset EndBoxNumber = stRecord.StartBoxNumberCons3 + stRecord.NumberOfBoxes -1>
            <cfset NumberOfBoxes = stRecord.NumberOfBoxes>
        <cfelse>
			<cfset StartBoxNumber = stRecord.StartBoxNumber>
            <cfset EndBoxNumber = stRecord.EndBoxNumber>
            <cfset NumberOfBoxes = stRecord.NumberOfBoxes>
        </cfif>

		<!--- Get a structure of the Order header --->
		<cfset strHeader = objOEORDH.getRecord(stRecord.ORDUNIQ)>	
		
		<!--- Get a query of the Order detail --->
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ORDUNIQ", stRecord.ORDUNIQ, True)>
		<cfset structInsert(SearchRecord, "LINENUM", stRecord.ORDLINENUM, True)>
		<cfset qryDetail = objOEORDD.searchRecords(SearchRecord, "query")>

<!---
		<cfset NumberOfBoxes = stRecord.NumberOfBoxes>				<!---RAB--->
		<cfset RemainingQuantity = stRecord.RemainingQuantity>		<!---RAB--->
--->

		<cfset TotalNumberOfSNs = qryDetail.QTYORDERED + qryDetail.QTYSHPTODT>

		<!--- CONSECUTIVE ORDER 2 --->
		<cfif isDefined("FORM.ConsecutiveQuantity")>
			<cfset stRecord = objSerialsShipments.consecutiveOrder2(stRecord, FORM.ConsecutiveQuantity)>

		<!--- CONSECUTIVE ORDER 3 --->
		<cfelseif isDefined("URL.ConsecutiveOrder3")>
			<cfset stRecord = objSerialsShipments.consecutiveOrder3(stRecord)>

<!---
		<!--- REPLICATE --->
<!---	<cfelseif isDefined("URL.Replicate")>	--->
		<cfelseif isDefined("FORM.ReplicateQuantity")>
<!---		<cfset stRecord = objSerialsShipments.replicate(stRecord)>	--->
			<cfset stRecord = objSerialsShipments.replicate(stRecord, FORM.ReplicateQuantity)>
--->

		</cfif>

	<cfelse>
		<!--- Get a structure of the Order header --->
		<cfset strHeader = objOEORDH.getRecord(URL.ORDUNIQ)>
		
		<!--- Get a query of the Order detail --->
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ORDUNIQ", URL.ORDUNIQ, True)>
		<cfset structInsert(SearchRecord, "LINENUM", URL.LINENUM, True)>
		<cfset qryDetail = objOEORDD.searchRecords(SearchRecord, "query")>
		
		<cfset BoxesPerPage = 200>

		<cfset StartBoxNumber = 1>
		<cfif isDefined("URL.StartBoxNumber")>
			<cfset StartBoxNumber = URL.StartBoxNumber>
		<cfelse>
			<!--- If serial numbers were previously saved with "Save and Postpone", set the starting box number appropriately --->
			<cfset structInsert(SearchRecord, "Posted", 0, True)>
			<cfset qrySavedSns = objSerialsShipments.searchRecords(SearchRecord, "query")>
			<cfif qrySavedSns.RecordCount GT 0>
				<cfset CurrentPage = ceiling((qrySavedSns.RecordCount + 1)/BoxesPerPage)>
				<cfset StartBoxNumber = ((CurrentPage - 1) * BoxesPerPage) + 1>			
			</cfif>
		</cfif>

		<cfset EndBoxNumber = StartBoxNumber + BoxesPerPage - 1>
		<cfset TotalNumberOfSNs = qryDetail.QTYORDERED + qryDetail.QTYSHPTODT>

		<cfset RemainingQuantity = objSerialsShipments.getRemainingQuantity(URL.ORDUNIQ, URL.LINENUM)>
		
		<cfif EndBoxNumber GT RemainingQuantity>
			<cfset EndBoxNumber = RemainingQuantity>
		</cfif>
		<cfset NumberOfBoxes = EndBoxNumber - StartBoxNumber + 1>

		<!--- Get a query of the serial numbers already entered --->
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ORDUNIQ", URL.ORDUNIQ, True)>
		<cfset structInsert(SearchRecord, "ORDLINENUM", URL.LINENUM, True)>
<!---	<cfset structInsert(SearchRecord, "Posted", 0, True)>	--->
		<cfset structInsert(SearchRecord, "StartBoxNumber", StartBoxNumber, True)>
		<cfset structInsert(SearchRecord, "EndBoxNumber", EndBoxNumber, True)>
		<cfset qrySerialsShipments = objSerialsShipments.searchRecords(SearchRecord, "query", "BoxNumber")>
<!---
qrySerialsShipments:<cfdump var="#qrySerialsShipments#"><br />
--->
		<cfset stRecord = structNew()>
        
		<!--- RAB 8/22/2012 --->        
        <cfif NOT isDefined("URL.LargeQuantity")>
			<cfset IndexCounter = StartBoxNumber>
            <cfloop query="qrySerialsShipments">
                <cfif qrySerialsShipments.Posted NEQ 1>
                    <cfset structInsert(stRecord, "SN_#IndexCounter#", qrySerialsShipments.SerialNumber, True)>
                    <cfset IndexCounter = IndexCounter + 1>
                </cfif>
            </cfloop>
        </cfif>

		<cfset structInsert(stRecord, "ORDUNIQ", URL.ORDUNIQ, True)>
		<cfset structInsert(stRecord, "ORDLINENUM", URL.LINENUM, True)>



		<cfset stErrors = structNew()>

<!---
		<!--- Determine the amount remaining to ship --->
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ORDUNIQ", stRecord.ORDUNIQ, True)>
		<cfset structInsert(SearchRecord, "ORDLINENUM", stRecord.ORDLINENUM, True)>
		<cfset structInsert(SearchRecord, "Posted", 1, True)>
	<!---<cfset structInsert(SearchRecord, "AttachedToInvoice", 1, True)>	--->
		<cfset qrySerialsShipmentsAttached = objSerialsShipments.searchRecords(SearchRecord, "query")>
	<!---<cfset RemainingQuantity = int(qryDetail.ORIGQTY - qrySerialsShipmentsAttached.RecordCount)>--->
		<cfif NOT isNumeric(qryDetail.QTYORDERED)><cfset qryDetail.QTYORDERED = 0></cfif>
		<cfif NOT isNumeric(qryDetail.QTYSHPTODT)><cfset qryDetail.QTYSHPTODT = 0></cfif>
		<cfset RemainingQuantity = int((qryDetail.QTYORDERED + qryDetail.QTYSHPTODT) - qrySerialsShipmentsAttached.RecordCount)>
	
		<cfset NumberOfBoxes = RemainingQuantity>
--->

	</cfif>

	<cfif NOT isDefined("RemainingQuantity")>
		<cfset RemainingQuantity = objSerialsShipments.getRemainingQuantity(qryDetail.ORDUNIQ, qryDetail.LINENUM)>
	</cfif>
	
	<cfif EndBoxNumber LT RemainingQuantity>
		<cfset ReadyToPost = 0>
	<cfelse>
		<cfset ReadyToPost = 1>
	</cfif>
<!---	
    <!--- RAB 8/22/2012--->
    <cfif isDefined("URL.LargeQuantity")>
    	<cfset LargeQuantity = URL.LargeQuantity>
	<cfelse>        
    	<cfset LargeQuantity = 0>
    </cfif>

LargeQuantity:<cfdump var="#LargeQuantity#"><br />
--->    
    
	<cfset ThisIsABatchNumberItem = 0>
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "ITEMNO", qryDetail.ITEM, True)>
	<cfset qryScannerBatchItems = objScannerBatchItems.searchRecords(SearchRecord, "query")>
	<cfif qryScannerBatchItems.RecordCount GT 0>
		<cfset ThisIsABatchNumberItem = 1>
	</cfif>

<!--- TEMP --->
<!---
</cfsilent>
--->
<cfset strScanner = objSerialsShipments.getScannerSettings("serials_shipments_serials_edit", qryDetail.ITEM)>

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
	<td valign="top" class="textmain"><font color="FF0000">#objSerialsShipments.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<!--- ORDER INFORMATION --->
	<cfinclude template="headerInfo.cfm">
	<!--- DETAIL INFORMATION --->
	<cfinclude template="detailInfo.cfm">
</td>
</tr>
<tr><td>&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	<form action="index.cfm?task=serials_shipments_serials_act&RequestTimeout=6000" method="Post" name="detailform">
	<input type="hidden" name="ORDUNIQ" value="#stRecord.ORDUNIQ#">
	<input type="hidden" name="ORDLINENUM" value="#stRecord.ORDLINENUM#">
	<input type="hidden" name="ITEM" value="#qryDetail.ITEM#">
	<input type="hidden" name="LOCATION" value="#qryDetail.LOCATION#">
	<input type="hidden" name="ORDNUMBER" value="#strHeader.ORDNUMBER#">
	<input type="hidden" name="NumberOfBoxes" value="#NumberOfBoxes#">
	<input type="hidden" name="StartBoxNumber" value="#StartBoxNumber#">
	<input type="hidden" name="EndBoxNumber" value="#EndBoxNumber#">
	<input type="hidden" name="ReadyToPost" value="#ReadyToPost#">
	<input type="hidden" name="RemainingQuantity" value="#RemainingQuantity#">
	<input type="hidden" name="WhichButton" value="">

	<!--- RAB 8/22/2012 --->
<!---  <input type="hidden" name="LargeQuantity" value="#LargeQuantity#">	--->


	<tr>
		<td valign="middle" class="textmain" colspan="2">
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
					Duplicate Serial Numbers were entered in two or more boxes.<br>These must be fixed before posting.
				</font>
			</td>
		</tr>
	</cfif>
	<cfif structKeyExists(stErrors, "BatchItemError")>
		<tr>
			<td valign="top" class="textmain" colspan="3">
				<font color="FF0000">
					The item you are shipping is identified as a "Batch Number Item".  Therefore, all serial number boxes must contain the same value.  This must be corrected before posting.
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

<!---
	<cfset NumberOfBoxes = qryDetail.QTYSHIPPED>
--->
<!---<cfset NumberOfBoxes = RemainingQuantity>	--->

<!--- TEMP --->
<!---
<tr>
<td colspan="3">
StartBoxNumber:<cfdump var="#StartBoxNumber#"><br />
EndBoxNumber:<cfdump var="#EndBoxNumber#"><br />

ReadyToPost:<cfdump var="#ReadyToPost#"><br />

stRecord:<cfdump var="#stRecord#"><br />
</td>
</tr>
--->
	<cfset FirstSNField = "">
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
<div id="settings" style="display:none;">#objSerialsShipments.jsonEncode(strScanner)#</div>
</cfoutput>