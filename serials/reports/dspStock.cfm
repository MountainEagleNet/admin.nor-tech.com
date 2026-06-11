<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/22/2007
	Function: 		Out of Stock Report - Display Page
	Template:		dspStock.cfm
	Task:			serials_reports_dspStock
--->
	<cfset objBackOrder = createObject("component", "admin.assets.cfcs.BackOrder")>
</cfsilent>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objBackOrder.getMessage()#</font></td>
</tr>
<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr><!--- Instructions --->
	<td valign="top" class="textmain">
		<cfif URL.UpdateOnly>
			The Out of Stock Report ran successfully and updated the information in the database.&nbsp;&nbsp;
			The report was <em><strong>not</strong></em> sent by email.
		<cfelse>
			The Out of Stock Report ran successfully, and was sent by email to the appropriate recipients.
		</cfif>
	</td>
</tr>
<tr><td>&nbsp;</td></tr>

</table>
</cfoutput>