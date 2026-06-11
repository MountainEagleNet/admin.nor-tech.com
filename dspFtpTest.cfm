<cfset variables.FTPSuccess = 0>
<cfset variables.LabelFileContent = "blah blah blah">
<cfset variables.RecordID = createUUID()>
<cfset variables.FileToFTP = "c:\inetpub\htdocs\admin\labels\labels_C7C3DDB2-C3D4-47F5-0A44543710BD6068.txt">

<cftry>
	<cfftp action="open" timeout="600" username="#APPLICATION.FTPServerUserName#" password="#APPLICATION.FTPServerPassword#" server="#APPLICATION.FTPServerIP#" port="#APPLICATION.FTPServerPort#" connection="objFtpConn" stopOnError = "Yes">
	<cfftp action="putFile" connection="objFtpConn" transfermode="auto" localfile="#variables.FileToFTP#" remotefile="labels.txt" failifexists="No">
	<cfftp action="close" connection="objFtpConn">
	<cfif isDefined("cfftp") eq 1 AND isDefined("cfftp.succeeded") eq 1 AND trim(cfftp.succeeded) IS "YES">
		<cfset variables.FTPSuccess = 1>
	</cfif>
	<cffile action="delete" file="#variables.FileToFTP#">
	<cfcatch type="any">
		<cfoutput>
		#cfcatch.message#<br/>
		#cfcatch.detail#<br/>
		</cfoutput>
		<cfabort>
	</cfcatch>
</cftry>

<cfoutput>Succeeded?: #variables.FTPSuccess#</cfoutput>