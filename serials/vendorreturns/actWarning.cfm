<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/03/2006
	Function: 		Warning action page
	Template:		actWarning.cfm
	Task:			serials_returnsvendor_warning_act
--->

<!--- BACK was clicked --->
<cfif isDefined("FORM.ButtonClicked") AND findNoCase("Back", FORM.ButtonClicked) NEQ 0>
	<cflocation url="index.cfm?task=serials_returnsvendor_serials_edit&Validation=1">

<!--- CONTINUE was clicked --->
<cfelse>
	<cflocation url="index.cfm?task=serials_returnsvendor_serials_post&RequestTimeout=6000">
</cfif>