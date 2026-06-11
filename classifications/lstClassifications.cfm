<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/12/2009
	Function: 		This page displays a list of classifications
	Template:		lstClassifications.cfm
	Task:			classifications_list
--->
	<cfset objClassifications = createObject("component", "admin.assets.cfcs.config.Classifications")>

	<cfparam name="URL.SortColumn" type="string" default="Type">
	<cfparam name="URL.SortOrder" type="string" default="Asc">

	<!--- set the new sort order for display --->
	<cfif URL.SortOrder IS "Desc">
		<cfset Variables.NewSortOrder = "Asc">
	<cfelse>
		<cfset Variables.NewSortOrder = "Desc">
	</cfif>

	<cfif URL.SortColumn IS "Type">
		<cfset Variables.OrderByList = "Type " & URL.SortOrder & ", SortOrder " & URL.SortOrder>
	<cfelse>
        <cfset Variables.OrderByList = URL.SortColumn & " " & URL.SortOrder>
    </cfif>

	<cfset SearchRecord = structNew()>

	<cfset qryClassifications = objClassifications.listRecords("query", Variables.OrderByList)>
	
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
	<td valign="top" class="subpagetitle" colspan="3">System Classifications Maintenance</td>
</tr>

<tr><!--- Link to "Add a New Item" --->
	<td valign="top" class="textmain" colspan="3" align="right">
		<a href="index.cfm?task=classifications_new">
			Add a New Classification
		</a>
	</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain" colspan="3"><font color="FF0000">#objClassifications.getMessage()#</font></td>
</tr>


<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<td valign="top" class="textsmall" colspan="3">
		The following list displays a list of System Classifications.<br>
		Add a new classification to the list by clicking "Add a New Classification" above.<br>
		Edit an existing classification by clicking the name in the list.
	</td>
</tr>

<tr>
<td valign="top" class="textmain" colspan="3">
	<table cellpadding="0" cellspacing="0" width="100%" border="0">
	
	<!--- LIST HEADINGS --->
	<tr>
		<td valign="bottom" height="18" bgcolor="006633">
			<a class="menuwh" href="index.cfm?task=classifications_list&SortColumn=Type&SortOrder=#NewSortOrder#">
				Type
			</a>
		</td>
		<td valign="bottom" height="18" bgcolor="006633">
			<a class="menuwh" href="index.cfm?task=classifications_list&SortColumn=Name&SortOrder=#NewSortOrder#">
				Name
			</a>
		</td>
		<td valign="bottom" height="18" bgcolor="006633" align="center">
			<a class="menuwh" href="index.cfm?task=classifications_list&SortColumn=SortOrder&SortOrder=#NewSortOrder#">
				Sort Order
			</a>
		</td>
		<td valign="bottom" height="18" bgcolor="006633" align="center">
			<a class="menuwh" href="index.cfm?task=classifications_list&SortColumn=DefaultClassification&SortOrder=#NewSortOrder#">
				Default?
			</a>
		</td>
<!---        
        <td>&nbsp;</td>
--->        
	</tr>

	<!--- LIST DATA --->	
	<cfif qryClassifications.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="5" class="productTitle"><font color="FF0000">You currently have no Classifications defined.</font></td>
		</tr>
	</cfif>
	
	<cfloop query="qryClassifications">
		<tr<cfif qryClassifications.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
			<td class="textsmall" align="left">
				#qryClassifications.Type#
			</td>

			<td class="textsmall" align="left">
				<a href="index.cfm?task=classifications_edit&ClassificationID=#urlEncodedFormat(qryClassifications.ClassificationID)#">
					#qryClassifications.Name#
				</a>				
			</td>
			
			<td class="textsmall" align="center">
				#qryClassifications.SortOrder#
			</td>
			
			<td class="textsmall" align="center">
				#yesNoFormat(qryClassifications.DefaultClassification)#
			</td>
<!---			
            <td class="textsmall" align="center">
                <a href="index.cfm?task=classifications_delete&ClassificationID=#urlEncodedFormat(qryClassifications.ClassificationID)#" onclick="return confirmDelete()">
                    [delete]
                </a>
            </td>
--->                
		</tr>
	</cfloop>

	</table>
</td>
</tr>

</table>
</cfoutput>