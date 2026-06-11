<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/21/2006
	Function: 		This page displays a list of batch number items
	Template:		lstBatch.cfm
	Task:			serials_admin_batch_list
--->
	<cfset objScannerBatchItems = createObject("component", "admin.assets.cfcs.ScannerBatchItems")>
	<cfset Error = "">

	<cfparam name="URL.SortColumn" type="string" default="ITEMNO">
	<cfparam name="URL.SortOrder" type="string" default="Asc">

	<!--- set the new sort order for display --->
	<cfif URL.SortOrder IS "Desc">
		<cfset Variables.NewSortOrder = "Asc">
	<cfelse>
		<cfset Variables.NewSortOrder = "Desc">
	</cfif>

	<cfset Variables.OrderByList = URL.SortColumn & " " & URL.SortOrder>

	<cfset stRecord = structNew()>

	<cfif isDefined("FORM.ITEMNO")>
		<cfset stRecord.ITEMNO = FORM.ITEMNO>
	<cfelseif isDefined("URL.ITEMNO")>
		<cfset stRecord.ITEMNO = URL.ITEMNO>
	<cfelse>
		<cfset stRecord.ITEMNO = "">
	</cfif>
	
	<cfif isDefined("FORM.ITEMDESC")>
		<cfset stRecord.ITEMDESC = FORM.ITEMDESC>
	<cfelseif isDefined("URL.ITEMDESC")>
		<cfset stRecord.ITEMDESC = URL.ITEMDESC>
	<cfelse>
		<cfset stRecord.ITEMDESC = "">
	</cfif>

	<cfif isDefined("URL.BackFromSNList") AND URL.BackFromSNList IS "1">
		<cfset stRecordQRY = objScannerBatchItems.getDataRecord()>
		<cfset qryScannerBatchItems = stRecordQRY.qryScannerBatchItems>
		<cfset stRecord.ITEMNO = stRecordQRY.ITEMNO>
		<cfset stRecord.ITEMDESC = stRecordQRY.ITEMDESC>

	<cfelse>
		<cfset SearchRecord = structNew()>
		<cfif trim(stRecord.ITEMNO) IS NOT "">
			<cfset structInsert(SearchRecord, "ITEMNO", stRecord.ITEMNO, True)>
		</cfif>
		<cfif trim(stRecord.ITEMDESC) IS NOT "">
			<cfset structInsert(SearchRecord, "ITEMDESC", stRecord.ITEMDESC, True)>
		</cfif>
		<cfset qryScannerBatchItems = objScannerBatchItems.searchRecords(SearchRecord, "query", Variables.OrderByList, 0)>
		<cfif qryScannerBatchItems.RecordCount EQ 0>
			<cfset Error = "No Match Found">
		</cfif>
	</cfif>
	
	<cfset structInsert(stRecord, "qryScannerBatchItems", qryScannerBatchItems, True)>	
	<cfset objScannerBatchItems.setDataRecord(stRecord)>	
	
</cfsilent>

<script language="javascript">
	function confirmDelete() {
		var msg = "Are you sure you would like to delete this record?";
		if(confirm(msg)) { return true; }
		else { return false; }
	}
</script>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle" colspan="3">Batch Number Item List</td>
</tr>

<tr><!--- Link back to "Add a New Item" --->
	<td valign="top" class="textmain" colspan="3" align="right">
		<a href="index.cfm?task=serials_admin_batch_new">
			Add a New Item
		</a>
	</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain" colspan="3"><font color="FF0000">#objScannerBatchItems.getMessage()#</font></td>
</tr>


<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<td valign="top" class="textmain" colspan="3">
		The following list displays "Batch Number Items".  These are items that are scanned in as serialized, but don't have serial number bar codes on them.  Instead, the "batch number" will be scanned in instead of the serial number.
	</td>
</tr>

<form name="ItemNumberSearch" action="index.cfm?task=serials_admin_batch_list" method="post">
	<tr>
		<td class="textmain" width="25%"><strong>Item Number:</strong></td>
		<td class="textmain" width="40%">
			<input name="ITEMNO" size="20" maxlength="50" value="#stRecord.ITEMNO#">
		</td>
		<td class="textmain" align="left">
			<input type="submit" name="ProcessSearch" value="Search">
		</td>
	</tr>
	<tr>
		<td class="textmain"><strong>Item Description:</strong></td>
		<td class="textmain">
			<input name="ITEMDESC" size="20" maxlength="50"	value="#stRecord.ITEMDESC#">
		</td>
	</tr>
</form>
<cfif Error IS NOT "">
	<tr><td class="textsmall">&nbsp;</td></tr>
	<tr>
		<td class="textmain" align="left" colspan="3">
			<font color="FF0000">
				<cfif Error IS "Both Empty"	>
					Please enter an Item Number and/or Description (partial or full) before clicking "Search".
				<cfelseif Error IS "No Match Found">
					<cfif trim(FORM.ITEMNO) IS NOT "" AND trim(FORM.ITEMDESC) IS NOT "" >
						No items were found matching your search critera.
					<cfelseif trim(FORM.ITEMNO) IS NOT "">
						Item Number '#FORM.ITEMNO#' was not found.
					<cfelseif trim(FORM.ITEMDESC) IS NOT "">
						Item Description '#FORM.ITEMDESC#' was not found.
					</cfif>
				</cfif>
			</font>
		</td>
	</tr>
</cfif>

<tr>
<td valign="top" class="textmain" colspan="3">
	<table cellpadding="0" cellspacing="0" width="100%" border="0">
	
	<!--- LIST HEADINGS --->
	<tr>
		<td height="18" bgcolor="006633" width="40%">
			<a class="menuwh" href="index.cfm?task=serials_admin_batch_list&
										SortColumn=ITEMNO&SortOrder=#NewSortOrder#&
										ITEMNO=#urlEncodedFormat(stRecord.ITEMNO)#&
										ITEMDESC=#urlEncodedFormat(stRecord.ITEMDESC)#">
				Item Number
			</a>
		</td>
		<td height="18" bgcolor="006633" width="50%">
			<a class="menuwh" href="index.cfm?task=serials_admin_batch_list&
										SortColumn=ITEMDESC&SortOrder=#NewSortOrder#&
										ITEMNO=#urlEncodedFormat(stRecord.ITEMNO)#&
										ITEMDESC=#urlEncodedFormat(stRecord.ITEMDESC)#">
				Description
			</a>
		</td>
		<td height="18" bgcolor="006633">&nbsp;</td>
	</tr>

	<!--- LIST DATA --->	
	<cfif qryScannerBatchItems.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="3" class="productTitle"><font color="FF0000">There are currently no Batch Number Items on file.</font></td>
		</tr>
	</cfif>
	
	<cfloop query="qryScannerBatchItems">
		<tr<cfif qryScannerBatchItems.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
			<td class="textsmall" align="left">
				<a href="index.cfm?task=serials_admin_batch_serials&ScannerBatchItemID=#urlEncodedFormat(qryScannerBatchItems.ScannerBatchItemID)#">
					#qryScannerBatchItems.ITEMNO#
				</a>
			</td>
			<td class="textsmall" align="left">#qryScannerBatchItems.ITEMDESC#</td>
			<td class="textsmall" align="center">
				<a href="index.cfm?task=serials_admin_batch_delete&ScannerBatchItemID=#urlEncodedFormat(qryScannerBatchItems.ScannerBatchItemID)#" onclick="return confirmDelete()">
					[delete]
				</a>
			</td>
		</tr>
	</cfloop>

	</table>
</td>
</tr>

</table>
</cfoutput>