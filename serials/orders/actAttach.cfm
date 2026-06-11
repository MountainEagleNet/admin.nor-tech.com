<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	10/12/2006
	Function: 		Attach serial numbers Action page
	Template:		actAttach.cfm
	Task:			serials_attach_act
--->

<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>

<cfset stFormCopy = duplicate(FORM)>

<cfif NOT isDefined("stFormCopy.ButtonClicked")>
	<cflocation url="index.cfm?task=serials_attach_list&ORDUNIQ=#urlEncodedFormat(stFormCopy.ORDUNIQ)#">
</cfif>

<!--- QUIT was clicked --->
<cfif FORM.ButtonClicked IS "Quit">
	<cflocation url="index.cfm?task=serials_attach_order_enter">

<!--- ATTACH INVOICE was clicked --->
<cfelse>
	<cflocation url="index.cfm?task=serials_attach_confirm&ORDUNIQ=#urlEncodedFormat(stFormCopy.ORDUNIQ)#">
</cfif>