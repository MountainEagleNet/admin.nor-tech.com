<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/19/2006
	Function: 		This page saves the systems for the reseller
	Template:		savAssignSystems.cfm
	Task:			admin_reseller_systems_save
--->
<cfset objResellerSystems = createObject("component", "admin.assets.cfcs.config.ResellerSystems")>

<cfset stFormCopy = duplicate(FORM)>

<cfparam name="stFormCopy.SystemList" default=""> 

<!--- Assign Systems --->
<cfset objResellerSystems.assignSystems(stFormCopy)>

<!--- UPDATE SYSTEM PRICES --->
<!--- Deprecated, 04/07/2010 --->
<!---
<cfset objResellerSystems.updatePrices(stFormCopy.CustomerID)>
--->

<cfset objResellerSystems.setMessage("The systems have been saved.")>
<cflocation url="index.cfm?task=admin_custaccounts_view&uid=#URLEncodedFormat(stFormCopy.CustomerID)#">
