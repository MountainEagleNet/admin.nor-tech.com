<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/15/2007
	Function: 		Dynamic Configurator: Email Quote Action
	Template:		actEmailQuote.cfm
	Task:			config_dyn_email_act
--->
<cfset objQuoteSystem = createObject("component", "admin.assets.cfcs.config.QuoteSystem")>

<cfset stFormCopy = duplicate(FORM)>

<cfparam name="stFormCopy.EmailAddressForQuote" default="">

<cfset stErrors = structNew()>

<!--- Validate the Email Address --->
<cfif trim(stFormCopy.EmailAddressForQuote) IS "" OR 
	  FindNoCase("@", stFormCopy.EmailAddressForQuote) EQ 0 OR
	  FindNoCase(".", stFormCopy.EmailAddressForQuote) EQ 0>
	<cfset structInsert(stErrors, "EmailAddressForQuote", "Please enter a valid email address", True)>
</cfif>

<!--- Validate the From Email Address --->
<cfif trim(stFormCopy.EmailAddressFrom) IS "" OR 
	  FindNoCase("@", stFormCopy.EmailAddressFrom) EQ 0 OR
	  FindNoCase(".", stFormCopy.EmailAddressFrom) EQ 0>
	<cfset structInsert(stErrors, "EmailAddressFrom", "Please enter a valid email address", True)>
</cfif>
	
<cfif NOT structIsEmpty(stErrors)>
	<cfset objQuoteSystem.setDataRecord(stFormCopy)>
	<cfset objQuoteSystem.setErrorRecord(stErrors)>
	<cflocation url="index.cfm?task=config_dyn_email_form&Validation=1">
</cfif> 

<!--- Save the title, if one was entered --->
<!---<cfif trim(stFormCopy.QuoteTitle) IS NOT "">--->
	<cfset strQuoteSystem = objQuoteSystem.getRecord(stFormCopy.QuoteSystemID)>
	<cfset structInsert(strQuoteSystem, "QuoteTitle", stFormCopy.QuoteTitle, True)>
	<cfset objQuoteSystem.saveRecord(strQuoteSystem)>
<!---</cfif>--->

<!--- Send the Email --->
<cfset EmailText = objQuoteSystem.emailFormattedQuote(stFormCopy.QuoteSystemID, 1)>		<!--- 1=IncludeNorTechLogo --->

<cfmail from=	"#stFormCopy.EmailAddressFrom#"		
		to=		"#stFormCopy.EmailAddressForQuote#"
		subject="Nor-Tech Quote, #dateFormat(now(), 'mmmm d, yyyy')#" 
		
		
		type="html">
<html>
<head>
	<style type="text/css">
		BODY	{font-family: Verdana, Arial, Helvetica, sans-serif;}
	</style>
</head>
<body>
#EmailText#
</body>
</html>	
</cfmail>

<!---
<cfset objQuoteSystem.emailQuote(stFormCopy.QuoteSystemID, stFormCopy.EmailAddressForQuote)>
--->

<cflocation url="index.cfm?task=config_dyn_receipt&QuoteSystemID=#urlEncodedFormat(stFormCopy.QuoteSystemID)#&QuoteSubmitted=0&QuoteEmailed=1&EmailAddressForQuote=#urlEncodedFormat(stFormCopy.EmailAddressForQuote)#">