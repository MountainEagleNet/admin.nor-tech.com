<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/21/2006
	Function: 		Warning action page
	Template:		actWarning.cfm
	Task:			serials_receipts_warning_act
--->

<!--- BACK was clicked --->
<cfif isDefined("FORM.ButtonClicked") AND findNoCase("Back", FORM.ButtonClicked) NEQ 0>
	<cflocation url="index.cfm?task=serials_receipts_serials_edit&Validation=1">

<!--- CONTINUE was clicked --->
<cfelse>
	<cfif APPLICATION.PasswordActive EQ 0>
		<cflocation url="index.cfm?task=serials_receipts_serials_post&RequestTimeout=6000">
	<cfelse>
		<cflocation url="index.cfm?task=serials_receipts_password">
	</cfif>
</cfif>