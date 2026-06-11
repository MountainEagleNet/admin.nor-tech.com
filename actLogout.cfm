<cfsilent>
	<!---
	Coded By: Alternative Systems, Inc - Nicholas Tunney
	Create Date: 7/16/2005
	Edit Date: 
	Function: This page processes an admin logout
	actLogout.cfm
	--->
	<!--- kill the SESSION.AdminAuth variable --->
	<cfscript>
		StructDelete(SESSION, "AdminAuth");
	</cfscript>
	<!--- send the user back to the login page --->
	<cflocation url="frmLogin.cfm?lo=1">
</cfsilent>