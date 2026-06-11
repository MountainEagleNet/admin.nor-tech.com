<!---<cfsilent>
--->	<!---
	Coded By: Alternative Systems, Inc - Nicholas Tunney
	Create Date: 7/17/2005
	Edit Date: 
	Function: Saves a customer account (new or edit)
	actCustAccountSave.cfm 
	--->
	<cfset objCust = createObject("component", "admin.assets.cfcs.Cust")>
	<cfset objSalesRep = createObject("component", "admin.assets.cfcs.SalesRep")>
	<cfset objComponentPrices = createObject("component", "admin.assets.cfcs.config.ComponentPrices")>

	<cfif isDefined("FORM.ButtonClicked") AND FORM.ButtonClicked IS "Delete">
		<cfset DeletedCustomer = objCust.DeleteCustomer(FORM.ID)>
        <cfif DeletedCustomer EQ 1>
			<cflocation url="index.cfm?task=admin_custaccounts_list&DeletedCustomer=#DeletedCustomer#">
		<cfelse>
			<cflocation url="index.cfm?task=admin_custaccounts_edit&DeletedCustomer=#DeletedCustomer#&uid=#urlEncodedFormat(FORM.ID)#">
        </cfif>
	</cfif>
	
	<cfparam name="FORM.Active" default="0">
	<cfparam name="FORM.SendShipmentConfirmation" default="0">
	<cfparam name="FORM.ShippingAndTax" default="0">
	<cfparam name="FORM.PriceListAccess" default="0">
	<cfparam name="FORM.GarageSaleAccess" default="0">
	<cfparam name="FORM.FreightEstimator" default="0">
	<cfparam name="FORM.UseClassifications" default="0">

	<cfparam name="FORM.DefaultAccount" default="0">

	<cfset FORM.Username = FORM.Email>

	<cfif NOT isNumeric(FORM.PointsSystem)>
		<cfset FORM.PointsSystem = 1>
	</cfif>
	<cfif NOT isNumeric(FORM.PointsNotebook)>
		<cfset FORM.PointsNotebook = 1>
	</cfif>
	<cfif NOT isNumeric(FORM.PointsServer)>
		<cfset FORM.PointsServer = 1>
	</cfif>
	
	<!--- Make sure the username isn't in use by another customer --->
	<cfset InUseID = objCust.userNameTaken(FORM.Username, FORM.ID)>
	<cfif InUseID GT 0>
		<cflocation url="index.cfm?task=admin_custaccounts_edit&Validation=yes&ID=#FORM.ID#&CustomerID=#FORM.CustomerID#&AcctNo=#FORM.AcctNo#&Company=#FORM.Company#&FirstName=#FORM.FirstName#&LastName=#FORM.LastName#&Email=#FORM.Email#&Username=#FORM.Username#&Passcode=#FORM.Passcode#&SalesRepID=#FORM.SalesRepID#&PointsSystem=#FORM.PointsSystem#&PointsNotebook=#FORM.PointsNotebook#&PointsServer=#FORM.PointsServer#&AccessLevel=#FORM.AccessLevel#&AccessLevelNew=#FORM.AccessLevelNew#&Active=#FORM.Active#&SendShipmentConfirmation=#FORM.SendShipmentConfirmation#&DateEmailSent=#FORM.DateEmailSent#&InUseID=#InUseID#&PriceListID=#urlEncodedFormat(FORM.PriceListID)#&PriceListAccess=#urlEncodedFormat(FORM.PriceListAccess)#&GarageSaleAccess=#urlEncodedFormat(FORM.GarageSaleAccess)#&ShippingAndTax=#FORM.ShippingAndTax#&IntelIDNumber=#urlEncodedFormat(FORM.IntelIDNumber)#&PhoneNumber=#urlEncodedFormat(FORM.PhoneNumber)#&FreightEstimator=#FORM.FreightEstimator#&UseClassifications=#FORM.UseClassifications#&DefaultAccount=#FORM.DefaultAccount#">
	</cfif>


	
	<!--- if we are editing --->
	<cfif len(FORM.ID)>
		<cfset Variables.CustomerID = objCust.updateRecord(FORM)>
    
        <!--- If a price list was assigned (or changed), fill in all of the selling prices --->    
        <cfif form.PriceListID IS NOT form.PriceListID_SAVED AND form.PriceListID IS NOT "" AND NOT objComponentPrices.pricesExistForPriceList(form.PriceListID)>
            <cfset objComponentPrices.createPricesForReseller(Variables.CustomerID)>
        </cfif>    
        
	<!--- otherwise it is a new record --->
	<cfelse>
		<cfset Variables.CustomerID = objCust.insertRecord(FORM)>

        <!--- If a price list was assigned (or changed), fill in all of the selling prices --->    
        <cfif form.PriceListID IS NOT form.PriceListID_SAVED AND form.PriceListID IS NOT "" AND NOT objComponentPrices.pricesExistForPriceList(form.PriceListID)>
            <cfset objComponentPrices.createPricesForReseller(Variables.CustomerID)>
        </cfif>    
		
		<!--- Send the customer email --->
		<cfset qryCustomer = objCust.getRecordAsQueryByCustomerID(Variables.CustomerID)>
		
		<!--- Get the sales rep's email address for the reply-to attribute --->
		<cfset ReplyToAddress = objSalesRep.getReplyToAddress(Variables.CustomerID)>

		<!--- Send the Email --->
		<cfmail from=	"info@nor-tech.com"		
				to=		"#qryCustomer.email#"
				replyto="#ReplyToAddress#"
				subject="Your Nor-Tech On Line Partners Account" 
				
				port="25">The Partners section of Nor-Tech.com has new, improved functionality we’re sure you’ll find useful!
			
