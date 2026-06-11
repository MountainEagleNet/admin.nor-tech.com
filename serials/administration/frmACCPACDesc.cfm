<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	07/16/2009
	Function: 		Update component descriptions from ACCPAC
	Template:		frmACCPACDesc.cfm
	Task:			serials_admin_ACCPACDescriptions_form
--->

<script language="javascript">
	function continueButton() {
		document.detailform.ButtonClicked.disabled = true;
		window.document.detailform.submit();
	}
</script>

<cfoutput>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr>
	<td class="textmain" style="font-size:16px; color:0033CC" height="18">
		<strong>Update component descriptions from ACCPAC</strong>
	<td>
</tr>

<tr><!--- Instructions --->
	<td valign="top" class="textmain">
    	This function updates all component descriptions in the configurator by "pulling in" the descriptions from ACCPAC.  You would typically run this after making adjustments to descriptions in ACCPAC to have those changes reflected in the configurator.<br><br>

		<font color="FF0000">Please Note:</font> Click the "Continue" button only once.
	</td>
</tr>
<tr><td>&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	<form action="index.cfm?task=serials_admin_ACCPACDescriptions_act&RequestTimeout=6000" method="Post" name="detailform">
	
	<tr>
	<td valign="top" colspan="2" align="center">
		<table cellpadding="4" cellspacing="0" border="0" width="80%">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<!--- "CONTINUE" BUTTON --->
			<td align="right">
				<input type="submit" name="ButtonClicked" value="&nbsp;Continue -&raquo;" onclick="return continueButton()">
			</td>
		</tr>
		</table>
	</td>
	</tr>

	</form>
	</table>
</td>
</tr>

</table>
</cfoutput>