<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/05/2006
	Function: 		This page displays a list of Transfers awaiting serial number input
	Template:		lstTransfers.cfm
	Task:			serials_transfers_list
--->
	<cfset objICTREH = createObject("component", "admin.assets.cfcs.ICTREH")>

	<cfparam name="URL.SortColumn" type="string" default="DOCNUM">
	<cfparam name="URL.SortOrder" type="string" default="Asc">

	<!--- set the new sort order for display --->
	<cfif URL.SortOrder IS "Desc">
		<cfset Variables.NewSortOrder = "Asc">
	<cfelse>
		<cfset Variables.NewSortOrder = "Desc">
	</cfif>

	<cfif trim(URL.SortColumn) IS  "TRANSDATE">		
		<cfset Variables.OrderByList = "TRANSDATE " & URL.SortOrder & ", DOCNUM " & URL.SortOrder>
	<cfelse>
		<cfset Variables.OrderByList = URL.SortColumn & " " & URL.SortOrder>
	</cfif>
	
	<cfset qryTransfers = objICTREH.listTransfers(Variables.OrderByList)>

</cfsilent>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">Transfers List</td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<form name="TransferNumberSearch" action="index.cfm?task=serials_transfers_find" method="post">
	<tr>
		<td class="textmain" align="left">
			<strong>Transfer Number:</strong>
			<input name="TransferNumber" size="20" maxlength="50"
				<cfif isDefined("URL.TransferNumber")>
					value="#URL.TransferNumber#"
				</cfif>
			>
			<input type="submit" name="ProcessSearch" value="Go">
		</td>
	</tr>
</form>
<cfif isDefined("URL.Error")>
	<tr>
		<td class="textmain" align="left">
			<font color="FF0000">
				<cfif URL.Error IS "Blank">
					Please enter a Transfer Number before clicking "Go".
				<cfelseif URL.Error IS "NotFound">
					Transfer Number <cfif isDefined("URL.TransferNumber")>'#URL.TransferNumber#'</cfif> was not found.
				<cfelseif URL.Error IS "MultipleFound">
					Multiple matches were found for Transfer Number <cfif isDefined("URL.TransferNumber")>'#URL.TransferNumber#'</cfif>.
				</cfif>
			</font>
		</td>
	</tr>
</cfif>

<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="0" cellspacing="0" width="100%" border="0">
	
	<!--- LIST HEADINGS --->
	<tr>
		<td height="18" bgcolor="006633" width="50%">
			<a class="menuwh" href="index.cfm?task=serials_transfers_list&SortColumn=DOCNUM&SortOrder=#NewSortOrder#">
				Transfer Number
			</a>
		</td>
		<td height="18" bgcolor="006633">
			<a class="menuwh" href="index.cfm?task=serials_transfers_list&SortColumn=TRANSDATE&SortOrder=#NewSortOrder#">
				Date of Transfer
			</a>
		</td>
	</tr>

	<!--- LIST DATA --->	
	<cfif qryTransfers.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="2" class="productTitle"><font color="FF0000">There are currently no Transfers awaiting serial number input.</font></td>
		</tr>
	</cfif>
	
	<cfloop query="qryTransfers">
		<tr<cfif qryTransfers.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>

			<td class="textsmall" align="left">
				<a href="index.cfm?task=serials_transfers_items_list&TRANFENSEQ=#urlEncodedFormat(qryTransfers.TRANFENSEQ)#">
					#qryTransfers.DOCNUM#
				</a>
			</td>
			<td class="textsmall" align="left">
				#objICTREH.formatDate(qryTransfers.TRANSDATE)#
			</td>
		</tr>
	</cfloop>

	</table>
</td>
</tr>


</table>
</cfoutput>

<script language="JavaScript" type="text/JavaScript">
<!--
document.TransferNumberSearch['TransferNumber'].focus();document.TransferNumberSearch['TransferNumber'].select()
-->
</script>
