<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	12/31/2007
	Function: 		This page displays a list of comop build items
	Template:		lstCompBuild.cfm
	Task:			serials_admin_compbuild_list
--->
	<cfset objCompBuildItems = createObject("component", "admin.assets.cfcs.CompBuildItems")>
	<cfset Error = "">

	<cfparam name="URL.SortColumn" type="string" default="ITEMNO">
	<cfparam name="URL.SortOrder" type="string" default="Asc">

	<!--- set the new sort order for display --->
	<cfif URL.SortOrder IS "Desc">
		<cfset Variables.NewSortOrder = "Asc">
	<cfelse>
		<cfset Variables.NewSortOrder = "Desc">
	</cfif>

	<cfset Variables.OrderByList = URL.SortColumn & " " & URL.SortOrder>

	<cfif isDefined("FORM.ITEMNO") AND isDefined("FORM.ITEMDESC")>
		<cfset SearchRecord = structNew()>
		<cfif trim(FORM.ITEMNO) IS NOT "">
			<cfset structInsert(SearchRecord, "ITEMNO", FORM.ITEMNO, True)>
		</cfif>
		<cfif trim(FORM.ITEMDESC) IS NOT "">
			<cfset structInsert(SearchRecord, "ITEMDESC", FORM.ITEMDESC, True)>
		</cfif>
		<cfset qryCompBuildItems = objCompBuildItems.searchRecords(SearchRecord, "query", Variables.OrderByList, 0)>
		<cfif qryCompBuildItems.RecordCount EQ 0>
			<cfset Error = "No Match Found">
		</cfif>
	<cfelse>
		<cfset qryCompBuildItems = objCompBuildItems.listRecords("query", Variables.OrderByList)>
	</cfif>
	
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
	<td valign="top" class="subpagetitle" colspan="3">Comp Build Items List</td>
</tr>

<tr><!--- Link back to "Add a New Item" --->
	<td valign="top" class="textmain" colspan="3" align="right">
		<a href="index.cfm?task=serials_admin_compbuild_new">
			Add a New Item
		</a>
	</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain" colspan="3"><font color="FF0000">#objCompBuildItems.getMessage()#</font></td>
</tr>


<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<td valign="top" class="textmain" colspan="3">
		The following list displays "Comp Build Items".  If one of these items is found on any line of an order, that order is considered a "Comp Build" order.
	</td>
</tr>

<form name="ItemNumberSearch" action="index.cfm?task=serials_admin_compbuild_list" method="post">
	<tr>
		<td class="textmain" width="25%"><strong>Item Number:</strong></td>
		<td class="textmain" width="40%">
			<input name="ITEMNO" size="20" maxlength="50"
				<cfif isDefined("FORM.ITEMNO")>
					value="#FORM.ITEMNO#"
				</cfif>
			>
		</td>
		<td class="textmain" align="left">
			<input type="submit" name="ProcessSearch" value="Search">
		</td>
	</tr>
	<tr>
		<td class="textmain"><strong>Item Description:</strong></td>
		<td class="textmain">
			<input name="ITEMDESC" size="20" maxlength="50"
				<cfif isDefined("FORM.ITEMDESC")>
					value="#FORM.ITEMDESC#"
				</cfif>
			>
		</td>
	</tr>
</form>
<cfif Error IS NOT "">
	<tr><td class="textsmall">&nbsp;</td></tr>
	<tr>
		<td class="textmain" align="left" colspan="3">
			<font color="FF0000">
				<cfif Error IS "Both Empty"	>
					Please enter an Item Number and/or Description (partial or full) before clicking "Search".
				<cfelseif Error IS "No Match Found">
					<cfif trim(FORM.ITEMNO) IS NOT "" AND trim(FORM.ITEMDESC) IS NOT "" >
						No items were found matching your search critera.
					<cfelseif trim(FORM.ITEMNO) IS NOT "">
						Item Number '#FORM.ITEMNO#' was not found.
					<cfelseif trim(FORM.ITEMDESC) IS NOT "">
						Item Description '#FORM.ITEMDESC#' was not found.
					</cfif>
				</cfif>
			</font>
		</td>
	</tr>
</cfif>

<tr>
<td valign="top" class="textmain" colspan="3">
	<table cellpadding="0" cellspacing="0" width="100%" border="0">
	
	<!--- LIST HEADINGS --->
	<tr>
		<td height="18" bgcolor="006633" width="40%">
			<a class="menuwh" href="index.cfm?task=serials_admin_compbuild_list&SortColumn=ITEMNO&SortOrder=#NewSortOrder#">
				Item Number
			</a>
		</td>
		<td height="18" bgcolor="006633" width="50%">
			<a class="menuwh" href="index.cfm?task=serials_admin_compbuild_list&SortColumn=ITEMDESC&SortOrder=#NewSortOrder#">
				Description
			</a>
		</td>
		<td height="18" bgcolor="006633">&nbsp;</td>
	</tr>

	<!--- LIST DATA --->	
	<cfif qryCompBuildItems.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="3" class="productTitle"><font color="FF0000">There are currently no Comp Build Items on file.</font></td>
		</tr>
	</cfif>
	
	<cfloop query="qryCompBuildItems">
		<tr<cfif qryCompBuildItems.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
			<td class="textsmall" align="left">#qryCompBuildItems.ITEMNO#</td>
			<td class="textsmall" align="left">#qryCompBuildItems.ITEMDESC#</td>
			<td class="textsmall" align="center">
				<a href="index.cfm?task=serials_admin_compbuild_delete&CompBuildItemsID=#urlEncodedFormat(qryCompBuildItems.CompBuildItemsID)#" onclick="return confirmDelete()">
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