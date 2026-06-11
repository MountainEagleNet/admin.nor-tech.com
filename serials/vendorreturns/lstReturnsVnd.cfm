<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/03/2006
	Function: 		This page displays a list of Vendor Returns awaiting serial number input
	Template:		lstReturnsVnd.cfm
	Task:			serials_returnsvendor_list
--->
	<cfset objPORETH1 = createObject("component", "admin.assets.cfcs.PORETH1")>

	<cfparam name="URL.SortColumn" type="string" default="RETNUMBER">
	<cfparam name="URL.SortOrder" type="string" default="Asc">

	<!--- set the new sort order for display --->
	<cfif URL.SortOrder IS "Desc">
		<cfset Variables.NewSortOrder = "Asc">
	<cfelse>
		<cfset Variables.NewSortOrder = "Desc">
	</cfif>

	<cfif trim(URL.SortColumn) IS  "VDNAME">		
		<cfset Variables.OrderByList = "VDNAME " & URL.SortOrder & ", RETNUMBER " & URL.SortOrder>
	<cfelseif trim(URL.SortColumn) IS  "DATE">		
		<cfset Variables.OrderByList = "[DATE] " & URL.SortOrder & ", RETNUMBER " & URL.SortOrder>
	<cfelse>
		<cfset Variables.OrderByList = URL.SortColumn & " " & URL.SortOrder>
	</cfif>
	
	<cfset qryVendorReturns = objPORETH1.listVendorReturns(Variables.OrderByList)>

</cfsilent>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">Returns to Vendor List</td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<form name="VendorReturnNumberSearch" action="index.cfm?task=serials_returnsvendor_find" method="post">
	<tr>
		<td class="textmain" align="left">
			<strong>Return to Vendor Number:</strong>
			<input name="VendorReturnNumber" size="20" maxlength="50"
				<cfif isDefined("URL.VendorReturnNumber")>
					value="#URL.VendorReturnNumber#"
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
					Please enter a Return to Vendor Number before clicking "Go".
				<cfelseif URL.Error IS "NotFound">
					Return to Vendor Number <cfif isDefined("URL.VendorReturnNumber")>'#URL.VendorReturnNumber#'</cfif> was not found.
				<cfelseif URL.Error IS "MultipleFound">
					Multiple matches were found for Return to Vendor Number <cfif isDefined("URL.VendorReturnNumber")>'#URL.VendorReturnNumber#'</cfif>.
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
		<td height="18" bgcolor="006633" width="25%">
			<a class="menuwh" href="index.cfm?task=serials_returnsvendor_list&SortColumn=RETNUMBER&SortOrder=#NewSortOrder#">
				Return Number
			</a>
		</td>
		<td height="18" bgcolor="006633" width="50%">
			<a class="menuwh" href="index.cfm?task=serials_returnsvendor_list&SortColumn=VDNAME&SortOrder=#NewSortOrder#">
				Vendor Name
			</a>
		</td>
		<td height="18" bgcolor="006633">
			<a class="menuwh" href="index.cfm?task=serials_returnsvendor_list&SortColumn=DATE&SortOrder=#NewSortOrder#">
				Date of Return
			</a>
		</td>
	</tr>

	<!--- LIST DATA --->	
	<cfif qryVendorReturns.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="3" class="productTitle"><font color="FF0000">There are currently no Returns to Vendor awaiting serial number input.</font></td>
		</tr>
	</cfif>
	
	<cfloop query="qryVendorReturns">
		<tr<cfif qryVendorReturns.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>

			<td class="textsmall" align="left">
				<a href="index.cfm?task=serials_returnsvendor_items_list&RETHSEQ=#urlEncodedFormat(qryVendorReturns.RETHSEQ)#">
					#qryVendorReturns.RETNUMBER#
				</a>
			</td>
			<td class="textsmall" align="left">#qryVendorReturns.VDNAME#</td>
			<td class="textsmall" align="left">
				#objPORETH1.formatDate(qryVendorReturns.DATE)#
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
document.VendorReturnNumberSearch['VendorReturnNumber'].focus();document.VendorReturnNumberSearch['VendorReturnNumber'].select()
-->
</script>
