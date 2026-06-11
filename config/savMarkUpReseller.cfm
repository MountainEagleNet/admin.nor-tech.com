<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/14/2006
	Function: 		This page saves the markup percentages and fixed prices for resellers
	Template:		savMarkUpReseller.cfm
	Task:			config_setup_markupreseller_save
--->
<cfset objConfigComponentsResellers = createObject("component", "admin.assets.cfcs.config.ConfigComponentsResellers")>
<cfset stFormCopy = duplicate(FORM)>


<!--- Validate: Make sure that a default is picked for each category, markups and fixed prices are decimals --->
<cfset stErrors = objConfigComponentsResellers.validateRecord(stFormCopy)>

<cfif structIsEmpty(stErrors)>
	<!--- Save markup percentage or fixed price --->
	<cfset objConfigComponentsResellers.saveRecord(stFormCopy)>
	<cfset objConfigComponentsResellers.setMessage("Reseller markup information has been saved.")>
	<cflocation url="index.cfm?task=config_setup_markupreseller_edit&ConfigComponentID=#urlEncodedFormat(stFormCopy.ConfigComponentID)#">	

<cfelse>
	<cfset objConfigComponentsResellers.setDataRecord(stFormCopy)>
	<cfset objConfigComponentsResellers.setErrorRecord(stErrors)>
	<cfset objConfigComponentsResellers.setMessage("Please correct the fields indicated below.")>
	<cflocation url="index.cfm?task=config_setup_markupreseller_edit&Validation=1">
</cfif>