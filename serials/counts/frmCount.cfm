<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/08/2006
	Function: 		This page displays prompts the user to enter count information
	Template:		frmCount.cfm
	Task:			serials_counts_enter
--->
	<cfset objCounts = createObject("component", "admin.assets.cfcs.Counts")>

	<cfif isDefined("URL.Validation")>
		<cfset stRecord = objCounts.getDataRecord()>
		<cfset stErrors = objCounts.getErrorRecord()>
	<cfelse>
		<cfset stRecord = objCounts.newRecord()>
		<cfset stErrors = structNew()>
	</cfif>

	<cfparam name="URL.SortColumn" type="string" default="CountDate">
	<cfparam name="URL.SortOrder" type="string" default="Asc">

	<!--- set the new sort order for display --->
	<cfif URL.SortOrder IS "Desc">
		<cfset Variables.NewSortOrder = "Asc">
	<cfelse>
		<cfset Variables.NewSortOrder = "Desc">
	</cfif>

	<cfif trim(URL.SortColumn) IS  "CountDate">		
		<cfset Variables.OrderByList = "CountDate " & URL.SortOrder & ", ITEMNO " & URL.SortOrder>
	<cfelseif trim(URL.SortColumn) IS  "UserName">		
		<cfset Variables.OrderByList = "UserName " & URL.SortOrder & ", ITEMNO " & URL.SortOrder>
	<cfelse>
		<cfset Variables.OrderByList = URL.SortColumn & " " & URL.SortOrder>
	</cfif>
	
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "Posted", 0, True)>
	<cfset qryCounts = objCounts.searchRecords(SearchRecord, "query", Variables.OrderByList)>
</cfsilent>

<script language="javascript">
	function confirmDelete() {
		var msg = "Are you sure you would like to delete this Count?";
		if(confirm(msg)) { return true; }
		else { return false; }
	}
</script>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objCounts.getMessage()#</font></td>
</tr>
<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr><!--- Instructions --->
	<td valign="top" class="textmain">
		Enter the item number, total quantity, and location of the item being counted.  You will then be prompted to scan all of the serial numbers for that item at that location.<br>
		Any counts that have not been posted (by clicking the "Save & Postpone" button) will appear at the bottom of the page.  You may resume those counts by clicking the Item Number.<br><br>
		<font color="FF0000">Note:</font> "Total Quantity" must be the total quantity of the count, not just the variance detected.
	</td>
</tr>
<!---<tr><td>&nbsp;</td></tr>--->

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	<form action="index.cfm?task=serials_counts_save" method="Post" name="detailform">
	<input type="hidden" name="CountsID" value="#stRecord.CountsID#">

	<!--- ITEM NUMBER --->
	<cfif structKeyExists(stErrors, "ITEMNO")>
		<tr>
			<td>&nbsp;</td>
			<td valign="top" class="textmain"><font color="FF0000">&raquo; #stErrors.ITEMNO#</font></td>
		</tr>
	</cfif>
	<tr>
		<td valign="top" class="textmain" width="30%"><b>Item Number:</b></td>
		<td valign="top" class="textmain">
			<input name="ITEMNO" size="20" maxlength="50" value="#stRecord.ITEMNO#" <cfif structKeyExists(stErrors, "ITEMNO")>style="border:1px solid red;"</cfif>>
		</td>
	</tr>
	
	<!--- QUANTITY --->
	<cfif structKeyExists(stErrors, "Quantity")>
		<tr>
			<td>&nbsp;</td>
			<td valign="top" class="textmain"><font color="FF0000">&raquo; #stErrors.Quantity#</font></td>
		</tr>
	</cfif>
	<tr>
		<td valign="top" class="textmain"><b>Total Quantity:</b></td>
		<td valign="top" class="textmain">
			<input name="Quantity" size="20" maxlength="50" value="#stRecord.Quantity#" <cfif structKeyExists(stErrors, "Quantity")>style="border:1px solid red;"</cfif>>
		</td>
	</tr>


	<!--- LOCATION --->
	<cfif structKeyExists(stErrors, "LOCATION")>
		<tr>
			<td>&nbsp;</td>
			<td valign="top" class="textmain"><font color="FF0000">&raquo; #stErrors.LOCATION#</font></td>
		</tr>
	</cfif>
	<tr>
		<td valign="top" class="textmain"><b>Location:</b></td>
		<td valign="top" class="textmain">
			<cfset qryLocations = objCounts.getLocations()>
			<select name="LOCATION" size="1">
				<option value="">- Select -</option>
				<cfloop query="qryLocations">
					<option value="#qryLocations.LOCATION#" 
						<cfif stRecord.LOCATION IS qryLocations.LOCATION>
							selected
						</cfif>
						> #qryLocations.LOCATION#: #qryLocations.DESC#
					</option>
				</cfloop>
			</select>
		</td>
	</tr>

	<tr>
	<td valign="top" colspan="2" align="center">
		<table cellpadding="4" cellspacing="0" border="0" width="80%">
