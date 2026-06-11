<cfsilent>
	<!---
	Coded By: Alternative Systems, Inc - Nicholas Tunney
	Create Date: 7/16/2005
	Edit Date: 	9/21/05, Ron Barth
	Function: Saves an admin account (new or edit)
	actAdminAccountSave.cfm 
	--->
	<cfset objAdmin = createObject("component", "admin.assets.cfcs.Admin")>
	<cfset objComponent = createObject("component", "admin.assets.cfcs.Component")>
	<cfset objSalesRep = createObject("component", "admin.assets.cfcs.SalesRep")>

	<cfparam name="FORM.Active" default="0">
	<cfparam name="FORM.MaintainSystemDefault" default="0">

	<cfset stFormCopy = duplicate(FORM)>
	
	<cfif NOT structKeyExists(stFormCopy, "IsVacationPasswordActive")>
		<cfset structInsert(stFormCopy, "IsVacationPasswordActive", 0, True)>
	</cfif>

	<!--- VALIDATION --->
	<cfset stErrors = structNew()>
	<cfif NOT objAdmin.UserNamePasswordValid(stFormCopy)>
		<cfset stErrors.EmailAddress = "This Email Address and Password you've chosen are already is use.<br>Please change the email address, the password, or both.">
	</cfif>
    <cfif stFormCopy.IsVacationPasswordActive EQ 1 AND trim(stFormCopy.VacationPassword) IS "">
		<cfset stErrors.VacationPassword = "&raquo; In order to set this user on vacation, the Vacation Password must be filled:">
	</cfif>
    <cfif stFormCopy.IsVacationPasswordActive EQ 1 AND trim(stFormCopy.CoveringUserID) IS "">
		<cfset stErrors.CoveringUserID = "&raquo; In order to set this user on vacation, you must select someone to cover for them while they are gone:">
	</cfif>
    <cfif stFormCopy.IsVacationPasswordActive EQ 1 AND trim(stFormCopy.VacationEmail) IS "">
		<cfset stErrors.VacationEmail = "&raquo; In order to set this user on vacation, you must enter an email address to receive this user's online orders.  If you don't want another user to receive these orders, simply enter this user's email address (#stFormCopy.EmailAddress#)">
	</cfif>
	<cfif NOT structIsEmpty(stErrors)>
		<cfset objComponent.setDataRecord(stFormCopy)>
		<cfset objComponent.setErrorRecord(stErrors)>
		<cflocation url="index.cfm?task=admin_accounts_edit&Validation=1">
	</cfif>
    
    <cfset EmailSuccess = 0>

	<!--- if we are editing --->
	<cfif len(stFormCopy.UserID)>
    
		<cfset savedAccount = objAdmin.updateRecord(stFormCopy)>
		<cfset UserID = FORM.UserID>
		<cfset Mode = "Edit">
        
		<!--- If they "Is user on vacation?" was checked, send an email to the covering user --->        
        <cfif stFormCopy.IsVacationPasswordActive_OLD EQ 0 AND stFormCopy.IsVacationPasswordActive EQ 1>
			<cfset EmailSuccess = objAdmin.sendVacationEmail(stFormCopy.UserID)>		
		</cfif>

	<!--- otherwise it is a new record --->
	<cfelse>
		<cfset UserID = objAdmin.insertRecord(stFormCopy)>
		<cfset Mode = "Add">
	</cfif>
    
    <!--- Update the vacation email address --->
    <cfset objSalesRep.updateVacationEmail(UserID, stFormCopy.VacationEmail)>
	
	<cfif FORM.Role IS NOT "Sales Rep">
		<!--- send the user back to the admin account list --->
		<cflocation url="index.cfm?task=admin_accounts_list">
	<cfelse>
		<!--- Go on to the Sales Rep Info page --->
		<cfif Mode IS "Edit">
			<cflocation url="index.cfm?task=admin_salesrep_edit&UserID=#URLEncodedFormat(UserID)#&EmailSuccess=#EmailSuccess#">
		<cfelse>
			<cflocation url="index.cfm?task=admin_salesrep_new&UserID=#URLEncodedFormat(UserID)#">
		</cfif>
	</cfif>
</cfsilent>