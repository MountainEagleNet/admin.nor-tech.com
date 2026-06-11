<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/28/2006
	Function: 		Warning action page
	Template:		actWarning.cfm
	Task:			serials_returns_warning_act
--->
<cfset objSerialsReturns = createObject("component", "admin.assets.cfcs.SerialsReturns")>

<cfset stFormCopy = duplicate(FORM)>

<!--- BACK was clicked --->
<cfif isDefined("stFormCopy.ButtonClicked") AND findNoCase("Back", stFormCopy.ButtonClicked) NEQ 0>
	<cfif stFormCopy.RMAACTION IS "Authorization">
		<cfset ForwardTask = "serials_returns_serialsauth_edit">
	<cfelse>
		<cfset ForwardTask = "serials_returns_serialsrcv_edit">
	</cfif>
	<cflocation url="index.cfm?task=#ForwardTask#&Validation=1">

<!--- CONTINUE was clicked --->
<cfelse>
	<cfif stFormCopy.RMAACTION IS "Authorization">
		<cfset stRecord = objSerialsReturns.getDataRecord()>
		<cfset objSerialsReturns.saveSerialNumberInput(stRecord)>
		<cfset objSerialsReturns.setMessage("Serial Numbers were successfully saved.")>
		
		<!--- If not all items for this RMA have been posted, find the first non-posted one and go directly to frmSerials --->
		<cfset FirstUnpostedLINENUM = objSerialsReturns.getFirstUnpostedItem(stFormCopy.RMAUNIQ, stFormCopy.LINENUM, stFormCopy.RMAACTION)>
		<cfif FirstUnpostedLINENUM IS NOT "">
			<cflocation url="index.cfm?task=serials_returns_serialsauth_edit&RMAUNIQ=#urlEncodedFormat(stFormCopy.RMAUNIQ)#&LINENUM=#urlEncodedFormat(FirstUnpostedLINENUM)#&RMAAction=#stFormCopy.RMAAction#">
		<cfelse>
			<cflocation url="index.cfm?task=serials_returns_serials_view&RMAUNIQ=#urlEncodedFormat(stFormCopy.RMAUNIQ)#&LINENUM=#urlEncodedFormat(stFormCopy.LINENUM)#&RMAAction=#stFormCopy.RMAAction#">
		</cfif>
	<cfelse>
		<cflocation url="index.cfm?task=serials_returns_serials_post&RequestTimeout=6000">
	</cfif>
</cfif>