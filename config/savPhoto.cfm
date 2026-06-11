<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/09/2006
	Function: 		This page saves the system photo
	Template:		savPhoto.cfm
	Task:			config_setup_photos_save
--->
<cfset objConfigPhotos = createObject("component", "admin.assets.cfcs.config.ConfigPhotos")>
<cfset stFormCopy = duplicate(FORM)>

<cfparam name="stFormCopy.CaseImage" default="0">

<!--- DELETE --->
<cfif isDefined("stFormCopy.ButtonClicked") AND stFormCopy.ButtonClicked IS "Delete">
	<cflocation url="index.cfm?task=config_setup_photos_delete&ConfigPhotoID=#urlEncodedFormat(stFormCopy.ConfigPhotoID)#">

<!--- UPLOAD AND SAVE --->
<cfelse>

	<cfif trim(stFormCopy.UploadFile) IS NOT "">
		<!--- UPLOAD THE FILE --->
		<cftry>
			<cffile action="upload" 
					filefield="UploadFile" 
					destination="#APPLICATION.SystemImagesLocation#" 
					nameconflict="makeunique"
					mode="777">
			<cfcatch type="any">
				<cfrethrow>
			</cfcatch>
		</cftry>
		<cfset stFormCopy.PhotoImage = FILE.ServerFile>
	</cfif>

	<cfset objConfigPhotos.saveRecord(stFormCopy)>
	<cfset objConfigPhotos.setMessage("The system image was successfully saved.")>
	<cflocation url="index.cfm?task=config_setup_photos_list">

</cfif>	