<cfsilent>
	<!---
	Coded By: 		Alternative Systems, Inc -  Ron Barth
	Create Date: 	12/05/2008
	Function: 		Allows editing password information
	Template:		frmPassword.cfm 
	--->
	<cfset objAdmin = createObject("component", "admin.assets.cfcs.Admin")>
	<cfset objComponent = createObject("component", "admin.assets.cfcs.Component")>
	<cfset objSalesRep = createObject("component", "admin.assets.cfcs.SalesRep")>

	<cfif isDefined("URL.Validation")>
		<cfset stRecord = objComponent.getDataRecord()>
		<cfset stErrors = objComponent.getErrorRecord()>
	<!--- if we are editing --->
	<cfelse>
		<cfset stRecord = objAdmin.getRecordAsStruct(objComponent.getSessionValue("adminuserid"))>
		<cfset stErrors = structNew()>
        <cfset structInsert(stRecord, "IsVacationPasswordActive_OLD", stRecord.IsVacationPasswordActive, True)>
		<cfset strSalesRep = objSalesRep.getSalesRepByUserID(stRecord.UserID)>
        <cfif structKeyExists(strSalesRep, "VacationEmail")>
        	<cfset structInsert(stRecord, "VacationEmail", strSalesRep.VacationEmail, True)>
		<cfelse>
        	<cfset structInsert(stRecord, "VacationEmail", "", True)>
        </cfif>
	</cfif>
    
    <cfset qryAdminAccts = objAdmin.listSalesReps()>
</cfsilent>

<script language="javascript">
function showOnVacation() {
	document.getElementById("OnVacation").style.display = "block";
}
//-->
</script>


<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Display Message --->
	<td colspan="2" valign="top" class="textmain"><font color="FF0000">#objComponent.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr>
	<td colspan="2" class="textsmall">&nbsp;</td>
</tr>

<cfset TabValue = 1>

