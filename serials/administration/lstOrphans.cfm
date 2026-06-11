<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	07/13/2007
	Function: 		This page displays a list of orphaned serial numbers
	Template:		lstOrphans.cfm
	Task:			serials_admin_orphans_list
--->
<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>

<cfset stFormCopy = duplicate(FORM)>

<cfset stErrors = objSerialsShipments.validateOrphanDates(stFormCopy)>

<cfif NOT structIsEmpty(stErrors)>
	<cfset objSerialsShipments.setDataRecord(stFormCopy)>
	<cfset objSerialsShipments.setErrorRecord(stErrors)>
	<cflocation url="index.cfm?task=serials_admin_orphans_form&Validation=1">
</cfif>

<cfset qryOrphanedSerialNumbers = objSerialsShipments.listOrphans(stFormCopy.StartDate, stFormCopy.EndDate)>
<!---
<cfdump var="#qryOrphanedSerialNumbers#">
--->
<cfset stRecord = structNew()>
<cfset structInsert(stRecord, "qryOrphans", qryOrphanedSerialNumbers, True)> 
<cfset objSerialsShipments.setDataRecord(stRecord)>

<cfset qryOrphanedOrders = objSerialsShipments.listOrphanedOrders(qryOrphanedSerialNumbers)>

<script language="javascript">
	function confirmDelete() {
		var msg = "Are you sure you want to delete all of the serial numbers in this list?";
		if(confirm(msg)) { 
			document.detailform.Delete.disabled = true;
		    window.document.detailform.submit();
		}
		else { return false; }
	}
</script>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle" colspan="4">Orphaned Serial Numbers List</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain" colspan="4"><font color="FF0000">#objSerialsShipments.getMessage()#</font></td>
</tr>


<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<td valign="top" class="textmain" colspan="4">
		The following list displays orders that contain "Orphaned Serial Numbers".  These are serial numbers that were scanned into orders, but then the item was deleted from the order in ACCPAC.<br><br>
		<cfif qryOrphanedOrders.RecordCount EQ 0>
			There are currently no Orphaned Serial Numbers on file for the date range you entered.
		<cfelse>
			Clicking the "Delete" button will <font color="FF0000"><em><strong>delete</strong></em></font> all of these orphaned serial numbers from the database, and will add them back to the master list of serial numbers.
		</cfif>
	</td>
</tr>
<tr><td>&nbsp;</td></tr>

<cfif qryOrphanedOrders.RecordCount GT 0>
	<form name="detailform" action="index.cfm?task=serials_admin_orphans_act&RequestTimeout=6000" method="post">
		<tr>
			<td class="textmain" align="center" colspan="4">
				<input type="submit" name="Delete" value="Delete" onclick="return confirmDelete()">
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	</form>
</cfif>

<tr>
<td valign="top" class="textmain" colspan="4">
	<table cellpadding="0" cellspacing="0" width="100%" border="0">
	
	<!--- LIST HEADINGS --->
	<tr>
		<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF">Order Number</td>
		<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF">Item Number</td>
		<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" align="center">Quantity of Serial Numbers</td>
		<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF">Posted Date</td>
	</tr>

	<!--- LIST DATA --->	
	<cfif qryOrphanedOrders.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="4" class="productTitle"><font color="FF0000">There are no Orphaned Serial Numbers for the date range you entered.</font></td>
		</tr>
	</cfif>
	
	<cfloop query="qryOrphanedOrders">
		<tr<cfif qryOrphanedOrders.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
			<td class="textsmall" align="left">#qryOrphanedOrders.ORDNUMBER#</td>
			<td class="textsmall" align="left">#qryOrphanedOrders.ITEMNO#</td>
			<td class="textsmall" align="center">#qryOrphanedOrders.SerialNumberCount#</td>
			<td class="textsmall" align="left">#dateFormat(qryOrphanedOrders.PostedDate, 'mm/dd/yyyy')#</td>
		</tr>
	</cfloop>

	</table>
</td>
</tr>

</table>
</cfoutput>