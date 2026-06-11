<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/01/2006
	Function: 		This page displays a form for editing/adding a system
	Template:		frmSystem.cfm	
	Task:			config_setup_systems_edit, config_setup_systems_new
--->
<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>
<cfset objConfigPhotos = createObject("component", "admin.assets.cfcs.config.ConfigPhotos")>
<cfset objClassifications = createObject("component", "admin.assets.cfcs.config.Classifications")>

<cfset objConfigComponents = createObject("component", "admin.assets.cfcs.config.ConfigComponents")>


<cfset DefaultSystems = objConfigSystems.getSessionValue("DefaultSystems")>

<cfif isDefined("URL.Validation")>
	<cfset stRecord = objConfigSystems.getDataRecord()>
	<cfset stErrors = objConfigSystems.getErrorRecord()>
<cfelseif isDefined("URL.ConfigSystemID")>
	<cfset stRecord = objConfigSystems.getRecord(URL.ConfigSystemID)>
	<cfset stErrors = structNew()>
	<cfset objConfigSystems.setSessionValue("NewSystem", 0)>
<cfelse>
	<cfset stRecord = objConfigSystems.newRecord()>
	<cfset stErrors = structNew()>
	<cfset objConfigSystems.setSessionValue("NewSystem", 1)>
	<cfset objConfigSystems.setSessionValue("CopySystem", 0)>
</cfif>

<cfset SearchRecord = structNew()>
<cfset structInsert(SearchRecord, "Type", stRecord.Type, True)>
<cfset qryClassifications = objClassifications.searchRecords(SearchRecord, "query", "Type, SortOrder")>
<cfset isMaintainedByDefault = objConfigSystems.isMaintainedByDefault(stRecord.ConfigSystemID)>



<script language="javascript">
<cfif isMaintainedByDefault AND structKeyExists(stRecord, "SalesRepPickDefaultCase") AND stRecord.SalesRepPickDefaultCase IS "1">
	window.onload = showPickDefaultCase;
</cfif>
function showPickDefaultCase() {
	document.getElementById("PickDefaultCase").style.display = "block";
}
</script>

<cfoutput>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<tr>
<td valign="top" class="subpagetitle"><cfif stRecord.ConfigSystemID IS "">New <cfif DefaultSystems>Default</cfif> System<cfelse>Edit System</cfif>
</td>
</tr>

<cfif isMaintainedByDefault>
    <tr>
    <td valign="top" class="textmain"><font color="FF0000">This system is maintained by its corresponding default system.</font></td>
    </tr>
</cfif>

<tr>
<td valign="top" class="textmain"><font color="FF0000">#objConfigSystems.getMessage()#</font></td>
</tr>

<tr>
<td class="textsmall">&nbsp;</td>
</tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="4" width="100%" border="0">
	<form action="index.cfm?task=config_setup_systems_save&RequestTimeout=6000" method="Post" name="detailform">
	<input type="hidden" name="ConfigSystemID" value="#stRecord.ConfigSystemID#">
	<input type="hidden" name="UserID" value="#stRecord.UserID#">
	<input type="hidden" name="SystemBasePrice" value="#stRecord.SystemBasePrice#">
	<cfset TabValue = 1>

	<tr>
	<td valign="middle" class="textmain" width="20%"><b>Name:</b> *</td>
	<td valign="top" class="textmain">
    	<input type="hidden" name="Name" value="#stRecord.Name#">
        #stRecord.Name#
    </td>
	</tr>

	<tr>
	<td valign="middle" class="textmain"><b>Number:</b></td>
	<td valign="top" class="textmain">
       <input type="hidden" name="SystemNumber" value="#stRecord.SystemNumber#">
       #stRecord.SystemNumber#
	</td>
	</tr>

	<tr>
	<td valign="top" class="textmain"><b>Description:</b></td>
	<td valign="top" class="textmain">
		<textarea name="Description" style="display:none;">#stRecord.Description#</textarea>
		#stRecord.Description#
	</td>
	</tr>

	<tr>
	<td valign="top" class="textmain"><b>Specs:</b></td>
	<td valign="top" class="textmain">
		<textarea name="Specs" style="display:none;">#stRecord.Specs#</textarea>
		#stRecord.Specs#
	</td>
	</tr>

	<tr>
	<td valign="middle" class="textmain"><b>Type:</b> *</td>
	<td valign="top" class="textmain">
    	<input type="hidden" name="Type" value="#stRecord.Type#">
        #stRecord.Type#
	</td>
	</tr>

    <tr>
	<td valign="middle" class="textmain"><b>Classification:</b></td>
	<td valign="middle" class="textmain">
		<input type="hidden" name="ClassificationID" value="#stRecord.ClassificationID#">
		#stRecord.ClassificationName#               
	</td>
	</tr>

	<tr>
	<td valign="middle" class="textmain" colspan="2">
		<b>Energy Star Approved?</b> * 
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="hidden" name="EnergystarApproved" value="#stRecord.EnergystarApproved#">
		#yesNoFormat(stRecord.EnergystarApproved)#               
	</td>
	</tr>

	<tr>
	<td valign="middle" class="textmain" colspan="2">
		<b>Auto Select Power Supply?</b> *  
		&nbsp;
		<input type="hidden" name="PowerSupplyAutoSelect" value="#stRecord.PowerSupplyAutoSelect#">
		#yesNoFormat(stRecord.PowerSupplyAutoSelect)#              
	</td>
	</tr>

	<cfset qryConfigPhotos = objConfigPhotos.listPrimaryPhotos()>
	<tr>
	<td valign="top" class="textmain"><b>Photo:</b> *</td>
	<td valign="top" class="textmain">
		<table width="100%" border="0">
		<cfset ImageFullPath = "http://partners.nor-tech.com/images/systems/" & stRecord.PhotoImage>
		<tr>
		<td valign="middle" class="textmain"><img src="#ImageFullPath#" border="0"></td>
		</tr>               
		</table>
		<input type="hidden" name="ConfigPhotoID" value="#stRecord.ConfigPhotoID#">
		<input type="hidden" name="PhotoImage" value="#stRecord.PhotoImage#"> 
	</td>
	</tr>

	<tr>
	<td valign="top" colspan="2" align="right">
		<table cellpadding="4" cellspacing="0" border="0" width="80%">
		<tr><td>&nbsp;</td></tr>
		<tr>
		<td><input type="submit" name="ButtonClicked" value="&nbsp;Continue -&raquo;" tabindex="#TabValue#"></td>
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