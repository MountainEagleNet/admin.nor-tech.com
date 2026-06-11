<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	10/07/2008
	Function: 		Delete Duplicates Page
	Template:		actDuplicates.cfm
	Task:			serials_corrections_delete_duplicates
--->
<cfset objSerials = createObject("component", "admin.assets.cfcs.Serials")>

<cfset NumberDeleted = objSerials.deleteDuplicates(URL.ITEMNO)>

<cfif NumberDeleted EQ 0>
	<cfset objSerials.setMessage("No Duplicates were found; none were deleted!")>
<cfelseif NumberDeleted EQ 1>
	<cfset objSerials.setMessage("One Duplicate was found and successfully deleted!")>
<cfelse>
	<cfset objSerials.setMessage("#NumberDeleted# Duplicates were found and successfully deleted!")>
</cfif>

<cflocation url="index.cfm?task=serials_corrections_serials_list&ITEMNO=#urlEncodedFormat(URL.ITEMNO)#">