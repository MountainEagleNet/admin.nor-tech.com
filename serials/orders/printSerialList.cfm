<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	10/16/2006
	Function: 		This page displays a list of serial numbers in a printable format
	Template:		printSerialList.cfm
	Task:			serials_attach_print
--->	
	<cfset objOEORDH = createObject("component", "admin.assets.cfcs.OEORDH")>
	<cfset objOEORDD = createObject("component", "admin.assets.cfcs.OEORDD")>
	<cfset objOEINVH = createObject("component", "admin.assets.cfcs.OEINVH")>
	<cfset objOEINVD = createObject("component", "admin.assets.cfcs.OEINVD")>

	<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>

	<!--- Get a structure of the Order header --->
	<cfif isDefined("URL.ORDUNIQ")>
		<cfset strHeader = objOEORDH.getRecord(URL.ORDUNIQ)>
	<cfelse>
		<cfset strHeader = objOEORDH.getRecord(FORM.ORDUNIQ)>
	</cfif>

	<!--- Get a structure of the Invoice header --->
	<cfif isDefined("URL.INVUNIQ")>
		<cfset strOEINVH = objOEINVH.getRecord(URL.INVUNIQ)>
	<cfelse>
		<cfset strOEINVH = objOEINVH.getRecord(FORM.INVUNIQ)>
	</cfif>
	
	<!--- Get a query of the Invoice lines --->	
	<cfif isDefined("URL.INVUNIQ")>
		<cfset qryDetail = objOEINVD.getSerializedLines(URL.INVUNIQ)>
	<cfelse>
		<cfset qryDetail = objOEINVD.getSerializedLines(FORM.INVUNIQ)>
	</cfif>
	
</cfsilent>

<script language="javascript">
	window.onload = init;
	function init() {
		window.print();
	}
</script>

<cfoutput>
<table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">

<!---
<tr><!--- Logo --->
	<td>
		<cfif left(trim(strHeader.CUSTOMER), 2) IS "RE" OR (isDefined("FORM.Company") AND FORM.Company IS "Reason")>
			<img src="/images/ReasonLogo.gif" alt="" name="logo" width="200" border="0">
		<cfelse>
			<img src="/images/logo.gif" alt="" name="logo" width="150" border="0">
		</cfif>
	</td>
</tr>
--->

<!---height="61" --->

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">Serial Number List</td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<td valign="top" class="textmain" width="50%">
		<table width="100%" border="0" cellpadding="3" cellspacing="1">
			<tr>
				<td class="textmain" align="left" width="40%"><b>Order Number:</b></td>
				<td class="textmain" align="left">#strHeader.ORDNUMBER#</td>
			</tr>
			<tr>
				<td class="textmain" align="left"><b>Order Date:</b></td>
				<td class="textmain" align="left">#objOEORDH.formatDate(strHeader.ORDDATE)#</td>
			</tr>
		</table>
	</td>

	<td valign="top" class="textmain">
		<table width="100%" border="0" cellpadding="3" cellspacing="1">
			<tr>
				<td width="45%" class="textmain" align="left"><b>Invoice Number:</b></td>
				<td class="textmain" align="left">#strOEINVH.INVNUMBER#</td>
			</tr>
			<tr>
				<td class="textmain" align="left"><b>Invoice Date:</b></td>
				<td class="textmain" align="left">#objOEINVH.formatDate(strOEINVH.INVDATE)#</td>
			</tr>
		</table>
	</td>
</tr>

<cfif NOT isDefined("FORM.Customer") OR trim(FORM.Customer) IS NOT "">
	<tr>
		<td valign="top" class="textmain" colspan="2">
			<table width="100%" border="0" cellpadding="1" cellspacing="0">
				<tr>
					<td width="20%" class="textmain" align="left">&nbsp;<b>Customer:</b></td>
					<td class="textmain" align="left">
						<cfif isDefined("FORM.Customer")>
							#FORM.Customer#
						<cfelse>
							#strHeader.BILNAME#
						</cfif>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</cfif>
<tr><td>&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain" colspan="2">
<!---<table cellpadding="0" cellspacing="0" width="100%" border="0">--->
	<table cellpadding="0" cellspacing="0" width="75%" border="0">
	
	<!--- LIST HEADINGS --->
	<tr>
		<td height="18" bgcolor="006633" class="productTitle" width="22%"><font color="FFFFFF">Item</font></td>
		<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Description / Serial Numbers</font></td>
	</tr>

	<!--- LIST DATA --->	
	<cfif qryDetail.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="4" class="productTitle"><font color="FF0000">This Order has no serialized items.</font></td>
		</tr>
	</cfif>
	
	<cfset PrintGray = 1>
	<cfloop query="qryDetail">
		<!--- Serial Numbers for this line --->
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "INVUNIQ", qryDetail.INVUNIQ, True)>
		<cfset structInsert(SearchRecord, "INVLINENUM", qryDetail.LINENUM, True)>
		<cfset qrySerialsShipments = objSerialsShipments.searchRecords(SearchRecord, "query", "SerialNumber")>
	
		<cfif qrySerialsShipments.RecordCount GT 0>
			
<!---		<tr<cfif qryDetail.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>	--->
			<tr<cfif PrintGray> style="background-color:##e5e5e6"</cfif>>
				<td class="textsmall" align="left">#qryDetail.ITEM#</td>
				<td class="textsmall" align="left">#qryDetail.DESC#</td>
			</tr>
<!---		<tr<cfif qryDetail.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>	--->
			<tr<cfif PrintGray> style="background-color:##e5e5e6"</cfif>>
				<td class="textsmall" align="left">&nbsp;</td>
	
				<cfset SerialNumberList = "">
				<cfset FirstOne = 1>
				<cfloop query="qrySerialsShipments">
					<cfif FirstOne>
						<cfset FirstOne = 0>
					<cfelse>
						<cfset SerialNumberList = SerialNumberList & ", ">
					</cfif>
					<cfset SerialNumberList = SerialNumberList & qrySerialsShipments.SerialNumber>
				</cfloop>
				<td class="textsmall" align="left">#SerialNumberList#</td>
			</tr>
<!---		<tr<cfif qryDetail.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>	--->
			<tr<cfif PrintGray> style="background-color:##e5e5e6"</cfif>>
				<td colspan="2"><img src="/imagesTemp/spacer.gif" alt="" width="1" height="10" border="0"></td>
			</tr>
			<cfif PrintGray>
				<cfset PrintGray = 0>
			<cfelse>
				<cfset PrintGray = 1>
			</cfif>
			
		</cfif>
		
	</cfloop>
	</table>
</td>
</tr>

</table>
</cfoutput>