Now you can view all your open orders, print invoices, search past invoices using a variety of search criteria and more!
	
Please login now using your email address as your username and the generic password shown below. You may change your password once you login for the first time.
	
Password: #qryCustomer.passcode#
	
Enjoy the new, improved Partners section on Nor-Tech.com!
	
Regards,
	
Northern Computer Technologies
901 East Cliff Road
Burnsville, MN 55337
(952) 808-1000</cfmail>

		<!--- Save the Date/Time sent in the "login" table --->
		<cfset strCustomer = objCust.getRecordAsStruct(URLDecode(qryCustomer.ID))>
		<cfset structInsert(strCustomer, "DateEmailSent", now(), True)>
		<cfset objCust.updateRecord(strCustomer)>		

<!---	<cflocation url="index.cfm?task=admin_custaccounts_list">	--->
<!---	<cflocation url="index.cfm?task=admin_custaccounts_view&uid=#URLEncodedFormat(Variables.CustomerID)#&JustAddedNewCustomer=yes">--->
		<cflocation url="index.cfm?task=admin_reseller_systems_edit&CustomerID=#URLEncodedFormat(Variables.CustomerID)#&JustAddedNewCustomer=yes">
	</cfif>
    

	<!--- If this is the Default account, mark all of the others for the Acct No as not default --->
	<cfset objCust.setDefaultAccount(Variables.CustomerID)>


	<!--- send the user back to the appropriate admin account list --->
	<cfif task EQ "admin_custaccounts_incomplete_update">
		<cflocation url="index.cfm?task=admin_accounts_incomplete">
	<cfelse>
<!---	<cflocation url="index.cfm?task=admin_custaccounts_list">	--->
<!---	<cflocation url="index.cfm?task=admin_custaccounts_view&uid=#URLEncodedFormat(Variables.CustomerID)#">	--->
		<cflocation url="index.cfm?task=admin_reseller_systems_edit&CustomerID=#URLEncodedFormat(Variables.CustomerID)#">
	</cfif>
<!---
</cfsilent>--->