<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/22/2006
	Edit Date: 		10/12/2006
	Function: 		Password action page
	Template:		actPassword.cfm
	Task:			serials_shipments_password_act
--->
<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>

<!--- BACK was clicked --->
<cfif structKeyExists(FORM, "ButtonClicked") AND findNoCase("Back", FORM.ButtonClicked) NEQ 0>
	<cfif isDefined("FORM.CorrectingSerialNumber")>
		<cflocation url="index.cfm?task=serials_shipments_serials_view&ORDUNIQ=#urlEncodedFormat(FORM.ORDUNIQ)#&LINENUM=#urlEncodedFormat(FORM.ORDLINENUM)#">
	<cfelse>
		<cflocation url="index.cfm?task=serials_shipments_serials_edit&Validation=1">
	</cfif>

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
		<cfif isDefined("FORM.CorrectingSerialNumber")>
			<cfset objSerialsShipments.setMessage("** Incorrect Password **<br>Serial Number was not corrected.")>
			<cflocation url="index.cfm?task=serials_shipments_serials_view&ORDUNIQ=#urlEncodedFormat(FORM.ORDUNIQ)#&LINENUM=#urlEncodedFormat(FORM.ORDLINENUM)#">
		<cfelse>
			<cfset objSerialsShipments.setMessage("** Incorrect Password **<br>Serial Numbers were not posted.")>
			<cflocation url="index.cfm?task=serials_shipments_serials_edit&Validation=1">
		</cfif>
	<cfelse>
		<cfif isDefined("FORM.CorrectingSerialNumber")>
			<cflocation url="index.cfm?task=serials_shipments_serials_post&Password=#FORM.Password#&CorrectingSerialNumber=1&RequestTimeout=6000">
		<cfelse>
			<cflocation url="index.cfm?task=serials_shipments_serials_post&Password=#FORM.Password#&RequestTimeout=6000">
		</cfif>
	</cfif>
</cfif>