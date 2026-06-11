<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/08/2007
	Function: 		Consecutive Order 3 Function, Serial Number Action Page
	Template:		actCons3Serials.cfm
	Task:			serials_shipments_consec3_serials_act
--->
<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>

<cfset stFormCopy = duplicate(FORM)>

<cfset stErrors = structNew()>
<cfset objSerialsShipments.setDataRecord(stFormCopy)>
<cfset objSerialsShipments.setErrorRecord(stErrors)>
<cflocation url="index.cfm?task=serials_shipments_serials_edit&ConsecutiveOrder3=1">