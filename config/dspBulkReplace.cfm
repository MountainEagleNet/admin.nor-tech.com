<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	10/21/2008
	Function: 		Replace Component - Response Page
	Template:		dspBulkReplace.cfm
	Task:			config_setup_bulkreplace_dsp
--->
	
<cfset objConfigComponents = createObject("component", "admin.assets.cfcs.config.ConfigComponents")>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">
		Replace System Component
	</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objConfigComponents.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr><!--- Instructions --->
	<td valign="top" class="textmain">
		Replace another component by <a href="index.cfm?task=config_setup_bulkreplace_frm">clicking here</a>.
	</td>
</tr>
<tr><td>&nbsp;</td></tr>

</table>
</cfoutput>