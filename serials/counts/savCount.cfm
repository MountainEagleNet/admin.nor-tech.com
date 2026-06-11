<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/08/2006
	Function: 		This page validates/saves the count information
	Template:		savCount.cfm
	Task:			serials_counts_save
--->
<cfset objCounts = createObject("component", "admin.assets.cfcs.Counts")>

<cfset stFormCopy = duplicate(FORM)>

<cfset stErrors = objCounts.validateRecord(stFormCopy)>

<cfif NOT structIsEmpty(stErrors)>
	<cfset objCounts.setDataRecord(stFormCopy)>
	<cfset objCounts.setErrorRecord(stErrors)>
	<cfset objCounts.setMessage("Please correct the fields indicated below.")>
	<cflocation url="index.cfm?task=serials_counts_enter&Validation=1">
<cfelse>
	<cfset objCounts.setDataRecord(stFormCopy)>
	<cfif stFormCopy.Quantity GT 0>
		<!--- If the quantity entered matched the number of serial numbers entered, give the user the chance to quit the process --->
		<cfset QuantityMatches = objCounts.checkQuantity(stFormCopy)>
		<cfif QuantityMatches>
			<cflocation url="index.cfm?task=serials_counts_quit">
		<cfelse>
			<cflocation url="index.cfm?task=serials_counts_serials_edit">
		</cfif>
	<cfelse>
		<cflocation url="index.cfm?task=serials_counts_serials_confirm">
	</cfif>
</cfif>