<!---	<tr><td>&nbsp;</td></tr>	--->
		<tr>
			<!--- "CONTINUE" BUTTON --->
			<td align="right">
				<input type="submit" name="ButtonClicked" value="&nbsp;Continue -&raquo;">
			</td>
		</tr>
		</table>
	</td>
	</tr>

	</form>
	</table>
</td>
</tr>



<!--- List of Existing unposted Counts --->
<cfif qryCounts.RecordCount GT 0>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td valign="top" class="textmain">
			Previously entered counts that have not yet been posted:
		</td>
	</tr>
	<tr>
	<td valign="top" class="textmain">
		<table cellpadding="0" cellspacing="0" width="100%" border="0">
		
		<!--- LIST HEADINGS --->
		<tr>
			<td height="18" bgcolor="006633" width="25%">
				<a class="menuwh" href="index.cfm?task=serials_counts_enter&
										SortColumn=ITEMNO&SortOrder=#NewSortOrder#">
					Item Number
				</a>
			</td>
			<td height="18" bgcolor="006633" width="38%">
				<a class="menuwh" href="index.cfm?task=serials_counts_enter&
										SortColumn=ITEMDESC&SortOrder=#NewSortOrder#">
					Item Description
				</a>
			</td>
			<td height="18" bgcolor="006633" width="12%" align="center">
				<a class="menuwh" href="index.cfm?task=serials_counts_enter&
										SortColumn=CountDate&SortOrder=#NewSortOrder#">
					Date of<br>Count
				</a>
			</td>
			<td height="18" bgcolor="006633" width="15%" align="center">
				<a class="menuwh" href="index.cfm?task=serials_counts_enter&
										SortColumn=UserName&SortOrder=#NewSortOrder#">
					User
				</a>
			</td>
			<td height="18" bgcolor="006633">&nbsp;</td>
		</tr>
		
		<cfloop query="qryCounts">
			<tr<cfif qryCounts.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
				<td class="textsmall" align="left">
					<a href="index.cfm?task=serials_counts_serials_edit&CountsID=#urlEncodedFormat(qryCounts.CountsID)#">
						#qryCounts.ITEMNO#
					</a>
				</td>
				<td class="textsmall" align="left">#qryCounts.ITEMDESC#</td>
				<td class="textsmall" align="center">#dateFormat(qryCounts.CountDate, 'mm/dd/yyyy')#</td>
				<td class="textsmall" align="center">#qryCounts.UserName#</td>
				<td class="textsmall" align="center">
					<a href="index.cfm?task=serials_counts_delete&CountsID=#urlEncodedFormat(qryCounts.CountsID)#" onclick="return confirmDelete()">
						[delete]
					</a>
				</td>
			</tr>
		</cfloop>
		</table>
	</td>
	</tr>
</cfif>

</table>
</cfoutput>

<cfif structKeyExists(stErrors, "ITEMNO")>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['ITEMNO'].focus(); document.detailform['ITEMNO'].select()
	-->
	</script>
<cfelseif structKeyExists(stErrors, "Quantity")>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['Quantity'].focus(); document.detailform['Quantity'].select()
	-->
	</script>
<cfelseif structKeyExists(stErrors, "LOCATION")>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['LOCATION'].focus();
	-->
	</script>
<cfelse>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['ITEMNO'].focus();document.detailform['ITEMNO'].select()
	-->
	</script>
</cfif>