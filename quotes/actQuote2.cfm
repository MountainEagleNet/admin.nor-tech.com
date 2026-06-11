<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/28/20096
	Function: 		
	Template:		
	Task:			
--->

<cfparam name="FORM.TypeOfQuote" default="">
<cfparam name="FORM.Type" default="">

<!--- Choice not selected --->
<cfif FORM.TypeOfQuote IS "">
	<cflocation url="index.cfm?task=quotes_new2&Error=Blank&UserID=#urlEncodedFormat(FORM.UserID)#&CustomerID=#urlEncodedFormat(FORM.CustomerID)#&TypeOfQuote=#FORM.TypeOfQuote#&Type=#FORM.Type#">

<!--- System Type not selected --->
<cfelseif FORM.TypeOfQuote IS "Include Base System" AND FORM.Type IS "">
	<cflocation url="index.cfm?task=quotes_new2&Error=NoSystemType&UserID=#urlEncodedFormat(FORM.UserID)#&CustomerID=#urlEncodedFormat(FORM.CustomerID)#&TypeOfQuote=#FORM.TypeOfQuote#&Type=#FORM.Type#">

<!--- Misc Parts Only --->
<cfelseif FORM.TypeOfQuote IS "Misc Parts Only">
	<cflocation url="index.cfm?task=quotes_new3&UserID=#urlEncodedFormat(FORM.UserID)#&CustomerID=#urlEncodedFormat(FORM.CustomerID)#&ConfigSystemID=">

<!--- Include Base System --->
<cfelse>
	<cflocation url="index.cfm?task=quotes_new2A&UserID=#urlEncodedFormat(FORM.UserID)#&CustomerID=#urlEncodedFormat(FORM.CustomerID)#&Type=#FORM.Type#&RequestTimeout=6000">
</cfif>