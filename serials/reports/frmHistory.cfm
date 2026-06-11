<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/10/2006
	Function: 		This page prompts the user to enter a serial number
	Template:		frmHistory.cfm
	Task:			serials_reports_history_enter
--->
	<cfset objSerialNumberAuditTrail = createObject("component", "admin.assets.cfcs.SerialNumberAuditTrail")>

	<cfset ExecuteSearch = 0>
	<cfset Error = 0>
	
	<cfif isDefined("FORM.SerialNumber")>
	
		<cfif NOT isDefined("FORM.Consolidate")>
			<cfset FORM.Consolidate = 0>
		</cfif>

		<cfset ExecuteSearch = 1>
		<cfif trim(FORM.SerialNumber) IS "">
			<cfset Error = 1>
			<cfset ErrorType = "SerialNumberBlank">
			
		<cfelseif isDate(FORM.BeginningDate) AND isDate(FORM.EndingDate) AND 
			 	  dateCompare(FORM.BeginningDate,FORM.EndingDate) EQ 1>
			<cfset Error = 1>
			<cfset ErrorType = "DateInvalidRange">
			
		<cfelse>
			<cfset qrySerials = objSerialNumberAuditTrail.findSerialNumber(SerialNumber)>
			<cfif trim(FORM.BeginningDate) IS "">
				<cfset BeginDate = "NONE">
			<cfelse>
				<cfset BeginDate = trim(FORM.BeginningDate)>
			</cfif>
			<cfif trim(FORM.EndingDate) IS "">
				<cfset EndDate = "NONE">
			<cfelse>
				<cfset EndDate = trim(FORM.EndingDate)>
			</cfif>
			<cfif qrySerials.RecordCount EQ 0>
				<cfset Error = 1>
				<cfset ErrorType = "SerialNumberNotFound">
			<cfelseif qrySerials.RecordCount EQ 1>
				<cflocation url="index.cfm?task=serials_reports_history_disp&SerialNumber=#urlEncodedFormat(qrySerials.SerialNumber)#&ITEMNO=#urlEncodedFormat(qrySerials.ITEMNO)#&BeginDate=#urlEncodedFormat(BeginDate)#&EndDate=#urlEncodedFormat(EndDate)#&TransactionType=#urlEncodedFormat(FORM.TransactionType)#&Consolidate=#FORM.Consolidate#">
			</cfif>
		</cfif>
	</cfif>

</cfsilent>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<!--- spacer --->
<tr><td class="textsmall" colspan="2">&nbsp;</td></tr>

