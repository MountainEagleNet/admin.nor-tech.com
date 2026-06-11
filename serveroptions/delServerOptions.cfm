<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/31/2007
	Function: 		Delete a part from the list
	Template:		delServerOptions.cfm
	Task:			server_options_delete
--->
<cfset objServerOptions = createObject("component", "admin.assets.cfcs.config.ServerOptions")>

<cfset objServerOptions.deleteRecord(URL.MiscPartID)>

<cfset objServerOptions.setMessage("The record has been successfully deleted.")>

<cflocation url="index.cfm?task=server_options_list">