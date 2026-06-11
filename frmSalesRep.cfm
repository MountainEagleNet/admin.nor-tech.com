<cfsilent>
	<!---
	Coded By: Alternative Systems, Inc - Ron Barth
	Create Date: 9/21/2005
	Edit Date: 
	Function: Allows adding/editing of a sales rep account
	frmSalesRep.cfm 
	--->
	<cfset objSalesRep = createObject("component", "admin.assets.cfcs.SalesRep")>
	<cfset objAdmin = createObject("component", "admin.assets.cfcs.Admin")>

	<cfset strUser = objAdmin.getRecordAsStruct(URL.UserID)>

	<!--- if we are editing --->
	<cfif URL.task EQ "admin_salesrep_edit">	
		<cfset stRecord = objSalesRep.getSalesRepByUserID(URL.UserID)>
	<!--- otherwise it is a new record --->
	<cfelse>
		<cfset stRecord = objSalesRep.newRecord()>
	</cfif>
	
	<cfset structInsert(stRecord, "UserID", URL.UserID, True)>
</cfsilent>
<script language="javascript">
	function validate(){
//		if (SalesRepAccountForm.FName.value == ""){
//			alert('You must enter a first name.');
//			return false;
//		}
//		if (SalesRepAccountForm.LName.value == ""){
//			alert('You must enter a last name.');
//			return false;
//		}
//		if (SalesRepAccountForm.EmailAddress.value == ""){
//			alert('You must enter an email address.');
//			return false;
//		}
//		if (SalesRepAccountForm.Passwd.value == ""){
//			alert('You must enter a password.');
//			return false;
//		}
	}
</script>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<!--- spacer --->
<tr>
	<td class="textsmall">&nbsp;</td>
</tr>

<cfif isDefined("URL.EmailSuccess") AND URL.EmailSuccess EQ 1>
    <tr>
        <td class="textmain">
            <font color="FF0000">
                The vacation information email was successfully sent.
            </font>
        </td>
    </tr>
    <tr>
        <td class="textsmall">&nbsp;</td>
    </tr>
</cfif>

<form name="SalesRepAccountForm" action="index.cfm?task=admin_salesrep_update" method="post" onsubmit="return validate(this)" enctype="multipart/form-data">
	<cfoutput>
		<input type="hidden" name="ID" value="#stRecord.ID#">
		<input type="hidden" name="UserID" value="#stRecord.UserID#">

		<cfset RepFullName = strUser.fname & " " & strUser.lname>
		<input type="hidden" name="repname" value="#RepFullName#">
		<input type="hidden" name="repemail" value="#strUser.emailaddress#">
		<input type="hidden" name="username" value="#strUser.emailaddress#">
		<input type="hidden" name="password" value="#strUser.passwd#">
		<tr>
			<td class="textmain" align="left">
			
			<strong>Sales Rep Phone:</strong><br>
			<input name="repphone" value="#stRecord.repphone#" size="20" maxlength="25"><br><br>

			<strong>Sales Rep Button:</strong><br>
			<input type="hidden" name="repbutton" value="#stRecord.repbutton#">
			<cfif trim(stRecord.repbutton) IS NOT "">
				<a href="https://partners.nor-tech.com/reps/images/#stRecord.repbutton#" target="_blank">#stRecord.repbutton#</a>
			<cfelse>
				[No Image Uploaded]
			</cfif>
			<br><br>
			
			<strong>New Sales Rep Button to Upload:</strong><br>
			<input name="UploadFile" type="file" size="30" tabindex="2"><br><br>

			<strong>Sales Rep URL:</strong><br>
			<input name="repURL" value="#stRecord.repURL#" size="25" maxlength="50"><br><br>	

			<strong>Sales Rep ACCPAC Code:</strong><br>
			<input name="CODESLSP" value="#stRecord.CODESLSP#" size="5" maxlength="50"><br><br>	

			<strong>Sales Rep Price URL:</strong><br>
			<input name="reppriceurl" value="#stRecord.reppriceurl#" size="25" maxlength="50"><br><br>
<!---
			<!--- VACATION EMAIL ADDRESS --->
			<strong>Vacation Email Address:</strong><br>
			<input name="VacationEmail" value="#stRecord.VacationEmail#" size="25" maxlength="50"><br><br>
--->
			<input type="hidden" name="VacationEmail" value="#stRecord.VacationEmail#">
			
            
			<strong>Message:</strong><br>
			<textarea name="message" wrap="virtual" cols="50" rows="5">#stRecord.message#</textarea><br><br>

			<input type="submit" value="Save"><br>
			</td>
		</tr>
	</cfoutput>
</form>
</table>