<form name="AdminAccountForm" action="index.cfm?task=admin_password_update" method="post">
	<input type="hidden" name="UserID" value="#stRecord.UserID#">
	<input type="hidden" name="Role" value="#stRecord.Role#">
	<input type="hidden" name="Active" value="#stRecord.Active#">

	<cfif structKeyExists(stErrors, "EmailPasswordTaken")>
		<tr>
			<td colspan="2" valign="top" class="textmain">
				<font color="FF0000">
					#stErrors.EmailPasswordTaken#
				</font>
			</td>
		</tr>
	</cfif>


	<cfif structKeyExists(stErrors, "FName")>
		<tr>
        	<td>&nbsp;</td>
			<td valign="top" class="textmain">
				<font color="FF0000">
					#stErrors.FName#
				</font>
			</td>
		</tr>
	</cfif>
	<tr>
		<td width="35%" class="textmain" align="left">
            <strong>First name:</strong>
        </td>
		<td class="textmain" align="left">
            <input name="FName" value="#stRecord.FName#" size="20" maxlength="25" tabindex="#TabValue#">
            <cfset TabValue = TabValue + 1>
        </td>
    </tr>    

	<cfif structKeyExists(stErrors, "LName")>
		<tr>
        	<td>&nbsp;</td>
			<td valign="top" class="textmain">
				<font color="FF0000">
					#stErrors.LName#
				</font>
			</td>
		</tr>
	</cfif>
	<tr>
		<td class="textmain" align="left">
            <strong>Last name:</strong>
        </td>
		<td class="textmain" align="left">
            <input name="LName" value="#stRecord.LName#" size="20" maxlength="25" tabindex="#TabValue#">
            <cfset TabValue = TabValue + 1>
        </td>
    </tr>    

	<cfif structKeyExists(stErrors, "EmailAddress")>
		<tr>
        	<td>&nbsp;</td>
			<td valign="top" class="textmain">
				<font color="FF0000">
					#stErrors.EmailAddress#
				</font>
			</td>
		</tr>
	</cfif>
	<tr>
		<td class="textmain" align="left">
            <strong>Email address:</strong>
        </td>
		<td class="textmain" align="left">
            <input name="EmailAddress" value="#stRecord.EmailAddress#" size="20" maxlength="75" tabindex="#TabValue#">
            <cfset TabValue = TabValue + 1>
		</td>
	</tr>
    
	<cfif structKeyExists(stErrors, "Passwd")>
		<tr>
        	<td>&nbsp;</td>
			<td valign="top" class="textmain">
				<font color="FF0000">
					#stErrors.Passwd#
				</font>
			</td>
		</tr>
	</cfif>
    <tr>
		<td class="textmain" align="left">
            <strong>Password:</strong>
        </td>
		<td class="textmain" align="left">
            <input name="Passwd" value="#stRecord.Passwd#" type="password" size="20" maxlength="50" tabindex="#TabValue#">
            <cfset TabValue = TabValue + 1>
        </td>
    </tr>    

    <tr>
		<td class="textmain" align="left">
            <strong>Are you on Vacation?</strong>
        </td>
		<td class="textmain" align="left">
            <input id="rontest" type="checkbox" name="IsVacationPasswordActive" tabindex="#TabValue#" value="1" onclick="showOnVacation()"<cfif stRecord.IsVacationPasswordActive EQ 1> checked</cfif>>
            <cfset TabValue = TabValue + 1>
			<input type="hidden" name="IsVacationPasswordActive_OLD" value="#stRecord.IsVacationPasswordActive_OLD#">
        </td>
    </tr>    

    <tr id="OnVacation" style="display:none">
        <td colspan="2" valign="top" class="textmain" style="color:333333; font-style:italic">
            To mark yourself as "on vacation", enter a vacation password below, select someone to cover for you while you're gone, and enter an email address to receive your online orders.  The vacation password can be anything you like, however it should not resemble your normal password at all.  After clicking "Save", if you checked the box above, an email will be sent to the Covering User informing them that they're covering for you and supplying them with the login email address and vacation password.
        </td>
    </tr>

	<cfif structKeyExists(stErrors, "VacationPassword")>
		<tr>
        	<td>&nbsp;</td>
			<td valign="top" class="textmain">
				<font color="FF0000">
					#stErrors.VacationPassword#
				</font>
			</td>
		</tr>
	</cfif>
    <tr>
		<td class="textmain" align="left">
            <strong>Vacation Password:</strong>
        </td>
		<td class="textmain" align="left">
            <input name="VacationPassword" value="#stRecord.VacationPassword#" type="password" size="20" maxlength="50" tabindex="#TabValue#">
            <cfset TabValue = TabValue + 1>
        </td>
    </tr>    
    

	<cfif structKeyExists(stErrors, "CoveringUserID")>
		<tr>
        	<td>&nbsp;</td>
			<td valign="top" class="textmain">
				<font color="FF0000">
					#stErrors.CoveringUserID#
				</font>
			</td>
		</tr>
	</cfif>
    <tr>
		<td class="textmain" align="left">
            <strong>Covering User:</strong>
        </td>
		<td class="textmain" align="left">
			<select name="CoveringUserID" size="1" tabindex="#TabValue#">
				<option value="">- Select -</option>
				<cfloop query="qryAdminAccts">
					<option value="#qryAdminAccts.UserID#" 
						<cfif isDefined("stRecord.CoveringUserID") AND stRecord.CoveringUserID IS qryAdminAccts.UserID>
							selected
						</cfif>
						> #qryAdminAccts.fname# #qryAdminAccts.lname#
					</option>
				</cfloop>
			</select>
            <cfset TabValue = TabValue + 1>
        </td>
    </tr>  
    
	<cfif structKeyExists(stErrors, "VacationEmail")>
		<tr>
        	<td>&nbsp;</td>
			<td valign="top" class="textmain">
				<font color="FF0000">
					#stErrors.VacationEmail#
				</font>
			</td>
		</tr>
	</cfif>
    <tr>
		<td class="textmain" align="left">
            <strong>Vacation Email Address:</strong>
        </td>
		<td class="textmain" align="left">
            <input name="VacationEmail" value="#stRecord.VacationEmail#" size="20" maxlength="50" tabindex="#TabValue#">
            <cfset TabValue = TabValue + 1>
        </td>
    </tr>    

      
	<tr>
	<td colspan="2" valign="top" align="left">
		<table cellpadding="4" cellspacing="0" border="0" width="80%">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<!--- "SAVE" BUTTON --->
			<td width="25%" align="left">
				<input type="submit" value="Save" tabindex="#TabValue#">
			</td>
			
		</tr>
		</table>
	</td>
	</tr>		
</form>
</table>
</cfoutput>