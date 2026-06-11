<cfsilent>
	<!---
	Coded By: Alternative Systems, Inc - Nicholas Tunney
	Create Date: 7/16/2005
	Edit Date: 
	Function: Allows adding/editing of a customer account
	frmCustAccount.cfm 
	--->
	<cfset objCust = createObject("component", "admin.assets.cfcs.Cust")>
	<cfset objPriceLists = createObject("component", "admin.assets.cfcs.prices.PriceLists")>
	<cfset objAdmin = createObject("component", "admin.assets.cfcs.Admin")>

	<!--- Validation look back --->
	<cfif isDefined("URL.Validation")>
		<cfset stRecord.ID = URL.ID>
		<cfset stRecord.CustomerID = URL.CustomerID>
		<cfset stRecord.AcctNo = URL.AcctNo>

		<cfset stRecord.DefaultAccount = URL.DefaultAccount>

		<cfset stRecord.Company = URL.Company>
		<cfset stRecord.FirstName = URL.FirstName>
		<cfset stRecord.LastName = URL.LastName>
		<cfset stRecord.Email = URL.Email>
		<cfset stRecord.Username = URL.Username>
		<cfset stRecord.Passcode = URL.Passcode>
		<cfset stRecord.SalesRepID = URL.SalesRepID>
		<cfset stRecord.PointsSystem = URL.PointsSystem>
		<cfset stRecord.PointsNotebook = URL.PointsNotebook>
		<cfset stRecord.PointsServer = URL.PointsServer>
		<cfset stRecord.AccessLevel = URL.AccessLevel>
		<cfset stRecord.AccessLevelNew = URL.AccessLevelNew>
		<cfset stRecord.Active = URL.Active>
		<cfset stRecord.DateEmailSent = URL.DateEmailSent>
		<cfset stRecord.SendShipmentConfirmation = URL.SendShipmentConfirmation>
		<cfset stRecord.PriceListID = URL.PriceListID>
		<cfset stRecord.PriceListAccess = URL.PriceListAccess>
		<cfset stRecord.GarageSaleAccess = URL.GarageSaleAccess>
		<cfset stRecord.IntelIDNumber = URL.IntelIDNumber>
		<cfset stRecord.PhoneNumber = URL.PhoneNumber>
		<cfset stRecord.FreightEstimator = URL.FreightEstimator>
		<cfset stRecord.UseClassifications  = URL.UseClassifications>
		<cfset stRecord.ShippingAndTax = URL.ShippingAndTax>
	
	<!--- if we are editing --->
	<cfelseif URL.task EQ "admin_custaccounts_edit" OR URL.task EQ "admin_custaccounts_incomplete_edit">
		<cfset stRecord = objCust.getRecordAsStruct(URLDecode(URL.uid))>
	<!--- otherwise it is a new record --->
	<cfelse>
		<cfset stRecord = objCust.newRecord()>
	</cfif>
	
	<!--- get sales reps for select box --->
	<cfset qSalesReps = objCust.getSalesReps()>

	<cfset CURRENT_adminuserid = objPriceLists.getSessionValue("adminuserid")>
    <!---
    <cfdump var="#SESSION#"><br />
    CURRENT_adminuserid:<cfdump var="#CURRENT_adminuserid#"><br />
    --->

    <cfset strAdminAcct = objAdmin.getRecordAsStruct(CURRENT_adminuserid)>
    
    <!--- ron_barth@altsystem.com OR jonr@nor-tech.com OR Sales Rep --->
    <cfif CURRENT_adminuserid IS "7EBCFD4D-423B-5784-96BD9CB11DAE423D" OR 
		  CURRENT_adminuserid IS "F3D0655D-F9B3-2764-44F08B59A3609C3F" OR
		  (structKeyExists(strAdminAcct, "Role") AND strAdminAcct.Role IS "Sales Rep")>
        <cfset ShowPassword = 1>
    <cfelse>
        <cfset ShowPassword = 0>
    </cfif>
    
</cfsilent>


