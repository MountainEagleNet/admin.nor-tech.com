<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/08/2006
	Function: 		This page prompts the user to enter an item number
	Template:		lstItems.cfm
	Task:			serials_corrections_item_list
--->
	<cfset objICITEM = createObject("component", "admin.assets.cfcs.ICITEM")>

	<cfset ExecuteSearch = 0>
	<cfset Error = 0>
	
	<cfif isDefined("FORM.ITEMNO")>
		<cfset ExecuteSearch = 1>
		<cfif trim(FORM.ITEMNO) IS "">
			<cfset Error = 1>
		<cfelse>
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "ITEMNO", FORM.ITEMNO, True)>
			<cfset qryICITEM = objICITEM.searchRecords(SearchRecord, "query", "ITEMNO", 0)>
			<cfif qryICITEM.RecordCount EQ 0>
				<cfset Error = 1>
			</cfif>
		</cfif>
	</cfif>

</cfsilent>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<form name="ItemNumberSearch" action="index.cfm?task=serials_corrections_item_list" method="post">
	<tr>
		<td class="textmain" align="left">
			<strong>Item Number:</strong>
			<input name="ITEMNO" size="20" maxlength="50"
				<cfif isDefined("FORM.ITEMNO")>
					value="#FORM.ITEMNO#"
				</cfif>
			>
			<input type="submit" name="ProcessSearch" value="Search">
		</td>
	</tr>
</form>
<cfif Error>
	<tr>
		<td class="textmain" align="left">
			<font color="FF0000">
				<cfif trim(FORM.ITEMNO) IS "">
					Please enter an Item Number (partial or full) before clicking "Search".
				<cfelseif qryICITEM.RecordCount EQ 0>
					Item Number <cfif isDefined("FORM.ITEMNO")>'#FORM.ITEMNO#'</cfif> was not found.
				</cfif>
			</font>
		</td>
	</tr>
</cfif>

<tr><td class="textsmall">&nbsp;</td></tr>
</cfoutput>


<cfif ExecuteSearch AND isDefined("qryICITEM") AND NOT Error>

	<tr>
	<td valign="top" class="textmain">
		<table cellpadding="0" cellspacing="0" width="100%" border="0">
		
		<!--- LIST HEADINGS --->
		<tr>
			<td height="18" bgcolor="006633" class="productTitle" width="35%"><font color="FFFFFF">Item Number</font></td>
			<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Description</font></td>
		</tr>
	
		<!--- LIST DATA --->	
		<cfif qryICITEM.RecordCount EQ 0>
			<tr>
				<td align="center" colspan="2" class="productTitle"><font color="FF0000">No matching records were found.</font></td>
			</tr>
		</cfif>
		
		<cfoutput query="qryICITEM" startrow="1" maxrows="20">
			<tr<cfif qryICITEM.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
	
				<td class="textsmall" align="left">
					<a href="index.cfm?task=serials_corrections_serials_list&ITEMNO=#urlEncodedFormat(qryICITEM.ITEMNO)#">
						#qryICITEM.ITEMNO#
					</a>
				</td>
				<td class="textsmall" align="left">
					#qryICITEM.DESC#
				</td>
			</tr>
		</cfoutput>
	
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