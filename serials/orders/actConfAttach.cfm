<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	10/12/2006
	Function: 		Confirmation Action Page
	Template:		actConfAttach.cfm
	Task:			serials_attach_confirm_act
--->

<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>
<cfset objOEINVH = createObject("component", "admin.assets.cfcs.OEINVH")>

<cfif isDefined("URL.FoundExactMatch") AND URL.FoundExactMatch EQ 1>
	<cfset AttachedINVUNIQ = URL.INVUNIQ>
	<cfset Success = objSerialsShipments.attachInvoice(URL.ORDUNIQ, AttachedINVUNIQ)>
	<cfset Variables.ORDUNIQ = URL.ORDUNIQ>
	<cfset Variables.INVUNIQ = AttachedINVUNIQ>

<cfelse>

	<cfset stFormCopy = duplicate(FORM)>
	
	<cfif NOT isDefined("stFormCopy.ButtonClicked")>
		<cflocation url="index.cfm?task=serials_attach_confirm&ORDUNIQ=#urlEncodedFormat(stFormCopy.ORDUNIQ)#">
	</cfif>
	
	<!--- QUIT was clicked --->
	<cfif stFormCopy.ButtonClicked IS "Quit">
		<cflocation url="index.cfm?task=serials_attach_order_enter">
	
	<!--- CONTINUE was clicked --->
	<cfelse>
	
		<!--- Exact Invoice Match was NOT Found --->
		<cfif isDefined("stFormCopy.FoundExactMatch") AND stFormCopy.FoundExactMatch EQ 0>
			<cfset stErrors = objSerialsShipments.validateInvoiceNumber(stFormCopy)>
			<cfif NOT structIsEmpty(stErrors)>
				<cfset objSerialsShipments.setDataRecord(stFormCopy)>
				<cfset objSerialsShipments.setErrorRecord(stErrors)>
				<cfset objSerialsShipments.setMessage("Please correct the fields indicated below.")>
				<cflocation url="index.cfm?task=serials_attach_confirm&Validation=1">
			<cfelse>
				<!--- Get the INVUNIQ for the invoice number entered --->
				<cfset SearchRecord = structNew()>
				<cfset structInsert(SearchRecord, "INVNUMBER", trim(stFormCopy.InvoiceNumber), True)>
				<cfset qryOEINVH = objOEINVH.searchRecords(SearchRecord, "query")>
				<cfset AttachedINVUNIQ = qryOEINVH.INVUNIQ>
				<cfset Success = objSerialsShipments.attachInvoice(stFormCopy.ORDUNIQ, AttachedINVUNIQ, 1)>	<!--- 1=ManualInvoiceNumber --->
				<cfset Variables.ORDUNIQ = stFormCopy.ORDUNIQ>
				<cfset Variables.INVUNIQ = AttachedINVUNIQ>
			</cfif>
		
		<!--- Exact Invoice Match WAS Found --->
		<cfelse>
			<cfset AttachedINVUNIQ = stFormCopy.INVUNIQ>
			<cfset Success = objSerialsShipments.attachInvoice(stFormCopy.ORDUNIQ, AttachedINVUNIQ)>
			<cfset Variables.ORDUNIQ = stFormCopy.ORDUNIQ>
			<cfset Variables.INVUNIQ = AttachedINVUNIQ>
		</cfif>
<!---	
		<cfif isDefined("Success") AND Success EQ 1>
			<cflocation url="index.cfm?task=serials_attach_confirm_view&ORDUNIQ=#urlEncodedFormat(stFormCopy.ORDUNIQ)#&INVUNIQ=#urlEncodedFormat(AttachedINVUNIQ)#">
		<cfelse>
			<cfset objSerialsShipments.setMessage("An error occurred; the invoice was not attached")>
			<cflocation url="index.cfm?task=serials_attach_confirm">
		</cfif>
--->	
	</cfif>

</cfif>

<cfif isDefined("Success") AND Success EQ 1>
	<cflocation url="index.cfm?task=serials_attach_print&ORDUNIQ=#urlEncodedFormat(Variables.ORDUNIQ)#&INVUNIQ=#urlEncodedFormat(Variables.INVUNIQ)#">
<cfelse>
	<cfset objSerialsShipments.setMessage("An error occurred; the invoice was not attached")>
	<cflocation url="index.cfm?task=serials_attach_confirm&ORDUNIQ=#urlEncodedFormat(stFormCopy.ORDUNIQ)#">
</cfif>