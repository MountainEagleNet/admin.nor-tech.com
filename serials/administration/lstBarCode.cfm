<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	10/20/2006
	Function: 		This page displays a list of bar code items
	Template:		lstBarCode.cfm
	Task:			serials_admin_barcode_list
--->
	<cfset objPrintBarCodeItems = createObject("component", "admin.assets.cfcs.PrintBarCodeItems")>

	<cfparam name="URL.SortColumn" type="string" default="ITEMNO">
	<cfparam name="URL.SortOrder" type="string" default="Asc">

	<!--- set the new sort order for display --->
	<cfif URL.SortOrder IS "Desc">
		<cfset Variables.NewSortOrder = "Asc">
	<cfelse>
		<cfset Variables.NewSortOrder = "Desc">
	</cfif>

	<cfset Variables.OrderByList = URL.SortColumn & " " & URL.SortOrder>
	
	<cfset qryPrintBarCodeItems = objPrintBarCodeItems.listRecords("query", Variables.OrderByList)>

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
	<td valign="top" class="subpagetitle">Print Bar Code Item List</td>
</tr>

<tr><!--- Link back to "Add a New Item" --->
	<td valign="top" class="textmain" colspan="2" align="right">
		<a href="index.cfm?task=serials_admin_barcode_new">
			Add a New Item
		</a>
	</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objPrintBarCodeItems.getMessage()#</font></td>
</tr>


<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<td valign="top" class="textmain">
		The following list displays "Print Bar Code Items".  When performing a receiving of any of these items, the "Print bar codes labels" checkbox will be checked by default.
	</td>
</tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="0" cellspacing="0" width="100%" border="0">
	
	<!--- LIST HEADINGS --->
	<tr>
		<td height="18" bgcolor="006633" width="40%">
			<a class="menuwh" href="index.cfm?task=serials_admin_barcode_list&SortColumn=ITEMNO&SortOrder=#NewSortOrder#">
				Item Number
			</a>
		</td>
		<td height="18" bgcolor="006633" width="50%">
			<a class="menuwh" href="index.cfm?task=serials_admin_barcode_list&SortColumn=ITEMDESC&SortOrder=#NewSortOrder#">
				Description
			</a>
		</td>
		<td height="18" bgcolor="006633">&nbsp;</td>
	</tr>

	<!--- LIST DATA --->	
	<cfif qryPrintBarCodeItems.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="3" class="productTitle"><font color="FF0000">There are currently no Print Bar Code Items on file.</font></td>
		</tr>
	</cfif>
	
	<cfloop query="qryPrintBarCodeItems">
		<tr<cfif qryPrintBarCodeItems.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
			<td class="textsmall" align="left">#qryPrintBarCodeItems.ITEMNO#</td>
			<td class="textsmall" align="left">#qryPrintBarCodeItems.ITEMDESC#</td>
			<td class="textsmall" align="center">
				<a href="index.cfm?task=serials_admin_barcode_delete&PrintBarCodeItemID=#urlEncodedFormat(qryPrintBarCodeItems.PrintBarCodeItemID)#" onclick="return confirmDelete()">
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