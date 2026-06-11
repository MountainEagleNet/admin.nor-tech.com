<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/07/2007
	Function: 		Consecutive Order 3 Function, Enter Serial Numbers 
	Template:		frmCons3Serials.cfm
	Task:			serials_receipts_consec3_serials
--->
<cfset objPORCPH1 = createObject("component", "admin.assets.cfcs.PORCPH1")>
<cfset objPORCPL = createObject("component", "admin.assets.cfcs.PORCPL")>
<cfset objSerialsReceipts = createObject("component", "admin.assets.cfcs.SerialsReceipts")>

<cfif isDefined("URL.Validation")>
	<cfset stErrors = objSerialsReceipts.getErrorRecord()>
<cfelse>
	<cfset stErrors = structNew()>
</cfif>

<cfset stRecord = objSerialsReceipts.getDataRecord()>

<!--- Get a structure of the Receipt header --->
<cfset strHeader = objPORCPH1.getRecord(stRecord.RCPHSEQ)>
<cfset SearchRecord = structNew()>
<cfset structInsert(SearchRecord, "RCPHSEQ", stRecord.RCPHSEQ, True)>
<cfset structInsert(SearchRecord, "RCPLREV", stRecord.RCPLREV, True)>

<!--- Get a query of the Receipt detail --->
<cfset qryDetail = objPORCPL.searchRecords(SearchRecord, "query")>

<cfset RemainingQuantity = objSerialsReceipts.getRemainingQuantity(stRecord.RCPHSEQ, stRecord.RCPLREV)>
<!---<cfset NumberBoxesCons3 = int(stRecord.NumberOfBoxes/stRecord.ConsecutiveQuantity)>--->
<cfset NumberBoxesCons3 = int(RemainingQuantity/stRecord.ConsecutiveQuantity)>

<cfset StartBoxNumberCons3 = 1>
<cfset EndBoxNumberCons3 = NumberBoxesCons3>

<cfset strScanner = objSerialsReceipts.getScannerSettings("serials_receipts_consec3_serials", qryDetail.ITEMNO)>

<script language="javascript">
	window.onload = init;
	function init() {
		window.scanner = new Scanner();
		window.scanner.setSettingsID("settings");
		window.scanner.init();
	}
	function confirmPost() {
		var msg = "Are you sure you want to Post serial numbers?";
		if(confirm(msg)) { 
			disableAllButtons();
			document.getElementById("Posting").style.visibility = "visible";		
		    window.document.detailform.submit();
		}
		else { return false; }
	}
//	function continueButton() {
//		disableAllButtons();
//		window.document.detailform.submit();
//	}
	function disableAllButtons() {
		document.detailform.ButtonClicked[0].disabled = true;
		return true;
	}
</script>

<cfoutput>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">Consecutive Order 3 Function, Serial Number Entry</td>
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
	<form action="index.cfm?task=serials_receipts_consec3_serials_act&RequestTimeout=12000" method="Post" name="detailform">
	<input type="hidden" name="RCPHSEQ" value="#stRecord.RCPHSEQ#">
	<input type="hidden" name="RCPLREV" value="#stRecord.RCPLREV#">
	<input type="hidden" name="StartBoxNumber" value="#stRecord.StartBoxNumber#">
	<input type="hidden" name="StartBoxNumberCons3" value="#StartBoxNumberCons3#">
	<input type="hidden" name="NumberOfBoxes" value="#stRecord.NumberOfBoxes#">
	<input type="hidden" name="NumberBoxesCons3" value="#NumberBoxesCons3#">
	<input type="hidden" name="PrintBarCodeLabels" value="#stRecord.PrintBarCodeLabels#">
	<input type="hidden" name="ConsecutiveQuantity" value="#stRecord.ConsecutiveQuantity#">
	<input type="hidden" name="EndBoxNumber" value="#stRecord.EndBoxNumber#">
	<input type="hidden" name="EndBoxNumberCons3" value="#EndBoxNumberCons3#">

	<input type="hidden" name="ITEMNO" value="#qryDetail.ITEMNO#">
	<input type="hidden" name="LOCATION" value="#qryDetail.LOCATION#">
	<input type="hidden" name="RQRECEIVED" value="#qryDetail.RQRECEIVED#">

	<tr>
		<td valign="top" class="textmain" colspan="3"><b>Serial Numbers:</b></td>
	</tr>
	
	<cfloop index="LoopCount" from="#StartBoxNumberCons3#" to="#EndBoxNumberCons3#">
		<cfset SNColumn = "SNC3_" & LoopCount>
		<cfif isDefined("stRecord") AND structKeyExists(stRecord, SNColumn)>
			<cfset SNColumnValue = stRecord[SNColumn]>	
		<cfelse>
			<cfset SNColumnValue = "">	
		</cfif>

		<cfif structKeyExists(stErrors, SNColumn)>
			<tr>
				<td>&nbsp;</td>
				<td valign="top" class="textsmall">
					<font color="FF0000">
						&raquo; #stErrors[SNColumn]#
					</font>
				</td>
			</tr>
		</cfif>
			
		<tr>
			<td valign="middle" class="textmain" width="15%" align="center" style="font-size:8px">&nbsp; <!---#LoopCount#---></td>
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
		</tr>
	</cfloop>

	<tr>
	<td valign="top" colspan="3" align="left">
		<table cellpadding="4" cellspacing="0" border="0" width="80%">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td align="center"><!--- "POST" BUTTON --->
					<input type="submit" name="ButtonClicked" value="Post" onclick="return confirmPost()" <!---onclick="return continueButton()"--->>
					<input type="hidden" name="ButtonClicked" value="NONE">
				</td>
			</tr>
			<tr id="Posting" style="visibility:hidden;">
				<td valign="top" align="center" class="textmain">
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