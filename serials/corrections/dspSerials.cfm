<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/09/2006
	Function: 		Display page for correcting the chosen serial number
	Template:		dspSerials.cfm
	Task:			serials_corrections_serials_view
--->
	<cfset objSerials = createObject("component", "admin.assets.cfcs.Serials")>
	<cfset objICITEM = createObject("component", "admin.assets.cfcs.ICITEM")>

	<cfset stRecord = objSerials.getRecord(URL.SerialID)>
	<cfset strHeader = objICITEM.getRecord(stRecord.ITEMNO)>
</cfsilent>

<script language="javascript">
	window.onload = init;
	function init() {
		var ref = document.getElementById("LinkBack");
		ref.focus();
	}
</script>

<cfoutput>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objSerials.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<!--- link back --->
<tr>
	<td class="textsmall" align="right">
		<a href="index.cfm?task=serials_corrections_item_list" id="LinkBack">
			<font style="background-color:FFFFCC; text-decoration:underline">Back to Corrections Item Entry Page</font>
		</a>
	</td>
</tr>

<tr>
<td valign="top" class="textmain">
	<!--- HEADER INFORMATION --->
	<cfinclude template="headerInfo.cfm">
</td>
</tr>
<tr><td>&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	<tr>
		<td valign="top" class="textmain" width="35%"><b>Old Serial Number:</b></td>
		<td valign="top" class="textmain">#URL.OldSerialNumber#</td>
	</tr>
	<tr>
		<td valign="middle" class="textmain"><b>New Serial Number:</b></td>
		<td valign="top" class="textmain">#stRecord.SerialNumber#</td>
	</tr>
	</table>
</td>
</tr>
</table>
</cfoutput>