<script language="javascript">
	function validate(){
		if (CustAccountForm.AcctNo.value == ""){
			alert('You must enter an account number.');
			return false;
		}
		if (CustAccountForm.FirstName.value == ""){
			alert('You must enter a first name.');
			return false;
		}
		if (CustAccountForm.LastName.value == ""){
			alert('You must enter a last name.');
			return false;
		}
		if (CustAccountForm.Email.value == ""){
			alert('You must enter an email address.');
			return false;
		}
//		if (CustAccountForm.Username.value == ""){
//			alert('You must enter a username.');
//			return false;
//		}
		if (CustAccountForm.Passcode.value == ""){
			alert('You must enter a password.');
			return false;
		}
//		if (CustAccountForm.SalesRepID.value == ""){
//			alert('You must select a sales rep.');
//			return false;
//		}
//		if (CustAccountForm.PointsSystem.value <= 0){
//			alert('You must enter a positive value for Points system.');
//			return false;
//		}
//		if (CustAccountForm.PointsNotebook.value <= 0){
//			alert('You must enter a positive value for Points notebook.');
//			return false;
//		}
//		if (CustAccountForm.PointsServer.value <= 0){
//			alert('You must enter a positive value for Points server.');
//			return false;
//		}
	}
	function confirmDelete() {
		var msg = "*** WARNING *** If there are quotes assigned to this customer, they will be reassigned to the default account, if one is found.  If there is not a default account, then those quotes will be deleted.  Are you sure you want to Delete this customer?";
		if(confirm(msg)) { return true; }
		else { return false; }
	}
</script>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<!--- spacer --->
<tr>
	<td class="textsmall" colspan="2">&nbsp;</td>
</tr>

<cfif isDefined("URL.Validation")>
	<cfoutput>
	<tr>
		<td class="textmain" colspan="2"><font color="FF0000">The email address / username '#stRecord.Email#' is in use by another customer.  Please enter a different email address.<br><br>Click <a href="index.cfm?task=admin_custaccounts_edit&uid=#URLEncodedFormat(URL.InUseID)#">here</a> to see the other customer using this address.<br></font></td>
	</tr>
	</cfoutput>
</cfif>

<cfif isDefined("URL.PriceListEmailed")>
	<cfset strPriceList = objPriceLists.getRecord(stRecord.PriceListID)>
	<cfoutput>
	<tr>
		<td class="textmain" colspan="2">
			<font color="FF0000">
				Price List '#strPriceList.Name#' was successfully emailed to '#stRecord.email#'.
			</font>
		</td>
	</tr>
	</cfoutput>
</cfif>


