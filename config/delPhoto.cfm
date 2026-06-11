<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/09/2006
	Function: 		Delete a photo image
	Template:		delPhoto.cfm
	Task:			config_setup_photos_delete
--->
<cfset objConfigPhotos = createObject("component", "admin.assets.cfcs.config.ConfigPhotos")>
<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>

<!--- Make sure that the image is not assigned to any systems --->
<cfset qryConfigSystems = objConfigSystems.listRecordsForParent("ConfigPhotoID", URL.ConfigPhotoID)>
<cfif qryConfigSystems.RecordCount GT 0>
	<cfset objConfigPhotos.setMessage("This image cannot be deleted because it is already assigned to one or more systems.  It must be removed from all systems before it can be deleted.")>
	<cflocation url="index.cfm?task=config_setup_photos_edit&ConfigPhotoID=#urlEncodedFormat(URL.ConfigPhotoID)#">
</cfif>

<cfset objConfigPhotos.deleteRecord(URL.ConfigPhotoID)>

<cfset objConfigPhotos.setMessage("The record has been successfully deleted.")>

<cflocation url="index.cfm?task=config_setup_photos_list">