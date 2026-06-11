<!--- refresh every rSeconds 6-26-2005 - Nic Tunney --->
<!---
<cfset rSeconds = 5>
<cfoutput>
	<meta http-equiv="refresh" content="#rSeconds#">
</cfoutput>
--->

<table width="94%" border="0" cellspacing="2" cellpadding="0">
<cfif CGI.CF_TEMPLATE_PATH NEQ "#VARIABLES.AdminDirPath#frmLogin.cfm" AND CGI.CF_TEMPLATE_PATH NEQ "#VARIABLES.AdminDirPath#actLogin.cfm">

	<cfif SESSION.Role IS NOT "Warehouse" AND SESSION.Role IS NOT "RMA" AND SESSION.Role IS NOT "Data Entry">
		<tr>
			<td width="6%">&nbsp;</td>
			<td width="94%" class="textleftnav"><a href="index.cfm">&gt; Admin Main</a></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td class="textleftnav"><a href="index.cfm?task=admin_custaccounts_search">&gt; Customer Search</a></td>
		</tr>
        
        <cfif NOT SESSION.UserOnVacation>
            <!---
			<tr>
                <td>&nbsp;</td>
                <td class="textleftnav">&nbsp;&nbsp;&#8226; <a href="index.cfm?task=admin_accounts_incomplete">Incomplete Accounts</a></td>
            </tr>
			<tr>
                <td>&nbsp;</td>
                <td class="textleftnav"><a href="index.cfm?task=admin_custaccounts_new">&gt; Add a New Customer</a></td>
            </tr>
            --->
			<cfif SESSION.Role IS "Sales Rep">
                <tr>
                    <td>&nbsp;</td>
                    <td class="textleftnav"><a href="index.cfm?task=admin_freightestimator_frm">&gt; Set Freight Estimator</a></td>
                </tr>
            </cfif>
        </cfif>
	</cfif>
	
	<cfif SESSION.Role IS "Administrator">
		<!---
		<tr>
			<td>&nbsp;</td>
			<td class="textleftnav"><a href="index.cfm?task=admin_accounts_list">&gt; Nor-Tech Users</a></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td class="textleftnav"><a href="index.cfm?task=admin_accounts_import_landing">&gt; AccPac Import</a></td>
		</tr>
		--->
	</cfif>
    
	<cfif NOT SESSION.UserOnVacation AND (SESSION.Role IS "Administrator" OR SESSION.Role IS "Sales Rep")>
        <!---
		<tr>
            <td>&nbsp;</td>
            <td class="textleftnav"><a href="index.cfm?task=admin_password_form">&gt; My Account</a></td>
        </tr>
		--->
    </cfif>
    

	<!--- ========================== --->
	<!---    DYNAMIC CONFIGURATOR    --->
	<!--- ========================== --->

	<cfif SESSION.Role IS "Administrator" OR SESSION.Role IS "Sales Rep">
		<tr>
			<td>&nbsp;</td>
			<td class="textleftnav" style="font-size:12px"><b><br>Configurator</font></b></td>
		</tr>
	</cfif>

	<!--- DEFAULT SYSTEMS --->
	<cfif SESSION.Role IS "Administrator">
		<tr>
			<td>&nbsp;</td>
			<td class="textleftnav"><a href="index.cfm?task=config_setup_systems_list&DefaultSystems=1">&gt; Default Systems</a></td>
		</tr>
	</cfif>

	<!--- SERVER OPTIONS --->
	<cfif SESSION.Role IS "Administrator">
		<tr>
			<td>&nbsp;</td>
			<td class="textleftnav"><a href="index.cfm?task=server_options_list">&gt; Server Options</a></td>
		</tr>
	</cfif>

	<!--- SYSTEMS CLASSIFICATIONS --->
	<cfif SESSION.Role IS "Administrator">
		<tr>
			<td>&nbsp;</td>
			<td class="textleftnav"><a href="index.cfm?task=classifications_list">&gt; System Classifications</a></td>
		</tr>
	</cfif>

	<!--- COMPONENT CATEGORIES --->
	<cfif SESSION.Role IS "Administrator">
		<tr>
			<td>&nbsp;</td>
			<td class="textleftnav"><a href="index.cfm?task=config_setup_compcats_list">&gt; Component Categories</a></td>
		</tr>
	</cfif>

	<!--- SYSTEMS --->
	<cfif NOT SESSION.UserOnVacation AND SESSION.Role IS "Sales Rep">
		<tr>
			<td>&nbsp;</td>
			<td class="textleftnav"><a href="index.cfm?task=config_setup_systems_list&DefaultSystems=0">&gt; Systems</a></td>
		</tr>
	</cfif>

	<!--- PRICE LISTS --->
	<cfif SESSION.Role IS "Sales Rep">
		<tr>
			<td>&nbsp;</td>
			<td class="textleftnav"><a href="index.cfm?task=config_pricelists_list&MasterPriceList=0">&gt; Price Lists</a></td>
		</tr>
	</cfif>

	<!--- QUOTES --->
	<cfif SESSION.Role IS "Sales Rep">
		<tr>
			<td>&nbsp;</td>
			<td class="textleftnav"><a href="index.cfm?task=quotes_list">&gt; Quotes</a></td>
		</tr>
	</cfif>

