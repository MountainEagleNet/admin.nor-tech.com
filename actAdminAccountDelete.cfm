<!---
Coded By: 		Alternative Systems, Inc - Ron Barth
Create Date: 	07/25/2007
Function: 		Deletes an admin account
Template:		actAdminAccountDelete.cfm
Task:			admin_accounts_delete 
--->
<cfset objAdmin = createObject("component", "admin.assets.cfcs.Admin")>
<cfset objSalesRep = createObject("component", "admin.assets.cfcs.SalesRep")>
<cfset objCust = createObject("component", "admin.assets.cfcs.Cust")>
<cfset objPriceLists = createObject("component", "admin.assets.cfcs.prices.PriceLists")>
<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>

<cfset stFormCopy = duplicate(FORM)>

<!--- Is this a sales rep that has customers in table "login"? --->
<cfset strSalesRep = objSalesRep.getSalesRepByUserID(stFormCopy.UserID)>

<cfif NOT structIsEmpty(strSalesRep) AND trim(strSalesRep.ID) IS NOT "">
	<cfset qryLogin = objCust.getCustomersForSalesRep(strSalesRep.ID)>
	<cfif qryLogin.RecordCount GT 0>
		<cfset objAdmin.setMessage("** ERROR **<br>This user account cannot be deleted because it is a sales rep assigned to one or more resellers.  You must remove this sales rep from all customer (reseller) accounts before deleting.")>
		<cflocation url="index.cfm?task=admin_accounts_edit&&uid=#urlEncodedFormat(stFormCopy.UserID)#">
	</cfif>
</cfif>

<!--- Does this admin account have any Price Lists in tblPriceLists? --->
<cfset qryPriceLists = objPriceLists.listRecordsForParent("UserID", stFormCopy.UserID)>
<cfif qryPriceLists.RecordCount GT 0>
	<cfset objAdmin.setMessage("** ERROR **<br>This user account cannot be deleted because it is has one or more price lists defined.  You must first remove each of this user's price lists before you can delete this account.")>
	<cflocation url="index.cfm?task=admin_accounts_edit&&uid=#urlEncodedFormat(stFormCopy.UserID)#">
</cfif>

<!--- Does this admin account have any Configurations in tblConfigSystems? --->
<cfset qryConfigSystems = objConfigSystems.listRecordsForParent("UserID", stFormCopy.UserID)>
<cfif qryConfigSystems.RecordCount GT 0>
	<cfset objAdmin.setMessage("** ERROR **<br>This user account cannot be deleted because it is has one or more system configurations set up in the configurator.  You must first remove each of these configurations from this user before you can delete this account.")>
	<cflocation url="index.cfm?task=admin_accounts_edit&&uid=#urlEncodedFormat(stFormCopy.UserID)#">
</cfif>

<!--- DELETE THE ACCOUNT --->
<cfset objAdmin.deleteRecord(stFormCopy.UserID)>
<cfif isDefined("strSalesRep.ID")>
	<cfset objSalesRep.deleteRecord(strSalesRep.ID)>
</cfif>

<cfset objAdmin.setMessage("The user account has been successfully deleted.")>
<cflocation url="index.cfm?task=admin_accounts_list">