<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/10/2006
	Function: 		This page displays a list of Reports
	Template:		lstReports.cfm
	Task:			serials_reports_list
--->

<cfoutput>
<table width="500" border="0" align="center" cellpadding="3" cellspacing="1">

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>


<tr>
	<td valign="top" class="textmain">
		<a href="serials/reports/index.cfm?task=serials_reports_history_enter" target="_blank">
			Serial Number History Report
		</a>
	</td>
</tr>

<tr>
	<td valign="top" class="textmain">
		<a href="serials/reports/index.cfm?task=serials_reports_history2_enter" target="_blank">
			Multiple Serial Number History Report
		</a>
	</td>
</tr>


<tr>
	<td valign="top" class="textmain">
		<a href="index.cfm?task=serials_reports_label_enter">
			Print Single Serial Number Bar Code
		</a>
	</td>
</tr>

<tr>
	<td valign="top" class="textmain">
		<a href="serials/reports/index.cfm?task=serials_reports_order_enter" target="_blank">
			Sales Order Number Report
		</a>
	</td>
</tr>
<tr>
	<td valign="top" class="textmain">
		<a href="serials/reports/index.cfm?task=serials_reports_part_enter" target="_blank">
			Part Number History Report
		</a>
	</td>
</tr>

<tr><td>&nbsp;</td></tr>

<tr>
	<td valign="top" class="textmain">
		<a href="serials/reports/index.cfm?task=serials_reports_undone_receipts&RequestTimeout=6000" target="_blank">
			Receipts with No Serial Numbers Entered
		</a>
	</td>
</tr>
<tr>
	<td valign="top" class="textmain">
		<a href="serials/reports/index.cfm?task=serials_reports_undone_vendorreturns&RequestTimeout=6000" target="_blank">
			Returns to Vendor with No Serial Numbers Entered
		</a>
	</td>
</tr>
<tr>
	<td valign="top" class="textmain">
		<a href="serials/reports/index.cfm?task=serials_reports_undone_adjustments&RequestTimeout=6000" target="_blank">
			Adjustments with No Serial Numbers Entered
		</a>
	</td>
</tr>
<tr>
	<td valign="top" class="textmain">
		<a href="serials/reports/index.cfm?task=serials_reports_undone_transfers&RequestTimeout=6000" target="_blank">
			Transfers with No Serial Numbers Entered
		</a>
	</td>
</tr>

<tr><td>&nbsp;</td></tr>

<tr>
	<td valign="top" class="textmain">
		<a href="index.cfm?task=serials_reports_frmStock">
			Out of Stock Report
		</a>
	</td>
</tr>
<tr>
	<td valign="top" class="textmain">
		<a href="index.cfm?task=serials_reports_frmStock&UpdateOnly=1">
			Out of Stock - Update Only
		</a>
	</td>
</tr>
<tr>
	<td valign="top" class="textmain">
		<a href="serials/reports/index.cfm?task=serials_reports_dspReceipts&RequestTimeout=6000" target="_blank">
			Receipts Report
		</a>
	</td>
</tr>

<tr><td>&nbsp;</td></tr>
<tr>
	<td valign="top" class="textmain">
		<a href="index.cfm?task=serials_reports_frmExport">
			Export Serial Numbers to Excel
		</a>
	</td>
</tr>

<tr><td>&nbsp;</td></tr>
<tr>
	<td valign="top" class="textmain">
<!---	<a href="serials/reports/index.cfm?task=serials_reports_history_enter" target="_blank">	--->
		<a href="serials/reports/index.cfm?task=serials_reports_sales_enter" target="_blank">
			Customer Sales Report
		</a>
	</td>
</tr>
<tr>
	<td valign="top" class="textmain">
		<a href="serials/reports/index.cfm?task=serials_reports_microsoft_enter" target="_blank">
			Microsoft SKU Report
		</a>
	</td>
</tr>
<tr>
	<td valign="top" class="textmain">
		<a href="index.cfm?task=serials_reports_frmIntel">
			Intel Sales Report
		</a>
	</td>
</tr>

<tr>
	<td valign="top" class="textmain">
		<a href="index.cfm?task=serials_reports_frmSpiff">
			Close-Out Specials (Spiff) Report
		</a>
	</td>
</tr>

</table>
</cfoutput>