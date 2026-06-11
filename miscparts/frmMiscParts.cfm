<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/31/2007
	Function: 		Add/Edit a Part
	Template:		frmMiscParts.cfm	
	Task:			misc_parts_new, misc_parts_edit
--->
<cfset objMiscParts = createObject("component", "admin.assets.cfcs.parts.MiscParts")>
<cfset objComponentCategories = createObject("component", "admin.assets.cfcs.config.ComponentCategories")>

<cfif isDefined("URL.Validation")>
	<cfset stRecord = objMiscParts.getDataRecord()>
	<cfset stErrors = objMiscParts.getErrorRecord()>
<cfelseif NOT isDefined("URL.MiscPartID")>
	<cfset stRecord = objMiscParts.newRecord()>
	<cfset structInsert(stRecord, "UserID", URL.UserID, True)>
	<cfset stErrors = structNew()>
<cfelse>
	<cfset stRecord = objMiscParts.getRecord(URL.MiscPartID)>
	<cfset stErrors = structNew()>
</cfif>


<cfset qryComponentCategories = objComponentCategories.listRecords()>

<cfoutput>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">
		Edit/New Misc Part
	</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objMiscParts.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="4" width="100%" border="0">
	<form action="index.cfm?task=misc_parts_save&RequestTimeout=6000" method="Post" name="detailform">
	<input type="hidden" name="MiscPartID" value="#stRecord.MiscPartID#">
	<input type="hidden" name="UserID" value="#stRecord.UserID#">
	<cfset TabValue = 1>

	<!--- MfgrPartNumber --->
	<cfif structKeyExists(stErrors, "MfgrPartNumber")>
		<tr>
			<td>&nbsp;</td>
			<td valign="bottom" class="textmain"><font color="FF0000">&raquo; #stErrors.MfgrPartNumber#</font></td>
		</tr>
	</cfif>
	<tr>
		<td valign="middle" class="textmain" width="30%"><b>Manufacturer's<br>Part Number:</b> *</td>
		<td valign="top" class="textmain">
			<input name="MfgrPartNumber" size="35" maxlength="50" tabindex="#TabValue#" value="#stRecord.MfgrPartNumber#" 
				<cfif structKeyExists(stErrors, "MfgrPartNumber")>style="border:1px solid red;"</cfif>
			>
			<cfset TabValue = TabValue + 1>
		</td>
	</tr>

	<!--- Description --->
	<cfif structKeyExists(stErrors, "Description")>
		<tr>
			<td>&nbsp;</td>
			<td valign="bottom" class="textmain"><font color="FF0000">&raquo; #stErrors.Description#</font></td>
		</tr>
	</cfif>
	<tr>
		<td valign="top" class="textmain"><b>Description:</b> *</td>
		<td valign="top" class="textmain">
			<input name="Description" size="35" maxlength="50" tabindex="#TabValue#" value="#stRecord.Description#" 
				<cfif structKeyExists(stErrors, "Description")>style="border:1px solid red;"</cfif>
			>
			<cfset TabValue = TabValue + 1>
		</td>
	</tr>

	<!--- ComponentCategoryID --->
	<cfif structKeyExists(stErrors, "ComponentCategoryID")>
		<tr>
			<td>&nbsp;</td>
			<td valign="bottom" class="textmain"><font color="FF0000">&raquo; #stErrors.ComponentCategoryID#</font></td>
		</tr>
	</cfif>
	<tr>
		<td valign="top" class="textmain"><b>Category:</b></td>
		<td valign="top" class="textmain">
            <select name="ComponentCategoryID" tabindex="#TabValue#">
            	<option value="">- None -</option>
                <cfloop query="qryComponentCategories">
                    <option value="#qryComponentCategories.ComponentCategoryID#"<cfif stRecord.ComponentCategoryID IS qryComponentCategories.ComponentCategoryID> selected</cfif>>
                    	#qryComponentCategories.Name#
                    </option>
                </cfloop>
            </select>
			<cfset TabValue = TabValue + 1>
		</td>
	</tr>

	<!--- Cost --->
	<cfif structKeyExists(stErrors, "Cost")>
		<tr>
			<td>&nbsp;</td>
			<td valign="bottom" class="textmain"><font color="FF0000">&raquo; #stErrors.Cost#</font></td>
		</tr>
	</cfif>
	<tr>
		<td valign="middle" class="textmain"><b>Cost ($):</b> *</td>
		<td valign="bottom" class="textmain">
			<input name="Cost" size="5" maxlength="50" tabindex="#TabValue#" value="#stRecord.Cost#" 
				<cfif structKeyExists(stErrors, "Cost")>style="border:1px solid red;"</cfif>
			>
			<cfset TabValue = TabValue + 1>
		</td>
	</tr>
	
	<!--- Notes --->
	<cfif structKeyExists(stErrors, "Notes")>
		<tr>
			<td>&nbsp;</td>
			<td valign="bottom" class="textmain"><font color="FF0000">&raquo; #stErrors.Notes#</font></td>
		</tr>
	</cfif>
	<tr>
		<td valign="top" class="textmain"><b>Notes:</b></td>
		<td valign="top" class="textmain">
			<textarea name="Notes" wrap="virtual" cols="50" rows="3" tabindex="#TabValue#" class="textmain" <cfif structKeyExists(stErrors, "Notes")>style="border:1px solid red;"</cfif>>#stRecord.Notes#</textarea>
			<cfset TabValue = TabValue + 1>
		</td>
	</tr>
	
	<tr>
	<td valign="top" colspan="2" align="center">
		<table cellpadding="4" cellspacing="0" border="0" width="80%">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center"><!--- "SAVE" BUTTON --->
				<input type="submit" name="ButtonClicked" value="Save" tabindex="#TabValue#">
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

<cfif structKeyExists(stErrors, "MfgrPartNumber")>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['MfgrPartNumber'].focus(); document.detailform['MfgrPartNumber'].select()
	-->
	</script>
<cfelseif structKeyExists(stErrors, "Description")>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['Description'].focus(); document.detailform['Description'].select()
	-->
	</script>
<cfelseif structKeyExists(stErrors, "Cost")>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['Cost'].focus(); document.detailform['Cost'].select()
	-->
	</script>
<cfelse>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['MfgrPartNumber'].focus();
	-->
	</script>
</cfif>	