<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	07/14/2006
	Function: 		Dynamic and Exportable Configurator: Quote Detail page
	Template:		quoteDetail.cfm
	Task:			quote_detail
--->
<cfset objQuoteSystem = createObject("component", "admin.assets.cfcs.config.QuoteSystem")>
<cfset objQuoteComponents = createObject("component", "admin.assets.cfcs.config.QuoteComponents")>
<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>

<cfset strQuoteSystem = objQuoteSystem.getRecord(URL.QuoteSystemID)>
<cfset qryQuoteComponents = objQuoteComponents.listRecordsForParent("QuoteSystemID", strQuoteSystem.QuoteSystemID, "TypeSortOrder")>

<script language="javascript">
	function confirmSubmit() {
		var msg = "Are you sure you want to Submit this Quote?";
		if (document.form1.QuoteSubmitted.value == "1") {
        	if (confirm("This quote has already been submitted; are you sure you want to submit it again?")==true)  { return true; }
			else { return false; }
		}
		else {
			if(confirm(msg)) { return true; }
			else { return false; }
		}
	}
	function confirmDelete() {
		var msg = "Are you sure you want to Delete this Quote?";
		if(confirm(msg)) { return true; }
		else { return false; }
	}
	function confirmUpdate() {
		var msg = "Are you sure you want to Update this Quote?";
		if(confirm(msg)) { return true; }
		else { return false; }
	}
</script>

<cfif strQuoteSystem.ConfigSystemID IS "">
	<cfset PartsOnly = 1>
<cfelse>
	<cfset PartsOnly = 0>
</cfif>

<cfoutput>
<table width="95%" border="0" align="center" cellpadding="6" cellspacing="0">
	<tr>
		<td colspan="2" class="textsmall"><div align="left" class="subhead">
		<table width="100%" border="0" cellspacing="0" cellpadding="3">
			<tr>
				<td width="34%">
                	<cfset ImageName = objConfigSystems.getImageName3(URL.QuoteSystemID)>
					<cfif ImageName IS NOT "">
						<img src="https://partners.nor-tech.com/images/systems/#ImageName#">
					</cfif>
				</td>
				
				<td width="66%">
					<div align="right"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"></font></div>
                   	<div align="right"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"></font></div>
                   	<div align="left">
					<table width="94%" border="0" align="center" cellpadding="3" cellspacing="0" bordercolor="CCCCCC">
						<cfif NOT PartsOnly>
                            <tr bgcolor="006633">
                                <td colspan="2">
                                    <div align="center"><strong><span class="textmain"><font color="FFFFFF">
                                        #strQuoteSystem.SystemName#
                                    </font></span></strong></div>
                                </td>
                            </tr>
                        </cfif>
                        <cfif NOT PartsOnly OR strQuoteSystem.Quantity GT 1>
                            <tr>
                                <td width="53%">
                                    <div align="right"><font color="000000" size="2" face="Verdana, Arial, Helvetica, sans-serif"><strong>
                                        <cfif NOT PartsOnly>
	                                        System Cost:
										<cfelse>
                                        	Price:									
										</cfif>
                                    </strong></font></div>
                                </td>
                                <td width="47%">
                                    <font color="000000" size="2" face="Verdana, Arial, Helvetica, sans-serif"><strong>
                                        #dollarFormat(strQuoteSystem.ResellerPrice)#
                                    </strong></font>
                                </td>
                            </tr>
                    	</cfif>
                        <cfif NOT PartsOnly OR strQuoteSystem.Quantity GT 1>
                            <tr>
                                <td>
                                    <div align="right"><font color="000000" size="2" face="Verdana, Arial, Helvetica, sans-serif"><strong>
                                        Quantity:
                                    </strong></font></div>
                                </td>
                                <td>
                                    <font color="000000" size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp;<strong>
                                        #strQuoteSystem.Quantity#
                                    </strong></font>
                                </td>
                            </tr>
						</cfif>                           
                            
						<tr>
							<td>
								<div align="right"><font size="4"><strong><font color="0033CC" face="Verdana, Arial, Helvetica, sans-serif">
									Your total cost:
								</font></strong></font></div>
							</td>
							<td>
								<strong><font color="0033CC" size="4" face="Verdana, Arial, Helvetica, sans-serif">
									#dollarFormat(strQuoteSystem.ResellerTotal)#
								</font></strong>
							</td>
						</tr>
					</table>
					</div>
				</td>
			</tr>
		</table>
