<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/28/2006
	Function: 		Action page, executed when any of the buttons is clicked on the serial number page
	Template:		actSerials.cfm
	Task:			serials_returns_serials_act
--->
<cfset objSerialsReturns = createObject("component", "admin.assets.cfcs.SerialsReturns")>
<cfset objSerialBatch2 = createObject("component", "admin.assets.cfcs.SerialBatch2")>

<cfset stFormCopy = duplicate(FORM)>

<!--- If this is a "Batch 2" Item, strip all non-numeric characters from the serial numbers --->
<cfset stFormCopy = objSerialBatch2.formatSerialNumbers(stFormCopy)>

<cfparam name="stFormCopy.PrintBarCodeLabels" default="">

<cfif stFormCopy.RMAACTION IS "Authorization">
	<cfset ForwardTask = "serials_returns_serialsauth_edit">
<cfelse>
	<cfset ForwardTask = "serials_returns_serialsrcv_edit">
</cfif>

<cfif NOT isDefined("stFormCopy.WhichButton")>
	<cflocation url="index.cfm?task=#ForwardTask#&RMAUNIQ=#urlEncodedFormat(stFormCopy.RMAUNIQ)#&LINENUM=#urlEncodedFormat(stFormCopy.LINENUM)#&RMAAction=#stFormCopy.RMAAction#">
</cfif>

<!--- CONSECUTIVE ORDER 2 was clicked --->
<cfif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Consecutive Order 2">
	<!--- Make sure the last SN box filled contains a numeric value --->
	<cfset stErrors = objSerialsReturns.validateConsecutiveOrder2(stFormCopy)>
	<cfset objSerialsReturns.setDataRecord(stFormCopy)>
	<cfset objSerialsReturns.setErrorRecord(stErrors)>
	<cfif NOT structIsEmpty(stErrors)>
		<cflocation url="index.cfm?task=#ForwardTask#&Validation=1">
	<cfelse>
		<cflocation url="index.cfm?task=serials_returns_consec_qty&ForwardTask=#ForwardTask#">
	</cfif>


<!--- CLEAR ALL was clicked --->
<cfelseif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Clear All">

	<cfif stFormCopy.RMAAction IS "Authorization">
		<cfset objSerialsReturns.deleteSerialNumbers(stFormCopy)>
	</cfif>
	<cflocation url="index.cfm?task=#ForwardTask#&RMAUNIQ=#urlEncodedFormat(stFormCopy.RMAUNIQ)#&LINENUM=#urlEncodedFormat(stFormCopy.LINENUM)#&RMAAction=#stFormCopy.RMAAction#">

<!--- CANCEL was clicked --->
<cfelseif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Cancel">
	<cflocation url="index.cfm?task=serials_returns_select">


<!--- SAVE was clicked --->
<cfelseif stFormCopy.RMAAction IS "Authorization">

	<!--- Check for Errors --->
<!---
	<cfset stErrors = objSerialsReturns.checkForErrors(stFormCopy)>
	<cfif NOT structIsEmpty(stErrors)>
		<cfset objSerialsReturns.setDataRecord(stFormCopy)>
		<cfset objSerialsReturns.setErrorRecord(stErrors)>
		<cflocation url="index.cfm?task=serials_returns_serialsauth_edit&Validation=1">
	</cfif>
--->	
	<!--- Check for Batch Item Error:  Make sure that the same entry is made in all of the serial number input boxes  --->
	<cfset stErrors = objSerialsReturns.checkForBatchItemError(stFormCopy)>
	<cfif NOT structIsEmpty(stErrors)>
		<cfset objSerialsReturns.setDataRecord(stFormCopy)>
		<cfset objSerialsReturns.setErrorRecord(stErrors)>
		<cflocation url="index.cfm?task=serials_returns_serialsauth_edit&Validation=1">
	</cfif>

	<!--- Check for Warnings --->
	<cfset stWarnings = objSerialsReturns.checkForWarningsAuthorization(stFormCopy)>
	<cfif NOT structIsEmpty(stWarnings)>
		<cfset objSerialsReturns.setDataRecord(stFormCopy)>
		<cfset objSerialsReturns.setErrorRecord(stWarnings)>
		<cflocation url="index.cfm?task=serials_returns_warning">
	</cfif>

	<cfset objSerialsReturns.saveSerialNumberInput(stFormCopy)>
	<cfset objSerialsReturns.setMessage("Serial Numbers were successfully saved.")>
	
	<!--- If not all items for this RMA have been posted, find the first non-posted one and go directly to frmSerials --->
	<cfset FirstUnpostedLINENUM = objSerialsReturns.getFirstUnpostedItem(stFormCopy.RMAUNIQ, stFormCopy.LINENUM, stFormCopy.RMAACTION)>
	<cfif FirstUnpostedLINENUM IS NOT "">
		<cflocation url="index.cfm?task=serials_returns_serialsauth_edit&RMAUNIQ=#urlEncodedFormat(stFormCopy.RMAUNIQ)#&LINENUM=#urlEncodedFormat(FirstUnpostedLINENUM)#&RMAAction=#stFormCopy.RMAAction#">
	<!--- Otherwise, go directly to the display page --->
	<cfelse>
		<cflocation url="index.cfm?task=serials_returns_serials_view&RMAUNIQ=#urlEncodedFormat(stFormCopy.RMAUNIQ)#&LINENUM=#urlEncodedFormat(stFormCopy.LINENUM)#&RMAAction=#stFormCopy.RMAAction#&PostingAll=1">
	</cfif>
	
<!--- POST was clicked --->
<cfelseif stFormCopy.RMAAction IS "Receiving">

	<!--- Check for Errors --->
<!--- 6/5/06: removing this code; duplicates are now being checked by the scanning JavaScript --->
<!---
	<cfset stErrors = objSerialsReturns.checkForErrors(stFormCopy)>
	<cfif NOT structIsEmpty(stErrors)>
		<cfset objSerialsReturns.setDataRecord(stFormCopy)>
		<cfset objSerialsReturns.setErrorRecord(stErrors)>
		<cflocation url="index.cfm?task=serials_returns_serialsrcv_edit&Validation=1">
	</cfif>
--->
	<!--- Check for Batch Item Error:  Make sure that the same entry is made in all of the serial number input boxes  --->
	<cfset stErrors = objSerialsReturns.checkForBatchItemError(stFormCopy)>
	<cfif NOT structIsEmpty(stErrors)>
		<cfset objSerialsReturns.setDataRecord(stFormCopy)>
		<cfset objSerialsReturns.setErrorRecord(stErrors)>
		<cflocation url="index.cfm?task=serials_returns_serialsrcv_edit&Validation=1">
	</cfif>

	<!--- Check for Warnings --->
	<cfset stWarnings = objSerialsReturns.checkForWarningsReceiving(stFormCopy)>
	<cfif NOT structIsEmpty(stWarnings)>
		<cfset objSerialsReturns.setDataRecord(stFormCopy)>
		<cfset objSerialsReturns.setErrorRecord(stWarnings)>
		<cflocation url="index.cfm?task=serials_returns_warning">
	</cfif>

	<cfset objSerialsReturns.setDataRecord(stFormCopy)>
	<cflocation url="index.cfm?task=serials_returns_serials_post&RequestTimeout=6000">

</cfif>