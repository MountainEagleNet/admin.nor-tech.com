<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/28/2006
	Function: 		This page displays two links for selecting the return action: Authorization or Receiving
	Template:		selectAction.cfm
	Task:			serials_returns_select
--->

<cfoutput>
<table width="500" border="0" align="center" cellpadding="3" cellspacing="1">

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>


<tr>
	<td valign="top" class="textmain">
		<a href="index.cfm?task=serials_returns_enter&RMAAction=Authorization">
			Returns/RMAs – Authorization
		</a>
	</td>
</tr>

<tr>
	<td valign="top" class="textmain">
		<a href="index.cfm?task=serials_returns_enter&RMAAction=Receiving">
			Returns/RMAs – Receiving
		</a>
	</td>
</tr>

</table>
</cfoutput>