<form name="SerialNumberSearch" action="index.cfm?task=serials_reports_history_enter&RequestTimeout=6000" method="post">
	<tr>
		<td class="textmain" align="left" width="35%">
			<strong>Serial Number:</strong>
		</td>
		<td class="textmain" align="left">
			<input name="SerialNumber" size="20" maxlength="50"
				<cfif isDefined("FORM.SerialNumber")>
					value="#FORM.SerialNumber#"
				</cfif>
			>
		</td>
	</tr>

	<tr>
		<td class="textmain" align="left">
			<strong>Beginning Date:</strong>
		</td>
		<td class="textmain" align="left">
			<input name="BeginningDate" size="20" maxlength="50"
				<cfif isDefined("FORM.BeginningDate")>
					value="#FORM.BeginningDate#"
				</cfif>
			> <i>(mm/dd/yyyy)</i>
		</td>
	</tr>
	<tr>
		<td class="textmain" align="left">
			<strong>Ending Date:</strong>
		</td>
		<td class="textmain" align="left">
			<input name="EndingDate" size="20" maxlength="50"
				<cfif isDefined("FORM.EndingDate")>
					value="#FORM.EndingDate#"
				</cfif>
			> <i>(mm/dd/yyyy)</i>
		</td>
	</tr>
	<tr>
		<td class="textmain" align="left">
			<strong>Transaction Type:</strong>
		</td>
		<td class="textmain" align="left">
			<select name="TransactionType" size="1">
				<option value="">- All -</option>
				
				<option value="Receipt" <cfif isDefined("FORM.TransactionType") AND FORM.TransactionType IS "Receipt">selected</cfif>>
					Receipts
				</option>
				<option value="Order" <cfif isDefined("FORM.TransactionType") AND FORM.TransactionType IS "Order">selected</cfif>>
					Orders
				</option>
				<option value="Return" <cfif isDefined("FORM.TransactionType") AND FORM.TransactionType IS "Return">selected</cfif>>
					Returns/RMAs
				</option>
				<option value="VendorReturn" <cfif isDefined("FORM.TransactionType") AND FORM.TransactionType IS "VendorReturn">selected</cfif>>
					Returns to Vendor
				</option>			
				<option value="Adjustment" <cfif isDefined("FORM.TransactionType") AND FORM.TransactionType IS "Adjustment">selected</cfif>>
					Adjustments
				</option>
				<option value="Transfer" <cfif isDefined("FORM.TransactionType") AND FORM.TransactionType IS "Transfer">selected</cfif>>
					Transfers
				</option>						
				<option value="Count" <cfif isDefined("FORM.TransactionType") AND FORM.TransactionType IS "Count">selected</cfif>>
					Counts
				</option>
				<option value="Correction" <cfif isDefined("FORM.TransactionType") AND FORM.TransactionType IS "Correction">selected</cfif>>
					Corrections
				</option>	
			</select>		
		</td>
	</tr>
	<tr>
		<td class="textmain" align="left">
			<strong>Consolidate Batch Items?</strong>
		</td>
		<td class="textmain" align="left">
			<input type="checkbox" name="Consolidate" value="1" <cfif isDefined("FORM.Consolidate") AND FORM.Consolidate EQ 1>checked</cfif>>			
		</td>
	</tr>

	<tr>
		<td class="textmain">&nbsp;</td>
		<td class="textmain">
			<input type="submit" name="ProcessSearch" value="Search">
		</td>
	</tr>
	
</form>
<cfif Error>
	<tr>
		<td class="textmain" align="left" colspan="2">
			<font color="FF0000">
				<cfif ErrorType IS "SerialNumberBlank">
<!---			<cfif trim(FORM.SerialNumber) IS "">	--->
					Please enter a Serial Number (partial or full) before clicking "Search".
				<cfelseif ErrorType IS "SerialNumberNotFound">
<!---			<cfelseif qrySerials.RecordCount EQ 0>	--->
					Serial Number <cfif isDefined("FORM.SerialNumber")>'#FORM.SerialNumber#'</cfif> was not found.
				<cfelseif ErrorType IS "DateInvalidRange">
					Ending Date must be greater than Beginning Date.
				</cfif>
			</font>
		</td>
	</tr>
</cfif>

<tr><td class="textsmall" colspan="2">&nbsp;</td></tr>
</cfoutput>


<cfif ExecuteSearch AND isDefined("qrySerials") AND NOT Error>

	<tr>
	<td valign="top" class="textmain" colspan="2">
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
	
				<td class="textsmall" align="left">
					<a href="index.cfm?task=serials_reports_history_disp&SerialNumber=#urlEncodedFormat(qrySerials.SerialNumber)#&ITEMNO=#urlEncodedFormat(qrySerials.ITEMNO)#&BeginDate=#urlEncodedFormat(BeginDate)#&EndDate=#urlEncodedFormat(EndDate)#&TransactionType=#urlEncodedFormat(FORM.TransactionType)#&Consolidate=#FORM.Consolidate#">
						#qrySerials.SerialNumber#
					</a>
				</td>
				<td class="textsmall" align="left">
					#qrySerials.ITEMNO#
				</td>
				<td class="textsmall" align="left">
					#qrySerials.ITEMDESC#
				</td>
			</tr>
		</cfoutput>
	
		</table>
	</td>
	</tr>

</cfif>


</table>

<cfif isDefined("ErrorType") AND ErrorType IS "DateInvalidRange">
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.SerialNumberSearch['EndingDate'].focus();document.SerialNumberSearch['EndingDate'].select()
	-->
	</script>
<cfelse>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.SerialNumberSearch['SerialNumber'].focus();document.SerialNumberSearch['SerialNumber'].select()
	-->
	</script>
</cfif>

