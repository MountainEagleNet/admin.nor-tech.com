<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/08/2007
	Function: 		Consecutive Order 3 Function, Enter Serial Numbers 
	Template:		frmCons3Serials.cfm
	Task:			serials_shipments_consec3_serials
--->
<cfset objOEORDH = createObject("component", "admin.assets.cfcs.OEORDH")>
<cfset objOEORDD = createObject("component", "admin.assets.cfcs.OEORDD")>
<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>

<cfset stRecord = objSerialsShipments.getDataRecord()>
<cfset RemainingQuantity = stRecord.RemainingQuantity>

<!--- Get a structure of the Receipt header --->
<cfset strHeader = objOEORDH.getRecord(stRecord.ORDUNIQ)>
<cfset SearchRecord = structNew()>
<cfset structInsert(SearchRecord, "ORDUNIQ", stRecord.ORDUNIQ, True)>
<cfset structInsert(SearchRecord, "LINENUM", stRecord.ORDLINENUM, True)>

<!--- Get a query of the Receipt detail --->
<cfset qryDetail = objOEORDD.searchRecords(SearchRecord, "query")>

<cfset NumberBoxesCons3 = int(stRecord.NumberOfBoxes/stRecord.ConsecutiveQuantity)>

<cfset StartBoxNumberCons3 = 1>
<cfset EndBoxNumberCons3 = NumberBoxesCons3>

<cfset strScanner = objSerialsShipments.getScannerSettings("serials_shipments_consec3_serials", qryDetail.ITEM)>

<script language="javascript">
	window.onload = init;
	function init() {
		window.scanner = new Scanner();
		window.scanner.setSettingsID("settings");
		window.scanner.init();
	}
	function continueButton() {
		disableAllButtons();
		window.document.detailform.submit();
	}
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
	<td valign="top" class="textmain"><font color="FF0000">#objSerialsShipments.getMessage()#</font></td>
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
	<form action="index.cfm?task=serials_shipments_consec3_serials_act&RequestTimeout=6000" method="Post" name="detailform">
	<input type="hidden" name="ORDUNIQ" value="#stRecord.ORDUNIQ#">
	<input type="hidden" name="ORDLINENUM" value="#stRecord.ORDLINENUM#">
	<input type="hidden" name="StartBoxNumberCons3" value="#StartBoxNumberCons3#">
	<input type="hidden" name="NumberOfBoxes" value="#stRecord.NumberOfBoxes#">
	<input type="hidden" name="NumberBoxesCons3" value="#NumberBoxesCons3#">
	<input type="hidden" name="ConsecutiveQuantity" value="#stRecord.ConsecutiveQuantity#">
	<input type="hidden" name="EndBoxNumberCons3" value="#EndBoxNumberCons3#">
	<input type="hidden" name="RemainingQuantity" value="#stRecord.RemainingQuantity#">

	<tr>
		<td valign="top" class="textmain" colspan="3"><b>Serial Numbers:</b></td>
	</tr>
	
	<cfloop index="LoopCount" from="#StartBoxNumberCons3#" to="#EndBoxNumberCons3#">
		<tr>
			<td valign="middle" class="textmain" width="15%" align="center" style="font-size:8px">&nbsp;</td>
			<cfset SNColumn = "SNC3_" & LoopCount>
				<cfset SNColumnValue = "">	
				<cfset SNStyle = "border:1px solid lightgrey;background-color:white;color:black;font-family:arial;font-size:11px;font-weight:normal;">
			
			<td valign="middle" class="textmain">
				<input name="#SNColumn#" value="#SNColumnValue#" size="50" maxlength="50" tabindex="#LoopCount#" onkeydown="return window.scanner.doKeyDown();" onkeypress="return window.scanner.doKeyPress();" onkeyup="return window.scanner.doKeyUp();" style="#SNStyle#"/>
			</td>
		</tr>
	</cfloop>

	<tr>
	<td valign="top" colspan="3" align="center">
		<table cellpadding="4" cellspacing="0" border="0" width="80%">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td width="30%"><!--- "CONTINUE" BUTTON --->
				<input type="submit" name="ButtonClicked" value="&nbsp;Continue -&raquo;" onclick="return continueButton()">
				<input type="hidden" name="ButtonClicked" value="NONE">
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