<cfcomponent extends="admin.assets.cfcs.Component">

	<cfif isDefined("APPLICATION.DSN_WWW")>
		<cfset This.DataSourceName = APPLICATION.DSN_WWW>
	<cfelse>
		<cfset This.DataSourceName = "NorTechWWW">
	</cfif>

	<cfif isDefined("APPLICATION.DSN_AP")>
		<cfset This.APDataSourceName = APPLICATION.DSN_AP>
	<cfelse>
		<cfset This.APDataSourceName = "NorTechAP">
	</cfif>


	<cfset This.Columns = "PartsAdminID,ITEMNO,ITEMDESC,GarageSale,SellPrice,VendorURL,Inactive,DateInactive">
	<cfset This.ViewColumns = This.Columns>
	
	<cfset This.TableName = "tblPartsAdmin">
	<cfset This.ViewName = This.TableName>
	
	<cfset This.PrimaryKey = "PartsAdminID">
	<cfset This.ForeignHeaderKey = "">
	<cfset This.ForeignDetailKey = "">
	
	<cfset This.ITEMNOKey = "">	

	<cfset This.GenerateUUIDKey = 1>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "ITEMNO">
	<cfset This.SortOrder = "Asc">

	<cfset This.SortOrderList = "">
	<cfset This.SortKey = "">
	<cfset This.ParentKey = "">
	<cfset This.CreatedKey = "">
	<cfset This.ModifiedKey = "">
	<cfset This.ZipCode1Key = "">
	<cfset This.ZipCode2Key = "">
	<cfset This.SavePrimaryKey = 0>
	<cfset This.ExcludeInUpdates = "">
	<cfset This.ExcludeInInserts = "">
	
	<cffunction name="validateRecord" access="public" returntype="struct" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
		<cfif validateRequired(Arguments.Record.ITEMNO) EQ 0>
			<cfset stErrors.ITEMNO = "Please enter the item number">
		<cfelseif NOT itemExists(Arguments.Record.ITEMNO)>
			<cfset stErrors.ITEMNO = "The item you entered was not found in ACCPAC.">
		</cfif>
		<cfif Arguments.Record.GarageSale EQ 1>
			<cfif validateRequired(Arguments.Record.SellPrice) EQ 0>
				<cfset stErrors.SellPrice = "You must enter a selling price.">
			<cfelseif validateZeroDecimal(Arguments.Record.SellPrice) EQ 0>
				<cfset stErrors.SellPrice = "Please enter a numeric value greater than or equal to zero.">
			</cfif>
		</cfif>
		<cfreturn stErrors>
	</cffunction>
	
	<cffunction name="saveRecord" access="public" returntype="string" output="No">
	<cfargument name="Record" type="struct" required="No">
		<cfset var RecordID = "">
		<cfset structInsert(Arguments.Record, "ITEMDESC", getItemDescription(Arguments.Record.ITEMNO), True)>
		<cfset RecordID = super.saveRecord(Arguments.Record)>
		<cfreturn RecordID>
	</cffunction>

	<cffunction name="getSellPrice" access="public" returntype="string" output="No">
	<cfargument name="ITEMNO" type="string" required="Yes">
		<cfset var SellPrice = "">
		<cfset qryGarageSaleItem = getGarageSaleItems("ITEMNO", Arguments.ITEMNO)>
		<cfif qryGarageSaleItem.RecordCount GT 0>
			<cfset SellPrice = qryGarageSaleItem.SellPrice>
		</cfif>
		<cfreturn SellPrice>
	</cffunction>

	<cffunction name="getVendorURL" access="public" returntype="string" output="No">
	<cfargument name="ITEMNO" type="string" required="Yes">
		<cfset var VendorURL = "">
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "ITEMNO", Arguments.ITEMNO, True)>
		<cfset qryPartsAdmin = searchRecords(SearchRecord, "query")>
		<cfif isDefined("qryPartsAdmin.VendorURL") AND trim(qryPartsAdmin.VendorURL) IS NOT "">
			<cfset VendorURL = trim(qryPartsAdmin.VendorURL)>
		</cfif>
		<cfreturn VendorURL>
	</cffunction>

	<cffunction name="getGarageSaleItems" access="public" returntype="query" output="No">
	<cfargument name="OrderByList" type="string" required="no">
	<cfargument name="ITEMNO" type="string" required="no">
		<cfset var qryGarageSaleItems = queryNew(This.ViewColumns)>
		<cfif NOT isDefined("Arguments.OrderByList")>
			<cfset Arguments.OrderByList = This.SortColumn & " " & This.SortOrder>
		</cfif>
		<cfquery datasource="#This.DataSourceName#" name="qryGarageSaleItems">
		SELECT 	#This.ViewColumns#
		FROM 	#This.ViewName#
		WHERE 	GarageSale = 1 AND
				SellPrice >= 0 AND
				Inactive = 0
				<cfif isDefined("Arguments.ITEMNO")>
					AND ITEMNO = '#Arguments.ITEMNO#'
				</cfif>
		ORDER BY #Arguments.OrderByList#
		</cfquery>
		<cfreturn qryGarageSaleItems>
	</cffunction>

	<cffunction name="isGarageSaleItem" access="public" returntype="boolean" output="No">
	<cfargument name="ITEMNO" type="string" required="Yes">
		<cfset var ThisIsAGarageSaleItem = 0>
		<cfquery datasource="#This.DataSourceName#" name="qryGarageSaleItems">
		SELECT 	#This.ViewColumns#
		FROM 	#This.ViewName#
		WHERE 	GarageSale = 1 AND
				SellPrice >= 0 AND 
				ITEMNO = '#Arguments.ITEMNO#'
		</cfquery>
		<cfif qryGarageSaleItems.RecordCount GT 0>
			<cfset ThisIsAGarageSaleItem = 1>
		</cfif>
		<cfreturn ThisIsAGarageSaleItem>
	</cffunction>
	
	<!---------------------------------------------------------------------------------------------------------->	
	<cffunction name="deactivateCloseoutSpecials" access="public" output="no">
		<cfset var qryCloseoutSpecials = queryNew("")>
		<cfset var qryItemQuantity = queryNew("")>
		<cfset var ToAddress = "">

		<cfquery datasource="#This.DataSourceName#" name="qryCloseoutSpecials">
		SELECT 	#This.ViewColumns#
		FROM 	#This.ViewName#
		WHERE 	GarageSale = 1 AND Inactive <> 1
		</cfquery>

		<cfloop query="qryCloseoutSpecials">
			<cfquery datasource="#This.APDataSourceName#" name="qryItemQuantity">
			SELECT 	dbo.ICILOC.ITEMNO
			FROM 	dbo.ICILOC
			WHERE 	dbo.ICILOC.ITEMNO = '#qryCloseoutSpecials.ITEMNO#' AND
					dbo.ICILOC.LOCATION = '1' AND
					dbo.ICILOC.QTYONHAND <= 0
			</cfquery>

			<cfif qryItemQuantity.RecordCount NEQ 0>
				<cfquery datasource="#This.DataSourceName#">
				UPDATE 	tblPartsAdmin 
				SET		Inactive = 1, 
                		DateInactive = #createODBCDateTime(now())#
                        
                        <!--- 06/03/2011 Ron Barth --->
                        <!--- 10/07/2011 Ron Barth.   "Reverse the change we made in June" - Todd Swank --->
                        <!--- ,GarageSale = 0 --->
                        
				WHERE 	PartsAdminID = '#qryCloseoutSpecials.PartsAdminID#'
				</cfquery>
