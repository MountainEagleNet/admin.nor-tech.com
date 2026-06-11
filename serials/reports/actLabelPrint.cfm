<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/12/2006
	Function: 		Bar Code Printing Page
	Template:		actLabelPrint.cfm
	Task:			serials_reports_label_print
--->

<!--- QUIT was clicked --->
<cfif NOT isDefined("FORM.ButtonClicked") OR findNoCase("Quit", FORM.ButtonClicked) NEQ 0>
	<cflocation url="index.cfm?task=serials_reports_label_enter">

<!--- CONTINUE was clicked --->
<cfelse>
	
	<cfset objSerials= createObject("component", "admin.assets.cfcs.Serials")>
	<cfset stFormCopy = duplicate(FORM)>
	
	<!--- Print Bar Code Label --->
	<cfset Success = objSerials.printSingleBarCodeLabel(stFormCopy.SerialID)>
	<cfif Success>
		<cfset objSerials.setMessage("The bar code label has been printed.")>
	<cfelse>
		<cfset objSerials.setMessage("** ERROR **<br><br>There was a problem with the printing process; the bar code label was NOT printed.")>
	</cfif>
	
	<!--- Go to the display page --->
	<cflocation url="index.cfm?task=serials_reports_label_response&SerialID=#urlEncodedFormat(stFormCopy.SerialID)#">

</cfif>