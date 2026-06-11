<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/03/2006
	Function: 		This page displays a list of Adjustments awaiting serial number input
	Template:		lstAdjustments.cfm
	Task:			serials_adjustments_list
--->
	<cfset objICADEH = createObject("component", "admin.assets.cfcs.ICADEH")>
	<cfset objSerialsAdjustments = createObject("component", "admin.assets.cfcs.SerialsAdjustments")>

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
	
	<cfset qryAdjustments = objICADEH.listAdjustments(Variables.OrderByList)>

</cfsilent>

<!---
<script language="javascript">
	function confirmRemove() {
		var msg = "Are you sure you want to Remove this adjustment from the list?";
		if(confirm(msg)) { return true; }
		else { return false; }
	}
</script>
--->

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">Adjustments List</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objSerialsAdjustments.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<form name="AdjustmentNumberSearch" action="index.cfm?task=serials_adjustments_find" method="post">
	<tr>
		<td class="textmain" align="left">
			<strong>Adjustment Number:</strong>
			<input name="AdjustmentNumber" size="20" maxlength="50"
				<cfif isDefined("URL.AdjustmentNumber")>
					value="#URL.AdjustmentNumber#"
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
					Please enter an Adjustment Number before clicking "Go".
				<cfelseif URL.Error IS "NotFound">
					Adjustment Number <cfif isDefined("URL.AdjustmentNumber")>'#URL.AdjustmentNumber#'</cfif> was not found.
				<cfelseif URL.Error IS "MultipleFound">
					Multiple matches were found for Adjustment Number <cfif isDefined("URL.AdjustmentNumber")>'#URL.AdjustmentNumber#'</cfif>.
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
			<a class="menuwh" href="index.cfm?task=serials_adjustments_list&SortColumn=DOCNUM&SortOrder=#NewSortOrder#">
				Adjustment Number
			</a>
		</td>
		<td height="18" bgcolor="006633" colspan="2">
			<a class="menuwh" href="index.cfm?task=serials_adjustments_list&SortColumn=TRANSDATE&SortOrder=#NewSortOrder#">
				Date of Adjustment
			</a>
		</td>
	</tr>

	<!--- LIST DATA --->	
	<cfif qryAdjustments.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="3" class="productTitle"><font color="FF0000">There are currently no Adjustments awaiting serial number input.</font></td>
		</tr>
	</cfif>
	
	<cfloop query="qryAdjustments">
		<tr<cfif qryAdjustments.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>

			<td class="textsmall" align="left">
				<a href="index.cfm?task=serials_adjustments_items_list&ADJENSEQ=#urlEncodedFormat(qryAdjustments.ADJENSEQ)#">
					#qryAdjustments.DOCNUM#
				</a>
			</td>
			<td class="textsmall" align="left">
				#objICADEH.formatDate(qryAdjustments.TRANSDATE)#
			</td>
			<td class="textsmall" align="right">
<!---			<a href="index.cfm?task=serials_adjustments_list_remove&ADJENSEQ=#urlEncodedFormat(qryAdjustments.ADJENSEQ)#" onClick="return confirmRemove()">	--->
				<a href="index.cfm?task=serials_adjustments_list_remove_form&ADJENSEQ=#urlEncodedFormat(qryAdjustments.ADJENSEQ)#">
					[remove]
				</a>
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
document.AdjustmentNumberSearch['AdjustmentNumber'].focus();document.AdjustmentNumberSearch['AdjustmentNumber'].select()
-->
</script>
