<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	07/13/2007
	Function: 		Orphaned serial numbers - Display Page
	Template:		dspOrphans.cfm
	Task:			serials_admin_orphans_display
--->
	<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>
</cfsilent>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objSerialsShipments.getMessage()#</font></td>
</tr>

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle" colspan="4">Orphaned Serial Number Deletion</td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr><!--- Instructions --->
	<td valign="top" class="textmain">
		The process was completed successfully.<br><br>
		
		A total of #URL.NumberDeleted# serial number<cfif URL.NumberDeleted GT 1>s were<cfelse> was</cfif> deleted from the database.<br><br>
		The serial number<cfif URL.NumberDeleted GT 1>s were<cfelse> was</cfif> added back to the master list of serial numbers, and <cfif URL.NumberDeleted GT 1>records were<cfelse>a record was</cfif> created in the serial number history table.
	</td>
</tr>
<tr><td>&nbsp;</td></tr>

</table>
</cfoutput>