<cfcomponent extends="admin.assets.cfcs.Component">
	<cfset This.DataSourceName = APPLICATION.DSN_WWW>

	<cfset This.TableName = "tblQuoteSystem">
	<cfset This.ViewName = This.TableName>

	<cfset This.Columns = "QuoteSystemID,CustomerID,SalesRepID,QuoteNumber,QuoteTitle,QuoteSubmitted,CustomerQuote,ConfigSystemID,SystemName,SystemAlias,SystemType,SystemPhoto,SystemConfigPhotoID,QuoteDate,ResellerPrice,Quantity,ResellerTotal,ResellerPONumber,ResellerComments,ShippingEstimate,ShippingCriteria,AdditionalWarrantyID,AdditionalWarrantyName,AdditionalWarrantyAmount,CustPrice,CustTotal,CustFirstName,CustLastName,CustTitle,CustCompany,CustAddress1,CustAddress2,CustCity,CustState,CustZip,CustIsPOBox,CustPhone,CustPhoneExtension,CustEmail,CustPONumber,CustComments,CustNoContact,SalesRepQuote,QuoteSent,TurnOffPricing">
	<cfset This.ViewColumns = This.Columns>
	
	<cfset This.PrimaryKey = "QuoteSystemID">
	
	<cfset This.GenerateUUIDKey = 1>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "QuoteNumber">
	<cfset This.SortOrder = "Asc">

	<cfset This.SortOrderList = "">
	<cfset This.SortKey = "">
	<cfset This.ParentKey = "">
	<cfset This.CreatedKey = "QuoteDate">
	<cfset This.ModifiedKey = "">
	<cfset This.ZipCode1Key = "CustZip">
	<cfset This.ZipCode2Key = "">
	<cfset This.SavePrimaryKey = 0>
	<cfset This.ExcludeInUpdates = "">
	<cfset This.ExcludeInInserts = "">
	<cfset This.QuotedInsertList = "ResellerPONumber,ResellerComments,QuoteTitle">

<!---
	<cffunction name="saveQuote" access="public" returntype="string" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset objCust = createObject("component", "admin.assets.cfcs.Cust")>
		<cfset objConfigComponents = createObject("component", "admin.assets.cfcs.config.ConfigComponents")>
		<cfset objQuoteComponents = createObject("component", "admin.assets.cfcs.config.QuoteComponents")>
		<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>

		<cfset strQuoteSystem = newRecord()>
		<cfset loginID = getSessionValue("ID")>
		<cfset qrylogin = objCust.getRecordAsQuery(loginID)>
		<cfset Variables.CustomerID = qrylogin.CustomerID>
		<cfset structInsert(strQuoteSystem, "CustomerID", Variables.CustomerID, True)>
		<cfset structInsert(strQuoteSystem, "SalesRepID", getSessionValue("salesrepid"), True)>
		<cfset structInsert(strQuoteSystem, "QuoteNumber", getUniqueQuoteNumber(), True)>
		<cfset structInsert(strQuoteSystem, "CustomerQuote", 0, True)>
		<cfset strConfigSystem = objConfigSystems.getRecord(Arguments.Record.ConfigSystemID)>
		<cfset structInsert(strQuoteSystem, "SystemName", strConfigSystem.Name, True)>
		<cfset structInsert(strQuoteSystem, "SystemType", strConfigSystem.Type, True)>
		<cfset structInsert(strQuoteSystem, "SystemPhoto", strConfigSystem.PhotoImage, True)>
		<cfset structInsert(strQuoteSystem, "SystemConfigPhotoID", strConfigSystem.ConfigPhotoID, True)>
		<cfset structInsert(strQuoteSystem, "ResellerPrice", Arguments.Record.ResellerPrice, True)>
		<cfif NOT isNumeric(Arguments.Record.Quantity)>
			<cfset Arguments.Record.Quantity = 1>
		</cfif>
		<cfset structInsert(strQuoteSystem, "Quantity", Arguments.Record.Quantity, True)>
		<cfset structInsert(strQuoteSystem, "ResellerTotal", Arguments.Record.ResellerTotal, True)>
		<cfset structInsert(strQuoteSystem, "ResellerPONumber", Arguments.Record.ResellerPONumber, True)>
		<cfset structInsert(strQuoteSystem, "ResellerComments", Arguments.Record.ResellerComments, True)>
		<cfset QuoteSystemID = saveRecord(strQuoteSystem)>

		<cfset lstRecord = structKeyList(Arguments.Record)>
		<cfloop list="#lstRecord#" index="Column">
			<cfif findNoCase('CAT_',Column) NEQ 0>
				<cfset ConfigComponentID = Arguments.Record[Column]>
				<cfset strConfigComponent = objConfigComponents.getRecord(ConfigComponentID)>
				<cfset strQuoteComponent = objQuoteComponents.newRecord()>
				<cfset structInsert(strQuoteComponent, "QuoteSystemID", QuoteSystemID, True)>
				<cfset structInsert(strQuoteComponent, "ITEMNO", strConfigComponent.ITEMNO, True)>
				<cfset structInsert(strQuoteComponent, "ITEMDESC", getItemDescription(strConfigComponent.ITEMNO), True)>
				<cfset structInsert(strQuoteComponent, "TypeName", strConfigComponent.CategoryName, True)>
				<cfset structInsert(strQuoteComponent, "TypeSortOrder", strConfigComponent.CategorySortOrder, True)>
				<cfset objQuoteComponents.saveRecord(strQuoteComponent)>
			</cfif>
		</cfloop>
		<cfreturn QuoteSystemID>
	</cffunction>
--->

	<!----------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="saveQuote" access="public" returntype="string" output="No">
	<cfargument name="Record" type="struct" required="Yes">
	<cfargument name="ExportableConfigurator" type="boolean" required="No">
    	<cfset var QuantityField = "">
        <cfset var QuantityValue = "">
        <cfset var QuoteSystemAlias = "">
        <cfset var ShippingCriteria = "">
		<cfset var DepotField = "">
        <cfset var DepotAmount = 0>
        <cfset var DepotName = "">
        <cfset var DepotAmount_CUSTOMER = "">
		<cfset var ThisITEMNO = "">
        <cfset var ThisCategoryName = "">
        <cfset var ThisCategorySortOrder = "">
        <cfset var qryComponentCategories = queryNew("")>
        
		<cfset objCust = createObject("component", "admin.assets.cfcs.Cust")>
		<cfset objConfigComponents = createObject("component", "admin.assets.cfcs.config.ConfigComponents")>
		<cfset objQuoteComponents = createObject("component", "admin.assets.cfcs.config.QuoteComponents")>
		<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>
		<cfset objResellerSystems = createObject("component", "admin.assets.cfcs.config.ResellerSystems")>

		<cfset strQuoteSystem = Arguments.Record>

		<!--- ADDITIONAL (DEPOT) WARRANTY --->
		<!--- If a Depot Warranty was checked, add it to the price --->
        <cfif structKeyExists(strQuoteSystem, "AdditionalWarrantyID") AND strQuoteSystem.AdditionalWarrantyID IS NOT "">

			<!--- Depot Amount, RESELLER --->
        	<cfset DepotField = "DEPOT_AMOUNT|" & strQuoteSystem.AdditionalWarrantyID>
            <cfset DepotAmount = strQuoteSystem[DepotField]>

			<!--- Depot Amount, CUSTOMER --->
        	<cfset DepotField = "DEPOT_AMOUNT_CUST|" & strQuoteSystem.AdditionalWarrantyID>
			<cfif structKeyExists(strQuoteSystem, DepotField)>
            	<cfset DepotAmount_CUSTOMER = strQuoteSystem[DepotField]>
          	<cfelse>
            	<cfset DepotAmount_CUSTOMER = "">
            </cfif>


        	<cfset DepotField = "DEPOT_NAME|" & strQuoteSystem.AdditionalWarrantyID>
            <cfset DepotName = strQuoteSystem[DepotField]>
            
            <cfset structInsert(strQuoteSystem, "AdditionalWarrantyName", DepotName, True)>
            <cfset structInsert(strQuoteSystem, "AdditionalWarrantyAmount", DepotAmount, True)>
<!---
DepotAmount:<cfdump var="#DepotAmount#"><br>
DepotName:<cfdump var="#DepotName#"><br>
--->
			<cfif isDefined("strQuoteSystem.TurnOffPricing") AND strQuoteSystem.TurnOffPricing IS NOT "1">
				<cfif isNumeric(DepotAmount)>
                    <cfset strQuoteSystem.ResellerPrice = strQuoteSystem.ResellerPrice + DepotAmount>
                    <cfset strQuoteSystem.ResellerTotal = strQuoteSystem.ResellerPrice * strQuoteSystem.Quantity>
                </cfif>
                
                <cfif isNumeric(DepotAmount_CUSTOMER)>
                    <cfif structKeyExists(strQuoteSystem, "CustPrice")>
                        <cfset strQuoteSystem.CustPrice = strQuoteSystem.CustPrice + DepotAmount_CUSTOMER>
                    </cfif>
                    <cfif structKeyExists(strQuoteSystem, "CustTotal")>
                        <cfset strQuoteSystem.CustTotal = strQuoteSystem.CustPrice * strQuoteSystem.Quantity>
                    </cfif>
                </cfif>
            </cfif>
        </cfif>
        
		<cfset structInsert(strQuoteSystem, "QuoteSystemID", "", True)>

		<cfif NOT isDefined("strQuoteSystem.CustomerID") OR trim(strQuoteSystem.CustomerID) IS "">
			<cfset loginID = getSessionValue("ID")>
			<cfset qrylogin = objCust.getRecordAsQuery(loginID)>
			<cfif qrylogin.RecordCount NEQ 0>
				<cfset structInsert(strQuoteSystem, "CustomerID", qrylogin.CustomerID, True)>
			</cfif>
		</cfif>

		<cfset SalesRepID = getSessionValue("salesrepid")>
		<cfif trim(SalesRepID) IS "">
			<cfset qryLogin = objCust.getLoginRecord(strQuoteSystem.CustomerID)>
			<cfset SalesRepID = qryLogin.SalesRepID>
		</cfif>
		<cfset structInsert(strQuoteSystem, "SalesRepID", SalesRepID, True)>

		<cfset structInsert(strQuoteSystem, "QuoteNumber", getUniqueQuoteNumber(), True)>
        
        <cfif structKeyExists(strQuoteSystem, "ShippingEstimate") AND strQuoteSystem.ShippingEstimate IS "">
        	<cfset structDelete(strQuoteSystem, "ShippingEstimate")>
        </cfif>
        
        <!--- SHIPPING CRITERIA --->
        <cfif structKeyExists(Arguments.Record, "State") AND structKeyExists(Arguments.Record, "ZipCode") AND structKeyExists(Arguments.Record, "ShippingMethod")>
			<cfset ShippingCriteria = "(Ship to " & Arguments.Record.State & ", " & Arguments.Record.ZipCode & ", " & Arguments.Record.ShippingMethod>
            <cfif structKeyExists(Arguments.Record, "ResidentialDelivery")>
                <cfset ShippingCriteria = ShippingCriteria & ", Residential Delivery">
            </cfif>
            <cfif structKeyExists(Arguments.Record, "SignatureRequired")>
                <cfset ShippingCriteria = ShippingCriteria & ", Signature Required">
            </cfif>
            <cfset ShippingCriteria = ShippingCriteria & ")">
			<cfset structInsert(strQuoteSystem, "ShippingCriteria", ShippingCriteria, True)>
       	</cfif>
		
		<cfif isDefined("Arguments.ExportableConfigurator") AND Arguments.ExportableConfigurator EQ 1>
			<cfset structInsert(strQuoteSystem, "CustomerQuote", 1, True)>
		<cfelse>
			<cfset structInsert(strQuoteSystem, "CustomerQuote", 0, True)>
		</cfif>
		<cfif Arguments.Record.ConfigSystemID IS NOT "">
        	<cfif isDefined("Arguments.Record.SystemAlias")>
				<cfset QuoteSystemAlias = Arguments.Record.SystemAlias>
			<cfelse>
            	<cfset QuoteSystemAlias = objResellerSystems.getAlias(strQuoteSystem.CustomerID,Arguments.Record.ConfigSystemID)>
			</cfif>
			<cfset strConfigSystem = objConfigSystems.getRecord(Arguments.Record.ConfigSystemID)>           
            <cfset structInsert(strQuoteSystem, "SystemName", strConfigSystem.Name, True)>
	        <cfset structInsert(strQuoteSystem, "SystemAlias", QuoteSystemAlias, True)>	
            <cfset structInsert(strQuoteSystem, "SystemType", strConfigSystem.Type, True)>
            <cfset structInsert(strQuoteSystem, "SystemPhoto", strConfigSystem.PhotoImage, True)>
            <cfset structInsert(strQuoteSystem, "SystemConfigPhotoID", strConfigSystem.ConfigPhotoID, True)>
		<cfelse>
            <cfset structInsert(strQuoteSystem, "SystemName", "", True)>
	        <cfset structInsert(strQuoteSystem, "SystemAlias", "", True)>	
            <cfset structInsert(strQuoteSystem, "SystemType", "", True)>
            <cfset structInsert(strQuoteSystem, "SystemPhoto", "", True)>
            <cfset structInsert(strQuoteSystem, "SystemConfigPhotoID", "", True)>
		</cfif>
        
		<cfif NOT structKeyExists(strQuoteSystem, "Quantity") OR NOT isNumeric(strQuoteSystem.Quantity)>
			<cfset strQuoteSystem.Quantity = 1>
		</cfif>
		<cfset structInsert(strQuoteSystem, "Quantity", strQuoteSystem.Quantity, True)>
<!---
<cfdump var="#Arguments.Record#">
<cfabort>
--->

		<cfset QuoteSystemID = saveRecord(strQuoteSystem)>

		<cfset lstRecord = structKeyList(Arguments.Record)>
		<cfloop list="#lstRecord#" index="Column">
			<cfif findNoCase('CAT_',Column) NEQ 0>
				<cfset ConfigComponentID = Arguments.Record[Column]>
                <cfif findNoCase('ENERGYSTAR|', ConfigComponentID) NEQ 0>
                
                	<cfset ThisITEMNO = removeChars(ConfigComponentID, 1, 11)>
                    <cfset ThisCategoryName = "EnergyStar">
                    <cfquery datasource="#This.DataSourceName#" name="qryComponentCategories">
                    SELECT	SortOrder
                    FROM	tblComponentCategories
                    WHERE 	Name = 'EnergyStar'
                    </cfquery>	
                    <cfif qryComponentCategories.RecordCount NEQ 0>
						<cfset ThisCategorySortOrder = qryComponentCategories.SortOrder>
                    <cfelse>
                    	<cfset ThisCategorySortOrder = "">
                    </cfif>
                    <cfset QuantityValue = 1>
                    
                    
                <cfelse>
                	<cfif findNoCase('|', ConfigComponentID) NEQ 0>
						<cfset LocationOfUnderscore = findNoCase('|', ConfigComponentID)>
                        <cfset ConfigComponentID = removeChars(ConfigComponentID, LocationOfUnderscore, len(ConfigComponentID)-LocationOfUnderscore+1)>
                    </cfif>
					<cfset strConfigComponent = objConfigComponents.getRecord(ConfigComponentID)>

                	<cfset ThisITEMNO = strConfigComponent.ITEMNO>
                    <cfset ThisCategoryName = strConfigComponent.CategoryName>
                    <cfset ThisCategorySortOrder = strConfigComponent.CategorySortOrder>

					<cfset QuantityField = "QTY|" & removeChars(Column, 1, 4)>
                    <cfset QuantityValue = "">
                    <cfif structKeyExists(Arguments.Record, QuantityField)>
                        <cfset QuantityValue = Arguments.Record[QuantityField]>
                    </cfif>
                    
                </cfif>
                
				<cfset strQuoteComponent = objQuoteComponents.newRecord()>
				<cfset structInsert(strQuoteComponent, "QuoteSystemID", QuoteSystemID, True)>
				<cfset structInsert(strQuoteComponent, "ITEMNO", ThisITEMNO, True)>
				<cfset structInsert(strQuoteComponent, "ITEMDESC", getItemDescription(ThisITEMNO), True)>
				<cfset structInsert(strQuoteComponent, "TypeName", ThisCategoryName, True)>
				<cfset structInsert(strQuoteComponent, "TypeSortOrder", ThisCategorySortOrder, True)>
				<cfset structInsert(strQuoteComponent, "MiscPart", 0, True)>
				<cfset structInsert(strQuoteComponent, "Quantity", QuantityValue, True)>
				<cfset objQuoteComponents.saveRecord(strQuoteComponent)>
			</cfif>
		</cfloop>
		<cfreturn QuoteSystemID>
	</cffunction>
	

	<!----------------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="getUniqueQuoteNumber" access="public" returntype="string" output="No">
		<cfset var QuoteNumber = "">
		<cfset FoundOne = 0>
		<cfloop condition="#FoundOne# EQ 0">
			<cfloop from="1" to="5" index="i">
				<cfset CharacterList = "0,1,2,3,4,5,6,7,8,9">
				<cfset RandomNumber = RandRange(1,ListLen(CharacterList))>
				<cfset RandomLetter = ListGetAt(CharacterList,RandomNumber)>
				<cfset QuoteNumber = QuoteNumber & RandomLetter>
			</cfloop>
			<cfset QuoteNumber = "Q" & QuoteNumber>
			
			<!--- Make sure this quote number isn't being used already --->
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "QuoteNumber", QuoteNumber, True)>
			<cfset qryQuoteSystem = searchRecords(SearchRecord)>
			<cfif qryQuoteSystem.RecordCount EQ 0>
				<cfset FoundOne = 1>
			</cfif>
		</cfloop>
		<cfreturn QuoteNumber>
	</cffunction>

	<!----------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="sendEmailToNorTech" access="public" output="No">
	<!--- When a quote is submitted, this sends an email to the Nor-Tech sales rep --->
	<cfargument name="QuoteSystemID" type="string" required="Yes">
	<cfargument name="Type" type="string" required="no">
		<cfset var LoopCount = 0>
		<cfset objSalesRep = createObject("component", "admin.assets.cfcs.SalesRep")>
		<cfset objQuoteComponents = createObject("component", "admin.assets.cfcs.config.QuoteComponents")>
		<cfset objCust = createObject("component", "admin.assets.cfcs.Cust")>
		<cfset strQuoteSystem = getRecord(Arguments.QuoteSystemID)>
		<cfset strReseller = objCust.getLoginRecord(strQuoteSystem.CustomerID)>

		<cfif NOT isDefined("Arguments.Type")>
			<cfset Arguments.Type = "quote">
		</cfif>

		<cfif strQuoteSystem.CustomerQuote>
			<cfset FromEmailAddress = strQuoteSystem.CustEmail>
		<cfelse>
			<cfset FromEmailAddress = getSessionValue("email")>
		</cfif>
		
		<cfif strQuoteSystem.CustomerQuote>
			<cfset strSalesRep = objSalesRep.getRecordAsStruct(strQuoteSystem.SalesRepID)>
		<cfelse>
			<cfset SalesRepID = getSessionValue("salesrepid")>
			<cfset strSalesRep = objSalesRep.getRecordAsStruct(SalesRepID)>
		</cfif>
		<cfset ToEmailAddress = strSalesRep.repemail>
		
		<cfset CCEmailAddress = "">
		<cfif isDefined("strSalesRep.VacationEmail") AND trim(strSalesRep.VacationEmail) IS NOT "">
			<cfset CCEmailAddress = strSalesRep.VacationEmail>		
		</cfif>

		<cfset qryQuoteComponents = objQuoteComponents.listRecordsForParent("QuoteSystemID", Arguments.QuoteSystemID, "TypeSortOrder")>
	
    	<cfif Arguments.Type IS "quote">
    		<cfset SubjectText = "Online Quote">
    	<cfelse>
    		<cfset SubjectText = "Online Order">
        </cfif>
		<cfif strQuoteSystem.CustomerQuote>
			<cfset SubjectText = SubjectText & " from Partner Branded Configurator">
		<cfelse>
			<cfset SubjectText = SubjectText & " from " & strReseller.firstname & " " & strReseller.lastname>
		</cfif>
	
