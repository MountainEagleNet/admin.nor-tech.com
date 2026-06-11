<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/10/2006
	Function: 		Serial Number History Report
	Template:		dspHistory.cfm
	Task:			serials_reports_history_disp
--->
<cfset objSerialNumberAuditTrail = createObject("component", "admin.assets.cfcs.SerialNumberAuditTrail")>
<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>
<cfset objOEINVH = createObject("component", "admin.assets.cfcs.OEINVH")>

<cfset stFormCopy = duplicate(FORM)>
<cfif trim(stFormCopy.BeginningDate) IS "">
	<cfset BeginDate = "NONE">
<cfelse>
	<cfset BeginDate = trim(stFormCopy.BeginningDate)>
</cfif>
<cfif trim(stFormCopy.EndingDate) IS "">
	<cfset EndDate = "NONE">
<cfelse>
	<cfset EndDate = trim(stFormCopy.EndingDate)>
</cfif>

<cfif NOT isDefined("stFormCopy.ProcessSearch")>
	<cfset objSerialNumberAuditTrail.setDataRecord(stFormCopy)>
	<cflocation url="index.cfm?task=serials_reports_history2_enter&NumberOfBoxes=#stFormCopy.AddBoxes#">
</cfif>

<cfoutput>
<table width="900" border="0" align="center" cellpadding="3" cellspacing="1">
	<tr>
		<td class="textmain" width="50%" valign="top" style="font-size:16px"><font color="0033CC">
			<b>Serial Number History Report</b></font>
		</td>
		<td class="textmain" width="15%"><b>Date of Report:</b></td>
		<td class="textmain">#dateFormat(now(), 'mm/dd/yyyy')# at #timeFormat(now(), 'h:mm tt')#</td>
	</tr>
</table>
</cfoutput>

<cfset lstForm = structKeyList(stFormCopy)>
<cfset FoundAtLeastOne = 0>
<cfloop list="#lstForm#" index="Column">
	<cfif findNoCase("SerialNumber_", Column) NEQ 0>
		<cfset SerialNumberValue = stFormCopy[Column]>
		<cfif trim(SerialNumberValue) IS NOT "">
		
			<cfset qrySerials = objSerialNumberAuditTrail.findSerialNumber(SerialNumberValue, 1)>
			
			<cfif qrySerials.RecordCount EQ 0>
				<cfoutput>
				<table width="900" border="0" align="center" cellpadding="3" cellspacing="1">
				<!--- spacer --->
				<tr><td class="textsmall">&nbsp;</td></tr>
				<tr>
					<td width="50%" valign="top">
						<table cellpadding="1" cellspacing="0" width="100%" border="0">
						<tr>
							<td class="textmain" width="30%"><b>Serial Number:</b></td>
							<td class="textmain">#SerialNumberValue#</td>
						</tr>
						</table>
					</td>
					<td valign="top">
						<table cellpadding="1" cellspacing="0" width="100%" border="0">
						<tr>
							<td class="textmain" valign="top" style="font-size:12px">
								<font color="FF0000">
									Serial Number Not Found
								</font>
							</td>
						</tr>
						</table>
					</td>
				</tr>
				</table>
				</cfoutput>
			</cfif>
			
			<cfloop query="qrySerials">

<!---
				<cfset SearchRecord = structNew()>
				<cfset structInsert(SearchRecord, "SerialNumber", SerialNumberValue, True)>
				<cfset structInsert(SearchRecord, "ITEMNO", qrySerials.ITEMNO, True)>
				<cfset qryHistory = objSerialNumberAuditTrail.searchRecords(SearchRecord, "query", "CreationDate", 1)>
--->
				<cfset qryHistory = objSerialNumberAuditTrail.serialNumberHistoryReport(SerialNumberValue, qrySerials.ITEMNO, BeginDate, EndDate)>

				<cfset FoundAtLeastOne = 1>
				<cfoutput>
				<table width="900" border="0" align="center" cellpadding="3" cellspacing="1">
				<!--- spacer --->
				<tr><td class="textsmall">&nbsp;</td></tr>
				
				<tr>
					<td width="50%" valign="top">
						<table cellpadding="1" cellspacing="0" width="100%" border="0">
						<tr>
							<td class="textmain" width="30%"><b>Serial Number:</b></td>
							<td class="textmain">#SerialNumberValue#</td>
						</tr>
						</table>
					</td>
					<td valign="top">
						<table cellpadding="1" cellspacing="0" width="100%" border="0">
						<tr>
							<td class="textmain"><b>Item Number:</b></td>
							<td class="textmain">#qryHistory.ITEMNO#</td>
						</tr>
						<tr>
							<td class="textmain"><b>Description:</b></td>
							<td class="textmain">#qryHistory.ITEMDESC#</td>
						</tr>
						</table>
					</td>
				</tr>
				
				<tr>
				<td valign="top" class="textmain" colspan="2">
					<table cellpadding="0" cellspacing="0" width="100%" border="0">
					
					<!--- LIST HEADINGS --->
					<tr>
						<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Date</font></td>
						<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Type</font></td>
						<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Number</font></td>
						<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Inv</font></td>
						<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Action</font></td>
						<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">User</font></td>
						<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Location</font></td>
						<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Vendor</font></td>
						<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Customer</font></td>
					</tr>
				
					<!--- LIST DATA --->	
					<cfif qryHistory.RecordCount EQ 0>
						<tr>
							<td align="center" colspan="9" class="productTitle"><font color="FF0000">The chosen serial number has no history <cfif (BeginDate IS NOT "NONE" AND isDate(BeginDate)) OR (EndDate IS NOT "NONE" AND isDate(EndDate))>for the date range entered</cfif>.</font></td>
						</tr>
					</cfif>
					
					<cfloop query="qryHistory">
						<tr  <cfif qryHistory.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
							<td class="textsmall" align="left">#dateFormat(qryHistory.CreationDate, "mm/dd/yyyy")#</td>
							<td class="textsmall" align="left">#qryHistory.TransactionType#</td>
							<td class="textsmall" align="left">#qryHistory.TransactionNumber#</td>
							
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
							<td class="textsmall" align="left">#InvoiceNumber#</td>
							
							<td class="textsmall" align="left">#qryHistory.AddorRemove#</td>
							<td class="textsmall" align="left">#qryHistory.UserFirstName# #qryHistory.UserLastName#</td>
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
					</cfloop>
				
					</table>
				</td>
				</tr>
				</table>
				</cfoutput>
			</cfloop>			
		</cfif>
	</cfif>
</cfloop>

<cfif NOT FoundAtLeastOne>
	<table width="900" border="0" align="center" cellpadding="3" cellspacing="1">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td class="textmain" width="50%" valign="top" style="font-size:12px">
				<font color="#FF0000">
					No records were found matching the serial number(s) you entered
				</font>
			</td>
		</tr>
	</table>
</cfif>