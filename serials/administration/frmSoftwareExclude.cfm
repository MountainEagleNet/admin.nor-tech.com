<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	07/18/2007
	Function: 		This page brings the user to a page where they can search for an inventory item to add to the list
	Template:		frmSoftwareExclude.cfm
	Task:			serials_admin_SW_new
--->
	<cfset objICITEM = createObject("component", "admin.assets.cfcs.ICITEM")>
	<cfset objSoftwareExclude = createObject("component", "admin.assets.cfcs.SoftwareExclude")>

	<cfset ExecuteSearch = 0>
	<cfset Error = "">
	
	<cfif isDefined("FORM.ITEMNO") AND isDefined("FORM.ITEMDESC")>
		<cfset ExecuteSearch = 1>
		<cfif trim(FORM.ITEMNO) IS "" AND trim(FORM.ITEMDESC) IS "">
			<cfset Error = "Both Empty">
		<cfelse>
			<cfset SearchRecord = structNew()>
			<cfif trim(FORM.ITEMNO) IS NOT "">
				<cfset structInsert(SearchRecord, "ITEMNO", FORM.ITEMNO, True)>
			</cfif>
			<cfif trim(FORM.ITEMDESC) IS NOT "">
				<cfset structInsert(SearchRecord, "DESC", FORM.ITEMDESC, True)>
			</cfif>
<!---		<cfset qryItems = objICITEM.searchRecords(SearchRecord, "query", "ITEMNO", 0)>	--->
			<cfset qryItems = objSoftwareExclude.searchAdminItems(SearchRecord)>
			<cfif qryItems.RecordCount EQ 0>
				<cfset Error = "No Match Found">
			</cfif>
		</cfif>
	</cfif>

</cfsilent>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle" colspan="3">Find Inventory Item</td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<form name="ItemNumberSearch" action="index.cfm?task=serials_admin_SW_new" method="post">
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
						Item Number '#FORM.ITEMNO#' was either not found, or is already included in the list of Software Excluded Items.
					<cfelseif trim(FORM.ITEMDESC) IS NOT "">
						Item Description '#FORM.ITEMDESC#' was not found.
					</cfif>
				</cfif>
			</font>
		</td>
	</tr>
</cfif>

<tr><td class="textsmall">&nbsp;</td></tr>
</cfoutput>

<cfif ExecuteSearch AND isDefined("qryItems") AND Error IS "">

	<tr>
	<td valign="top" class="textmain" colspan="3">
		<table cellpadding="0" cellspacing="0" width="100%" border="0">
		<form name="PickItems" action="index.cfm?task=serials_admin_SW_save" method="post">

		<tr>
			<td valign="top" class="textmain" colspan="2">
				Check the boxes for all items that you want to add to<br>the master list of "Software Excluded Items", then click "Add".
			</td>
			<td valign="top" class="textmain">
				<input type="submit" name="ProcessSearch" value="Add">
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	
		<!--- LIST HEADINGS --->
		<tr>
			<td height="18" bgcolor="006633" class="productTitle" width="40%"><font color="FFFFFF">Item Number</font></td>
			<td height="18" bgcolor="006633" class="productTitle" width="50%"><font color="FFFFFF">Description</font></td>
			<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">&nbsp;</font></td>
		</tr>
	
		<!--- LIST DATA --->	
		<cfif qryItems.RecordCount EQ 0>
			<tr>
				<td align="center" colspan="2" class="productTitle"><font color="FF0000">No matching records were found.</font></td>
			</tr>
		</cfif>
		
		<cfoutput query="qryItems" startrow="1" maxrows="20">
			<tr<cfif qryItems.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
	
				<td class="textsmall" align="left" valign="middle">#qryItems.ITEMNO#</td>
				<td class="textsmall" align="left" valign="middle">#qryItems.DESC#</td>
				<td class="textsmall" align="center">
					<input type="checkbox" name="ITEM_#qryItems.ITEMNO#" value="1">
<!---
					<a href="index.cfm?task=serials_admin_SW_save&ITEMNO=#urlEncodedFormat(qryItems.ITEMNO)#&ITEMDESC=#urlEncodedFormat(qryItems.DESC)#">
						[add]
					</a>
--->
				</td>
			</tr>
		</cfoutput>

		</form>
		</table>
	</td>
	</tr>

</cfif>


</table>

<script language="JavaScript" type="text/JavaScript">
<!--
document.ItemNumberSearch['ITEMNO'].focus();document.ItemNumberSearch['ITEMNO'].select()
-->
</script>