<!---
				<cfset ToAddress = "todds@nor-tech.com">
--->
				<cfset ToAddress = "seanq@nor-tech.com">
                
				<cfmail from=	"Nor-Tech<info@nor-tech.com>" 
						to=		"#ToAddress#" 
						subject="A Close-Out Specials Item was Deactivated"
						type=	"html"
						timeout="60">
					<html>
					<head><style type="text/css">BODY {font-family: Verdana, Arial, Helvetica, sans-serif;}</style></head>
					<body>
						The following closeout special item was deactivated because the on-hand amount is now zero:<br><br>
						
						ITEM: #qryCloseoutSpecials.ITEMNO#<br><br>
						
						Have a great day!
					</body>
					</html>	
				</cfmail>
			</cfif>
		</cfloop>
	</cffunction>
	
	<!---------------------------------------------------------------------------------------------------------->	
	<cffunction name="emailCloseoutSpecials" access="public" output="YES">
		<cfset var qryCloseoutSpecials = "">
		<cfset var SavedCategory = "">
		<cfset var Category = "">
		<cfset var ToAddress = "">
		<cfset var qryICITEM = queryNew("")>
		<cfset var qryICCATG = queryNew("")>
		<cfset var OnHand = 0>
		<cfset var qryItemLocation = queryNew("")>		
		
		<cfset qryCloseoutSpecials = getGarageSaleItems("ITEMNO")>