<!---	</div>	--->
		</td>
	</tr>
	
	
	<tr>
    	<td colspan="2" class="textsmall">&nbsp;</td>
	</tr>


	<!--- QUOTE NUMBER --->	
	<tr>
		<td valign="middle" align="right" width="39%" class="systemCategory" bgcolor="FFFFFF">
			<font size="2" face="Arial, Helvetica, sans-serif"><strong>
				Quote Number:
			</strong></font>
		</td>
		<td valign="middle" align="left" class="textsmall" bgcolor="FFFFFF">
			<font size="2" face="Arial, Helvetica, sans-serif">
				#strQuoteSystem.QuoteNumber#
			</font>
		</td>
	</tr>

	<!--- PURCHASE ORDER NUMBER --->
	<tr>
		<td valign="top" bgcolor="F3F3F3">
			<div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><strong>
				Purchase Order Number:
			</strong></font></div>
		</td>
		<td class="textsmall" valign="top" bgcolor="F3F3F3">
			<font size="2" face="Arial, Helvetica, sans-serif">
				#strQuoteSystem.ResellerPONumber#
			</font>
		</td>
	</tr>

	<tr>
		<td valign="top" width="39%">
			<div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><strong>
				Date Saved:
			</strong></font></div>
		</td>
		<td class="textsmall" valign="top">
			<font size="2" face="Arial, Helvetica, sans-serif">
				#LSDateFormat(strQuoteSystem.QuoteDate,'M/DD/YY')#
			</font>
		</td>
	</tr>

	<cfif isNumeric(strQuoteSystem.ShippingEstimate) AND strQuoteSystem.ShippingCriteria IS NOT "(Ship to , , )">
        <tr>
			<td colspan="2">
        		<table width="100%" border="0" cellspacing="0" cellpadding="3">
					<tr>
                        <td width="38%" valign="top" bgcolor="F3F3F3">
                            <div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><strong>
                                Estimated Shipping:
                            </strong></font></div>
                        </td>
                        <td width="13%" class="textsmall" valign="top" bgcolor="F3F3F3">
                            <font size="2" face="Arial, Helvetica, sans-serif">
                                #dollarFormat(strQuoteSystem.ShippingEstimate)#
                            </font>
                        </td>
                        <td class="textsmall" valign="top" bgcolor="F3F3F3">
                            <font size="2" face="Arial, Helvetica, sans-serif">
								<cfif trim(strQuoteSystem.ShippingCriteria) IS NOT "">
                                 	#strQuoteSystem.ShippingCriteria#
								<cfelse>
                                	&nbsp;
		                        </cfif>
                            </font>
                        </td>
                    </tr>
				</table>
            </td>
        </tr>
	</cfif>
