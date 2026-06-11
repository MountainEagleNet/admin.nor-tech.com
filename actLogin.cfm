<cfparam name="FORM.EmailAddress" default="">
<cfparam name="FORM.Passwd" default="">
<cfquery name="checkAdmin" datasource="#APPLICATION.DSN_WWW#">
SELECT	UserID,FName,LName,Role,VacationPassword,IsVacationPasswordActive
FROM	tblAdminAccts
   WHERE	Active = 1 AND
           lower(EmailAddress) = '#lcase(trim(FORM.EmailAddress))#' AND
          (Passwd = '#FORM.Passwd#' OR (VacationPassword = '#FORM.Passwd#' AND IsVacationPasswordActive = 1))
;
</cfquery>	
<cfif checkAdmin.RecordCount EQ 1>
	<cfset ThisSalesRepsID = 0>
	<cfif checkAdmin.Role IS "Sales Rep">
		<cfset objSalesRep = createObject("component", "admin.assets.cfcs.SalesRep")>
		<cfset strSalesRep = objSalesRep.getSalesRepByUserID(checkAdmin.UserID)>
		<cfif structKeyExists(strSalesRep, "ID")>
			<cfset ThisSalesRepsID = strSalesRep.ID>
		</cfif>
	</cfif>
	<cfset SESSION.AdminAuth = 1>
	<cfset SESSION.AdminUserID = checkAdmin.UserID>
	<cfset SESSION.FName = checkAdmin.FName>
	<cfset SESSION.LName = checkAdmin.LName>
	<cfset SESSION.EmailAddress = lcase(trim(FORM.EmailAddress))>
	<cfset SESSION.Role = checkAdmin.Role>
	<cfset SESSION.SalesRepID = ThisSalesRepsID>
       <cfif checkAdmin.IsVacationPasswordActive EQ 1 AND trim(FORM.Passwd) IS checkAdmin.VacationPassword>
		<cfset SESSION.UserOnVacation = 1>
       <cfelse>
		<cfset SESSION.UserOnVacation = 0>
	</cfif>       
    <cflocation url="index.cfm?task=main">       
<cfelse>
	<cfscript>StructDelete(SESSION, "AdminAuth");</cfscript>
	<cflocation url="frmLogin.cfm?nid=1">
</cfif>