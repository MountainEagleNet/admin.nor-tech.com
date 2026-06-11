<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/09/2007
	Template:		dspCreate.cfm
	Task:			serials_admin_create_view
--->
	<cfset objSerialsAdministration = createObject("component", "admin.assets.cfcs.SerialsAdministration")>
	<cfset stRecord = objSerialsAdministration.getDataRecord()>
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
	<td valign="top" class="textmain"><font color="FF0000">#objSerialsAdministration.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<!--- link back --->
<tr>
	<td class="textsmall" align="right">
		<a href="index.cfm?task=serials_admin_create_enter" id="LinkBack">
			<font style="background-color:FFFFCC; text-decoration:underline">Back to Main Page</font>
		</a>
	</td>
</tr>


<tr>
<td valign="top" class="textmain">

	<table cellpadding="1" cellspacing="0" width="100%" border="0">
		<tr>
			<td width="30%" class="textmain" align="left"><b>Transaction Type:</b></td>
			<td class="textmain" align="left">Create Serial Numbers and Print Bar Code Labels</td>
		</tr>
		<tr>
			<td class="textmain" align="left"><b>Item Number:</b></td>
			<td class="textmain" align="left">#stRecord.ITEMNO#</td>
		</tr>
		<tr>
			<td class="textmain" align="left"><b>Item Description:</b></td>
			<td class="textmain" align="left">#objSerialsAdministration.getItemDescription(stRecord.ITEMNO)#</td>
		</tr>
		<tr>
			<td class="textmain" align="left"><b>Date/Time:</b></td>
			<td class="textmain" align="left">
				#dateFormat(now(), 'mm/dd/yyyy')#, #timeFormat(now(), 'h:mm tt')#
			</td>
		</tr>
		<tr>
			<td class="textmain" align="left"><b>Quantity:</b></td>
			<td class="textmain" align="left">#int(stRecord.QUANTITY)#</td>
		</tr>
	</table>

</td>
</tr>

<tr><td>&nbsp;</td></tr>
</table>
</cfoutput>