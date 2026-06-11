<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/08/2007
	Function: 		This page displays the form for entering quantity for the "Consecutive Order 3" function
	Template:		frmCons3Quantity.cfm
	Task:			serials_shipments_consec3_qty
--->
<cfset objOEORDH = createObject("component", "admin.assets.cfcs.OEORDH")>
<cfset objOEORDD = createObject("component", "admin.assets.cfcs.OEORDD")>
<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>

<cfset stRecord = objSerialsShipments.getDataRecord()>
<cfset RemainingQuantity = stRecord.RemainingQuantity>

<cfif isDefined("URL.Validation")>
	<cfset stErrors = objSerialsShipments.getErrorRecord()>
<cfelse>
	<cfset stErrors = structNew()>
</cfif>

<!--- Get a structure of the Receipt header --->
<cfset strHeader = objOEORDH.getRecord(stRecord.ORDUNIQ)>
<cfset SearchRecord = structNew()>
<cfset structInsert(SearchRecord, "ORDUNIQ", stRecord.ORDUNIQ, True)>
<cfset structInsert(SearchRecord, "LINENUM", stRecord.ORDLINENUM, True)>
<!--- Get a query of the Receipt detail --->
<cfset qryDetail = objOEORDD.searchRecords(SearchRecord, "query")>


<script language="javascript">
	function ContinueButton() {
		disableAllButtons();
		window.document.detailform.submit();
	}
	function disableAllButtons() {
		document.detailform.Continue.disabled = true;
		return true;
	}
</script>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<td valign="top" class="subpagetitle">Consecutive Order 3 Function, Enter Quantity</td>
</tr>

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
		Enter the quantity of serial numbers contained in each subsection, then click "Continue".<br><br>
		
		For example, if you're scanning hard drives that come in boxes of 10, enter "10" on this page.  Then, on the next page, you'll scan the first serial number of each box.
	</td>
</tr>
<tr><td>&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	<form action="index.cfm?task=serials_shipments_consec3_qty_act" method="Post" name="detailform">
	<input type="hidden" name="ORDUNIQ" value="#stRecord.ORDUNIQ#">
	<input type="hidden" name="ORDLINENUM" value="#stRecord.ORDLINENUM#">
	<input type="hidden" name="NumberOfBoxes" value="#stRecord.NumberOfBoxes#">
	<input type="hidden" name="RemainingQuantity" value="#stRecord.RemainingQuantity#">

	<cfif structKeyExists(stErrors, "ConsecutiveQuantity")>
		<tr>
			<td>&nbsp;</td>
			<td valign="bottom" class="textmain" colspan="2"><font color="FF0000">&raquo; #stErrors.ConsecutiveQuantity#</font></td>
		</tr>
	</cfif>
	<tr>
		<td valign="top" class="textmain" width="20%"><b>Quantity:</b></td>
		<td valign="top" class="textmain">
			<input name="ConsecutiveQuantity"
				<cfif isDefined("stRecord.ConsecutiveQuantity")>
					value="#stRecord.ConsecutiveQuantity#"
				</cfif>
			size="10" maxlength="50">
		</td>
	</tr>

	<tr><td>&nbsp;</td></tr>
	<tr>
	<td valign="top" colspan="2" align="center">
		<table cellpadding="4" cellspacing="0" border="0" width="50%" align="center">
		<tr>
			<!--- "CONTINUE" BUTTON --->
			<td align="center">
				<input type="submit" name="Continue" value="Continue" onclick="return ContinueButton()">
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

<script language="JavaScript" type="text/JavaScript">
<!--
document.detailform['ConsecutiveQuantity'].focus(); document.detailform['ConsecutiveQuantity'].select();
-->
</script>