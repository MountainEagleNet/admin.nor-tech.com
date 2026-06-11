<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/06/2007
	Function: 		"Quit" action page
	Template:		actQuit.cfm
	Task:			serials_counts_quit_act
--->

<!--- QUIT was clicked --->
<cfif isDefined("FORM.WhichButton") AND findNoCase("Quit", FORM.WhichButton) NEQ 0>
	<cflocation url="index.cfm?task=serials_counts_enter">

<!--- CONTINUE was clicked --->
<cfelse>
	<cflocation url="index.cfm?task=serials_counts_serials_edit">
</cfif>