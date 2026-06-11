<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/28/2006
	Function: 		This page prompts the user to enter an RMA number
	Template:		enterRMA.cfm
	Task:			serials_returns_enter
--->

<cfoutput>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">#URL.RMAAction#</td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<form name="RMANumberSearch" action="index.cfm?task=serials_returns_find" method="post">
<input type="hidden" name="RMAAction" value="#URL.RMAAction#">

	<tr>
		<td class="textmain" align="left">
			<strong>RMA Number:</strong>
			<input name="RMANumber" size="20" maxlength="50"
				<cfif isDefined("URL.RMANumber")>
					value="#URL.RMANumber#"
				</cfif>
			>
			<input type="submit" name="ProcessSearch" value="Go">
		</td>
	</tr>
</form>
<cfif isDefined("URL.Error")>
	<tr>
		<td class="textmain" align="left">
			<font color="FF0000">
				<cfif URL.Error IS "Blank">
					Please enter an RMA Number before clicking "Go".
				<cfelseif URL.Error IS "NotFound">
					RMA Number <cfif isDefined("URL.RMANumber")>'#URL.RMANumber#'</cfif> was not found.
				<cfelseif URL.Error IS "MultipleFound">
					Multiple matches were found for RMA Number <cfif isDefined("URL.RMANumber")>'#URL.RMANumber#'</cfif>.
				</cfif>
			</font>
		</td>
	</tr>
</cfif>

<tr><td class="textsmall">&nbsp;</td></tr>

</table>
</cfoutput>

<script language="JavaScript" type="text/JavaScript">
<!--
document.RMANumberSearch['RMANumber'].focus();document.RMANumberSearch['RMANumber'].select()
-->
</script>
