<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/03/2006
	Function: 		This page displays the warning form
	Template:		frmWarning.cfm
	Task:			serials_returnsvendor_warning
--->
	<cfset objPORETH1 = createObject("component", "admin.assets.cfcs.PORETH1")>
	<cfset objPORETL = createObject("component", "admin.assets.cfcs.PORETL")>
	<cfset objSerialsVendorReturns = createObject("component", "admin.assets.cfcs.SerialsVendorReturns")>

	<cfset stRecord = objSerialsVendorReturns.getDataRecord()>
	<cfset stWarnings = objSerialsVendorReturns.getErrorRecord()>

	<!--- Get a structure of the Return to Vendor header --->
	<cfset strHeader = objPORETH1.getRecord(stRecord.RETHSEQ)>
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "RETHSEQ", stRecord.RETHSEQ, True)>
	<cfset structInsert(SearchRecord, "RETLREV", stRecord.RETLREV, True)>
	<!--- Get a query of the Return to Vendor detail --->
	<cfset qryDetail = objPORETL.searchRecords(SearchRecord, "query")>

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
	
	<cfif structKeyExists(stWarnings, "WrongLocation")>
		<tr>
			<td valign="top" class="textmain" colspan="2">
				<font color="FF0000">
					The following serial numbers are on file, but for a different location:
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

<!---
	<cfif structKeyExists(stWarnings, "ReturnedToVendor")>
		<tr>
			<td valign="top" class="textmain" colspan="2">
				<font color="FF0000">
					<b>WARNING!!</b> The following serial number(s) was already returned to this Vendor!
				</font>
			</td>
		</tr>
		<cfset RecordList = structKeyList(stWarnings)>
		<cfloop list="#RecordList#" index="SNColumn">
			<cfif findNoCase("RTV|SN_", SNColumn) NEQ 0>
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
--->
	
	<cfif structKeyExists(stWarnings, "BatchItemWarning")>
		<tr>
			<td valign="top" class="textmain" colspan="2">
				<font color="FF0000">
					The item you are returning to a vendor is identified as a "Batch Number Item", but the serial number that you scanned, '#stWarnings.BatchItemWarning#', doesn't match any on file for this item.
				</font>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	</cfif>

	<cfif structKeyExists(stWarnings, "BlankFields")>
		<cfset NumberOfBlankFields = stWarnings.BlankFields>
		<cfset TotalFields = int(qryDetail.RQRETURNED)>
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
	
	<form action="index.cfm?task=serials_returnsvendor_warning_act" method="Post" name="detailform">
	<input type="hidden" name="RETHSEQ" value="#stRecord.RETHSEQ#">
	<input type="hidden" name="RETLREV" value="#stRecord.RETLREV#">
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