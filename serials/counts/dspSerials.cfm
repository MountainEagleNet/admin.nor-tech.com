<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/08/2006
	Function: 		This page displays serial numbers in view-only format
	Template:		dspSerials.cfm
	Task:			serials_counts_serials_view
--->
	<cfset objCounts = createObject("component", "admin.assets.cfcs.Counts")>
	<cfset objSerialsCounts = createObject("component", "admin.assets.cfcs.SerialsCounts")>

	<!--- Get a structure of the Count header --->
	<cfset stRecord = objCounts.getRecord(URL.CountsID)>
	<!--- Get a query of the serial numbers entered --->
	<cfset qrySerialsCounts = objSerialsCounts.listRecordsForParent("CountsID", URL.CountsID)>
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
	<td valign="top" class="textmain"><font color="FF0000">#objSerialsCounts.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<!--- link back --->
<tr>
	<td class="textsmall" align="right">
		<a href="index.cfm?task=serials_counts_enter" id="LinkBack">
			<font style="background-color:FFFFCC; text-decoration:underline">Back to Counts Entry Page</font>
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
		<td valign="top" class="textmain" colspan="2"><b>Serial Numbers:</b></td>
	</tr>
	
	<cfloop query="qrySerialsCounts">
		<tr>
			<td valign="top" class="textmain" width="20%">&nbsp;</td>
			<td valign="top" class="textmain">#qrySerialsCounts.SerialNumber#</td>
		</tr>
	</cfloop>
	</table>
</td>
</tr>
<tr><td>&nbsp;</td></tr>
</table>
</cfoutput>