<cfsilent>
	<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	12/05/2008
	Function: 		Saves password information
	Template:		actPasswordSave.cfm 
	--->
	<cfset objAdmin = createObject("component", "admin.assets.cfcs.Admin")>
	<cfset objComponent = createObject("component", "admin.assets.cfcs.Component")>
	<cfset objSalesRep = createObject("component", "admin.assets.cfcs.SalesRep")>

	<cfset stFormCopy = duplicate(FORM)>
	
	<cfif NOT structKeyExists(stFormCopy, "IsVacationPasswordActive")>
		<cfset structInsert(stFormCopy, "IsVacationPasswordActive", 0, True)>
	</cfif>

	<!--- VALIDATION --->
	<cfset stErrors = structNew()>
    <cfif trim(stFormCopy.FName) IS "">
		<cfset stErrors.FName = "&raquo; You must enter your first name:">
	</cfif>
    <cfif trim(stFormCopy.LName) IS "">
		<cfset stErrors.LName = "&raquo; You must enter your last name:">
	</cfif>
    <cfif trim(stFormCopy.EmailAddress) IS "">
		<cfset stErrors.EmailAddress = "&raquo; You must enter your email address:">
	</cfif>
    <cfif trim(stFormCopy.Passwd) IS "">
		<cfset stErrors.Passwd = "&raquo; You must enter a password:">
	</cfif>
    <cfif NOT structKeyExists(stErrors, "EmailAddress") AND NOT structKeyExists(stErrors, "Passwd")>
		<cfif NOT objAdmin.UserNamePasswordValid(stFormCopy)>
            <cfset stErrors.EmailPasswordTaken = "This Email Address and Password you've chosen are already is use.<br>Please change the email address, the password, or both.">
        </cfif>
   	</cfif>
    <cfif stFormCopy.IsVacationPasswordActive EQ 1 AND trim(stFormCopy.VacationPassword) IS "">
		<cfset stErrors.VacationPassword = "&raquo; In order to mark yourself as &quot;on vacation&quot;, the Vacation Password must be filled:">
	</cfif>
    <cfif stFormCopy.IsVacationPasswordActive EQ 1 AND trim(stFormCopy.CoveringUserID) IS "">
		<cfset stErrors.CoveringUserID = "&raquo; In order to mark yourself as &quot;on vacation&quot;, you must select someone to cover for you while you're gone:">
	</cfif>
    <cfif NOT structKeyExists(stErrors, "VacationPassword") AND NOT structKeyExists(stErrors, "Passwd")>
		<cfif trim(stFormCopy.VacationPassword) IS trim(stFormCopy.Passwd)>
            <cfset stErrors.VacationPassword = "&raquo; Your Vacation Password cannot be the same as your &quot;normal&quot; Password:">
        </cfif>
	</cfif>    
    <cfif stFormCopy.IsVacationPasswordActive EQ 1 AND trim(stFormCopy.VacationEmail) IS "">
		<cfset stErrors.VacationEmail = "&raquo; In order to mark yourself as &quot;on vacation&quot;, you must enter an email address to receive your online orders.  If you don't want another user to receive your orders, simply enter your own email address (#stFormCopy.EmailAddress#)">
	</cfif>
        
	<cfif NOT structIsEmpty(stErrors)>
		<cfset objComponent.setDataRecord(stFormCopy)>
		<cfset objComponent.setErrorRecord(stErrors)>
		<cflocation url="index.cfm?task=admin_password_form&Validation=1">
	</cfif>
    
    <cfset EmailSuccess = 0>
    
	<cfset objAdmin.updateRecord(stFormCopy)>

    <!--- Update the vacation email address --->
    <cfset objSalesRep.updateVacationEmail(stFormCopy.UserID, stFormCopy.VacationEmail)>
    
    <!--- If they "Is user on vacation?" was checked, send an email to the covering user --->        
    <cfif stFormCopy.IsVacationPasswordActive_OLD EQ 0 AND stFormCopy.IsVacationPasswordActive EQ 1>
        <cfset EmailSuccess = objAdmin.sendVacationEmail(stFormCopy.UserID)>		
    </cfif>

	<cfif EmailSuccess>
		<cfset objComponent.setMessage("Your information was successfully saved, and the vacation information email was successfully sent.")>
	<cfelse>
		<cfset objComponent.setMessage("Your information was successfully saved.")>
	</cfif>

    <cflocation url="index.cfm?task=admin_password_form">
    
</cfsilent>