<cfcomponent extends="admin.assets.cfcs.Component">

	<cfif isDefined("APPLICATION.DSN_WWW")>
		<cfset This.DataSourceName = APPLICATION.DSN_WWW>
	<cfelse>
		<cfset This.DataSourceName = "NorTechWWW">
	</cfif>

	<cfset This.Columns = "PartsOrdersID,CustomerID,SessionID,OrderDate,OrderPlaced,OrderPlacedDate,OrderNumber,Comment">
	<cfset This.ViewColumns = This.Columns>
	
	<cfset This.TableName = "tblPartsOrders">
	<cfset This.ViewName = This.TableName>
	
	<cfset This.PrimaryKey = "PartsOrdersID">
	<cfset This.ForeignHeaderKey = "">
	<cfset This.ForeignDetailKey = "">
	
	<cfset This.ITEMNOKey = "">	

	<cfset This.GenerateUUIDKey = 1>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "OrderDate">
	<cfset This.SortOrder = "Desc">

	<cfset This.SortOrderList = "">
	<cfset This.SortKey = "">
	<cfset This.ParentKey = "">
	<cfset This.CreatedKey = "OrderDate">
	<cfset This.ModifiedKey = "OrderPlacedDate">
	<cfset This.ZipCode1Key = "">
	<cfset This.ZipCode2Key = "">
	<cfset This.SavePrimaryKey = 0>
	<cfset This.ExcludeInUpdates = "">
	<cfset This.ExcludeInInserts = "">

	<cffunction name="processOrder" access="public" output="no">
	<cfargument name="PartsOrdersID" type="string" required="Yes">

		<!--- Set the "OrderPlaced" bit and the OrderNumber --->
		<cfset strPartsOrder = getRecord(Arguments.PartsOrdersID)>
		<cfset structInsert(strPartsOrder, "OrderPlaced", 1, True)>
		<cfset structInsert(strPartsOrder, "OrderNumber", getUniqueOrderNumber(), True)>
		<cfset saveRecord(strPartsOrder)>

		<!--- Send the email to the Nor-Tech sales rep --->
		<cfset sendEmailToNorTech(Arguments.PartsOrdersID)>

		<!--- Send the email to the Customer --->
		<cfset sendEmailToCustomer(Arguments.PartsOrdersID)>
	
	</cffunction>

	<cffunction name="getUniqueOrderNumber" access="public" returntype="string" output="No">
		<cfset var OrderNumber = "">
		<cfset FoundOne = 0>
		<cfloop condition="#FoundOne# EQ 0">
			<cfloop from="1" to="5" index="i">
				<cfset CharacterList = "0,1,2,3,4,5,6,7,8,9">
				<cfset RandomNumber = RandRange(1,ListLen(CharacterList))>
				<cfset RandomLetter = ListGetAt(CharacterList,RandomNumber)>
				<cfset OrderNumber = OrderNumber & RandomLetter>
			</cfloop>
			<cfset OrderNumber = "P" & OrderNumber>
			
			<!--- Make sure this order number isn't being used already --->
			<cfset SearchRecord = structNew()>
			<cfset structInsert(SearchRecord, "OrderNumber", OrderNumber, True)>
			<cfset qryPartsOrders = searchRecords(SearchRecord)>
			<cfif qryPartsOrders.RecordCount EQ 0>
				<cfset FoundOne = 1>
			</cfif>
		</cfloop>
		<cfreturn OrderNumber>
	</cffunction>
	
	<cffunction name="sendEmailToNorTech" access="public" output="no">
	<cfargument name="PartsOrdersID" type="string" required="Yes">
		<cfset objCust = createObject("component", "admin.assets.cfcs.Cust")>
		<cfset objSalesRep = createObject("component", "admin.assets.cfcs.SalesRep")>

		<cfset ToEmailAddress = "">
		<cfset FromEmailAddress = "">
		<cfset SubjectText = "">
		
		<cfset strPartsOrder = getRecord(Arguments.PartsOrdersID)>
		<cfset strReseller = objCust.getLoginRecord(strPartsOrder.CustomerID)>
		<cfset strSalesRep = objSalesRep.getRecord(strReseller.salesrepID)>
		
		<cfset FromEmailAddress = strReseller.email>
		<cfset SubjectText = "Parts Order from " & strReseller.firstname & " " & strReseller.lastname & " of " & strReseller.company>
		<cfset ToEmailAddress = strSalesRep.repemail>

		<cfset CCEmailAddress = "">
		<cfif isDefined("strSalesRep.VacationEmail") AND trim(strSalesRep.VacationEmail) IS NOT "">
			<cfset CCEmailAddress = strSalesRep.VacationEmail>		
		</cfif>

		<cfset PartsOrderText = getPartsOrderText(Arguments.PartsOrdersID)>

