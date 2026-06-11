<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	11/29/2006
	Function: 		Remove adjustment from the list
	Template:		actRemove.cfm
	Task:			serials_adjustments_list_remove
--->

<cfset objSerialsAdjustments = createObject("component", "admin.assets.cfcs.SerialsAdjustments")>
<cfset objSerialsAdjustmentsExclude = createObject("component", "admin.assets.cfcs.SerialsAdjustmentsExclude")>

<cfset stFormCopy = duplicate(FORM)>

<!--- BACK was clicked --->
<cfif NOT isDefined("stFormCopy.WhichButton") OR stFormCopy.WhichButton IS "Back">
	<cflocation url="index.cfm?task=serials_adjustments_list">

<!--- CONTINUE was clicked --->
<cfelse>
	<cfset strSerialsAdjustmentsExclude = objSerialsAdjustmentsExclude.newRecord()>
	<cfset structInsert(strSerialsAdjustmentsExclude, "ADJENSEQ", stFormCopy.ADJENSEQ, True)>
	<cfset structInsert(strSerialsAdjustmentsExclude, "RemoveComment", stFormCopy.RemoveComment, True)>
	<cfset objSerialsAdjustmentsExclude.saveRecord(strSerialsAdjustmentsExclude)>
	<cfset objSerialsAdjustments.setMessage("The adjustment was successfully removed from the list.")>
	<cflocation url="index.cfm?task=serials_adjustments_list">
</cfif>