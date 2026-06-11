<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	03/26/2007
	Function: 		Part Number History Report
	Template:		dspPartHistory.cfm
	Task:			serials_reports_part_disp
--->
	<cfset objSerialNumberAuditTrail = createObject("component", "admin.assets.cfcs.SerialNumberAuditTrail")>
	<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>
	<cfset objOEINVH = createObject("component", "admin.assets.cfcs.OEINVH")>
	<cfset objScannerBatchItems = createObject("component", "admin.assets.cfcs.ScannerBatchItems")>

	<cfset qryHistory = objSerialNumberAuditTrail.partNumberHistoryReport(URL.ITEMNO, URL.BeginDate, URL.EndDate, URL.TransactionType)>

	<cfset ConsolidateSerialNumbers = 0>
	<cfif URL.Consolidate EQ 1>
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ITEMNO", URL.ITEMNO, True)>
		<cfset qryScannerBatchItems = objScannerBatchItems.searchRecords(SearchRecord, "query")>
		<cfif qryScannerBatchItems.RecordCount GT 0>
			<cfset ConsolidateSerialNumbers = 1>
		</cfif>
	</cfif>

</cfsilent>

<cfoutput>
<table width="950" border="0" align="center" cellpadding="3" cellspacing="1">
<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<td width="50%" valign="top">
		<table cellpadding="1" cellspacing="0" width="100%" border="0">
		<tr>
			<td colspan="2" valign="top" class="textmain" style="font-size:16px"><font color="0033CC">
				<b>Part Number History Report</b></font>
			</td>
		</tr>
		<tr>
			<td class="textmain" width="30%"><b>Part Number:</b></td>
			<td class="textmain">#URL.ITEMNO#</td>
		</tr>
		</table>
	</td>
	<td valign="top">
		<table cellpadding="1" cellspacing="0" width="100%" border="0">
		<tr>
			<td class="textmain" width="30%"><b>Date of Report:</b></td>
			<td class="textmain">#dateFormat(now(), 'mm/dd/yyyy')# at #timeFormat(now(), 'h:mm tt')#</td>
		</tr>
		<tr>
			<td class="textmain"><b>Description:</b></td>
			<td class="textmain">#objSerialNumberAuditTrail.getItemDescription(URL.ITEMNO)#</td>
		</tr>
		</table>
	</td>