<!---	<cfset ToEmailAddress = "ron_barth@altsystem.com">	--->	<!--- TEMP --->

		<cfmail from=	"Nor-Tech Parts Order <info@nor-tech.com>" 
				to=		"#ToEmailAddress#" 
				cc=		"#CCEmailAddress#"  
				replyto="#FromEmailAddress#" 
				subject="#SubjectText#"
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
			The following parts order was submitted by #strReseller.firstname# #strReseller.lastname# of #strReseller.company#:<br><br>		
		
			#PartsOrderText#
		</body>
		</html>			
		</cfmail>
	
	</cffunction>
	
	<cffunction name="sendEmailToCustomer" access="public" output="no">
	<cfargument name="PartsOrdersID" type="string" required="Yes">
		<cfset objCust = createObject("component", "admin.assets.cfcs.Cust")>
		<cfset objSalesRep = createObject("component", "admin.assets.cfcs.SalesRep")>

		<cfset ToEmailAddress = "">
		<cfset FromEmailAddress = "">
		<cfset SubjectText = "">
		
		<cfset strPartsOrder = getRecord(Arguments.PartsOrdersID)>
		<cfset strReseller = objCust.getLoginRecord(strPartsOrder.CustomerID)>
		<cfset strSalesRep = objSalesRep.getRecord(strReseller.salesrepID)>
		
		<cfset ToEmailAddress = strReseller.email>
		<cfset SubjectText = "Parts Order Placed at Nor-Tech">
		<cfset FromEmailAddress = strSalesRep.repemail>

		<cfset PartsOrderText = getPartsOrderText(Arguments.PartsOrdersID)>

<!---	<cfset ToEmailAddress = "ron_barth@altsystem.com">	--->	<!--- TEMP --->

		<cfmail from=	"Nor-Tech Parts Order <info@nor-tech.com>" 
				to=		"#ToEmailAddress#" 
				replyto="#FromEmailAddress#" 
				subject="#SubjectText#"
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
			Thank you for your parts order!  Your order number is: <strong><font color="0033CC">#strPartsOrder.OrderNumber#</font></strong><br><br>
			Details of your order are below.  Please contact your sales rep, <strong><a href="mailto:#strSalesRep.repemail#">#strSalesRep.repname#</a></strong>, if you have any questions regarding this order.<br><br>
		
			#PartsOrderText#
		</body>
		</html>			
		</cfmail>
	
	</cffunction>	
	
	
	<cffunction name="getPartsOrderText" access="public" returntype="string" output="No">
	<cfargument name="PartsOrdersID" type="string" required="Yes">
		<cfset var PartsOrderText = "">

		<cfset objCust = createObject("component", "admin.assets.cfcs.Cust")>
		<cfset objPartsOrdersItems = createObject("component", "admin.assets.cfcs.parts.PartsOrdersItems")>

		<cfset strPartsOrder = getRecord(Arguments.PartsOrdersID)>
		<cfset strReseller = objCust.getLoginRecord(strPartsOrder.CustomerID)>

		<cfset qryPartsOrdersItems = objPartsOrdersItems.listRecordsForParent("PartsOrdersID", Arguments.PartsOrdersID)>

		<cfsavecontent variable="PartsOrderText">
			<cfoutput>
				<table cellpadding="0" cellspacing="0" width="100%" border="0">
					<tr><td><strong>Partner Information:</strong></td></tr>
					<tr><td>#strReseller.firstname# #strReseller.lastname#</td></tr>
					<tr><td>#strReseller.company#</td></tr>
					<tr><td>#strReseller.email#</td></tr>
					<tr><td>Account Number: #strReseller.acctno#</td></tr>
		
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td><strong>Parts Order Number: #strPartsOrder.OrderNumber#</td>
					</tr>
					<cfif trim(strPartsOrder.Comment) IS NOT "">
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td>
								<table cellpadding="0" cellspacing="0" width="100%" border="0">
									<tr>
										<td width="10%"><strong>Comment:</strong></td>
										<td>#strPartsOrder.Comment#</td>
									</tr>
								</table>
							</td>
						</tr>
					</cfif>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td><strong>Parts Ordered:</strong></td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td>
							<table cellpadding="0" cellspacing="0" width="75%" border="0">
								<tr>
									<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF">Part ##</td>
									<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF">Description</font></td>
									<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" align="right">Price</td>
									<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" align="center">Quantity</td>
									<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" align="right">Extension</td>
								</tr>
								<cfset TotalExtension = 0>
								<cfloop query="qryPartsOrdersItems">
									<tr<cfif qryPartsOrdersItems.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
					
										<!--- PART NUMBER --->
										<td style="font-size:10px">#qryPartsOrdersItems.ITEMNO#</td>
										
										<!--- PART DESCRIPTION --->
										<td style="font-size:10px">#qryPartsOrdersItems.ITEMDESC#</td>
										
										<!--- SELLING PRICE --->
										<td style="font-size:10px" align="right">#dollarFormat(qryPartsOrdersItems.SellPrice)#</td>
										
										<!--- QUANTITY --->
										<td style="font-size:10px" align="center">#qryPartsOrdersItems.Quantity#</td>
														
										<!--- EXTENSION --->
										<cfset Extension = 0>
										<cfset FormattedExtension = "">
										<cfif isNumeric(qryPartsOrdersItems.SellPrice) AND isNumeric(qryPartsOrdersItems.Quantity)>
											<cfset Extension = qryPartsOrdersItems.SellPrice * qryPartsOrdersItems.Quantity>
											<cfset FormattedExtension = dollarFormat(Extension)>
										</cfif>
										<td style="font-size:10px" align="right">#FormattedExtension#</td>
		
									</tr>
									<cfset TotalExtension = TotalExtension + Extension>
								</cfloop>
								<!--- TOTAL --->
								<tr><td colspan="5"><hr></td></tr>
								<tr>
									<td colspan="3">&nbsp;</td>
									<td style="font-size:10px" align="right">Total:</td>
									<td style="font-size:10px" align="right">#dollarFormat(TotalExtension)#</td>
								</tr>
							
							</table>
						</td>
					</tr>
				</table>
			</cfoutput>
		</cfsavecontent>
		<cfreturn PartsOrderText>
	</cffunction>
		
</cfcomponent>