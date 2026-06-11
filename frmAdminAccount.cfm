<cfsilent>
	<!---
	Coded By: Alternative Systems, Inc - Nicholas Tunney
	Create Date: 7/16/2005
	Edit Date: 	9/21/05, Ron Barth
	Function: Allows adding/editing of an admin account
	frmAdminAccount.cfm 
	--->
	<cfset objAdmin = createObject("component", "admin.assets.cfcs.Admin")>
	<cfset objComponent = createObject("component", "admin.assets.cfcs.Component")>
	<cfset objSalesRep = createObject("component", "admin.assets.cfcs.SalesRep")>

	<cfif isDefined("URL.Validation")>
		<cfset stRecord = objComponent.getDataRecord()>
		<cfset stErrors = objComponent.getErrorRecord()>
	<!--- if we are editing --->
	<cfelseif URL.task EQ "admin_accounts_edit">
		<cfset stRecord = objAdmin.getRecordAsStruct(URLDecode(URL.uid))>
		<cfset stErrors = structNew()>

		<cfset strSalesRep = objSalesRep.getSalesRepByUserID(stRecord.UserID)>
        <cfif structKeyExists(strSalesRep, "VacationEmail")>
        	<cfset structInsert(stRecord, "VacationEmail", strSalesRep.VacationEmail, True)>
		<cfelse>
        	<cfset structInsert(stRecord, "VacationEmail", "", True)>
        </cfif>
        
	<!--- otherwise it is a new record --->
	<cfelse>
		<cfset stRecord = objAdmin.newRecord()>
       	<cfset structInsert(stRecord, "VacationEmail", "", True)>
		<cfset stErrors = structNew()>
	</cfif>
    
    <cfset qryAdminAccts = objAdmin.listSalesReps()>

	<cfset CURRENT_adminuserid = objComponent.getSessionValue("adminuserid")>

    <cfif CURRENT_adminuserid IS "7EBCFD4D-423B-5784-96BD9CB11DAE423D" OR CURRENT_adminuserid IS "F3D0655D-F9B3-2764-44F08B59A3609C3F">
        <cfset ShowPassword = 1>
    <cfelse>
        <cfset ShowPassword = 0>
    </cfif>
    
</cfsilent>

<!---
stRecord:<cfdump var="#stRecord#">
strSalesRep:<cfdump var="#strSalesRep#">
<cfabort>
--->
<script language="javascript">
function validate(){
	if (AdminAccountForm.FName.value == ""){
		alert('You must enter a first name.');
		return false;
	}
	if (AdminAccountForm.LName.value == ""){
		alert('You must enter a last name.');
		return false;
	}
	if (AdminAccountForm.EmailAddress.value == ""){
		alert('You must enter an email address.');
		return false;
	}
	if (AdminAccountForm.Passwd.value == ""){
		alert('You must enter a password.');
		return false;
	}
}

function confirmDelete() {
	var msg = "Are you sure you want to Delete this user account?";
	if(confirm(msg)) { return true; }
	else { return false; }
}

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

<form name="AdminAccountForm" action="index.cfm?task=admin_accounts_update" method="post" onsubmit="return validate(this)">
	<input type="hidden" name="UserID" value="#stRecord.UserID#">

	<cfif structKeyExists(stErrors, "EmailAddress")>
		<tr>
			<td colspan="2" valign="top" class="textmain">
				<font color="FF0000">
					#stErrors.EmailAddress#
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

	<tr>
		<td class="textmain" align="left">
            <strong>Last name:</strong>
        </td>
		<td class="textmain" align="left">
            <input name="LName" value="#stRecord.LName#" size="20" maxlength="25" tabindex="#TabValue#">
            <cfset TabValue = TabValue + 1>
        </td>
    </tr>    

	<tr>
		<td class="textmain" align="left">
            <strong>Email address:</strong>
        </td>
		<td class="textmain" align="left">
            <input name="EmailAddress" value="#stRecord.EmailAddress#" size="20" maxlength="75" tabindex="#TabValue#">
            <cfset TabValue = TabValue + 1>
		</td>
	</tr>
    
    <tr>
		<td class="textmain" align="left">
            <strong>Normal Password:</strong>
        </td>
		<td class="textmain" align="left">
           	<cfif ShowPassword>
                <input name="Passwd" value="#stRecord.Passwd#" size="20" maxlength="50" tabindex="#TabValue#">
			<cfelse>
                <input name="Passwd" value="#stRecord.Passwd#" type="password" size="20" maxlength="50" tabindex="#TabValue#">
            </cfif>
            <cfset TabValue = TabValue + 1>
        </td>
    </tr>    

    <tr>
		<td class="textmain" align="left">
            <strong>Is User on Vacation?</strong>
        </td>
		<td class="textmain" align="left">
            <input id="rontest" type="checkbox" name="IsVacationPasswordActive" tabindex="#TabValue#" value="1" onclick="showOnVacation()"<cfif stRecord.IsVacationPasswordActive EQ 1> checked</cfif>>
            <cfset TabValue = TabValue + 1>
			<input type="hidden" name="IsVacationPasswordActive_OLD" value="#stRecord.IsVacationPasswordActive#">
        </td>
    </tr>    

    <tr id="OnVacation" style="display:none">
        <td colspan="2" valign="top" class="textmain" style="color:333333; font-style:italic">
            To put this user on vacation, enter a vacation password below, select someone to cover for this user while they're gone, and enter an email address to receive this user's online orders.  After clicking "Save", if the box above is checked, an email will be sent to the Covering User informing them that they're covering for this user and supplying them with the login email address and vacation password.
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
           	<cfif ShowPassword>       
                <input name="VacationPassword" value="#stRecord.VacationPassword#" size="20" maxlength="50" tabindex="#TabValue#">
            <cfelse>
                <input name="VacationPassword" value="#stRecord.VacationPassword#" type="password" size="20" maxlength="50" tabindex="#TabValue#">
           	</cfif>     
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
		<td class="textmain" align="left">
