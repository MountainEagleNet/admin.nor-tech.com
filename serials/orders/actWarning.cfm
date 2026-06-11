<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/26/2006
	Edit Date: 		10/12/2006
	Function: 		Warning action page
	Template:		actWarning.cfm
	Task:			serials_shipments_warning_act
--->

<!--- BACK was clicked --->
<cfif isDefined("FORM.ButtonClicked") AND findNoCase("Back", FORM.ButtonClicked) NEQ 0>
	<cfif isDefined("FORM.CorrectingSerialNumber")>
		<cflocation url="index.cfm?task=serials_shipments_serials_view&ORDUNIQ=#urlEncodedFormat(FORM.ORDUNIQ)#&LINENUM=#urlEncodedFormat(FORM.ORDLINENUM)#">
	<cfelse>
		<cflocation url="index.cfm?task=serials_shipments_serials_edit&Validation=1">
	</cfif>

<!--- CONTINUE was clicked --->
<cfelse>
	<cfif APPLICATION.PasswordActive EQ 0>
		<cfif isDefined("FORM.CorrectingSerialNumber")>
			<cflocation url="index.cfm?task=serials_shipments_serials_post&CorrectingSerialNumber=1&RequestTimeout=6000">
		<cfelse>
			<cflocation url="index.cfm?task=serials_shipments_serials_post&RequestTimeout=6000">
		</cfif>
	<cfelse>
		<cfif isDefined("FORM.CorrectingSerialNumber")>
			<cflocation url="index.cfm?task=serials_shipments_password&CorrectingSerialNumber=1">
		<cfelse>
			<cflocation url="index.cfm?task=serials_shipments_password">
		</cfif>
	</cfif>
</cfif>