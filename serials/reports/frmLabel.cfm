<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/12/2006
	Function: 		This page prompts the user to enter a serial number
	Template:		frmLabel.cfm
	Task:			serials_reports_label_enter
--->
	<cfset objSerials = createObject("component", "admin.assets.cfcs.Serials")>

	<cfset ExecuteSearch = 0>
	<cfset Error = 0>
	
	<cfif isDefined("FORM.SerialNumber")>
		<cfset ExecuteSearch = 1>
		<cfif trim(FORM.SerialNumber) IS "">
			<cfset Error = 1>
		<cfelse>
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "SerialNumber", FORM.SerialNumber, True)>
			<cfset qrySerials = objSerials.searchRecords(SearchRecord, "query", "SerialNumber", 0)>
			<cfif qrySerials.RecordCount EQ 0>
				<cfset Error = 1>
			<cfelseif qrySerials.RecordCount EQ 1>
				<cflocation url="index.cfm?task=serials_reports_label_disp&SerialID=#urlEncodedFormat(qrySerials.SerialID)#">
			</cfif>
		</cfif>
	</cfif>

</cfsilent>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<form name="SerialNumberSearch" action="index.cfm?task=serials_reports_label_enter" method="post">
	<tr>
		<td class="textmain" align="left">
			<strong>Serial Number:</strong>
			<input name="SerialNumber" size="20" maxlength="50"
				<cfif isDefined("FORM.SerialNumber")>
					value="#FORM.SerialNumber#"
				</cfif>
			>
			<input type="submit" name="ProcessSearch" value="Search">
		</td>
	</tr>
</form>
<cfif Error>
	<tr>
		<td class="textmain" align="left">
			<font color="FF0000">
				<cfif trim(FORM.SerialNumber) IS "">
					Please enter a Serial Number (partial or full) before clicking "Search".
				<cfelseif qrySerials.RecordCount EQ 0>
					Serial Number <cfif isDefined("FORM.SerialNumber")>'#FORM.SerialNumber#'</cfif> was not found.
				</cfif>
			</font>
		</td>
	</tr>
</cfif>

<tr><td class="textsmall">&nbsp;</td></tr>
</cfoutput>


<cfif ExecuteSearch AND isDefined("qrySerials") AND NOT Error>

	<tr>
	<td valign="top" class="textmain">
		<table cellpadding="0" cellspacing="0" width="100%" border="0">
		
		<!--- LIST HEADINGS --->
		<tr>
			<td height="18" bgcolor="006633" class="productTitle" width="35%"><font color="FFFFFF">Serial Number</font></td>
			<td height="18" bgcolor="006633" class="productTitle" width="30%"><font color="FFFFFF">Item Number</font></td>
			<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Description</font></td>
		</tr>
	
		<!--- LIST DATA --->	
		<cfif qrySerials.RecordCount EQ 0>
			<tr>
				<td align="center" colspan="2" class="productTitle"><font color="FF0000">No matching records were found.</font></td>
			</tr>
		</cfif>
		
		<cfoutput query="qrySerials" startrow="1" maxrows="20">
			<tr<cfif qrySerials.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
	
				<td class="textsmall" align="left" valign="top">
					<a href="index.cfm?task=serials_reports_label_disp&SerialID=#urlEncodedFormat(qrySerials.SerialID)#">
						#qrySerials.SerialNumber#
					</a>
				</td>
				<td class="textsmall" align="left" valign="top">
					#qrySerials.ITEMNO#
				</td>
				<td class="textsmall" align="left" valign="top">
					#objSerials.getItemDescription(qrySerials.ITEMNO)#
				</td>
			</tr>
		</cfoutput>
	
		</table>
	</td>
	</tr>

</cfif>


</table>

<script language="JavaScript" type="text/JavaScript">
<!--
document.SerialNumberSearch['SerialNumber'].focus();document.SerialNumberSearch['SerialNumber'].select()
-->
</script>