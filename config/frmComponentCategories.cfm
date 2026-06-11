<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/07/2006
	Function: 		This page displays a form for assigning component categories to a system
	Template:		frmConfigComponentCategories.cfm	
	Task:			config_setup_categories_edit
--->
<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>
<cfset objConfigComponentCategories = createObject("component", "admin.assets.cfcs.config.ConfigComponentCategories")>
<cfset objComponentCategories = createObject("component", "admin.assets.cfcs.config.ComponentCategories")>

<cfset strConfigSystem = objConfigSystems.getRecord(URL.ConfigSystemID, "struct")>

<cfset qryComponentCategories = objComponentCategories.listRecords("query", "SortOrder")>
<cfset qryConfigComponentCategories = objConfigComponentCategories.listRecordsForParent("ConfigSystemID", URL.ConfigSystemID)>

<cfset isMaintainedByDefault = objConfigSystems.isMaintainedByDefault(URL.ConfigSystemID)>


<cfoutput>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">Component Category Selection</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objConfigComponentCategories.getMessage()#</font></td>
</tr>

<cfif qryConfigComponentCategories.RecordCount GT 0>
	<tr>
	<td valign="top" class="textmain">
	An "X" to the left of a category indicates that category is used on this system.
	</td>
	</tr>
</cfif>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<td>	
		<table cellpadding="2" cellspacing="0" width="100%" border="0">
			<tr>
				<td valign="middle" class="textmain" width="20%"><b>System Name:</b></td>
				<td valign="top" class="textmain">#strConfigSystem.Name#</td>
			</tr>
		</table>
	</td>
</tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	<form action="index.cfm?task=config_setup_categories_save&RequestTimeout=6000" method="Post" name="detailform">
	<input type="hidden" name="ConfigSystemID" value="#strConfigSystem.ConfigSystemID#">
	<cfset TabValue = 1>
	
	<!--- LIST HEADINGS --->
	<tr>
		<td height="18" bgcolor="006633" class="productTitle" colspan="2"><font color="FFFFFF">Component Categories</font></td>
	</tr>
	
	<!--- DATA --->
	<cfif qryComponentCategories.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="2" class="productTitle"><font color="FF0000">There are no Component Categories defined.</font></td>
		</tr>
	</cfif>
<!---
qryComponentCategories:<cfdump var="#qryComponentCategories#">
--->
	<cfloop query="qryComponentCategories">
	
		<cfset CategoryIsAssigned = 0>
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ConfigSystemID", strConfigSystem.ConfigSystemID, True)>
		<cfset structInsert(SearchRecord, "ComponentCategoryID", qryComponentCategories.ComponentCategoryID, True)>
		<cfset qryConfigComponentCategories = objConfigComponentCategories.searchRecords(SearchRecord, "query")>
		<cfif qryConfigComponentCategories.RecordCount NEQ 0>
			<cfset CategoryIsAssigned = 1>
		</cfif>
	
		<tr<cfif qryComponentCategories.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
			<td class="textsmall" width="10%">
				<!--- Assigned CheckBox --->
               	<cfif CategoryIsAssigned>
                	&nbsp;&nbsp; <font color="0000FF"><b>X</b></font>
                </cfif>
			</td>
			<td class="textsmall">
				#qryComponentCategories.Name#
			</td>
		</tr>
	</cfloop>

	<tr>
		<td valign="top" colspan="2" align="center">
			<table cellpadding="4" cellspacing="0" border="0" width="60%">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td align="right"><!--- "CONTINUE" BUTTON --->
					<input type="submit" name="ButtonClicked" value="&nbsp;Continue -&raquo;" tabindex="#TabValue#">
				</td>
			</tr>
			</table>
		</td>
	</tr>

	</form>
	</table>
</td>
</tr>
</table>
</cfoutput>