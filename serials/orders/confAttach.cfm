<!---<cfsilent>--->
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	10/12/2006
	Function: 		This page displays the attachment confirmation form
	Template:		confAttach.cfm
	Task:			serials_attach_confirm
--->
	<cfset objOEORDH = createObject("component", "admin.assets.cfcs.OEORDH")>
	<cfset objOEINVH = createObject("component", "admin.assets.cfcs.OEINVH")>
	<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>

	<cfif isDefined("URL.Validation")>
		<cfset stRecord = objSerialsShipments.getDataRecord()>
		<cfset stErrors = objSerialsShipments.getErrorRecord()>
		<cfset Variables.INVUNIQ = "">
	<cfelse>
		<cfset stRecord = structNew()>
		<cfset structInsert(stRecord, "ORDUNIQ", URL.ORDUNIQ, True)>
		<cfset structInsert(stRecord, "InvoiceNumber", "", True)>
		<cfset structInsert(stRecord, "REInvoiceNumber", "", True)>
		<cfset stErrors = structNew()>
		
<!---	<cfset Variables.INVUNIQ = objSerialsShipments.findInvoiceToAttach(stRecord.ORDUNIQ)>	--->
		<cfset strInvoiceAttach = objSerialsShipments.findInvoiceToAttach(stRecord.ORDUNIQ)>
		<cfset Variables.INVUNIQ = strInvoiceAttach.INVUNIQFound>
		
	</cfif>

	<!--- Get a structure of the Order header --->
<!---<cfset strHeader = objOEORDH.getRecord(URL.ORDUNIQ)>--->
	<cfset strHeader = objOEORDH.getRecord(stRecord.ORDUNIQ)>

<!---<cfset Variables.INVUNIQ = objSerialsShipments.findInvoiceToAttach(URL.ORDUNIQ)>	--->

<!---</cfsilent>--->

<!--- Exact Match for the invoice was found --->
<cfif Variables.INVUNIQ IS NOT "">
	<cflocation url="index.cfm?task=serials_attach_confirm_act&ORDUNIQ=#urlEncodedFormat(stRecord.ORDUNIQ)#&INVUNIQ=#urlEncodedFormat(Variables.INVUNIQ)#&FoundExactMatch=1&RequestTimeout=6000">
</cfif>


<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objSerialsShipments.getMessage()#</font></td>
</tr>
<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<td valign="top" class="textmain" style="font-size:16px"><font color="FF0000"><b>Attachment Confirmation</b></font></td>
</tr>

<tr>
<td valign="top" class="textmain">
	<!--- ORDER INFORMATION --->
	<cfinclude template="headerInfo.cfm">
</td>
</tr>
<tr><td>&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<form action="index.cfm?task=serials_attach_confirm_act&RequestTimeout=6000" method="Post" name="detailform">
<!---<input type="hidden" name="ORDUNIQ" value="#URL.ORDUNIQ#">--->
	<input type="hidden" name="ORDUNIQ" value="#stRecord.ORDUNIQ#">
	<input type="hidden" name="INVUNIQ" value="#Variables.INVUNIQ#">

	<table cellpadding="2" cellspacing="0" width="100%" border="0">
		<cfset TabValue = 1>

<!---
		<!--- Exact Match for the invoice was found --->
		<cfif Variables.INVUNIQ IS NOT "">

			<input type="hidden" name="FoundExactMatch" value="1">
			
			<cfset strOEINVH = objOEINVH.getRecord(Variables.INVUNIQ)>
			<tr>
				<td width="30%" class="textmain" align="left">
					<strong>Invoice Found:</strong>
				</td>
				<td class="textmain" align="left">
					#strOEINVH.INVNUMBER#
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td colspan="2" class="textmain" align="left">
					You are about to attach the serial numbers entered on this order<br>to invoice number '#strOEINVH.INVNUMBER#'
				</td>
			</tr>
--->

		<!--- Exact Match for the invoice was NOT found --->
<!---	<cfelse>	--->
			<input type="hidden" name="FoundExactMatch" value="0">
			
			<tr>
				<td class="textmain" align="center" colspan="2">
					<font color="FF0000"><b>** Invoice was not found **</b></font>
				</td>
			</tr>		
			<tr>
				<td class="textmain" align="left" colspan="2">
					The scanned serial numbers can be attached to an invoice <i>only</i> if an exact invoice match is found. &nbsp;
					The item numbers and quantities entered in the invoice must match the number of serial numbers scanned.<br><br>
					In this case, an exact match was not found. &nbsp; It is possible that one or more of the quantities were
					entered incorrectly when creating the invoice, or that the quantities hand-written on the printed order were 
					entered incorrectly, etc.
<!---					
					<cfif isDefined("strInvoiceAttach.qryErrors")>
						<br><br>
						The item on the order that appears to be causing the error is '#strInvoiceAttach.ErrorITEM#'.  It is on order line number #strInvoiceAttach.ErrorORDLINENUM#.
						<cfif isDefined("strInvoiceAttach.ErrorQTYSHIPPED") AND isDefined("strInvoiceAttach.ErrorSNsScanned")>
							The number of serial numbers scanned on the order line is #strInvoiceAttach.ErrorSNsScanned#; the quantity to ship on invoice #strInvoiceAttach.ErrorINVNUMBER# is #int(strInvoiceAttach.ErrorQTYSHIPPED)#.
						</cfif>
					</cfif>	
