<!---
Template:		PasswordChange_act.cfm
Coded By:		Ron Barth
Create Date:	04/19/2013
--->
<cfset objComponent = createObject("component", "admin.assets.cfcs.Component")>

<cfset objAdmin = createObject("component", "admin.assets.cfcs.Admin")>

<!---
<cfset objValidation = createObject("component", "standard.utilities.Validation")>
--->
<cfset stFormCopy = duplicate(FORM)>


<!--- VALIDATE THE FIELDS --->
<cfset stErrors = structNew()>
<!--- password --->
<cfif trim(stFormCopy.password) IS "">
	<cfset structInsert(stErrors, "password", "Please enter a new password:", True)>
</cfif>		

<!--- passwordConfirm --->
<cfif trim(stFormCopy.passwordConfirm) IS "">
	<cfset structInsert(stErrors, "passwordConfirm", "Please confirm your new password by entering it here:", True)>
</cfif>		


<cfif NOT structKeyExists(stErrors, "password") AND NOT structKeyExists(stErrors, "passwordConfirm")>

	<cfif trim(stFormCopy.password) IS NOT trim(stFormCopy.passwordConfirm)>
		<cfset structInsert(stErrors, "passwordConfirm", "Your passwords do not match.  Please try again:", True)>
        
    <cfelseif objAdmin.samePasswordEntered(stFormCopy.UserID, stFormCopy.password)>
		<cfset structInsert(stErrors, "password", "You cannot use the same password; you must change it:", True)>
        
    <cfelseif objAdmin.passwordIsNoGood(stFormCopy.password)>
		<cfset structInsert(stErrors, "password", "Your password must be at least 12 characters in length, and must contain at least one letter, one number, and one special character (such as ! or @):", True)>
        
    </cfif>
</cfif>


<cfif NOT structIsEmpty(stErrors)>
	<!--- Save record and errors to session scope --->
	<cfset objComponent.setSessionValue("PasswordChangeForm", stFormCopy)>
	<cfset objComponent.setSessionValue("PasswordChangeErrors", stErrors)>
    <cflocation addtoken="no" url="PasswordChange.cfm?Validation=1">

<cfelse>	
	<cfset objAdmin.saveNewPassword(stFormCopy.UserID, stFormCopy.password)>

	<cfset SESSION.AdminAuth = 1>


    <cflocation url="index.cfm?task=main">
</cfif>