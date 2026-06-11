<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/31/2007
	Function: 		This page displays a list of parts
	Template:		lstPartsAdmin.cfm
	Task:			parts_admin_list
--->
	<cfset objPartsAdmin = createObject("component", "admin.assets.cfcs.parts.PartsAdmin")>
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

	<cfset SearchRecord = structNew()>
	<cfif isDefined("FORM.ITEMNO") AND isDefined("FORM.ITEMDESC") AND isDefined("FORM.InactiveStatus")>
		<cfif trim(FORM.ITEMNO) IS NOT "">
			<cfset structInsert(SearchRecord, "ITEMNO", FORM.ITEMNO, True)>
		</cfif>
		<cfif trim(FORM.ITEMDESC) IS NOT "">
			<cfset structInsert(SearchRecord, "ITEMDESC", FORM.ITEMDESC, True)>
		</cfif>
		<cfif FORM.InactiveStatus IS "Active">
			<cfset structInsert(SearchRecord, "Inactive", 0, True)>
		<cfelseif FORM.InactiveStatus IS "Inactive">
			<cfset structInsert(SearchRecord, "Inactive", 1, True)>
		</cfif>
		
		<cfset qryPartsAdmin = objPartsAdmin.searchRecords(SearchRecord, "query", Variables.OrderByList, 0)>
		<cfif qryPartsAdmin.RecordCount EQ 0>
			<cfset Error = "No Match Found">
		</cfif>
	<cfelse>
		<cfset structInsert(SearchRecord, "Inactive", 0, True)>
		<cfset qryPartsAdmin = objPartsAdmin.searchRecords(SearchRecord, "query", Variables.OrderByList, 0)>
<!---	<cfset qryPartsAdmin = objPartsAdmin.listRecords("query", Variables.OrderByList)>	--->
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
<table width="575" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle" colspan="3">Parts Maintenance</td>
</tr>

<tr><!--- Link to "Add a New Item" --->
	<td valign="top" class="textmain" colspan="3" align="right">
		<a href="index.cfm?task=parts_admin_new">
			Add a New Item
		</a>
	</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain" colspan="3"><font color="FF0000">#objPartsAdmin.getMessage()#</font></td>
</tr>


<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<td valign="top" class="textsmall" colspan="3">
		The following list displays a list of parts from ACCPAC.  Items are added to this list for one of two reasons:
		<ul>
			<li>To mark them as "Nor-Tech Closeout Specials" items and to enter a selling price.</li>
			<li>To enter a vendor's website URL, allowing the partner to view further details of the item.</li>
		</ul>
		Search for an item in the list by entering the Item number or description below and clicking "Search".<br>
		Add a new item to the list by clicking "Add a New Item" above.<br>
		Edit an existing item by clicking the Item Number in the list.
	</td>
</tr>

<form name="ItemNumberSearch" action="index.cfm?task=parts_admin_list" method="post">
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
	
	<tr>
		<td class="textmain" valign="top"><strong>Closeout Specials:</strong></td>
		<td class="textmain">
			<input type="radio" name="InactiveStatus" value="Active" 
				<cfif NOT isDefined("FORM.InactiveStatus") OR FORM.InactiveStatus IS "Active">checked</cfif>
				>Active Items Only <br>
			<input type="radio" name="InactiveStatus" value="Inactive" 
				<cfif isDefined("FORM.InactiveStatus") AND FORM.InactiveStatus IS "Inactive">checked</cfif>
				>Inactive Items Only <br>
			<input type="radio" name="InactiveStatus" value="Both" 
				<cfif isDefined("FORM.InactiveStatus") AND FORM.InactiveStatus IS "Both">checked</cfif>
				>Both 
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
		<td valign="bottom" height="18" bgcolor="006633">
			<a class="menuwh" href="index.cfm?task=parts_admin_list&SortColumn=ITEMNO&SortOrder=#NewSortOrder#">
				Item
			</a>
		</td>
		<td valign="bottom" height="18" bgcolor="006633">
			<a class="menuwh" href="index.cfm?task=parts_admin_list&SortColumn=ITEMDESC&SortOrder=#NewSortOrder#">
				Description
			</a>
		</td>
		<td valign="bottom" height="18" bgcolor="006633" align="center">
			<a class="menuwh" href="index.cfm?task=parts_admin_list&SortColumn=ITEMDESC&SortOrder=#NewSortOrder#">
				Nor-Tech<br>Closeout<br>Specials<br>Item?
			</a>
		</td>
		<td valign="bottom" height="18" bgcolor="006633" align="center">
			<a class="menuwh" href="index.cfm?task=parts_admin_list&SortColumn=SellPrice&SortOrder=#NewSortOrder#">
				Selling<br>Price
			</a>
		</td>
		<td valign="bottom" height="18" bgcolor="006633">
			<a class="menuwh" href="index.cfm?task=parts_admin_list&SortColumn=VendorURL&SortOrder=#NewSortOrder#">
				Vendor<br>Website
			</a>
		</td>
		<td valign="bottom" height="18" bgcolor="006633" style="color:FFFFFF; font-weight:bold; font-size:12px">Inactive<br>Date</td>
		<td height="18" bgcolor="006633" width="8%">&nbsp;</td>
	</tr>

	<!--- LIST DATA --->	
	<cfif qryPartsAdmin.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="7" class="productTitle"><font color="FF0000">There are currently no Parts entered on the list.</font></td>
		</tr>
	</cfif>
	
	<cfloop query="qryPartsAdmin">
		<tr<cfif qryPartsAdmin.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
			<td class="textsmall" align="left">
				<a href="index.cfm?task=parts_admin_edit&PartsAdminID=#urlEncodedFormat(qryPartsAdmin.PartsAdminID)#">
					#qryPartsAdmin.ITEMNO#
				</a>				
			</td>
			
			<td class="textsmall" align="left">
				<cfif len(trim(qryPartsAdmin.ITEMDESC)) GT 20>
					#left(trim(qryPartsAdmin.ITEMDESC), 20)#...
				<cfelse>
					#trim(qryPartsAdmin.ITEMDESC)#
				</cfif>
			</td>
			
			<td class="textsmall" align="center">#yesNoFormat(qryPartsAdmin.GarageSale)#</td>
			
			<td class="textsmall" align="center">
				<cfif qryPartsAdmin.GarageSale EQ 1>
					#dollarFormat(qryPartsAdmin.SellPrice)#
				<cfelse>
					&nbsp;
				</cfif>
			</td>
			
			<td class="textsmall" align="left">
				<cfif len(trim(qryPartsAdmin.VendorURL)) GT 20>
					#left(trim(qryPartsAdmin.VendorURL), 20)#...
				<cfelse>
					#trim(qryPartsAdmin.VendorURL)#
				</cfif>
			</td>
			
			<td class="textsmall" align="left">
				<cfif qryPartsAdmin.DateInactive IS "1/1/1900">
					&nbsp;
				<cfelseif isDate(qryPartsAdmin.DateInactive)>
					#dateFormat(qryPartsAdmin.DateInactive, 'mm/dd/yy')#
				</cfif>
			</td>
			
			<td class="textsmall" align="center">
				<cfif qryPartsAdmin.GarageSale EQ 0>
					<a href="index.cfm?task=parts_admin_delete&PartsAdminID=#urlEncodedFormat(qryPartsAdmin.PartsAdminID)#" onclick="return confirmDelete()">
						[delete]
					</a>
				<cfelse>
					&nbsp;				
				</cfif>
			</td>
			
		</tr>
	</cfloop>

	</table>
</td>
</tr>

</table>
</cfoutput>