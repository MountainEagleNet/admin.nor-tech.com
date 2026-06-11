<!---
Coded By: 		Alternative Systems, Inc - Ron Barth
Create Date: 	01/30/2009
Template:		actFreightEst.cfm 
--->

<cfset objCust = createObject("component", "admin.assets.cfcs.Cust")>

<cfset stFormCopy = duplicate(FORM)>

<cfset Result = objCust.setFreightEstimator(stFormCopy)>

<cfif Result IS "TurnedOn">
	<cfset objCust.setMessage("The Freight Estimator was successfully turned ON for all of your resellers.")>
<cfelseif Result IS "TurnedOff">
	<cfset objCust.setMessage("The Freight Estimator was successfully turned OFF for all of your resellers.")>
<cfelseif Result IS "TurnedOnPick">
	<cfset objCust.setMessage("The Freight Estimator was successfully turned ON for the resellers you picked.")>
<cfelse>
	<cfset objCust.setMessage("No Action was taken; you must check one of the radio buttons before clicking Continue.")>
</cfif>

<cflocation url="index.cfm?task=admin_freightestimator_frm">