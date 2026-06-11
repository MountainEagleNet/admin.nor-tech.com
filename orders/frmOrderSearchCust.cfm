<cfsilent>
	<!---
	Coded By: Alternative Systems, Inc - Ron Barth
	Create Date: 2/19/2013
	frmOrderSearchCust.cfm
	task: admin_orders_frmOrderSearchCust
	--->
</cfsilent>

<cfset objOrders = createObject("component", "admin.assets.cfcs.orders.Orders")>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<!--- spacer --->
<tr>
	<td class="textsmall">&nbsp;</td>
</tr>
<!---
<tr>
	<td colspan="7" class="pagetitle">
		Orders for #objOrders.getCustomerName(URL.AcctNo)#
	</td>
</tr>
--->
<!---
<tr>
	<td class="textmain">To search orders for this customer, enter criteria below and click 'Search Orders'.</td>
</tr>
--->
<tr><td>&nbsp;</td></tr>

<form name="CustSearchForm" action="index.cfm?task=admin_orders_lstOrderSearch&RequestTimeout=6000" method="post">
<input type="hidden" name="CameFrom" value="frmOrderSearchCust" />
<!---
<input type="hidden" name="AcctNo" value="#URL.AcctNo#" />
--->



	<cfif isDefined("URL.Error") AND (URL.Error IS "BothBlank" OR URL.Error IS "AcctNoNotFound")>
    	<tr>
            <td class="textmain" align="left" style="color:red">
            	<cfif URL.Error IS "AcctNoNotFound">
                	Account Number '<strong>#URL.AcctNo#</strong>' was not found.
            	<cfelse>
                    Enter an Account Number or a Company Name
                </cfif>
            </td>
        </tr>
    </cfif>

	<tr>
		<td class="textmain" align="left">
			<strong>Account Number:</strong><br>
            
            <cfif isDefined("URL.AcctNo")>
            	<cfset FieldValue = URL.AcctNo>
			<cfelse>
            	<cfset FieldValue = "">
            </cfif>
            
			<input name="AcctNo" size="20" maxlength="50" value="#FieldValue#"
				<cfif isDefined("URL.Error") AND (URL.Error IS "BothBlank" OR URL.Error IS "AcctNoNotFound")>
					style="border-top: 2px solid red; border-left: 2px solid red; border-bottom: 1px solid red; border-right: 1px solid red;"
				</cfif>			
            >
		</td>
	</tr>
    
    
    
	<cfif isDefined("URL.Error") AND URL.Error IS NOT "BothBlank" AND URL.Error IS NOT "AcctNoNotFound">
    	<tr>
            <td class="textmain" align="left" style="color:red">
            	<cfif URL.Error IS "CustNotFound">
                	Company '<strong>#URL.Company#</strong>' was not found.
            	<cfelseif URL.Error IS "MulitpleCustsFound">
                	More than one company matched your entry of '<strong>#URL.Company#</strong>'.<br />Please try again, or enter an Account Number above to find an exact match.
                </cfif>
            </td>
        </tr>
    </cfif>
    
	<tr>
		<td class="textmain" align="left">
			<strong>Company Name:</strong><br>
			
            
            <cfif isDefined("URL.Company")>
            	<cfset FieldValue = URL.Company>
			<cfelse>
            	<cfset FieldValue = "">
            </cfif>
            <input name="Company" size="20" maxlength="50" value="#FieldValue#"
				<cfif isDefined("URL.Error") AND URL.Error IS NOT "BothBlank" AND URL.Error IS NOT "AcctNoNotFound">
					style="border-top: 2px solid red; border-left: 2px solid red; border-bottom: 1px solid red; border-right: 1px solid red;"
				</cfif>			
            >
		</td>
	</tr>
	<tr>
		<td class="textmain" align="left">
			<input type="submit" name="ProcessSearch" value="Search Orders">
		</td>
	</tr>
</form>
</table>
</cfoutput>