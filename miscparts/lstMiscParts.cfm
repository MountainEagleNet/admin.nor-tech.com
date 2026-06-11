<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/31/2007
	Function: 		This page displays a list of parts
	Template:		lstMiscParts.cfm
	Task:			misc_parts_list
--->
	<cfset objMiscParts = createObject("component", "admin.assets.cfcs.parts.MiscParts")>
<!---<cfset Error = "">--->

	<cfparam name="URL.SortColumn" type="string" default="MfgrPartNumber">
	<cfparam name="URL.SortOrder" type="string" default="Asc">

	<!--- set the new sort order for display --->
	<cfif URL.SortOrder IS "Desc">
		<cfset Variables.NewSortOrder = "Asc">
	<cfelse>
		<cfset Variables.NewSortOrder = "Desc">
	</cfif>

	<cfset Variables.OrderByList = URL.SortColumn & " " & URL.SortOrder>

	<cfset SearchRecord = structNew()>
<!---
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
		
		<cfset qryMiscParts = objMiscParts.searchRecords(SearchRecord, "query", Variables.OrderByList, 0)>
		<cfif qryMiscParts.RecordCount EQ 0>
			<cfset Error = "No Match Found">
		</cfif>
	<cfelse>
--->

		<cfset Variables.UserID = objMiscParts.getSessionValue("adminuserid")>

		<cfset structInsert(SearchRecord, "UserID", Variables.UserID, True)>

		<cfset qryMiscParts = objMiscParts.searchRecords(SearchRecord, "query", Variables.OrderByList, 0)>
		

<!---</cfif>--->
	
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
	<td valign="top" class="subpagetitle" colspan="3">Misc Parts Maintenance</td>
</tr>

<tr><!--- Link to "Add a New Item" --->
	<td valign="top" class="textmain" colspan="3" align="right">
		<a href="index.cfm?task=misc_parts_new&UserID=#urlEncodedFormat(Variables.UserID)#">
			Add a New Misc Part
		</a>
	</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain" colspan="3"><font color="FF0000">#objMiscParts.getMessage()#</font></td>
</tr>


<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<td valign="top" class="textsmall" colspan="3">
		The following list displays a list of Misc Parts.  These parts are not associated with inventory in ACCPAC in any way.<br>
<!---	Search for an item in the list by entering the Item number or description below and clicking "Search".<br>	--->
		Add a new item to the list by clicking "Add a New Misc Part" above.<br>
		Edit an existing item by clicking the Manufacturer Part Number in the list.
	</td>
</tr>
<!---
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
--->

<tr>
<td valign="top" class="textmain" colspan="3">
	<table cellpadding="0" cellspacing="0" width="100%" border="0">
	
	<!--- LIST HEADINGS --->
	<tr>
		<td valign="bottom" height="18" bgcolor="006633">
			<a class="menuwh" href="index.cfm?task=misc_parts_list&SortColumn=MfgrPartNumber&SortOrder=#NewSortOrder#">
				Manufacturer's Part Number
			</a>
		</td>
		<td valign="bottom" height="18" bgcolor="006633">
			<a class="menuwh" href="index.cfm?task=misc_parts_list&SortColumn=Description&SortOrder=#NewSortOrder#">
				Description
			</a>
		</td>
		<td valign="bottom" height="18" bgcolor="006633" align="center">
			<a class="menuwh" href="index.cfm?task=misc_parts_list&SortColumn=Cost&SortOrder=#NewSortOrder#">
				Cost
			</a>
		</td>
		<cfif NOT SESSION.UserOnVacation>
            <td valign="bottom" height="18" bgcolor="006633" align="center">&nbsp;</td>
		</cfif>
	</tr>

	<!--- LIST DATA --->	
	<cfif qryMiscParts.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="4" class="productTitle"><font color="FF0000">You currently have no Misc Parts defined.</font></td>
		</tr>
	</cfif>
	
	<cfloop query="qryMiscParts">
		<tr<cfif qryMiscParts.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
			<td class="textsmall" align="left">
				<a href="index.cfm?task=misc_parts_edit&MiscPartID=#urlEncodedFormat(qryMiscParts.MiscPartID)#">
					#qryMiscParts.MfgrPartNumber#
				</a>				
			</td>
			
			<td class="textsmall" align="left">
				<cfif len(trim(qryMiscParts.Description)) GT 20>
					#left(trim(qryMiscParts.Description), 20)#...
				<cfelse>
					#trim(qryMiscParts.Description)#
				</cfif>
			</td>
			
			<td class="textsmall" align="center">
				#dollarFormat(qryMiscParts.Cost)#
			</td>
			
            <cfif NOT SESSION.UserOnVacation>
                <td class="textsmall" align="center">
                    <a href="index.cfm?task=misc_parts_delete&MiscPartID=#urlEncodedFormat(qryMiscParts.MiscPartID)#" onclick="return confirmDelete()">
                        [delete]
                    </a>
                </td>
         	</cfif>
                
		</tr>
	</cfloop>

	</table>
</td>
</tr>

</table>
</cfoutput>