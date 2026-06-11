<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/26/2006
	Function: 		This page displays a form for editing/adding component categories
	Template:		frmCompCat.cfm	
	Task:			config_setup_compcats_edit, config_setup_compcats_new
--->

<cfset objComponentCategories = createObject("component", "admin.assets.cfcs.config.ComponentCategories")>

<cfif isDefined("URL.Validation")>
	<cfset stRecord = objComponentCategories.getDataRecord()>
	<cfset stErrors = objComponentCategories.getErrorRecord()>
<cfelseif isDefined("URL.ComponentCategoryID")>
	<cfset stRecord = objComponentCategories.getRecord(URL.ComponentCategoryID)>
	<cfset stErrors = structNew()>
<cfelse>
	<cfset stRecord = objComponentCategories.newRecord()>
	<cfset stErrors = structNew()>
</cfif>

<script language="javascript">
	function confirmDelete() {
		var msg = "Are you sure you want to Delete this category?";
		if(confirm(msg)) { return true; }
		else { return false; }
	}
</script>

<cfoutput>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">
		<cfif stRecord.ComponentCategoryID IS "">
			New Component Category
		<cfelse>
			Edit Component Category
		</cfif>
	</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objComponentCategories.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	<form action="index.cfm?task=config_setup_compcats_save" method="Post" name="detailform">
	<input type="hidden" name="ComponentCategoryID" value="#stRecord.ComponentCategoryID#">
	<input type="hidden" name="SortOrder" value="#stRecord.SortOrder#">
	<cfset TabValue = 1>

	<!--- Name --->
	<cfif structKeyExists(stErrors, "Name")>
		<tr>
			<td>&nbsp;</td>
			<td valign="top" class="textmain"><font color="FF0000">&raquo; #stErrors.Name#</font></td>
		</tr>
	</cfif>
	<tr>
		<td valign="middle" class="textmain" width="20%"><b>Name:</b> *</td>
		<td valign="top" class="textmain">
        	<cfif stRecord.Name IS "Power Supply" OR stRecord.Name IS "EnergyStar">
                <input type="hidden" name="Name" value="#stRecord.Name#">
                #stRecord.Name#
            <cfelse>
                <input name="Name" size="30" maxlength="50" tabindex="#TabValue#" value="#stRecord.Name#" 
                    <cfif structKeyExists(stErrors, "Name")>style="border:1px solid red;"</cfif>
                >
                <cfset TabValue = TabValue + 1>
            </cfif>
		</td>
	</tr>

	<!--- CATEGORY --->
	<cfif structKeyExists(stErrors, "CATEGORY")>
		<tr>
			<td>&nbsp;</td>
			<td valign="top" class="textmain"><font color="FF0000">&raquo; #stErrors.CATEGORY#</font></td>
		</tr>
	</cfif>
	<tr>
		<td valign="middle" class="textmain"><b>Category:</b> *</td>
		<td valign="top" class="textmain">
			<cfset qryCategories = objComponentCategories.listACCPACCategories()>
			<select name="CATEGORY" size="1" tabindex="#TabValue#">
				<option value="">- Select -</option>
				<cfloop query="qryCategories">
					<option value="#qryCategories.CATEGORY#" 
						<cfif stRecord.CATEGORY IS qryCategories.CATEGORY>
							selected
						</cfif>
						> #qryCategories.CATEGORY#- #qryCategories.DESC#
					</option>
				</cfloop>
			</select>
			<cfset TabValue = TabValue + 1>
		</td>
	</tr>

	<!--- SortOrder --->
	<cfif stRecord.ComponentCategoryID IS NOT "">
		<tr>
			<td valign="middle" class="textmain"><b>Sort Order:</b></td>
			<td valign="top" class="textmain">#stRecord.SortOrder#</td>
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
			<cfif trim(stRecord.ComponentCategoryID) IS NOT "">
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

<cfif structKeyExists(stErrors, "Name")>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['Name'].focus(); document.detailform['Name'].select()
	-->
	</script>
<cfelseif structKeyExists(stErrors, "CATEGORY")>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['CATEGORY'].focus(); 
	-->
	</script>
<cfelse>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['Name'].focus();
	-->
	</script>
</cfif>	