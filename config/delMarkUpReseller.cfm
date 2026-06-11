<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/14/2006
	Function: 		Delete a reseller markup
	Template:		delMarkUpReseller.cfm
	Task:			config_setup_markupreseller_delete
--->
<cfset objConfigComponentsResellers = createObject("component", "admin.assets.cfcs.config.ConfigComponentsResellers")>
<cfset strConfigComponentsReseller = objConfigComponentsResellers.getRecord(URL.ConfigComponentsResellersID)>

<cfset objConfigComponentsResellers.deleteRecord(URL.ConfigComponentsResellersID)>

<cfset objConfigComponentsResellers.setMessage("The record has been successfully deleted.")>

<cflocation url="index.cfm?task=config_setup_markupreseller_edit&ConfigComponentID=#urlEncodedFormat(strConfigComponentsReseller.ConfigComponentID)#">