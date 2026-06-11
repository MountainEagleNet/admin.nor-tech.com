<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/03/2006
	Function: 		This page displays a list of items for a chosen return to vendor
	Template:		lstItems.cfm
	Task:			serials_returnsvendor_items_list
--->
	<cfset objPORETH1 = createObject("component", "admin.assets.cfcs.PORETH1")>
	<cfset objPORETL = createObject("component", "admin.assets.cfcs.PORETL")>
	<cfset objSerialsVendorReturns = createObject("component", "admin.assets.cfcs.SerialsVendorReturns")>

	<!--- Get a structure of the Receipt header --->
	<cfset strHeader = objPORETH1.getRecord(URL.RETHSEQ)>
	
	<!--- Get a query of the Receipt lines --->	
	<cfset qryDetail = objPORETL.getSerializedLines(URL.RETHSEQ)>

</cfsilent>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">Return to Vendor Item List</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objSerialsVendorReturns.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<!--- link back --->
<tr>
	<td class="textsmall" align="right">
		<a href="index.cfm?task=serials_returnsvendor_list">
			Back to Vendor Returns List
		</a>
	</td>
</tr>

<!--- "START SCAN" link --->
<!--- If not all items for this order have been posted, find the first non-posted one and go directly to frmSerials --->
<cfset FirstUnpostedRETLREV = objSerialsVendorReturns.getFirstUnpostedItem(URL.RETHSEQ)>
<cfif FirstUnpostedRETLREV IS NOT "">
	<tr>
		<td class="textmain" align="right">
			<a href="index.cfm?task=serials_returnsvendor_serials_edit&RETHSEQ=#urlEncodedFormat(URL.RETHSEQ)#&RETLREV=#urlEncodedFormat(FirstUnpostedRETLREV)#">
				START SCAN
			</a>
		</td>
	</tr>
</cfif>	

<tr>
<td valign="top" class="textmain">

	<!--- HEADER INFORMATION --->
	<cfinclude template="headerInfo.cfm">
	<tr><td>&nbsp;</td></tr>

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
			<td align="center" colspan="4" class="productTitle"><font color="FF0000">This Vendor Return has no serialized items.</font></td>
		</tr>
	</cfif>
	
	<cfloop query="qryDetail">
		<cfset PostedFlag = objSerialsVendorReturns.getPostedFlag(qryDetail.RETHSEQ, qryDetail.RETLREV)>
	
		<tr<cfif qryDetail.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>

			<td class="textsmall" align="left">
				<cfif PostedFlag IS NOT "Serial Numbers Posted">
					<a href="index.cfm?task=serials_returnsvendor_serials_edit&RETHSEQ=#urlEncodedFormat(qryDetail.RETHSEQ)#&RETLREV=#urlEncodedFormat(qryDetail.RETLREV)#">
						#qryDetail.ITEMNO#
					</a>
				<cfelse>
					<a href="index.cfm?task=serials_returnsvendor_serials_view&RETHSEQ=#urlEncodedFormat(qryDetail.RETHSEQ)#&RETLREV=#urlEncodedFormat(qryDetail.RETLREV)#">
						#qryDetail.ITEMNO#
					</a>
				</cfif>
			</td>
			<td class="textsmall" align="left">#qryDetail.ITEMDESC#</td>
			<td class="textsmall" align="center">#int(qryDetail.RQRETURNED)#</td>
			<td class="textsmall" align="left">#PostedFlag#</td>
		</tr>
	</cfloop>
	</table>
</td>
</tr>

</table>
</cfoutput>