<cfsilent>
	<!---
	Coded By: Alternative Systems, Inc - Ron Barth
	Create Date: 9/26/2005
	Edit Date: 
	Function: Sends Customer Email
	actSendCustEmail.cfm 
	--->
	<cfset objCust = createObject("component", "admin.assets.cfcs.Cust")>
	<cfset objSalesRep = createObject("component", "admin.assets.cfcs.SalesRep")>
	
	<cfset strCustomer = objCust.getRecordAsStruct(URLDecode(URL.uid))>

	<!--- Get the sales rep's email address for the reply-to attribute --->
	<cfset ReplyToAddress = objSalesRep.getReplyToAddress(strCustomer.CustomerID)>
	
	<!--- Send the Email --->
	<cfmail from=	"info@nor-tech.com"		
			to=		"#strCustomer.email#"
			replyto="#ReplyToAddress#"
			subject="Your Nor-Tech On Line Partners Account" 
			port="25">The Partners section of Nor-Tech.com has new, improved functionality we’re sure you’ll find useful!
			
Now you can view all your open orders, print invoices, search past invoices using a variety of search criteria and more!
	
Please login now using your email address as your username and the password shown below. 

Password: #strCustomer.passcode#


https://partners.nor-tech.com/
	
Enjoy the new, improved Partners section on Nor-Tech.com!
	
Regards,
	
Northern Computer Technologies
901 East Cliff Road
Burnsville, MN 55337
(952) 808-1000</cfmail>

	<!--- Save the Date/Time sent in the "login" table --->
	<cfset structInsert(strCustomer, "DateEmailSent", now(), True)>
	<cfset objCust.updateRecord(strCustomer)>
	
	<!--- send the user back to the appropriate admin account list --->
	<cflocation url="index.cfm?task=admin_custaccounts_list">
</cfsilent>


<!---
	<cfmail from=	"ronbarth@adelphia.net"		
			to=		"#strCustomer.email#"
			subject="Improved partners section at Nor-Tech.com"
			type=	"html">
	<html>
	<head>
		<style type="text/css">
			BODY	{font-family:Verdana, Arial, Helvetica, sans-serif; font-size:12px;}
		</style>
	</head>
	<body>
	The Partners section of Nor-Tech.com has new, improved functionality we’re sure you’ll find useful!<br><br>
	
	Now you can view all your open orders, print invoices, search past invoices using a variety of search criteria and more!<br><br>
	
	Please login now using your email address as your username and the generic password shown below. You may change your password once you login for the first time.<br><br>
	
	Password: #strCustomer.passcode#<br><br>
	
	Enjoy the new, improved Partners section on Nor-Tech.com!<br><br>
	
	Regards,<br><br>
	
	Northern Computer Technologies<br>
	901 East Cliff Road<br>
	Burnsville, MN 55337<br>
	(952) 808-1000<br>
	</body>
	</html>		
	</cfmail>
--->
