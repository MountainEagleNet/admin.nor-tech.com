<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/05/2006
	Function: 		This page displays the warning form
	Template:		frmWarning.cfm
	Task:			serials_transfers_warning
--->
	<cfset objICTREH = createObject("component", "admin.assets.cfcs.ICTREH")>
	<cfset objICTRED = createObject("component", "admin.assets.cfcs.ICTRED")>
	<cfset objSerialsTransfers = createObject("component", "admin.assets.cfcs.SerialsTransfers")>

	<cfset stRecord = objSerialsTransfers.getDataRecord()>
	<cfset stWarnings = objSerialsTransfers.getErrorRecord()>

	<!--- Get a structure of the Transfer header --->
	<cfset strHeader = objICTREH.getRecord(stRecord.TRANFENSEQ)>
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "TRANFENSEQ", stRecord.TRANFENSEQ, True)>
	<cfset structInsert(SearchRecord, "LINENO", stRecord.LINENO, True)>
	<!--- Get a query of the Transfer detail --->
	<cfset qryDetail = objICTRED.searchRecords(SearchRecord, "query")>

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

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<td valign="top" class="textmain" style="font-size:16px"><font color="FF0000"><b>Serial Number Entry - WARNING!!</b></font></td>
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
	Please note the following warning(s).<br> 
	You may click "Back" to fix the errors, or click "Continue" to overrule the warnings and continue the posting process.
	</td>
</tr>


<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	
	<cfif structKeyExists(stWarnings, "NotOnFile")>
		<tr>
			<td valign="top" class="textmain" colspan="2">
				<font color="FF0000">
					The following serial numbers are not on file:
				</font>
			</td>
		</tr>
		<cfset RecordList = structKeyList(stWarnings)>
		<cfloop list="#RecordList#" index="SNColumn">
			<cfif findNoCase("NotOnFile_SN_", SNColumn) NEQ 0>
				<cfset SNValue = stWarnings[SNColumn]>
				<tr>
					<td valign="top" class="textmain" width="20%">&nbsp;</td>
					<td valign="top" class="textmain">
						<font color="FF0000">
							#SNValue#
						</font>
					</td>
				</tr>
			</cfif>
		</cfloop>
		<tr><td>&nbsp;</td></tr>
	</cfif>

	<cfif structKeyExists(stWarnings, "WrongLocation")>
		<tr>
			<td valign="top" class="textmain" colspan="2">
				<font color="FF0000">
					The following serial numbers are on file, but for a different inventory location:
				</font>
			</td>
		</tr>
		<cfset RecordList = structKeyList(stWarnings)>
		<cfloop list="#RecordList#" index="SNColumn">
			<cfif findNoCase("WrongLocation_SN_", SNColumn) NEQ 0>
				<cfset SNValue = stWarnings[SNColumn]>
				<tr>
					<td valign="top" class="textmain" width="20%">&nbsp;</td>
					<td valign="top" class="textmain">
						<font color="FF0000">
							#SNValue#
						</font>
					</td>
				</tr>
			</cfif>
		</cfloop>
		<tr><td>&nbsp;</td></tr>
	</cfif>

	<cfif structKeyExists(stWarnings, "BatchItemWarning")>
		<tr>
			<td valign="top" class="textmain" colspan="2">
				<font color="FF0000">
					The item you are transferring is identified as a "Batch Number Item", but the serial number that you scanned, '#stWarnings.BatchItemWarning#', doesn't match any on file for this item.
				</font>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	</cfif>

	<cfif structKeyExists(stWarnings, "BlankFields")>
		<cfset NumberOfBlankFields = stWarnings.BlankFields>
		<cfset TotalFields = int(qryDetail.QUANTITY)>
		<cfset NumberFieldsFilled = TotalFields - NumberOfBlankFields>
		<tr>
			<td valign="top" class="textmain" colspan="2">
				<font color="FF0000">
					The transfer quantity is #TotalFields#, but you entered 
					<cfif NumberFieldsFilled EQ 0>no serial numbers.
					<cfelseif NumberFieldsFilled EQ 1>only 1 serial number.
					<cfelse>only #NumberFieldsFilled# serial numbers.
					</cfif>
				</font>
			</td>
		</tr>
	</cfif>
	</table>
	
	<form action="index.cfm?task=serials_transfers_warning_act" method="Post" name="detailform">
	<input type="hidden" name="TRANFENSEQ" value="#stRecord.TRANFENSEQ#">
	<input type="hidden" name="LINENO" value="#stRecord.LINENO#">
	<table cellpadding="4" cellspacing="0" border="0" width="80%" align="center">
	<tr>
		<!--- "BACK" BUTTON --->
		<td align="left">
			<input type="submit" name="ButtonClicked" value="&laquo;- Back&nbsp;">
		</td>
		<!--- "CONTINUE" BUTTON --->
		<td align="right">
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
</cfoutput>