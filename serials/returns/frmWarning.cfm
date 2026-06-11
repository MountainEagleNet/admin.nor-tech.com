<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/28/2006
	Function: 		This page displays the warning form
	Template:		frmWarning.cfm
	Task:			serials_returns_warning
--->
	<cfset objRAHEAD = createObject("component", "admin.assets.cfcs.RAHEAD")>
	<cfset objRADET = createObject("component", "admin.assets.cfcs.RADET")>
	<cfset objSerialsReturns = createObject("component", "admin.assets.cfcs.SerialsReturns")>

	<cfset stRecord = objSerialsReturns.getDataRecord()>
	<cfset stWarnings = objSerialsReturns.getErrorRecord()>

	<!--- Get a structure of the Return header --->
	<cfset strHeader = objRAHEAD.getRecord(stRecord.RMAUNIQ)>
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "RMAUNIQ", stRecord.RMAUNIQ, True)>
	<cfset structInsert(SearchRecord, "LINENUM", stRecord.LINENUM, True)>
	<!--- Get a query of the Return detail --->
	<cfset qryDetail = objRADET.searchRecords(SearchRecord, "query")>
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

	<!--- AUTHORIZATION PHASE --->
	<cfif structKeyExists(stWarnings, "AlreadyOnFile")>
		<tr>
			<td valign="top" class="textmain" colspan="2">
				<font color="FF0000">
					The following serial numbers are already on file:
				</font>
			</td>
		</tr>
		<cfset RecordList = structKeyList(stWarnings)>
		<cfloop list="#RecordList#" index="SNColumn">
			<cfif findNoCase("SN_", SNColumn) NEQ 0>
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
					The item you are returning is identified as a "Batch Number Item", but the serial number that you scanned, '#stWarnings.BatchItemWarning#', doesn't match any on file for this item.
				</font>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	</cfif>

	<!--- RECEIVING PHASE --->
	<cfif structKeyExists(stWarnings, "NotAuthorized")>
		<tr>
			<td valign="top" class="textmain" colspan="2">
				<font color="FF0000">
					The following serial numbers do not match any of the<br>authorized serial numbers for this return:
				</font>
			</td>
		</tr>
		<cfset RecordList = structKeyList(stWarnings)>
		<cfloop list="#RecordList#" index="SNColumn">
			<cfif findNoCase("SN_", SNColumn) NEQ 0>
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

	<cfif structKeyExists(stWarnings, "BlankFields")>
		<cfset NumberOfBlankFields = stWarnings.BlankFields>
		<cfset TotalFields = int(qryDetail.QTY)>
		<cfset NumberFieldsFilled = TotalFields - NumberOfBlankFields>
		<tr>
			<td valign="top" class="textmain" colspan="2">
				<font color="FF0000">
					The return quantity is #TotalFields#, but you entered 
					<cfif NumberFieldsFilled EQ 0>no serial numbers.
					<cfelseif NumberFieldsFilled EQ 1>only 1 serial number.
					<cfelse>only #NumberFieldsFilled# serial numbers.
					</cfif>
				</font>
			</td>
		</tr>
	</cfif>
	</table>
	
	<form action="index.cfm?task=serials_returns_warning_act&RequestTimeout=6000" method="Post" name="detailform">
	<input type="hidden" name="RMAUNIQ" value="#stRecord.RMAUNIQ#">
	<input type="hidden" name="LINENUM" value="#stRecord.LINENUM#">
	<input type="hidden" name="RMAAction" value="#stRecord.RMAAction#">
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