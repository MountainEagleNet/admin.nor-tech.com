<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/29/2012
	Function: 		This page displays a form for selection server options
	Template:		frmServerOptions.cfm	
	Task:			config_setup_serveroptions_edit
--->


<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>
<cfset objServerOptions = createObject("component", "admin.assets.cfcs.config.ServerOptions")>
<cfset objServerOptionSelections = createObject("component", "admin.assets.cfcs.config.ServerOptionSelections")>
<cfset objServerSelectionsSystems = createObject("component", "admin.assets.cfcs.config.ServerSelectionsSystems")>

<cfif isDefined("URL.Validation")>
	<cfset stRecord = objConfigSystems.getDataRecord()>
	<cfset stErrors = objConfigSystems.getErrorRecord()>
	<cfset Variables.ConfigSystemID = stRecord.ConfigSystemID>
<cfelse>
	<cfset Variables.ConfigSystemID = URL.ConfigSystemID>
	<cfset stRecord = objConfigSystems.getRecord(Variables.ConfigSystemID, "struct")>
	<cfset stErrors = structNew()>
</cfif>	

<cfset qryServerOptions = objServerOptions.listRecords()>
<!---
qryServerOptions:<cfdump var="#qryServerOptions#">
--->

<cfset isMaintainedByDefault = objConfigSystems.isMaintainedByDefault(Variables.ConfigSystemID)>
<!---
<script language="javascript">
	function openWindow(url_string, width, height)	{
		var options = "scrollbars=1,resizable=1,height="+height+",width="+width;
		new_window = window.open(url_string, "newwin", options );
		return false;
	}	
</script>
--->
<cfoutput>

<!---<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">--->
<table width="575" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle" colspan="2">Server Options Page</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain" colspan="2"><font color="FF0000">#objConfigSystems.getMessage()#</font></td>
</tr>

<tr><!--- Help --->
	<td valign="top" class="textmain" colspan="2">
  		<cfif NOT isMaintainedByDefault>
            Make one selection for each server option by clicking its radio button.
      	<cfelse>
        	An "X" to the left of a server option identifies the selection for that option.
        </cfif>
	</td>
</tr>

<!--- spacer --->
<tr><td class="textsmall" colspan="2">&nbsp;</td></tr>

<tr>
	<td colspan="2">	
		<table cellpadding="2" cellspacing="0" width="100%" border="0">
			<tr>
				<td valign="middle" class="textmain" width="20%"><b>System Name:</b></td>
				<td valign="top" class="textmain">#stRecord.Name#</td>
			</tr>
		</table>
	</td>
</tr>

<tr>
<td valign="top" class="textmain" colspan="2">
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	<form action="index.cfm?task=config_setup_serveroptions_save&RequestTimeout=6000" method="Post" name="detailform">
	<input type="hidden" name="ConfigSystemID" value="#stRecord.ConfigSystemID#">
	<input type="hidden" name="Name" value='#stRecord.Name#'>
	<cfset TabValue = 1>
	
	<!--- LIST HEADINGS --->
	<tr>
		<td height="18" bgcolor="006633" class="productTitle" colspan="3"><font color="FFFFFF">Server Options</font></td>
	</tr>

	<!--- DATA --->
	<cfif qryServerOptions.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="3" class="productTitle"><font color="FF0000">There are no Server Options defined.</font></td>
		</tr>
	</cfif>

	<!--- SERVER OPTIONS --->
	<cfloop query="qryServerOptions">
		<cfset CURRENTServerOptionID = qryServerOptions.ServerOptionID>

		<cfset qryServerOptionSelections = objServerOptionSelections.getSelections(CURRENTServerOptionID)>

        <tr style="background-color:##e5e5e6">
            <!--- SERVER OPTION NAME --->
            <td class="textmain" colspan="3">#qryServerOptions.Name#</td>
        </tr>

		<!--- "Please make a selection for server option..." VALIDATION ERROR MESSAGE --->
        <cfset ErrorFieldName = "SERVOPT_" & CURRENTServerOptionID>
        <cfif structKeyExists(stErrors, ErrorFieldName)>
            <cfset ErrorFieldValue = stErrors[ErrorFieldName]>
            <tr>
                <td valign="top" class="textmain" colspan="4"><font color="FF0000">&raquo; #ErrorFieldValue#</font></td>
            </tr>
        </cfif>
        
		<!--- "NO SELECTIONS FOUND FOR THIS SERVER OPTION" VALIDATION ERROR MESSAGE --->
        <cfif qryServerOptionSelections.RecordCount EQ 0>
            <tr>
                <td align="center" colspan="3" class="textsmall"><font color="FF0000">There no selections for server option '#qryServerOptions.Name#'.</font></td>
            </tr>
        </cfif>
        
		<!--- SELECTIONS --->
        <cfloop query="qryServerOptionSelections">
            <cfset CURRENTServerOptionSelectionID = qryServerOptionSelections.ServerOptionSelectionID>
            <tr>
                <td class="textsmall" width="10%">&nbsp;</td>
                
                <!--- SELECTION RADIO BUTTON --->
                <cfset FieldName = "SERVOPT_" & CURRENTServerOptionID>

                <cfset ThisOneIsChecked = 0>
                <cfif structKeyExists(stRecord, FieldName) AND stRecord[FieldName] IS qryServerOptionSelections.ServerOptionSelectionID>
                    <cfset ThisOneIsChecked = 1>
                <cfelseif objServerSelectionsSystems.inDatabase(stRecord.ConfigSystemID, CURRENTServerOptionSelectionID)>                            
                    <cfset ThisOneIsChecked = 1>
                </cfif>

                <td class="textmain" width="1%" valign="middle">
                    <cfif NOT isMaintainedByDefault>
                        <input type="radio" name="#FieldName#" value="#qryServerOptionSelections.ServerOptionSelectionID#" tabindex="#TabValue#"
                            <cfif ThisOneIsChecked>
                                checked
                            </cfif>
                        >
                    <cfelseif ThisOneIsChecked>
                        <font color="0000FF"><b>X</b></font> 
                    </cfif>                    
                </td>
                
                <td class="textmain" valign="middle">
                    #qryServerOptionSelections.Name#
                </td>
            </tr>
        </cfloop>
            
	</cfloop>

	<tr>
		<td valign="top" colspan="3" align="center">
			<table cellpadding="4" cellspacing="0" border="0" width="60%">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td align="right"><!--- "CONTINUE" BUTTON --->
					<input type="submit" name="ButtonClicked" value="&nbsp;Continue -&raquo;" tabindex="#TabValue#">
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