<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/22/2006
	Function: 		Password action page
	Template:		actPassword.cfm
	Task:			serials_receipts_password_act
--->
<cfset objSerialsReceipts = createObject("component", "admin.assets.cfcs.SerialsReceipts")>

<!--- BACK was clicked --->
<cfif structKeyExists(FORM, "ButtonClicked") AND findNoCase("Back", FORM.ButtonClicked) NEQ 0>
	<cflocation url="index.cfm?task=serials_receipts_serials_edit&Validation=1">

<!--- CONTINUE was clicked --->
<cfelse>

	<!--- Wrong Password --->
	<cfif NOT structKeyExists(FORM, "Password") OR trim(FORM.Password) IS "" OR 
			(FORM.Password IS NOT APPLICATION.ContinuePassword1 AND
			 FORM.Password IS NOT APPLICATION.ContinuePassword2 AND
			 FORM.Password IS NOT APPLICATION.ContinuePassword3 AND
			 FORM.Password IS NOT APPLICATION.ContinuePassword4 AND
			 FORM.Password IS NOT APPLICATION.ContinuePassword5 AND
			 FORM.Password IS NOT APPLICATION.ContinuePassword6)>
		<cfset objSerialsReceipts.setMessage("** Incorrect Password **<br>Serial Numbers were not posted.")>
		<cflocation url="index.cfm?task=serials_receipts_serials_edit&Validation=1">
	<cfelse>
		<cflocation url="index.cfm?task=serials_receipts_serials_post&Password=#FORM.Password#&RequestTimeout=6000">
	</cfif>
</cfif>