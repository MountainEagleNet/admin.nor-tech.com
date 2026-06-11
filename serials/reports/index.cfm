<cfsilent>
	<!---
	Coded By: Alternative Systems, Inc - Ron Barth
	Create Date: 05/11/2006
	Edit Date: 
	Function: Index Page
	index.cfm 
	This page controls the layout of root pages and sets the root parameters.
	The template is created with <cfinclude>s for each of the main sections of the page
	--->
</cfsilent>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Northern Computer Technologies</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta name="KEYWORDS" content="Custom, Configuration, PCs, Laptops, Portables, Computer, Notebook, Hardware, Build, Value, Technology, Servers, Intel, Intel Premier Provider, AMD, Opteron, Dual Opteron, Athlon, Pentium, Xeon, Nor-Tech, Northern Computer Technologies, Voyageur PC, voyageurpc">
<meta name="TITLE" content="Northern Computer Technologies">
<meta name="DESCRIPTION" content="Nor-Tech is a premier wholesale OEM and a leading manufacturer of custom configured, build-to-order PCs, servers, notebooks and custom vertical market solutions.">
<meta name="AUTHOR" content="Northern Computer Technologies">
<meta name="LANGUAGE" content="en">
<meta name="DOCUMENTCOUNTRYCODE" content="us">

<!--- Include scanner.js for scanner functionality --->
<cfif isDefined("task")>
	<cfset objScannerSettings = createObject("component", "admin.assets.cfcs.ScannerSettings")>
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "Task", task, True)>
	<cfset qryScannerSettings = objScannerSettings.searchRecords(SearchRecord, "query")>
	<cfif qryScannerSettings.RecordCount NEQ 0>
		<script src="/scripts/scanner.js"></script>
	</cfif>
</cfif>

<link href="/techstyle.css" rel="stylesheet" type="text/css">
</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="756" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
   <td height="318" colspan="8" valign="top">
		<cfsilent>
			<cfparam name="task" default="main">
		</cfsilent>
		<cfswitch expression="#task#">
			<!--- REPORTS --->
			<!--- List All Reports --->
			<cfcase value="serials_reports_list">
				<cfinclude template="lstReports.cfm">
			</cfcase>
			
			<!--- History, Enter S/N --->
			<cfcase value="serials_reports_history_enter">
				<cfinclude template="frmHistory.cfm">
			</cfcase>			
			<!--- History, Display --->
			<cfcase value="serials_reports_history_disp">
				<cfinclude template="dspHistory.cfm">
			</cfcase>	
			<!--- History, Delete --->
			<cfcase value="serials_reports_history_delete">
				<cfinclude template="delHistory.cfm">
			</cfcase>	

			<!--- History2, Enter S/N --->
			<cfcase value="serials_reports_history2_enter">
				<cfinclude template="frmHistory2.cfm">
			</cfcase>			
			<!--- History2, Display --->
			<cfcase value="serials_reports_history2_disp">
				<cfinclude template="dspHistory2.cfm">
			</cfcase>	

			<!--- Order, Enter Order Num --->
			<cfcase value="serials_reports_order_enter">
				<cfinclude template="frmOrder.cfm">
			</cfcase>			
			<!--- Order, Display--->
			<cfcase value="serials_reports_order_disp">
				<cfinclude template="dspOrder.cfm">
			</cfcase>	

			<!--- Part Number History, Enter Item Number --->
			<cfcase value="serials_reports_part_enter">
				<cfinclude template="frmPartHistory.cfm">
			</cfcase>			
			<!--- Part Number History, Display --->
			<cfcase value="serials_reports_part_disp">
				<cfinclude template="dspPartHistory.cfm">
			</cfcase>	
						
			<!--- Receipts with No Serial Numbers Entered --->
			<cfcase value="serials_reports_undone_receipts">
				<cfinclude template="dspUndoneReceipts.cfm">
			</cfcase>	
			<!--- Returns to Vendor with No Serial Numbers Entered --->
			<cfcase value="serials_reports_undone_vendorreturns">
				<cfinclude template="dspUndoneVendorReturns.cfm">
			</cfcase>	
			<!--- Adjustments with No Serial Numbers Entered --->
			<cfcase value="serials_reports_undone_adjustments">
				<cfinclude template="dspUndoneAdjustments.cfm">
			</cfcase>	
			<!--- Transfers with No Serial Numbers Entered --->
			<cfcase value="serials_reports_undone_transfers">
				<cfinclude template="dspUndoneTransfers.cfm">
			</cfcase>							

			<!--- Receipts Report --->
			<cfcase value="serials_reports_dspReceipts">
				<cfinclude template="dspReceipts.cfm">
			</cfcase>				

			<!--- Sales, Selection Criteria --->
			<cfcase value="serials_reports_sales_enter">
				<cfinclude template="frmSales.cfm">
			</cfcase>			
			<!--- Sales, Display --->
			<cfcase value="serials_reports_sales_disp">
				<cfinclude template="dspSales.cfm">
			</cfcase>	

			<!--- Microsoft SKU Report, Selection Criteria --->
			<cfcase value="serials_reports_microsoft_enter">
				<cfinclude template="frmMicrosoft.cfm">
			</cfcase>			
			<!--- Microsoft SKU Report, Display --->
			<cfcase value="serials_reports_microsoft_disp">
				<cfinclude template="dspMicrosoft.cfm">
			</cfcase>	
									
			<!--- MAIN --->
			<cfdefaultcase>
				<cfinclude template="../../dspMain.cfm">
			</cfdefaultcase>
		</cfswitch>
		
	</td>
  </tr>
</table>
<map name="logoMap">
<area shape="rect" coords="7,8,134,45" href="http://www.nor-tech.com" alt="Nor-tech Home">
</map>
</body>
</html>
