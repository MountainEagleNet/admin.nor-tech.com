<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/26/2006
	Function: 		This page displays a list of Component Categories
	Template:		lstCompCats.cfm
	Task:			config_setup_compcats_list
--->
	<cfset objComponentCategories = createObject("component", "admin.assets.cfcs.config.ComponentCategories")>
	<cfset qryComponentCategories = objComponentCategories.listRecords()>
</cfsilent>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">Component Categories</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objComponentCategories.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<!--- Link to Add New Component Category --->
	<td align="right" class="textmain">
		<a href="index.cfm?task=config_setup_compcats_new">
			Add a New Category
		</a>
	</td>
</tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="0" cellspacing="0" width="100%" border="0">
	
	<!--- LIST HEADINGS --->
	<tr>
		<td height="18" bgcolor="006633" class="productTitle" width="50%"><font color="FFFFFF">Name</font></td>
		<td height="18" bgcolor="006633" class="productTitle" width="20%" align="center"><font color="FFFFFF">Category</font></td>
		<td height="18" bgcolor="006633" class="productTitle" align="center"><font color="FFFFFF">Sort</font></td>
	</tr>

	<!--- LIST DATA --->	
	<cfif qryComponentCategories.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="3" class="productTitle"><font color="FF0000">There are currently no Component Categories defined.</font></td>
		</tr>
	</cfif>
	
	<cfloop query="qryComponentCategories">
		<tr<cfif qryComponentCategories.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>

			<td class="textsmall" align="left">
				<a href="index.cfm?task=config_setup_compcats_edit&ComponentCategoryID=#urlEncodedFormat(qryComponentCategories.ComponentCategoryID)#">
					#qryComponentCategories.Name#
				</a>
			</td>
			<td class="textsmall" align="center">#qryComponentCategories.CATEGORY#</td>

			<td class="textsmall" align="center">
				&nbsp;<a href="index.cfm?task=config_setup_compcats_sortup&
							ComponentCategoryID=#urlEncodedFormat(qryComponentCategories.ComponentCategoryID)#"><img src="images/contract.gif" border="0" alt="sort up"></a>
				&nbsp;<a href="index.cfm?task=config_setup_compcats_sortdown&
							ComponentCategoryID=#urlEncodedFormat(qryComponentCategories.ComponentCategoryID)#"><img src="images/expand.gif" border="0" alt="sort down"></a>
					</td>
			</td>

		</tr>
	</cfloop>

	</table>
</td>
</tr>


</table>
</cfoutput>