<!---
            <strong>Password:</strong><br>
            <input name="Passwd" value="#stRecord.Passwd#" size="20" maxlength="50" tabindex="#TabValue#"><br>
            <font color="666666">
            Note: To set this user "on vacation", set their password to something in the following format: "<i>password</i>_vacation".  
            When logging in, if the system detects "_vacation" in the password, then access to various parts of the system will be restricted.
            </font>
            <br />        <br>
            <cfset TabValue = TabValue + 1>
--->            
            <strong>Role:</strong>
        </td>
		<td class="textmain" align="left">
            <select name="Role" size="1" tabindex="#TabValue#">
                <option value="Sales Rep" <cfif stRecord.Role IS "Sales Rep" OR stRecord.Role IS "">selected</cfif>> 
                    Sales Rep
                </option>
                <option value="Administrator" <cfif stRecord.Role IS "Administrator">selected</cfif>> 
                    Administrator
                </option>
                <option value="Warehouse" <cfif stRecord.Role IS "Warehouse">selected</cfif>> 
                    Warehouse
                </option>
                <option value="Receiver" <cfif stRecord.Role IS "Receiver">selected</cfif>> 
                    Receiver
                </option>
                <option value="Order Puller" <cfif stRecord.Role IS "Order Puller">selected</cfif>> 
                    Order Puller
                </option>
                <option value="RMA" <cfif stRecord.Role IS "RMA">selected</cfif>> 
                    RMA
                </option>
                <option value="Data Entry" <cfif stRecord.Role IS "Data Entry">selected</cfif>> 
                    Data Entry
                </option>
            </select>
            <cfset TabValue = TabValue + 1>
        </td>
    </tr>    



	<!--- MaintainSystemDefault --->
    <!--- 12/14/2012:
		  Sean: "If this box is checked then any time I as the administrator create a new default system it will automatically be imported into their list of offerings.
		  FYI – whenever I create a new default system I always create it under my own systems as a sales rep and then import it into the list of default systems.
		  Conversely, any time I as administrator would delete a default system it would automatically be deleted from their list of offerings.
		  If the "Maintain Sales Reps System By Default" checkbox is left blank for a particular rep then it will remain status quo for them and they’ll be responsible 
		  for importing and deleting their own default systems".	
	--->
	<cfif stRecord.Role IS "Sales Rep" OR stRecord.Role IS "">    
        <tr>
            <td class="textmain" align="left">
                <strong>Maintain Sales Reps<br />System By Default?</strong>
            </td>
            <td class="textmain" align="left">
                <input type="checkbox" name="MaintainSystemDefault" tabindex="#TabValue#" value="1"<cfif stRecord.MaintainSystemDefault EQ 1> checked</cfif>>
                <cfset TabValue = TabValue + 1>
            </td>
        </tr>    
	</cfif>

            
    <tr>
		<td class="textmain" align="left">
            <strong>Is this account Active?</strong>
        </td>
		<td class="textmain" align="left">
            <input type="checkbox" name="Active" tabindex="#TabValue#" value="1"<cfif stRecord.Active EQ 1> checked</cfif>>
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
			</form>
			
			<!--- "DELETE" BUTTON --->
			<cfif stRecord.UserID IS NOT "">
				<form action="index.cfm?task=admin_accounts_delete" method="post" onSubmit="return confirmDelete()">
					<input type="hidden" name="UserID" value="#stRecord.UserID#">
					<td align="left">
						<input type="submit" value="Delete">
					</td>
				</form>
			</cfif>
		</tr>
		</table>
	</td>
	</tr>		
</table>
</cfoutput>