<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	07/24/2007
	Function: 		This page displays a list of valid serial numbers for a batch number item
	Template:		lstBatchSNs.cfm
	Task:			serials_admin_batch_serials
--->
	<cfset objScannerBatchItems = createObject("component", "admin.assets.cfcs.ScannerBatchItems")>
	<cfset objScannerBatchItemSNs = createObject("component", "admin.assets.cfcs.ScannerBatchItemSNs")>

	<cfset strScannerBatchItem = objScannerBatchItems.getRecord(URL.ScannerBatchItemID)>
	<cfset qryScannerBatchItemSNs = objScannerBatchItemSNs.listRecordsForParent("ScannerBatchItemID", URL.ScannerBatchItemID, "SerialNumber")>
	
</cfsilent>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle" colspan="2">Batch Item Valid Serial Number List</td>
</tr>

<tr><!--- Link back to "Batch Number Item List" --->
	<td valign="top" class="textmain" colspan="2" align="right">
		<a href="index.cfm?task=serials_admin_batch_list&BackFromSNList=1">
			Back to Batch Number Item List
		</a>
	</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain" colspan="2"><font color="FF0000">#objScannerBatchItemSNs.getMessage()#</font></td>
</tr>


<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<td valign="top" class="textmain" colspan="2">
		The following displays a list of valid serial numbers on file for the specified batch number item. &nbsp;	
		If one of the following serial numbers is not scanned when filling an order that contains this item, a warning will appear.
	</td>
</tr>

<tr><td>&nbsp;</td></tr>
<tr>
	<td class="textmain" width="25%"><strong>Item Number:</strong></td>
	<td class="textmain">#strScannerBatchItem.ITEMNO#</td>
</tr>

<tr>
	<td class="textmain"><strong>Item Description:</strong></td>
	<td class="textmain">#strScannerBatchItem.ITEMDESC#</td>
</tr>
<tr><td>&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain" colspan="2">
	<table cellpadding="0" cellspacing="0" width="100%" border="0">
	
	<!--- LIST HEADINGS --->
	<tr>
		<td height="18" bgcolor="006633" class="productTitle" style="color:##FFFFFF">
			Serial Number
		</td>
	</tr>

	<!--- LIST DATA --->	
	<cfif qryScannerBatchItemSNs.RecordCount EQ 0>
		<tr>
			<td align="center" class="productTitle" style="color:##FF0000">
				There are currently no valid Serial Numbers on file for this Batch Number Item.
			</td>
		</tr>
	</cfif>
	
	<cfloop query="qryScannerBatchItemSNs">
		<tr<cfif qryScannerBatchItemSNs.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
			<td class="textsmall" align="left">
				#qryScannerBatchItemSNs.SerialNumber#
			</td>
		</tr>
	</cfloop>

	</table>
</td>
</tr>

</table>
</cfoutput>