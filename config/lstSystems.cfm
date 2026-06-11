<!---<cfsilent>--->
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/01/2006
	Function: 		This page displays a list of Systems
	Template:		lstSystems.cfm
	Task:			config_setup_systems_list
--->
	<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>

	<cfif isDefined("URL.DefaultSystems")>
		<cfset DefaultSystems = URL.DefaultSystems>
	<cfelse>
		<cfset DefaultSystems = objConfigSystems.getSessionValue("DefaultSystems")>
	</cfif>
	<cfif NOT isDefined("DefaultSystems") OR DefaultSystems IS "">
		<cfset DefaultSystems = 0>
	</cfif>
<!---
	<cfif isDefined("URL.DefaultSystems") AND URL.DefaultSystems EQ 1>
		<cfset DefaultSystems = 1>
	<cfelse>
		<cfset DefaultSystems = 0>
	</cfif>
--->	
	<cfset objConfigSystems.setSessionValue("DefaultSystems", DefaultSystems)>
	
	<cfif DefaultSystems>
		<!--- Default Systems --->
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "DefaultSystem", 1, True)>
		<cfset qryConfigSystems = objConfigSystems.searchRecords(SearchRecord, "query", "TypeSortOrder, SortOrder, Name")>
		
	<cfelse>
		<!--- Sales Rep Systems --->
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "DefaultSystem", 0, True)>
<!---	<cfset structInsert(SearchRecord, "UserID", SESSION.adminuserid, True)>	--->
		<cfset structInsert(SearchRecord, "UserID", objConfigSystems.getSessionValue("adminuserid"), True)>
		<cfset qryConfigSystems = objConfigSystems.searchRecords(SearchRecord, "query", "TypeSortOrder, SortOrder, Name")>
	</cfif>

<!---</cfsilent>--->

<!---
<cfquery datasource="NorTechWWW" name="qryAllSystems">
SELECT	ConfigSystemID
FROM 	tblConfigSystems 
</cfquery>	
qryAllSystems.RecordCount:<cfdump var="#qryAllSystems.RecordCount#"><br />

<cfquery datasource="NorTechWWW" name="qryPriceLists">
SELECT	PriceListID
FROM 	tblPriceLists 
</cfquery>	
qryPriceLists.RecordCount:<cfdump var="#qryPriceLists.RecordCount#"><br />

<cfquery datasource="NorTechWWW" name="qryResellerSystems">
SELECT	ResellerSystemID
FROM 	tblResellerSystems
</cfquery>	
qryResellerSystems.RecordCount:<cfdump var="#qryResellerSystems.RecordCount#"><br />
--->


<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">System List</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objConfigSystems.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<!---
<cfif NOT DefaultSystems AND qryConfigSystems.RecordCount EQ 0>
	<tr>
		<!--- "Copy all default systems" link --->
		<td align="right" class="textmain">
			<a href="index.cfm?task=config_setup_systems_copy&CopyDefaultSystems=1">
				Copy all Default Systems
			</a>
		</td>
	</tr>
</cfif>
<cfif NOT DefaultSystems>
	<tr>
		<!--- "Import default systems" link --->
		<td align="right" class="textmain">
			<a href="index.cfm?task=config_setup_defaultsystems_list">
				Import Default Systems
			</a>
		</td>
	</tr>
</cfif>

<cfif DefaultSystems>
	<tr>
		<!--- "Import sales rep systems" link --->
		<td align="right" class="textmain">
			<a href="index.cfm?task=config_setup_salesrepsystems_list">
				Import Sales Reps' Systems
			</a>
		</td>
	</tr>
</cfif>

<tr>
	<!--- "Create a New System" link --->
	<td align="right" class="textmain">
		<a href="index.cfm?task=config_setup_systems_new">
			Create a New System
		</a>
	</td>
</tr>


