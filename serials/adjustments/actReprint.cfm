<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/09/2007
	Function: 		Reprint Serial Numbers Page
	Template:		actReprint.cfm
	Task:			serials_adjustments_serials_reprint
--->
<cfset objSerialsAdjustments = createObject("component", "admin.assets.cfcs.SerialsAdjustments")>

<cfset stFormCopy = duplicate(Form)>

<cfset stRecord = structNew()>
<cfset structInsert(stRecord, "ADJENSEQ", stFormCopy.ADJENSEQ, True)>
<cfset structInsert(stRecord, "LINENO", stFormCopy.LINENO, True)>

<!--- Print Bar Code Labels --->
<cfset Success = objSerialsAdjustments.printBarCodeLabels(stRecord)>
<cfif Success>
	<cfset objSerialsAdjustments.setMessage("Bar code labels were successfully printed.")>
<cfelse>
	<cfset objSerialsAdjustments.setMessage("There was a problem with the printing process; bar code labels were NOT printed.")>
</cfif>

<!--- Go to the display page --->
<cflocation url="index.cfm?task=serials_adjustments_serials_view&ADJENSEQ=#urlEncodedFormat(stRecord.ADJENSEQ)#&LINENO=#urlEncodedFormat(stRecord.LINENO)#">