<!---		
		<cfset ToAddress = "todds@nor-tech.com">
--->
		<cfset ToAddress = "seanq@nor-tech.com">

		<cfmail from=	"Nor-Tech<info@nor-tech.com>" 
				to=		"#ToAddress#" 
				replyto="#ToAddress#" 
				subject="Nor-Tech Close-Out Specials, #dateFormat(now(), 'mmmm d, yyyy')#"
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
		
			<table width="80%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td height="18" style="font-size:14px; font-weight:bold;" colspan="2">
						Nor-Tech Close-Out Specials
					</td>
					<td height="18" style="font-size:14px; font-weight:bold;" align="right" colspan="5">
						#dateFormat(now(), 'mmmm d, yyyy')#
					</td>
				</tr>
				
				<!--- Header --->
				<tr>
					<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF">Item Number</td>
					<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF">Description</td>
					<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" align="center">Quantity On Hand</font></td>
					<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" align="right">Current Price</font></td>
				</tr>
				<tr>
					<td height="18" colspan="4">&nbsp;</td>
				</tr>
				
				<!--- Data --->
				<cfif qryCloseoutSpecials.RecordCount EQ 0>
					<tr>
						<td align="center" colspan="7" style="font-size:12px; font-weight:bold; color:FF0000">
							No closeout special items were found.
						</td>
					</tr>
				</cfif>

				<cfset SavedCategory = "">
				<cfloop query="qryCloseoutSpecials">

					<cfset Category = "">
					<cfquery datasource="#This.APDataSourceName#" name="qryICITEM">
					SELECT 	dbo.ICITEM.CATEGORY
					FROM 	dbo.ICITEM
					WHERE 	dbo.ICITEM.ITEMNO = '#qryCloseoutSpecials.ITEMNO#'
					</cfquery>
					<cfif qryICITEM.RecordCount NEQ 0>
						<cfquery datasource="#This.APDataSourceName#" name="qryICCATG">
						SELECT 	dbo.ICCATG.[DESC]
						FROM 	dbo.ICCATG
						WHERE 	dbo.ICCATG.CATEGORY = '#qryICITEM.CATEGORY#'
						</cfquery>
						<cfif qryICCATG.RecordCount NEQ 0>
							<cfset Category = qryICCATG.DESC>
						</cfif>
					</cfif>

					<cfset OnHand = 0>
					<cfquery datasource="#This.APDataSourceName#" name="qryItemLocation">
					SELECT 	dbo.ICILOC.QTYONHAND
					FROM 	dbo.ICILOC
					WHERE 	dbo.ICILOC.ITEMNO = '#qryCloseoutSpecials.ITEMNO#' AND dbo.ICILOC.LOCATION = '1'
					</cfquery>
					<cfif qryItemLocation.RecordCount NEQ 0>
						<cfset OnHand = qryItemLocation.QTYONHAND>
					</cfif>

					<cfif Category IS NOT SavedCategory>
						<tr>
							<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" colspan="4">
								<font color="FFFFFF">#Category#</font>
							</td>
						</tr>
						<cfset SavedCategory = Category>
					</cfif>
				
					<tr>
						<!--- ITEM NUMBER --->
						<td style="font-size:10px">#qryCloseoutSpecials.ITEMNO#</td>
						<!--- ITEM DESCRIPTION --->						
						<td style="font-size:10px">#qryCloseoutSpecials.ITEMDESC#</td>
						<!--- QUANTITY --->
						<td style="font-size:10px" align="center">#int(OnHand)#</td>
						<!--- ITEM PRICE --->
						<td style="font-size:10px" align="right">#dollarFormat(qryCloseoutSpecials.Sellprice)#</td>
					</tr>

				</cfloop>
			</table>
		</body>
		</html>	
		</cfmail>
	</cffunction>
	
	
</cfcomponent>