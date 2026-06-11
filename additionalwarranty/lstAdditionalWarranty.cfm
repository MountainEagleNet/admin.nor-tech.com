<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	12/28/2009
	Function: 		This page displays a list of additional warranties
	Template:		lstAdditionalWarranty.cfm
	Task:			additionalwarranty_list
--->
	<cfset objAdditionalWarranty = createObject("component", "admin.assets.cfcs.config.AdditionalWarranty")>

	<cfparam name="URL.SortColumn" type="string" default="SortOrder">
	<cfparam name="URL.SortOrder" type="string" default="Asc">

	<!--- set the new sort order for display --->
	<cfif URL.SortOrder IS "Desc">
		<cfset Variables.NewSortOrder = "Asc">
	<cfelse>
		<cfset Variables.NewSortOrder = "Desc">
	</cfif>
<!---
	<cfif URL.SortColumn IS "Type">
		<cfset Variables.OrderByList = "Type " & URL.SortOrder & ", SortOrder " & URL.SortOrder>
	<cfelse>
--->    
        <cfset Variables.OrderByList = URL.SortColumn & " " & URL.SortOrder>
<!---        
    </cfif>
--->
	<cfset SearchRecord = structNew()>

	<cfset qryAdditionalWarranty = objAdditionalWarranty.listRecords("query", Variables.OrderByList)>
	
</cfsilent>
<!---
<script language="javascript">
	function confirmDelete() {
		var msg = "Are you sure you would like to delete this record?";
		if(confirm(msg)) { return true; }
		else { return false; }
	}
</script>
--->

<cfoutput>
<table width="575" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle" colspan="3">Depot Warranty Maintenance</td>
</tr>

<tr><!--- Link to "Add a New Item" --->
	<td valign="top" class="textmain" colspan="3" align="right">
		<a href="index.cfm?task=additionalwarranty_new">
			Add a New Depot Warranty
		</a>
	</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain" colspan="3"><font color="FF0000">#objAdditionalWarranty.getMessage()#</font></td>
</tr>


<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<td valign="top" class="textsmall" colspan="3">
		The following list displays Depot Warranties.<br>
		Add a new additional warranty to the list by clicking "Add a New Depot Warranty" above.<br>
		Edit an existing additional warranty by clicking the name in the list.
	</td>
</tr>

<tr>
<td valign="top" class="textmain" colspan="3">
	<table cellpadding="0" cellspacing="0" width="100%" border="0">
	
	<!--- LIST HEADINGS --->
	<tr>
		<td valign="bottom" height="18" bgcolor="006633">
			<a class="menuwh" href="index.cfm?task=additionalwarranty_list&SortColumn=Name&SortOrder=#NewSortOrder#">
				Name
			</a>
		</td>
		<td valign="bottom" height="18" bgcolor="006633" align="center">
			<a class="menuwh" href="index.cfm?task=additionalwarranty_list&SortColumn=PercentMarkUp&SortOrder=#NewSortOrder#">
				Percent Mark-up
			</a>
		</td>
		<td valign="bottom" height="18" bgcolor="006633" align="center">
			<a class="menuwh" href="index.cfm?task=additionalwarranty_list&SortColumn=SortOrder&SortOrder=#NewSortOrder#">
				Sort Order
			</a>
		</td>
	</tr>

	<!--- LIST DATA --->	
	<cfif qryAdditionalWarranty.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="5" class="productTitle"><font color="FF0000">You currently have no Depot Warranties defined.</font></td>
		</tr>
	</cfif>
	
	<cfloop query="qryAdditionalWarranty">
		<tr<cfif qryAdditionalWarranty.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
			<td class="textsmall" align="left">
				<a href="index.cfm?task=additionalwarranty_edit&AdditionalWarrantyID=#urlEncodedFormat(qryAdditionalWarranty.AdditionalWarrantyID)#">
					#qryAdditionalWarranty.Name#
				</a>				
			</td>

			<td class="textsmall" align="center">
				#qryAdditionalWarranty.PercentMarkUp#%
			</td>

			<td class="textsmall" align="center">
				#qryAdditionalWarranty.SortOrder#
			</td>
			
		</tr>
	</cfloop>

	</table>
</td>
</tr>

</table>
</cfoutput>