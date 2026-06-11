<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/28/2006
	Function: 		This page displays a list of items for a chosen return
	Template:		lstItems.cfm
	Task:			serials_returns_items_list
--->
	<cfset objRAHEAD = createObject("component", "admin.assets.cfcs.RAHEAD")>
	<cfset objRADET = createObject("component", "admin.assets.cfcs.RADET")>
	<cfset objSerialsReturns = createObject("component", "admin.assets.cfcs.SerialsReturns")>

	<!--- Get a structure of the Return header --->
	<cfset strHeader = objRAHEAD.getRecord(URL.RMAUNIQ)>
	
	<!--- Get a query of the Return lines --->	
	<cfset qryDetail = objRADET.getSerializedLinesQuantity(URL.RMAUNIQ)>

</cfsilent>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">#URL.RMAACTION# - Return/RMA Item List</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objSerialsReturns.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<!--- link back --->
<tr>
	<td class="textsmall" align="right">
		<a href="index.cfm?task=serials_returns_enter&RMAACTION=#urlEncodedFormat(URL.RMAACTION)#">
			Back to RMA Entry Page
		</a>
	</td>
</tr>

<!--- "START SCAN" link --->
<!--- If not all items for this RMA have been posted, find the first non-posted one and go directly to frmSerials --->
<cfset FirstUnpostedLINENUM = objSerialsReturns.getFirstUnpostedItem(URL.RMAUNIQ, "[NONE]", URL.RMAACTION)>
<cfif FirstUnpostedLINENUM IS NOT "">
	<cfif URL.RMAACTION IS "Authorization">
		<cfset SerialTask = "serials_returns_serialsauth_edit">
	<cfelse>
		<cfset SerialTask = "serials_returns_serialsrcv_edit">
	</cfif>
	<tr>
		<td class="textmain" align="right">
			<a href="index.cfm?task=#SerialTask#&RMAUNIQ=#urlEncodedFormat(URL.RMAUNIQ)#&LINENUM=#urlEncodedFormat(FirstUnpostedLINENUM)#&RMAAction=#URL.RMAAction#">
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
		<td height="18" bgcolor="006633" class="productTitle" width="45%" ><font color="FFFFFF">Description</font></td>
		<td height="18" bgcolor="006633" class="productTitle" width="10%" align="center"><font color="FFFFFF">Location</font></td>
		<td height="18" bgcolor="006633" class="productTitle" width="7%" align="center"><font color="FFFFFF">Qty</font></td>
		<td height="18" bgcolor="006633" class="productTitle">&nbsp;</td>
	</tr>

	<!--- LIST DATA --->	
	<cfif qryDetail.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="5" class="productTitle"><font color="FF0000">This RMA has no serialized items with a return quantity greater than zero.</font></td>
		</tr>
	</cfif>
	
	<cfloop query="qryDetail">
		<cfset PostedFlag = objSerialsReturns.getPostedFlag(qryDetail.RMAUNIQ, qryDetail.LINENUM)>
		
		<cfif PostedFlag IS "Serial Numbers Posted" OR qryDetail.QTY LE 0>
			<cfset ForwardTask = "serials_returns_serials_view">
		<cfelseif URL.RMAACTION IS "Authorization">
			<cfset ForwardTask = "serials_returns_serialsauth_edit">
		<cfelseif URL.RMAACTION IS "Receiving">
			<cfset ForwardTask = "serials_returns_serialsrcv_edit">
		<cfelse>
			<cfset ForwardTask = "serials_returns_serials_view">
		</cfif>
	
		<tr<cfif qryDetail.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
			<td class="textsmall" align="left">
				<a href="index.cfm?task=#ForwardTask#&RMAUNIQ=#urlEncodedFormat(qryDetail.RMAUNIQ)#&LINENUM=#urlEncodedFormat(qryDetail.LINENUM)#&RMAAction=#URL.RMAAction#">
					#qryDetail.ITEM#
				</a>
			</td>
			<td class="textsmall" align="left">#qryDetail.DESC#</td>
			<td class="textsmall" align="center">#qryDetail.LOCATION#</td>
			<td class="textsmall" align="center">#int(qryDetail.QTY)#</td>
			<td class="textsmall" align="left">#PostedFlag#</td>
		</tr>
	</cfloop>
	</table>
</td>
</tr>

</table>
</cfoutput>