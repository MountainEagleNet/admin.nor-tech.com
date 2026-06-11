<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	01/06/2011
	Function: 		This page displays the form for entering quantity for the "Consecutive Order 3" function
	Template:		frmCons3Quantity.cfm
	Task:			serials_counts_consec3_qty
--->
<!---
	<cfset objPORCPH1 = createObject("component", "admin.assets.cfcs.PORCPH1")>
	<cfset objPORCPL = createObject("component", "admin.assets.cfcs.PORCPL")>
--->    
	<cfset objSerialsCounts = createObject("component", "admin.assets.cfcs.SerialsCounts")>

	<cfset stRecord = objSerialsCounts.getDataRecord()>
	<cfif isDefined("URL.Validation")>
		<cfset stErrors = objSerialsCounts.getErrorRecord()>
	<cfelse>
		<cfset stErrors = structNew()>
	</cfif>
<!---
	<!--- Get a structure of the Receipt header --->
	<cfset strHeader = objPORCPH1.getRecord(stRecord.RCPHSEQ)>
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "RCPHSEQ", stRecord.RCPHSEQ, True)>
	<cfset structInsert(SearchRecord, "RCPLREV", stRecord.RCPLREV, True)>
	<!--- Get a query of the Receipt detail --->
	<cfset qryDetail = objPORCPL.searchRecords(SearchRecord, "query")>
--->
</cfsilent>

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
	<form action="index.cfm?task=serials_counts_consec3_qty_act" method="Post" name="detailform">
	<input type="hidden" name="CountsID" value="#stRecord.CountsID#">
	<input type="hidden" name="ITEMNO" value="#stRecord.ITEMNO#">
	<input type="hidden" name="Quantity" value="#stRecord.Quantity#">
	<input type="hidden" name="LOCATION" value="#stRecord.LOCATION#">
	<input type="hidden" name="StartBoxNumber" value="#stRecord.StartBoxNumber#">
	<input type="hidden" name="NumberOfBoxes" value="#stRecord.NumberOfBoxes#">
	<input type="hidden" name="EndBoxNumber" value="#stRecord.EndBoxNumber#">

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