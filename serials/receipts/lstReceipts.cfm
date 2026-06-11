<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/19/2006
	Function: 		This page displays a list of Receipts awaiting serial number input
	Template:		lstReceipts.cfm
	Task:			serials_receipts_list
--->
	<cfset objPORCPH1 = createObject("component", "admin.assets.cfcs.PORCPH1")>
	<cfset objSerialsReceipts = createObject("component", "admin.assets.cfcs.SerialsReceipts")>

	<cfif isDefined("URL.ShowReceiptsList") AND URL.ShowReceiptsList EQ 1>
		<cfparam name="URL.SortColumn" type="string" default="RCPNUMBER">
		<cfparam name="URL.SortOrder" type="string" default="Asc">
	
		<!--- set the new sort order for display --->
		<cfif URL.SortOrder IS "Desc">
			<cfset Variables.NewSortOrder = "Asc">
		<cfelse>
			<cfset Variables.NewSortOrder = "Desc">
		</cfif>
	
		<cfif trim(URL.SortColumn) IS  "VDNAME">		
			<cfset Variables.OrderByList = "VDNAME " & URL.SortOrder & ", RCPNUMBER " & URL.SortOrder>
		<cfelseif trim(URL.SortColumn) IS  "DATE">		
			<cfset Variables.OrderByList = "[DATE] " & URL.SortOrder & ", RCPNUMBER " & URL.SortOrder>
		<cfelse>
			<cfset Variables.OrderByList = URL.SortColumn & " " & URL.SortOrder>
		</cfif>
		
		<cfset qryReceipts = objPORCPH1.listReceipts(Variables.OrderByList)>
	</cfif>

</cfsilent>

<script language="javascript">
	function confirmRemove() {
		var msg = "Are you sure you want to Remove this receipt from the list?";
		if(confirm(msg)) { return true; }
		else { return false; }
	}
</script>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<!---
<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">Receipts List</td>
</tr>
--->

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objSerialsReceipts.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<form name="ReceiptNumberSearch" action="index.cfm?task=serials_receipts_find" method="post">
	<tr>
		<td class="textmain" align="left">
			<strong>Receipt Number:</strong>
			<input name="ReceiptNumber" size="20" maxlength="50"
				<cfif isDefined("URL.ReceiptNumber")>
					value="#URL.ReceiptNumber#"
				</cfif>
			>
			<input type="submit" name="ProcessSearch" value="Go">
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<cfif NOT isDefined("URL.ShowReceiptsList") OR URL.ShowReceiptsList EQ 0>
				<a href="index.cfm?task=serials_receipts_list&ShowReceiptsList=1&RequestTimeout=6000">Show List of Receipts</a>
			<cfelse>
				<a href="index.cfm?task=serials_receipts_list&ShowReceiptsList=0&RequestTimeout=6000">Hide List of Receipts</a>
			</cfif>
		</td>
	</tr>
</form>
<cfif isDefined("URL.Error")>
	<tr>
		<td class="textmain" align="left">
			<font color="FF0000">
				<cfif URL.Error IS "Blank">
					Please enter a Receipt Number before clicking "Go".
				<cfelseif URL.Error IS "NotFound">
					Receipt Number <cfif isDefined("URL.ReceiptNumber")>'#URL.ReceiptNumber#'</cfif> was not found.
				<cfelseif URL.Error IS "MultipleFound">
					Multiple matches were found for Receipt Number <cfif isDefined("URL.ReceiptNumber")>'#URL.ReceiptNumber#'</cfif>.
				</cfif>
			</font>
		</td>
	</tr>
</cfif>

<tr><td class="textsmall">&nbsp;</td></tr>

<cfif isDefined("URL.ShowReceiptsList") AND URL.ShowReceiptsList EQ 1>
	<tr>
	<td valign="top" class="textmain">
		<table cellpadding="0" cellspacing="0" width="100%" border="0">
		
		<!--- LIST HEADINGS --->
		<tr>
			<td height="18" bgcolor="006633" width="25%">
				<a class="menuwh" href="index.cfm?task=serials_receipts_list&
										SortColumn=RCPNUMBER&SortOrder=#NewSortOrder#&
										ShowReceiptsList=1">
					Receipt Number
				</a>
			</td>
			<td height="18" bgcolor="006633" width="50%">
				<a class="menuwh" href="index.cfm?task=serials_receipts_list&
										SortColumn=VDNAME&SortOrder=#NewSortOrder#&
										ShowReceiptsList=1">
					Vendor Name
				</a>
			</td>
			<td height="18" bgcolor="006633" colspan="2">
				<a class="menuwh" href="index.cfm?task=serials_receipts_list&
										SortColumn=DATE&SortOrder=#NewSortOrder#&
										ShowReceiptsList=1">
					Date of Receipt
				</a>
			</td>
		</tr>
	
		<!--- LIST DATA --->	
		<cfif qryReceipts.RecordCount EQ 0>
			<tr>
				<td align="center" colspan="3" class="productTitle"><font color="FF0000">There are currently no Receipts awaiting serial number input.</font></td>
			</tr>
		</cfif>
		
		<cfloop query="qryReceipts">
			<tr<cfif qryReceipts.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
	
				<td class="textsmall" align="left">
					<a href="index.cfm?task=serials_receipts_items_list&RCPHSEQ=#urlEncodedFormat(qryReceipts.RCPHSEQ)#">
						#qryReceipts.RCPNUMBER#
					</a>
				</td>
				<td class="textsmall" align="left">#qryReceipts.VDNAME#</td>
				<td class="textsmall" align="left">
					#objPORCPH1.formatDate(qryReceipts.DATE)#
				</td>
				<td class="textsmall" align="right">
<!---			<a href="index.cfm?task=serials_receipts_list_remove&RCPHSEQ=#urlEncodedFormat(qryReceipts.RCPHSEQ)#" onClick="return confirmRemove()">	--->
					<a href="index.cfm?task=serials_receipts_list_remove_form&RCPHSEQ=#urlEncodedFormat(qryReceipts.RCPHSEQ)#">
						[remove]
					</a>
				</td>
			</tr>
		</cfloop>
	
		</table>
	</td>
	</tr>
</cfif>

</table>
</cfoutput>

<script language="JavaScript" type="text/JavaScript">
<!--
document.ReceiptNumberSearch['ReceiptNumber'].focus();document.ReceiptNumberSearch['ReceiptNumber'].select()
-->
</script>
