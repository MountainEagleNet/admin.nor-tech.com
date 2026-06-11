<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/09/2006
	Function: 		This page displays a list of photos (system images)
	Template:		lstPhotos.cfm
	Task:			config_setup_photos_list
--->
	<cfset objConfigPhotos = createObject("component", "admin.assets.cfcs.config.ConfigPhotos")>
	<cfset qryConfigPhotos = objConfigPhotos.listRecords()>
</cfsilent>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">System Images</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objConfigPhotos.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<!--- Link to Add New System Image --->
	<td align="right" class="textmain">
		<a href="index.cfm?task=config_setup_photos_new">
			Add a New System Image
		</a>
	</td>
</tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="0" cellspacing="0" width="100%" border="0">
	
	<!--- LIST HEADINGS --->
	<tr>
		<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Name</font></td>
		<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">File Name</font></td>
		<td height="18" bgcolor="006633" class="productTitle" align="center"><font color="FFFFFF">Case Image?</font></td>
		<td height="18" bgcolor="006633" class="productTitle" align="center"><font color="FFFFFF">&nbsp;</font></td>
	</tr>

	<!--- LIST DATA --->	
	<cfif qryConfigPhotos.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="4" class="productTitle"><font color="FF0000">There are currently no System Images defined.</font></td>
		</tr>
	</cfif>
	
	<cfloop query="qryConfigPhotos">
		<tr>
			<cfif trim(qryConfigPhotos.Name) IS "">
				<cfset NameText = "[none]">
			<cfelse>
				<cfset NameText = trim(qryConfigPhotos.Name)>
			</cfif>
			<td class="textmain" align="left">
				<a href="index.cfm?task=config_setup_photos_edit&ConfigPhotoID=#urlEncodedFormat(qryConfigPhotos.ConfigPhotoID)#">
					#NameText#
				</a>
			</td>
			<td class="textmain" align="left">#qryConfigPhotos.PhotoImage#</td>
			<td class="textmain" align="center">#yesNoFormat(qryConfigPhotos.CaseImage)#</td>
			<td class="textsmall" align="center">
				<img src="https://partners.nor-tech.com/images/systems/#qryConfigPhotos.PhotoImage#" border="0" alt="System Image">
			</td>

		</tr>
		<tr><td colspan="4"><hr></td></tr>
	</cfloop>

	</table>
</td>
</tr>


</table>
</cfoutput>