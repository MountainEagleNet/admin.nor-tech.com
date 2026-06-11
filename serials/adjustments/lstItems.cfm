<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/03/2006
	Function: 		This page displays a list of items for a chosen adjustment
	Template:		lstItems.cfm
	Task:			serials_adjustments_items_list
--->
	<cfset objICADEH = createObject("component", "admin.assets.cfcs.ICADEH")>
	<cfset objICADED = createObject("component", "admin.assets.cfcs.ICADED")>
	<cfset objSerialsAdjustments = createObject("component", "admin.assets.cfcs.SerialsAdjustments")>
	<cfset objSerialsAdjustmentsExclude = createObject("component", "admin.assets.cfcs.SerialsAdjustmentsExclude")>

	<!--- Get a structure of the Receipt header --->
	<cfset strHeader = objICADEH.getRecord(URL.ADJENSEQ)>
	
	<!--- Get a query of the Receipt lines --->	
	<cfset qryDetail = objICADED.getSerializedLines(URL.ADJENSEQ)>

</cfsilent>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">Adjustment Item List</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objSerialsAdjustments.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<!--- link back --->
<tr>
	<td class="textsmall" align="right">
		<a href="index.cfm?task=serials_adjustments_list">
			Back to Adjustments List
		</a>
	</td>
</tr>

<!--- COPY SERIAL NUMBERS FROM RECEIPT --->
<tr>
	<td class="textsmall" align="right">
		<a href="index.cfm?task=serials_adjustments_serials_copy_edit&ADJENSEQ=#urlEncodedFormat(URL.ADJENSEQ)#&RequestTimeout=6000">
			Copy Serial Numbers from Receipt
		</a>
	</td>
</tr>

<tr>
<td valign="top" class="textmain">

	<!--- HEADER INFORMATION --->
	<cfinclude template="headerInfo.cfm">
	
	<!--- Comment (reason the adjustment ws removed from the list) --->
	<cfset qrySerialsAdjustmentsExclude = objSerialsAdjustmentsExclude.listRecordsForParent("ADJENSEQ", URL.ADJENSEQ)>
	<cfif isDefined("qrySerialsAdjustmentsExclude.RemoveComment") AND trim(qrySerialsAdjustmentsExclude.RemoveComment) IS NOT "">
		<table cellpadding="1" cellspacing="0" width="100%" border="0">
			<tr>
				<td width="30%" class="textmain" align="left"><b>Comment:</b></td>
				<td class="textmain" align="left">#qrySerialsAdjustmentsExclude.RemoveComment#</td>
			</tr>
			<tr>
				<td class="textmain" align="left">&nbsp;</td>
				<td class="textsmall" align="left" style="color:##FF0000 ">
					<em>(This comment indicates why this adjustment was removed from the list)</em>
				</td>
			</tr>
		</table>
	</cfif>
	
	<tr><td>&nbsp;</td></tr>

	<table cellpadding="0" cellspacing="0" width="100%" border="0">
	
	<!--- LIST HEADINGS --->
	<tr>
		<td height="18" bgcolor="006633" class="productTitle" width="22%" ><font color="FFFFFF">Item</font></td>
		<td height="18" bgcolor="006633" class="productTitle" width="35%" ><font color="FFFFFF">Description</font></td>
		<td height="18" bgcolor="006633" class="productTitle" width="10%" align="center"><font color="FFFFFF">Qty</font></td>
		<td height="18" bgcolor="006633" class="productTitle" width="10%">&nbsp;</td>
		<td height="18" bgcolor="006633" class="productTitle">&nbsp;</td>
	</tr>

	<!--- LIST DATA --->	
	<cfif qryDetail.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="5" class="productTitle"><font color="FF0000">This Adjustment has no serialized items.</font></td>
		</tr>
	</cfif>
	
	<cfloop query="qryDetail">
		<cfset PostedFlag = objSerialsAdjustments.getPostedFlag(qryDetail.ADJENSEQ, qryDetail.LINENO)>
	
		<tr<cfif qryDetail.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>

			<td class="textsmall" align="left">
				<cfif PostedFlag IS NOT "Serial Numbers Posted">
					<a href="index.cfm?task=serials_adjustments_serials_edit&ADJENSEQ=#urlEncodedFormat(qryDetail.ADJENSEQ)#&LINENO=#urlEncodedFormat(qryDetail.LINENO)#">
						#qryDetail.ITEMNO#
					</a>
				<cfelse>
					<a href="index.cfm?task=serials_adjustments_serials_view&ADJENSEQ=#urlEncodedFormat(qryDetail.ADJENSEQ)#&LINENO=#urlEncodedFormat(qryDetail.LINENO)#">
						#qryDetail.ITEMNO#
					</a>
				</cfif>
			</td>
			<td class="textsmall" align="left">#qryDetail.ITEMDESC#</td>
			<td class="textsmall" align="center">#int(qryDetail.QUANTITY)#</td>
			<td class="textsmall" align="left">
				<cfif qryDetail.TRANSTYPE EQ 1 OR qryDetail.TRANSTYPE EQ 3 OR qryDetail.TRANSTYPE EQ 5>
					Increase
				<cfelse>
					Decrease
				</cfif>
			</td>
			<td class="textsmall" align="left">#PostedFlag#</td>
		</tr>
	</cfloop>
	</table>
</td>
</tr>

</table>
</cfoutput>