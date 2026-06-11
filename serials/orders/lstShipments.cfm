<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/26/2006
	Function: 		This page displays a list of Shipments for the entered order
	Template:		lstShipments.cfm
	Task:			serials_shipments_list
--->
	<cfset objOESHIH = createObject("component", "admin.assets.cfcs.OESHIH")>
	<cfset objOEORDH = createObject("component", "admin.assets.cfcs.OEORDH")>
	<cfset objOEINVH = createObject("component", "admin.assets.cfcs.OEINVH")>

	<cfparam name="URL.SortColumn" type="string" default="SHINUMBER">
	<cfparam name="URL.SortOrder" type="string" default="Asc">

	<!--- set the new sort order for display --->
	<cfif URL.SortOrder IS "Desc">
		<cfset Variables.NewSortOrder = "Asc">
	<cfelse>
		<cfset Variables.NewSortOrder = "Desc">
	</cfif>

	<cfif trim(URL.SortColumn) IS  "SHIDATE">		
		<cfset Variables.OrderByList = "SHIDATE " & URL.SortOrder & ", SHINUMBER " & URL.SortOrder>
	<cfelse>
		<cfset Variables.OrderByList = URL.SortColumn & " " & URL.SortOrder>
	</cfif>
	
	<cfset qryShipments = objOESHIH.listRecordsForParent("ORDNUMBER", URL.ORDNUMBER, Variables.OrderByList)>
	
	<!--- Get a query of the Order --->
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "ORDNUMBER", URL.ORDNUMBER, True)>
	<cfset qryOrder = objOEORDH.searchRecords(SearchRecord, "query")>
<!---
	<!--- Get a structure of the Order --->
	<cfset strOrder = objOEORDH.getRecord(URL.ORDUNIQ)>
--->		
</cfsilent>

<!--- If only one shipment is found for this order, the user is forwarded to the item list for this shipment --->
<cfif qryShipments.RecordCount EQ 1>
	<cflocation url="index.cfm?task=serials_shipments_items_list&SHIUNIQ=#urlEncodedFormat(qryShipments.SHIUNIQ)#">
</cfif>


<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">Invoices List</td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<!--- link back --->
<tr>
	<td class="textsmall" align="right">
		<a href="index.cfm?task=serials_orders_enter">
			Back to Order Number Entry Page
		</a>
	</td>
</tr>

<tr>
<td valign="top" class="textmain">

	<!--- ORDER INFORMATION --->
	<cfinclude template="orderInfo.cfm">
	<tr><td>&nbsp;</td></tr>

	<table cellpadding="0" cellspacing="0" width="100%" border="0">
	
	<!--- LIST HEADINGS --->
	<tr>
		<td height="18" bgcolor="006633" width="25%">
			<a class="menuwh" href="index.cfm?task=serials_shipments_list&SortColumn=SHINUMBER&SortOrder=#NewSortOrder#&ORDUNIQ=#urlEncodedFormat(qryOrder.ORDUNIQ)#&ORDNUMBER=#urlEncodedFormat(qryOrder.ORDNUMBER)#">
				Invoice Number
			</a>
		</td>
		<td height="18" bgcolor="006633">
			<a class="menuwh" href="index.cfm?task=serials_shipments_list&SortColumn=SHIDATE&SortOrder=#NewSortOrder#&ORDUNIQ=#urlEncodedFormat(qryOrder.ORDUNIQ)#&ORDNUMBER=#urlEncodedFormat(qryOrder.ORDNUMBER)#">
				Date of Invoice
			</a>
		</td>
	</tr>

	<!--- LIST DATA --->	
	<cfif qryShipments.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="2" class="productTitle"><font color="FF0000">No shipments were found for this order number.</font></td>
		</tr>
	</cfif>
	
	<cfloop query="qryShipments">
		<tr<cfif qryShipments.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
		
			<!--- Get the invoice --->
			<cfset strSearch = structNew()>
			<cfset structInsert(strSearch, "ORDNUMBER", qryShipments.ORDNUMBER, True)>
			<cfset structInsert(strSearch, "SHINUMBER", qryShipments.SHINUMBER, True)>
			<cfset qryOEINVH = objOEINVH.searchRecords(strSearch, "query")>
			<cfif qryOEINVH.RecordCount NEQ 0>
				<cfset InvoiceNumber = qryOEINVH.INVNUMBER>
				<cfset InvoiceDate = objOEINVH.formatDate(qryOEINVH.INVDATE)>
			<cfelse>	<!--- Should never happen --->
				<cfset InvoiceNumber = "[Unknown]">
				<cfset InvoiceDate = "[Unknown]">
			</cfif>

			<td class="textsmall" align="left">
				<a href="index.cfm?task=serials_shipments_items_list&SHIUNIQ=#urlEncodedFormat(qryShipments.SHIUNIQ)#">
					#InvoiceNumber#
<!---				#qryShipments.SHINUMBER#	--->
				</a>
			</td>
			<td class="textsmall" align="left">
				#InvoiceDate#
<!---			#objOESHIH.formatDate(qryShipments.SHIDATE)#	--->
			</td>
		</tr>
	</cfloop>

	</table>
</td>
</tr>


</table>
</cfoutput>