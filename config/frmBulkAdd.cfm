<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	10/09/2008
	Function: 		This page displays a form for adding a component to all of a sales rep's systems.
	Template:		frmBulkAdd.cfm	
	Task:			config_setup_bulkadd_frm
--->

<cfset objConfigComponents = createObject("component", "admin.assets.cfcs.config.ConfigComponents")>
<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>

<cfif isDefined("URL.DefaultSystems")>
	<cfset DefaultSystems = URL.DefaultSystems>
<cfelse>
	<cfset DefaultSystems = objConfigSystems.getSessionValue("DefaultSystems")>
</cfif>
<cfif NOT isDefined("DefaultSystems") OR DefaultSystems IS "">
	<cfset DefaultSystems = 0>
</cfif>

<cfset SearchRecord = structNew()>
<cfset structInsert(SearchRecord, "DefaultSystem", DefaultSystems, True)>
<cfif NOT DefaultSystems>
	<cfset structInsert(SearchRecord, "UserID", objConfigSystems.getSessionValue("adminuserid"), True)>
</cfif>    
<cfset qryConfigSystems = objConfigSystems.searchRecords(SearchRecord, "query", "TypeSortOrder, Name")>

<cfif isDefined("URL.Validation")>
	<cfset stRecord = objConfigComponents.getSessionValue("BulkComponent1")>
	<cfset stErrors = objConfigComponents.getErrorRecord()>
<cfelse>
	<cfset stRecord = structNew()>
    <cfset structInsert(stRecord, "AddComponent", "", True)>
    <cfloop query="qryConfigSystems">
    	<cfset structInsert(stRecord, "SYS|#qryConfigSystems.ConfigSystemID#", 1, True)>
    </cfloop>
	<cfset stErrors = structNew()>
</cfif>

<script language="javascript">
	function disableButton() {
		document.detailform.ButtonClicked.disabled = true;
		window.document.detailform.submit();
	}
</script>


<cfoutput>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">
		Add System Component
	</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objConfigComponents.getMessage()#</font></td>
</tr>

<tr>
	<td valign="top" class="textmain">
    	Enter a valid ACCPAC part number in the box below, check one or more of your configurations, then click "Continue".<br />
        You will then be given a chance to select the category (or categories) that you want to add this component to.<br />
        This function will add this component to all of the configurations you check below.<br />
        <cfif NOT DefaultSystems>
            <font color="FF0000"><i><b>Note:</b></i></font> You can add components only to systems that you maintain yourself; those maintained by their corresponding default system do not appear in the list below.
		<cfelse>
            <font color="FF0000"><i><b>Note:</b></i></font> It will also add the component to all sales rep's systems that are being maintained by their corresponding default system.
      	</cfif>
    </td>
</tr>    

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="4" width="100%" border="0">
	<form action="index.cfm?task=config_setup_bulkadd_act&RequestTimeout=6000" method="Post" name="detailform">
	<cfset TabValue = 1>

	<!--- AddComponent --->
	<cfif structKeyExists(stErrors, "AddComponent")>
		<tr>
			<td>&nbsp;</td>
			<td valign="bottom" class="textmain"><font color="FF0000">&raquo; #stErrors.AddComponent#</font></td>
		</tr>
	</cfif>
	<tr>
		<td valign="middle" class="textmain" width="30%"><b>Component to Add:</b> *</td>
		<td valign="top" class="textmain">
			<input name="AddComponent" size="30" maxlength="50" tabindex="#TabValue#" value="#stRecord.AddComponent#" 
				<cfif structKeyExists(stErrors, "AddComponent")>style="border:1px solid red;"</cfif>
			>
			<cfset TabValue = TabValue + 1>
		</td>
	</tr>
        
    
    <tr>
    <td valign="top" class="textmain" colspan="2">
        <table cellpadding="2" cellspacing="0" width="100%" border="0">
        
		<cfif structKeyExists(stErrors, "Systems")>
            <tr>
                <td colspan="3" valign="bottom" class="textmain"><font color="FF0000">&raquo; #stErrors.Systems#</font></td>
            </tr>
        </cfif>
        
        
        <!--- LIST HEADINGS --->
        <tr>
            <td height="18" bgcolor="006633" class="productTitle" width="10%"><font color="FFFFFF">&nbsp;</font></td>
            <td height="18" bgcolor="006633" class="productTitle" width="25%"><font color="FFFFFF">System Type</font></td>
            <td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">System Name</font></td>
        </tr>
        
        <!--- DATA --->
        <cfif qryConfigSystems.RecordCount EQ 0>
            <tr>
                <td align="center" colspan="3" class="productTitle"><font color="FF0000">You have no systems defined.</font></td>
            </tr>
        </cfif>
    
        <cfloop query="qryConfigSystems">
        	<cfif NOT objConfigSystems.isMaintainedByDefault(qryConfigSystems.ConfigSystemID)>
				<cfset FieldName = "SYS|" & qryConfigSystems.ConfigSystemID>
                <cfset SystemIsAssigned = 0>
                <tr<cfif qryConfigSystems.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
                    <td class="textsmall">
                        <!--- Assigned CheckBox --->
                        <input type="checkbox" name="#FieldName#" value="1" tabindex="#TabValue#"
                            <cfif structKeyExists(stRecord, FieldName)>
                                checked
                            </cfif>
                        >
                        <cfset TabValue = TabValue + 1>
                    </td>
                    <td class="textsmall">
                        #qryConfigSystems.Type#
                    </td>
                    <td class="textsmall">
                        #qryConfigSystems.Name#
                    </td>
                </tr>
            </cfif>
        </cfloop>
    
        </table>
    </td>
    </tr>

	<tr>
	<td valign="top" colspan="2" align="right">
		<table cellpadding="4" cellspacing="0" border="0" width="100%">
		<tr>
			<td align="center"><!--- "Continue" BUTTON --->
				<input type="submit" name="ButtonClicked" value="Continue" tabindex="#TabValue#" onclick="return disableButton()">
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

<cfif structKeyExists(stErrors, "AddComponent")>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['AddComponent'].focus(); document.detailform['AddComponent'].select()
	-->
	</script>
<cfelse>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['AddComponent'].focus();
	-->
	</script>
</cfif>	