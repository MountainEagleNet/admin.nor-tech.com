<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	11/02/2006
	Function: 		This page displays a list of virtual items
	Template:		lstVirtual.cfm
	Task:			serials_admin_virtual_list
--->
	<cfset objVirtualItems = createObject("component", "admin.assets.cfcs.VirtualItems")>

	<cfparam name="URL.SortColumn" type="string" default="ITEMNO">
	<cfparam name="URL.SortOrder" type="string" default="Asc">

	<!--- set the new sort order for display --->
	<cfif URL.SortOrder IS "Desc">
		<cfset Variables.NewSortOrder = "Asc">
	<cfelse>
		<cfset Variables.NewSortOrder = "Desc">
	</cfif>

	<cfset Variables.OrderByList = URL.SortColumn & " " & URL.SortOrder>
	
	<cfset qryVirtualItems = objVirtualItems.listRecords("query", Variables.OrderByList)>

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
	<td valign="top" class="subpagetitle">Virtual Item List</td>
</tr>

<tr><!--- Link back to "Add a New Item" --->
	<td valign="top" class="textmain" colspan="2" align="right">
		<a href="index.cfm?task=serials_admin_virtual_new">
			Add a New Item
		</a>
	</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objVirtualItems.getMessage()#</font></td>
</tr>


<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<td valign="top" class="textmain">
		The following list displays "Virtual Items".  These are items that are not stocked in inventory; they are shipped, but they are never received.  Therefore, when fulfilling an order, if the item is a "Virtual Item", the system will not check to make sure that the serial number is already on file.
	</td>
</tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="0" cellspacing="0" width="100%" border="0">
	
	<!--- LIST HEADINGS --->
	<tr>
		<td height="18" bgcolor="006633" width="40%">
			<a class="menuwh" href="index.cfm?task=serials_admin_virtual_list&SortColumn=ITEMNO&SortOrder=#NewSortOrder#">
				Item Number
			</a>
		</td>
		<td height="18" bgcolor="006633" width="50%">
			<a class="menuwh" href="index.cfm?task=serials_admin_virtual_list&SortColumn=ITEMDESC&SortOrder=#NewSortOrder#">
				Description
			</a>
		</td>
		<td height="18" bgcolor="006633">&nbsp;</td>
	</tr>

	<!--- LIST DATA --->	
	<cfif qryVirtualItems.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="3" class="productTitle"><font color="FF0000">There are currently no Virtual Items on file.</font></td>
		</tr>
	</cfif>
	
	<cfloop query="qryVirtualItems">
		<tr<cfif qryVirtualItems.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
			<td class="textsmall" align="left">#qryVirtualItems.ITEMNO#</td>
			<td class="textsmall" align="left">#qryVirtualItems.ITEMDESC#</td>
			<td class="textsmall" align="center">
				<a href="index.cfm?task=serials_admin_virtual_delete&VirtualItemID=#urlEncodedFormat(qryVirtualItems.VirtualItemID)#" onclick="return confirmDelete()">
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