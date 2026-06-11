<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/05/2006
	Function: 		This page displays a list of items for a chosen transfer
	Template:		lstItems.cfm
	Task:			serials_transfers_items_list
--->
	<cfset objICTREH = createObject("component", "admin.assets.cfcs.ICTREH")>
	<cfset objICTRED = createObject("component", "admin.assets.cfcs.ICTRED")>
	<cfset objSerialsTransfers = createObject("component", "admin.assets.cfcs.SerialsTransfers")>

	<!--- Get a structure of the Transfer header --->
	<cfset strHeader = objICTREH.getRecord(URL.TRANFENSEQ)>
	
	<!--- Get a query of the Transfer lines --->	
	<cfset qryDetail = objICTRED.getSerializedLines(URL.TRANFENSEQ)>

</cfsilent>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">Transfer Item List</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objSerialsTransfers.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<!--- link back --->
<tr>
	<td class="textsmall" align="right">
		<a href="index.cfm?task=serials_transfers_list">
			Back to Transfers List
		</a>
	</td>
</tr>

<tr>
<td valign="top" class="textmain">

	<!--- HEADER INFORMATION --->
	<cfinclude template="headerInfo.cfm">
	<tr><td>&nbsp;</td></tr>

	<table cellpadding="0" cellspacing="0" width="100%" border="0">
	
	<!--- LIST HEADINGS --->
	<tr>
		<td height="18" bgcolor="006633" class="productTitle" width="22%" ><font color="FFFFFF">Item</font></td>
		<td height="18" bgcolor="006633" class="productTitle" width="35%" ><font color="FFFFFF">Description</font></td>
		<td height="18" bgcolor="006633" class="productTitle" width="7%" align="center"><font color="FFFFFF">Qty</font></td>
		<td height="18" bgcolor="006633" class="productTitle" width="7%" align="center"><font color="FFFFFF">From</font></td>
		<td height="18" bgcolor="006633" class="productTitle" width="7%" align="center"><font color="FFFFFF">To</font></td>
		<td height="18" bgcolor="006633" class="productTitle">&nbsp;</td>
	</tr>

	<!--- LIST DATA --->	
	<cfif qryDetail.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="6" class="productTitle"><font color="FF0000">This Transfer has no serialized items.</font></td>
		</tr>
	</cfif>
	
	<cfloop query="qryDetail">
		<cfset PostedFlag = objSerialsTransfers.getPostedFlag(qryDetail.TRANFENSEQ, qryDetail.LINENO)>
	
		<tr<cfif qryDetail.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>

			<td class="textsmall" align="left">
				<cfif PostedFlag IS NOT "Serial Numbers Posted">
					<a href="index.cfm?task=serials_transfers_serials_edit&TRANFENSEQ=#urlEncodedFormat(qryDetail.TRANFENSEQ)#&LINENO=#urlEncodedFormat(qryDetail.LINENO)#">
						#qryDetail.ITEMNO#
					</a>
				<cfelse>
					<a href="index.cfm?task=serials_transfers_serials_view&TRANFENSEQ=#urlEncodedFormat(qryDetail.TRANFENSEQ)#&LINENO=#urlEncodedFormat(qryDetail.LINENO)#">
						#qryDetail.ITEMNO#
					</a>
				</cfif>
			</td>
			<td class="textsmall" align="left">#qryDetail.ITEMDESC#</td>
			<td class="textsmall" align="center">#int(qryDetail.QUANTITY)#</td>
			<td class="textsmall" align="center">#qryDetail.FROMLOC# <!---#qryDetail.FRLOCDESC#---></td>
			<td class="textsmall" align="center">#qryDetail.TOLOC# <!---#qryDetail.TOLOCDESC#---></td>
			<td class="textsmall" align="left">#PostedFlag#</td>
		</tr>
	</cfloop>
	</table>
</td>
</tr>

</table>
</cfoutput>