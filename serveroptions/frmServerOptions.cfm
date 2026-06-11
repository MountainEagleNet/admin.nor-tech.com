<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/31/2007
	Function: 		Add/Edit a Part
	Template:		frmServerOptions.cfm	
	Task:			server_options_new, server_options_edit
--->
<cfset objServerOptions = createObject("component", "admin.assets.cfcs.config.ServerOptions")>
<cfset objServerOptionSelections = createObject("component", "admin.assets.cfcs.config.ServerOptionSelections")>

<cfif isDefined("URL.Validation")>
	<cfset stRecord = objServerOptions.getDataRecord()>
	<cfset stErrors = objServerOptions.getErrorRecord()>
<cfelseif NOT isDefined("URL.ServerOptionID")>
	<cfset stRecord = objServerOptions.newRecord()>
	<cfset stErrors = structNew()>
<cfelse>
	<cfset stRecord = objServerOptions.getRecord(URL.ServerOptionID)>
	<cfset stErrors = structNew()>
</cfif>
<!---
stRecord:<cfdump var="#stRecord#">
--->

<cfif stRecord.ServerOptionID IS NOT "">
	<cfset qryServerOptionSelections = objServerOptionSelections.getSelections(stRecord.ServerOptionID)>
</cfif>
<!---
qryServerOptionSelections:<cfdump var="#qryServerOptionSelections#">
--->
<cfoutput>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">
		Edit/New Server Option
	</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objServerOptions.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="4" width="100%" border="0">
	<form action="index.cfm?task=server_options_save&RequestTimeout=6000" method="Post" name="detailform">
	<input type="hidden" name="ServerOptionID" value="#stRecord.ServerOptionID#">
	<cfset TabValue = 1>

	<!--- Name --->
	<cfif structKeyExists(stErrors, "Name")>
		<tr>
			<td>&nbsp;</td>
			<td valign="bottom" class="textmain"><font color="FF0000">&raquo; #stErrors.Name#</font></td>
		</tr>
	</cfif>
	<tr>
		<td valign="middle" class="textmain" width="30%"><b>Server Option Name:</b> *</td>
		<td valign="top" class="textmain">
			<input name="Name" size="35" maxlength="50" tabindex="#TabValue#" value="#stRecord.Name#" 
				<cfif structKeyExists(stErrors, "Name")>style="border:1px solid red;"</cfif>
			>
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

	<cfif stRecord.ServerOptionID IS NOT "">
    
        <tr><td colspan="2"><hr /></td></tr>
    
        <tr>
            <td valign="middle" class="textmain"><b>Selections:</b></td>
            
            <td valign="top" class="textmain" colspan="1" align="right">
                <a href="index.cfm?task=server_options_selections_new&ServerOptionID=#urlEncodedFormat(stRecord.ServerOptionID)#">
                    Add a New Server Option Selection
                </a>
            </td>
        </tr>


        <tr>
            <td valign="top" class="textmain" colspan="2">
                <table cellpadding="0" cellspacing="0" width="100%" border="0">
                
                <!--- LIST HEADINGS --->
                <tr>
                    <td valign="bottom" height="18" class="menuwh" bgcolor="006633">
						<a class="menuwh" href="index.cfm?task=server_options_edit&ServerOptionID=#urlEncodedFormat(stRecord.ServerOptionID)#">
                            Server Option Selection Name
						</a>                            
                    </td>
                </tr>
            
                <!--- LIST DATA --->	
                <cfif qryServerOptionSelections.RecordCount EQ 0>
                    <tr>
                        <td align="center" colspan="1" class="productTitle"><font color="FF0000">There are currently no selections defined for this Server Option.</font></td>
                    </tr>
                </cfif>
                
                <cfloop query="qryServerOptionSelections">
                    <tr<cfif qryServerOptionSelections.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
                        <td class="textsmall" align="left">
                            <a href="index.cfm?task=server_options_selections_edit&ServerOptionSelectionID=#urlEncodedFormat(qryServerOptionSelections.ServerOptionSelectionID)#">
                                #qryServerOptionSelections.Name#
                            </a>				
                        </td>
                    </tr>
                </cfloop>
            
                </table>
            </td>
        </tr>




	</cfif>

    

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
<cfelse>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['Name'].focus();
	-->
	</script>
</cfif>	