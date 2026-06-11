<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/28/20096
	Function: 		
	Template:		
	Task:			
--->

<!--- A "Configure" Button was Clicked --->
<cfif isDefined("URL.ConfigSystemID")>
	<cflocation url="index.cfm?task=quotes_new3&UserID=#urlEncodedFormat(URL.UserID)#&CustomerID=#urlEncodedFormat(URL.CustomerID)#&ConfigSystemID=#urlEncodedFormat(URL.ConfigSystemID)#&RequestTimeout=6000">

<!--- Select by Classification --->
<cfelse>
	<cflocation url="index.cfm?task=quotes_new2A&UserID=#urlEncodedFormat(FORM.UserID)#&CustomerID=#urlEncodedFormat(FORM.CustomerID)#&SystemType=#FORM.SystemType#&SortByPrice=#FORM.SortByPrice#&FilterClassificationID=#FORM.FilterClassificationID#&RequestTimeout=6000">

</cfif>