<!---
	<!--- DEFAULT MARKUP PERCENTAGES --->
	<cfif SESSION.Role IS "Sales Rep">
		<tr>
			<td>&nbsp;</td>
			<td class="textleftnav"><a href="index.cfm?task=config_setup_sysmarkup_edit">&gt; Default Markup %</a></td>
		</tr>
	</cfif>
--->	
	
	<!--- MASTER LIST OF SYSTEM PHOTOS --->
	<cfif SESSION.Role IS "Administrator">
		<tr>
			<td>&nbsp;</td>
			<td class="textleftnav"><a href="index.cfm?task=config_setup_photos_list">&gt; System Images</a></td>
		</tr>
	</cfif>

	<!--- MASTER PRICE LIST --->
	<cfif SESSION.Role IS "Administrator">
		<tr>
			<td>&nbsp;</td>
<!---		<td class="textleftnav"><a href="index.cfm?task=config_pricelists_name_edit&PriceListID=MASTERPRICELISTUUID">&gt; Master Price List</a></td>--->
			<td class="textleftnav"><a href="prices/index.cfm?task=config_pricelists_name_edit&PriceListID=MASTERPRICELISTUUID" target="_blank">&gt; Master Price List</a></td>
		</tr>
	</cfif>

	<!--- IMPORT COMPONENTS FROM ACCPAC INTO PRICE LISTS --->
	<cfif SESSION.Role IS "Administrator">
		<tr>
			<td>&nbsp;</td>
			<td class="textleftnav"><a href="index.cfm?task=config_pricelists_import_edit">&gt; Import Components</a></td>
		</tr>
	</cfif>

	<!--- IMPORT CATEGORY DESCRIPTIONS FROM ACCPAC INTO PRICE LISTS --->
	<cfif SESSION.Role IS "Administrator">
		<tr>
			<td>&nbsp;</td>
			<td class="textleftnav"><a href="index.cfm?task=config_pricelists_import_categories_edit">&gt; Import Categories</a></td>
		</tr>
	</cfif>

	<!--- Remove parts from Price Lists that aren’t web-enabled in ACCPAC --->
	<cfif SESSION.Role IS "Administrator">
		<tr>
			<td>&nbsp;</td>
			<td class="textleftnav"><a href="index.cfm?task=config_pricelists_webdisabled_edit">&gt; Web-Disabled Parts</a></td>
		</tr>
	</cfif>

	<!--- PARTS MAINTENANCE --->
	<cfif SESSION.Role IS "Administrator">
		<tr>
			<td>&nbsp;</td>
			<td class="textleftnav"><a href="index.cfm?task=parts_admin_list">&gt; Parts Maintenance</a></td>
		</tr>
	</cfif>

	<!--- MISC PARTS MAINTENANCE --->
	<cfif SESSION.Role IS "Administrator" OR SESSION.Role IS "Sales Rep">
		<tr>
			<td>&nbsp;</td>
			<td class="textleftnav"><a href="index.cfm?task=misc_parts_list">&gt; Misc Parts</a></td>
		</tr>
	</cfif>
	<!--- ADDITIONAL WARRANTY --->
	<cfif SESSION.Role IS "Administrator">
		<tr>
			<td>&nbsp;</td>
			<td class="textleftnav"><a href="index.cfm?task=additionalwarranty_list">&gt; Depot Warranty</a></td>
		</tr>
	</cfif>
    


	
	<!--- ========================== --->
	<!---    SERIALIZATION SYSTEM    --->
	<!--- ========================== --->
	<cfif NOT SESSION.UserOnVacation>
    
		<cfoutput>
        <tr>
            <td>&nbsp;</td>
            <td class="textleftnav" style="font-size:12px"><b><br>Serial Number System</font></b></td>
        </tr>
        
        
        
		<!--- ORDER SEARCH --->
        <cfif SESSION.Role IS "RMA" OR SESSION.salesrepid IS "13">
            <tr>
                <td>&nbsp;</td>
                <td class="textleftnav"><a href="index.cfm?task=admin_orders_frmOrderSearchCust">&gt; Order Search</a></td>
            </tr>
        </cfif>
        
        
        
        
        
        
        
        
        <!--- RECEIPTS --->
        <cfif SESSION.Role IS "Administrator" OR SESSION.Role IS "Receiver" OR SESSION.Role IS "Warehouse" OR SESSION.Role IS "RMA">
    <!---
            <cfset objPORCPH1 = createObject("component", "admin.assets.cfcs.PORCPH1")>
            <cfset qryReceipts = objPORCPH1.listReceipts()>
            <cfif qryReceipts.RecordCount EQ 0>
    --->
                <cfset LinkTitle = "Receipts">
    <!---
            <cfelse>
                <cfset LinkTitle = "Receipts (" & qryReceipts.RecordCount & ")">
            </cfif>
    --->
    <!---
            <cfif NOT isNumeric(APPLICATION.NumberOfReceipts)>
                <cfset LinkTitle = "Receipts">
            <cfelse>
                <cfset LinkTitle = "Receipts (" & APPLICATION.NumberOfReceipts & ")">
            </cfif>
    --->
            <tr>
                <td>&nbsp;</td>
                <td class="textleftnav"><a href="index.cfm?task=serials_receipts_list">&gt; #LinkTitle#</a></td>
            </tr>
        </cfif>
    
        <!--- ORDERS/SHIPMENTS --->
        <cfif SESSION.Role IS "Administrator" OR 
              SESSION.Role IS "Order Puller" OR 
              SESSION.Role IS "Warehouse" OR 
              SESSION.Role IS "RMA" OR 
              SESSION.Role IS "Receiver" OR 
              SESSION.Role IS "Sales Rep">
            <tr>
                <td>&nbsp;</td>
                <td class="textleftnav"><a href="index.cfm?task=serials_orders_enter">&gt; Orders<!---/Invoices---></a></td>
            </tr>
        </cfif>
    
        <!--- SERIAL NUMBER LIST --->
        <cfif SESSION.Role IS "Administrator" OR 
              SESSION.Role IS "Order Puller" OR 
              SESSION.Role IS "Warehouse" OR 
              SESSION.Role IS "RMA" OR 
              SESSION.Role IS "Data Entry" OR 
              SESSION.Role IS "Receiver" OR 
              SESSION.Role IS "Sales Rep">
            <tr>
                <td>&nbsp;</td>
                <td class="textleftnav"><a href="serials/orders/index.cfm?task=serials_attach_order_enter" target="_blank">&gt; Serial Number List</a></td>
            </tr>
        </cfif>
    
        <!--- REPRINT SERIAL NUMBER LIST --->
        <cfif SESSION.Role IS "Administrator" OR 
              SESSION.Role IS "Order Puller" OR 
              SESSION.Role IS "Warehouse" OR 
              SESSION.Role IS "RMA" OR 
              SESSION.Role IS "Data Entry" OR 
              SESSION.Role IS "Receiver" OR 
              SESSION.Role IS "Sales Rep">
            <tr>
                <td>&nbsp;</td>
                <td class="textleftnav"><a href="serials/orders/index.cfm?task=serials_reprint_invoice_enter" target="_blank">&gt; Reprint Serial List</a></td>
            </tr>
        </cfif>
    
        <!--- RETURNS/RMAS --->
        <cfif SESSION.Role IS "Administrator" OR SESSION.Role IS "RMA" OR SESSION.Role IS "Warehouse">
            <tr>
                <td>&nbsp;</td>
                <td class="textleftnav"><a href="index.cfm?task=serials_returns_select">&gt; Returns/RMAs</a></td>
            </tr>
        </cfif>
        
        <!--- RETURNS TO VENDOR --->
        <cfif SESSION.Role IS "Administrator" OR SESSION.Role IS "Warehouse" OR SESSION.Role IS "RMA">
    <!---
            <cfset objPORETH1 = createObject("component", "admin.assets.cfcs.PORETH1")>
            <cfset qryVendorReturns = objPORETH1.listVendorReturns()>
            <cfif qryVendorReturns.RecordCount EQ 0>
    --->
                <cfset LinkTitle = "Returns to Vendor">
    <!---
            <cfelse>
                <cfset LinkTitle = "Returns to Vendor (" & qryVendorReturns.RecordCount & ")">
            </cfif>
    --->		
            <tr>
                <td>&nbsp;</td>
                <td class="textleftnav"><a href="index.cfm?task=serials_returnsvendor_list">&gt; #LinkTitle#</a></td>
            </tr>
        </cfif>
        
        <!--- ADJUSTMENTS --->
        <cfif SESSION.Role IS "Administrator" OR SESSION.Role IS "Warehouse" OR SESSION.Role IS "RMA">
    <!---
            <cfset objICADEH = createObject("component", "admin.assets.cfcs.ICADEH")>
            <cfset qryAdjustments = objICADEH.listAdjustments()>
            <cfif qryAdjustments.RecordCount EQ 0>
    --->
                <cfset LinkTitle = "Adjustments">
    <!---
            <cfelse>
                <cfset LinkTitle = "Adjustments (" & qryAdjustments.RecordCount & ")">
            </cfif>
    --->
            <tr>
                <td>&nbsp;</td>
                <td class="textleftnav"><a href="index.cfm?task=serials_adjustments_list">&gt; #LinkTitle#</a></td>
            </tr>
        </cfif>
        
        <!--- TRANSFERS --->
        <cfif SESSION.Role IS "Administrator" OR SESSION.Role IS "Warehouse" OR SESSION.Role IS "RMA">
    <!---
            <cfset objICTREH = createObject("component", "admin.assets.cfcs.ICTREH")>
            <cfset qryTransfers = objICTREH.listTransfers()>
            <cfif qryTransfers.RecordCount EQ 0>
    --->
                <cfset LinkTitle = "Transfers">
    <!---
            <cfelse>
                <cfset LinkTitle = "Transfers (" & qryTransfers.RecordCount & ")">
            </cfif>
    --->
            <tr>
                <td>&nbsp;</td>
                <td class="textleftnav"><a href="index.cfm?task=serials_transfers_list">&gt; #LinkTitle#</a></td>
            </tr>
        </cfif>
    
        <!--- COUNTS --->
        <cfif SESSION.Role IS "Administrator" OR SESSION.Role IS "Warehouse" OR SESSION.Role IS "RMA">
            <tr>
                <td>&nbsp;</td>
                <td class="textleftnav"><a href="index.cfm?task=serials_counts_enter">&gt; Counts</a></td>
            </tr>
        </cfif>
    
        <!--- CORRECTIONS --->
        <cfif SESSION.Role IS "Administrator" OR SESSION.Role IS "Warehouse" OR SESSION.Role IS "RMA" OR SESSION.Role IS "Receiver" OR SESSION.Role IS "Sales Rep">
            <tr>
                <td>&nbsp;</td>
                <td class="textleftnav"><a href="index.cfm?task=serials_corrections_item_list">&gt; Corrections</a></td>
            </tr>
        </cfif>
    
        <!--- REPORTS --->
        <cfif SESSION.Role IS NOT "Data Entry">
            <tr>
                <td>&nbsp;</td>
                <td class="textleftnav"><a href="index.cfm?task=serials_reports_list">&gt; Reports</a></td>
            </tr>
        </cfif>
    
        <!--- ADMINISTRATION --->
        <cfif SESSION.Role IS "Administrator" OR SESSION.Role IS "Warehouse" OR SESSION.Role IS "RMA" OR SESSION.Role IS "Receiver">
            <tr>
                <td>&nbsp;</td>
                <td class="textleftnav"><a href="index.cfm?task=serials_admin_menu">&gt; Administration</a></td>
            </tr>
        </cfif>

		<!--- PRICE LISTS --->
        <cfif SESSION.Role IS "Warehouse" OR SESSION.Role IS "RMA">
            <tr>
                <td>&nbsp;</td>
                <td class="textleftnav"><a href="index.cfm?task=config_pricelists_list&MasterPriceList=0">&gt; Price Lists</a></td>
            </tr>
        </cfif>
        
        <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        </cfoutput>
    
	</cfif>    
    
<cfelse>
	<tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
</cfif>
</table>