--->					
<!---
					<br><br><br>
					If you are absolutely sure that you know the correct invoice number and want to proceed, please enter the invoice 
					number twice below and click 'Continue'.
--->					
<!---				Please note that these errors must be investigated and corrected before the attachment process can continue.	--->
				</td>
			</tr>		
			
			<cfif isDefined("strInvoiceAttach.qryErrors")>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td class="textmain" align="left" colspan="2">
						The errors that were found are listed below:
					</td>
				</tr>
				<tr>
					<td class="textmain" align="left" colspan="2">
						<table cellpadding="2" cellspacing="0" width="100%" border="0">
							<tr>
								<td height="18" bgcolor="006633" class="textmain" style="color:FFFFFF"><b>Invoice<br>Number</b></td>
								<td height="18" bgcolor="006633" class="textmain" style="color:FFFFFF"><b>Item</b></td>
								<td height="18" bgcolor="006633" class="textmain" style="color:FFFFFF"><b>Order<br>Line</b></td>
								<td height="18" bgcolor="006633" class="textmain" style="color:FFFFFF" align="center"><b>Quantity on<br>Invoice</b></td>
								<td height="18" bgcolor="006633" class="textmain" style="color:FFFFFF" align="center"><b>Quantity<br>Scanned<br>on Order</b></td>
							</tr>
							
							<cfloop query="strInvoiceAttach.qryErrors">
								<tr>
									<td class="textsmall" align="left">#strInvoiceAttach.qryErrors.INVNUMBER#</td>
									<td class="textsmall" align="left">#strInvoiceAttach.qryErrors.ITEM#</td>
									<td class="textsmall" align="left">#strInvoiceAttach.qryErrors.ORDLINENUM#</td>
									<td class="textsmall" align="center">
										<cfif isNumeric(strInvoiceAttach.qryErrors.QTYSHIPPED)>
											#int(strInvoiceAttach.qryErrors.QTYSHIPPED)#						
										<cfelse>
											#strInvoiceAttach.qryErrors.QTYSHIPPED#
										</cfif>
									</td>
									<td class="textsmall" align="center">#strInvoiceAttach.qryErrors.SNsScanned#</td>
								</tr>							
							</cfloop>						
						</table>
					</td>
				</tr>
			</cfif>

			<tr><td>&nbsp;</td></tr>
			<tr>
				<td class="textmain" align="left" colspan="2">
					If you are absolutely sure that you know the correct invoice number and want to proceed, please enter the invoice 
					number twice below and click 'Continue'.
				</td>
			</tr>

			<cfif structKeyExists(stErrors, "WrongInvoice")>
				<tr>
					<td valign="top" class="textmain" colspan="2">
						<font color="FF0000">
							<b>*** ERROR ***</b><br>
							One or more of the items on the invoice you entered does not match the items on the order.  Please
							enter a different invoice number.
						</font>
					</td>
				</tr>
			</cfif>

			<cfif structKeyExists(stErrors, "InvoiceNumber")>
				<tr>
					<td>&nbsp;</td>
					<td valign="top" class="textmain"><font color="FF0000">&raquo; #stErrors.InvoiceNumber#</font></td>
				</tr>
			</cfif>
			<tr>
				<td width="35%" class="textmain" align="left">
					<strong>Enter Invoice Number:</strong>
				</td>
				<td class="textmain" align="left">
					<input name="InvoiceNumber" size="20" maxlength="50" value="#stRecord.InvoiceNumber#" <cfif structKeyExists(stErrors, "InvoiceNumber")>style="border:1px solid red;"</cfif> tabindex="#TabValue#">
					<cfset TabValue = TabValue + 1>
				</td>
			</tr>
			
			<cfif structKeyExists(stErrors, "REInvoiceNumber")>
				<tr>
					<td>&nbsp;</td>
					<td valign="top" class="textmain"><font color="FF0000">&raquo; #stErrors.REInvoiceNumber#</font></td>
				</tr>
			</cfif>
			<tr>
				<td class="textmain" align="left">
					<strong>Re-Enter Invoice Number:</strong>
				</td>
				<td class="textmain" align="left">
					<input name="REInvoiceNumber" size="20" maxlength="50" <cfif structKeyExists(stErrors, "REInvoiceNumber")>style="border:1px solid red;"</cfif> tabindex="#TabValue#">
					<cfset TabValue = TabValue + 1>
				</td>
			</tr>
		
<!---	</cfif>	--->

		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="left">
				<table cellpadding="2" cellspacing="0" width="80%" border="0">
					<tr>
						<!--- "QUIT" BUTTON --->
						<td class="textmain" align="center" width="50%">
							<input type="submit" name="ButtonClicked" value="Quit">
						</td>
						<!--- "CONTINUE" BUTTON --->
						<td class="textmain" align="center">
							<input type="submit" name="ButtonClicked" value="&nbsp;Continue -&raquo;" tabindex="#TabValue#">
						</td>
					</tr>
				</table>
			</td>
		</tr>
	
	</table>

	</form>
</td>
</tr>

</table>
</cfoutput>