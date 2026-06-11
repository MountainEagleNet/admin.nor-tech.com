<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/09/2006
	Function: 		This page displays a form for correcting the chosen serial number
	Template:		frmConfirm.cfm
	Task:			serials_corrections_serials_confirm
--->
	<cfset objSerials = createObject("component", "admin.assets.cfcs.Serials")>
	<cfset objICITEM = createObject("component", "admin.assets.cfcs.ICITEM")>

	<!--- QUIT was clicked --->
	<cfif isDefined("FORM.ButtonClicked") AND findNoCase("Quit", FORM.ButtonClicked) NEQ 0>
		<cflocation url="index.cfm?task=serials_corrections_serials_list&ITEMNO=#urlEncodedFormat(FORM.ITEMNO)#">
	</cfif>

	<cfset stErrors = structNew()>
	<cfset stFormCopy = duplicate(FORM)>
	<cfif trim(FORM.NewSerialNumber) IS "">
		<cfset structInsert(stErrors, "NewSerialNumber", "Please enter a serial number", True)>
	<cfelseif trim(FORM.NewSerialNumber) IS trim(FORM.SerialNumber)>
		<cfset structInsert(stErrors, "NewSerialNumber", "The number you entered is identical to the one currently on file.  Please enter a new serial number", True)>
	</cfif>
	<cfif NOT structIsEmpty(stErrors)>
		<cfset objSerials.setDataRecord(stFormCopy)>
		<cfset objSerials.setErrorRecord(stErrors)>
		<cflocation url="index.cfm?task=serials_corrections_serials_edit&Validation=1">
	</cfif>

	<cfset stRecord = duplicate(FORM)>
	<cfset strHeader = objICITEM.getRecord(stRecord.ITEMNO)>
</cfsilent>

<script language="javascript">
	function disableButton() {
	  document.detailform.ButtonClicked[1].disabled = true;
	  document.getElementById("Posting").style.visibility = "visible";					
	  window.document.detailform.submit();
	}
	
</script>

<cfoutput>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objSerials.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<td valign="top" class="textmain" style="font-size:16px"><font color="0033CC"><b>Confirmation</b></font></td>
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
	<form action="index.cfm?task=serials_corrections_serials_save" method="Post" name="detailform">
	<input type="hidden" name="SerialID" value="#stRecord.SerialID#">
	<input type="hidden" name="NewSerialNumber" value="#stRecord.NewSerialNumber#">
	<input type="hidden" name="SerialNumber" value="#stRecord.SerialNumber#">
	<input type="hidden" name="ITEMNO" value="#stRecord.ITEMNO#">

	<tr>
		<td valign="top" class="textmain" width="35%"><b>Old Serial Number:</b></td>
		<td valign="top" class="textmain">#stRecord.SerialNumber#</td>
	</tr>

	<tr>
		<td valign="middle" class="textmain"><b>New Serial Number:</b></td>
		<td valign="top" class="textmain">#stRecord.NewSerialNumber#</td>
	</tr>

	<tr><td>&nbsp;</td></tr>
	<tr>
		<td class="textmain" colspan="2">
			You are about to replace the old serial number (#stRecord.SerialNumber#) with the new one (#stRecord.NewSerialNumber#).&nbsp;&nbsp;&nbsp;&nbsp;Are you sure you want to continue?
		</td>
	</tr>

	<tr>
	<td valign="top" colspan="2" align="center">
		<table cellpadding="4" cellspacing="0" border="0" width="80%">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<!--- "QUIT" BUTTON --->
				<td width="50%">
					<input type="submit" name="ButtonClicked" value="Quit">
				</td>
				<!--- "CONTINUE" BUTTON --->
				<td>
					<input type="submit" name="ButtonClicked" value="&nbsp;Continue -&raquo;" onclick="return disableButton()">
				</td>
			</tr>
			<tr id="Posting" style="visibility:hidden;">
				<td valign="top" colspan="2" align="center" class="textmain">
					<font color="FF0000">Posting Serial Number - Please Wait</font>
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