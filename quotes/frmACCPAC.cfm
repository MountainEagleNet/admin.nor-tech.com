<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	12/11/2008
	Function: 		This page displays details for an invoice in ACCPAC
	Template:		lstACCPAC .cfm
	Task:			quotes_new_lstACCPAC
--->
<cfset objOrders = createObject("component", "partners.orders.assets.cfcs.Orders")>
<cfset objOEVIA = createObject("component", "admin.assets.cfcs.OEVIA")>
<cfset objOECOINI = createObject("component", "admin.assets.cfcs.OECOINI")>


<cfset qryOEINVH = objOrders.getInvoiceMain(URL.INVUNIQ)>
<cfset qryOEINVD = objOrders.getInvoiceDetails(URL.INVUNIQ)>

<!--- Get Shipper Name / Method from ACCPAC table OEVIA --->
<cfset ShippingMethod = objOEVIA.getShippingMethod(qryOEINVH.SHIPVIA)>
<cfset TrackingNumber = objOECOINI.getTrackingNumber(qryOEINVH.INVUNIQ)>

<cfset TrackingURL = objOECOINI.getTrackingURL(ShippingMethod, TrackingNumber)>
<cfset Subtotal = 0>
<cfset ShippingHandling = 0>

<!---
<cfdump var="#qryOEINVH#">
<cfdump var="#qryOEINVD#">
<cfabort>
--->

