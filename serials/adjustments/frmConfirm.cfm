<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/03/2006
	Function: 		This page displays the confirmation page prior to posting serial numbers
	Template:		frmConfirm.cfm
	Task:			serials_adjustments_serials_confirm
--->
	<cfset objICADEH = createObject("component", "admin.assets.cfcs.ICADEH")>
	<cfset objICADED = createObject("component", "admin.assets.cfcs.ICADED")>
	<cfset objSerialsAdjustments = createObject("component", "admin.assets.cfcs.SerialsAdjustments")>

	<cfset stRecord = objSerialsAdjustments.getDataRecord()>

	<!--- Get a structure of the Adjustment header --->
	<cfset strHeader = objICADEH.getRecord(stRecord.ADJENSEQ)>
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "ADJENSEQ", stRecord.ADJENSEQ, True)>
	<cfset structInsert(SearchRecord, "LINENO", stRecord.LINENO, True)>
	<!--- Get a query of the Adjustment detail --->
	<cfset qryDetail = objICADED.searchRecords(SearchRecord, "query")>

</cfsilent>

<script language="JavaScript" type="text/JavaScript">
<!--
function disableButton() {
  document.detailform.ButtonClicked[1].disabled = true;
  document.getElementById("Posting").style.visibility = "visible";					
  window.document.detailform.submit();
}
//-->
</script>

<cfoutput>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objSerialsAdjustments.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<td valign="top" class="textmain" style="font-size:16px"><font color="0033CC"><b>Confirmation</b></font></td>
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
	<table cellpadding="2" cellspacing="0" width="100%" border="0">

	<cfif stRecord.AdjustmentType IS "Increase" AND isDefined("stRecord.PrintBarCodeLabels")>
		<tr>
			<td valign="top" class="textmain" colspan="2">
				<b>Print bar codes labels for these items?</b>
				&nbsp;&nbsp; #yesNoFormat(stRecord.PrintBarCodeLabels)#
			</td>
		</tr>
	</cfif>
	
	<tr>
		<td valign="top" class="textmain" colspan="2"><b>Serial Numbers:</b></td>
	</tr>
	
	<cfset RecordList = structKeyList(stRecord)>
	<cfloop list="#RecordList#" index="SNColumn">
		<cfif findNoCase("SN_", SNColumn) NEQ 0 AND trim(stRecord[SNColumn]) IS NOT "">
			<tr>
				<td valign="top" class="textmain" width="20%">&nbsp;</td>
				<td valign="top" class="textmain">#stRecord[SNColumn]#</td>
			</tr>
		</cfif>
	</cfloop>

	<tr><td>&nbsp;</td></tr>
	<tr>
		<td valign="top" class="textmain" colspan="2">
			<cfif stRecord.AdjustmentType IS "Increase">
				You are about to add these serial numbers to the database.<br>Are you sure you want to continue?
			<cfelse>
				You are about to delete these serial numbers from the database.<br>Are you sure you want to continue?
			</cfif>
		</td>
	</tr>

	<tr>
	<td valign="top" colspan="2" align="center">
		<form action="index.cfm?task=serials_adjustments_serials_post&RequestTimeout=6000" method="Post" name="detailform">
<!---
		<input type="hidden" name="ADJENSEQ" value="#stRecord.ADJENSEQ#">
		<input type="hidden" name="LINENO" value="#stRecord.LINENO#">
--->
		<table cellpadding="4" cellspacing="0" border="0" width="80%">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<!--- "QUIT" BUTTON --->
				<td>
					<input type="submit" name="ButtonClicked" value="Quit">
				</td>
				<!--- "CONTINUE" BUTTON --->
				<td>
					<input type="submit" name="ButtonClicked" value="&nbsp;Continue -&raquo;" onclick="return disableButton()">
				</td>
			</tr>
			<tr id="Posting" style="visibility:hidden;">
				<td valign="top" colspan="2" align="center" class="textmain">
					<font color="FF0000">Posting Serial Numbers - Please Wait</font>
				</td>
			</tr>
			
		</table>
		</form>
	</td>
	</tr>

	</table>
</td>
</tr>
</table>
</cfoutput>