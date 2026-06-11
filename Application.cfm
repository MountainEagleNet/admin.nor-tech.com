<cfsilent>
	<cfapplication name="NTAdmin" clientmanagement="No" sessionmanagement="Yes" setclientcookies="Yes" sessiontimeout="#createTimeSpan(0,4,0,0)#">
	

<!---	<cfset NorTechURL = "www.nor-tech.com">	--->	<!---RAB 4/24/13--->
	<cfset NorTechURL = "admin.nor-tech.com">

<!--- Rob Panico, 7/12/2012: --->
<!---
	<cfset NorTechURL = "173.11.49.211">
	<cfset NorTechSSL = 0>
	<cfset NorTechAdmin = "://#NorTechURL#/admin/index.cfm">
	<cfif NorTechSSL eq 0><cfset NorTechAdmin = "http" & NorTechAdmin>
	<cfelse><cfset NorTechAdmin = "https" & NorTechAdmin></cfif>
--->

	<!--- make sure user is logged in, or redirect to login.cfm --->

	<cfset VARIABLES.AdminDirPath = "c:\inetpub\htdocs\admin.nortech.com\">
	<cfset APPLICATION.AdminDirPath = VARIABLES.AdminDirPath>
	<cfset VARIABLES.PartnersDirPath = "c:\inetpub\htdocs\ntc.nortech.com\">



	<cfset VARIABLES.AdminLocation = "admin">
	<cfset APPLICATION.AdminLocation = "admin">

	<cfif CGI.CF_TEMPLATE_PATH NEQ "#VARIABLES.AdminDirPath#frmLogin.cfm" AND 
		  CGI.CF_TEMPLATE_PATH NEQ "#VARIABLES.AdminDirPath#actLogin.cfm" AND 
		  CGI.CF_TEMPLATE_PATH NEQ "#VARIABLES.AdminDirPath#PasswordChange.cfm" AND 
		  CGI.CF_TEMPLATE_PATH NEQ "#VARIABLES.AdminDirPath#PasswordChange_act.cfm" AND 
		  CGI.CF_TEMPLATE_PATH NEQ "#VARIABLES.AdminDirPath#data.cfm" AND
		  NOT IsDefined("Session.AdminAuth")>
		<cflocation url="frmLogin.cfm">
	</cfif>
	
	<!--- Configurator, location where the system images are stored --->	
	<cfset APPLICATION.SystemImagesLocation = "c:\inetpub\htdocs\ntc.nortech.com\media\photos\systems\">

	<!--- Serialization System: This is the date that we want the "serial number not found" warning to become active
		  in order fulfillment, returns to vendor, "decrease" adjustments, and transfers --->
	<cfset APPLICATION.WarningActivationDate = "02/01/2007">

	<!--- Serialization System: This determines whether or not we're prompting for the password upon clicking
		  "Continue" after the warning page --->
	<cfset APPLICATION.PasswordActive = 1>
	<!--- This is the password --->
	<cfset APPLICATION.ContinuePassword1 = "passlah">		<!--- Larry Hanson's Password --->
	<cfset APPLICATION.ContinuePassword2 = "passrrb">		<!--- Rob Bauer's Password --->
	<cfset APPLICATION.ContinuePassword3 = "passamg">		<!--- Amanda Gardner's Password --->
	<cfset APPLICATION.ContinuePassword4 = "passmsf">		<!--- Mark Frank's Password --->
	<cfset APPLICATION.ContinuePassword5 = "passccb">		<!--- Chris Belcher's Password --->
	<cfset APPLICATION.ContinuePassword6 = "passjcm">		<!--- Julie Messbarger's Password --->

<!---=============================================================================================--->
<!--- LABEL MATRIX APPLICATION VARIABLES --->

	<!--- IP Address and Port of the Label Printing computer (with FTP server and running Label Matrix software) --->
<!---<cfset APPLICATION.FTPServerIP = "68.170.150.74">--->		<!--- IP of Ron's computer --->
	<cfset APPLICATION.FTPServerIP = "192.168.1.178"> 			<!--- IP of Nor-Tech's label printing computer --->
	<cfset APPLICATION.FTPServerPort = "21">
	
	<!--- User name and password for the account created in the FTP server on the Label Printing computer --->
	<cfset APPLICATION.FTPServerUserName = "label_manager">
	<cfset APPLICATION.FTPServerPassword = "cr5623ap">

	<!--- Directory on the Label Printing computer to receive the labels.txt file --->
	<cfset APPLICATION.LabelMatrixPollDirectory = "/C:/LabelMatrixText/">
	<!--- NOTE: As of 8/31/06, this is no longer used.  It is not needed if, in Serv-U, the above user (label_manager)
		  is set up to have access only to the C:/LabelMatrixText directory --->

<!---=============================================================================================--->
<!--- DATASOUCE NAMES --->

<!--- RAB 10/03/2012 --->
	
	<!--- "Our" Datasource Name --->	
		<cfset APPLICATION.DSN_WWW = "NorTechWWW">		
<!---	<cfset APPLICATION.DSN_WWW = "NorTechWWW_NEW">	--->

	<!--- ACCPAC Datasource Name --->	
		<cfset APPLICATION.DSN_AP = "NorTechAP">		
<!---	<cfset APPLICATION.DSN_AP = "NorTechAP_NEW">	--->


<!---=============================================================================================--->
<!--- APPLICATION-SPECIFIC SCANNER SETTINGS --->

	<!--- KEYCODE (numeric):
			The Ascii key code associated with the end character sent by the scanner 
			immediately following the serial number.  (i.e. [Enter] = 13; [Tab] = 9; [Space] = 32;
			[Backspace] = 8). Any key code is valid including the function keys. 
			o alpha numeric characters may be used. The default is 13 (enter).	--->
		<cfset APPLICATION.KEYCODE = 13>

	<!--- CANCELKEY (boolean):
			A flag to determine whether or not the end key should be allowed to act normally or be
			cancelled.  (i.e. If the end character is tab do we want an actual tab to be registered 
			by the browser, which might tab the cursor to the next box on the page). Default is true 
			(the end key is sent only for purposes of the javascript and is then cancelled).  --->
		<cfset APPLICATION.CANCELKEY = 1>
		
	<!--- FINALSOUND (string):
			The name of a sound clip file (.wav or .mp3) that is played when the final text input box 
			has been populated with a serial number.  --->
		<cfset APPLICATION.FINALSOUND = "Final.wav">
		
	<!--- DUPESOUND (string):
			The name of a sound clip file (.wav or .mp3) that is played when a duplicate serial number 
			is scanned.  --->
		<cfset APPLICATION.DUPESOUND = "Dupe.wav">

	<!--- MASKSOUND (string):
			The name of a sound clip file (.wav or .mp3) that is played when a serial number is 
			scanned which does not match the mask of previously scanned numbers.  --->
		<cfset APPLICATION.MASKSOUND = "Mask.wav">
	
<!---=============================================================================================--->
</cfsilent>