<cfoutput>
	<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
	<form name="CreateQuote" action="index.cfm?task=quotes_new_actACCPAC" method="post">
	<input type="hidden" name="INVUNIQ" value="#URL.INVUNIQ#">

        <tr><!--- Page Title --->
            <td valign="top" class="subpagetitle">ACCPAC Invoice Details</td>
        </tr>
    
        <tr><!--- Instructions --->
            <td valign="top" class="textmain" colspan="2">
                This page displays invoice details for the invoice you selected.  Click the "Create Quote" button to continue creating a quote from this invoice.
            </td>
        </tr>
    
		<!--- spacer --->
        <tr>
            <td class="textsmall" colspan="2">&nbsp;</td>
        </tr>
        
        <!--- CREATE QUOTE BUTTON --->
        <tr>
            <td align="center" class="textsmall" colspan="2">
                <input type="submit" name="CreateQuote" value="Create Quote">
            </td>
        </tr>
        
        
        <!--- links --->
        <tr>
            <td class="textsmall" colspan="2" align="right">
                <cfif TrackingURL IS NOT "">
                    <a href="#TrackingURL#" target="_blank">Track Shipment</a><br>
                </cfif>
            </td>
        </tr>
        <!--- header --->
        <tr>
            <td class="textsmall" colspan="2" align="right">
                #qryOEINVH.Customer#<br>
                #qryOEINVH.InvNumber#<br>
            </td>
        </tr>
        <!--- shipping and billing --->
        <tr>
            <td class="textsmall" align="left" valign="top">
                #qryOEINVH.BilName#<br>
                #qryOEINVH.BilAddr1#<br>
                <cfif len(qryOEINVH.BilAddr2)>#qryOEINVH.BilAddr2#<br></cfif>
                <cfif len(qryOEINVH.BilAddr3)>#qryOEINVH.BilAddr3#<br></cfif>
                <cfif len(qryOEINVH.BilAddr4)>#qryOEINVH.BilAddr4#<br></cfif>
                #qryOEINVH.BilCity#, #qryOEINVH.BilState# #qryOEINVH.BilZip#<br>
            </td>
            
            <td class="textsmall" align="left" valign="top">
                #qryOEINVH.ShpName#<br>
                #qryOEINVH.ShpAddr1#<br>
                <cfif len(qryOEINVH.ShpAddr2)>#qryOEINVH.ShpAddr2#<br></cfif>
                <cfif len(qryOEINVH.ShpAddr3)>#qryOEINVH.ShpAddr3#<br></cfif>
                <cfif len(qryOEINVH.ShpAddr4)>#qryOEINVH.ShpAddr4#<br></cfif>
                #qryOEINVH.ShpCity#, #qryOEINVH.ShpState# #qryOEINVH.ShpZip#<br>
    
            </td>
        </tr>
        <!--- spacer --->
        <tr>
            <td class="textsmall" colspan="2">&nbsp;
                    
            </td>
        </tr>
        <!--- main invoice detail --->
        <!--- order/invoice information --->
        <tr>
            <td class="textsmall" colspan="2">
                <table width="80%" border="0" align="center" cellpadding="3" cellspacing="1">
                <tr>
                    <td class="textsmall" align="left">#qryOEINVH.ViaDesc#</td>
                    <td class="textsmall" align="left">#objOrders.DateFix(qryOEINVH.InvDate)#</td>
                    <td class="textsmall" align="left">NCTI</td>
                    <td class="textsmall" align="left">#qryOEINVH.OrdNumber#</td>
                </tr>
                <tr>
                    <td class="textsmall" align="left">#qryOEINVH.PONumber#</td>
                    <td class="textsmall" align="left">#objOrders.DateFix(qryOEINVH.OrdDate)#</td>
                    <td class="textsmall" align="left">#qryOEINVH.Terms#</td>
                    <td class="textsmall" align="left">#qryOEINVH.SalesPer1#</td>
                </tr>
                </table>
            </td>
        </tr>
        <!--- spacer --->
        <tr>
            <td class="textsmall" colspan="2">&nbsp;
                    
            </td>
        </tr>
        <!--- shipping and billing --->
        <tr>
            <td class="textsmall" colspan="2">
                <table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
                <cfloop query="qryOEINVD">
                    <tr>
                        <td class="textsmall" valign="top">#Round(qryOEINVD.QtyOrdered)#</td>
                        <td class="textsmall" valign="top">#Round(qryOEINVD.QtyShipped)#</td>
                        <td class="textsmall" valign="top">#Round(qryOEINVD.QtyBackOrd)#</td>
                        <td class="textsmall" valign="top">#qryOEINVD.Item#</td>
                        <td class="textsmall" valign="top">#qryOEINVD.Desc#</td>
                        <td class="textsmall" align="right" valign="top">
                            <cfif trim(qryOEINVD.Desc) NEQ "SHIPPING & HANDLING">
                                #DollarFormat(qryOEINVD.ItemPrice)# EA
                            <cfelse>
                                &nbsp;
                            </cfif>					
                        </td>
                        <td class="textsmall" align="right" valign="top">
                            <cfif trim(qryOEINVD.Desc) NEQ "SHIPPING & HANDLING">
                                #DollarFormat(qryOEINVD.TotalPriceForLine)#
                            <cfelse>
                                #DollarFormat(qryOEINVD.ExtInvMisc)#
                            </cfif>
                        </td>
                    </tr>
                    
                    <!--- SERIAL NUMBERS --->
                    <cfif qryOEINVH.INVDATE LT 20061101 
                          <!--- vvv  10/18/06: temporarily added to show sales reps new serial number info   vvv --->
                          AND qryOEINVH.Customer IS NOT "O003"
                        >
                        <cfset SerialNumberList = objOrders.getComment(qryOEINVD.INVUNIQ, qryOEINVD.DETAILNUM)>
                    <cfelse>
                        <cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>
                        <cfset SerialNumberList = objSerialsShipments.getSerialNumberList(qryOEINVD.INVUNIQ, qryOEINVD.LINENUM)>
                    </cfif>
                    <cfif trim(SerialNumberList) IS NOT "">
                        <tr>
                            <td class="textsmall" colspan="4">&nbsp;</td>
                            <td class="textsmall" colspan="3">#SerialNumberList#</td>
                        </tr>
                    </cfif>
                    
                    <!--- handle totalling --->
                    <cfif trim(qryOEINVD.Desc) IS NOT "SHIPPING & HANDLING" AND trim(qryOEINVD.Desc) IS NOT "Shipping">
                        <cfset Subtotal = Subtotal + qryOEINVD.TotalPriceForLine>
                    <cfelse>
                        <cfset ShippingHandling = ShippingHandling + qryOEINVD.ExtInvMisc>
                    </cfif>
                </cfloop>
                <!--- spacer --->
                <tr>
                    <td colspan="7" class="textsmall" align="right">&nbsp;
                        
                    </td>
                </tr>
    
                <!--- STARSHIP SHIPPING INFORMATION --->
                <tr>
                    <td class="textsmall" colspan="7">
                        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
                            <tr>
                                <td class="textsmall" colspan="2">SHIPPING INFORMATION:</td>
                            </tr>
                            <tr>
                                <td class="textsmall" width="23%">CARRIER:</td>
                                <td class="textsmall">#ShippingMethod#</td>
                            </tr>
                            <tr>
                                <td class="textsmall">DATE:</td>
                                <td class="textsmall">#dateFormat(objOrders.DateFix(qryOEINVH.ShipDate), 'MMMM DD, YYYY')#</td>
                            </tr>
                            <tr>
                                <td class="textsmall">TRACKING NUMBER:</td>
                                <td class="textsmall">
                                    <cfif TrackingNumber IS "">
                                        N/A
                                    <cfelse>
                                        <cfif TrackingURL IS NOT "">
                                            <a href="#TrackingURL#" target="_blank">#TrackingNumber#</a>
                                        <cfelse>
                                            #TrackingNumber#
                                        </cfif>
                                    </cfif>
                                </td>
                            </tr>
                            <cfif TrackingNumber IS "" OR TrackingURL IS "">
                                <tr>
                                    <td class="textsmall" colspan="2">
                                        <i>Contact your Nor-Tech sales rep for tracking information</i>
                                    </td>
                                </tr>
                            </cfif>
                        </table>
                    </td>
                </tr>
                
                
                <!--- totals --->
                <cfset AmountDue = Subtotal + ShippingHandling>
                <!--- spacer --->
                <tr>
                    <td colspan="7" class="textsmall" align="right">&nbsp;
                        
                    </td>
                </tr>
                <!--- display totals --->
                <tr>
                    <td colspan="6" class="textsmall" align="right">
                        <strong>SUBTOTAL</strong><br>
                    </td>
                    <td class="textsmall" align="right">
                        #DollarFormat(VARIABLES.Subtotal)#<br>
                    </td>
                </tr>
                <tr>
                    <td colspan="6" class="textsmall" align="right">
                        <strong>SHIPPING AND HANDLING</strong><br>
                    </td>
                    <td class="textsmall" align="right">
                        #DollarFormat(VARIABLES.ShippingHandling)#<br>
                    </td>
                </tr>
                <tr>
                    <td colspan="6" class="textsmall" align="right">
                        <strong>AMOUNT DUE</strong><br>
                    </td>
                    <td class="textsmall" align="right">
                        #DollarFormat(VARIABLES.AmountDue)#<br>
                    </td>
                </tr>
                </table>
            </td>
        </tr>
        
    </form>
    </table>
</cfoutput>