<!---
	<cfif isNumeric(strQuoteSystem.AdditionalWarrantyAmount)>
        <tr>
			<td colspan="2">
        		<table width="100%" border="0" cellspacing="0" cellpadding="3">
					<tr>
                        <td width="38%" valign="top" bgcolor="F3F3F3">
                            <div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><strong>
                                Depot Warranty:
                            </strong></font></div>
                        </td>
                        <td width="13%" class="textsmall" valign="top" bgcolor="F3F3F3">
                            <font size="2" face="Arial, Helvetica, sans-serif">
                                #dollarFormat(strQuoteSystem.AdditionalWarrantyAmount)#
                            </font>
                        </td>
                        <td class="textsmall" valign="top" bgcolor="F3F3F3">
                            <font size="2" face="Arial, Helvetica, sans-serif">
                                <cfif trim(strQuoteSystem.AdditionalWarrantyName) IS NOT "">
                                    (#strQuoteSystem.AdditionalWarrantyName#)
                                <cfelse>
                                    &nbsp;
                                </cfif>
                            </font>
                        </td>
                    </tr>
				</table>
            </td>
        </tr>
	</cfif>
--->    

	<!--- SYSTEM SUMMARY --->
	<cfset BackGroundColor = "">

	<cfif NOT PartsOnly>
        <tr>
            <td valign="top" colspan="2">
                <table width="100%" border="0" cellpadding="6" cellspacing="0">
    <!---
                    <tr>
                        <td valign="middle" height="25px" align="center" colspan="2" class="systemName">System Summary</td>
                    </tr>
    --->	
    
                    <tr>
                        <td align="right" style="font-weight:bold" class="systemCategory"><font size="2" color="0000FF">Category</font></td>
                        <td align="center" style="font-weight:bold" class="systemCategory"><font size="2" color="0000FF">Quantity</font></td>
                        <td style="font-weight:bold" class="systemCategory"><font size="2" color="0000FF">Item</font></td>
                    </tr>
                    <tr><td colspan="3"><hr></td></tr>
                    <cfloop query="qryQuoteComponents">
                        <cfif qryQuoteComponents.CurrentRow MOD 2 EQ 0>
                            <cfset BackGroundColor = "">
                        <cfelse>
                            <cfset BackGroundColor = "F3F3F3">
                        </cfif>
                        <tr>
                            <!--- CATEGORY LABEL --->
                            <td valign="middle" align="right" width="39%" class="systemCategory" bgcolor="#BackGroundColor#">
                                <font size="2" face="Arial, Helvetica, sans-serif"><strong>
                                    #qryQuoteComponents.TypeName#:
                                </strong></font>
                            </td>
    
                            <!--- QUANTITY --->
                            <td width="5%" align="center" class="systemCategory" bgcolor="#BackGroundColor#"><strong><font size="2">#qryQuoteComponents.Quantity#</font></strong></td>
    
                            <!--- SELECTED COMPONENT --->
                            <td valign="middle" align="left" class="textsmall" bgcolor="#BackGroundColor#">
                                <font size="2" face="Arial, Helvetica, sans-serif">
                                    #qryQuoteComponents.ITEMDESC#
                                </font>
                            </td>
    
                        </tr>
                    </cfloop>                        

					<!--- DEPOT WARRANTY --->
                    <cfif isNumeric(strQuoteSystem.AdditionalWarrantyAmount)>
                        <tr>
                            <!--- CATEGORY LABEL --->
                            <td valign="middle" align="right" width="39%" class="systemCategory" bgcolor="#BackGroundColor#">
                                <font size="2" face="Arial, Helvetica, sans-serif"><strong>
                                    Depot Warranty:
                                </strong></font>
                            </td>
                            <!--- QUANTITY --->
                            <td width="5%" align="center" class="systemCategory" bgcolor="#BackGroundColor#"><strong><font size="2">1</font></strong></td>
                            <!--- SELECTED COMPONENT --->
                            <td valign="middle" align="left" class="textsmall" bgcolor="#BackGroundColor#">
                                <font size="2" face="Arial, Helvetica, sans-serif">
                                    #strQuoteSystem.AdditionalWarrantyName#
                                </font>
                            </td>
                        </tr>
                    </cfif>
                    
                </table>
            </td>
        </tr>
        
	<!--- PARTS-ONLY QUOTE --->
    <cfelse>
        <tr>
            <td valign="top" colspan="2">
                <table width="100%" border="0" cellpadding="6" cellspacing="0">    
                    <tr>
                        <td align="left" style="font-weight:bold" class="systemCategory"><font size="2" color="0000FF">Part</font></td>
                        <td align="left" style="font-weight:bold" class="systemCategory"><font size="2" color="0000FF">Description</font></td>
                        <td align="center" style="font-weight:bold" class="systemCategory"><font size="2" color="0000FF">Price</font></td>
                        <td align="center" style="font-weight:bold" class="systemCategory"><font size="2" color="0000FF">Quantity</font></td>
                        <td align="center" style="font-weight:bold" class="systemCategory"><font size="2" color="0000FF">Total</font></td>
                    </tr>
                    <tr><td colspan="5"><hr></td></tr>
                    <cfloop query="qryQuoteComponents">
                        <cfif qryQuoteComponents.CurrentRow MOD 2 EQ 0>
                            <cfset BackGroundColor = "">
                        <cfelse>
                            <cfset BackGroundColor = "F3F3F3">
                        </cfif>
                        <tr>
                            <!--- ITEM --->
                            <td valign="middle" align="left" class="systemCategory" bgcolor="#BackGroundColor#">
                                <font size="2" face="Arial, Helvetica, sans-serif"><strong>
                                    #qryQuoteComponents.ITEMNO#
                                </strong></font>
                            </td>
                            <!--- DESCRIPTION --->
                            <td valign="middle" align="left" class="textsmall" bgcolor="#BackGroundColor#">
                                <font size="2" face="Arial, Helvetica, sans-serif">
                                    #qryQuoteComponents.ITEMDESC#
                                </font>
                            </td>
                            <!--- PRICE --->
                            <td valign="middle" align="center" class="textsmall" bgcolor="#BackGroundColor#">
                                <font size="2" face="Arial, Helvetica, sans-serif">
                                    #dollarFormat(qryQuoteComponents.SellingPrice)#
                                </font>
                            </td>
                            <!--- QUANTITY --->
                            <td valign="middle" align="center" class="textsmall" bgcolor="#BackGroundColor#">
                                <font size="2" face="Arial, Helvetica, sans-serif">
                                    #qryQuoteComponents.Quantity#
                                </font>
                            </td>
                            <!--- TOTAL --->
                            <td valign="middle" align="center" class="textsmall" bgcolor="#BackGroundColor#">
                                <font size="2" face="Arial, Helvetica, sans-serif">
                                    #dollarFormat(qryQuoteComponents.SellingPrice * qryQuoteComponents.Quantity)#
                                </font>
                            </td>
                        </tr>
                    </cfloop>                        
                </table>
            </td>
        </tr>
 	</cfif>
    
    
	<!--- RESELLER'S PO NUMBER --->
<!---
	<tr>
		<td valign="top" <cfif BackGroundColor IS "">bgcolor="F3F3F3"</cfif>>
			<div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><strong>
				Purchase Order Number:
			</strong></font></div>
		</td>
		<td class="textsmall" valign="top" <cfif BackGroundColor IS "">bgcolor="F3F3F3"</cfif>>
			<font size="2" face="Arial, Helvetica, sans-serif">
				#strQuoteSystem.ResellerPONumber#
			</font>
		</td>
	</tr>
--->

	<!--- RESELLER'S COMMENTS --->
	<tr>
		<td valign="top" <cfif BackGroundColor IS NOT "F3F3F3">bgcolor="F3F3F3"</cfif>>
			<div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><strong>
				Comments:
			</strong></font></div>
		</td>
		<td class="textsmall" valign="top" <cfif BackGroundColor IS NOT "F3F3F3">bgcolor="F3F3F3"</cfif>>
			<font size="2" face="Arial, Helvetica, sans-serif">
				#strQuoteSystem.ResellerComments#
			</font>
		</td>
	</tr>

	<cfif isBoolean(strQuoteSystem.CustomerQuote) AND strQuoteSystem.CustomerQuote EQ 1>

		<tr><td>&nbsp;</td></tr>
		<tr>
			<td class="productTitle" colspan="2">
				<span class="pagetitle">
					This quote was entered by the following customer of yours:
				</span>
			</td>
		</tr>
			
		<tr valign="top">
			<td class="textsmall"><div align="right"><font size="2" face="Arial, Helvetica, sans-serif">
				<strong>Name:<br></strong></font></div>
			</td>
			<td class="textsmall"><font size="2" face="Arial, Helvetica, sans-serif">
				#strQuoteSystem.CustFirstName# #strQuoteSystem.CustLastName#</font>
			</td>
		</tr>
		
		<tr valign="top" bgcolor="F3F3F3">
			<td class="textsmall"><div align="right"><font size="2" face="Arial, Helvetica, sans-serif">
				<strong>Title:<br></strong></font></div>
			</td>
			<td><font size="2" face="Arial, Helvetica, sans-serif">
				#strQuoteSystem.CustTitle#</font>
			</td>
		</tr>
		
		<tr valign="top">
			<td class="textsmall"><div align="right"><font size="2" face="Arial, Helvetica, sans-serif">
				<strong>Company:<br></strong></font></div>
			</td>
			<td class="textsmall"><font size="2" face="Arial, Helvetica, sans-serif">
				#strQuoteSystem.CustCompany#</font>
			</td>
		</tr>
		
		<tr valign="top" bgcolor="F3F3F3">
			<td class="textsmall"><div align="right"><font size="2" face="Arial, Helvetica, sans-serif">
				<strong>Address:<br></strong></font></div>
			</td>
			<td><font size="2" face="Arial, Helvetica, sans-serif">

				<cfif trim(strQuoteSystem.CustAddress1) IS NOT "" OR
					  trim(strQuoteSystem.CustAddress2) IS NOT "" OR
					  trim(strQuoteSystem.CustCity) IS NOT "" OR
					  trim(strQuoteSystem.CustState) IS NOT "" OR
					  trim(strQuoteSystem.CustZip) IS NOT "">
					<cfif trim(strQuoteSystem.CustAddress1) IS NOT "">
						#strQuoteSystem.CustAddress1#<br>
					</cfif>
					<cfif trim(strQuoteSystem.CustAddress2) IS NOT "">
						#strQuoteSystem.CustAddress2#<br>
					</cfif>
					<cfif trim(strQuoteSystem.CustCity) IS NOT "">
						#strQuoteSystem.CustCity#
					</cfif>
					<cfif trim(strQuoteSystem.CustState) IS NOT "">
						, #strQuoteSystem.CustState#
					</cfif>
					<cfif trim(strQuoteSystem.CustZip) IS NOT "">
						, #strQuoteSystem.CustZip#
					</cfif>
				</cfif>

				</font>
			</td>
		</tr>
		
		<cfif strQuoteSystem.CustIsPOBox EQ 1>
			<tr valign="top" bgcolor="F3F3F3">
				<td></td>
				<td class="textsmall">
					<font size="2" face="Arial, Helvetica, sans-serif">* This address is a PO Box</font><br>
					&nbsp;<br>
				</td>
			</tr>
		</cfif>
		
		<tr valign="top">
			<td class="textsmall"><div align="right"><font size="2" face="Arial, Helvetica, sans-serif">
				<strong>Email:<br></strong></font></div>
			</td>
			<td class="textsmall">
				<font size="2" face="Arial, Helvetica, sans-serif">
<!---				<a href="mailto:#strQuoteSystem.CustEmail#">	--->
						#strQuoteSystem.CustEmail#
<!---				</a>	--->
				</font>
			</td>
		</tr>


		<tr valign="top" bgcolor="F3F3F3">
			<td class="textsmall"><div align="right"><font size="2" face="Arial, Helvetica, sans-serif">
				<strong>Phone:<br></strong></font></div>
			</td>
			<td class="textsmall"><font size="2" face="Arial, Helvetica, sans-serif">
				
					#strQuoteSystem.CustPhone#
					<cfif trim(strQuoteSystem.CustPhoneExtension) IS NOT "">
						&nbsp;&nbsp; (Ext. #strQuoteSystem.CustPhoneExtension#)
					</cfif>
				</font>
			</td>
		</tr>
		
		<tr valign="top">
			<td class="textsmall"><div align="right"><font size="2" face="Arial, Helvetica, sans-serif">
				<strong>Customer's Comments:<br></strong></font></div>
			</td>
			<td><font size="2" face="Arial, Helvetica, sans-serif">
				#strQuoteSystem.CustComments#</font>
			</td>
		</tr>

		<tr valign="top" bgcolor="F3F3F3">
			<td class="textsmall"><div align="right"><font size="2" face="Arial, Helvetica, sans-serif">
				<strong>Customer's PO Number:<br></strong></font></div>
			</td>
			<td class="textsmall"><font size="2" face="Arial, Helvetica, sans-serif">
				#strQuoteSystem.CustPONumber#</font>
			</td>
		</tr>

		<cfif strQuoteSystem.CustNoContact EQ 1>
			<tr valign="top">
				<td></td>
				<td class="textsmall">
					<font size="2" face="Arial, Helvetica, sans-serif">* This customer does not wish to be contacted</font><br>
					&nbsp;<br>
				</td>
			</tr>
		</cfif>
		
		<tr valign="top">
			<td><div align="right"><font color="0033CC" size="4" face="Arial, Helvetica, sans-serif">
				<strong>Customer's Price:<br></strong></font></div>
			</td>
			<td>
				<strong><font color="0033CC" size="4" face="Verdana, Arial, Helvetica, sans-serif">
					#dollarFormat(strQuoteSystem.CustPrice)#
				</font></strong>
			</td>
		</tr>

		<tr valign="top" bgcolor="F3F3F3">
			<td><div align="right"><font color="0033CC" size="4" face="Arial, Helvetica, sans-serif">
				<strong>Customer's Total:<br></strong></font></div>
			</td>
			<td>
				<strong><font color="0033CC" size="4" face="Verdana, Arial, Helvetica, sans-serif">
					#dollarFormat(strQuoteSystem.CustTotal)#
				</font></strong>
			</td>
		</tr>

	</cfif>


	<tr>
		<td colspan="2" class="textsmall">
			<font color="000000">
				Click &quot;submit quote&quot; to send it to your sales representative
			</font>
			<font color="000000">.</font><font color="FF0000">
				The total cost listed above is an estimate only. It does not include shipping and handling costs. 
				Your sales representative will contact you shortly with your final cost quote.
			</font>
		</td>
	</tr>
    
    <tr>
        <td colspan="2">
        <table width="75%" border="0" align="center" cellpadding="6" cellspacing="0">
        <tr>
            <!--- DELETE QUOTE --->
            <cfif NOT SESSION.UserOnVacation>
                <td align="center">
                    <form name="form1a" method="POST" action="index.cfm?task=quote_delete">
                    <input name="QuoteSystemID" type="hidden" value="#strQuoteSystem.QuoteSystemID#">
                    <input name="QuoteSubmitted" type="hidden" value="#strQuoteSystem.QuoteSubmitted#">
                    <input name="" type="image" src="http://partners.nor-tech.com/images/deleteQuote.gif" alt="Delete Quote" onclick="return confirmDelete()" width="100" height="28">
                    </form>
                </td>
            </cfif>
            
            <!--- UPDATE QUOTE --->
<!---      <cfif strQuoteSystem.ConfigSystemID IS NOT "">	
                <cfset strConfigSystem = objConfigSystems.getRecord(strQuoteSystem.ConfigSystemID)>
                <cfif NOT structIsEmpty(strConfigSystem)>	
--->							
                    <td align="center">
                        <form name="form1b" method="POST" action="index.cfm?task=quote_update">
                        <input name="QuoteSystemID" type="hidden" value="#strQuoteSystem.QuoteSystemID#">
                        <input name="ConfigSystemID" type="hidden" value="#strQuoteSystem.ConfigSystemID#">
                        <input name="" type="image" src="http://partners.nor-tech.com/images/updateQuote.gif" alt="Update Quote" onclick="return confirmUpdate()" width="100" height="28">
                        </form>
                    </td>
<!---           </cfif>
	       </cfif>	--->
            
            <!--- SUBMIT QUOTE --->
            <td align="center">
                <form name="form1" method="POST" action="index.cfm?task=quote_submit_selectEmails">
                <input name="QuoteSystemID" type="hidden" value="#strQuoteSystem.QuoteSystemID#">
                <input name="QuoteSubmitted" type="hidden" value="#strQuoteSystem.QuoteSubmitted#">
                <input name="" type="image" src="http://partners.nor-tech.com/images/submitQuote.gif" alt="Submit Quote" onclick="return confirmSubmit()" width="100" height="28">
                </form>
            </td>
            
            <!--- EMAIL QUOTE --->
            <td align="center" valign="top">
                <a href="index.cfm?task=config_dyn_email_form&QuoteSystemID=#urlEncodedFormat(strQuoteSystem.QuoteSystemID)#">
                    <img src="http://partners.nor-tech.com/images/emailquote.gif" border="0" width="100" height="28">
                </a>
            </td>
			
			<td align="center" valign="top">
				<a href="index.cfm?task=quotes_new1&QuoteSystemID=#urlEncodedFormat(strQuoteSystem.QuoteSystemID)#&CopyingQuote=1&Cpyx=1&RequestTimeout=6000">
					<img src="http://partners.nor-tech.com/images/copyQuoteBtn.gif" border="0" width="100" height="28">
				</a>
			</td>
            
        </tr>
        </table>
        </td>
    </tr>
        

	<tr>
		<td colspan="2">
			<div align="center" class="textsmall">
				<a href="index.cfm?task=quotes_list">
					Click here to return to quote list <cfif strQuoteSystem.SalesRepQuote EQ 0>without submitting order</cfif>                    
				</a>
			</div>
		</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
</table>
</cfoutput>