<cfif qryConfigSystems.RecordCount GT 0>
	<tr>
		<!--- "Sort Workstations" link --->
		<td align="right" class="textmain">
			<a href="index.cfm?task=config_setup_systems_sort&SystemType=Workstation">
				Sort Workstations
			</a>
		</td>
	</tr>
	<tr>
		<!--- "Sort Notebooks" link --->
		<td align="right" class="textmain">
			<a href="index.cfm?task=config_setup_systems_sort&SystemType=Notebook">
				Sort Notebooks
			</a>
		</td>
	</tr>
	<tr>
		<!--- "Sort Servers" link --->
		<td align="right" class="textmain">
			<a href="index.cfm?task=config_setup_systems_sort&SystemType=Server">
				Sort Servers
			</a>
		</td>
	</tr>
	<tr>
		<!--- "Sort Mini/Mountable PCs" link --->
		<td align="right" class="textmain">
			<a href="index.cfm?task=config_setup_systems_sort&SystemType=MiniMountablePC">
				Sort Mini/Mountable PCs
			</a>
		</td>
	</tr>
    
	<tr>
		<!--- "Add System Component" link --->
		<td align="right" class="textmain">
			<a href="index.cfm?task=config_setup_bulkadd_frm&DefaultSystems=#DefaultSystems#">
				Add System Component
			</a>
		</td>
	</tr>
	<tr>
		<!--- "Replace System Component" link --->
		<td align="right" class="textmain">
			<a href="index.cfm?task=config_setup_bulkreplace_frm&DefaultSystems=#DefaultSystems#">
				Replace System Component
			</a>
		</td>
	</tr>
	<tr>
		<!--- "Delete System Component" link --->
		<td align="right" class="textmain">
			<a href="index.cfm?task=config_setup_bulkdelete_frm&DefaultSystems=#DefaultSystems#">
				Delete System Component
			</a>
		</td>
	</tr>
</cfif>
--->
<tr>
<td valign="top" class="textmain">
	<table cellpadding="0" cellspacing="0" width="100%" border="0">
	
	<!--- LIST HEADINGS --->
	<tr>
		<td height="18" bgcolor="006633" class="productTitle" <!---width="50%"--->><font color="FFFFFF">System Name</font></td>
		<td height="18" bgcolor="006633" class="productTitle" <!---width="25%"--->><font color="FFFFFF">Type</font></td>
		<td height="18" bgcolor="006633" class="productTitle" <!---width="25%"--->><font color="FFFFFF">Classification</font></td>
		<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">&nbsp;</font></td>
	</tr>

	<!--- LIST DATA --->	
	<cfif qryConfigSystems.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="4" class="productTitle"><font color="FF0000">You currently have no <cfif DefaultSystems>Default </cfif>Systems defined.</font></td>
		</tr>
	</cfif>
	
	<cfloop query="qryConfigSystems">
		<tr<cfif qryConfigSystems.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>

			<td class="textsmall">
				<a href="index.cfm?task=config_setup_systems_edit&ConfigSystemID=#urlEncodedFormat(qryConfigSystems.ConfigSystemID)#">
					#qryConfigSystems.Name#
				</a>
			</td>
			<td class="textsmall">
				<cfif qryConfigSystems.Type IS "MiniMountablePC">
                    Mini/Mountable PC
                <cfelse>
	            	#qryConfigSystems.Type#
                </cfif>
            </td>
			<td class="textsmall">
	            #qryConfigSystems.ClassificationName#
            </td>
			<td class="textsmall" align="center">
				<cfif qryConfigSystems.DefaultSystem>
					DEFAULT SYSTEM
				<cfelseif objConfigSystems.isMaintainedByDefault(qryConfigSystems.ConfigSystemID)>
                	<font color="FF0000"><i>(Maint. by Default)</i></font>
                <cfelse>
					&nbsp;
				</cfif>
			</td>
<!---
			<td class="textsmall" align="center">
				<a href="index.cfm?task=config_setup_systems_delete&ConfigSystemID=#urlEncodedFormat(qryConfigSystems.ConfigSystemID)#">
					[delete]
				</a>
			</td>
--->

		</tr>
	</cfloop>


	
	</table>
</td>
</tr>

<!---
<cfif SESSION.Role IS "Administrator">
<tr>
	<td class="textsmall" align="right">
		<a href="index.cfm?task=config_RAB092415&RequestTimeout=36000" target="_blank" >
			++
		</a>
	</td>
</tr>	
</cfif>
--->

</table>
</cfoutput>