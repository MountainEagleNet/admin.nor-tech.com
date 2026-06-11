<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/20/2006
	Function: 		This page displays a list of items for a chosen receipt
	Template:		lstItems.cfm
	Task:			serials_receipts_items_list
--->
	<cfset objPORCPH1 = createObject("component", "admin.assets.cfcs.PORCPH1")>
	<cfset objPORCPL = createObject("component", "admin.assets.cfcs.PORCPL")>
	<cfset objSerialsReceipts = createObject("component", "admin.assets.cfcs.SerialsReceipts")>
	<cfset objSerialsReceiptsExclude = createObject("component", "admin.assets.cfcs.SerialsReceiptsExclude")>

	<!--- Get a structure of the Receipt header --->
	<cfset strHeader = objPORCPH1.getRecord(URL.RCPHSEQ)>
	
	<!--- Get a query of the Receipt lines --->	
	<cfset qryDetail = objPORCPL.getSerializedLines(URL.RCPHSEQ)>

</cfsilent>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">Receipt Item List</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objSerialsReceipts.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<!--- link back --->
<tr>
	<td class="textsmall" align="right">
		<a href="index.cfm?task=serials_receipts_list">
			Back to Receipts List
		</a>
	</td>
</tr>

<!--- "START SCAN" link --->
<!--- If not all items for this order have been posted, find the first non-posted one and go directly to frmSerials --->
<cfset FirstUnpostedRCPLREV = objSerialsReceipts.getFirstUnpostedItem(URL.RCPHSEQ)>
<cfif FirstUnpostedRCPLREV IS NOT "">
	<tr>
		<td class="textmain" align="right">
			<a href="index.cfm?task=serials_receipts_serials_edit&RCPHSEQ=#urlEncodedFormat(URL.RCPHSEQ)#&RCPLREV=#urlEncodedFormat(FirstUnpostedRCPLREV)#">
				START SCAN
			</a>
		</td>
	</tr>
</cfif>

<tr>
	<td>
		<!--- HEADER INFORMATION --->
		<cfinclude template="headerInfo.cfm">
		
		<!--- Comment (reason the adjustment ws removed from the list) --->
		<cfset qrySerialsReceiptsExclude = objSerialsReceiptsExclude.listRecordsForParent("RCPHSEQ", URL.RCPHSEQ)>
		<cfif isDefined("qrySerialsReceiptsExclude.RemoveComment") AND trim(qrySerialsReceiptsExclude.RemoveComment) IS NOT "">
			<table cellpadding="1" cellspacing="0" width="100%" border="0">
				<tr>
					<td width="30%" class="textmain" align="left"><b>Comment:</b></td>
					<td class="textmain" align="left">#qrySerialsReceiptsExclude.RemoveComment#</td>
				</tr>
				<tr>
					<td class="textmain" align="left">&nbsp;</td>
					<td class="textsmall" align="left" style="color:##FF0000 ">
						<em>(This comment indicates why this receipt was removed from the list)</em>
					</td>
				</tr>
			</table>
		</cfif>

	</td>
</tr>
<tr><td>&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="0" cellspacing="0" width="100%" border="0">
	
	<!--- LIST HEADINGS --->
	<tr>
		<td height="18" bgcolor="006633" class="productTitle" width="22%" ><font color="FFFFFF">Item</font></td>
		<td height="18" bgcolor="006633" class="productTitle" width="50%" ><font color="FFFFFF">Description</font></td>
		<td height="18" bgcolor="006633" class="productTitle" width="7%" align="center"><font color="FFFFFF">Qty</font></td>
		<td height="18" bgcolor="006633" class="productTitle">&nbsp;</td>
	</tr>

	<!--- LIST DATA --->	
	<cfif qryDetail.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="4" class="productTitle"><font color="FF0000">This Receipt has no serialized items.</font></td>
		</tr>
	</cfif>
	
	<cfloop query="qryDetail">
		<cfset PostedFlag = objSerialsReceipts.getPostedFlagAlternate(qryDetail.RCPHSEQ, qryDetail.RCPLREV, qryDetail.RQRECEIVED)>
	
		<tr<cfif qryDetail.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>

			<td class="textsmall" align="left">
				<cfif PostedFlag IS NOT "Serial Numbers Posted">
					<a href="index.cfm?task=serials_receipts_serials_edit&RCPHSEQ=#urlEncodedFormat(qryDetail.RCPHSEQ)#&RCPLREV=#urlEncodedFormat(qryDetail.RCPLREV)#">
						#qryDetail.ITEMNO#
					</a>
				<cfelse>
					<a href="index.cfm?task=serials_receipts_serials_view&RCPHSEQ=#urlEncodedFormat(qryDetail.RCPHSEQ)#&RCPLREV=#urlEncodedFormat(qryDetail.RCPLREV)#">
						#qryDetail.ITEMNO#
					</a>
				</cfif>
			</td>
			<td class="textsmall" align="left">#qryDetail.ITEMDESC#</td>
			<td class="textsmall" align="center">#int(qryDetail.RQRECEIVED)#</td>
			<td class="textsmall" align="left">
				<cfif PostedFlag IS NOT "No Serial Numbers">
					<a href="index.cfm?task=serials_receipts_serials_view&RCPHSEQ=#urlEncodedFormat(qryDetail.RCPHSEQ)#&RCPLREV=#urlEncodedFormat(qryDetail.RCPLREV)#">
						#PostedFlag#
					</a>
				<cfelse>
					#PostedFlag#
				</cfif>
			</td>
		</tr>
	</cfloop>
	</table>
</td>
</tr>

</table>
</cfoutput>