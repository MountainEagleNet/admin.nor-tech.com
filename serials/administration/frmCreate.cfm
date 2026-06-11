<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/09/2007
	Function: 		This page displays prompts the user to enter Part Number and Quantity information 
	Template:		frmCreate.cfm
	Task:			serials_admin_create_enter
--->
	<cfset objSerialsAdministration = createObject("component", "admin.assets.cfcs.SerialsAdministration")>

	<cfif isDefined("URL.Validation")>
		<cfset stRecord = objSerialsAdministration.getDataRecord()>
		<cfset stErrors = objSerialsAdministration.getErrorRecord()>
	<cfelse>
		<cfset stRecord = structNew()>
		<cfset structInsert(stRecord, "ITEMNO", "", True)>
		<cfset structInsert(stRecord, "Quantity", "", True)>
		<cfset stErrors = structNew()>
	</cfif>

</cfsilent>

<!---
<cfdump var="#stRecord#">
--->
<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objSerialsAdministration.getMessage()#</font></td>
</tr>
<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr><!--- Instructions --->
	<td valign="top" class="textmain">
		Enter the item number and quantity of serial numbers that you want to create and print bar code labels for.<br>
	</td>
</tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	<form action="index.cfm?task=serials_admin_create_act" method="Post" name="detailform">

	<!--- ITEM NUMBER --->
	<cfif structKeyExists(stErrors, "ITEMNO")>
		<tr>
			<td>&nbsp;</td>
			<td valign="top" class="textmain"><font color="FF0000">&raquo; #stErrors.ITEMNO#</font></td>
		</tr>
	</cfif>
	<tr>
		<td valign="top" class="textmain" width="30%"><b>Item Number:</b></td>
		<td valign="top" class="textmain">
			<input name="ITEMNO" size="20" maxlength="50" value="#stRecord.ITEMNO#" <cfif structKeyExists(stErrors, "ITEMNO")>style="border:1px solid red;"</cfif>>
		</td>
	</tr>
	
	<!--- QUANTITY --->
	<cfif structKeyExists(stErrors, "Quantity")>
		<tr>
			<td>&nbsp;</td>
			<td valign="top" class="textmain"><font color="FF0000">&raquo; #stErrors.Quantity#</font></td>
		</tr>
	</cfif>
	<tr>
		<td valign="top" class="textmain"><b>Quantity:</b></td>
		<td valign="top" class="textmain">
			<input name="Quantity" size="20" maxlength="50" value="#stRecord.Quantity#" <cfif structKeyExists(stErrors, "Quantity")>style="border:1px solid red;"</cfif>>
		</td>
	</tr>

	<tr>
	<td valign="top" colspan="2" align="center">
		<table cellpadding="4" cellspacing="0" border="0" width="80%">
		<tr>
			<!--- "CONTINUE" BUTTON --->
			<td align="right">
				<input type="submit" name="ButtonClicked" value="&nbsp;Continue -&raquo;">
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

<cfif structKeyExists(stErrors, "ITEMNO")>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['ITEMNO'].focus(); document.detailform['ITEMNO'].select()
	-->
	</script>
<cfelseif structKeyExists(stErrors, "Quantity")>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['Quantity'].focus(); document.detailform['Quantity'].select()
	-->
	</script>
<cfelse>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['ITEMNO'].focus();document.detailform['ITEMNO'].select()
	-->
	</script>
</cfif>