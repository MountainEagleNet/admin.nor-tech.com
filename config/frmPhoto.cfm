<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/09/2006
	Function: 		This page displays a form for editing/adding system photos
	Template:		frmPhoto.cfm	
	Task:			config_setup_photos_edit, config_setup_photos_new
--->
<cfset objConfigPhotos = createObject("component", "admin.assets.cfcs.config.ConfigPhotos")>

<cfif isDefined("URL.Validation")>
	<cfset stRecord = objConfigPhotos.getDataRecord()>
	<cfset stErrors = objConfigPhotos.getErrorRecord()>
<cfelseif isDefined("URL.ConfigPhotoID")>
	<cfset stRecord = objConfigPhotos.getRecord(URL.ConfigPhotoID)>
	<cfset stErrors = structNew()>
<cfelse>
	<cfset stRecord = objConfigPhotos.newRecord()>
	<cfset stErrors = structNew()>
</cfif>

<script language="javascript">
	function confirmDelete() {
		var msg = "Are you sure you want to Delete this system image?";
		if(confirm(msg)) { return true; }
		else { return false; }
	}
</script>

<cfoutput>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">
		<cfif stRecord.ConfigPhotoID IS "">
			New System Image
		<cfelse>
			Edit System Image
		</cfif>
	</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objConfigPhotos.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="7" cellspacing="2" width="100%" border="0">
	<form action="index.cfm?task=config_setup_photos_save" method="Post" name="detailform" enctype="multipart/form-data">
	<input type="hidden" name="ConfigPhotoID" value="#stRecord.ConfigPhotoID#">
	<cfset TabValue = 1>

	<!--- Name --->
	<tr>
		<td valign="middle" class="textmain" width="30%"><b>Name:</b></td>
		<td valign="top" class="textmain">
			<input name="Name" size="30" maxlength="50" tabindex="#TabValue#" value="#stRecord.Name#" 
				<cfif structKeyExists(stErrors, "Name")>style="border:1px solid red;"</cfif>
			>
			<cfset TabValue = TabValue + 1>
		</td>
	</tr>

	<!--- PhotoImage Name --->
	<cfif stRecord.ConfigPhotoID IS NOT "">
		<tr>
			<td valign="middle" class="textmain"><b>Image File Name:</b></td>
			<td valign="top" class="textmain">#stRecord.PhotoImage#</td>
		</tr>
	</cfif>

	<!--- PhotoImage (thumbnail) --->
	<cfif stRecord.ConfigPhotoID IS NOT "">
		<tr>
			<td valign="middle" class="textmain"><b>Photo:</b></td>
			<td valign="top" class="textmain">
				<cfif trim(stRecord.PhotoImage) IS NOT "">
					<img src="https://partners.nor-tech.com/images/systems/#stRecord.PhotoImage#" border="0" alt="System Image">
				</cfif>
			</td>
		</tr>
	</cfif>
	
	<!--- Description --->
	<tr>
		<td valign="middle" class="textmain"><b>Description:</b></td>
		<td valign="top" class="textmain">
			<textarea name="Description" wrap="virtual" cols="50" rows="5" tabindex="#TabValue#" class="textmain">#stRecord.Description#</textarea>
			<cfset TabValue = TabValue + 1>
		</td>
	</tr>
    
	<!--- CaseImage --->
    <tr>
		<td valign="middle" class="textmain"><b>Case Image?</b></td>
		<td valign="top" class="textmain">
            <input type="checkbox" name="CaseImage" value="1" tabindex="#TabValue#"
                <cfif stRecord.CaseImage EQ 1>
                    checked
                </cfif>
            >
            <cfset TabValue = TabValue + 1>
        </td>
    </tr>
	
	<!--- Upload New Image --->
	<tr>
		<td valign="middle" class="textmain"><b>Upload New Image:</b></td>
		<td valign="top" class="textmain">
			<input name="UploadFile" type="file" size="30" tabindex="8">
		</td>
	</tr>
	<cfif stRecord.ConfigPhotoID IS NOT "">
		<tr>
			<td valign="middle" class="textmain" colspan="2">
				<b><i><font color="FF0000">Please Note:</font></i></b> Uploading a new image will replace the current image with the new one on <i>all</i> sales reps' systems that use this image.
			</td>
		</tr>
	</cfif>

	<tr>
	<td valign="top" colspan="2" align="right">
		<table cellpadding="4" cellspacing="0" border="0" width="80%">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td><!--- "SAVE" BUTTON --->
				<input type="submit" name="ButtonClicked" value="Save" tabindex="#TabValue#">
			</td>
			<cfif trim(stRecord.ConfigPhotoID) IS NOT "">
				<td><!--- "DELETE" BUTTON --->
					<input type="submit" name="ButtonClicked" value="Delete" onclick="return confirmDelete()">
				</td>
			</cfif>
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

<script language="JavaScript" type="text/JavaScript">
<!--
document.detailform['Name'].focus();
-->
</script>