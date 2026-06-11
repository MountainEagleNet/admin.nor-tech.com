<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/07/2008
	Function: 		Delete a count
	Template:		delCount.cfm
	Task:			serials_counts_delete
--->
<cfset objCounts = createObject("component", "admin.assets.cfcs.Counts")>

<cfset objCounts.deleteCount(URL.CountsID)>

<cfset objCounts.setMessage("The record has been successfully deleted.")>

<cflocation url="index.cfm?task=serials_counts_enter">