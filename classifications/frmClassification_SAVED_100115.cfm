<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/12/2009
	Function: 		Add/Edit a Classification
	Template:		frmClassifications.cfm	
	Task:			classifications_new, classifications_edit
--->
<cfset objClassifications = createObject("component", "admin.assets.cfcs.config.Classifications")>

<cfif isDefined("URL.Validation")>
	<cfset stRecord = objClassifications.getDataRecord()>
	<cfset stErrors = objClassifications.getErrorRecord()>
<cfelseif NOT isDefined("URL.ClassificationID")>
	<cfset stRecord = objClassifications.newRecord()>
	<cfset stErrors = structNew()>
<cfelse>
	<cfset stRecord = objClassifications.getRecord(URL.ClassificationID)>
	<cfset stErrors = structNew()>
</cfif>


<cfoutput>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">
		Edit/New Classification
	</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objClassifications.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="4" width="100%" border="0">
	<form action="index.cfm?task=classifications_save&RequestTimeout=6000" method="Post" name="detailform">
	<input type="hidden" name="ClassificationID" value="#stRecord.ClassificationID#">
	<cfset TabValue = 1>

	<!--- Name --->
	<cfif structKeyExists(stErrors, "Name")>
		<tr>
			<td>&nbsp;</td>
			<td valign="bottom" class="textmain"><font color="FF0000">&raquo; #stErrors.Name#</font></td>
		</tr>
	</cfif>
	<tr>
		<td valign="middle" class="textmain" width="20%"><b>Name:</b> *</td>
		<td valign="top" class="textmain">
			<input name="Name" size="35" maxlength="50" tabindex="#TabValue#" value="#stRecord.Name#" 
				<cfif structKeyExists(stErrors, "Name")>style="border:1px solid red;"</cfif>
			>
			<cfset TabValue = TabValue + 1>
		</td>
	</tr>

	<!--- Type --->
	<cfif structKeyExists(stErrors, "Type")>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td>&nbsp;</td>
			<td valign="bottom" class="textmain"><font color="FF0000">&raquo; #stErrors.Type#</font></td>
		</tr>
	</cfif>
	<tr>
		<td valign="top" class="textmain"><b>Type:</b> *</td>
		<td valign="top" class="textmain">
			<input type="radio" name="Type" value="Workstation" tabindex="#TabValue#"
				<cfif stRecord.Type IS "workstation">checked</cfif>
				>Workstation <br />
			<input type="radio" name="Type" value="Notebook"
				<cfif stRecord.Type IS "notebook">checked</cfif>
				>Notebook <br />
			<input type="radio" name="Type" value="Server"
				<cfif stRecord.Type IS "server">checked</cfif>
				>Server <br />
			<input type="radio" name="Type" value="MiniMountablePC"
				<cfif stRecord.Type IS "MiniMountablePC">checked</cfif>
				>Mini/Mountable PC
			<cfset TabValue = TabValue + 1>
		</td>
	</tr>

	<!--- SortOrder --->
	<cfif structKeyExists(stErrors, "SortOrder")>
		<tr>
			<td>&nbsp;</td>
			<td valign="bottom" class="textmain"><font color="FF0000">&raquo; #stErrors.SortOrder#</font></td>
		</tr>
	</cfif>
	<tr>
		<td valign="middle" class="textmain"><b>Sort Order:</b> *</td>
		<td valign="top" class="textmain">
			<input name="SortOrder" size="5" maxlength="50" tabindex="#TabValue#" value="#stRecord.SortOrder#" 
				<cfif structKeyExists(stErrors, "SortOrder")>style="border:1px solid red;"</cfif>
			>
			<cfset TabValue = TabValue + 1>
		</td>
	</tr>

	<!--- DefaultClassification --->
	<cfif structKeyExists(stErrors, "DefaultClassification")>
		<tr>
			<td>&nbsp;</td>
			<td valign="bottom" class="textmain"><font color="FF0000">&raquo; #stErrors.DefaultClassification#</font></td>
		</tr>
	</cfif>
	<tr>
		<td valign="middle" class="textmain"><b>Default?</b></td>
		<td valign="top" class="textmain">
            <input type="checkbox" name="DefaultClassification" tabindex="#TabValue#" value="1"<cfif stRecord.DefaultClassification EQ 1> checked</cfif>>
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

<cfif structKeyExists(stErrors, "Name")>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['Name'].focus(); document.detailform['Name'].select()
	-->
	</script>
<cfelseif structKeyExists(stErrors, "Type")>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['Type'].focus(); document.detailform['Type'].select()
	-->
	</script>
<cfelseif structKeyExists(stErrors, "SortOrder")>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['SortOrder'].focus(); document.detailform['SortOrder'].select()
	-->
	</script>
<cfelse>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['Name'].focus();
	-->
	</script>
</cfif>	