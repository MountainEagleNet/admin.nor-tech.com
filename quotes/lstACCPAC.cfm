<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	12/08/2008
	Function: 		This page displays a list of invoices in ACCPAC
	Template:		lstACCPAC .cfm
	Task:			quotes_new_lstACCPAC
--->
	<cfset objOEINVH = createObject("component", "admin.assets.cfcs.OEINVH")>
	<cfset Error = "">

	<cfset SearchRecord = structNew()>
    <cfset ShowTheList = 0>
	<cfif isDefined("FORM.ProcessSearch")>
		<cfif trim(FORM.CUSTOMER) IS NOT "">
			<cfset structInsert(SearchRecord, "CUSTOMER", FORM.CUSTOMER, True)>
		</cfif>
		<cfif trim(FORM.BILNAME) IS NOT "">
			<cfset structInsert(SearchRecord, "BILNAME", FORM.BILNAME, True)>
		</cfif>
		<cfif trim(FORM.INVNUMBER) IS NOT "">
			<cfset structInsert(SearchRecord, "INVNUMBER", FORM.INVNUMBER, True)>
		</cfif>
		<cfif trim(FORM.ITEM) IS NOT "">
			<cfset structInsert(SearchRecord, "ITEM", FORM.ITEM, True)>
		</cfif>
		<cfif trim(FORM.DESC) IS NOT "">
			<cfset structInsert(SearchRecord, "DESC", FORM.DESC, True)>
		</cfif>
		<cfif isDefined("FORM.SystemOrdersOnly")>
			<cfset structInsert(SearchRecord, "SystemOrdersOnly", 1, True)>
		</cfif>
		<cfif isNumeric(trim(FORM.NumberToDisplay))>
			<cfset structInsert(SearchRecord, "NumberToDisplay", trim(FORM.NumberToDisplay), True)>
		</cfif>

		<cfset qryOEINVH = objOEINVH.searchInvoices(SearchRecord)>
    	<cfset ShowTheList = 1>	
	</cfif>
	
</cfsilent>

<script language="javascript">
function showWarning() {
	document.getElementById("NoItem").style.display = "block";
}
//-->
</script>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">ACCPAC Invoices</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objOEINVH.getMessage()#</font></td>
</tr>


<tr><!--- Instructions --->
	<td valign="top" class="textmain">
    	Find an invoice that you want to create a quote from by entering information in the fields below.  To search only for completed systems (AC-COMP-BUILD, AC-COMP-SERVER, etc), check the "System Orders Only" box.  When you click "Search", the top 20 invoices will be retrieved that match your criteria.  Select the invoice by clicking the invoice number in the list.
    </td>
</tr>


<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<!---
<tr>
	<td valign="top" class="textmain" colspan="3">
		The following list displays "Software Excluded Items".  These items will not be included in the out-of-stock report that reports backordered items for comp builds.
	</td>
</tr>
--->