<!---	<cfmail from=	"Nor-Tech Online Configurator <#FromEmailAddress#>" 	--->
		<cfmail from=	"Nor-Tech Online Configurator <info@nor-tech.com>" 
				to=		"#ToEmailAddress#" 
				cc=		"#CCEmailAddress#"  
				replyto="#FromEmailAddress#" 
				subject="#SubjectText#"
				type=	"html"
				timeout="60">
<!---			server="192.168.1.2" timeout="60">	--->
		<html>
		<head>
			<style type="text/css">
				BODY	{font-family:Arial, Helvetica, sans-serif; font-size:12px;}
				TD		{font-family:Arial, Helvetica, sans-serif; font-size:12px;}
			</style>
		</head>
		<body>

    	<cfif Arguments.Type IS "quote">
			The following is an online quote
    	<cfelse>
			The following is an online order
        </cfif>
		<cfif strQuoteSystem.CustomerQuote>
			submitted by a customer of partner company #strReseller.company# using the Nor-Tech partner branded system configurator.<br><br>
		<cfelse>
			submitted from #strReseller.firstname# #strReseller.lastname# at #strReseller.company#:<br><br>		
		</cfif>
        
        <cfif strQuoteSystem.TurnOffPricing IS "1">
        	<strong>NOTE</strong>: This quote originated from a price-free configurator.  Please contact customer to provide real quote.<br><br>
        </cfif>

		<table cellpadding="0" cellspacing="0" width="100%" border="0">

			<tr>
				<td><strong>Type:</strong></td>
				<td>
					<cfif Arguments.Type IS "quote">
                        <font color="9900FF"><strong>Quote</strong></font>
                    <cfelse>
                        <font color="FF0000"><strong>Order</strong></font>
                    </cfif>
                </td>
			</tr>
   			<tr><td>&nbsp;</td></tr>

			<cfif strQuoteSystem.CustomerQuote>
				<tr><td colspan="2"><strong>Partner Information:</strong></td></tr>
				<tr><td colspan="2">#strReseller.firstname# #strReseller.lastname#</td></tr>
				<tr><td colspan="2">#strReseller.company#</td></tr>
				<tr><td colspan="2">#strReseller.email#</td></tr>
				<tr><td colspan="2">Account Number: #strReseller.acctno#</td></tr>

				<tr><td>&nbsp;</td></tr>
				<tr><td colspan="2"><strong>Customer Information:</strong></td></tr>
				<tr>
					<td colspan="2">
						#strQuoteSystem.CustFirstName# #strQuoteSystem.CustLastName# 
						<cfif trim(strQuoteSystem.CustTitle) IS NOT "">
							(#strQuoteSystem.CustTitle#)
						</cfif>
						<br>
						<cfif trim(strQuoteSystem.CustCompany) IS NOT "">
							#strQuoteSystem.CustCompany#<br>
						</cfif>
						#strQuoteSystem.CustEmail#<br>
						<cfif trim(strQuoteSystem.CustAddress1) IS NOT "" OR
							  trim(strQuoteSystem.CustAddress2) IS NOT "" OR
						 	  trim(strQuoteSystem.CustCity) IS NOT "" OR
							  trim(strQuoteSystem.CustState) IS NOT "" OR
							  trim(strQuoteSystem.CustZip) IS NOT "">
							<cfif trim(strQuoteSystem.CustAddress1) IS NOT "">
								#strQuoteSystem.CustAddress1#
							</cfif>
							<cfif trim(strQuoteSystem.CustAddress2) IS NOT "">
								, #strQuoteSystem.CustAddress2#
							</cfif>
							<cfif trim(strQuoteSystem.CustCity) IS NOT "">
								, #strQuoteSystem.CustCity#
							</cfif>
							<cfif trim(strQuoteSystem.CustState) IS NOT "">
								, #strQuoteSystem.CustState#
							</cfif>
							<cfif trim(strQuoteSystem.CustZip) IS NOT "">
								, #strQuoteSystem.CustZip#
							</cfif>
							<br>
						</cfif>
						<cfif trim(strQuoteSystem.CustPhone) IS NOT "">
							#strQuoteSystem.CustPhone#
							<cfif trim(strQuoteSystem.CustPhoneExtension) IS NOT "">
								ext #strQuoteSystem.CustPhoneExtension#
							</cfif>
							<br>
						</cfif>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
			</cfif>
		
			<tr>
				<td width="15%"><strong>Quote Number:</strong></td>
				<td>#strQuoteSystem.QuoteNumber#</td>
			</tr>
			<tr>
				<td><strong>Quote Date:</strong></td>
				<td>#dateFormat(strQuoteSystem.QuoteDate, 'mmmm d, yyyy')#</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td><strong>System Name:</strong></td>
				<td>
                	#strQuoteSystem.SystemName#
					<cfif trim(strQuoteSystem.SystemAlias) IS NOT "">
						(Partner's Alias: #strQuoteSystem.SystemAlias#)
					</cfif>
                </td>
			</tr>
			<tr>
				<td><strong>System Type:</strong></td>
				<td>
                	<cfif strQuoteSystem.SystemType IS "MiniMountablePC">
						Mini/Mountable PC
					<cfelse>
                		#strQuoteSystem.SystemType#					
					</cfif> 
                </td>
			</tr>
			
			<tr><td>&nbsp;</td></tr>
            
           	<cfif strQuoteSystem.TurnOffPricing IS NOT "1">
                <tr>
                    <td><strong>Reseller Price:</strong></td>
                    <td>#numberFormat(strQuoteSystem.ResellerPrice, '$.99')#</td>
                </tr>
            </cfif>

			<tr>
				<td><strong>Quantity:</strong></td>
				<td>#strQuoteSystem.Quantity#</td>
			</tr>
            
           	<cfif strQuoteSystem.TurnOffPricing IS NOT "1">
                <tr>
                    <td><strong>Reseller Total:</strong></td>
                    <td>#numberFormat(strQuoteSystem.ResellerTotal, '$.99')#</td>
                </tr>
            </cfif>
            
			<cfif isNumeric(strQuoteSystem.ShippingEstimate) AND strQuoteSystem.ShippingCriteria IS NOT "(Ship to , , )">
                <tr>
                    <td><strong>Estimated Shipping:</strong></td>
                    <td>
                    	#numberFormat(strQuoteSystem.ShippingEstimate, '$.99')#
                        <cfif trim(strQuoteSystem.ShippingCriteria) IS NOT "">
                        	&nbsp;&nbsp;&nbsp; #strQuoteSystem.ShippingCriteria#
                        </cfif>
                    </td>
                </tr>
			</cfif>
<!---
			<cfif isNumeric(strQuoteSystem.AdditionalWarrantyAmount)>  
                <tr>
                    <td><strong>Depot Warranty:</strong></td>
                    <td>
                    	#numberFormat(strQuoteSystem.AdditionalWarrantyAmount, '$.99')#
                        <cfif trim(strQuoteSystem.AdditionalWarrantyName) IS NOT "">
                        	&nbsp;&nbsp;&nbsp; (#strQuoteSystem.AdditionalWarrantyName#)
                        </cfif>
                    </td>
                </tr>
			</cfif>
--->            
			<cfif strQuoteSystem.CustomerQuote>
	           	<cfif strQuoteSystem.TurnOffPricing IS NOT "1">
                    <tr><td>&nbsp;</td></tr>
                    <tr>
                        <td><strong>Customer Price:</strong></td>
                        <td>#numberFormat(strQuoteSystem.CustPrice, '$.99')#</td>
                    </tr>
                    <tr>
                        <td><strong>Quantity:</strong></td>
                        <td>#strQuoteSystem.Quantity#</td>
                    </tr>
                    <tr>
                        <td><strong>Customer Total:</strong></td>
                        <td>#numberFormat(strQuoteSystem.CustTotal, '$.99')#</td>
                    </tr>
				</cfif>
			</cfif>
						
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td><strong>PO Number:</strong></td>
				<td>
					<cfif strQuoteSystem.CustomerQuote>
						#strQuoteSystem.CustPONumber#
					<cfelse>
						#strQuoteSystem.ResellerPONumber#
					</cfif>
				</td>
			</tr>
			<tr>
				<td><strong>Comments:</strong></td>
				<td>
					<cfif strQuoteSystem.CustomerQuote>
						#strQuoteSystem.CustComments#
					<cfelse>
						#strQuoteSystem.ResellerComments#
					</cfif>
				</td>
			</tr>
			
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td colspan="2"><strong>System Components:</strong></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
            
            
            <tr>
            	<td colspan="2">
                    <table cellpadding="0" cellspacing="0" width="100%" border="0">
                    	<tr>
                        	<td style="font-weight:bold"><font color="0000FF">Category</font></td>
                        	<td style="font-weight:bold"><font color="0000FF">Quantity</font></td>
                        	<td style="font-weight:bold"><font color="0000FF">Item</font></td>
                        </tr>
                        <tr><td colspan="3"><hr></td></tr>
                        <cfloop query="qryQuoteComponents">
                            <tr>
                                <td><strong>#qryQuoteComponents.TypeName#:</strong></td>
                                <td width="10%" align="center"><strong>#qryQuoteComponents.Quantity#</strong></td>
                                <td>
                                    <cfif trim(qryQuoteComponents.ITEMNO) IS "[NONE]">					
                                        <font style="color:000099; font-weight:bold">#qryQuoteComponents.ITEMNO#</font>
                                    <cfelse>
                                        <font style="color:000099; font-weight:bold">#qryQuoteComponents.ITEMNO#:</font> #qryQuoteComponents.ITEMDESC#
                                    </cfif>
                                </td>
                            </tr>
						</cfloop>    
						<cfif isNumeric(strQuoteSystem.AdditionalWarrantyAmount)> 
                            <tr>
                                <td><strong>Depot Warranty:</strong></td>
                                <td align="center"><strong>1</strong></td>
                                <td>
                                    <font style="color:000099; font-weight:bold">#strQuoteSystem.AdditionalWarrantyName#</font>
                                </td>
                            </tr>
                        </cfif>
                                            
                    </table>
                </td>
            </tr>

		</table>

		</body>
		</html>	
		</cfmail>
	
	</cffunction>

	<!----------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="sendEmailToResellers" access="public" output="No">
	<!--- When a customer submits a quote request from the exportable configurator, emails are sent to all email
		  addresses in the "EmailAddresses" field in table "login" for this reseller --->
	<cfargument name="QuoteSystemID" type="string" required="Yes">
	<cfargument name="Type" type="string" required="no">
		<cfif NOT isDefined("Arguments.Type")>
			<cfset Arguments.Type = "quote">
		</cfif>
		<cfset objCust = createObject("component", "admin.assets.cfcs.Cust")>
		<cfset strQuoteSystem = getRecord(Arguments.QuoteSystemID)>
		<cfset strReseller = objCust.getLoginRecord(strQuoteSystem.CustomerID)>
		<cfset lstAddresses = strReseller.EmailAddresses>
		<cfif trim(lstAddresses) IS "">
			<cfset sendEmailToReseller(Arguments.QuoteSystemID, strReseller.email, Arguments.Type)>
		<cfelse>
			<cfloop list="#lstAddresses#" index="ResellerAddress">
				<cfif trim(ResellerAddress) IS NOT "">
					<cfset sendEmailToReseller(Arguments.QuoteSystemID, ResellerAddress, Arguments.Type)>
				</cfif>
			</cfloop>
		</cfif>
	</cffunction>

	<!----------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="sendEmailToReseller" access="public" output="No">
	<!--- When a quote is submitted, this ends an email to the Reseller (partner) --->
	<cfargument name="QuoteSystemID" type="string" required="Yes">
	<cfargument name="ResellerEmailAddress" type="string" required="No">
	<cfargument name="Type" type="string" required="no">
		<cfset var LoopCount = 0>
		<cfif NOT isDefined("Arguments.Type")>
			<cfset Arguments.Type = "quote">
		</cfif>
        
		<cfset objSalesRep = createObject("component", "admin.assets.cfcs.SalesRep")>
		<cfset objQuoteComponents = createObject("component", "admin.assets.cfcs.config.QuoteComponents")>
		<cfset objCust = createObject("component", "admin.assets.cfcs.Cust")>

		<cfset strQuoteSystem = getRecord(Arguments.QuoteSystemID)>
		<cfset strReseller = objCust.getLoginRecord(strQuoteSystem.CustomerID)>
		
		<cfif isDefined("Arguments.ResellerEmailAddress") AND trim(Arguments.ResellerEmailAddress) IS NOT "">
			<cfset ResellerEmailAddress = Arguments.ResellerEmailAddress>
		<cfelse>
			<cfset ResellerEmailAddress = getSessionValue("email")>
		</cfif>
        
        <cfif ResellerEmailAddress IS "">
			<cfset ResellerEmailAddress = strReseller.email>
		</cfif>

		<cfif strQuoteSystem.CustomerQuote>
			<cfset strSalesRep = objSalesRep.getRecordAsStruct(strQuoteSystem.SalesRepID)>
		<cfelse>
			<cfset SalesRepID = getSessionValue("salesrepid")>
			<cfset strSalesRep = objSalesRep.getRecordAsStruct(SalesRepID)>
		</cfif>

		<cfset qryQuoteComponents = objQuoteComponents.listRecordsForParent("QuoteSystemID", Arguments.QuoteSystemID, "TypeSortOrder")>

		<cfif trim(ResellerEmailAddress) IS NOT "">

			<!--- Get the sales rep's email address for the reply-to attribute --->
			<cfset ReplyToAddress = "info@nor-tech.com">
			<cfif structKeyExists(strSalesRep, "repemail") AND trim(strSalesRep.repemail) IS NOT "">
				<cfset ReplyToAddress = trim(strSalesRep.repemail)>
			</cfif>
SubjectText            
            <cfif Arguments.Type IS "quote">
            	<cfset SubjectText = "Your Online Quote">
            <cfelse>
            	<cfset SubjectText = "Your Online Order">
            </cfif>
	
			<cfmail from=	"Nor-Tech Online Configurator <info@nor-tech.com>" 
					to=		"#ResellerEmailAddress#" 
					replyto="#ReplyToAddress#"
					subject="#SubjectText#"
					type=	"html"
					timeout="60">
<!---				server="192.168.1.2" timeout="60">	--->
			<html>
			<head>
				<style type="text/css">
					BODY	{font-family:Arial, Helvetica, sans-serif; font-size:12px;}
					TD		{font-family:Arial, Helvetica, sans-serif; font-size:12px;}
				</style>
			</head>
			<body>
<!---            
			<cfif strQuoteSystem.CustomerQuote>
				The following is an online order submitted by one of your customers using the Nor-Tech partner branded system configurator.<br><br>
			<cfelse>
				Thank you for using the Nor-Tech Online Configurator. #strSalesRep.repname# will contact you shortly to confirm the final price on your quote.<br><br>
				The following is the online order you submitted:<br><br>
			</cfif>
--->	
			<table cellpadding="0" cellspacing="0" width="100%" border="0">
            	<cfif structKeyExists(strReseller, "LogoDisplay") AND strReseller.LogoDisplay EQ 1 AND
					  structKeyExists(strReseller, "Logo") AND strReseller.Logo IS NOT "">
					<cfset LogoAlignment = "left">
                    <cfif isDefined("strReseller.LogoAlign") AND trim(strReseller.LogoAlign) IS NOT "">
                        <cfset LogoAlignment = strReseller.LogoAlign>
                    </cfif>
                    <tr>
                        <td align="#LogoAlignment#" colspan="2">
<!---                      	<img src="http://www.nor-tech.com/partners/config/assets/logos/#strReseller.Logo#" alt="#strReseller.Company#" border="0">	--->
                        	<img src="http://partners.nor-tech.com/config/assets/logos/#strReseller.Logo#" alt="#strReseller.Company#" border="0">
<!---
                        	<img src="http://test.nor-tech.com/partnersTEST/config/assets/logos/#strReseller.Logo#" alt="#strReseller.Company#" border="0">
--->

                        </td>
                    </tr>
                </cfif>

                <tr>
                	<td colspan="2">
						<cfif strQuoteSystem.CustomerQuote>
                            The following is an online <cfif Arguments.Type IS "quote">quote<cfelse>order</cfif> submitted by one of your customers using the Nor-Tech partner branded system configurator.<br><br>
							<cfif strQuoteSystem.TurnOffPricing IS "1">
                                <strong>NOTE</strong>: This quote originated from a price-free configurator.  Please contact customer to provide real quote.<br><br>
                            </cfif>
                            
                        <cfelse>
                            Thank you for using the Nor-Tech Online Configurator. #strSalesRep.repname# will contact you shortly to confirm the final price on your <cfif Arguments.Type IS "quote">quote<cfelse>order</cfif>.<br><br>
                            The following is the online <cfif Arguments.Type IS "quote">quote<cfelse>order</cfif> you submitted:<br><br>
                        </cfif>
                	</td>
              	</tr>
                
                
	
                <tr><td>&nbsp;</td></tr>
                <tr>
                    <td><strong>Type:</strong></td>
                    <td>
                        <cfif Arguments.Type IS "quote">
                            <font color="9900FF"><strong>Quote</strong></font>
                        <cfelse>
                            <font color="FF0000"><strong>Order</strong></font>
                        </cfif>
                    </td>
                </tr>
                <tr><td>&nbsp;</td></tr>

				<cfif strQuoteSystem.CustomerQuote>
					<tr><td colspan="2"><strong>Customer Information:</strong></td></tr>
					<tr>
						<td colspan="2">
							#strQuoteSystem.CustFirstName# #strQuoteSystem.CustLastName# 
							<cfif trim(strQuoteSystem.CustTitle) IS NOT "">
								(#strQuoteSystem.CustTitle#)
							</cfif>
							<br>
							<cfif trim(strQuoteSystem.CustCompany) IS NOT "">
								#strQuoteSystem.CustCompany#<br>
							</cfif>
							#strQuoteSystem.CustEmail#<br>
							<cfif trim(strQuoteSystem.CustAddress1) IS NOT "" OR
								  trim(strQuoteSystem.CustAddress2) IS NOT "" OR
								  trim(strQuoteSystem.CustCity) IS NOT "" OR
								  trim(strQuoteSystem.CustState) IS NOT "" OR
								  trim(strQuoteSystem.CustZip) IS NOT "">
								<cfif trim(strQuoteSystem.CustAddress1) IS NOT "">
									#strQuoteSystem.CustAddress1#
								</cfif>
								<cfif trim(strQuoteSystem.CustAddress2) IS NOT "">
									, #strQuoteSystem.CustAddress2#
								</cfif>
								<cfif trim(strQuoteSystem.CustCity) IS NOT "">
									, #strQuoteSystem.CustCity#
								</cfif>
								<cfif trim(strQuoteSystem.CustState) IS NOT "">
									, #strQuoteSystem.CustState#
								</cfif>
								<cfif trim(strQuoteSystem.CustZip) IS NOT "">
									, #strQuoteSystem.CustZip#
								</cfif>
								<br>
							</cfif>
							<cfif trim(strQuoteSystem.CustPhone) IS NOT "">
								#strQuoteSystem.CustPhone#
								<cfif trim(strQuoteSystem.CustPhoneExtension) IS NOT "">
									ext #strQuoteSystem.CustPhoneExtension#
								</cfif>
								<br>
							</cfif>
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
				</cfif>
			
				<tr>
					<td width="15%"><strong>Quote Number:</strong></td>
					<td>#strQuoteSystem.QuoteNumber#</td>
				</tr>
				<tr>
					<td><strong>Quote Date:</strong></td>
					<td>#dateFormat(strQuoteSystem.QuoteDate, 'mmmm d, yyyy')#</td>
				</tr>
				
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td><strong>System Name:</strong></td>
					<td>
						<cfif trim(strQuoteSystem.SystemAlias) IS NOT "">
                            #strQuoteSystem.SystemAlias#
                        <cfelse>
                            #strQuoteSystem.SystemName#
                        </cfif>
                    </td>
				</tr>
				<tr>
					<td><strong>System Type:</strong></td>
					<td>
						<cfif strQuoteSystem.SystemType IS "MiniMountablePC">
                            Mini/Mountable PC
                        <cfelse>
                            #strQuoteSystem.SystemType#					
                        </cfif> 
                   	</td>
				</tr>
				
				<tr><td>&nbsp;</td></tr>
                
				<cfif strQuoteSystem.TurnOffPricing IS NOT "1">
                    <tr>
                        <td><strong>Price:</strong></td>
                        <td>#numberFormat(strQuoteSystem.ResellerPrice, '$.99')#</td>
                    </tr>
                </cfif>
                
				<tr>
					<td><strong>Quantity:</strong></td>
					<td>#strQuoteSystem.Quantity#</td>
				</tr>
                
				<cfif strQuoteSystem.TurnOffPricing IS NOT "1">
                    <tr>
                        <td><strong>Total:</strong></td>
                        <td>#numberFormat(strQuoteSystem.ResellerTotal, '$.99')#</td>
                    </tr>
				</cfif>
                                    
				<cfif isNumeric(strQuoteSystem.ShippingEstimate) AND strQuoteSystem.ShippingCriteria IS NOT "(Ship to , , )">  
                    <tr>
                        <td><strong>Estimated Shipping:</strong></td>
                        <td>
                        	#numberFormat(strQuoteSystem.ShippingEstimate, '$.99')#
                           	<cfif trim(strQuoteSystem.ShippingCriteria) IS NOT "">
                        		&nbsp;&nbsp;&nbsp; #strQuoteSystem.ShippingCriteria#
                        	</cfif>
                      	</td>
                    </tr>
                </cfif>
<!---                
				<cfif isNumeric(strQuoteSystem.AdditionalWarrantyAmount)>  
                    <tr>
                        <td><strong>Depot Warranty:</strong></td>
                        <td>
                            #numberFormat(strQuoteSystem.AdditionalWarrantyAmount, '$.99')#
                            <cfif trim(strQuoteSystem.AdditionalWarrantyName) IS NOT "">
                                &nbsp;&nbsp;&nbsp; (#strQuoteSystem.AdditionalWarrantyName#)
                            </cfif>
                        </td>
                    </tr>
                </cfif>
--->                
<!---			<cfif strQuoteSystem.CustomerQuote>	--->
					<tr><td>&nbsp;</td></tr>
					<cfif strQuoteSystem.TurnOffPricing IS NOT "1">
                        <tr>
                            <td><strong>Customer Price:</strong></td>
                            <td>#numberFormat(strQuoteSystem.CustPrice, '$.99')#</td>
                        </tr>
                        <tr>
                            <td><strong>Quantity:</strong></td>
                            <td>#strQuoteSystem.Quantity#</td>
                        </tr>
                        <tr>
                            <td><strong>Customer Total:</strong></td>
                            <td>#numberFormat(strQuoteSystem.CustTotal, '$.99')#</td>
                        </tr>
                  	</cfif>
<!---			</cfif>	--->				

				<tr><td>&nbsp;</td></tr>
				<tr>
					<td><strong>PO Number:</strong></td>
					<td>
						<cfif strQuoteSystem.CustomerQuote>
							#strQuoteSystem.CustPONumber#
						<cfelse>
							#strQuoteSystem.ResellerPONumber#
						</cfif>
					</td>
				</tr>
				<tr>
					<td><strong>Comments:</strong></td>
					<td>
						<cfif strQuoteSystem.CustomerQuote>
							#strQuoteSystem.CustComments#
						<cfelse>
							#strQuoteSystem.ResellerComments#
						</cfif>
					</td>
				</tr>
				
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td colspan="2"><strong>System Components:</strong></td>
				</tr>
				<tr><td>&nbsp;</td></tr>


                <tr>
                    <td colspan="2">
                        <table cellpadding="0" cellspacing="0" width="100%" border="0">
                            <tr>
                                <td style="font-weight:bold"><font color="0000FF">Category</font></td>
                                <td align="center" style="font-weight:bold"><font color="0000FF">Quantity</font></td>
                                <td style="font-weight:bold"><font color="0000FF">Item</font></td>
                            </tr>
                            <tr><td colspan="3"><hr></td></tr>
                            <cfloop query="qryQuoteComponents">
                                <tr>
                                    <td width="15%"><strong>#qryQuoteComponents.TypeName#:</strong></td>
                                    <td width="15%" align="center"><strong>#qryQuoteComponents.Quantity#</strong></td>
                                    <td>
                                        #qryQuoteComponents.ITEMDESC#
                                    </td>
                                </tr>
                            </cfloop>   
							<cfif isNumeric(strQuoteSystem.AdditionalWarrantyAmount)> 
                                <tr>
                                    <td><strong>Depot Warranty:</strong></td>
                                    <td align="center"><strong>1</strong></td>
                                    <td>
                                        <font style="color:000099; font-weight:bold">#strQuoteSystem.AdditionalWarrantyName#</font>
                                    </td>
                                </tr>
                            </cfif>
                                                 
                        </table>
                    </td>
                </tr>

			</table>
	
			<br>Thank you for your business and for being a valued Nor-Tech customer!<br><br>
	
			#strSalesRep.repname#<br>
			Northern Computer Technologies<br>
			<cfif trim(strSalesRep.repphone) IS NOT "">
				#strSalesRep.repphone#<br>
			</cfif>
			#strSalesRep.repemail#<br>
			www.nor-tech.com
			</body>
			</html>	
			</cfmail>
            
            <cfquery datasource="#This.DataSourceName#">
            UPDATE 	tblQuoteSystem
            SET		QuoteSent = 1
            WHERE 	QuoteSystemID = '#Arguments.QuoteSystemID#'
            </cfquery>	
            
		</cfif>
	
	</cffunction>
	
	<cffunction name="sendQuoteToACCPAC" access="public" output="No">
	<cfargument name="QuoteSystemID" type="string" required="Yes">
	<cfargument name="Type" type="string" required="no">
        <cfset local.csv = "">
		<cfset objQuoteComponents = createObject("component", "admin.assets.cfcs.config.QuoteComponents")>
		<cfset strQuoteSystem = getRecord(Arguments.QuoteSystemID)>
		<cfset qryQuoteComponents = objQuoteComponents.listRecordsForParent("QuoteSystemID", Arguments.QuoteSystemID, "TypeSortOrder")>
		
		<!--- change/update quote number for accpac compatibility --->
		<!---
		<cfif left(strQuoteSystem.QuoteNumber,2) is "QQ">
			<cfset strQuoteSystem.QuoteNumber = "Q2" & right(strQuoteSystem.QuoteNumber,len(strQuoteSystem.QuoteNumber)-2)>
		<cfelseif left(strQuoteSystem.QuoteNumber, 1) is "Q" AND left(strQuoteSystem.QuoteNumber, 2) is not "Q2">
			<cfset strQuoteSystem.QuoteNumber = "Q2" & right(strQuoteSystem.QuoteNumber,len(strQuoteSystem.QuoteNumber)-1)>
		</cfif>
		<cfquery datasource="#This.DataSourceName#">
		UPDATE tblQuoteSystem
		SET QuoteNumber = '#strQuoteSystem.QuoteNumber#'
		WHERE QuoteSystemID = '#arguments.QuoteSystemID#'
		</cfquery>
		--->
		
		<cfset local.nonmatchparts = matchParts(arguments.QuoteSystemID)>
		
		<!--- create CSV data --->
		<cfif trim(strQuoteSystem.CustCompany) IS NOT "">
			<cfset strQuoteSystem.CustFullName = trim(strQuoteSystem.CustCompany)>
		<cfelse>
			<cfset strQuoteSystem.CustFullName = trim(strQuoteSystem.CustFirstName & strQuoteSystem.CustLastName)>
		</cfif>
		<cfsavecontent variable="local.csv">
		<cfoutput>
		RECTYPE,ORDUNIQ,ORDNUMBER,CUSTOMER,SHIPTO,PONUMBER,TEMPLATE,LOCATION,ORDTOTAL,ORDMTOTAL,ORDLINES,COMMENT#chr(13)##chr(10)#
		RECTYPE,ORDUNIQ,LINENUM,LINETYPE,ITEM,MISCCHARGE,LOCATION,QTYORDERED,UNITPRICE,PRIUNTPRC,EXTINVMISC,#chr(13)##chr(10)#
		RECTYPE,ORDUNIQ,LINENUM,SERIALNUMF,,,,,,,,#chr(13)##chr(10)#
		RECTYPE,ORDUNIQ,LINENUM,LOTNUMF,,,,,,,,#chr(13)##chr(10)#
		RECTYPE,ORDUNIQ,PAYMENT,DISCBASE,DISCDATE,DISCPER,DISCAMT,DUEBASE,DUEDATE,DUEPER,DUEAMT,#chr(13)##chr(10)#
		RECTYPE,ORDUNIQ,OPTFIELD,VALUE,,,,,,,,#chr(13)##chr(10)#
		1,1000,'#trim(strQuoteSystem.QuoteNumber)#','#strQuoteSystem.CustFullName#','','#strQuoteSystem.CustPONumber#','MAIN',1,#strQuoteSystem.CustTotal#,0,#qryQuoteComponents.RecordCount#,'#trim(strQuoteSystem.CustComments)#'#chr(13)##chr(10)#
		<cfloop query="qryQuoteComponents">
			<cfif arrayFindNoCase(local.nonmatchparts, qryQuoteComponents.ITEMNO) eq 0>
				2,1000,#val(qryQuoteComponents.CurrentRow * 32)#,1,'#trim(qryQuoteComponents.ITEMDESC)#',,1,#qryQuoteComponents.Quantity#,#qryQuoteComponents.SellingPrice#,#qryQuoteComponents.SellingPrice#,#val(qryQuoteComponents.SellingPrice * qryQuoteComponents.Quantity)##chr(13)##chr(10)#
			</cfif>
		</cfloop>
		</cfoutput>
		</cfsavecontent>
		
		<!--- write file to disk --->
		<cffile action="WRITE" file="#APPLICATION.AdminDirPath#assets\files\#trim(strQuoteSystem.QuoteNumber)#.csv" output="#trim(local.csv)#" addNewLine="no" fixnewline="no" nameconflict="OVERWRITE">
	</cffunction>
	
	
	<cffunction name="matchParts" access="public" returntype="array" output="no">
	<cfargument name="QuoteSystemID" type="string" required="Yes">
	<cfargument name="IncludeType" type="boolean" required="no" default="0">
		<cfset local.nomatches = arrayNew(1)>
		<cfset objQuoteComponents = createObject("component", "admin.assets.cfcs.config.QuoteComponents")>
		<cfset objConfigComponents = createObject("component", "admin.assets.cfcs.config.ConfigComponents")>
		<cfset qryQuoteComponents = objQuoteComponents.listRecordsForParent("QuoteSystemID", Arguments.QuoteSystemID, "TypeSortOrder")>
		<cfloop query="qryQuoteComponents">
			<cfif objConfigComponents.isConfigurable(qryQuoteComponents.ITEMNO) eq 0>
				<cfif arguments.IncludeType eq 1>
					<cfset local.item = "#trim(qryQuoteComponents.TypeName)#: #trim(qryQuoteComponents.ITEMNO)#">
					<cfset arrayAppend(local.nomatches, local.item)>
				<cfelse>
					<cfset arrayAppend(local.nomatches, qryQuoteComponents.ITEMNO)>
				</cfif>
			</cfif>
		</cfloop>
		<cfreturn local.nomatches>	
	</cffunction>

	
	<cffunction name="sendQuoteToReseller" access="public" returntype="boolean" output="No">
	<!--- When a quote is submitted, this ends an email to the Reseller (partner) --->
	<cfargument name="QuoteSystemID" type="string" required="Yes">
	<cfargument name="Record" type="struct" required="Yes">
    	<cfset var Success = 0>
        <cfset var SendToAddresses = "">
        <cfset var strQuoteSystem = structNew()>
        <cfset var strSalesRep = structNew()>
        <cfset var qryQuoteComponents = queryNew("")>
        <cfset var ReplyToAddress = "">
		<cfset var EmailText = "">
       
		<cfset objSalesRep = createObject("component", "admin.assets.cfcs.SalesRep")>
		<cfset objQuoteComponents = createObject("component", "admin.assets.cfcs.config.QuoteComponents")>
        
		<cfset strQuoteSystem = getRecord(Arguments.QuoteSystemID)>
		<cfset strSalesRep = objSalesRep.getRecordAsStruct(strQuoteSystem.SalesRepID)>
		<cfset qryQuoteComponents = objQuoteComponents.listRecordsForParent("QuoteSystemID", Arguments.QuoteSystemID, "TypeSortOrder")>

        <!--- Get the sales rep's email address for the reply-to attribute --->
        <cfset ReplyToAddress = "info@nor-tech.com">
        <cfif structKeyExists(Arguments.Record, "SalesRepEmail") AND trim(Arguments.Record.SalesRepEmail) IS NOT "">
            <cfset ReplyToAddress = trim(Arguments.Record.SalesRepEmail)>
        </cfif>
        
        <cfif Arguments.Record.SendToCustomer AND Arguments.Record.SendToSalesRep>
          <cfset SendToAddresses = Arguments.Record.ResellerEmailAddress & "; " & Arguments.Record.SalesRepEmail>
        <cfelseif Arguments.Record.SendToCustomer AND NOT Arguments.Record.SendToSalesRep>
            <cfset SendToAddresses = Arguments.Record.ResellerEmailAddress>
        <cfelseif NOT Arguments.Record.SendToCustomer AND Arguments.Record.SendToSalesRep>
          <cfset SendToAddresses = Arguments.Record.SalesRepEmail>
        </cfif>
        
        <cfif SendToAddresses IS NOT "">
        
<!---      	<cfif strQuoteSystem.ConfigSystemID IS "">	--->
				<cfset EmailText = emailFormattedQuote(Arguments.QuoteSystemID, 1)>		<!--- 1=IncludeNorTechLogo --->
<!---		<cfelse>
				<cfset EmailText = emailFormattedQuote(Arguments.QuoteSystemID, 0)>
			</cfif>	--->

            <cfmail from=	"Nor-Tech <info@nor-tech.com>" 
                    to=		"#SendToAddresses#" 
                    replyto="#ReplyToAddress#"
                    subject="Nor-Tech Quote (Quote Number #strQuoteSystem.QuoteNumber#)"
                    type=	"html"
                    timeout="60">
            <html>
            <head>
                <style type="text/css">
                    BODY	{font-family:Arial, Helvetica, sans-serif; font-size:12px;}
                    TD		{font-family:Arial, Helvetica, sans-serif; font-size:12px;}
                </style>
            </head>
            <body>
            #EmailText#
            </body>
            </html>	
            </cfmail>
            
            <cfquery datasource="#This.DataSourceName#">
            UPDATE 	tblQuoteSystem
            SET		QuoteSent = 1
            WHERE 	QuoteSystemID = '#Arguments.QuoteSystemID#'
            </cfquery>	
            
           	<cfset Success = 1>
        </cfif>
                	
		<cfreturn Success>
	</cffunction>

	<!----------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="sendEmailToCustomer" access="public" output="No">
	<!--- When a quote is submitted, this ends an email to the Customer (the Reseller/partner's customer) --->
	<cfargument name="QuoteSystemID" type="string" required="Yes">
		<cfset objSalesRep = createObject("component", "admin.assets.cfcs.SalesRep")>
		<cfset objQuoteComponents = createObject("component", "admin.assets.cfcs.config.QuoteComponents")>
		<cfset objCust = createObject("component", "admin.assets.cfcs.Cust")>

		<cfset strQuoteSystem = getRecord(Arguments.QuoteSystemID)>
		<cfset strReseller = objCust.getLoginRecord(strQuoteSystem.CustomerID)>
		
		<cfset qryQuoteComponents = objQuoteComponents.listRecordsForParent("QuoteSystemID", Arguments.QuoteSystemID, "TypeSortOrder")>

		<cfmail from=	"#strReseller.company# <#strReseller.email#>" 
				to=		"#strQuoteSystem.CustEmail#" 
				subject="Your Online Quote"
				type=	"html"
				timeout="60">
<!---			server="192.168.1.2" timeout="60">	--->
		<html>
		<head>
			<style type="text/css">
				BODY	{font-family:Arial, Helvetica, sans-serif; font-size:12px;}
				TD		{font-family:Arial, Helvetica, sans-serif; font-size:12px;}
			</style>
		</head>
		<body>
<!---        
		Thank you for submitting a quote request using the #strReseller.company# Online Configurator.<br>
		A sales person will be in contact with you shortly to review your quote.&nbsp;&nbsp;&nbsp; Below you will find a copy of your quote.<br><br>		
--->		
		<table cellpadding="0" cellspacing="0" width="100%" border="0">
			<cfif structKeyExists(strReseller, "LogoDisplay") AND strReseller.LogoDisplay EQ 1 AND
                  structKeyExists(strReseller, "Logo") AND strReseller.Logo IS NOT "">
                <cfset LogoAlignment = "left">
                <cfif isDefined("strReseller.LogoAlign") AND trim(strReseller.LogoAlign) IS NOT "">
                    <cfset LogoAlignment = strReseller.LogoAlign>
                </cfif>
                <tr>
                    <td align="#LogoAlignment#" colspan="2">
<!---                   <img src="http://www.nor-tech.com/partners/config/assets/logos/#strReseller.Logo#" alt="#strReseller.Company#" border="0">	--->
                        <img src="http://partners.nor-tech.com/config/assets/logos/#strReseller.Logo#" alt="#strReseller.Company#" border="0">
                    </td>
                </tr>
            </cfif>

			<tr>
            	<td colspan="2">
                    Thank you for submitting a quote request using the #strReseller.company# Online Configurator.<br>
                    A sales person will be in contact with you shortly to review your quote.&nbsp;&nbsp;&nbsp; Below you will find a copy of your quote.<br><br>		
              	</td>
       		</tr>
        
			<tr><td colspan="2"><strong>Customer Information:</strong></td></tr>
			<tr>
				<td colspan="2">
					#strQuoteSystem.CustFirstName# #strQuoteSystem.CustLastName# 
					<cfif trim(strQuoteSystem.CustTitle) IS NOT "">
						(#strQuoteSystem.CustTitle#)
					</cfif>
					<br>
					<cfif trim(strQuoteSystem.CustCompany) IS NOT "">
						#strQuoteSystem.CustCompany#<br>
					</cfif>
					#strQuoteSystem.CustEmail#<br>
					<cfif trim(strQuoteSystem.CustAddress1) IS NOT "" OR
						  trim(strQuoteSystem.CustAddress2) IS NOT "" OR
						  trim(strQuoteSystem.CustCity) IS NOT "" OR
						  trim(strQuoteSystem.CustState) IS NOT "" OR
						  trim(strQuoteSystem.CustZip) IS NOT "">
						<cfif trim(strQuoteSystem.CustAddress1) IS NOT "">
							#strQuoteSystem.CustAddress1#
						</cfif>
						<cfif trim(strQuoteSystem.CustAddress2) IS NOT "">
							, #strQuoteSystem.CustAddress2#
						</cfif>
						<cfif trim(strQuoteSystem.CustCity) IS NOT "">
							, #strQuoteSystem.CustCity#
						</cfif>
						<cfif trim(strQuoteSystem.CustState) IS NOT "">
							, #strQuoteSystem.CustState#
						</cfif>
						<cfif trim(strQuoteSystem.CustZip) IS NOT "">
							, #strQuoteSystem.CustZip#
						</cfif>
						<br>
					</cfif>
					<cfif trim(strQuoteSystem.CustPhone) IS NOT "">
						#strQuoteSystem.CustPhone#
						<cfif trim(strQuoteSystem.CustPhoneExtension) IS NOT "">
							ext #strQuoteSystem.CustPhoneExtension#
						</cfif>
						<br>
					</cfif>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
		
			<tr>
				<td width="15%"><strong>Quote Number:</strong></td>
				<td>#strQuoteSystem.QuoteNumber#</td>
			</tr>
			<tr>
				<td><strong>Quote Date:</strong></td>
				<td>#dateFormat(strQuoteSystem.QuoteDate, 'mmmm d, yyyy')#</td>
			</tr>
			
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td><strong>System Name:</strong></td>
				<td>
					<cfif trim(strQuoteSystem.SystemAlias) IS NOT "">
                        #strQuoteSystem.SystemAlias#
                    <cfelse>
                        #strQuoteSystem.SystemName#
                    </cfif>
              	</td>
			</tr>
			<tr>
				<td><strong>System Type:</strong></td>
				<td>#strQuoteSystem.SystemType#</td>
			</tr>
			
			<tr><td>&nbsp;</td></tr>
            
			<cfif strQuoteSystem.TurnOffPricing IS NOT "1">
                <tr>
                    <td><strong>System Price:</strong></td>
                    <td>#numberFormat(strQuoteSystem.CustPrice, '$.99')#</td>
                </tr>
           	</cfif>
            
			<tr>
				<td><strong>Quantity:</strong></td>
				<td>#strQuoteSystem.Quantity#</td>
			</tr>
            
			<cfif strQuoteSystem.TurnOffPricing IS NOT "1">            
                <tr>
                    <td><strong>Total Price:</strong></td>
                    <td>#numberFormat(strQuoteSystem.CustTotal, '$.99')#</td>
                </tr>
			</cfif>
            
			<cfif isNumeric(strQuoteSystem.ShippingEstimate) AND strQuoteSystem.ShippingCriteria IS NOT "(Ship to , , )"> 
                <tr>
                    <td><strong>Estimated Shipping:</strong></td>
                    <td>
                    	#numberFormat(strQuoteSystem.ShippingEstimate, '$.99')#
						<cfif trim(strQuoteSystem.ShippingCriteria) IS NOT "">
                            &nbsp;&nbsp;&nbsp; #strQuoteSystem.ShippingCriteria#
                        </cfif>
                    </td>
                </tr>
			</cfif>
			
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td><strong>PO Number:</strong></td>
				<td>#strQuoteSystem.CustPONumber#</td>
			</tr>
			<tr>
				<td><strong>Comments:</strong></td>
				<td>#strQuoteSystem.CustComments#</td>
			</tr>
			
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td colspan="2"><strong>System Components:</strong></td>
			</tr>
			<tr><td>&nbsp;</td></tr>

            <tr>
                <td colspan="2">
                    <table cellpadding="0" cellspacing="0" width="100%" border="0">
                        <tr>
                            <td style="font-weight:bold"><font color="0000FF">Category</font></td>
                            <td align="center" style="font-weight:bold"><font color="0000FF">Quantity</font></td>
                            <td style="font-weight:bold"><font color="0000FF">Item</font></td>
                        </tr>
                        <tr><td colspan="3"><hr></td></tr>
                        <cfloop query="qryQuoteComponents">
                            <tr>
                                <td width="15%"><strong>#qryQuoteComponents.TypeName#:</strong></td>
                                <td width="15%" align="center"><strong>#qryQuoteComponents.Quantity#</strong></td>
                                <td>
                                    #qryQuoteComponents.ITEMDESC#
                                </td>
                            </tr>
                        </cfloop>                        
						<cfif isNumeric(strQuoteSystem.AdditionalWarrantyAmount)> 
                            <tr>
                                <td><strong>Depot Warranty:</strong></td>
                                <td align="center"><strong>1</strong></td>
                                <td>
                                    <font style="color:000099; font-weight:bold">#strQuoteSystem.AdditionalWarrantyName#</font>
                                </td>
                            </tr>
                        </cfif>
                    </table>
                </td>
            </tr>

<!---
			<cfloop query="qryQuoteComponents">
				<tr>
					<td><strong>#qryQuoteComponents.TypeName#:</strong></td>
					<td>
						#qryQuoteComponents.ITEMDESC#
					</td>
				</tr>
			</cfloop>
--->

		</table>

		<br><br>

		Best Regards,<br>
		#strReseller.firstname# #strReseller.lastname#<br>
		#strReseller.company#<br>
		#strReseller.email#<br>
		#strReseller.RootURL#<br>
		
		</body>
		</html>	
		</cfmail>
	
	</cffunction>

	<cffunction name="listQuotes" access="public" returntype="query" output="No">
	<cfargument name="SystemType" type="string" required="Yes">
		<cfset var qryQuoteSystem = queryNew(This.ViewColumns)>
		<cfset objCust = createObject("component", "admin.assets.cfcs.Cust")>
		<cfset loginID = getSessionValue("ID")>
		<cfset qrylogin = objCust.getRecordAsQuery(loginID)>
		<cfif qrylogin.RecordCount NEQ 0>
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "CustomerID", qrylogin.CustomerID, True)>
            <cfif Arguments.SystemType IS NOT "Parts Quotes">
				<cfset structInsert(SearchRecord, "SystemType", Arguments.SystemType, True)>
				<cfset qryQuoteSystem = searchRecords(SearchRecord, "query", "QuoteDate DESC")>
            <cfelse>
                <cfquery datasource="#This.DataSourceName#" name="qryQuoteSystem">
                SELECT	*
                FROM	tblQuoteSystem
                WHERE 	CustomerID = '#qrylogin.CustomerID#' AND
                		ConfigSystemID = ''
                </cfquery>	
            </cfif>
		</cfif>
		<cfreturn qryQuoteSystem>
	</cffunction>

	<cffunction name="searchQuotes" access="public" returntype="query" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset objCust = createObject("component", "admin.assets.cfcs.Cust")>
		<cfset loginID = getSessionValue("ID")>
		<cfset qrylogin = objCust.getRecordAsQuery(loginID)>
		<cfif trim(Arguments.Record.QuoteDate) IS NOT "">
			<cfset StartDate = dateFormat(Arguments.Record.QuoteDate, "yyyy-mm-dd 00:00:00.0")>
			<cfset EndDate = DateFormat(Arguments.Record.QuoteDate, "yyyy-mm-dd 23:59:59.9")>
		</cfif>
		<cfquery datasource="#This.DataSourceName#" name="qryQuoteSearch">
		SELECT	*
		FROM    tblQuoteSystem 
		WHERE   CustomerID = '#qrylogin.CustomerID#'
			<cfif trim(Arguments.Record.QuoteTitle) IS NOT "">
				AND QuoteTitle LIKE '%#Arguments.Record.QuoteTitle#%'
			</cfif>
			<cfif trim(Arguments.Record.QuoteDate) IS NOT "">
				AND QuoteDate >= '#StartDate#'
				AND QuoteDate <= '#EndDate#'
			</cfif>
			<cfif trim(Arguments.Record.QuoteNumber) IS NOT "">
				AND QuoteNumber LIKE '%#Arguments.Record.QuoteNumber#%'
			</cfif>
		ORDER BY	QuoteDate DESC, QuoteNumber
		</cfquery>	
		<cfreturn qryQuoteSearch>
	</cffunction>

	<!----------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="emailFormattedQuote" access="public" returntype="string" output="No">
	<cfargument name="QuoteSystemID" type="string" required="Yes">
	<cfargument name="IncludeNorTechLogo" type="boolean" required="no">
		<cfset var EmailText = "">
        <cfset var LoopCount = 0>
		<cfset var BackGroundColor = "">
        <cfset var PartsOnly = 0>
        <cfset var ImageName = "">
		<cfset objQuoteSystem = createObject("component", "admin.assets.cfcs.config.QuoteSystem")>
		<cfset objQuoteComponents = createObject("component", "admin.assets.cfcs.config.QuoteComponents")>
		<cfset objLogin = createObject("component", "admin.assets.cfcs.Cust")>
		<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>

		<cfif NOT isDefined("Arguments.IncludeNorTechLogo")>
			<cfset Arguments.IncludeNorTechLogo = 0>
		</cfif>

		<cfset strQuoteSystem = objQuoteSystem.getRecord(Arguments.QuoteSystemID)>
        
		<cfif strQuoteSystem.ConfigSystemID IS "">
        	<cfset PartsOnly = 1>
        <cfelse>
        	<cfset PartsOnly = 0>
        </cfif>
        
		<cfset qryQuoteComponents = objQuoteComponents.listRecordsForParent("QuoteSystemID", strQuoteSystem.QuoteSystemID, "TypeSortOrder")>
		
		<cfset qryLogin = objLogin.getLoginRecord(strQuoteSystem.CustomerID)>		
		<cfsavecontent variable="EmailText">
			<cfoutput>

			<table width="95%" border="0" align="center" cellpadding="6" cellspacing="0">
				<cfif trim(strQuoteSystem.QuoteTitle) IS NOT "">
					<tr>
						<td colspan="2" align="center">
							<font size="4" color="0033CC" face="Verdana, Arial, Helvetica, sans-serif"><strong>								
								#strQuoteSystem.QuoteTitle#
							</strong></font>
						</td>
					</tr>				
				</cfif>
				<tr>
					<td>
                    	<!--- Partner logo --->
						<cfif qryLogin.LogoDisplay EQ 1 AND trim(qryLogin.Logo) IS NOT "">
<!---						
							<cfif isDefined("APPLICATION.PartnersLocation")>
                                <img src="https://www.nor-tech.com/#APPLICATION.PartnersLocation#/config/assets/logos/#qryLogin.Logo#" alt="Customer Logo" name="logo" border="0"><br>
							<cfelse>
                                <img src="https://www.nor-tech.com/partners/config/assets/logos/#qryLogin.Logo#" alt="Customer Logo" name="logo" border="0"><br>
							</cfif>
--->
							<img src="https://partners.nor-tech.com/config/assets/logos/#qryLogin.Logo#" alt="Customer Logo" name="logo" border="0"><br>
							
						</cfif>
						<font size="2" face="Arial, Helvetica, sans-serif"><strong>
							#qryLogin.company#<br>
							#qryLogin.firstname# #qryLogin.lastname#<br>
							#qryLogin.email#<br>
							<cfif trim(qryLogin.PhoneNumber) IS NOT "">
								#qryLogin.PhoneNumber#<br>
							</cfif>
						</strong></font>						
					</td>
                    <!--- NOR-TECH LOGO --->
					<td align="center" valign="bottom">
                    	<cfif Arguments.IncludeNorTechLogo>
<!---						
                    		<img src="https://www.nor-tech.com/ImagesTemp/logo2.jpg" alt="Nor-Tech Logo" name="nortechlogo" border="0"><br>
--->
                    		<img src="https://partners.nor-tech.com/images/logo2.jpg" alt="Nor-Tech Logo" name="nortechlogo" border="0"><br>							
						<cfelse>
                        	&nbsp;
                        </cfif>                            
                    </td>
                    
				</tr>
			
				<tr>
					<td colspan="2" class="textsmall"><div align="left" class="subhead">
					<table width="100%" border="0" cellspacing="0" cellpadding="3">
						<tr>
							<td width="34%">
                            	<cfset ImageName = objConfigSystems.getImageName3(Arguments.QuoteSystemID)>
                                
<!---							<cfif trim(strQuoteSystem.SystemPhoto) IS NOT "">	--->
								<cfif ImageName IS NOT "">
									
<!---									
									<cfif isDefined("APPLICATION.PartnersLocation")>
										<img src="https://www.nor-tech.com/#APPLICATION.PartnersLocation#/images/systems/#ImageName#">
									<cfelse>
										<img src="https://www.nor-tech.com/partners/images/systems/#ImageName#">
                                    </cfif>
--->								
									<!--- 5/10/2013 --->	
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
													<cfif trim(strQuoteSystem.SystemAlias) IS NOT "">
                                                        #strQuoteSystem.SystemAlias#
                                                    <cfelse>
                                                        #strQuoteSystem.SystemName#
                                                    </cfif>
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
					</td>
				</tr>
				<tr>
					<td colspan="2" class="textsmall">&nbsp;</td>
				</tr>
				
				<tr>
					<td valign="top" class="systemCategory" bgcolor="F3F3F3">
						<div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><strong>
							Quote Number:
						</strong></font></div>
					</td>
					<td class="textsmall" valign="top" class="textsmall" bgcolor="F3F3F3">
						<font size="2" face="Arial, Helvetica, sans-serif">
							#strQuoteSystem.QuoteNumber#
						</font>
					</td>
				</tr>

				<tr>
					<td valign="top" width="39%" class="systemCategory">
						<div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><strong>
							Quote Date:
						</strong></font></div>
					</td>
					<td class="textsmall" valign="top" class="textsmall">
						<font size="2" face="Arial, Helvetica, sans-serif">
							#LSDateFormat(strQuoteSystem.QuoteDate,'M/DD/YYYY')#
						</font>
					</td>
				</tr>
                
				<cfif isNumeric(strQuoteSystem.ShippingEstimate) AND strQuoteSystem.ShippingCriteria IS NOT "(Ship to , , )">  
                    <tr>
                        <td valign="top" class="systemCategory" bgcolor="F3F3F3">
                            <div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><strong>
                                Estimated Shipping:
                            </strong></font></div>
                        </td>
                        <td class="textsmall" valign="top" bgcolor="F3F3F3">
                            <font size="2" face="Arial, Helvetica, sans-serif">
                                #dollarFormat(strQuoteSystem.ShippingEstimate)#
								<cfif trim(strQuoteSystem.ShippingCriteria) IS NOT "">
                                    &nbsp;&nbsp;&nbsp; #strQuoteSystem.ShippingCriteria#
                                </cfif>
                            </font>
                        </td>
                    </tr>
                </cfif>
<!---
				<cfif isNumeric(strQuoteSystem.AdditionalWarrantyAmount)>  
                    <tr>
                        <td valign="top" class="systemCategory" bgcolor="F3F3F3">
                            <div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><strong>
                                Depot Warranty:
                            </strong></font></div>
                        </td>
                        <td class="textsmall" valign="top" bgcolor="F3F3F3">
                            <font size="2" face="Arial, Helvetica, sans-serif">
                                #dollarFormat(strQuoteSystem.AdditionalWarrantyAmount)#
								<cfif trim(strQuoteSystem.AdditionalWarrantyName) IS NOT "">
                                    &nbsp;&nbsp;&nbsp; (#strQuoteSystem.AdditionalWarrantyName#)
                                </cfif>
                            </font>
                        </td>
                    </tr>
                </cfif>
--->			
				<!--- SYSTEM SUMMARY --->
				<cfif NOT PartsOnly>
                    <tr>
                        <td valign="top" colspan="2">
                            <table width="100%" border="0" cellpadding="6" cellspacing="0">
    
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
				<cfif trim(strQuoteSystem.ResellerPONumber) IS NOT "">
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
				</cfif>
			
				<!--- RESELLER'S COMMENTS --->
				<cfif trim(strQuoteSystem.ResellerComments) IS NOT "">
					<tr>
						<td valign="top" <cfif BackGroundColor IS "F3F3F3">bgcolor="F3F3F3"</cfif>>
							<div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><strong>
								Comments:
							</strong></font></div>
						</td>
						<td class="textsmall" valign="top" <cfif BackGroundColor IS "F3F3F3">bgcolor="F3F3F3"</cfif>>
							<font size="2" face="Arial, Helvetica, sans-serif">
								#strQuoteSystem.ResellerComments#
							</font>
						</td>
					</tr>
				</cfif>
			
<!---
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
--->				
			
				<tr>
					<td colspan="2" class="textsmall">
						<font size="2" color="FF0000" face="Arial, Helvetica, sans-serif">
							The total cost listed above is an estimate only. It does not include shipping and handling costs. 
							Please contact your sales representative with any questions.
						</font>
					</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
			</table>

			</cfoutput>
		</cfsavecontent>
		<cfreturn EmailText>
	</cffunction>
    
	<cffunction name="getQuantityOfSystems" access="public" returntype="numeric" output="No">
	<cfargument name="QuoteSystemID" type="string" required="Yes">
		<cfset var QuantityOfSystems = 0>
		<cfset var qryQuoteSystem = queryNew("Quantity")>
		<cfquery datasource="#This.DataSourceName#" name="qryQuoteSystem">
		SELECT	Quantity
		FROM 	#This.TableName#
		WHERE	QuoteSystemID = '#Arguments.QuoteSystemID#'
		</cfquery>
		<cfif qryQuoteSystem.RecordCount NEQ 0 AND isNumeric(qryQuoteSystem.Quantity)>
			<cfset QuantityOfSystems = qryQuoteSystem.Quantity>
		</cfif>		
		<cfreturn QuantityOfSystems>
	</cffunction>

<!---
	<cffunction name="getQuoteTotalPrice" access="public" returntype="numeric" output="No">
	<cfargument name="strQuoteScreen3" type="struct" required="Yes">
	<cfargument name="strQuoteScreen4" type="struct" required="Yes">
		<cfset var QuoteTotalPrice = 0>
		
		<cfset PriceListID = Arguments.strQuoteScreen3.PriceListID>

		<cfquery datasource="#This.DataSourceName#" name="qryConfigSystem">
		SELECT	SystemBasePrice
		FROM 	tblConfigSystems
		WHERE	ConfigSystemID = '# Arguments.strQuoteScreen3.ConfigSystemID#'
		</cfquery>
		<cfif qryConfigSystem.RecordCount NEQ 0>
			<cfset QuoteTotalPrice = QuoteTotalPrice + qryConfigSystem.SystemBasePrice>
		</cfif>

		<cfset lstScreen3 = structKeyList(Arguments.strQuoteScreen3)>
		<cfloop list="#lstScreen3#" index="Column">
			<cfif findNoCase('CAT_', Column) NEQ 0>
				<cfset ConfigComponentCategoryID = removeChars(Column, 1, 4)>
				<cfset ConfigComponentID = Arguments.strQuoteScreen3[Column]>
				<cfset IgnoreField = "IGNORE|" & ConfigComponentCategoryID>
				<cfif NOT structKeyExists(Arguments.strQuoteScreen3, IgnoreField)>
					<cfquery datasource="#This.DataSourceName#" name="qryConfigComponent">
					SELECT	ITEMNO
					FROM 	tblConfigComponents
					WHERE	ConfigComponentID = '#ConfigComponentID#'
					</cfquery>
					<cfif qryConfigComponent.RecordCount NEQ 0>					
						<cfquery datasource="#This.DataSourceName#" name="qryPriceListComponents">
						SELECT	tblPriceListComponents.SellPrice
						FROM 	tblPriceListComponents
								INNER JOIN tblPriceListCategories ON 
								tblPriceListComponents.PriceListCategoryID = tblPriceListCategories.PriceListCategoryID
						WHERE	tblPriceListCategories.PriceListID = '#PriceListID#' AND
								tblPriceListComponents.ITEMNO = '#trim(qryConfigComponent.ITEMNO)#' AND
								tblPriceListComponents.Active = 1
						</cfquery>
						<cfif qryPriceListComponents.RecordCount NEQ 0>	
							<cfset QuoteTotalPrice = QuoteTotalPrice + qryPriceListComponents.SellPrice>
						</cfif>				
					</cfif>
				</cfif>
			</cfif>
		</cfloop>
		
		<cfset lstScreen4 = structKeyList(Arguments.strQuoteScreen4)>
		<cfloop list="#lstScreen4#" index="Column">
			<cfif findNoCase('COST|', Column) NEQ 0>
				<cfif isNumeric(Arguments.strQuoteScreen4[Column])>
					<cfset QuoteTotalPrice = QuoteTotalPrice + Arguments.strQuoteScreen4[Column]>
				</cfif>
			</cfif>
		</cfloop>
        
        
		<cfreturn QuoteTotalPrice>
	</cffunction>
--->

	<!------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="getQuoteTotalCost" access="public" returntype="numeric" output="No">
	<cfargument name="strQuoteScreen3" type="struct" required="Yes">
	<cfargument name="strQuoteScreen4" type="struct" required="Yes">
		<cfset var QuoteTotalCost = 0>	
        <cfset var qryConfigSystem = queryNew("")>
        <cfset var lstScreen3 = "">
        <cfset var ConfigComponentCategoryID = "">
        <cfset var SelecBoxValue = "">
        <cfset var ConfigComponentID = "">
        <cfset var IgnoreField = "">
        <cfset var qryConfigComponent = queryNew("")>
        <cfset var qryMiscParts = queryNew("")>
		<cfset var QuantityKey = "">
        <cfset var ThisQuantity = 0>
		<cfset var qryPriceListComponents = queryNew("")>
                
		<cfquery datasource="#This.DataSourceName#" name="qryConfigSystem">
		SELECT	SystemBasePrice
		FROM 	tblConfigSystems
		WHERE	ConfigSystemID = '# Arguments.strQuoteScreen3.ConfigSystemID#'
		</cfquery>
		<cfif qryConfigSystem.RecordCount NEQ 0>
			<cfset QuoteTotalCost = QuoteTotalCost + qryConfigSystem.SystemBasePrice>
		</cfif>
		<cfset lstScreen3 = structKeyList(Arguments.strQuoteScreen3)>
		<cfloop list="#lstScreen3#" index="Column">
			<cfif findNoCase('CAT_', Column) NEQ 0>
				<cfset ConfigComponentCategoryID = removeChars(Column, 1, 4)>
				<cfset SelecBoxValue = Arguments.strQuoteScreen3[Column]>
                <cfset ConfigComponentID = left(SelecBoxValue, FindNoCase("|",SelecBoxValue)-1)>
				<cfset IgnoreField = "IGNORE|" & ConfigComponentCategoryID>
				<cfif NOT structKeyExists(Arguments.strQuoteScreen3, IgnoreField)>
					<cfquery datasource="#This.DataSourceName#" name="qryConfigComponent">
					SELECT	ITEMNO
					FROM 	tblConfigComponents
					WHERE	ConfigComponentID = '#ConfigComponentID#'
					</cfquery>
					<cfif qryConfigComponent.RecordCount NEQ 0>	
                    	<cfset QuantityField = "QTY|" & removeChars(Column, 1, 4)>
                    	<cfif structKeyExists(Arguments.strQuoteScreen3, QuantityField)>
                    		<cfset QuoteTotalCost = QuoteTotalCost + (getItemCost(qryConfigComponent.ITEMNO) * Arguments.strQuoteScreen3[QuantityField])>
                        <cfelse>
							<cfset QuoteTotalCost = QuoteTotalCost + getItemCost(qryConfigComponent.ITEMNO)>
						</cfif>
					</cfif>
				</cfif>
			</cfif>
		</cfloop>

        <cfloop query="Arguments.strQuoteScreen4.qrySelectedParts">
        	<cfif Arguments.strQuoteScreen4.qrySelectedParts.MiscPartID IS NOT "">
                <cfquery datasource="#This.DataSourceName#" name="qryMiscParts">
                SELECT	Cost,MiscPartID
                FROM 	tblMiscParts
                WHERE	MiscPartID = '#Arguments.strQuoteScreen4.qrySelectedParts.MiscPartID#'
                </cfquery>
				<cfif qryMiscParts.RecordCount NEQ 0>
                    <cfset QuantityKey = "QTY|" & qryMiscParts.MiscPartID>
                    <cfif structKeyExists(Arguments.strQuoteScreen4, QuantityKey) AND isNumeric(Arguments.strQuoteScreen4[QuantityKey])>
                        <cfset ThisQuantity = Arguments.strQuoteScreen4[QuantityKey]>
                    <cfelse>
                        <cfset ThisQuantity = 1>
                    </cfif>
                    <cfset QuoteTotalCost = QuoteTotalCost + (qryMiscParts.Cost * ThisQuantity)>
                </cfif>
                
			<cfelseif Arguments.strQuoteScreen4.qrySelectedParts.PriceListComponentID IS NOT "">
                <cfquery datasource="#This.DataSourceName#" name="qryPriceListComponents">
                SELECT	ITEMNO,PriceListComponentID
                FROM 	tblPriceListComponents
                WHERE	PriceListComponentID = '#Arguments.strQuoteScreen4.qrySelectedParts.PriceListComponentID#'
                </cfquery>
				<cfif qryPriceListComponents.RecordCount NEQ 0>
                    <cfset QuantityKey = "QTY|" & qryPriceListComponents.PriceListComponentID>
                    <cfif structKeyExists(Arguments.strQuoteScreen4, QuantityKey) AND isNumeric(Arguments.strQuoteScreen4[QuantityKey])>
                        <cfset ThisQuantity = Arguments.strQuoteScreen4[QuantityKey]>
                    <cfelse>
                        <cfset ThisQuantity = 1>
                    </cfif>
                    <cfset QuoteTotalCost = QuoteTotalCost + (getItemCost(qryPriceListComponents.ITEMNO) * ThisQuantity)>
                </cfif>

			<cfelse>
                    <cfset QuantityKey = "QTY|" & Arguments.strQuoteScreen4.qrySelectedParts.ACCPACPartID>
                    <cfif structKeyExists(Arguments.strQuoteScreen4, QuantityKey) AND isNumeric(Arguments.strQuoteScreen4[QuantityKey])>
                        <cfset ThisQuantity = Arguments.strQuoteScreen4[QuantityKey]>
                    <cfelse>
                        <cfset ThisQuantity = 1>
                    </cfif>
                    <cfset QuoteTotalCost = QuoteTotalCost + (getItemCost(Arguments.strQuoteScreen4.qrySelectedParts.ITEMNO) * ThisQuantity)>

			</cfif>

        </cfloop>
		
		<cfreturn QuoteTotalCost>
	</cffunction>

	<!------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="getQuoteTotalPrice" access="public" returntype="numeric" output="No">
	<cfargument name="qryConfigParts" type="query" required="Yes">
	<cfargument name="ConfigSystemID" type="string" required="Yes">
		<cfset var QuoteTotalPrice = 0>
        <cfset var qryConfigSystem = queryNew("")>
		<cfif Arguments.ConfigSystemID IS NOT "">
            <cfquery datasource="#This.DataSourceName#" name="qryConfigSystem">
            SELECT	SystemBasePrice
            FROM 	tblConfigSystems
            WHERE	ConfigSystemID = '# Arguments.ConfigSystemID#'
            </cfquery>
            <cfif qryConfigSystem.RecordCount NEQ 0>
                <cfset QuoteTotalPrice = QuoteTotalPrice + qryConfigSystem.SystemBasePrice>
            </cfif>
        </cfif>
		<cfloop query="Arguments.qryConfigParts">
        	<cfif isNumeric(Arguments.qryConfigParts.SellPrice)>
				<cfset QuoteTotalPrice = QuoteTotalPrice + Arguments.qryConfigParts.SellPrice>
			</cfif>
        </cfloop>
		<cfreturn QuoteTotalPrice>
	</cffunction>
    
	<!------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="saveSalesRepQuote" access="public" returntype="string" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var QuoteSystemID = "">
		<cfset var lstRecord = "">
		<cfset var Column = "">
		<cfset var MiscPartID = "">
		<cfset var strMiscPart = structNew()>
		<cfset var CURRENTSellingPrice = "">
        <cfset var SellingPriceKey = "">
        <cfset var QuantityKey = "">
        <cfset var CURRENTQuantity = "">
		<cfset var ThisPartDescription = "">
        <cfset var qryComponentCategory = queryNew("")>
        <cfset var CategoryName = "">
        <cfset var qryPriceListCategory = queryNew("")>
        <cfset var ThisItemNumber = "">
		<cfset objMiscParts = createObject("component", "admin.assets.cfcs.parts.MiscParts")>
		<cfset objPriceListComponents = createObject("component", "admin.assets.cfcs.prices.PriceListComponents")>

		<cfset QuoteSystemID = saveQuote(Arguments.Record)>
		
		<cfquery datasource="#This.DataSourceName#">
		UPDATE 	tblQuoteSystem
		SET		
<!---        
        		ResellerPrice = '#Arguments.Record.QuoteTotalPrice#',
				ResellerTotal = '#Arguments.Record.QuoteTotalPrice#',
--->
				SalesRepQuote = 1,
                QuoteSent = 0
		WHERE 	QuoteSystemID = '#QuoteSystemID#'
		</cfquery>		
		
		<cfset lstRecord = structKeyList(Arguments.Record)>
		<cfloop list="#lstRecord#" index="Column">
			<!--- MISC PART --->
			<cfif findNoCase('MISCPART|', Column)>
				<cfset MiscPartID = removeChars(Column, 1, 9)>
				<cfset strMiscPart = objMiscParts.getRecord(MiscPartID)>
                <cfquery datasource="#This.DataSourceName#" name="qryComponentCategory">
                SELECT	Name
                FROM	tblComponentCategories
                WHERE 	ComponentCategoryID = '#strMiscPart.ComponentCategoryID#'
                </cfquery>	
				<cfif qryComponentCategory.RecordCount NEQ 0>
					<cfset CategoryName = qryComponentCategory.Name>
                <cfelse>
                	<cfset CategoryName = "">					
				</cfif>
				<cfset SellingPriceKey = "SELLPRICE|" & MiscPartID>
                <cfset CURRENTSellingPrice = Arguments.Record[SellingPriceKey]>
				<cfset QuantityKey = "QUANTITY|" & MiscPartID>
                <cfset CURRENTQuantity = Arguments.Record[QuantityKey]>
				<cfquery datasource="#This.DataSourceName#">
				INSERT INTO tblQuoteComponents (
					QuoteComponentID, 
					QuoteSystemID,
					ITEMNO,
					ITEMDESC,
                    TypeName,
					MiscPart,
					MiscPartID,
                    PriceListComponentID,
                    SellingPrice,
                    Quantity)
				VALUES (
					'#createUUID()#', 
					'#QuoteSystemID#',
					'#strMiscPart.MfgrPartNumber#',
					'#strMiscPart.Description#',
                    '#CategoryName#',
					1,
					'#MiscPartID#',
                    '',
                    '#CURRENTSellingPrice#',
                    '#CURRENTQuantity#')
				</cfquery>		
			<!--- PRICE LIST COMPONENT --->
			<cfelseif findNoCase('PRICELISTPART|', Column)>
				<cfset PriceListComponentID = removeChars(Column, 1, 14)>
				<cfset strPriceListComponent = objPriceListComponents.getRecord(PriceListComponentID)>     
                <cfquery datasource="#This.DataSourceName#" name="qryPriceListCategory">
                SELECT	CategoryDescription
                FROM	tblPriceListCategories
                WHERE 	PriceListCategoryID = '#strPriceListComponent.PriceListCategoryID#'
                </cfquery>	
				<cfif qryPriceListCategory.RecordCount NEQ 0>
					<cfset CategoryName = qryPriceListCategory.CategoryDescription>
                <cfelse>
                	<cfset CategoryName = "">					
				</cfif>
                           
				<cfset SellingPriceKey = "SELLPRICE|" & PriceListComponentID>
                <cfset CURRENTSellingPrice = Arguments.Record[SellingPriceKey]>
				<cfset QuantityKey = "QUANTITY|" & PriceListComponentID>
                <cfset CURRENTQuantity = Arguments.Record[QuantityKey]>

                <cfset ThisPartDescription = getItemDescription(strPriceListComponent.ITEMNO)>
				<cfquery datasource="#This.DataSourceName#">
				INSERT INTO tblQuoteComponents (
					QuoteComponentID, 
					QuoteSystemID,
					ITEMNO,
					ITEMDESC,
                    TypeName,
				 	MiscPart,
					MiscPartID,				
	                PriceListComponentID,	
	                SellingPrice,			
                    Quantity)
				VALUES (
					'#createUUID()#', 
					'#QuoteSystemID#',
					'#strPriceListComponent.ITEMNO#',
					'#ThisPartDescription#',
                    '#CategoryName#',
					1,
					'',
	                '#PriceListComponentID#',	
                    '#CURRENTSellingPrice#',	
                    '#CURRENTQuantity#')
				</cfquery>		

			<!--- ACCPAC MISC PART --->
			<cfelseif findNoCase('ACCPACPART|', Column)>
				<cfset ACCPACPartID = removeChars(Column, 1, 11)>
                
                <cfset ThisItemNumber = Arguments.Record[Column]>
                <cfset CategoryName = getCategoryDescription(ThisItemNumber)>					

				<cfset SellingPriceKey = "SELLPRICE|" & ACCPACPartID>
                <cfset CURRENTSellingPrice = Arguments.Record[SellingPriceKey]>
				<cfset QuantityKey = "QUANTITY|" & ACCPACPartID>
                <cfset CURRENTQuantity = Arguments.Record[QuantityKey]>

                <cfset ThisPartDescription = getItemDescription(ThisItemNumber)>
				<cfquery datasource="#This.DataSourceName#">
				INSERT INTO tblQuoteComponents (
					QuoteComponentID, 
					QuoteSystemID,
					ITEMNO,
					ITEMDESC,
                    TypeName,
				 	MiscPart,
					MiscPartID,				
	                PriceListComponentID,	
	                SellingPrice,			
                    Quantity)
				VALUES (
					'#createUUID()#', 
					'#QuoteSystemID#',
					'#ThisItemNumber#',
					'#ThisPartDescription#',
                    '#CategoryName#',
					1,
					'',
	                '',	
                    '#CURRENTSellingPrice#',	
                    '#CURRENTQuantity#')
				</cfquery>		

			</cfif>
		</cfloop>
		<cfreturn QuoteSystemID>
	</cffunction>		


	<cffunction name="findSalesRepQuotes" access="public" returntype="query" output="No">
	<cfargument name="SearchRecord" type="struct" required="Yes">
	<cfargument name="OrderByList" type="string" required="Yes">
		<cfset var qryQuotes = queryNew("")>
        <cfset var SalesRepID = "">
        <cfset var BeginDate = "">
		<cfset var EndDate = "">
       	<cfif structKeyExists(Arguments.SearchRecord, "QuoteDate") AND isDate(Arguments.SearchRecord.QuoteDate)>
        	<cfset BeginDate = dateFormat(Arguments.SearchRecord.QuoteDate, 'm/d/yyyy')>
        	<cfset EndDate = dateFormat(dateAdd('d', 1, Arguments.SearchRecord.QuoteDate), 'm/d/yyyy')>
        </cfif>
		<cfset SalesRepID = getSessionValue("salesrepid")>
		<cfif  SalesRepID IS NOT "">
            <cfquery datasource="#This.DataSourceName#" name="qryQuotes">
            SELECT	tblQuoteSystem.QuoteSystemID, tblQuoteSystem.QuoteNumber, tblQuoteSystem.QuoteDate, tblQuoteSystem.SystemName, 
            		tblQuoteSystem.ResellerTotal, tblQuoteSystem.QuoteSent, tblQuoteSystem.Quantity, tblQuoteSystem.SalesRepQuote, tblQuoteSystem.TurnOffPricing,
            		tblQuoteSystem.ResellerPONumber, login.acctno AS CustomerNumber, login.company AS CustomerName
            FROM	tblQuoteSystem
            		LEFT OUTER JOIN login ON login.CustomerID = tblQuoteSystem.CustomerID
            WHERE 	<!---	tblQuoteSystem.SalesRepQuote = 1 AND	--->
                    tblQuoteSystem.SalesRepID = '#SalesRepID#'
                    <cfif structKeyExists(Arguments.SearchRecord, "QuoteNumber") AND trim(Arguments.SearchRecord.QuoteNumber) IS NOT "">
                    	AND tblQuoteSystem.QuoteNumber = '#trim(Arguments.SearchRecord.QuoteNumber)#'
                    </cfif>
					<cfif BeginDate IS NOT "" AND EndDate IS NOT "">
                        AND tblQuoteSystem.QuoteDate >= '#BeginDate#'
                        AND tblQuoteSystem.QuoteDate < '#EndDate#'
                    </cfif>
					<cfif structKeyExists(Arguments.SearchRecord, "ResellerPONumber") AND trim(Arguments.SearchRecord.ResellerPONumber) IS NOT "">
						AND tblQuoteSystem.ResellerPONumber LIKE '%#trim(Arguments.SearchRecord.ResellerPONumber)#%'
					</cfif>
                    <cfif structKeyExists(Arguments.SearchRecord, "CustomerNumber") AND trim(Arguments.SearchRecord.CustomerNumber) IS NOT "">
                    	AND login.acctno LIKE '%#trim(Arguments.SearchRecord.CustomerNumber)#%'
                    </cfif>
                    <cfif structKeyExists(Arguments.SearchRecord, "CustomerName") AND trim(Arguments.SearchRecord.CustomerName) IS NOT "">
                    	AND login.company LIKE '%#trim(Arguments.SearchRecord.CustomerName)#%'
                    </cfif>
            ORDER BY #Arguments.OrderByList#                 
            </cfquery>	
		</cfif>
        <cfreturn qryQuotes>
    </cffunction>

	<!------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="copyComponents" access="public" returntype="query" output="No">
	<cfargument name="QuoteSystemID" type="string" required="Yes">
		<cfset var qrySelectedParts = queryNew("MiscPartID,PriceListComponentID,SellingPrice,Quantity,ITEMNO,ACCPACPartID")>
		<cfset var ACCPACArray = ArrayNew(1)>
        <cfquery datasource="#This.DataSourceName#" name="qrySelectedParts">
        SELECT	MiscPartID,PriceListComponentID,SellingPrice,Quantity,ITEMNO
        FROM	tblQuoteComponents
        WHERE 	QuoteSystemID = '#Arguments.QuoteSystemID#' 
		AND		MiscPart = '1'
        </cfquery>	
        <cfset queryAddColumn(qrySelectedParts, "ACCPACPartID", ACCPACArray)>
        <cfloop query="qrySelectedParts">
        	<cfif qrySelectedParts.MiscPartID IS "" AND qrySelectedParts.PriceListComponentID IS "">
	    	    <cfset querySetCell(qrySelectedParts, "ACCPACPartID", createUUID(), CurrentRow)>
			</cfif>               
    	</cfloop>
        <cfreturn qrySelectedParts>
    </cffunction>

	<!------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="createQuoteFromACCPAC" access="public" returntype="struct" output="No">
	<cfargument name="INVUNIQ" type="string" required="Yes">
	<cfargument name="PriceListID" type="string" required="Yes">
		<cfset var strQuoteScreen4 = structNew()>
        <cfset var qrySelectedParts = queryNew("MiscPartID,PriceListComponentID,Quantity,SellingPrice,ACCPACPartID,ITEMNO")>
        <cfset var qryOEINVD = queryNew("")>
		<cfset var qryPriceListComponents = queryNew("")>
		<cfset var CURRENTQuantity = "">
		<cfset objOEINVD = createObject("component", "admin.assets.cfcs.OEINVD")>
		<cfset qryOEINVD = objOEINVD.listRecordsForParent("INVUNIQ", Arguments.INVUNIQ)>

        <cfloop query="qryOEINVD">
        	<cfif isNumeric(qryOEINVD.QTYSHIPPED)>
				<cfset CURRENTQuantity = int(qryOEINVD.QTYORDERED)>
			<cfelse>
				<cfset CURRENTQuantity = qryOEINVD.QTYORDERED>            
			</cfif>
        	<cfif trim(qryOEINVD.ITEM) IS NOT "">
                <cfquery datasource="#This.DataSourceName#" name="qryPriceListComponents">
                SELECT	PriceListComponentID
                FROM	vPriceListComponents
                WHERE 	(PriceListID = '#Arguments.PriceListID#') AND 
                        (ITEMNO = '#trim(qryOEINVD.ITEM)#') AND 
                        (Active = 1)
                </cfquery>	
                <!--- If this component is found on this customer's price list --->
                <cfif qryPriceListComponents.RecordCount NEQ 0>
                    <cfset queryAddRow(qrySelectedParts)>
                    <cfset querySetCell(qrySelectedParts, "MiscPartID", "")>
                    <cfset querySetCell(qrySelectedParts, "PriceListComponentID", qryPriceListComponents.PriceListComponentID)>
                    <cfset querySetCell(qrySelectedParts, "Quantity", CURRENTQuantity)>
                    <cfset querySetCell(qrySelectedParts, "SellingPrice", "")>
                <!--- If not, see if the part is already listed as a misc part, and add it if need be --->
                <cfelse>
                    <cfset queryAddRow(qrySelectedParts)>
                    <cfset querySetCell(qrySelectedParts, "MiscPartID", "")>
                    <cfset querySetCell(qrySelectedParts, "PriceListComponentID", "")>
                    <cfset querySetCell(qrySelectedParts, "Quantity", CURRENTQuantity)>
                    <cfset querySetCell(qrySelectedParts, "SellingPrice", "")>
                    
    		        <cfset querySetCell(qrySelectedParts, "ACCPACPartID", createUUID())>
    		        <cfset querySetCell(qrySelectedParts, "ITEMNO", trim(qryOEINVD.ITEM))>
				</cfif>
			</cfif>
        </cfloop>
		<cfif qrySelectedParts.RecordCount NEQ 0>
			<cfset structInsert(strQuoteScreen4, "qrySelectedParts", qrySelectedParts, True)>
		</cfif>
        <cfreturn strQuoteScreen4>
    </cffunction>

	<!------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="copyQuoteNewCustomer" access="public" returntype="struct" output="No">
	<cfargument name="QuoteSystemID" type="string" required="Yes">
	<cfargument name="PriceListID" type="string" required="Yes">
		<cfset var strQuoteScreen4 = structNew()>
        <cfset var qrySelectedParts = queryNew("MiscPartID,PriceListComponentID,Quantity,SellingPrice,ACCPACPartID,ITEMNO")>
        <cfset var qryQuoteComponents = queryNew("")>
		<cfset var qryPriceListComponents = queryNew("")>
		<cfset var CURRENTQuantity = "">
		<cfset var qryPartFound = queryNew("")>
		<cfset var SavedITEMNO = "">
        <cfset var SameItem = 0>
		<cfset objQuoteComponents = createObject("component", "admin.assets.cfcs.config.QuoteComponents")>

		<cfset qryQuoteComponents = objQuoteComponents.listRecordsForParent("QuoteSystemID", Arguments.QuoteSystemID, "ITEMNO")>
        
        <cfloop query="qryQuoteComponents">
        
        	<cfif trim(qryQuoteComponents.ITEMNO) IS NOT "[NONE]">
				<cfif trim(qryQuoteComponents.ITEMNO) IS NOT SavedITEMNO>
					<cfset SavedITEMNO = trim(qryQuoteComponents.ITEMNO)>
                	<cfset SameItem = 0>
                <cfelse>
                	<cfset SameItem = 1>
				</cfif>
        		<cfif isNumeric(qryQuoteComponents.Quantity)>
                    <cfset CURRENTQuantity = int(qryQuoteComponents.Quantity)>
                <cfelse>
                    <cfset CURRENTQuantity = qryQuoteComponents.Quantity>            
                </cfif>
                <cfif trim(qryQuoteComponents.ITEMNO) IS NOT "">
                    <cfquery datasource="#This.DataSourceName#" name="qryPriceListComponents">
                    SELECT	PriceListComponentID
                    FROM	vPriceListComponents
                    WHERE 	(PriceListID = '#Arguments.PriceListID#') AND 
                            (ITEMNO = '#trim(qryQuoteComponents.ITEMNO)#') AND 
                            (Active = 1)
                    </cfquery>	
                    <!--- If this component is found on this customer's price list --->
                    <cfif qryPriceListComponents.RecordCount NEQ 0>
                    	<cfif SameItem>
                            <cfquery dbtype="query" name="qryPartFound">
                            SELECT	*
                            FROM	qrySelectedParts
                            WHERE 	PriceListComponentID = '#qryPriceListComponents.PriceListComponentID#'
                            </cfquery>	
                            <cfset CURRENTQuantity = CURRENTQuantity + qryPartFound.Quantity>
                            <cfset querySetCell(qrySelectedParts, "Quantity", CURRENTQuantity, qrySelectedParts.RecordCount)>
						<cfelse>
							<cfset queryAddRow(qrySelectedParts)>
                            <cfset querySetCell(qrySelectedParts, "MiscPartID", "")>
                            <cfset querySetCell(qrySelectedParts, "PriceListComponentID", qryPriceListComponents.PriceListComponentID)>
                            <cfset querySetCell(qrySelectedParts, "Quantity", CURRENTQuantity)>
                            <cfset querySetCell(qrySelectedParts, "SellingPrice", "")>
						</cfif>
    
                    <!--- If this is a Misc Part --->
                    <cfelseif qryQuoteComponents.MiscPart AND qryQuoteComponents.MiscPartID IS NOT "">
                        <cfset queryAddRow(qrySelectedParts)>
                        <cfset querySetCell(qrySelectedParts, "MiscPartID", qryQuoteComponents.MiscPartID)>
                        <cfset querySetCell(qrySelectedParts, "PriceListComponentID", "")>
                        <cfset querySetCell(qrySelectedParts, "Quantity", CURRENTQuantity)>
                        <cfset querySetCell(qrySelectedParts, "SellingPrice", "")>
    
                    <!--- If not, add it as an ACCPAC part --->
                    <cfelse>
                        <cfset queryAddRow(qrySelectedParts)>
                        <cfset querySetCell(qrySelectedParts, "MiscPartID", "")>
                        <cfset querySetCell(qrySelectedParts, "PriceListComponentID", "")>
                        <cfset querySetCell(qrySelectedParts, "Quantity", CURRENTQuantity)>
                        <cfset querySetCell(qrySelectedParts, "SellingPrice", "")>
                        <cfset querySetCell(qrySelectedParts, "ACCPACPartID", createUUID())>
                        <cfset querySetCell(qrySelectedParts, "ITEMNO", trim(qryQuoteComponents.ITEMNO))>
                    </cfif>
                </cfif>
            </cfif>
        </cfloop>
        
		<cfif qrySelectedParts.RecordCount NEQ 0>
			<cfset structInsert(strQuoteScreen4, "qrySelectedParts", qrySelectedParts, True)>
		</cfif>
        <cfreturn strQuoteScreen4>
    </cffunction>
        
	<!------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="getAcctno" access="public" returntype="string" output="No">
	<cfargument name="QuoteSystemID" type="string" required="Yes">
		<cfset var acctno = "">
        <cfset var qryLogin = queryNew("")>
        <cfquery datasource="#This.DataSourceName#" name="qryLogin">
        SELECT	acctno
        FROM	login
        		INNER JOIN tblQuoteSystem ON tblQuoteSystem.CustomerID = login.CustomerID
        WHERE 	tblQuoteSystem.QuoteSystemID = '#Arguments.QuoteSystemID#'
        </cfquery>	
        <cfif qryLogin.RecordCount NEQ 0>
			<cfset acctno = qryLogin.acctno>
		</cfif>
        <cfreturn acctno>
    </cffunction>

	<!------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="getCompany" access="public" returntype="string" output="No">
	<cfargument name="QuoteSystemID" type="string" required="Yes">
		<cfset var company = "">
        <cfset var qryLogin = queryNew("")>
        <cfquery datasource="#This.DataSourceName#" name="qryLogin">
        SELECT	company
        FROM	login
        		INNER JOIN tblQuoteSystem ON tblQuoteSystem.CustomerID = login.CustomerID
        WHERE 	tblQuoteSystem.QuoteSystemID = '#Arguments.QuoteSystemID#'
        </cfquery>	
        <cfif qryLogin.RecordCount NEQ 0>
			<cfset company = qryLogin.company>
		</cfif>
        <cfreturn company>
    </cffunction>

	<!------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="validateShipping" access="public" returntype="struct" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
		<cfif validateRequired(Arguments.Record.ZipCode) EQ 0>
			<cfset stErrors.ZipCode = "Please enter the Ship-to Zip Code">
		</cfif>
		<cfif validateRequired(Arguments.Record.State) EQ 0 OR len(Arguments.Record.State) GT 2>
			<cfset stErrors.State = "Please enter the Ship-to State (2-letter abbreviation)">
		</cfif>
		<cfif validateRequired(Arguments.Record.ShippingMethod) EQ 0>
			<cfset stErrors.ShippingMethod = "Please select a Shipping Method">
		</cfif>
		<cfreturn stErrors>
	</cffunction>

	<!------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="getEstimatedFreight" access="public" returntype="struct" output="yes">
	<cfargument name="Record" type="struct" required="Yes">
    <cfargument name="ExportableConfigurator" type="boolean" default="0" required="no">
		<cfreturn createObject("component", "FreightEstimator").getEstimatedFreight(arguments.Record, arguments.ExportableConfigurator)>
	</cffunction>
	
	<cffunction name="getEstimatedFreightOLD" access="public" returntype="struct" output="yes">
	<cfargument name="Record" type="struct" required="Yes">
    <cfargument name="ExportableConfigurator" type="boolean" default="0" required="no">
    	<cfset var strResult = structNew()>
		<cfset var EstimatedFreight = "">
        <cfset var UPSShippingMethod = "">
        <cfset var qryConfigSystem = queryNew("")>
        <cfset var Weight = 0>
		<cfset var lstRecord = "">
        <cfset var Column = "">
        <cfset var ConfigComponentCategoryID = "">
        <cfset var qryConfigComponentCategories = queryNew("")>
        <cfset var ConfigComponentID = "">
        <cfset var LocationOfUnderscore = "">
        <cfset var qryConfigComponents = queryNew("")>
        <cfset var MonitorWeight = 0>
        <cfset var QuantityField = "">
        <cfset var MonitorQuantity = 0>
        <cfset var PriceListComponentID = "">
        <cfset var qryPriceListComponents = queryNew("")>
        <cfset var PartDescription = ""> 
        <cfset var qrylogin = queryNew("")>
		<cfset objCust = createObject("component", "admin.assets.cfcs.Cust")>

        <cfset structInsert(strResult, "Success", 1, True)>
        <cfset structInsert(strResult, "EstimatedFreight", "", True)>
        <cfset structInsert(strResult, "ErrorMessage", "", True)>
<!---
<cfdump var="#Arguments.Record#">
--->
		<cfif Arguments.Record.ShippingMethod IS "Ground">
        	<cfset UPSShippingMethod = "03">
        <cfelseif Arguments.Record.ShippingMethod IS "2nd Day Air">
        	<cfset UPSShippingMethod = "02">
        <cfelseif Arguments.Record.ShippingMethod IS "Next Day Air">
        	<cfset UPSShippingMethod = "01">
       	</cfif>
        
        <cfset Arguments.Record.State = uCase(Arguments.Record.State)>

        <!--- Weight: Calculate the weight of the package as the sum of the base weight plus the weight of the monitor(s) --->
        <cfquery datasource="#This.DataSourceName#" name="qryConfigSystem">
        SELECT	Type
        FROM	tblConfigSystems
        WHERE 	ConfigSystemID = '#Arguments.Record.ConfigSystemID#'
        </cfquery>	
        <cfif qryConfigSystem.RecordCount EQ 0>
			<cfset structInsert(strResult, "Success", 0, True)>
        	<cfset structInsert(strResult, "ErrorMessage", "A shipping charge could not be determined.", True)>
        <cfelse>
        
			<!--- Base Weight (weight of the computer) --->
            <cfif qryConfigSystem.Type IS "Workstation">
                <cfset Weight = Weight + 42>
            <cfelseif qryConfigSystem.Type IS "Server">
                <cfset Weight = Weight + 70>
            <cfelseif qryConfigSystem.Type IS "Notebook">
                <cfset Weight = Weight + 12>
            <cfelseif qryConfigSystem.Type IS "MiniMountablePC">
                <cfset Weight = Weight + 10>
            <cfelse>
				<cfset structInsert(strResult, "Success", 0, True)>
                <cfset structInsert(strResult, "ErrorMessage", "A shipping charge could not be determined because the system type is unknown.", True)>
            </cfif>

            <cfif strResult.Success>
				<!--- Monitor Weight --->
                <cfset lstRecord = structKeyList(Arguments.Record)>
                <cfloop list="#lstRecord#" index="Column">
                    <cfset MonitorWeight = 0>
                    <cfif findNoCase('CAT_',Column) NEQ 0>
                        <cfset ConfigComponentCategoryID = removeChars(Column, 1, 4)>
                        <cfquery datasource="#This.DataSourceName#" name="qryConfigComponentCategories">
                        SELECT	CATEGORY
                        FROM	vConfigComponentCategories
                        WHERE 	ConfigComponentCategoryID = '#ConfigComponentCategoryID#'
                        </cfquery>	
                        <cfif qryConfigComponentCategories.RecordCount NEQ 0 AND trim(qryConfigComponentCategories.CATEGORY) IS "MN">
                            <cfset ConfigComponentID = Arguments.Record[Column]>
                          
                            <cfif findNoCase('|', ConfigComponentID) NEQ 0>
                                <cfset LocationOfUnderscore = findNoCase('|', ConfigComponentID)>
                                <cfset ConfigComponentID = removeChars(ConfigComponentID, LocationOfUnderscore, len(ConfigComponentID)-LocationOfUnderscore+1)>
                            </cfif>
                            <cfquery datasource="#This.DataSourceName#" name="qryConfigComponents">
                            SELECT	DESCRIPTION
                            FROM	vConfigComponents
                            WHERE 	ConfigComponentID = '#ConfigComponentID#'
                            </cfquery>	
                            <cfif qryConfigComponents.RecordCount EQ 0>
								<cfset structInsert(strResult, "Success", 0, True)>
                                <cfset structInsert(strResult, "ErrorMessage", "A shipping charge could not be determined.  A monitor is included in this system, but the monitor size cannot be determined.", True)>
                            <cfelse>
                            	<!--- 17 INCH MONITOR --->
                                <cfif findNoCase('17IN', qryConfigComponents.DESCRIPTION) NEQ 0 OR findNoCase('17"', qryConfigComponents.DESCRIPTION) NEQ 0>
                                    <cfset MonitorWeight = 14>
                            	<!--- 19 INCH MONITOR --->
                                <cfelseif findNoCase('19IN', qryConfigComponents.DESCRIPTION) NEQ 0 OR findNoCase('19"', qryConfigComponents.DESCRIPTION) NEQ 0>
                                    <cfset MonitorWeight = 16>
                            	<!--- 22 INCH MONITOR --->
                                <cfelseif findNoCase('22IN', qryConfigComponents.DESCRIPTION) NEQ 0 OR findNoCase('22"', qryConfigComponents.DESCRIPTION) NEQ 0>
                                    <cfset MonitorWeight = 22>
                            	<!--- 24 INCH MONITOR --->
                                <cfelseif findNoCase('24IN', qryConfigComponents.DESCRIPTION) NEQ 0 OR findNoCase('24"', qryConfigComponents.DESCRIPTION) NEQ 0>
                                    <cfset MonitorWeight = 25>
                            	<!--- 32 INCH MONITOR --->
                                <cfelseif findNoCase('32IN', qryConfigComponents.DESCRIPTION) NEQ 0 OR findNoCase('32"', qryConfigComponents.DESCRIPTION) NEQ 0>
                                    <cfset MonitorWeight = 52>
                                <cfelseif trim(qryConfigComponents.DESCRIPTION) IS "None">
                                    <cfset MonitorWeight = 0>
                                <cfelse>
									<cfset structInsert(strResult, "Success", 0, True)>
                                    <cfset structInsert(strResult, "ErrorMessage", "A shipping charge could not be determined.  A monitor is included in this system, but the monitor size cannot be determined.", True)>
                                </cfif>
                            </cfif>
                          	<cfif strResult.Success>
								<cfset QuantityField = "QTY|" & ConfigComponentCategoryID>
                                <cfif structKeyExists(Arguments.Record, QuantityField)>
                                    <cfset MonitorQuantity = Arguments.Record[QuantityField]>
                                    <cfif isNumeric(MonitorQuantity)>
                                        <cfset MonitorWeight = MonitorWeight * MonitorQuantity>
                                    </cfif>
                                </cfif>
                                <cfset Weight = Weight + MonitorWeight>
                          	</cfif>
                        </cfif>
        
                    <cfelseif findNoCase('PRICELISTPART|',Column) NEQ 0>
                        <cfset PriceListComponentID = removeChars(Column, 1, 14)>
                        <cfquery datasource="#This.DataSourceName#" name="qryPriceListComponents">
                        SELECT	CATEGORY, ITEMNO
                        FROM	vPriceListComponents
                        WHERE 	PriceListComponentID = '#PriceListComponentID#'
                        </cfquery>	
                        <cfif qryPriceListComponents.RecordCount NEQ 0 AND trim(qryPriceListComponents.CATEGORY) IS "MN">
                            <cfset PartDescription = getItemDescription(qryPriceListComponents.ITEMNO)>
                           	<!--- 17 INCH MONITOR --->
                            <cfif findNoCase('17IN', PartDescription) NEQ 0 OR findNoCase('17"', PartDescription) NEQ 0>
                                <cfset MonitorWeight = 14>
                           	<!--- 19 INCH MONITOR --->
                            <cfelseif findNoCase('19IN', PartDescription) NEQ 0 OR findNoCase('19"', PartDescription) NEQ 0>
                                <cfset MonitorWeight = 16>
                           	<!--- 22 INCH MONITOR --->
                            <cfelseif findNoCase('22IN', PartDescription) NEQ 0 OR findNoCase('22"', PartDescription) NEQ 0>
                                <cfset MonitorWeight = 22>
							<!--- 24 INCH MONITOR --->
                            <cfelseif findNoCase('24IN', PartDescription) NEQ 0 OR findNoCase('24"', PartDescription) NEQ 0>
                                <cfset MonitorWeight = 25>
                            <!--- 32 INCH MONITOR --->
                            <cfelseif findNoCase('32IN', PartDescription) NEQ 0 OR findNoCase('32"', PartDescription) NEQ 0>
                                <cfset MonitorWeight = 52>
							<cfelseif trim(PartDescription) IS "None">
                                <cfset MonitorWeight = 0>
                            <cfelse>
								<cfset structInsert(strResult, "Success", 0, True)>
                                <cfset structInsert(strResult, "ErrorMessage", "A shipping charge could not be determined.  A monitor is included in this system, but the monitor size cannot be determined.", True)>
                            </cfif>
                           	<cfif strResult.Success>
								<cfset QuantityField = "QUANTITY|" & PriceListComponentID>
                                <cfif structKeyExists(Arguments.Record, QuantityField)>
                                    <cfset MonitorQuantity = Arguments.Record[QuantityField]>
                                    <cfif isNumeric(MonitorQuantity)>
                                        <cfset MonitorWeight = MonitorWeight * MonitorQuantity>
                                    </cfif>
                                </cfif>
                                <cfset Weight = Weight + MonitorWeight>
                         	</cfif>
                        </cfif>
                    </cfif>
                </cfloop>

				<cfif strResult.Success>                
					<!--- Set up the UPS Access Request XML File --->
                    <cfxml variable="UPSAccessRequest">
                        <AccessRequest xml:lang="en-US">
                            <AccessLicenseNumber>4C3B00A21EA24410</AccessLicenseNumber>
                            <UserId>nortechrb</UserId>
                            <Password>tlldob1!</Password>
                        </AccessRequest>
                    </cfxml>
                    
                    <!--- Set up the UPS Track Request XML File --->
                    <cfxml variable="UPSRateRequest">
                        <RatingServiceSelectionRequest>
                            <Request>
                                <RequestAction>Rate</RequestAction>
                                <RequestOption>Rate</RequestOption>
                            </Request>
                    
                            <Shipment>
                                <Shipper>
                                    <ShipperNumber>1204W0</ShipperNumber>
                                    <Address>
                                        <AddressLine1>901 East Cliff Road </AddressLine1>
                                        <City>Burnsville</City>
                                        <StateProvinceCode>MN</StateProvinceCode>
                                        <PostalCode>55337</PostalCode>
                                        <CountryCode>US</CountryCode>
                                    </Address>
                                </Shipper>
                                <ShipTo>
                                    <Address>
                                        <StateProvinceCode>#Arguments.Record.State#</StateProvinceCode>				<!--- State --->
                                        <PostalCode>#Arguments.Record.ZipCode#</PostalCode>							<!--- Zip Code --->
                                        <cfif structKeyExists(Arguments.Record, "ResidentialDelivery")>
                                            <ResidentialAddressIndicator></ResidentialAddressIndicator>				<!--- Residential Delivery --->	
                                        </cfif>
                                    </Address>
                                </ShipTo>
                                <Service>
                                    <Code>#UPSShippingMethod#</Code>						<!--- Shipping Method: 03 = Ground, 02 = 2nd Day Air, 01 = Next Day Air --->
                                </Service>
                                <Package>
                                    <PackagingType>
                                        <Code>02</Code>
                                    </PackagingType>
                                    <PackageWeight>
                                        <UnitOfMeasurement>
                                            <Code>LBS</Code>
                                        </UnitOfMeasurement>
                                        <Weight>#Weight#</Weight>											<!--- Weight --->
                                    </PackageWeight>
                                    <cfif structKeyExists(Arguments.Record, "SignatureRequired")>
                                        <PackageServiceOptions>
                                            <DeliveryConfirmation>											<!--- Signature Required; 2 = "Delivery Confirmation Signature Required" --->
                                                <DCISType>2</DCISType>
                                            </DeliveryConfirmation>
                                        </PackageServiceOptions>
                                    </cfif>
                                </Package>
                                <RateInformation>
                                    <NegotiatedRatesIndicator></NegotiatedRatesIndicator>
                                </RateInformation>
                            </Shipment>
                        </RatingServiceSelectionRequest>
                    </cfxml>
                    
                    <!--- Combine the two of them --->
                    <cfset UPS_XMLFile = toString(UPSAccessRequest) & toString(UPSRateRequest)>
                    
                    <!--- Send the XML File to UPS; result is returned in variable "CFHTTP" --->
<!---               <cfhttp method="post" url="https://wwwcie.ups.com/ups.app/xml/Rate">	--->
                    <cfhttp method="post" url="https://www.ups.com/ups.app/xml/Rate">
                        <cfhttpparam type="XML" value="#UPS_XMLFile#">
                    </cfhttp>
                    
                    <cfset ParsedContent = xmlParse(CFHTTP.FileContent)>
                    <cfset xnTrackResponse = ParsedContent.XmlRoot>
                    
                    <!--- Check for an Error --->
                    <cfif xnTrackResponse.Response.ResponseStatusCode.XmlText IS "0">
						<cfset structInsert(strResult, "Success", 0, True)>
                        <cfset structInsert(strResult, "ErrorMessage", xnTrackResponse.Response.Error.ErrorDescription.XmlText, True)>
                    <cfelse>
                        <cfif isDefined("xnTrackResponse.RatedShipment.NegotiatedRates.NetSummaryCharges.GrandTotal.MonetaryValue.XmlText")>
                            <cfset EstimatedFreight = xnTrackResponse.RatedShipment.NegotiatedRates.NetSummaryCharges.GrandTotal.MonetaryValue.XmlText>
                        <cfelse>
                            <cfset EstimatedFreight = xnTrackResponse.RatedShipment.TotalCharges.MonetaryValue.XmlText>
                        </cfif>
                        <!--- "We add $4 to every order for insurance but the customers don’t need to see this" - Sean Quinlan --->
                        <cfif isNumeric(EstimatedFreight)>
                            <cfset EstimatedFreight = EstimatedFreight + 4>
                        </cfif>

                        <!--- Exportable Configurator; mark up the shipping cost --->
                        <cfif Arguments.ExportableConfigurator>
                            <cfquery datasource="#This.DataSourceName#" name="qrylogin">
                            SELECT	ShippingChargeType, MarkupShippingCharges, MarkupType, PercentWorkstations, PercentNotebooks, PercentServers, PercentMiniMountablePCs
                            FROM	login
                            WHERE 	CustomerID = '#Arguments.Record.CustomerID#'
                            </cfquery>	
							<cfif qrylogin.ShippingChargeType IS "Freight Estimator" AND qrylogin.MarkupShippingCharges EQ 1>
								<!--- MARGIN PERCENT --->
								<cfif qryLogin.MarkupType IS "Margin">
                                    <cfif qryConfigSystem.Type IS "Workstation" AND isNumeric(qryLogin.PercentWorkstations)>
                                        <cfset EstimatedFreight = EstimatedFreight / (1 - qryLogin.PercentWorkstations)>
                                    <cfelseif qryConfigSystem.Type IS "Notebook" AND isNumeric(qryLogin.PercentNotebooks)>
                                        <cfset EstimatedFreight = EstimatedFreight / (1 - qryLogin.PercentNotebooks)>
                                    <cfelseif qryConfigSystem.Type IS "Server" AND isNumeric(qryLogin.PercentServers)>
                                        <cfset EstimatedFreight = EstimatedFreight / (1 - qryLogin.PercentServers)>
                                    <cfelseif qryConfigSystem.Type IS "MiniMountablePC" AND isNumeric(qryLogin.PercentMiniMountablePCs)>
                                        <cfset EstimatedFreight = EstimatedFreight / (1 - qryLogin.PercentMiniMountablePCs)>
                                    </cfif>
                                
                                <!--- MARKUP PERCENTAGES --->
                                <cfelse>
                                    <cfif qryConfigSystem.Type IS "Workstation" AND isNumeric(qryLogin.PercentWorkstations)>
                                        <cfset EstimatedFreight = EstimatedFreight + EstimatedFreight * qryLogin.PercentWorkstations>
                                    <cfelseif qryConfigSystem.Type IS "Notebook" AND isNumeric(qryLogin.PercentNotebooks)>
                                        <cfset EstimatedFreight = EstimatedFreight + EstimatedFreight * qryLogin.PercentNotebooks>
                                    <cfelseif qryConfigSystem.Type IS "Server" AND isNumeric(qryLogin.PercentServers)>
                                        <cfset EstimatedFreight = EstimatedFreight + EstimatedFreight * qryLogin.PercentServers>
                                    <cfelseif qryConfigSystem.Type IS "MiniMountablePC" AND isNumeric(qryLogin.PercentMiniMountablePCs)>
                                        <cfset EstimatedFreight = EstimatedFreight + EstimatedFreight * qryLogin.PercentMiniMountablePCs>
                                    </cfif>
                                </cfif>
                            
                            </cfif>
						</cfif>

						<!--- Quantity of Systems being quoted --->
                        <cfif structKeyExists(Arguments.Record, "Quantity") AND isNumeric(Arguments.Record.Quantity) AND Arguments.Record.Quantity GT 1>
                            <cfset EstimatedFreight = EstimatedFreight * Arguments.Record.Quantity>
                        </cfif>
                        
                        <cfset structInsert(strResult, "EstimatedFreight", EstimatedFreight, True)>
                    </cfif>
           		</cfif>
          	</cfif>
        </cfif>
        
		<cfreturn strResult>
	</cffunction>

	<!------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="selectEnergyStar" access="public" returntype="struct" output="No">
	<cfargument name="stFormCopy" type="struct" required="Yes">
    	<cfset var qryConfigSystem = queryNew("")>
        <cfset var qryConfigComponentCategories = queryNew("")>
        <cfset var FieldName = "">
        <cfset var FieldValue = "">
        <cfset var ConfigComponentID = "">
        <cfset var qryConfigComponents = queryNew("")>
        <cfset var qryConfigComponents_ES = queryNew("")>
		<cfset var EnergyStarITEMNO = "">
        <cfset var qryConfigComponentCategories_ES = queryNew("")>
		<cfset var SystemSuffix = "">
        <cfset var qryConfigSystem2 = queryNew("")>
        
<!---
Arguments.stFormCopy:<cfdump var="#Arguments.stFormCopy#">
<cfabort>
--->
		<cfif NOT structKeyExists(Arguments.stFormCopy, "IgnoreEnergyStar")>
    
            <cfquery datasource="#This.DataSourceName#" name="qryConfigSystem">
            SELECT	Name, SystemNumber, EnergystarApproved, DefaultConfigSystemID
            FROM	tblConfigSystems
            WHERE 	ConfigSystemID = '#Arguments.stFormCopy.ConfigSystemID#'
            </cfquery>	
    <!---
    qryConfigSystem:<cfdump var="#qryConfigSystem#">
    --->
            <cfif qryConfigSystem.RecordCount NEQ 0>
                
                <!--- The last 2 characters of the system name must be "ES" for it to be EnergyStar approved --->
                <cfif right(qryConfigSystem.Name, 2) IS "ES" OR qryConfigSystem.EnergystarApproved EQ 1>
            
    
                    <cfif trim(qryConfigSystem.SystemNumber) IS NOT "">
                        <cfset SystemSuffix = trim(qryConfigSystem.SystemNumber)>                    
                    <cfelseif qryConfigSystem.DefaultConfigSystemID IS NOT "">
                        <!--- Try to get the System Number from the default system that this one is maintained from --->
                        <cfquery datasource="#This.DataSourceName#" name="qryConfigSystem2">
                        SELECT	SystemNumber
                        FROM	tblConfigSystems
                        WHERE 	ConfigSystemID = '#qryConfigSystem.DefaultConfigSystemID#'
                        </cfquery>	
                        <cfif qryConfigSystem2.RecordCount NEQ 0>
                            <cfset SystemSuffix = trim(qryConfigSystem2.SystemNumber)>                    
                        </cfif>
                    </cfif>
        <!---
        SystemSuffix:<cfdump var="#SystemSuffix#"><br>
        --->
                    <cfif SystemSuffix IS NOT "">
                    
                        <!--- Get the Energystar category --->
                        <cfquery datasource="#This.DataSourceName#" name="qryConfigComponentCategories_ES">
                        SELECT	ConfigComponentCategoryID
                        FROM	vConfigComponentCategories
                        WHERE 	ConfigSystemID = '#Arguments.stFormCopy.ConfigSystemID#' AND
                                CategoryName = 'EnergyStar'
                        </cfquery>	
        <!---
        qryConfigComponentCategories_ES:<cfdump var="#qryConfigComponentCategories_ES#">
        --->
                        <cfif qryConfigComponentCategories_ES.RecordCount NEQ 0>
                        
                        
            <!---            
            qryConfigSystem.Name:<cfdump var="#qryConfigSystem.Name#"><bR>
            --->      
        <!---          
                            <!--- Get the System Suffix (e.g., "2300ES") --->
                            <cfloop condition="findNoCase(' ', trim(qryConfigSystem.Name))">
                                <cfset qryConfigSystem.Name = removeChars(qryConfigSystem.Name, 1, findNoCase(' ', trim(qryConfigSystem.Name)))>
                            </cfloop>
                            <cfset SystemSuffix = trim(qryConfigSystem.Name)>                    
        --->    
            <!---    
            SystemSuffix:<cfdump var="#SystemSuffix#"><bR>
            --->
                            <!--- Get the Case category --->
                            <cfquery datasource="#This.DataSourceName#" name="qryConfigComponentCategories">
                            SELECT	ConfigComponentCategoryID
                            FROM	vConfigComponentCategories
                            WHERE 	ConfigSystemID = '#Arguments.stFormCopy.ConfigSystemID#' AND
                                    CATEGORY = 'CS'
                            </cfquery>	
            <!---                
            qryConfigComponentCategories:<cfdump var="#qryConfigComponentCategories#">
            --->
                            <cfif qryConfigComponentCategories.RecordCount NEQ 0>
                                <cfset FieldName = "CAT_" & qryConfigComponentCategories.ConfigComponentCategoryID>
                                <cfif structKeyExists(Arguments.stFormCopy, FieldName)>
                                    <cfset FieldValue = Arguments.stFormCopy[FieldName]>
                                    <cfif findNoCase("|", FieldValue) NEQ 0>
                                        <cfset ConfigComponentID = left(FieldValue, findNoCase("|", FieldValue)-1)>
                                    <cfelse>
                                        <cfset ConfigComponentID = FieldValue>
                                    </cfif>
            <!---
            ConfigComponentID:<cfdump var="#ConfigComponentID#"><br>
            --->
                                    <!--- Get the Case component --->
                                    <cfquery datasource="#This.DataSourceName#" name="qryConfigComponents">
                                    SELECT	ITEMNO
                                    FROM	tblConfigComponents
                                    WHERE 	ConfigComponentID = '#ConfigComponentID#'
                                    </cfquery>	
                                    <cfif qryConfigComponents.RecordCount NEQ 0>
            
										<!--- RAB 04/30/2012 --->
<!---                                   <cfif trim(qryConfigComponents.ITEMNO) IS "CS-EV-E4252-BLACK-NPS">	--->
                                        <cfif trim(qryConfigComponents.ITEMNO) IS "CS-EV-4572B-S2">
                                            <cfset EnergyStarITEMNO = "AC-ENERGYSTAR-" & SystemSuffix & "ES">
            
                                        <cfelseif trim(qryConfigComponents.ITEMNO) IS "CS-LO-ST951B-VOY/NP">
                                            <cfset EnergyStarITEMNO = "AC-ENERGYSTAR-L" & SystemSuffix & "ES">
                                            
                                            
										<!--- RAB 05/01/2012 --->
<!---                                        
                                        <cfelseif trim(qryConfigComponents.ITEMNO) IS "CS-CE-TLA397/NP">
                                            <cfset EnergyStarITEMNO = "AC-ENERGYSTAR-C" & SystemSuffix & "ES">
            
                                        <cfelseif trim(qryConfigComponents.ITEMNO) IS "CS-CE-FX629MBKH">
                                            <cfset EnergyStarITEMNO = "AC-ENERGYSTAR-F" & SystemSuffix & "ES">
    
                                        <cfelseif trim(qryConfigComponents.ITEMNO) IS "CS-LO-BK202-80PLUS-VOY">
                                            <cfset EnergyStarITEMNO = "AC-ENERGYSTAR-M" & SystemSuffix & "ES">
--->                                            
                                            
                                        <cfelseif trim(qryConfigComponents.ITEMNO) IS "CS-CM-CAC-T05-UWC">
                                            <cfset EnergyStarITEMNO = "AC-ENERGYSTAR-" & SystemSuffix & "ES">
            
                                        </cfif>
            <!---
            EnergyStarITEMNO:<cfdump var="#EnergyStarITEMNO#"><br>
            --->
            
        
                                        <cfset FieldName = "CAT_" & qryConfigComponentCategories_ES.ConfigComponentCategoryID>
        
                                        <cfset structInsert(Arguments.stFormCopy, FieldName, "ENERGYSTAR|" & EnergyStarITEMNO, True)>
        
        
        
        <!---    
                                        <!--- Get the EnergyStar component --->
                                        <cfquery datasource="#This.DataSourceName#" name="qryConfigComponents_ES">
                                        SELECT	ConfigComponentID
                                        FROM	vConfigComponents
                                        WHERE 	ConfigSystemID = '#Arguments.stFormCopy.ConfigSystemID#' AND
                                                ITEMNO = '#EnergyStarITEMNO#'
                                        </cfquery>	
                                        
                                        <cfif qryConfigComponents_ES.RecordCount NEQ 0>
            
                                            <!--- Get the EnergyStar category --->
                                            <cfquery datasource="#This.DataSourceName#" name="qryConfigComponentCategories_ES">
                                            SELECT	ConfigComponentCategoryID
                                            FROM	vConfigComponentCategories
                                            WHERE 	ConfigSystemID = '#Arguments.stFormCopy.ConfigSystemID#' AND
                                                    CategoryName = 'EnergyStar'
                                            </cfquery>	
                                            <cfif qryConfigComponentCategories_ES.RecordCount NEQ 0>
                                                <cfset FieldName = "CAT_" & qryConfigComponentCategories_ES.ConfigComponentCategoryID>
            
                                                <cfset structInsert(Arguments.stFormCopy, FieldName, qryConfigComponents_ES.ConfigComponentID & "|0|", True)>
                                            </cfif>
                                        </cfif>
        --->                                
                                    </cfif>
                                </cfif>
                            </cfif>
                        </cfif> 
                    </cfif>
                </cfif>
            </cfif>
        </cfif>
            
<!---        
Arguments.stFormCopy:<cfdump var="#Arguments.stFormCopy#">
<cfabort>
--->
        <cfreturn Arguments.stFormCopy>
    </cffunction>


	<!------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="selectPowerSupply" access="public" returntype="struct" output="No">
	<cfargument name="stFormCopy" type="struct" required="Yes">
		<cfset var qryCase = queryNew("")>
        <cfset var FieldName = "">
        <cfset var FieldValue = "">
        <cfset var ConfigComponentID = "">
        <cfset var qryCaseComponent = queryNew("")>
        <cfset var qryPowerSupply = queryNew("")>
        <cfset var qryPowerSupplyComponent = queryNew("")>
        <cfset var qryComponentPrice = queryNew("")>
<!---
Arguments.stFormCopy:<cfdump var="#Arguments.stFormCopy#"><br>
--->
		<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>

		<cfif objConfigSystems.isPowerSupplyAutoSelect(Arguments.stFormCopy.ConfigSystemID)>

			<!--- Case category --->
            <cfquery datasource="#APPLICATION.DSN_WWW#" name="qryCase">
            SELECT	ConfigComponentCategoryID
            FROM    vConfigComponentCategories 
            WHERE   ConfigSystemID = '#Arguments.stFormCopy.ConfigSystemID#' AND
                    CategoryName = 'Case'
            </cfquery>
            
			<cfif qryCase.RecordCount NEQ 0>
                <cfset FieldName = "CAT_" & qryCase.ConfigComponentCategoryID>
                <cfif structKeyExists(Arguments.stFormCopy, FieldName)>
                    <cfset FieldValue = Arguments.stFormCopy[FieldName]>
                    <cfset ConfigComponentID = left(FieldValue, findNoCase("|", FieldValue)-1)>
            
					<!--- Selected Case component --->
                    <cfquery datasource="#APPLICATION.DSN_WWW#" name="qryCaseComponent">
                    SELECT	ITEMNO
                    FROM    tblConfigComponents 
                    WHERE   ConfigComponentID = '#ConfigComponentID#'
                    </cfquery>
<!---
qryCaseComponent:<cfdump var="#qryCaseComponent#"><br>
--->
                    
					<cfif qryCaseComponent.RecordCount NEQ 0>

<!--- 07/12/2011 --->
<!---                    
						<cfif trim(qryCaseComponent.ITEMNO) IS "CS-CE-FX629MBKH" OR 
							  trim(qryCaseComponent.ITEMNO) IS "CS-CE-TLA397/NP" OR 
							  trim(qryCaseComponent.ITEMNO) IS "CS-LO-BK202-80PLUS-VOY">
--->
						<cfif trim(qryCaseComponent.ITEMNO) IS "CS-LO-BK202-80PLUS-VOY">
                        
							<!--- Power supply category --->
                            <cfquery datasource="#APPLICATION.DSN_WWW#" name="qryPowerSupply">
                            SELECT	ConfigComponentCategoryID
                            FROM    vConfigComponentCategories 
                            WHERE   ConfigSystemID = '#Arguments.stFormCopy.ConfigSystemID#' AND
                                    CategoryName = 'Power Supply'
                            </cfquery>
<!---
qryPowerSupply:<cfdump var="#qryPowerSupply#"><br>
--->
							<cfif qryPowerSupply.RecordCount NEQ 0>
                                <cfset FieldName = "CAT_" & qryPowerSupply.ConfigComponentCategoryID>
<!---
FieldName:<cfdump var="#FieldName#"><br>
--->
								<!--- Remove power supply (because it's integrated into the case --->
                                <cfif trim(qryCaseComponent.ITEMNO) IS "CS-LO-BK202-80PLUS-VOY">
                                	<cfif structKeyExists(Arguments.stFormCopy, FieldName)>
                                    	<cfset structDelete(Arguments.stFormCopy, FieldName)>
                                    </cfif>
                                <cfelse>
                                    
                                    <!--- Selected Power Supply component --->
                                    <cfquery datasource="#APPLICATION.DSN_WWW#" name="qryPowerSupplyComponent">
                                    SELECT	ConfigComponentID
                                    FROM    tblConfigComponents 
                                    WHERE   ConfigComponentCategoryID = '#qryPowerSupply.ConfigComponentCategoryID#' AND
                                            ITEMNO = 'PS-AGI-U350PLUS'
                                    </cfquery>
                        
                                    <cfif qryPowerSupplyComponent.RecordCount NEQ 0>
                                        <cfset FieldValue = qryPowerSupplyComponent.ConfigComponentID>
                                        <!--- Get the price  --->
                                        <cfquery datasource="#APPLICATION.DSN_WWW#" name="qryComponentPrice">
                                        SELECT	Price
                                        FROM    tblComponentPrices
                                        WHERE   ConfigComponentID = '#qryPowerSupplyComponent.ConfigComponentID#' AND
                                                PriceListID = '#Arguments.stFormCopy.PriceListID#'
                                        </cfquery>
                                        <cfif qryComponentPrice.RecordCount NEQ 0>
                                            <cfset FieldValue = FieldValue & "|" & qryComponentPrice.Price & "|">
                                        </cfif>
                                        <cfset structInsert(Arguments.stFormCopy, FieldName, FieldValue, True)>
                                    </cfif>
                                
                                </cfif>
                                
							</cfif>
						</cfif>
					</cfif>                                                    
				</cfif>
			</cfif>
		</cfif>

<!---
Arguments.stFormCopy:<cfdump var="#Arguments.stFormCopy#"><br>
--->
        <cfreturn Arguments.stFormCopy>
    </cffunction>


	<!------------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="copyQuote" access="public" returntype="struct" output="No">
    <!---
		Ron Barth, 1/23/2013
		Makes a copy of a quote when clicking "[copy]" on the list of quotes
	--->
	<cfargument name="QuoteSystemID" type="string" required="Yes">
	<cfargument name="CustomerID" type="string" required="Yes">
		<cfset var strResult = structNew()>
		<cfset var qryPriceListComponents = queryNew("")>
		<cfset var qryErrors = queryNew("ITEMNO")>
		<cfset var qryMiscParts = queryNew("")>
        <cfset var AddIt = 0>
        <cfset var ItemDescription = "">
		<cfset var qryQuoteSystem = queryNew("")>
		<cfset var qryQuoteComponents = queryNew("")>
        <cfset var Column = "">
		<cfset var strQuoteSystem = structNew()>
		<cfset var NewQuoteSystemID = "">

        <cfquery datasource="#This.DataSourceName#" name="qryQuoteSystem">
        SELECT	#This.Columns#
        FROM    tblQuoteSystem 
        WHERE   QuoteSystemID = '#Arguments.QuoteSystemID#' 
        </cfquery>
		<cfoutput maxrows="1" query="qryQuoteSystem">
            <cfloop list="#qryQuoteSystem.ColumnList#" index="Column">
                <cfset structInsert(strQuoteSystem, Column, evaluate(Column), True)>
            </cfloop>
        </cfoutput>

		<cfset NewQuoteSystemID = createUUID()>

        <cfquery datasource="#This.DataSourceName#">
        INSERT INTO tblQuoteSystem  (
        	QuoteSystemID,
            CustomerID,
            QuoteNumber,
            QuoteDate,
        	<cfloop list="#This.Columns#" index="Column">
            	<cfif Column IS NOT "QuoteSystemID" AND 
					  Column IS NOT "CustomerID" AND
					  Column IS NOT "QuoteNumber" AND
					  Column IS NOT "QuoteDate">
                    #Column#
                    <cfif Column IS NOT listLast(This.Columns)>
                        ,
                    </cfif>
                </cfif>
            </cfloop>
			)
        VALUES (
            '#NewQuoteSystemID#', 
            '#Arguments.CustomerID#',
            '#getUniqueQuoteNumber()#',
            #createODBCDateTime(now())#,
            <cfloop list="#This.Columns#" index="Column">
            	<cfif Column IS NOT "QuoteSystemID" AND 
					  Column IS NOT "CustomerID" AND
					  Column IS NOT "QuoteNumber" AND
					  Column IS NOT "QuoteDate">
                    
                    <cfif trim(strQuoteSystem[Column]) IS "">
                    	NULL
                    <cfelse>
                        '#strQuoteSystem[Column]#'
                    </cfif>  
                    <cfif Column IS NOT listLast(This.Columns)>
                        ,
                    </cfif>
                </cfif>
            </cfloop>
			)
        </cfquery>	


		<!--- COMPONENTS --->
        <cfquery datasource="#This.DataSourceName#" name="qryQuoteComponents">
        SELECT	QuoteComponentID,QuoteSystemID,ITEMNO,ITEMDESC,TypeName,TypeSortOrder,MiscPart,MiscPartID,PriceListComponentID,SellingPrice,Quantity
        FROM    tblQuoteComponents
        WHERE   QuoteSystemID = '#Arguments.QuoteSystemID#' 
        </cfquery>
        <cfloop query="qryQuoteComponents">

			<cfset AddIt = 1>
        	<cfif qryQuoteComponents.PriceListComponentID IS NOT "">
                <cfquery datasource="#This.DataSourceName#" name="qryPriceListComponents">
                SELECT	PriceListComponentID
                FROM    tblPriceListComponents
                WHERE   PriceListComponentID = '#qryQuoteComponents.PriceListComponentID#' 
                </cfquery>
                <cfif qryPriceListComponents.RecordCount EQ 0>
                	<cfset AddIt = 0>
					<cfset queryAddRow(qryErrors)>
                    <cfset querySetCell(qryErrors, "ITEMNO", qryQuoteComponents.ITEMNO)>
                </cfif>
            <cfelseif qryQuoteComponents.MiscPartID IS NOT "">
                <cfquery datasource="#This.DataSourceName#" name="qryMiscParts">
                SELECT	MiscPartID
                FROM    tblMiscParts
                WHERE   MiscPartID = '#qryQuoteComponents.MiscPartID#' 
                </cfquery>
                <cfif qryMiscParts.RecordCount EQ 0>
                	<cfset AddIt = 0>
					<cfset queryAddRow(qryErrors)>
                    <cfset querySetCell(qryErrors, "ITEMNO", qryQuoteComponents.ITEMNO)>
                </cfif>
            <cfelseif trim(qryQuoteComponents.ITEMNO) IS NOT "">
            
				<cfset ItemDescription = getItemDescription(trim(qryQuoteComponents.ITEMNO))>            	
            	<cfif ItemDescription IS "">
                	<cfset AddIt = 0>
					<cfset queryAddRow(qryErrors)>
                    <cfset querySetCell(qryErrors, "ITEMNO", qryQuoteComponents.ITEMNO)>
                </cfif>
            </cfif>

			<cfif AddIt>
                <cfquery datasource="#This.DataSourceName#">
                INSERT INTO tblQuoteComponents (
                    QuoteComponentID, 
                    QuoteSystemID, 
                    ITEMNO, 
                    ITEMDESC, 
                    TypeName, 
                    TypeSortOrder, 
                    MiscPart, 
                    MiscPartID, 
                    PriceListComponentID, 
                    SellingPrice, 
                    Quantity
                    )
                VALUES (
                    '#createUUID()#', 
                    '#NewQuoteSystemID#',
                    '#qryQuoteComponents.ITEMNO#',
                    '#qryQuoteComponents.ITEMDESC#',
                    '#qryQuoteComponents.TypeName#',
                    '#qryQuoteComponents.TypeSortOrder#',
                    '#qryQuoteComponents.MiscPart#',
                    '#qryQuoteComponents.MiscPartID#',
                    '#qryQuoteComponents.PriceListComponentID#',
                    '#qryQuoteComponents.SellingPrice#',
                    '#qryQuoteComponents.Quantity#'
                    )
                </cfquery>
            </cfif>
        </cfloop>

		<cfset structInsert(strResult, "NewQuoteSystemID", NewQuoteSystemID, True)>
		<cfset structInsert(strResult, "Errors", qryErrors, True)>

		<cfreturn strResult>
    </cffunction>

</cfcomponent>