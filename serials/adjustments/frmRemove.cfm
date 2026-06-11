<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	07/17/2007
	Function: 		This page displays the comments form
	Template:		frmRemove.cfm
	Task:			serials_adjustments_list_remove_form
--->
	<cfset objICADEH = createObject("component", "admin.assets.cfcs.ICADEH")>

	<!--- Get a structure of the Adjustment header --->
	<cfset strHeader = objICADEH.getRecord(URL.ADJENSEQ)>

</cfsilent>

<script language="JavaScript" type="text/JavaScript">
<!--
	function confirmPost() {
		var msg = "Are you sure you want to Remove this adjustment from the list?";
		if(confirm(msg)) { 
			disableAllButtons();
			document.detailform.WhichButton.value = "Continue";
		    window.document.detailform.submit();
		}
		else { return false; }
	}

	function confirmCancel() {
		disableAllButtons();
		document.detailform.WhichButton.value = "Back";
		window.document.detailform.submit();
	}

	function disableAllButtons() {
		document.detailform.ButtonClicked[0].disabled = true;
		document.detailform.ButtonClicked[1].disabled = true;
		return true;
	}


//-->
</script>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<td valign="top" class="textmain" style="font-size:16px"><font color="FF0000"><b>Remove Adjustment</b></font></td>
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
	You may enter a comment below to indicate why you are removing this adjustment.<br> 
	Click "Continue" to remove the adjustment; click "Back" to go back to the adjustment list without removing.
	</td>
</tr>


<tr>
<td valign="top" class="textmain">
	<form action="index.cfm?task=serials_adjustments_list_remove" method="Post" name="detailform">
	<input type="hidden" name="ADJENSEQ" value="#URL.ADJENSEQ#">
	<input type="hidden" name="WhichButton" value="">
	<cfset TabValue = 1>
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td width="15%" class="textmain" align="left" valign="middle">
			<strong>Comment:</strong>
		</td>
		<td class="textmain" align="left">
			<textarea name="RemoveComment" wrap="virtual" cols="60" rows="3" tabindex="#TabValue#" class="textmain"></textarea>
			<cfset TabValue = TabValue + 1>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	</table>
	
	<table cellpadding="4" cellspacing="0" border="0" width="70%" align="center">
	<tr>
		<!--- "BACK" BUTTON --->
		<td align="left">
			<input type="submit" name="ButtonClicked" value="&laquo;- Back&nbsp;" onclick="return confirmCancel()">
		</td>
		<!--- "CONTINUE" BUTTON --->
		<td align="right">
			<input type="submit" name="ButtonClicked" value="&nbsp;Continue -&raquo;" onclick="return confirmPost()" tabindex="#TabValue#">
		</td>
	</tr>
	</table>
	</form>
</td>
</tr>

</table>
</cfoutput>

<script language="JavaScript" type="text/JavaScript">
<!--
document.detailform['RemoveComment'].focus();document.detailform['RemoveComment'].select()
-->
</script>