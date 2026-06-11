<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/22/2012
	Function: 		This page displays a list of server options
	Template:		lstServerOptions.cfm
	Task:			server_options_list
--->
	<cfset objServerOptions = createObject("component", "admin.assets.cfcs.config.ServerOptions")>

	<cfparam name="URL.SortColumn" type="string" default="Name">
	<cfparam name="URL.SortOrder" type="string" default="Asc">

	<!--- set the new sort order for display --->
	<cfif URL.SortOrder IS "Desc">
		<cfset Variables.NewSortOrder = "Asc">
	<cfelse>
		<cfset Variables.NewSortOrder = "Desc">
	</cfif>

	<cfset Variables.OrderByList = URL.SortColumn & " " & URL.SortOrder>
    
	<cfset qryServerOptions = objServerOptions.listRecords()>
</cfsilent>
<!---
<cfdump var="#qryServerOptions#">
--->
<cfoutput>
<table width="575" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle" colspan="1">Server Options</td>
</tr>

<tr><!--- Link to "Add a New Server Option" --->
	<td valign="top" class="textmain" colspan="1" align="right">
		<a href="index.cfm?task=server_options_new">
			Add a New Server Option
		</a>
	</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain" colspan="1"><font color="FF0000">#objServerOptions.getMessage()#</font></td>
</tr>


<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<td valign="top" class="textsmall" colspan="1">
		The following displays a list of Server Options. <br />
		Add a new server option to the list by clicking "Add a New Server Option" above.<br>
		Edit an existing server option by clicking the name in the list.
	</td>
</tr>


<tr>
<td valign="top" class="textmain" colspan="1">
	<table cellpadding="0" cellspacing="0" width="100%" border="0">
	
	<!--- LIST HEADINGS --->
	<tr>
		<td valign="bottom" height="18" bgcolor="006633">
			<a class="menuwh" href="index.cfm?task=server_options_list&SortColumn=Name&SortOrder=#NewSortOrder#">
				Server Option Name
			</a>
		</td>
	</tr>

	<!--- LIST DATA --->	
	<cfif qryServerOptions.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="1" class="productTitle"><font color="FF0000">You currently have no Server Options defined.</font></td>
		</tr>
	</cfif>
	
	<cfloop query="qryServerOptions">
		<tr<cfif qryServerOptions.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
			<td class="textsmall" align="left">
				<a href="index.cfm?task=server_options_edit&ServerOptionID=#urlEncodedFormat(qryServerOptions.ServerOptionID)#">
					#qryServerOptions.Name#
				</a>				
			</td>
		</tr>
	</cfloop>

	</table>
</td>
</tr>

</table>
</cfoutput>