<cfif isDefined("URL.DeletedCustomer")>
	<tr>
		<td class="textmain" colspan="2">
			<font color="FF0000">
            	<cfoutput>
            	<cfif  URL.DeletedCustomer EQ 4>
                	You are trying to delete this customer, <!---the default customer for Account Number '#stRecord.acctno#',---> but other customer accounts exist with this same account number (#stRecord.acctno#).  You need to set one of those accounts to be the default; then you'll be able to delete this account.
            	<cfelseif  URL.DeletedCustomer EQ 2>
                	There are quotes attached to this customer, but a default customer was not found for Account Number '#stRecord.acctno#'.  We therefore don't have an account to reassign these quotes to, so you cannot delete this customer.
				<cfelse>
                    There are quotes attached to this customer, but more than 1 default customer was not found for Account Number '#stRecord.acctno#'.  We therefore don't know who to reassign these quotes to, so you cannot delete this customer.                
             	</cfif>
                </cfoutput>
			</font>
		</td>
	</tr>
</cfif>


<cfoutput>
<cfif stRecord.ID IS NOT "">			
<!---
	<tr>
		<td class="textsmall" align="center">
			<font size="+1">
				<cfif isBoolean(stRecord.Active) AND stRecord.Active>			
					<a href="index.cfm?task=admin_custaccounts_sendemail&uid=#URLEncodedFormat(stRecord.ID)#"><strong>Send Customer Email</strong></a>
				<cfelse>
					<font color="999999"><strong>Send Customer Email</strong></font><br>
					<i><font size="-1" color="999999">(Email cannot be sent because this account is not checked as active)</font></i>
				</cfif>
			</font>
		</td>
	</tr>
--->
	<tr>
		<td class="textmain" align="right" colspan="2">
			<cfif isBoolean(stRecord.Active) AND stRecord.Active>			
				<a href="index.cfm?task=admin_custaccounts_sendemail&uid=#URLEncodedFormat(stRecord.ID)#"><strong>Send Customer Email</strong></a>
			<cfelse>
				<font color="999999"><strong>Send Customer Email</strong></font><br>
				<i><font size="-1" color="999999">(Email cannot be sent because this account is not checked as active)</font></i>
			</cfif>
		</td>
	</tr>
	
	<!--- Assign Systems --->
	<tr>
		<td class="textmain" align="right" colspan="2">
			<cfif isBoolean(stRecord.Active) AND stRecord.Active>			
				<a href="index.cfm?task=admin_reseller_systems_edit&CustomerID=#URLEncodedFormat(stRecord.CustomerID)#">
					<strong>Assign Systems</strong>
				</a>
			<cfelse>
				<font color="999999"><strong>Assign Systems</strong></font><br>
				<i><font size="-1" color="999999">(Systems cannot be assigned because this account is not checked as active)</font></i>
			</cfif>
		</td>
	</tr>

	<!--- CUSTOMER ORDERS --->
	<tr>
		<td class="textmain" align="right" colspan="2">
            <a href="index.cfm?task=admin_orders_lstOrders&AcctNo=#URLEncodedFormat(stRecord.AcctNo)#">
                <strong>Customer Orders</strong>
            </a>
		</td>
	</tr>
	
	<!--- Email Price List to Customer --->
	<cfif stRecord.PriceListID IS NOT "" AND 
		  isDefined("stRecord.PriceListAccess") AND isNumeric(stRecord.PriceListAccess) AND stRecord.PriceListAccess EQ 1>
		<tr>
			<td class="textmain" align="right" colspan="2">
				<a href="index.cfm?task=admin_custaccounts_emailpricelist&uid=#URLEncodedFormat(stRecord.ID)#">
					<strong>Email Price List to Customer</strong>
				</a>
			</td>
		</tr>
	</cfif>

</cfif>
</cfoutput>

<form name="CustAccountForm" action="index.cfm?RequestTimeout=6000&task=<cfif Task EQ 'admin_custaccounts_incomplete_edit'>admin_custaccounts_incomplete_update<cfelse>admin_custaccounts_update</cfif>" method="post" onsubmit="return validate(this)">

	<cfset TabValue = 1>
	<cfoutput>
		<input type="hidden" name="ID" value="#stRecord.ID#">
		<input type="hidden" name="CustomerID" value="#stRecord.CustomerID#">
		<input type="hidden" name="PriceListID_SAVED" value="#stRecord.PriceListID#">
		<tr>
			<td class="textmain" width="35%">
				<strong>Account number:</strong>
			</td>
			<td class="textmain">
				<input name="AcctNo" value="#stRecord.AcctNo#" size="20" maxlength="50" tabindex="#TabValue#">
				<cfset TabValue = TabValue + 1>
			</td>
		</tr>
        
		<tr>
			<td class="textmain">
				<strong>Default Account?</strong>
			</td>
			<td class="textmain">
				<input type="checkbox" name="DefaultAccount" value="1"<cfif stRecord.DefaultAccount EQ 1> checked</cfif> tabindex="#TabValue#">
				<cfset TabValue = TabValue + 1>
			</td>
		</tr>
        
		<tr>
			<td class="textmain">
				<strong>Company:</strong>
			</td>
			<td class="textmain">
				<input name="Company" value="#stRecord.Company#" size="20" maxlength="50" tabindex="#TabValue#">
				<cfset TabValue = TabValue + 1>
			</td>
		</tr>
		<tr>
			<td class="textmain">
				<strong>First name:</strong>
			</td>
			<td class="textmain">
				<input name="FirstName" value="#stRecord.FirstName#" size="20" maxlength="50" tabindex="#TabValue#">
				<cfset TabValue = TabValue + 1>
			</td>
		</tr>
		<tr>
			<td class="textmain">
				<strong>Last name:</strong>
			</td>
			<td class="textmain">
				<input name="LastName" value="#stRecord.LastName#" size="20" maxlength="50" tabindex="#TabValue#">
				<cfset TabValue = TabValue + 1>
			</td>
		</tr>
		<tr>
			<td class="textmain">
				<strong>Email address / Username:</strong>
			</td>
			<td class="textmain">
				<input name="Email" value="#stRecord.Email#" size="20" maxlength="100" tabindex="#TabValue#">
				<cfset TabValue = TabValue + 1>
			</td>
		</tr>

		<input type="hidden" name="Username" value="#stRecord.Username#">
<!---			
		<strong>Username:</strong><br>
		<input name="Username" value="#stRecord.Username#" size="20" maxlength="255"><br><br>
--->			
		<tr>
			<td class="textmain">
				<strong>Password:</strong>
			</td>
			<td class="textmain">
            	<cfif ShowPassword>
                    <input name="Passcode" value="#stRecord.Passcode#" size="20" maxlength="255" tabindex="#TabValue#">
                <cfelse>
                    <input name="Passcode" value="#stRecord.Passcode#" type="password" size="20" maxlength="255" tabindex="#TabValue#">
                </cfif>
				<cfset TabValue = TabValue + 1>
			</td>
		</tr>
		<tr>
			<td class="textmain">
				<strong>SalesRep:</strong>
			</td>
			<td class="textmain">
				<cfif SESSION.Role IS "Sales Rep">
					<input type="hidden" name="SalesRepID" value="#SESSION.SalesRepID#">
					#SESSION.FName#	#SESSION.LName#
				<cfelse>			
					<select name="SalesRepID" tabindex="#TabValue#">
						<cfloop query="qSalesReps">
							<option value="#qSalesReps.ID#"<cfif stRecord.SalesRepID EQ qSalesReps.ID> selected</cfif>>#RepName#</option>
						</cfloop>
					</select>
					<cfset TabValue = TabValue + 1>
				</cfif>
			</td>
		</tr>
		<tr>
			<td class="textmain">
				<strong>Intel ID Number:</strong>
			</td>
			<td class="textmain">
				<input name="IntelIDNumber" value="#stRecord.IntelIDNumber#" size="20" maxlength="50" tabindex="#TabValue#">
				<cfset TabValue = TabValue + 1>
			</td>
		</tr>
		<tr>
			<td class="textmain">
				<strong>Phone Number:</strong>
			</td>
			<td class="textmain">
				<input name="PhoneNumber" value="#stRecord.PhoneNumber#" size="20" maxlength="50" tabindex="#TabValue#">
				<cfset TabValue = TabValue + 1>
			</td>
		</tr>
		

<!--- 7/20/06: The new configurator is not using the old "points" system, therefore I'm removing this code.  
	  I'm hiding the fields so we don't have to remove them from the database table.  -Ron Barth --->
			<input type="hidden" name="PointsSystem" value="#stRecord.PointsSystem#">
			<input type="hidden" name="PointsNotebook" value="#stRecord.PointsNotebook#">
			<input type="hidden" name="PointsServer" value="#stRecord.PointsServer#">
<!---
			<strong>Points system:</strong> (example - .90 equals 10 points, .88 equals
			12 points, etc) <br>
			<input name="PointsSystem" value="#stRecord.PointsSystem#" size="10" maxlength="10"><br><br>
			<strong>Points notebook:</strong><br>
			<input name="PointsNotebook" value="#stRecord.PointsNotebook#" size="10" maxlength="10"><br><br>
			<strong>Points server:</strong><br>
			<input name="PointsServer" value="#stRecord.PointsServer#" size="10" maxlength="10"><br><br>
--->			


		<input type="hidden" name="AccessLevel" value="#stRecord.AccessLevel#">
<!---
		<tr>
			<td class="textmain">
				<strong>Access level:</strong><br>(enter 1 for all access) 
			</td>
			<td class="textmain">
				<input name="AccessLevel" value="#stRecord.AccessLevel#" size="10" maxlength="10" tabindex="#TabValue#">
				<cfset TabValue = TabValue + 1>
			</td>
		</tr>
--->

		<!--- ACCESS LEVEL NEW --->
		<tr>
			<td class="textmain"><strong>Access level:</strong></td>
			<td class="textmain">
            	<input type="radio" name="AccessLevelNew" value="All Access" tabindex="#TabValue#"
					<cfif stRecord.AccessLevelNew IS "All Access" OR stRecord.AccessLevelNew IS "">
                		checked="checked" 
                    </cfif>
                    >All Access
            	<input type="radio" name="AccessLevelNew" value="Limited Access" tabindex="#TabValue#"
					<cfif stRecord.AccessLevelNew IS "Limited Access">
                		checked="checked" 
                    </cfif>
                	>Limited Access
				<cfset TabValue = TabValue + 1>
			</td>
		</tr>
		<tr>
			<td class="textmain">&nbsp;</td>
			<td class="textsmall" style="font-style:italic; color:666">"Limited Access" gives access to everything except "Orders", "List All Orders", and "Search Orders" on the left nav menu of the partner's section.
			</td>
		</tr>
		
		<!--- PRICE LIST --->
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "MasterPriceList", 0, True)>
		<cfset structInsert(SearchRecord, "UserID", objPriceLists.getSessionValue("adminuserid"), True)>
		<cfset qryPriceLists = objPriceLists.searchRecords(SearchRecord, "query")>
		<tr>
			<td class="textmain">
				<strong>Price List:</strong><br>
			</td>
			<td class="textmain">
				<select name="PriceListID" size="1" tabindex="#TabValue#">
					<option value="">- Select -</option>
					<cfloop query="qryPriceLists">
						<option value="#qryPriceLists.PriceListID#" 
							<cfif stRecord.PriceListID IS qryPriceLists.PriceListID>
								selected
							</cfif>
							> #qryPriceLists.Name#
						</option>
					</cfloop>
				</select>
				<cfset TabValue = TabValue + 1>
			</td>
		</tr>
		
		<tr>
			<td class="textmain" colspan="2">
				<input type="checkbox" name="PriceListAccess" value="1"<cfif stRecord.PriceListAccess EQ 1> checked</cfif> tabindex="#TabValue#">&nbsp;Does this customer have access to their price list and parts ordering?
				<cfset TabValue = TabValue + 1>
			</td>
		</tr>

		<tr>
			<td class="textmain" colspan="2">
				<input type="checkbox" name="GarageSaleAccess" value="1"<cfif stRecord.GarageSaleAccess EQ 1> checked</cfif> tabindex="#TabValue#">&nbsp;Does this customer have access to "Nor-Tech Closeout Specials" when ordering parts?
				<cfset TabValue = TabValue + 1>
			</td>
		</tr>
				
		<tr>
			<td class="textmain" colspan="2">
				<input type="checkbox" name="Active" value="1"<cfif stRecord.Active EQ 1> checked</cfif> tabindex="#TabValue#">&nbsp;This account is active
				<cfset TabValue = TabValue + 1>
			</td>
		</tr>
		<tr>
			<td class="textmain" colspan="2">
				<input type="checkbox" name="SendShipmentConfirmation" value="1"<cfif stRecord.SendShipmentConfirmation EQ 1> checked</cfif> tabindex="#TabValue#">&nbsp;Send Shipment Confirmation Emails
				<cfset TabValue = TabValue + 1>
			</td>
		</tr>
		<tr>
			<td class="textmain" colspan="2">
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<strong>Date Last Email Sent:</strong> &nbsp;
				<cfif stRecord.DateEmailSent IS NOT "" AND stRecord.DateEmailSent IS NOT "1/1/1900">
					#dateFormat(stRecord.DateEmailSent, 'mm/dd/yyyy')# at 
					#timeFormat(stRecord.DateEmailSent, 'h:mm tt')#
				<cfelse>
					Never
				</cfif>
			</td>
		</tr>
		<input type="hidden" name="DateEmailSent" value="#stRecord.DateEmailSent#">

		<tr>
			<td class="textmain" colspan="2">
				<input type="checkbox" name="ShippingAndTax" value="1"<cfif stRecord.ShippingAndTax EQ 1> checked</cfif> tabindex="#TabValue#">&nbsp;Display the line "(shipping and tax not included)" on the configurator?
				<cfset TabValue = TabValue + 1>
			</td>
		</tr>
		<tr>
			<td class="textmain" colspan="2">
				<input type="checkbox" name="FreightEstimator" value="1"<cfif stRecord.FreightEstimator EQ 1> checked</cfif> tabindex="#TabValue#">&nbsp;Does this customer use the UPS Freight Calculator on the configurator?
				<cfset TabValue = TabValue + 1>
			</td>
		</tr>
        
		<tr>
			<td class="textmain" colspan="2">
				<input type="checkbox" name="UseClassifications" value="1"<cfif stRecord.UseClassifications  EQ 1> checked</cfif> tabindex="#TabValue#">&nbsp;Does this customer use Classifications on the configurator?
				<cfset TabValue = TabValue + 1>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		
		
		<tr>
			<td class="textmain" colspan="2" align="center">
				<table width="75%" border="0" align="center" cellpadding="3" cellspacing="1">
					<tr>
						<td class="textmain" align="center">
							<input type="submit" name="ButtonClicked" value="Save" tabindex="#TabValue#">
						</td>
						<cfif trim(stRecord.ID) IS NOT "">
							<td class="textmain" align="center">
								<input type="submit" name="ButtonClicked" value="Delete" onclick="return confirmDelete()">
							</td>
						</cfif>
					</tr>
				</table>
			</td>
		</tr>
	</cfoutput>
</form>
</table>

<cfif NOT isDefined("URL.Validation")>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.CustAccountForm['AcctNo'].focus();
	-->
	</script>
</cfif>