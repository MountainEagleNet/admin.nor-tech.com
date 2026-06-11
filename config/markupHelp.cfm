<!---
	Template: 	markupHelp.cfm
	Author: 	Ron Barth
	Created: 	12/05/2005
	Purpose: 	popup window that shows help for Markup Percentage fields
--->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
	<cfoutput>
	<title>Markup Percentage Help</title>
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
The markup percentage is the percentage above and beyond the wholesale cost that should be charged to your customer when they create a quote.  Three separate fields exist to enter individual markup percentages for notebooks, workstations, and servers.  These percentages must be entered as numbers.<br>
<br>

For Example:<br>
Entering "25" as the markup percentage for workstations indicates a 25% markup.  With this percentage, if your price to Nor-Tech is  $1,000 for a particular workstation, your customer will see $1,250 as their quote total for that same workstation.<br>
Entering "10.5" as the markup percentage indicates a "10 and a half percent" markup, and results in a cost of $1105 to your customer.
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