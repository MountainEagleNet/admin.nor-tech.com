<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	09/14/2006
	Function: 		This page displays a list of Default Systems for the sales rep to import
	Template:		lstDefaultSystems.cfm
	Task:			config_setup_defaultsystems_list
--->
	<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>

	<!--- Default Systems --->
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "DefaultSystem", 1, True)>
	<cfset qryConfigSystems = objConfigSystems.searchRecords(SearchRecord, "query", "TypeSortOrder, SortOrder, Name")>

</cfsilent>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">Default System List</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objConfigSystems.getMessage()#</font></td>
</tr>

<tr><!--- Instructions --->
	<td valign="top" class="textmain">
    	Select the default systems you want to import by checking the "Import System" checkboxes.<br /><br />
    
   		For each system that you are importing, check or clear the "Maintain From Default" checkbox appropriately:  
        <ul>
        	<li>If checked, then updates made to the default system in the future will automatically be applied to your system (and you will not be allowed to make "manual" adjustments to your system).</li>
        	<li>If cleared, then you will have complete control of maintaining the system.</li>
        </ul>
        
    	After making your selections, click "Import".
 	</td>
</tr>


<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<!--- "Back to Your System List" link --->
	<td align="right" class="textmain">
		<a href="index.cfm?task=config_setup_systems_list&DefaultSystems=0">	
			Back to Your System List
		</a>
	</td>
</tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="0" cellspacing="0" width="100%" border="0">
	<form action="index.cfm?task=config_setup_defaultsystems_copy&RequestTimeout=6000" method="Post" name="detailform">
	<cfset TabValue = 1>

	<!--- LIST HEADINGS --->
	<tr>
		<td height="18" bgcolor="006633" class="productTitle" width="50%"><font color="FFFFFF">System Name</font></td>
		<td height="18" bgcolor="006633" class="productTitle" width="25%"><font color="FFFFFF">Type</font></td>
		<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Import System?</font></td>
		<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Maintain From Default?</font></td>
	</tr>

	<!--- LIST DATA --->	
	<cfif qryConfigSystems.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="4" class="productTitle"><font color="FF0000">Sorry, there are currently have no Default Systems defined.</font></td>
		</tr>
	</cfif>
	
	<cfloop query="qryConfigSystems">
		<tr<cfif qryConfigSystems.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>

			<td class="textsmall">#qryConfigSystems.Name#</td>
			<td class="textsmall">#qryConfigSystems.Type#</td>
			<td class="textsmall" align="center">
				<input type="checkbox" name="SYSTEM|#qryConfigSystems.ConfigSystemID#" value="1" tabindex="#TabValue#">
				<cfset TabValue = TabValue + 1>
			</td>
			<td class="textsmall" align="center">
				<input type="checkbox" name="MAINTAIN|#qryConfigSystems.ConfigSystemID#" checked="checked" value="1" tabindex="#TabValue#">
				<cfset TabValue = TabValue + 1>
			</td>
		</tr>
	</cfloop>
    

	<!--- **********************************   TEMP   *********************************** --->
<!---    
	<tr>
		<td valign="top" colspan="4" align="center">
			<input name="RONCODE" value="" type="text" size="5" maxlength="50">
		</td>
	</tr>
--->    
	<!--- **********************************   TEMP   *********************************** --->


	<tr>
		<td valign="top" colspan="4" align="center">
			<table cellpadding="4" cellspacing="0" border="0" width="60%">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td align="right"><!--- "IMPORT" BUTTON --->
					<input type="submit" name="ButtonClicked" value="Import" tabindex="#TabValue#">
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