<form name="ACCPACSearch" action="index.cfm?task=quotes_new_lstACCPAC&RequestTimeout=6000" method="post">
	<tr>
    	<td>
            <table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
        
                <tr>
                    <td class="textmain" width="28%"><strong>Customer Number:</strong></td>
                    <td class="textmain">
                        <input name="CUSTOMER" size="20" maxlength="50"
                            <cfif isDefined("FORM.CUSTOMER")>
                                value="#FORM.CUSTOMER#"
                            </cfif>
                        >
                    </td>
                </tr>
                <tr>
                    <td class="textmain"><strong>Customer Name:</strong></td>
                    <td class="textmain">
                        <input name="BILNAME" size="20" maxlength="50"
                            <cfif isDefined("FORM.BILNAME")>
                                value="#FORM.BILNAME#"
                            </cfif>
                        >
                    </td>
                </tr>
                <tr>
                    <td class="textmain"><strong>Invoice Number:</strong></td>
                    <td class="textmain">
                        <input name="INVNUMBER" size="20" maxlength="50"
                            <cfif isDefined("FORM.INVNUMBER")>
                                value="#FORM.INVNUMBER#"
                            </cfif>
                        >
                    </td>
                </tr>

                <tr>
                    <td class="textmain"><strong>Item Number:</strong></td>
                    <td class="textmain">
                        <input name="ITEM" size="20" maxlength="50"
                            <cfif isDefined("FORM.ITEM")>
                                value="#FORM.ITEM#"
                            </cfif>
                        >
                    </td>
                </tr>
                <tr>
                    <td class="textmain"><strong>Item Description:</strong></td>
                    <td class="textmain">
                        <input name="DESC" size="20" maxlength="50"
                            <cfif isDefined("FORM.DESC")>
                                value="#FORM.DESC#"
                            </cfif>
                        >
                    </td>
                </tr>

                <tr>
                    <td class="textmain"><strong>System Orders Only?</strong></td>
                    <td class="textmain">
                        <input type="checkbox" name="SystemOrdersOnly" value="1" 
                            <cfif isDefined("FORM.SystemOrdersOnly") AND FORM.SystemOrdersOnly EQ 1>
                                 checked="checked"
                            </cfif>
                         onclick="showWarning()">				
                    </td>
                </tr>
                
                <tr id="NoItem" style="display:none;">
                	<td class="textmain" colspan="2" style="color:FF0000">
                    	<em><strong>NOTE</strong></em>: If you check this box, do NOT enter anything in the "Item Number" or "Item Description" fields above.
                    </td>
                </tr>
                
                <tr>
                    <td class="textmain" colspan="2"><strong>Number of Invoices to Display:</strong><!---</td>
                    <td class="textmain">--->  &nbsp;&nbsp;
                        <input name="NumberToDisplay" size="1" maxlength="50"
                            <cfif isDefined("FORM.NumberToDisplay")>
                                value="#FORM.NumberToDisplay#"
                           	<cfelse>
                                value="20"
                            </cfif>
                        >
                    </td>
                </tr>

				<tr>                
                    <td colspan="2" class="textmain" align="center">
                        <input type="submit" name="ProcessSearch" value="Search">
                    </td>
				</tr>
            </table>          
        </td>    
    </tr>
    
    
        
    
</form>

<cfif ShowTheList>    
    <tr>
        <td valign="top" class="textmain">
            <table cellpadding="2" cellspacing="0" width="100%" border="0">
            
            <!--- LIST HEADINGS --->
            <tr>
           		<td height="18" bgcolor="006633" class="productTitle" width="25%"><font color="FFFFFF">Invoice<br />Number</font></td>
           		<td height="18" bgcolor="006633" class="productTitle" width="25%"><font color="FFFFFF">Customer Number / Name</font></td>
<!---      		<td height="18" bgcolor="006633" class="productTitle" width="25%"><font color="FFFFFF">Customer Name</font></td>	--->
           		<td height="18" bgcolor="006633" class="productTitle" width="25%"><font color="FFFFFF">Invoice<br />Date</font></td>
           		<td height="18" bgcolor="006633" class="productTitle" width="25%"><font color="FFFFFF">Item Number / Description</font></td>
<!---      		<td height="18" bgcolor="006633" class="productTitle" width="25%"><font color="FFFFFF">Description</font></td>	--->
            </tr>
        
            <!--- LIST DATA --->	
            <cfif qryOEINVH.RecordCount EQ 0>
                <tr>
                    <td align="center" colspan="4" class="productTitle">
                    	<font color="FF0000">
                        	No Invoices were found that match your search critera.
						</font>
                	</td>
                </tr>
            </cfif>
            
            <cfloop query="qryOEINVH">
                <tr<cfif qryOEINVH.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
                    <td class="textsmall" align="left">
						<a href="index.cfm?task=quotes_new_frmACCPAC&INVUNIQ=#urlEncodedFormat(qryOEINVH.INVUNIQ)#">
	                    	#qryOEINVH.INVNUMBER#
						</a>
                    </td>
                    <td class="textsmall" align="left">#qryOEINVH.CUSTOMER#<br />#qryOEINVH.BILNAME#</td>
<!---               <td class="textsmall" align="left">#qryOEINVH.BILNAME#</td>	--->
                    <td class="textsmall" align="left">#objOEINVH.formatDate(qryOEINVH.INVDATE)#</td>
        
                    <td class="textsmall" align="left">
                    	<cfif isDefined("qryOEINVH.ITEM")>
                    		#qryOEINVH.ITEM# <br />
                        <cfelse>
                        	&nbsp;
                        </cfif>
<!---
                    </td>
                    <td class="textsmall" align="left">
--->
                    	<cfif isDefined("qryOEINVH.DESC")>
                    		#qryOEINVH.DESC#
                        <cfelse>
                        	&nbsp;
                        </cfif>
               		</td>
                </tr>
            </cfloop>
        
            </table>
        </td>
    </tr>
</cfif>

</table>
</cfoutput>