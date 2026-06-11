<!--- SEND EMAIL TO RON --->


<cfmail from=	"ron_barth@altsystem.com" 
		to=		"ron_barth@altsystem.com" 
		cc=		"support_contact@altsystem.com"
		subject="NOR-TECH ADMIN SECTION ERROR">The Following Error has occurred in the Nor-Tech Admin section:

<cfif isDefined("cfcatch.type")>Error Type: #cfcatch.type#</cfif>

<cfif isDefined("cfcatch.errorcode")>Error Code: #cfcatch.errorcode#</cfif>

<cfif isDefined("cfcatch.message")>Error Message: #cfcatch.message#</cfif>

<cfif isDefined("cfcatch.detail")>Error Description: #cfcatch.detail#</cfif>

<cfif isDefined("cfcatch.StackTrace")>Stack Trace: #cfcatch.StackTrace#</cfif>

Date/Time: #dateFormat(now(), 'mm/dd/yyyy')# at #timeFormat(now(), 'h:mm tt')#

User: <cfif isDefined("SESSION.fname")>#SESSION.fname#</cfif> <cfif isDefined("SESSION.lname")>#SESSION.lname#</cfif>

<cfif isDefined("task")>Task Being Executed: #task#</cfif>

<cfif isDefined("Cgi.Http_User_Agent")>Browser being used: #Cgi.Http_User_Agent#</cfif>

<cfif isDefined("Cgi.Http_Referer")>Referring Document: #Cgi.Http_Referer#</cfif>

<cfif isDefined("Cgi.Remote_Addr")>Client IP Address: #Cgi.Remote_Addr#</cfif>

</cfmail>

<cfoutput>
<table width="100%" cellspacing="0" cellpadding="10">
<tr>
<td valign="top" align="center">
	<table cellpadding="2" cellspacing="0" width="100%" class="border">
	<tr class="subpagetitle">
		<th style="text-align:left;">An Error has Occurred</th>
	</tr>
	<tr>
		<td valign="top" class="textmain">
			<p>We're sorry. The application has encountered an unexpected error.<br>
			&nbsp;<br>
			Technical support has been notified of the error and will attempt to remedy it as soon as possible.<br><br>
			<cfif isDefined("Cgi.Http_Referer")>
				You may attempt to go back to the previous screen by clicking <a href="#CGI.HTTP_REFERER#">here</a>.<br>
			</cfif>

			If you have questions about this error please contact us at <a href="mailto:support_contact@altsystem.com">support_contact@altsystem.com</a>.
		</td>
	</tr>
	</table>
</td>
</tr>
</table>
</cfoutput>