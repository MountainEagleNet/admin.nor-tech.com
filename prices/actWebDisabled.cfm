<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/05/2008
	Function: 		Remove parts from Price Lists that aren’t web-enabled in ACCPAC, Action Page
	Template:		actWebDisabled.cfm
	Task:			config_pricelists_webdisabled_act
--->

<cfset objPriceLists = createObject("component", "admin.assets.cfcs.prices.PriceLists")>

<cfset stFormCopy = duplicate(FORM)>

<cfset Outcome = objPriceLists.webDisabledComponents(stFormCopy.ITEMNO)>

<cfif Outcome IS NOT "">
	<cflocation url="index.cfm?task=config_pricelists_webdisabled_edit&ErrorFound=#Outcome#&ITEMNO=#urlEncodedFormat(stFormCopy.ITEMNO)#">
<cfelse>
	<cflocation url="index.cfm?task=config_pricelists_webdisabled_view&ITEMNO=#urlEncodedFormat(stFormCopy.ITEMNO)#">
</cfif>