<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/09/2006
	Function: 		This page displays a list of Systems for sorting
	Template:		lstSystemsSort.cfm
	Task:			config_setup_systems_sort
--->
	<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>

	<cfset DefaultSystems = objConfigSystems.getSessionValue("DefaultSystems")>

	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "Type", URL.SystemType, True)>
	<cfif DefaultSystems>
		<!--- Default Systems --->
		<cfset structInsert(SearchRecord, "DefaultSystem", 1, True)>
		<cfset qryConfigSystems = objConfigSystems.searchRecords(SearchRecord, "query", "TypeSortOrder, SortOrder, Name")>
	<cfelse>
		<!--- Sales Rep Systems --->
		<cfset structInsert(SearchRecord, "DefaultSystem", 0, True)>
		<cfset structInsert(SearchRecord, "UserID", objConfigSystems.getSessionValue("adminuserid"), True)>
		<cfset qryConfigSystems = objConfigSystems.searchRecords(SearchRecord, "query", "TypeSortOrder, SortOrder, Name")>
	</cfif>
</cfsilent>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">
    	Sort Systems: 
        <cfif URL.SystemType IS "MiniMountablePC">
			Mini/Mountable PC
		<cfelse>
            #URL.SystemType#
		</cfif>
    </td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objConfigSystems.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<!--- Return to master system list --->
	<td align="right" class="textmain">
		<a href="index.cfm?task=config_setup_systems_list">
			Return to System List
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
	<cfif qryConfigSystems.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="3" class="productTitle"><font color="FF0000">You currently have no #URL.SystemType#s defined.</font></td>
		</tr>
	</cfif>
	
	<cfloop query="qryConfigSystems">
		<tr<cfif qryConfigSystems.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>

			<td class="textsmall" align="left">#qryConfigSystems.Name#</td>
			<td class="textsmall">
				<cfif qryConfigSystems.Type IS "MiniMountablePC">
                    Mini/Mountable PC
                <cfelse>
	            	#qryConfigSystems.Type#
                </cfif>
        	</td>

			<td class="textsmall" align="center">
				&nbsp;<a href="index.cfm?task=config_setup_systems_sortup&
							ConfigSystemID=#urlEncodedFormat(qryConfigSystems.ConfigSystemID)#&
							SystemType=#URL.SystemType#">
								<img src="images/contract.gif" border="0" alt="sort up">
						</a>
				&nbsp;<a href="index.cfm?task=config_setup_systems_sortdown&
							ConfigSystemID=#urlEncodedFormat(qryConfigSystems.ConfigSystemID)#&
							SystemType=#URL.SystemType#">
								<img src="images/expand.gif" border="0" alt="sort down">
						</a>
			</td>

		</tr>
	</cfloop>

	</table>
</td>
</tr>


</table>
</cfoutput>