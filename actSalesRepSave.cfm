<cfsilent>
	<!---
	Coded By: Alternative Systems, Inc - Ron Barth
	Create Date: 9/21/2005
	Edit Date: 
	Function: Saves a sales rep account (new or edit)
	actSalesRepSave.cfm 
	--->
	<cfset objSalesRep = createObject("component", "admin.assets.cfcs.SalesRep")>

	<!--- UPLOAD THE FILE --->
	<cfif FORM.UploadFile IS NOT "">
		<cfset SaveDirectory = PartnersDirPath & "reps\images">
		<cffile action="upload" filefield="FORM.UploadFile" destination="#SaveDirectory#" nameconflict="makeunique" mode="777">
		
		<cfset FORM.repbutton = FILE.ServerFile>
	</cfif>
	
	<!--- if we are editing --->
	<cfif len(FORM.ID)>
		<cfset savedAccount = objSalesRep.updateRecord(FORM)>
	<!--- otherwise it is a new record --->
	<cfelse>
		<cfset SalesRepID = objSalesRep.insertRecord(FORM)>
		
		<!--- Adding a new sales rep: set default markup percentages to "10" --->
		<cfset strSalesRep = structNew()>
		<cfset structInsert(strSalesRep, "ID", SalesRepID, True)>
		<cfset structInsert(strSalesRep, "MARKUPPCTWORKSTATIONS", "10", True)>
		<cfset structInsert(strSalesRep, "MARKUPPCTNOTEBOOKS", "10", True)>
		<cfset structInsert(strSalesRep, "MARKUPPCTSERVERS", "10", True)>
		<cfset objsalesrep.updateMarkupPercentages(strSalesRep)>
		
	</cfif>
	
	<!--- send the user back to the admin account list --->
	<cflocation url="index.cfm?task=admin_accounts_list">
	
</cfsilent>
