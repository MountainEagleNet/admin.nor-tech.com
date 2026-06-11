<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/08/2006
	Function: 		This page displays the confirmation page prior to posting serial numbers
	Template:		dspDiscrepancies.cfm
	Task:			serials_counts_serials_confirm
--->
	<cfset objSerials = createObject("component", "admin.assets.cfcs.Serials")>
	<cfset objSerialsCounts = createObject("component", "admin.assets.cfcs.SerialsCounts")>

	<cfset stRecord = objSerialsCounts.getDataRecord()>
	<cfparam name="stRecord.ReadyToPost" default="1">
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
	<td valign="top" class="textmain"><font color="FF0000">#objSerialsCounts.getMessage()#</font></td>
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
</td>
</tr>
<tr><td>&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	
	<cfset qryNotOnFile = objSerialsCounts.getNotOnFile(stRecord)>
	<cfif qryNotOnFile.RecordCount GT 0>
		<tr>
			<td valign="top" class="textmain" colspan="2" style="color:FF0000">The following serial numbers were scanned but are not on file; they will be added to the database.</td>
		</tr>
	</cfif>
	<cfloop query="qryNotOnFile">
		<tr>
			<td valign="top" class="textmain" width="20%">&nbsp;</td>
			<td valign="top" class="textmain">#qryNotOnFile.SerialNumber#</td>
		</tr>
	</cfloop>
	
	<cfset qryOnFile = objSerialsCounts.getOnFile(stRecord)>
	<cfif qryOnFile.RecordCount GT 0>
		<tr>
			<td valign="top" class="textmain" colspan="2" style="color:FF0000">The following serial numbers are on file but were not scanned; they will be removed from the database.</td>
		</tr>
	</cfif>
	<cfloop query="qryOnFile">
		<tr>
			<td valign="top" class="textmain" width="20%">&nbsp;</td>
			<td valign="top" class="textmain">#qryOnFile.SerialNumber#</td>
		</tr>
	</cfloop>
	
	<cfset quantityError = objSerialsCounts.getQuantityError(stRecord)>
	<cfif quantityError IS NOT "">
		<tr>
			<td valign="top" class="textmain" colspan="2" style="color:FF0000">
				#quantityError#
			</td>
		</tr>
	</cfif>
	
	<cfif qryNotOnFile.RecordCount EQ 0 AND qryOnFile.RecordCount EQ 0 AND quantityError IS "">
		<tr>
			<td valign="top" class="textmain" colspan="2">No discrepancies were found between the scanned serial numbers and those currently on file for this item/location.</td>
		</tr>
	</cfif>
	

	<tr>
	<td valign="top" colspan="2" align="center">
		<form action="index.cfm?task=serials_counts_serials_post&RequestTimeout=6000" method="Post" name="detailform">
		<input type="hidden" name="Quantity" value="#stRecord.Quantity#">
		<input type="hidden" name="CameFromConfirmationPage" value="1">
		<input type="hidden" name="ReadyToPost" value="#stRecord.ReadyToPost#">
		<table cellpadding="4" cellspacing="0" border="0" width="80%">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<!--- "QUIT" BUTTON --->
				<td>
					<input type="submit" name="ButtonClicked" value="Quit">
				</td>
				<!--- "CONTINUE" BUTTON --->
<!---			<cfif qryNotOnFile.RecordCount GT 0 OR qryOnFile.RecordCount GT 0>	--->
					<td>
						<input type="submit" name="ButtonClicked" value="&nbsp;Continue -&raquo;" onclick="return disableButton()">
					</td>
<!---			</cfif>	--->
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