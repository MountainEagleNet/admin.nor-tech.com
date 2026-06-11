<!---
	Template: 	markupHelpSystems.cfm
	Author: 	Ron Barth
	Created: 	06/13/2006
	Purpose: 	popup window that shows help for Markup Percentage and Fixed Price fields
--->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
	<cfoutput>
	<title>Markup Percentage and Fixed Price Help</title>
	<link href="/techstyle.css" rel="stylesheet" type="text/css">
	</cfoutput>
</head>
<!---<body class="helpText">--->
<body>

<cfoutput>
<table width="100%" cellspacing="0" cellpadding="2">
<form>
<tr>
	<td width="2%">&nbsp;<br></td>
	<td valign="top" width="88%">
		<table cellpadding="3" cellspacing="0" width="100%">
		<tr>
			<td class="textmain" valign="top">
The markup percentage is the percentage above and beyond the wholesale cost that should be charged to your customer when they create a quote.<br><br>

When a system is being built with the configurator, the price of the system is calculated as follows:  the price of each individual component is derived from the inventory table in ACCPAC; these prices are marked up by the applicable markup percentage (as described below); these marked-up prices are added together; the "System Base Price" (which is an amount you may define to add to the price of the system) is added to this total.<br><br>

The hierarchy for determining the applicable markup percentage is as follows:<br>
1. Component fixed price for a specific reseller<br>
2. Component markup percentage for a specific reseller<br>
3. Component fixed price (non-reseller specific)<br>
4. Component markup percentage (non-reseller specific)<br>
5. Component category markup percentage<br>
6. System type markup percentage<br>
<br><br>

Information entered in the "Markup %" fields must be entered as percentages.  For example, entering "25" as a markup percentage indicates a 25% markup.  Entering "10.50" indicates a "10 and a half percent" markup.<br><br>

Information entered in the "Fixed Price" fields must be entered as dollars.  For example, entering "50" indicates that the price of that particular component will be $50.00.  
			</td>
		</tr>
		</table>
	</td>
</tr>
<tr><td>&nbsp;</td></tr>
<tr>
	<td width="2%">&nbsp;<br></td>
	<td width="88%" align="left"><input type="button" class="formButton" value="Close Window" onclick="self.close()"></td>
</tr>
</table>
<br><br>
</form>
</cfoutput>

</body>
</html>