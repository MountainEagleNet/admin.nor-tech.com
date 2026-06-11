<cfsilent>
	<!---
	Coded By: Alternative Systems, Inc - Nicholas Tunney
	Create Date: 8/16/2005
	Edit Date: 
	Function: This page runs the task to get new accounts from accpac, and import them into the www SQL database
	actCustomerImport.cfm
	--->
</cfsilent>

<cfinclude template="/scheduler/cust_export.cfm">

<!--- let them know what happened --->
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<!--- spacer --->
<tr>
	<td class="textsmall">&nbsp;</td>
</tr>
<tr>
	<td class="textmain" align="left">
		<cfoutput>
			#qGetNewIDs.RecordCount# <cfif qGetNewIDs.RecordCount EQ 1>record was<cfelse>records were</cfif> imported from AccPac.  #VARIABLES.EmailsSent# <cfif VARIABLES.EmailsSent EQ 1>email was<cfelse>emails were</cfif> sent to valid email addresses.<br>
		</cfoutput>
	</td>
</tr>
</table>