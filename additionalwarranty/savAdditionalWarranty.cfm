<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	12/28/2009
	Function: 		This page saves the AdditionalWarranty
	Template:		savAdditionalWarranty.cfm
	Task:			additionalwarranty_save
--->
<cfset objAdditionalWarranty = createObject("component", "admin.assets.cfcs.config.AdditionalWarranty")>
<cfset stFormCopy = duplicate(FORM)>

<!--- VALIDATE AND SAVE --->
<cfset stErrors = objAdditionalWarranty.validateRecord(stFormCopy)>

<cfif structIsEmpty(stErrors)>
	<cfset AdditionalWarrantyID = objAdditionalWarranty.saveRecord(stFormCopy)>
	<cfset objAdditionalWarranty.setMessage("The Additional Warranty has been saved.")>
	<cflocation url="index.cfm?task=additionalwarranty_list">
<cfelse>
	<cfset objAdditionalWarranty.setDataRecord(stFormCopy)>
	<cfset objAdditionalWarranty.setErrorRecord(stErrors)>
	<cfset objAdditionalWarranty.setMessage("Please correct the fields indicated below.")>
	<cflocation url="index.cfm?task=additionalwarranty_edit&Validation=1">
</cfif>