</tr>
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain" colspan="2">
	<table cellpadding="0" cellspacing="0" width="100%" border="0">
	
	<!--- LIST HEADINGS --->
	<tr>
		<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Date</font></td>
		<td height="18" bgcolor="006633" class="productTitle" align="center"><font color="FFFFFF">Serial Number</font></td>
		<td height="18" bgcolor="006633" class="productTitle" align="center"><font color="FFFFFF">Type</font></td>
		<td height="18" bgcolor="006633" class="productTitle" align="center"><font color="FFFFFF">Number</font></td>
		<td height="18" bgcolor="006633" class="productTitle" align="center"><font color="FFFFFF">Inv</font></td>
		<td height="18" bgcolor="006633" class="productTitle" align="center"><font color="FFFFFF">Action</font></td>
		<td height="18" bgcolor="006633" class="productTitle" align="center"><font color="FFFFFF">User</font></td>
		<td height="18" bgcolor="006633" class="productTitle" align="center"><font color="FFFFFF">Approver</font></td>
		<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Location</font></td>
		<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Vendor</font></td>
		<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Customer</font></td>
	</tr>

	<!--- LIST DATA --->	
	<cfif qryHistory.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="11" class="productTitle">
				<font color="FF0000">
				The chosen item number has no 
				<cfif URL.TransactionType IS NOT "">
					'#URL.TransactionType#' transactions
				<cfelse>
					history
				</cfif>
				<cfif (URL.BeginDate IS NOT "NONE" AND isDate(URL.BeginDate)) OR (URL.EndDate IS NOT "NONE" AND isDate(URL.EndDate))> 			
					for the date range 
					<cfif isDate(URL.BeginDate) AND isDate(URL.EndDate)>
						#dateFormat(URL.BeginDate, 'm/dd/yyyy')# - #dateFormat(URL.EndDate, 'm/dd/yyyy')#
					<cfelse>
						entered
					</cfif>
				</cfif>
				</font>
			</td>
		</tr>
	</cfif>

	<cfset KeyField = "">
	<cfloop query="qryHistory">
	
		<cfset ThisKeyField = trim(qryHistory.TransactionType) & trim(qryHistory.TransactionNumber) & trim(qryHistory.ITEMNO) & trim(qryHistory.SerialNumber)>
		<cfif NOT ConsolidateSerialNumbers OR ThisKeyField IS NOT KeyField>
			<cfset KeyField = ThisKeyField>
		
			<cfif NOT ConsolidateSerialNumbers>
				<cfif qryHistory.CurrentRow mod 2>
					<cfset BackgroundGray = 1>
				<cfelse>
					<cfset BackgroundGray = 0>
				</cfif>
			</cfif>
			<cfif ConsolidateSerialNumbers>
				<cfif NOT isDefined("BackgroundGray") OR BackgroundGray EQ 1>
					<cfset BackgroundGray = 0>
				<cfelse>
					<cfset BackgroundGray = 1>
				</cfif>
			</cfif>

			<tr  <cfif BackgroundGray> style="background-color:##e5e5e6"</cfif>>
				<td class="textsmall" align="left">#dateFormat(qryHistory.CreationDate, "mm/dd/yyyy")#</td>
				<td class="textsmall" align="center">#qryHistory.SerialNumber#</td>
				<td class="textsmall" align="center">#qryHistory.TransactionType#</td>
				<td class="textsmall" align="center">#qryHistory.TransactionNumber#</td>
				
				<cfset InvoiceNumber = "">
				<cfif qryHistory.TransactionType IS "Order">
					<cfset strSerialsShipment = objSerialsShipments.getRecord(qryHistory.SerialTableIDValue)>
					<cfif NOT structIsEmpty(strSerialsShipment) AND strSerialsShipment.INVUNIQ IS NOT "">
						<cfset strOEINVH = objOEINVH.getRecord(strSerialsShipment.INVUNIQ)>
						<cfif isDefined("strOEINVH.INVNUMBER")>
							<cfset InvoiceNumber = strOEINVH.INVNUMBER>
						</cfif>
					</cfif>
				</cfif>
				<td class="textsmall" align="center">#InvoiceNumber#</td>
	
				<td class="textsmall" align="center">#qryHistory.AddorRemove#</td>
				<td class="textsmall" align="center">#qryHistory.UserFirstName# #qryHistory.UserLastName#</td>
				<td class="textsmall" align="center">
					<cfif qryHistory.ApprovalPassword IS "">
						&nbsp;
					<cfelseif qryHistory.ApprovalPassword IS APPLICATION.ContinuePassword1>
						L Hanson
					<cfelseif qryHistory.ApprovalPassword IS APPLICATION.ContinuePassword2>
						R Bauer
					<cfelseif qryHistory.ApprovalPassword IS APPLICATION.ContinuePassword3>
						A Gardner
					<cfelseif qryHistory.ApprovalPassword IS APPLICATION.ContinuePassword4>
						M Frank
					<cfelseif qryHistory.ApprovalPassword IS APPLICATION.ContinuePassword5>
						C Belcher
					<cfelseif qryHistory.ApprovalPassword IS APPLICATION.ContinuePassword6>
						J Messbarger
					</cfif>
				</td>
				<td class="textsmall" align="left">
					<cfif trim(qryHistory.LOCATION) IS NOT "">
						#trim(qryHistory.LOCATION)#, #trim(qryHistory.LOCATIONDESC)#
					<cfelse>
						&nbsp;
					</cfif>
				</td>
				<td class="textsmall" align="left">
					<cfif trim(qryHistory.VDCODE) IS NOT "">
						#trim(qryHistory.VDCODE)#, #trim(qryHistory.VDNAME)#
					<cfelse>
						&nbsp;
					</cfif>
				</td>
				<td class="textsmall" align="left">
					<cfif trim(qryHistory.CUSTOMER) IS NOT "">
						#trim(qryHistory.CUSTOMER)#, #trim(qryHistory.BILNAME)#
					<cfelse>
						&nbsp;
					</cfif>
				</td>
			</tr>
		</cfif>
	</cfloop>

	</table>
</td>
</tr>

</table>
</cfoutput>