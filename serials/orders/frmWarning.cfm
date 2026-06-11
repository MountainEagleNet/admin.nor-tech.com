<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/26/2006
	Edit Date: 		10/12/2006
	Function: 		This page displays the warning form
	Template:		frmWarning.cfm
	Task:			serials_shipments_warning
--->
	<cfset objOEORDH = createObject("component", "admin.assets.cfcs.OEORDH")>
	<cfset objOEORDD = createObject("component", "admin.assets.cfcs.OEORDD")>
	<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>

	<cfset stRecord = objSerialsShipments.getDataRecord()>
	<cfset stWarnings = objSerialsShipments.getErrorRecord()>

	<!--- Get a structure of the Order header --->
	<cfset strHeader = objOEORDH.getRecord(stRecord.ORDUNIQ)>
	
	<!--- Get a query of the Order detail --->
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "ORDUNIQ", stRecord.ORDUNIQ, True)>
	<cfset structInsert(SearchRecord, "LINENUM", stRecord.ORDLINENUM, True)>
	<cfset qryDetail = objOEORDD.searchRecords(SearchRecord, "query")>

	<!--- Determine the amount remaining to ship --->
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "ORDUNIQ", stRecord.ORDUNIQ, True)>
	<cfset structInsert(SearchRecord, "ORDLINENUM", stRecord.ORDLINENUM, True)>
	<cfset structInsert(SearchRecord, "Posted", 1, True)>
	<cfset qrySerialsShipmentsAttached = objSerialsShipments.searchRecords(SearchRecord, "query")>
	<cfif NOT isNumeric(qryDetail.QTYORDERED)><cfset qryDetail.QTYORDERED = 0></cfif>
	<cfif NOT isNumeric(qryDetail.QTYSHPTODT)><cfset qryDetail.QTYSHPTODT = 0></cfif>
	<cfset RemainingQuantity = int((qryDetail.QTYORDERED + qryDetail.QTYSHPTODT) - qrySerialsShipmentsAttached.RecordCount)>

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
	<!--- ORDER INFORMATION --->
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
		<cfset stWarningsNew = structNew()>
		<cfloop list="#RecordList#" index="Column">
			<cfif findNoCase("NotOnFile_SN_", Column) NEQ 0>
				<cfset NumberedField = removeChars(Column, 1, 13)>
				<cfset structInsert(stWarningsNew, NumberedField, stWarnings[Column], True)>
			</cfif>
		</cfloop>
		<cfset RecordListNew = listSort(structKeyList(stWarningsNew), "numeric")>
		<cfloop list="#RecordListNew#" index="SNColumn">
			<cfset SNValue = stWarningsNew[SNColumn]>
			<tr>
				<td valign="top" class="textmain" width="20%">&nbsp;</td>
				<td valign="top" class="textmain">
					<font color="FF0000">
						#SNValue#
					</font>
				</td>
			</tr>
		</cfloop>
		<tr><td>&nbsp;</td></tr>
	</cfif>

	<cfif structKeyExists(stWarnings, "MultipleFound")>
		<tr>
			<td valign="top" class="textmain" colspan="2">
				<font color="FF0000">
					The following serial numbers were found more than once in the master list of serial numbers:
				</font>
			</td>
		</tr>
		<cfset RecordList = structKeyList(stWarnings)>
		<cfloop list="#RecordList#" index="SNColumn">
			<cfif findNoCase("MultipleFound_SN_", SNColumn) NEQ 0>
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

	<cfif structKeyExists(stWarnings, "WrongItem")>
		<tr>
			<td valign="top" class="textmain" colspan="2">
				<font color="FF0000">
					The following serial numbers are listed for a different inventory item:
				</font>
			</td>
		</tr>
		<cfset RecordList = structKeyList(stWarnings)>
		<cfloop list="#RecordList#" index="SNColumn">
			<cfif findNoCase("WrongItem_SN_", SNColumn) NEQ 0>
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

	<cfif structKeyExists(stWarnings, "CompBuildFound")>
		<tr>
			<td valign="top" class="textmain" colspan="2">
				<font color="FF0000">
					This is a comp build item; the following serial numbers  have already been used on comp build items on another order:
				</font>
			</td>
		</tr>
		<cfset RecordList = structKeyList(stWarnings)>
		<cfloop list="#RecordList#" index="SNColumn">
			<cfif findNoCase("CompBuildFound_SN_", SNColumn) NEQ 0>
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
					The item you are shipping is identified as a "Batch Number Item", but the serial number that you scanned, '#stWarnings.BatchItemWarning#', doesn't match any on file for this item.<br>
					If you continue, the new serial number will be saved as a valid serial number for this item.
				</font>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	</cfif>
	
	<cfif structKeyExists(stWarnings, "BatchItemWarning2")>
		<tr>
			<td valign="top" class="textmain" colspan="2">
				<font color="FF0000">
					The item you are shipping is identified as a "Batch Number Item", and the quantity of serial numbers you scanned is greater than the quantity on file in the master list of serial numbers.
				</font>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	</cfif>

	<cfif structKeyExists(stWarnings, "BlankFields")>
		<cfset NumberOfBlankFields = stWarnings.BlankFields>
		
<!---	<cfset TotalFields = int(qryDetail.QTYSHIPPED)>	--->
		<cfset TotalFields = RemainingQuantity>

		<cfset NumberFieldsFilled = TotalFields - NumberOfBlankFields>
		<tr>
			<td valign="top" class="textmain" colspan="2">
				<font color="FF0000">
					The remaining quantity is #TotalFields#, but you entered 
					<cfif NumberFieldsFilled EQ 0>no serial numbers.
					<cfelseif NumberFieldsFilled EQ 1>only 1 serial number.
					<cfelse>only #NumberFieldsFilled# serial numbers.
					</cfif>
				</font>
			</td>
		</tr>
	</cfif>
	</table>
	
	<form action="index.cfm?task=serials_shipments_warning_act" method="Post" name="detailform">
	<input type="hidden" name="ORDUNIQ" value="#stRecord.ORDUNIQ#">
	<input type="hidden" name="ORDLINENUM" value="#stRecord.ORDLINENUM#">
	<cfif isDefined("URL.CorrectingSerialNumber")>
		<input type="hidden" name="CorrectingSerialNumber" value="1">
	</cfif>
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