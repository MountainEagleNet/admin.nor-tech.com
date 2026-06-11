<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/31/2007
	Function: 		This page saves the part
	Template:		savPartsAdmin.cfm
	Task:			parts_admin_save
--->
<cfset objPartsAdmin = createObject("component", "admin.assets.cfcs.parts.PartsAdmin")>
<cfset stFormCopy = duplicate(FORM)>

<cfparam name="stFormCopy.GarageSale" default="">
<cfparam name="stFormCopy.Inactive" default="0">

<!--- VALIDATE AND SAVE --->
<cfset stErrors = objPartsAdmin.validateRecord(stFormCopy)>

<cfif structIsEmpty(stErrors)>
	<cfif stFormCopy.Inactive EQ 1>
		<cfset structInsert(stFormCopy, "DateInactive", now(), True)>
	<cfelse>
		<cfset structInsert(stFormCopy, "DateInactive", "", True)>
	</cfif>
	<cfset PartsAdminID = objPartsAdmin.saveRecord(stFormCopy)>
	<cfset objPartsAdmin.setMessage("The part has been saved.")>
	<cflocation url="index.cfm?task=parts_admin_list">
<cfelse>
	<cfset objPartsAdmin.setDataRecord(stFormCopy)>
	<cfset objPartsAdmin.setErrorRecord(stErrors)>
	<cfset objPartsAdmin.setMessage("Please correct the fields indicated below.")>
	<cflocation url="index.cfm?task=parts_admin_edit&Validation=1">
</cfif>