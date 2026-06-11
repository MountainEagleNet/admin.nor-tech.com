<cfcomponent extends="admin.assets.cfcs.Component">
<!---<cfset This.DataSourceName = APPLICATION.DSN_AP>--->

	<cfif isDefined("APPLICATION.DSN_AP")>
		<cfset This.DataSourceName = APPLICATION.DSN_AP>
	<cfelse>
		<cfset This.DataSourceName = "NorTechAP">
	</cfif>

	<cfif isDefined("APPLICATION.DSN_WWW")>
		<cfset This.WWWDataSourceName = APPLICATION.DSN_WWW>
	<cfelse>
		<cfset This.WWWDataSourceName = "NorTechWWW">
	</cfif>

	<cfif isDefined("APPLICATION.AdminLocation")>
		<cfset CURRENT_AdminLocation = APPLICATION.AdminLocation>
	<cfelse>
		<cfset CURRENT_AdminLocation = "admin">
	</cfif>
																													 <!--- RAB 10/10/2012 --->
	<cfset This.Columns = "INVUNIQ,INVNUMBER,SHINUMBER,ORDNUMBER,INVDATE,CUSTOMER,BILNAME,ORDDATE,PONUMBER,SHIPTRACK,SHIPVIA">
	<cfset This.ViewColumns = This.Columns>
	
	<cfset This.TableName = "dbo.OEINVH">
	<cfset This.ViewName = This.TableName>
	
	<cfset This.PrimaryKey = "INVUNIQ">
	<cfset This.ITEMNOKey = "">
	<cfset This.GenerateUUIDKey = 0>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "INVNUMBER">
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

	<!---------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="dailySalesReport" access="public" output="no">
		<cfset objAdmin = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.Admin")>

		<!--- get a query of all sales reps --->
		<cfset qrySalesReps = objAdmin.listSalesReps()>
<!---
qrySalesReps:<cfdump var="#qrySalesReps#"><br>
--->        
		<cfloop query="qrySalesReps">

<!--- TEMP RAB 101112 --->
<!---  
			<cfif trim(qrySalesReps.CODESLSP) IS "TS">
--->            

				<cfif qrySalesReps.Active EQ 1 AND trim(qrySalesReps.CODESLSP) IS NOT "">
                    <cfset EmailText = getDailySalesReport(qrySalesReps.CODESLSP)>
                    <cfif EmailText IS NOT "">
                        <cfset ToAddress = qrySalesReps.emailaddress>
    
<!--- TEMP RAB 101112 --->  
<!---
<cfset ToAddress = "ron_barth@altsystem.com">	
--->    
                        <cfif findNoCase("@", ToAddress) NEQ 0 AND findNoCase(".", ToAddress) NEQ 0>
                            <cfmail from=	"info@nor-tech.com"		
                                    to=		"#ToAddress#"
                                    subject="Daily Sales Report"
                                    
                                    
                                    type="html">
                                <html>
                                <head><style type="text/css">BODY {font-family: Verdana, Arial, Helvetica, sans-serif;}</style></head>
                                <body>
                                #EmailText#
                                </body>
                                </html>	
                            </cfmail>
                            
                        </cfif>
                    </cfif>

                </cfif>

<!--- TEMP RAB 101112 --->  
<!---
            </cfif>
--->

		</cfloop>
	</cffunction>

	<!---------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="getDailySalesReport" access="public" returntype="string" output="No">
	<cfargument name="CODESLSP" type="string" required="Yes">
		<cfset var EmailText = "">
		<cfset var ReportDate = "">
		<cfset var DateOfReport = "">
		<cfset var qrySales = queryNew("INVUNIQ,INVNUMBER,CUSTOMER,BILNAME,TotalItemSales,TotalItemCost")>
		<cfset var qryCredits = queryNew("CRDUNIQ,CRDNUMBER,CUSTOMER,BILNAME,TotalItemSales,TotalItemCost")>
        
        <cfset var NewTotalItemCost = "">
        
		<!--- Use Yesterday's Date as the Report Date --->
        <cfset ReportDate = dateFormat(dateAdd('d', -1, now()), "yyyymmdd")>
        <cfset DateOfReport = dateAdd('d', -1, now())>
			

<!--- TEMP RAB 101112 --->  
<!---
<cfset ReportDate = "20121010">		
<cfset DateOfReport = "10/10/2012">	
--->
		<!--- Skip Saturday and Sunday --->
		<cfif dayOfWeek(DateOfReport) NEQ 7 AND dayOfWeek(DateOfReport) NEQ 1>
	
			<!--- SALES --->
			<cfquery datasource="NorTechAP" name="qrySales">
            SELECT	dbo.OEINVH.INVUNIQ, dbo.OEINVH.INVNUMBER, dbo.OEINVH.CUSTOMER, dbo.OEINVH.BILNAME,
                    (SELECT	SUM(dbo.OEINVD.QtyShipped * dbo.OEINVD.UnitPrice)
                     FROM   dbo.OEINVD
                     WHERE  dbo.OEINVH.INVUNIQ = dbo.OEINVD.INVUNIQ) AS TotalItemSales

<!--- 1/18/2011: Switching this back: we are now grabbing cost from the invoice --->
<!--- 2/28/2011: Switching this back (again): we are now grabbing cost from inventory --->
<!--- vvvvvvvvvvvvvvvvvv --->
<!---
                     ,
                    (SELECT	SUM(dbo.OEINVD.QtyShipped * dbo.OEINVD.UnitCost)
                     FROM   dbo.OEINVD
                     WHERE  dbo.OEINVH.INVUNIQ = dbo.OEINVD.INVUNIQ) AS TotalItemCost
--->                     
<!--- ^^^^^^^^^^^^^^^^^^ --->

            FROM	dbo.OEINVH
                    INNER JOIN dbo.ARCUS ON dbo.OEINVH.CUSTOMER = dbo.ARCUS.IDCUST 
                    INNER JOIN dbo.ARSAP ON dbo.ARCUS.CODESLSP1 = dbo.ARSAP.CODESLSP
            WHERE	dbo.OEINVH.INVDATE = '#ReportDate#' AND
                    dbo.ARSAP.CODESLSP = '#Arguments.CODESLSP#'
            ORDER BY dbo.OEINVH.CUSTOMER, dbo.OEINVH.INVNUMBER
			</cfquery>

<!--- TEMP RAB 101112 --->  
<!---
qrySales:<cfdump var="#qrySales#"><br>
--->
			<!--- CREDITS --->
			<cfquery datasource="NorTechAP" name="qryCredits">
			SELECT	dbo.OECRDH.CRDUNIQ, dbo.OECRDH.CRDNUMBER, dbo.OECRDH.CUSTOMER, dbo.OECRDH.BILNAME,
					(SELECT	SUM(dbo.OECRDD.QTYRETURN * dbo.OECRDD.UnitPrice)
					 FROM   dbo.OECRDD
					 WHERE  dbo.OECRDH.CRDUNIQ = dbo.OECRDD.CRDUNIQ) AS TotalItemSales,
					(SELECT	SUM(dbo.OECRDD.QTYRETURN * dbo.OECRDD.UnitCost)
					 FROM   dbo.OECRDD
					 WHERE  dbo.OECRDH.CRDUNIQ = dbo.OECRDD.CRDUNIQ) AS TotalItemCost
			FROM	dbo.OECRDH
					INNER JOIN dbo.ARCUS ON dbo.OECRDH.CUSTOMER = dbo.ARCUS.IDCUST 
					INNER JOIN dbo.ARSAP ON dbo.ARCUS.CODESLSP1 = dbo.ARSAP.CODESLSP
			WHERE	dbo.OECRDH.CRDDATE = '#ReportDate#' AND
					dbo.ARSAP.CODESLSP = '#Arguments.CODESLSP#'
			ORDER BY dbo.OECRDH.CUSTOMER, dbo.OECRDH.CRDNUMBER
			</cfquery>

<!--- TEMP RAB 101112 ---> 
<!--- 
qryCredits:<cfdump var="#qryCredits#"><br>
--->
			<cfquery datasource="#This.WWWDataSourceName#" name="qrySalesRep">
			SELECT	repname
			FROM	salesrep
			WHERE	CODESLSP = '#Arguments.CODESLSP#' 
			</cfquery>		
	
			<cfsavecontent variable="EmailText">
				<cfoutput>
					<table width="90%" align="center" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td colspan="7">
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td height="18" style="font-size:14px; font-weight:bold;" width="33%">
											Daily Sales Report 
										</td>
										<td height="18" style="font-size:14px; font-weight:bold;" width="33%" align="center">
											<cfif isDefined("qrySalesRep.repname")>
												Sales Rep: #qrySalesRep.repname#
											<cfelse>
												&nbsp;
											</cfif>
										</td>
										<td height="18" style="font-size:14px; font-weight:bold;" align="right">
											Report Date: #dateFormat(DateOfReport, 'mmmm d, yyyy')#
										</td>
									</tr>
								</table>								
							</td>
						</tr>
						
						<!--- Header --->
						<tr>
							<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF">Document<br>Number</td>
							<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF">Customer<br>Number</font></td>
							<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF">Customer<br>Name</td>
							<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" align="right">Total Item<br>Sales</td>
							<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" align="right">Total Item<br>Cost</td>
							<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" align="right">Gross<br>Profit</td>
							<td height="18" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" width="5%">&nbsp;</td>
						</tr>			
					
						<!--- Data --->
						<cfif qrySales.RecordCount EQ 0>
							<tr>
								<td align="center" colspan="7" style="font-size:12px; font-weight:bold; color:FF0000">
									No invoices or credits were found.
								</td>
							</tr>
						</cfif>
					
						<cfset Total_TotalItemSales = 0>
						<cfset Total_TotalItemCost = 0>
						<cfset Total_GrossProfit = 0>
						
						<!--- SALES --->
						<cfloop query="qrySales">
							
							<tr<cfif qrySales.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
								<!--- DOCUMENT NUMBER --->
								<td style="font-size:10px" valign="top">#qrySales.INVNUMBER#</td>
					
								<!--- CUSTOMER NUMBER --->
								<td style="font-size:10px" valign="top">#qrySales.CUSTOMER#</td>
					
								<!--- CUSTOMER NAME --->
								<td style="font-size:10px" valign="top">#qrySales.BILNAME#</td>
					
								<!--- TOTAL ITEM SALES --->
								<td style="font-size:10px" valign="top" align="right">#dollarFormat(qrySales.TotalItemSales)#</td>
				
								<!--- TOTAL ITEM COST --->
<!--- 1/18/2011: Switching this back: we are now grabbing cost from the invoice --->
<!--- 2/28/2011: Switching this back (again): we are now grabbing cost from inventory --->
<!--- vvvvvvvvvvvvvvvvvv --->
<!---
								<td style="font-size:10px" valign="top" align="right">#dollarFormat(qrySales.TotalItemCost)#</td>
--->
                                <cfset NewTotalItemCost = getTotalItemCost(qrySales.INVUNIQ)>
								<td style="font-size:10px" valign="top" align="right">#dollarFormat(NewTotalItemCost)#</td>


<!--- TEMP RAB 101112 --->  
<!---
<cfif trim(qrySales.INVUNIQ) IS "11171906">
NewTotalItemCost:<cfoutput>#NewTotalItemCost#</cfoutput><br>
</cfif>
--->


								<!--- GROSS PROFIT --->
<!---							<cfset GrossProfit = qrySales.TotalItemSales - qrySales.TotalItemCost>		--->
								<cfset GrossProfit = qrySales.TotalItemSales - NewTotalItemCost>	
                                
								<td style="font-size:10px" valign="top" align="right">#dollarFormat(GrossProfit)#</td>
<!--- ^^^^^^^^^^^^^^^^^^ --->
								
								<td>&nbsp;</td>
							</tr>
							<cfset Total_TotalItemSales = Total_TotalItemSales + qrySales.TotalItemSales>
                            
<!---						<cfset Total_TotalItemCost = Total_TotalItemCost + qrySales.TotalItemCost>	--->
							<cfset Total_TotalItemCost = Total_TotalItemCost + NewTotalItemCost>	

							<cfset Total_GrossProfit = Total_GrossProfit + GrossProfit>
						</cfloop>
						
						<!--- CREDITS --->
						<cfloop query="qryCredits">
<!---
							<cfquery datasource="NorTechAP" name="qryOECRDD">
							SELECT	ITEM, QTYRETURN
							FROM    dbo.OECRDD
							WHERE   (CRDUNIQ = '#qryCredits.CRDUNIQ#')
							ORDER BY LINENUM
							</cfquery>
							
							<cfset TotalItemCost = 0>
							<cfloop query="qryOECRDD">
								<cfif trim(qryOECRDD.ITEM) IS NOT "">
									<cfquery datasource="NorTechAP" name="qryICILOC">
									SELECT	TOTALCOST, QTYONHAND, LASTCOST, RECENTCOST
									FROM    dbo.ICILOC
									WHERE   (ITEMNO = '#qryOECRDD.ITEM#') AND (LOCATION = '1')
									</cfquery>
									<cfif qryICILOC.RecordCount GT 0>
										<!--- TOTALCOST/QTYONHAND, if QTYONHAND > 0 --->
										<cfif isNumeric(qryICILOC.TOTALCOST) AND isNumeric(qryICILOC.QTYONHAND) AND qryICILOC.QTYONHAND GT 0>
											<cfset TotalItemCost = TotalItemCost + qryOECRDD.QTYRETURN * (qryICILOC.TOTALCOST / qryICILOC.QTYONHAND)>
										<!--- Otherwise use LAST COST, if last cost is greater than zero --->
										<cfelseif isNumeric(qryICILOC.LASTCOST) AND qryICILOC.LASTCOST GT 0>
											<cfset TotalItemCost = TotalItemCost + qryOECRDD.QTYRETURN * qryICILOC.LASTCOST>
										<!--- Otherwise use RECENT COST --->
										<cfelse>
											<cfset TotalItemCost = TotalItemCost + qryOECRDD.QTYRETURN * qryICILOC.RECENTCOST>
										</cfif>
									</cfif>
								</cfif>
							</cfloop>
--->													
							<tr<cfif qryCredits.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
								<!--- DOCUMENT NUMBER --->
								<td style="font-size:10px" valign="top">#qryCredits.CRDNUMBER#</td>
					
								<!--- CUSTOMER NUMBER --->
								<td style="font-size:10px" valign="top">#qryCredits.CUSTOMER#</td>
					
								<!--- CUSTOMER NAME --->
								<td style="font-size:10px" valign="top">#qryCredits.BILNAME#</td>
					
								<!--- TOTAL ITEM SALES --->
								<td style="font-size:10px" valign="top" align="right">#dollarFormat(qryCredits.TotalItemSales * -1)#</td>
					
								<!--- TOTAL ITEM COST --->
								<td style="font-size:10px" valign="top" align="right">#dollarFormat(qryCredits.TotalItemCost * -1)#</td>
								
								<!--- GROSS PROFIT --->
								<cfset GrossProfit = qryCredits.TotalItemSales - qryCredits.TotalItemCost>
								<td style="font-size:10px" valign="top" align="right">#dollarFormat(GrossProfit * -1)#</td>
								
								<td>&nbsp;</td>
							</tr>
							<cfset Total_TotalItemSales = Total_TotalItemSales - qryCredits.TotalItemSales>
							<cfset Total_TotalItemCost = Total_TotalItemCost - qryCredits.TotalItemCost>
							<cfset Total_GrossProfit = Total_GrossProfit - GrossProfit>
						</cfloop>
						
						<!--- Grand Totals --->
						<tr style="background-color:##e5e5e6">
							<td height="22" bgcolor="006633" style="font-size:12px; font-weight:bold; font-style:italic; color:FFFFFF" colspan="3" align="right" valign="middle">
								Totals<cfif isDefined("qrySalesRep.repname")> for #qrySalesRep.repname#</cfif>:
							</td>
							<td height="22" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" align="right" valign="middle">
								#dollarFormat(Total_TotalItemSales)#
							</td>
							<td height="22" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" align="right" valign="middle">
								#dollarFormat(Total_TotalItemCost)#
							</td>
							<td height="22" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" align="right" valign="middle">
								#dollarFormat(Total_GrossProfit)#
							</td>
							<td height="22" bgcolor="006633" style="font-size:12px; font-weight:bold; color:FFFFFF" align="right" valign="middle">&nbsp;
								
							</td>
						</tr>
					</table>
				</cfoutput>
			</cfsavecontent>
		</cfif>

        
		<cfreturn EmailText>
	</cffunction>	


	<!---------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="getTotalItemCost" access="public" returntype="numeric" output="no">
	<cfargument name="INVUNIQ" type="string" required="Yes">
    	<cfset var NewTotalItemCost = 0>
        <cfset var IndividualItemCost = 0>
        <cfset var qryOEINVD = queryNew("")>

        <cfquery datasource="NorTechAP" name="qryOEINVD">
        SELECT	INVUNIQ, LINENUM, ITEM, [DESC], QTYORDERED, QTYSHIPPED, QTYBACKORD, ORDNUMBER, UNITPRICE, UNITCOST
        FROM    dbo.OEINVD
        WHERE   INVUNIQ = '#trim(Arguments.INVUNIQ)#'
        </cfquery>

<!--- TEMP RAB 101112 ---> 
<!---
<cfif trim(Arguments.INVUNIQ) IS "11171906">
qryOEINVD:<cfdump var="#qryOEINVD#"><br>
<cfabort>
</cfif>
--->
		<cfloop query="qryOEINVD">
        	<cfif trim(qryOEINVD.ITEM) IS NOT "">
            	<cfset IndividualItemCost = getItemCost(qryOEINVD.ITEM)>
            	<cfset NewTotalItemCost = NewTotalItemCost + (qryOEINVD.QTYSHIPPED * IndividualItemCost)>
            </cfif>
        </cfloop>
<!---
NewTotalItemCost:<cfdump var="#NewTotalItemCost#"><br>
<cfabort>
--->    
        
    	<cfreturn NewTotalItemCost>
	</cffunction>	


	<!---------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="setSalesHistory" access="public" output="no">
        <cfset var qrySalesReps = queryNew("")>
        <cfset var Yesterday = "">
        <cfset var FormattedDate = "">
        <cfset var CurrentDate = 0>
        <cfset var qrySales = queryNew("")>
        <cfset var qryCredits = queryNew("")>
		<cfset var TotalSales = 0>
        <cfset var TotalCost = 0>
        <cfset var GrossProfit = 0>
        <cfset var NewTotalItemCost = 0>

		<cfset objAdmin = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.Admin")>

		<!--- get a query of all sales reps --->
		<cfset qrySalesReps = objAdmin.listSalesReps()>

		<cfset Yesterday = dateAdd('d', -1, now())>       
        
		<cfset FormattedDate = dateFormat(Yesterday, "mm/dd/yyyy")>
        <cfset CurrentDate = formatDateToInteger(FormattedDate)>


        <!--- Skip Sat and Sun --->
        <cfif dayOfWeek(FormattedDate) NEQ 1 AND dayOfWeek(FormattedDate) NEQ 7>

            <cfloop query="qrySalesReps">
                <cfif qrySalesReps.Active EQ 1 AND trim(qrySalesReps.CODESLSP) IS NOT "">

					<!--- SALES --->
                    <cfquery datasource="NorTechAP" name="qrySales">
                    SELECT	dbo.OEINVH.INVUNIQ,
                            (SELECT	SUM(dbo.OEINVD.QtyShipped * dbo.OEINVD.UnitPrice)
                             FROM   dbo.OEINVD
                             WHERE  dbo.OEINVH.INVUNIQ = dbo.OEINVD.INVUNIQ) AS TotalItemSales

<!--- 1/18/2011: Switching this back: we are now grabbing cost from the invoice --->
<!--- 2/28/2011: Switching this back (again): we are now grabbing cost from inventory --->
<!--- vvvvvvvvvvvvvvvvvv --->
<!---
                             ,
                            (SELECT	SUM(dbo.OEINVD.QtyShipped * dbo.OEINVD.UnitCost)
                             FROM   dbo.OEINVD
                             WHERE  dbo.OEINVH.INVUNIQ = dbo.OEINVD.INVUNIQ) AS TotalItemCost
--->                             
<!--- ^^^^^^^^^^^^^^^^^^ --->
                             
                             
                    FROM	dbo.OEINVH
                            INNER JOIN dbo.ARCUS ON dbo.OEINVH.CUSTOMER = dbo.ARCUS.IDCUST 
                            INNER JOIN dbo.ARSAP ON dbo.ARCUS.CODESLSP1 = dbo.ARSAP.CODESLSP
                    WHERE	dbo.OEINVH.INVDATE = '#CurrentDate#' AND
                            dbo.ARSAP.CODESLSP = '#qrySalesReps.CODESLSP#'
                    </cfquery>
                    <!--- CREDITS --->
                    <cfquery datasource="NorTechAP" name="qryCredits">
                    SELECT	dbo.OECRDH.CRDUNIQ,
                            (SELECT	SUM(dbo.OECRDD.QTYRETURN * dbo.OECRDD.UnitPrice)
                             FROM   dbo.OECRDD
                             WHERE  dbo.OECRDH.CRDUNIQ = dbo.OECRDD.CRDUNIQ) AS TotalItemSales,
                            (SELECT	SUM(dbo.OECRDD.QTYRETURN * dbo.OECRDD.UnitCost)
                             FROM   dbo.OECRDD
                             WHERE  dbo.OECRDH.CRDUNIQ = dbo.OECRDD.CRDUNIQ) AS TotalItemCost
                    FROM	dbo.OECRDH
                            INNER JOIN dbo.ARCUS ON dbo.OECRDH.CUSTOMER = dbo.ARCUS.IDCUST 
                            INNER JOIN dbo.ARSAP ON dbo.ARCUS.CODESLSP1 = dbo.ARSAP.CODESLSP
                    WHERE	dbo.OECRDH.CRDDATE = '#CurrentDate#' AND
                            dbo.ARSAP.CODESLSP = '#qrySalesReps.CODESLSP#'
                    </cfquery>

					<cfset TotalSales = 0>
                    <cfset TotalCost = 0>
                    <cfset GrossProfit = 0>
                    
                    <cfloop query="qrySales">
                        <cfset TotalSales = TotalSales + qrySales.TotalItemSales>

<!--- 1/18/2011: Switching this back: we are now grabbing cost from the invoice --->
<!--- 2/28/2011: Switching this back (again): we are now grabbing cost from inventory --->
<!--- vvvvvvvvvvvvvvvvvv --->
<!---
                        <cfset TotalCost = TotalCost + qrySales.TotalItemCost>
--->
                        <cfset NewTotalItemCost = getTotalItemCost(qrySales.INVUNIQ)>
                        <cfset TotalCost = TotalCost + NewTotalItemCost>
<!--- ^^^^^^^^^^^^^^^^^^ --->
                    </cfloop>
                    
                    <cfloop query="qryCredits">
                        <cfset TotalSales = TotalSales - qryCredits.TotalItemSales>
						<cfset TotalCost = TotalCost - qryCredits.TotalItemCost>
                    </cfloop>

					<cfset GrossProfit = TotalSales - TotalCost>
        
                    <cfquery datasource="#This.WWWDataSourceName#">
                    INSERT INTO tblSalesHistory (
                        SalesHistoryID, 
                        DateOfSale,
                        CODESLSP,
                        fname,
                        lname,
                        Sales,
                        Cost,
                        GrossProfit)
                    VALUES (
                        '#createUUID()#', 
                        '#CurrentDate#',
                        '#qrySalesReps.CODESLSP#',
                        '#qrySalesReps.fname#',
                        '#qrySalesReps.lname#',
                        '#int(TotalSales)#',
                        '#int(TotalCost)#',
                        '#int(GrossProfit)#')
                    </cfquery>		
				</cfif>
			</cfloop>
		</cfif>

	</cffunction>	


	<!---------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="setSalesHistory_RESYNC" access="public" output="no">
<!---
		Called from actSalesReports_082211 to resync the August 17th 2011 numbers.  This is a temporary process,
		used only once.
--->    
        <cfset var qrySalesReps = queryNew("")>
        <cfset var Yesterday = "">
        <cfset var FormattedDate = "">
        <cfset var CurrentDate = 0>
        <cfset var qrySales = queryNew("")>
        <cfset var qryCredits = queryNew("")>
		<cfset var TotalSales = 0>
        <cfset var TotalCost = 0>
        <cfset var GrossProfit = 0>
        <cfset var NewTotalItemCost = 0>

		<cfset objAdmin = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.Admin")>

		<!--- get a query of all sales reps --->
		<cfset qrySalesReps = objAdmin.listSalesReps()>

		<cfset Yesterday = "08/17/2011">       
        
		<cfset FormattedDate = dateFormat(Yesterday, "mm/dd/yyyy")>
        <cfset CurrentDate = formatDateToInteger(FormattedDate)>
<!---
FormattedDate:<cfdump var="#FormattedDate#"><br>
CurrentDate:<cfdump var="#CurrentDate#"><br>
--->
        <!--- Skip Sat and Sun --->
        <cfif dayOfWeek(FormattedDate) NEQ 1 AND dayOfWeek(FormattedDate) NEQ 7>

            <cfloop query="qrySalesReps">
                <cfif qrySalesReps.Active EQ 1 AND trim(qrySalesReps.CODESLSP) IS NOT "">

					<!--- SALES --->
                    <cfquery datasource="NorTechAP" name="qrySales">
                    SELECT	dbo.OEINVH.INVUNIQ,
                            (SELECT	SUM(dbo.OEINVD.QtyShipped * dbo.OEINVD.UnitPrice)
                             FROM   dbo.OEINVD
                             WHERE  dbo.OEINVH.INVUNIQ = dbo.OEINVD.INVUNIQ) AS TotalItemSales
                    FROM	dbo.OEINVH
                            INNER JOIN dbo.ARCUS ON dbo.OEINVH.CUSTOMER = dbo.ARCUS.IDCUST 
                            INNER JOIN dbo.ARSAP ON dbo.ARCUS.CODESLSP1 = dbo.ARSAP.CODESLSP
                    WHERE	dbo.OEINVH.INVDATE = '#CurrentDate#' AND
                            dbo.ARSAP.CODESLSP = '#qrySalesReps.CODESLSP#'
                    </cfquery>
                    <!--- CREDITS --->
                    <cfquery datasource="NorTechAP" name="qryCredits">
                    SELECT	dbo.OECRDH.CRDUNIQ,
                            (SELECT	SUM(dbo.OECRDD.QTYRETURN * dbo.OECRDD.UnitPrice)
                             FROM   dbo.OECRDD
                             WHERE  dbo.OECRDH.CRDUNIQ = dbo.OECRDD.CRDUNIQ) AS TotalItemSales,
                            (SELECT	SUM(dbo.OECRDD.QTYRETURN * dbo.OECRDD.UnitCost)
                             FROM   dbo.OECRDD
                             WHERE  dbo.OECRDH.CRDUNIQ = dbo.OECRDD.CRDUNIQ) AS TotalItemCost
                    FROM	dbo.OECRDH
                            INNER JOIN dbo.ARCUS ON dbo.OECRDH.CUSTOMER = dbo.ARCUS.IDCUST 
                            INNER JOIN dbo.ARSAP ON dbo.ARCUS.CODESLSP1 = dbo.ARSAP.CODESLSP
                    WHERE	dbo.OECRDH.CRDDATE = '#CurrentDate#' AND
                            dbo.ARSAP.CODESLSP = '#qrySalesReps.CODESLSP#'
                    </cfquery>

					<cfset TotalSales = 0>
                    <cfset TotalCost = 0>
                    <cfset GrossProfit = 0>
                    
                    <cfloop query="qrySales">
                        <cfset TotalSales = TotalSales + qrySales.TotalItemSales>
                        <cfset NewTotalItemCost = getTotalItemCost(qrySales.INVUNIQ)>
                        <cfset TotalCost = TotalCost + NewTotalItemCost>
                    </cfloop>
                    
                    <cfloop query="qryCredits">
                        <cfset TotalSales = TotalSales - qryCredits.TotalItemSales>
						<cfset TotalCost = TotalCost - qryCredits.TotalItemCost>
                    </cfloop>

					<cfset GrossProfit = TotalSales - TotalCost>
        
                    <cfquery datasource="#This.WWWDataSourceName#">
                    INSERT INTO tblSalesHistory (
                        SalesHistoryID, 
                        DateOfSale,
                        CODESLSP,
                        fname,
                        lname,
                        Sales,
                        Cost,
                        GrossProfit)
                    VALUES (
                        '#createUUID()#', 
                        '#CurrentDate#',
                        '#qrySalesReps.CODESLSP#',
                        '#qrySalesReps.fname#',
                        '#qrySalesReps.lname#',
                        '#int(TotalSales)#',
                        '#int(TotalCost)#',
                        '#int(GrossProfit)#')
                    </cfquery>		
				</cfif>
			</cfloop>
		</cfif>

	</cffunction>	
    
	<!---------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="monthToDateSales" access="public" output="no">
		<cfset objAdmin = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.Admin")>

		<!--- get a query of all sales reps --->
		<cfset qrySalesReps = objAdmin.listSalesReps011516()>
		
		<cfset EmailText = getmonthToDateSales_NEW(qrySalesReps)>
		<cfif EmailText IS NOT "">
			<cfloop query="qrySalesReps">
				<cfif qrySalesReps.Active EQ 1 AND trim(qrySalesReps.CODESLSP) IS NOT "">

					<cfset ToAddress = qrySalesReps.emailaddress>	

<!--- TEMP RAB --->
<!---
<cfset ToAddress = "ron_barth@altsystem.com">
--->					
					<cfif findNoCase("@", ToAddress) NEQ 0 AND findNoCase(".", ToAddress) NEQ 0>
						<cfmail from=	"info@nor-tech.com"		
								to=		"#ToAddress#"
								subject="Month to Date Sales Report"
								
								
								type="html">
							<html>
							<head><style type="text/css">BODY {font-family: Verdana, Arial, Helvetica, sans-serif;}</style></head>
							<body>
							#EmailText#
							</body>
							</html>	
						</cfmail>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
	</cffunction>	
	
	<!---------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="getmonthToDateSales_NEW" access="public" returntype="string" output="No">
	<cfargument name="qrySalesReps" type="query" required="Yes">
		<cfset var EmailText = "">
		<cfset var BeginningDate = "">
		<cfset var EndingDate = "">
		<cfset var MonthAbbrev = "">
		<cfset var strMonthTotalSales = structNew()>
		<cfset var strMonthTotalGrossProfit = structNew()>
		<cfset var lstMonthTotalSales = "">
		<cfset var lstMonthTotalGrossProfit = "">
		<cfset var CurrentDate = "">
		<cfset var FormattedDate = "">
		<cfset var TotalSales = 0>
		<cfset var TotalCost = 0>
		<cfset var GrossProfit = 0>
		<cfset var CurrentAmount = 0>
		<cfset var MonthlySalesTotalAmount = 0>
		<cfset var MonthlyGrossProfitTotalAmount = 0>
		<cfset var Yesterday = "">
        <cfset var NewTotalItemCost = "">
        <cfset var qrySalesHistory = queryNew("")>

		<cfset Yesterday = dateAdd('d', -1, now())>

		<cfset BeginningDate = year(Yesterday) & dateFormat(Yesterday, 'mm') & "01">
		<cfset EndingDate = BeginningDate + daysInMonth(Yesterday) - 1>
		<cfset MonthAbbrev = dateFormat(Yesterday, 'mmm')>
        

<!--- TEMP RAB --->        
<!---
<cfset BeginningDate = "20100501">		
<cfset EndingDate = "20100531">
<cfset MonthAbbrev = "May">	   
--->
		<cfsavecontent variable="EmailText">
			<cfoutput>
				<table width="100%" align="center" border="1" cellpadding="0" cellspacing="0">
					<tr>
						<td colspan="30">
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td height="18" style="font-size:14px; font-weight:bold;" width="50%">
										Month to Date Sales Report 
									</td>
									<td height="18" style="font-size:14px; font-weight:bold;" align="right">
										Report Date: #dateFormat(now(), 'mmmm d, yyyy')#
									</td>
								</tr>
							</table>								
						</td>
					</tr>
					
					<!--- Header --->
					<tr>
<!---					<td height="18" bgcolor="006633" style="font-size:10px; font-weight:bold; color:FFFFFF">Date</td>	--->
						<td height="18" style="font-size:10px; font-weight:bold;">Date</td>
						<cfloop query="Arguments.qrySalesReps">
							<cfif Arguments.qrySalesReps.Active EQ 1 AND trim(Arguments.qrySalesReps.CODESLSP) IS NOT "">
<!---							<td align="center" colspan="2" height="18" bgcolor="006633" style="font-size:10px; font-weight:bold; color:FFFFFF">	--->
								<td align="center" colspan="2" height="18" style="font-size:10px; font-weight:bold;">
									#Arguments.qrySalesReps.fname# #Arguments.qrySalesReps.lname#
								</td>
							</cfif>
						</cfloop>
					</tr>
					<tr>
<!---					<td height="18" bgcolor="006633" style="font-size:10px; font-weight:bold; color:FFFFFF">&nbsp;</td>	--->
						<td height="18" style="font-size:10px; font-weight:bold;">&nbsp;</td>
						<cfloop query="Arguments.qrySalesReps">
							<cfif Arguments.qrySalesReps.Active EQ 1 AND trim(Arguments.qrySalesReps.CODESLSP) IS NOT "">
<!---							<td align="center" height="18" bgcolor="006633" style="font-size:10px; font-weight:bold; color:FFFFFF">Sales</td>	--->
								<td align="center" height="18" style="font-size:10px; font-weight:bold;">Sales</td>
<!---							<td align="center" height="18" bgcolor="006633" style="font-size:10px; font-weight:bold; color:FFFFFF">G.P.</td>	--->
								<td align="center" height="18" style="font-size:10px; font-weight:bold;">G.P.</td>
							</cfif>
						</cfloop>
					</tr>
				
					<cfset strMonthTotalSales = structNew()>
					<cfset strMonthTotalGrossProfit = structNew()>
					
					<cfloop query="Arguments.qrySalesReps">
						<cfif Arguments.qrySalesReps.Active EQ 1 AND trim(Arguments.qrySalesReps.CODESLSP) IS NOT "">
							<cfset structInsert(strMonthTotalSales, trim(Arguments.qrySalesReps.CODESLSP), 0, True)>
							<cfset structInsert(strMonthTotalGrossProfit, trim(Arguments.qrySalesReps.CODESLSP), 0, True)>
						</cfif>
					</cfloop>
				
					<cfset lstMonthTotalSales = structKeyList(strMonthTotalSales)>
					<cfset lstMonthTotalGrossProfit = structKeyList(strMonthTotalGrossProfit)>
				
					<cfloop from="#BeginningDate#" to="#EndingDate#" step="1" index="CurrentDate">
						<cfset FormattedDate = mid(CurrentDate, 5, 2) & "/" & mid(CurrentDate, 7, 2) & "/" & mid(CurrentDate, 1, 4)>
						<!--- Skip Sat and Sun --->
						<cfif dayOfWeek(FormattedDate) NEQ 1 AND dayOfWeek(FormattedDate) NEQ 7>
							<tr>
								<td style="font-size:10px" valign="top">#int(mid(CurrentDate, 7, 2))#-#MonthAbbrev#</td>
								<cfloop query="Arguments.qrySalesReps">
									<cfif Arguments.qrySalesReps.Active EQ 1 AND trim(Arguments.qrySalesReps.CODESLSP) IS NOT "">
				
										<cfif dateCompare(FormattedDate, Yesterday) EQ 1>
											<!--- SALES --->
											<td align="right" style="font-size:10px" valign="top">&nbsp;</td>
											<!--- G.P. --->
											<td align="right" style="font-size:10px" valign="top">&nbsp;</td>
										<cfelse>
                                        
											<cfset TotalSales = 0>
											<cfset GrossProfit = 0>

                                            <cfquery datasource="#This.WWWDataSourceName#" name="qrySalesHistory">
                                            SELECT	Sales,GrossProfit
                                            FROM	tblSalesHistory
                                            WHERE 	DateOfSale = '#CurrentDate#' AND
                                            		CODESLSP = '#Arguments.qrySalesReps.CODESLSP#'
                                            </cfquery>		
                                            
                                            <cfif qrySalesHistory.RecordCount NEQ 0>
                                            	<cfset TotalSales = qrySalesHistory.Sales>
												<cfset GrossProfit = qrySalesHistory.GrossProfit>
                                            </cfif>
					
											<!--- SALES --->
											<td align="right" style="font-size:10px" valign="top">#int(TotalSales)#</td>
											<!--- G.P. --->
											<td align="right" style="font-size:10px" valign="top">#int(GrossProfit)#</td>
											
											<cfloop list="#lstMonthTotalSales#" index="Column">
												<cfif Column IS trim(Arguments.qrySalesReps.CODESLSP)>
													<cfset CurrentAmount = strMonthTotalSales[Column]>
													<cfset structDelete(strMonthTotalSales, Column)>
													<cfbreak>
												</cfif>
											</cfloop>
											<cfset structInsert(strMonthTotalSales, trim(Arguments.qrySalesReps.CODESLSP), (CurrentAmount + TotalSales), True)>
				
											<cfloop list="#lstMonthTotalGrossProfit#" index="Column">
												<cfif Column IS trim(Arguments.qrySalesReps.CODESLSP)>
													<cfset CurrentAmount = strMonthTotalGrossProfit[Column]>
													<cfset structDelete(strMonthTotalGrossProfit, Column)>
													<cfbreak>
												</cfif>
											</cfloop>
											<cfset structInsert(strMonthTotalGrossProfit, trim(Arguments.qrySalesReps.CODESLSP), (CurrentAmount + GrossProfit), True)>
					
										</cfif>
									</cfif>
								</cfloop>
							</tr>
				
						</cfif>
					</cfloop>
				
					<!--- TOTALS --->
					<cfset lstMonthTotalSales = structKeyList(strMonthTotalSales)>
					<cfset lstMonthTotalGrossProfit = structKeyList(strMonthTotalGrossProfit)>
				
					<tr>
<!---					<td height="18" bgcolor="006633" style="font-size:10px; font-weight:bold; color:FFFFFF">TOTAL</td>	--->
						<td height="18" style="font-size:10px; font-weight:bold;">TOTAL</td>
						<cfloop query="Arguments.qrySalesReps">
							<cfif Arguments.qrySalesReps.Active EQ 1 AND trim(Arguments.qrySalesReps.CODESLSP) IS NOT "">
								<cfloop list="#lstMonthTotalSales#" index="Column">
									<cfif Column IS trim(Arguments.qrySalesReps.CODESLSP)>
										<cfset MonthlySalesTotalAmount = strMonthTotalSales[Column]>
										<cfbreak>
									</cfif>
								</cfloop>
								<cfloop list="#lstMonthTotalGrossProfit#" index="Column">
									<cfif Column IS trim(Arguments.qrySalesReps.CODESLSP)>
										<cfset MonthlyGrossProfitTotalAmount = strMonthTotalGrossProfit[Column]>
										<cfbreak>
									</cfif>
								</cfloop>
								
<!---							<td align="right" height="18" bgcolor="006633" style="font-size:10px; font-weight:bold; color:FFFFFF">	--->
								<td align="right" height="18" style="font-size:10px; font-weight:bold;">
									#int(MonthlySalesTotalAmount)#
								</td>
<!---							<td align="right" height="18" bgcolor="006633" style="font-size:10px; font-weight:bold; color:FFFFFF">	--->
								<td align="right" height="18" style="font-size:10px; font-weight:bold;">
									#int(MonthlyGrossProfitTotalAmount)#
								</td>
							</cfif>
						</cfloop>
					</tr>
					
				</table>
			</cfoutput>
		</cfsavecontent>

		<cfreturn EmailText>
	</cffunction>
        
	<!---------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="getmonthToDateSales" access="public" returntype="string" output="No">
	<cfargument name="qrySalesReps" type="query" required="Yes">
		<cfset var EmailText = "">
		<cfset var BeginningDate = "">
		<cfset var EndingDate = "">
		<cfset var MonthAbbrev = "">
<!---	<cfset var qrySalesReps = structNew()>	--->
		<cfset var strMonthTotalSales = structNew()>
		<cfset var strMonthTotalGrossProfit = structNew()>
		<cfset var lstMonthTotalSales = "">
		<cfset var lstMonthTotalGrossProfit = "">
		<cfset var CurrentDate = "">
		<cfset var FormattedDate = "">
		<cfset var qrySales = queryNew("")>
		<cfset var qryCredits = queryNew("")>
		<cfset var TotalSales = 0>
		<cfset var TotalCost = 0>
		<cfset var GrossProfit = 0>
		<cfset var CurrentAmount = 0>
		<cfset var MonthlySalesTotalAmount = 0>
		<cfset var MonthlyGrossProfitTotalAmount = 0>
		<cfset var Yesterday = "">
        <cfset var NewTotalItemCost = "">

<!---	<cfset var qryOEINVD = queryNew("")>	--->
<!---	<cfset var TotalItemCost = 0>	--->
<!---	<cfset var qryICILOC = queryNew("")>	--->
<!---	<cfset var qryOECRDD = queryNew("")>	--->
				
<!---	<cfset qrySalesReps = Arguments.qrySalesReps>	--->

		<cfset Yesterday = dateAdd('d', -1, now())>

		<cfset BeginningDate = year(Yesterday) & dateFormat(Yesterday, 'mm') & "01">
		<cfset EndingDate = BeginningDate + daysInMonth(Yesterday) - 1>
		<cfset MonthAbbrev = dateFormat(Yesterday, 'mmm')>
        

<!--- TEMP RAB --->        
<!---
<cfset BeginningDate = "20100501">		
<cfset EndingDate = "20100531">
<cfset MonthAbbrev = "May">	   
--->
		<cfsavecontent variable="EmailText">
			<cfoutput>
				<table width="100%" align="center" border="1" cellpadding="0" cellspacing="0">
					<tr>
						<td colspan="30">
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td height="18" style="font-size:14px; font-weight:bold;" width="50%">
										Month to Date Sales Report 
									</td>
									<td height="18" style="font-size:14px; font-weight:bold;" align="right">
										Report Date: #dateFormat(now(), 'mmmm d, yyyy')#
									</td>
								</tr>
							</table>								
						</td>
					</tr>
					
					<!--- Header --->
					<tr>
<!---					<td height="18" bgcolor="006633" style="font-size:10px; font-weight:bold; color:FFFFFF">Date</td>	--->
						<td height="18" style="font-size:10px; font-weight:bold;">Date</td>
						<cfloop query="Arguments.qrySalesReps">
							<cfif Arguments.qrySalesReps.Active EQ 1 AND trim(Arguments.qrySalesReps.CODESLSP) IS NOT "">
<!---							<td align="center" colspan="2" height="18" bgcolor="006633" style="font-size:10px; font-weight:bold; color:FFFFFF">	--->
								<td align="center" colspan="2" height="18" style="font-size:10px; font-weight:bold;">
									#Arguments.qrySalesReps.fname# #Arguments.qrySalesReps.lname#
								</td>
							</cfif>
						</cfloop>
					</tr>
					<tr>
<!---					<td height="18" bgcolor="006633" style="font-size:10px; font-weight:bold; color:FFFFFF">&nbsp;</td>	--->
						<td height="18" style="font-size:10px; font-weight:bold;">&nbsp;</td>
						<cfloop query="Arguments.qrySalesReps">
							<cfif Arguments.qrySalesReps.Active EQ 1 AND trim(Arguments.qrySalesReps.CODESLSP) IS NOT "">
<!---							<td align="center" height="18" bgcolor="006633" style="font-size:10px; font-weight:bold; color:FFFFFF">Sales</td>	--->
								<td align="center" height="18" style="font-size:10px; font-weight:bold;">Sales</td>
<!---							<td align="center" height="18" bgcolor="006633" style="font-size:10px; font-weight:bold; color:FFFFFF">G.P.</td>	--->
								<td align="center" height="18" style="font-size:10px; font-weight:bold;">G.P.</td>
							</cfif>
						</cfloop>
					</tr>
				
					<cfset strMonthTotalSales = structNew()>
					<cfset strMonthTotalGrossProfit = structNew()>
					
					<cfloop query="Arguments.qrySalesReps">
						<cfif Arguments.qrySalesReps.Active EQ 1 AND trim(Arguments.qrySalesReps.CODESLSP) IS NOT "">
							<cfset structInsert(strMonthTotalSales, trim(Arguments.qrySalesReps.CODESLSP), 0, True)>
							<cfset structInsert(strMonthTotalGrossProfit, trim(Arguments.qrySalesReps.CODESLSP), 0, True)>
						</cfif>
					</cfloop>
				
					<cfset lstMonthTotalSales = structKeyList(strMonthTotalSales)>
					<cfset lstMonthTotalGrossProfit = structKeyList(strMonthTotalGrossProfit)>
				
					<cfloop from="#BeginningDate#" to="#EndingDate#" step="1" index="CurrentDate">
						<cfset FormattedDate = mid(CurrentDate, 5, 2) & "/" & mid(CurrentDate, 7, 2) & "/" & mid(CurrentDate, 1, 4)>
						<!--- Skip Sat and Sun --->
						<cfif dayOfWeek(FormattedDate) NEQ 1 AND dayOfWeek(FormattedDate) NEQ 7>
							<tr>
								<td style="font-size:10px" valign="top">#int(mid(CurrentDate, 7, 2))#-#MonthAbbrev#</td>
								<cfloop query="Arguments.qrySalesReps">
									<cfif Arguments.qrySalesReps.Active EQ 1 AND trim(Arguments.qrySalesReps.CODESLSP) IS NOT "">
				
<!---									<cfif dateCompare(FormattedDate, now()) EQ 1>	--->
										<cfif dateCompare(FormattedDate, Yesterday) EQ 1>
											<!--- SALES --->
											<td align="right" style="font-size:10px" valign="top">&nbsp;</td>
											<!--- G.P. --->
											<td align="right" style="font-size:10px" valign="top">&nbsp;</td>
										<cfelse>
											<!--- SALES --->
											<cfquery datasource="NorTechAP" name="qrySales">
											SELECT	dbo.OEINVH.INVUNIQ,
													(SELECT	SUM(dbo.OEINVD.QtyShipped * dbo.OEINVD.UnitPrice)
													 FROM   dbo.OEINVD
													 WHERE  dbo.OEINVH.INVUNIQ = dbo.OEINVD.INVUNIQ) AS TotalItemSales
<!---                                                     
                                                     ,
													(SELECT	SUM(dbo.OEINVD.QtyShipped * dbo.OEINVD.UnitCost)
													 FROM   dbo.OEINVD
													 WHERE  dbo.OEINVH.INVUNIQ = dbo.OEINVD.INVUNIQ) AS TotalItemCost
--->                                                     
											FROM	dbo.OEINVH
													INNER JOIN dbo.ARCUS ON dbo.OEINVH.CUSTOMER = dbo.ARCUS.IDCUST 
													INNER JOIN dbo.ARSAP ON dbo.ARCUS.CODESLSP1 = dbo.ARSAP.CODESLSP
											WHERE	dbo.OEINVH.INVDATE = '#CurrentDate#' AND
													dbo.ARSAP.CODESLSP = '#Arguments.qrySalesReps.CODESLSP#'
											</cfquery>
											<!--- CREDITS --->
											<cfquery datasource="NorTechAP" name="qryCredits">
											SELECT	dbo.OECRDH.CRDUNIQ,
													(SELECT	SUM(dbo.OECRDD.QTYRETURN * dbo.OECRDD.UnitPrice)
													 FROM   dbo.OECRDD
													 WHERE  dbo.OECRDH.CRDUNIQ = dbo.OECRDD.CRDUNIQ) AS TotalItemSales,
													(SELECT	SUM(dbo.OECRDD.QTYRETURN * dbo.OECRDD.UnitCost)
													 FROM   dbo.OECRDD
													 WHERE  dbo.OECRDH.CRDUNIQ = dbo.OECRDD.CRDUNIQ) AS TotalItemCost
											FROM	dbo.OECRDH
													INNER JOIN dbo.ARCUS ON dbo.OECRDH.CUSTOMER = dbo.ARCUS.IDCUST 
													INNER JOIN dbo.ARSAP ON dbo.ARCUS.CODESLSP1 = dbo.ARSAP.CODESLSP
											WHERE	dbo.OECRDH.CRDDATE = '#CurrentDate#' AND
													dbo.ARSAP.CODESLSP = '#Arguments.qrySalesReps.CODESLSP#'
											</cfquery>
											
											<cfset TotalSales = 0>
											<cfset TotalCost = 0>
											<cfset GrossProfit = 0>
											
											<cfloop query="qrySales">
												<cfset TotalSales = TotalSales + qrySales.TotalItemSales>
<!---					
												<cfquery datasource="NorTechAP" name="qryOEINVD">
												SELECT	ITEM, QTYSHIPPED
												FROM    dbo.OEINVD
												WHERE   (INVUNIQ = '#qrySales.INVUNIQ#')
												ORDER BY LINENUM
												</cfquery>

												<cfset TotalItemCost = 0>
												<cfloop query="qryOEINVD">
													<cfif trim(qryOEINVD.ITEM) IS NOT "">
														<cfquery datasource="NorTechAP" name="qryICILOC">
														SELECT	TOTALCOST, QTYONHAND, LASTCOST, RECENTCOST
														FROM    dbo.ICILOC
														WHERE   (ITEMNO = '#qryOEINVD.ITEM#') AND (LOCATION = '1')
														</cfquery>
														<cfif qryICILOC.RecordCount GT 0>
															<!--- TOTALCOST/QTYONHAND, if QTYONHAND > 0 --->
															<cfif isNumeric(qryICILOC.TOTALCOST) AND isNumeric(qryICILOC.QTYONHAND) AND qryICILOC.QTYONHAND GT 0>
																<cfset TotalItemCost = TotalItemCost + qryOEINVD.QTYSHIPPED * (qryICILOC.TOTALCOST / qryICILOC.QTYONHAND)>
															<!--- Otherwise use LAST COST, if last cost is greater than zero --->
															<cfelseif isNumeric(qryICILOC.LASTCOST) AND qryICILOC.LASTCOST GT 0>
																<cfset TotalItemCost = TotalItemCost + qryOEINVD.QTYSHIPPED * qryICILOC.LASTCOST>
															<!--- Otherwise use RECENT COST --->
															<cfelse>
																<cfset TotalItemCost = TotalItemCost + qryOEINVD.QTYSHIPPED * qryICILOC.RECENTCOST>
															</cfif>
														</cfif>
													</cfif>
												</cfloop>
--->

												<cfset NewTotalItemCost = getTotalItemCost(qrySales.INVUNIQ)>
<!---											<cfset TotalCost = TotalCost + qrySales.TotalItemCost>	--->
												<cfset TotalCost = TotalCost + NewTotalItemCost>
											</cfloop>
											
											
											<cfloop query="qryCredits">
												<cfset TotalSales = TotalSales - qryCredits.TotalItemSales>

<!---
												<cfquery datasource="NorTechAP" name="qryOECRDD">
												SELECT	ITEM, QTYRETURN
												FROM    dbo.OECRDD
												WHERE   (CRDUNIQ = '#qryCredits.CRDUNIQ#')
												ORDER BY LINENUM
												</cfquery>
												
												<cfset TotalItemCost = 0>
												<cfloop query="qryOECRDD">
													<cfif trim(qryOECRDD.ITEM) IS NOT "">
														<cfquery datasource="NorTechAP" name="qryICILOC">
														SELECT	TOTALCOST, QTYONHAND, LASTCOST, RECENTCOST
														FROM    dbo.ICILOC
														WHERE   (ITEMNO = '#qryOECRDD.ITEM#') AND (LOCATION = '1')
														</cfquery>
														<cfif qryICILOC.RecordCount GT 0>
															<!--- TOTALCOST/QTYONHAND, if QTYONHAND > 0 --->
															<cfif isNumeric(qryICILOC.TOTALCOST) AND isNumeric(qryICILOC.QTYONHAND) AND qryICILOC.QTYONHAND GT 0>
																<cfset TotalItemCost = TotalItemCost + qryOECRDD.QTYRETURN * (qryICILOC.TOTALCOST / qryICILOC.QTYONHAND)>
															<!--- Otherwise use LAST COST, if last cost is greater than zero --->
															<cfelseif isNumeric(qryICILOC.LASTCOST) AND qryICILOC.LASTCOST GT 0>
																<cfset TotalItemCost = TotalItemCost + qryOECRDD.QTYRETURN * qryICILOC.LASTCOST>
															<!--- Otherwise use RECENT COST --->
															<cfelse>
																<cfset TotalItemCost = TotalItemCost + qryOECRDD.QTYRETURN * qryICILOC.RECENTCOST>
															</cfif>
														</cfif>
													</cfif>
												</cfloop>
--->
																			
												<cfset TotalCost = TotalCost - qryCredits.TotalItemCost>
											</cfloop>
											
											<cfset GrossProfit = TotalSales - TotalCost>
					
											<!--- SALES --->
											<td align="right" style="font-size:10px" valign="top">#int(TotalSales)#</td>
											<!--- G.P. --->
											<td align="right" style="font-size:10px" valign="top">#int(GrossProfit)#</td>
											
											<cfloop list="#lstMonthTotalSales#" index="Column">
												<cfif Column IS trim(Arguments.qrySalesReps.CODESLSP)>
													<cfset CurrentAmount = strMonthTotalSales[Column]>
													<cfset structDelete(strMonthTotalSales, Column)>
													<cfbreak>
												</cfif>
											</cfloop>
											<cfset structInsert(strMonthTotalSales, trim(Arguments.qrySalesReps.CODESLSP), (CurrentAmount + TotalSales), True)>
				
											<cfloop list="#lstMonthTotalGrossProfit#" index="Column">
												<cfif Column IS trim(Arguments.qrySalesReps.CODESLSP)>
													<cfset CurrentAmount = strMonthTotalGrossProfit[Column]>
													<cfset structDelete(strMonthTotalGrossProfit, Column)>
													<cfbreak>
												</cfif>
											</cfloop>
											<cfset structInsert(strMonthTotalGrossProfit, trim(Arguments.qrySalesReps.CODESLSP), (CurrentAmount + GrossProfit), True)>
					
										</cfif>
									</cfif>
								</cfloop>
							</tr>
				
						</cfif>
					</cfloop>
				
					<!--- TOTALS --->
					<cfset lstMonthTotalSales = structKeyList(strMonthTotalSales)>
					<cfset lstMonthTotalGrossProfit = structKeyList(strMonthTotalGrossProfit)>
				
					<tr>
<!---					<td height="18" bgcolor="006633" style="font-size:10px; font-weight:bold; color:FFFFFF">TOTAL</td>	--->
						<td height="18" style="font-size:10px; font-weight:bold;">TOTAL</td>
						<cfloop query="Arguments.qrySalesReps">
							<cfif Arguments.qrySalesReps.Active EQ 1 AND trim(Arguments.qrySalesReps.CODESLSP) IS NOT "">
								<cfloop list="#lstMonthTotalSales#" index="Column">
									<cfif Column IS trim(Arguments.qrySalesReps.CODESLSP)>
										<cfset MonthlySalesTotalAmount = strMonthTotalSales[Column]>
										<cfbreak>
									</cfif>
								</cfloop>
								<cfloop list="#lstMonthTotalGrossProfit#" index="Column">
									<cfif Column IS trim(Arguments.qrySalesReps.CODESLSP)>
										<cfset MonthlyGrossProfitTotalAmount = strMonthTotalGrossProfit[Column]>
										<cfbreak>
									</cfif>
								</cfloop>
								
<!---							<td align="right" height="18" bgcolor="006633" style="font-size:10px; font-weight:bold; color:FFFFFF">	--->
								<td align="right" height="18" style="font-size:10px; font-weight:bold;">
									#int(MonthlySalesTotalAmount)#
								</td>
<!---							<td align="right" height="18" bgcolor="006633" style="font-size:10px; font-weight:bold; color:FFFFFF">	--->
								<td align="right" height="18" style="font-size:10px; font-weight:bold;">
									#int(MonthlyGrossProfitTotalAmount)#
								</td>
							</cfif>
						</cfloop>
					</tr>
					
				</table>
			</cfoutput>
		</cfsavecontent>

		<cfreturn EmailText>
	</cffunction>

	<!---------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="monthToDateSalesTotals" access="public" output="no">
		<cfset objAdmin = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.Admin")>

		<!--- get a query of all sales reps --->
		<cfset qrySalesReps = objAdmin.listSalesReps011516()>
		
		<cfset EmailText = getmonthToDateSalesTotals_NEW(qrySalesReps)>
		<cfif EmailText IS NOT "">

			<cfset ToAddress = "davidb@nor-tech.com">	

<!--- TEMP RAB --->
<!---
<cfset ToAddress = "ron_barth@altsystem.com">
--->
            <cfif findNoCase("@", ToAddress) NEQ 0 AND findNoCase(".", ToAddress) NEQ 0>
                <cfmail from=	"info@nor-tech.com"		
                        to=		"#ToAddress#"
                        subject="Month to Date Sales Totals Report"
                        
                        
                        type="html">
                    <html>
                    <head><style type="text/css">BODY {font-family: Verdana, Arial, Helvetica, sans-serif;}</style></head>
                    <body>
                    #EmailText#
                    </body>
                    </html>	
                </cfmail>
            </cfif>
		</cfif>
	</cffunction>	

	<!---------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="getmonthToDateSalesTotals_NEW" access="public" returntype="string" output="No">
	<cfargument name="qrySalesReps" type="query" required="Yes">
		<cfset var EmailText = "">
		<cfset var BeginningDate = "">
		<cfset var EndingDate = "">
		<cfset var MonthAbbrev = "">
		<cfset var strMonthTotalSales = structNew()>
		<cfset var strMonthTotalGrossProfit = structNew()>
		<cfset var lstMonthTotalSales = "">
		<cfset var lstMonthTotalGrossProfit = "">
		<cfset var CurrentDate = "">
		<cfset var FormattedDate = "">
		<cfset var TotalSales = 0>
		<cfset var TotalCost = 0>
		<cfset var GrossProfit = 0>
		<cfset var CurrentAmount = 0>
		<cfset var MonthlySalesTotalAmount = 0>
		<cfset var MonthlyGrossProfitTotalAmount = 0>
		<cfset var Yesterday = "">
        <cfset var NewTotalItemCost = "">
        <cfset var qrySalesHistory = queryNew("")>

		<cfset Yesterday = dateAdd('d', -1, now())>

		<cfset BeginningDate = year(Yesterday) & dateFormat(Yesterday, 'mm') & "01">
		<cfset EndingDate = BeginningDate + daysInMonth(Yesterday) - 1>
		<cfset MonthAbbrev = dateFormat(Yesterday, 'mmm')>

<!--- TEMP RAB --->
<!---
<cfset BeginningDate = "20100501">		
<cfset EndingDate = "20100531">			
<cfset MonthAbbrev = "May">				
--->
		<cfsavecontent variable="EmailText">
			<cfoutput>
				<table width="65%" align="center" border="1" cellpadding="1" cellspacing="1">
					<tr>
						<td colspan="3">
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td height="18" style="font-size:14px; font-weight:bold;">
										Month to Date Sales Report - Totals 
									</td>
                             	</tr>
                                <tr>
									<td height="18" style="font-size:14px; font-weight:bold;">
										Report Date: #dateFormat(now(), 'mmmm d, yyyy')#
									</td>
								</tr>
							</table>								
						</td>
					</tr>
					
					<!--- Header --->
					<tr>
						<td height="18" style="font-size:10px; font-weight:bold;">Date</td>
						<td align="center" height="18" style="font-size:10px; font-weight:bold;">Sales</td>
						<td align="center" height="18" style="font-size:10px; font-weight:bold;">G.P.</td>
					</tr>
				
					<cfset strMonthTotalSales = structNew()>
					<cfset strMonthTotalGrossProfit = structNew()>
					
					<cfloop query="Arguments.qrySalesReps">
						<cfif Arguments.qrySalesReps.Active EQ 1 AND trim(Arguments.qrySalesReps.CODESLSP) IS NOT "">
							<cfset structInsert(strMonthTotalSales, trim(Arguments.qrySalesReps.CODESLSP), 0, True)>
							<cfset structInsert(strMonthTotalGrossProfit, trim(Arguments.qrySalesReps.CODESLSP), 0, True)>
						</cfif>
					</cfloop>
				
					<cfset lstMonthTotalSales = structKeyList(strMonthTotalSales)>
					<cfset lstMonthTotalGrossProfit = structKeyList(strMonthTotalGrossProfit)>
				
					<cfloop from="#BeginningDate#" to="#EndingDate#" step="1" index="CurrentDate">
						<cfset FormattedDate = mid(CurrentDate, 5, 2) & "/" & mid(CurrentDate, 7, 2) & "/" & mid(CurrentDate, 1, 4)>
						<!--- Skip Sat and Sun --->
						<cfif dayOfWeek(FormattedDate) NEQ 1 AND dayOfWeek(FormattedDate) NEQ 7>
							<tr>
								<td style="font-size:10px" valign="top">#int(mid(CurrentDate, 7, 2))#-#MonthAbbrev#</td>

								<cfset TotalSRSales = 0>
                                <cfset TotalSRGrossProfit = 0>

								<cfloop query="Arguments.qrySalesReps">
									<cfif Arguments.qrySalesReps.Active EQ 1 AND trim(Arguments.qrySalesReps.CODESLSP) IS NOT "">
										<cfif dateCompare(FormattedDate, Yesterday) EQ 1>
<!---
											<!--- SALES --->
											<td align="right" style="font-size:10px" valign="top">&nbsp;</td>
											<!--- G.P. --->
											<td align="right" style="font-size:10px" valign="top">&nbsp;</td>
--->
										<cfelse>
											
											<cfset TotalSales = 0>
											<cfset GrossProfit = 0>
                                            
                                            <cfquery datasource="#This.WWWDataSourceName#" name="qrySalesHistory">
                                            SELECT	Sales,GrossProfit
                                            FROM	tblSalesHistory
                                            WHERE 	DateOfSale = '#CurrentDate#' AND
                                            		CODESLSP = '#Arguments.qrySalesReps.CODESLSP#'
                                            </cfquery>		

                                            <cfif qrySalesHistory.RecordCount NEQ 0>
                                            	<cfset TotalSales = qrySalesHistory.Sales>
												<cfset GrossProfit = qrySalesHistory.GrossProfit>
                                            </cfif>

                    						<cfset TotalSRSales = TotalSRSales + TotalSales>
                    						<cfset TotalSRGrossProfit = TotalSRGrossProfit + GrossProfit>

											<cfloop list="#lstMonthTotalSales#" index="Column">
												<cfif Column IS trim(Arguments.qrySalesReps.CODESLSP)>
													<cfset CurrentAmount = strMonthTotalSales[Column]>
													<cfset structDelete(strMonthTotalSales, Column)>
													<cfbreak>
												</cfif>
											</cfloop>
											<cfset structInsert(strMonthTotalSales, trim(Arguments.qrySalesReps.CODESLSP), (CurrentAmount + TotalSales), True)>
				
											<cfloop list="#lstMonthTotalGrossProfit#" index="Column">
												<cfif Column IS trim(Arguments.qrySalesReps.CODESLSP)>
													<cfset CurrentAmount = strMonthTotalGrossProfit[Column]>
													<cfset structDelete(strMonthTotalGrossProfit, Column)>
													<cfbreak>
												</cfif>
											</cfloop>
											<cfset structInsert(strMonthTotalGrossProfit, trim(Arguments.qrySalesReps.CODESLSP), (CurrentAmount + GrossProfit), True)>
					
										</cfif>
									</cfif>
								</cfloop>
                                
								<!--- SALES --->
                                <td align="right" style="font-size:10px" valign="top">#int(TotalSRSales)#</td>
                                <!--- G.P. --->
                                <td align="right" style="font-size:10px" valign="top">#int(TotalSRGrossProfit)#</td>
                                
							</tr>
				
						</cfif>
					</cfloop>
				
					<!--- TOTALS --->
					<cfset lstMonthTotalSales = structKeyList(strMonthTotalSales)>
					<cfset lstMonthTotalGrossProfit = structKeyList(strMonthTotalGrossProfit)>
				
					<tr>
						<td height="18" style="font-size:10px; font-weight:bold;">TOTAL</td>
                        
                        <cfset TTMonthlySalesTotalAmount = 0>
                        <cfset TTMonthlyGrossProfitTotalAmount = 0>
                        
						<cfloop query="Arguments.qrySalesReps">
							<cfif Arguments.qrySalesReps.Active EQ 1 AND trim(Arguments.qrySalesReps.CODESLSP) IS NOT "">
								<cfloop list="#lstMonthTotalSales#" index="Column">
									<cfif Column IS trim(Arguments.qrySalesReps.CODESLSP)>
										<cfset MonthlySalesTotalAmount = strMonthTotalSales[Column]>
										<cfbreak>
									</cfif>
								</cfloop>
								<cfloop list="#lstMonthTotalGrossProfit#" index="Column">
									<cfif Column IS trim(Arguments.qrySalesReps.CODESLSP)>
										<cfset MonthlyGrossProfitTotalAmount = strMonthTotalGrossProfit[Column]>
										<cfbreak>
									</cfif>
								</cfloop>

        		                <cfset TTMonthlySalesTotalAmount = TTMonthlySalesTotalAmount + MonthlySalesTotalAmount>
      			               	<cfset TTMonthlyGrossProfitTotalAmount = TTMonthlyGrossProfitTotalAmount + MonthlyGrossProfitTotalAmount>
<!---
								<td align="right" height="18" style="font-size:10px; font-weight:bold;">
									#int(MonthlySalesTotalAmount)#
								</td>
								<td align="right" height="18" style="font-size:10px; font-weight:bold;">
									#int(MonthlyGrossProfitTotalAmount)#
								</td>
--->
							</cfif>
						</cfloop>
                        <td align="right" height="18" style="font-size:10px; font-weight:bold;">
                            #int(TTMonthlySalesTotalAmount)#
                        </td>
                        <td align="right" height="18" style="font-size:10px; font-weight:bold;">
                            #int(TTMonthlyGrossProfitTotalAmount)#
                        </td>
					</tr>
					
				</table>
			</cfoutput>
		</cfsavecontent>

		<cfreturn EmailText>
	</cffunction>

	<!---------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="getmonthToDateSalesTotals" access="public" returntype="string" output="No">
	<cfargument name="qrySalesReps" type="query" required="Yes">
		<cfset var EmailText = "">
		<cfset var BeginningDate = "">
		<cfset var EndingDate = "">
		<cfset var MonthAbbrev = "">
<!---	<cfset var qrySalesReps = structNew()>	--->
		<cfset var strMonthTotalSales = structNew()>
		<cfset var strMonthTotalGrossProfit = structNew()>
		<cfset var lstMonthTotalSales = "">
		<cfset var lstMonthTotalGrossProfit = "">
		<cfset var CurrentDate = "">
		<cfset var FormattedDate = "">
		<cfset var qrySales = queryNew("")>
		<cfset var qryCredits = queryNew("")>
		<cfset var TotalSales = 0>
		<cfset var TotalCost = 0>
		<cfset var GrossProfit = 0>
		<cfset var CurrentAmount = 0>
		<cfset var MonthlySalesTotalAmount = 0>
		<cfset var MonthlyGrossProfitTotalAmount = 0>
		<cfset var Yesterday = "">
        <cfset var NewTotalItemCost = "">

		<cfset Yesterday = dateAdd('d', -1, now())>

		<cfset BeginningDate = year(Yesterday) & dateFormat(Yesterday, 'mm') & "01">
		<cfset EndingDate = BeginningDate + daysInMonth(Yesterday) - 1>
		<cfset MonthAbbrev = dateFormat(Yesterday, 'mmm')>

<!--- TEMP RAB --->
<!---
<cfset BeginningDate = "20100501">		
<cfset EndingDate = "20100531">			
<cfset MonthAbbrev = "May">				
--->
		<cfsavecontent variable="EmailText">
			<cfoutput>
				<table width="65%" align="center" border="1" cellpadding="1" cellspacing="1">
					<tr>
						<td colspan="3">
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td height="18" style="font-size:14px; font-weight:bold;">
										Month to Date Sales Report - Totals 
									</td>
                             	</tr>
                                <tr>
									<td height="18" style="font-size:14px; font-weight:bold;">
										Report Date: #dateFormat(now(), 'mmmm d, yyyy')#
									</td>
								</tr>
							</table>								
						</td>
					</tr>
					
					<!--- Header --->
					<tr>
						<td height="18" style="font-size:10px; font-weight:bold;">Date</td>
						<td align="center" height="18" style="font-size:10px; font-weight:bold;">Sales</td>
						<td align="center" height="18" style="font-size:10px; font-weight:bold;">G.P.</td>
					</tr>
				
					<cfset strMonthTotalSales = structNew()>
					<cfset strMonthTotalGrossProfit = structNew()>
					
					<cfloop query="Arguments.qrySalesReps">
						<cfif Arguments.qrySalesReps.Active EQ 1 AND trim(Arguments.qrySalesReps.CODESLSP) IS NOT "">
							<cfset structInsert(strMonthTotalSales, trim(Arguments.qrySalesReps.CODESLSP), 0, True)>
							<cfset structInsert(strMonthTotalGrossProfit, trim(Arguments.qrySalesReps.CODESLSP), 0, True)>
						</cfif>
					</cfloop>
				
					<cfset lstMonthTotalSales = structKeyList(strMonthTotalSales)>
					<cfset lstMonthTotalGrossProfit = structKeyList(strMonthTotalGrossProfit)>
				
					<cfloop from="#BeginningDate#" to="#EndingDate#" step="1" index="CurrentDate">
						<cfset FormattedDate = mid(CurrentDate, 5, 2) & "/" & mid(CurrentDate, 7, 2) & "/" & mid(CurrentDate, 1, 4)>
						<!--- Skip Sat and Sun --->
						<cfif dayOfWeek(FormattedDate) NEQ 1 AND dayOfWeek(FormattedDate) NEQ 7>
							<tr>
								<td style="font-size:10px" valign="top">#int(mid(CurrentDate, 7, 2))#-#MonthAbbrev#</td>

								<cfset TotalSRSales = 0>
                                <cfset TotalSRGrossProfit = 0>

								<cfloop query="Arguments.qrySalesReps">
									<cfif Arguments.qrySalesReps.Active EQ 1 AND trim(Arguments.qrySalesReps.CODESLSP) IS NOT "">
										<cfif dateCompare(FormattedDate, Yesterday) EQ 1>
<!---
											<!--- SALES --->
											<td align="right" style="font-size:10px" valign="top">&nbsp;</td>
											<!--- G.P. --->
											<td align="right" style="font-size:10px" valign="top">&nbsp;</td>
--->
										<cfelse>
                                        
											<!--- SALES --->
											<cfquery datasource="NorTechAP" name="qrySales">
											SELECT	dbo.OEINVH.INVUNIQ,
													(SELECT	SUM(dbo.OEINVD.QtyShipped * dbo.OEINVD.UnitPrice)
													 FROM   dbo.OEINVD
													 WHERE  dbo.OEINVH.INVUNIQ = dbo.OEINVD.INVUNIQ) AS TotalItemSales
<!---                                                     
                                                     ,
													(SELECT	SUM(dbo.OEINVD.QtyShipped * dbo.OEINVD.UnitCost)
													 FROM   dbo.OEINVD
													 WHERE  dbo.OEINVH.INVUNIQ = dbo.OEINVD.INVUNIQ) AS TotalItemCost
--->                                                     
											FROM	dbo.OEINVH
													INNER JOIN dbo.ARCUS ON dbo.OEINVH.CUSTOMER = dbo.ARCUS.IDCUST 
													INNER JOIN dbo.ARSAP ON dbo.ARCUS.CODESLSP1 = dbo.ARSAP.CODESLSP
											WHERE	dbo.OEINVH.INVDATE = '#CurrentDate#' AND
													dbo.ARSAP.CODESLSP = '#Arguments.qrySalesReps.CODESLSP#'
											</cfquery>
											<!--- CREDITS --->
											<cfquery datasource="NorTechAP" name="qryCredits">
											SELECT	dbo.OECRDH.CRDUNIQ,
													(SELECT	SUM(dbo.OECRDD.QTYRETURN * dbo.OECRDD.UnitPrice)
													 FROM   dbo.OECRDD
													 WHERE  dbo.OECRDH.CRDUNIQ = dbo.OECRDD.CRDUNIQ) AS TotalItemSales,
													(SELECT	SUM(dbo.OECRDD.QTYRETURN * dbo.OECRDD.UnitCost)
													 FROM   dbo.OECRDD
													 WHERE  dbo.OECRDH.CRDUNIQ = dbo.OECRDD.CRDUNIQ) AS TotalItemCost
											FROM	dbo.OECRDH
													INNER JOIN dbo.ARCUS ON dbo.OECRDH.CUSTOMER = dbo.ARCUS.IDCUST 
													INNER JOIN dbo.ARSAP ON dbo.ARCUS.CODESLSP1 = dbo.ARSAP.CODESLSP
											WHERE	dbo.OECRDH.CRDDATE = '#CurrentDate#' AND
													dbo.ARSAP.CODESLSP = '#Arguments.qrySalesReps.CODESLSP#'
											</cfquery>
											
											<cfset TotalSales = 0>
											<cfset TotalCost = 0>
											<cfset GrossProfit = 0>
											
											<cfloop query="qrySales">
												<cfset TotalSales = TotalSales + qrySales.TotalItemSales>
                                                
												<cfset NewTotalItemCost = getTotalItemCost(qrySales.INVUNIQ)>
<!---											<cfset TotalCost = TotalCost + qrySales.TotalItemCost>	--->
												<cfset TotalCost = TotalCost + NewTotalItemCost>
											</cfloop>
											
											<cfloop query="qryCredits">
												<cfset TotalSales = TotalSales - qryCredits.TotalItemSales>
												<cfset TotalCost = TotalCost - qryCredits.TotalItemCost>
											</cfloop>
											
											<cfset GrossProfit = TotalSales - TotalCost>
					
                    						<cfset TotalSRSales = TotalSRSales + TotalSales>
                    						<cfset TotalSRGrossProfit = TotalSRGrossProfit + GrossProfit>
<!---                    
											<!--- SALES --->
											<td align="right" style="font-size:10px" valign="top">#int(TotalSales)#</td>
											<!--- G.P. --->
											<td align="right" style="font-size:10px" valign="top">#int(GrossProfit)#</td>
--->											
											<cfloop list="#lstMonthTotalSales#" index="Column">
												<cfif Column IS trim(Arguments.qrySalesReps.CODESLSP)>
													<cfset CurrentAmount = strMonthTotalSales[Column]>
													<cfset structDelete(strMonthTotalSales, Column)>
													<cfbreak>
												</cfif>
											</cfloop>
											<cfset structInsert(strMonthTotalSales, trim(Arguments.qrySalesReps.CODESLSP), (CurrentAmount + TotalSales), True)>
				
											<cfloop list="#lstMonthTotalGrossProfit#" index="Column">
												<cfif Column IS trim(Arguments.qrySalesReps.CODESLSP)>
													<cfset CurrentAmount = strMonthTotalGrossProfit[Column]>
													<cfset structDelete(strMonthTotalGrossProfit, Column)>
													<cfbreak>
												</cfif>
											</cfloop>
											<cfset structInsert(strMonthTotalGrossProfit, trim(Arguments.qrySalesReps.CODESLSP), (CurrentAmount + GrossProfit), True)>
					
										</cfif>
									</cfif>
								</cfloop>
                                
								<!--- SALES --->
                                <td align="right" style="font-size:10px" valign="top">#int(TotalSRSales)#</td>
                                <!--- G.P. --->
                                <td align="right" style="font-size:10px" valign="top">#int(TotalSRGrossProfit)#</td>
                                
							</tr>
				
						</cfif>
					</cfloop>
				
					<!--- TOTALS --->
					<cfset lstMonthTotalSales = structKeyList(strMonthTotalSales)>
					<cfset lstMonthTotalGrossProfit = structKeyList(strMonthTotalGrossProfit)>
				
					<tr>
						<td height="18" style="font-size:10px; font-weight:bold;">TOTAL</td>
                        
                        <cfset TTMonthlySalesTotalAmount = 0>
                        <cfset TTMonthlyGrossProfitTotalAmount = 0>
                        
						<cfloop query="Arguments.qrySalesReps">
							<cfif Arguments.qrySalesReps.Active EQ 1 AND trim(Arguments.qrySalesReps.CODESLSP) IS NOT "">
								<cfloop list="#lstMonthTotalSales#" index="Column">
									<cfif Column IS trim(Arguments.qrySalesReps.CODESLSP)>
										<cfset MonthlySalesTotalAmount = strMonthTotalSales[Column]>
										<cfbreak>
									</cfif>
								</cfloop>
								<cfloop list="#lstMonthTotalGrossProfit#" index="Column">
									<cfif Column IS trim(Arguments.qrySalesReps.CODESLSP)>
										<cfset MonthlyGrossProfitTotalAmount = strMonthTotalGrossProfit[Column]>
										<cfbreak>
									</cfif>
								</cfloop>

        		                <cfset TTMonthlySalesTotalAmount = TTMonthlySalesTotalAmount + MonthlySalesTotalAmount>
      			               	<cfset TTMonthlyGrossProfitTotalAmount = TTMonthlyGrossProfitTotalAmount + MonthlyGrossProfitTotalAmount>
<!---
								<td align="right" height="18" style="font-size:10px; font-weight:bold;">
									#int(MonthlySalesTotalAmount)#
								</td>
								<td align="right" height="18" style="font-size:10px; font-weight:bold;">
									#int(MonthlyGrossProfitTotalAmount)#
								</td>
--->
							</cfif>
						</cfloop>
                        <td align="right" height="18" style="font-size:10px; font-weight:bold;">
                            #int(TTMonthlySalesTotalAmount)#
                        </td>
                        <td align="right" height="18" style="font-size:10px; font-weight:bold;">
                            #int(TTMonthlyGrossProfitTotalAmount)#
                        </td>
					</tr>
					
				</table>
			</cfoutput>
		</cfsavecontent>

		<cfreturn EmailText>
	</cffunction>	

	<!---------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="searchInvoices" access="public" returntype="query" output="no">
	<cfargument name="SearchRecord" type="struct" required="Yes">
    	<cfset var qryInvoices = queryNew("")>
		<cfset var SearchByItem = 0>
		<cfset var qryCompBuildItems = queryNew("")>
		<cfset objCompBuildItems = createObject("component", "#CURRENT_AdminLocation#.assets.cfcs.CompBuildItems")>

		<cfset qryCompBuildItems = objCompBuildItems.listRecords()>
		<cfif structKeyExists(Arguments.SearchRecord, "ITEM") OR 
			  structKeyExists(Arguments.SearchRecord, "DESC") OR 
			  structKeyExists(Arguments.SearchRecord, "SystemOrdersOnly")>
            <cfset SearchByItem = 1>
        </cfif>
        
        <cfif NOT structKeyExists(Arguments.SearchRecord, "NumberToDisplay")>
			<cfset Arguments.SearchRecord.NumberToDisplay = 20>
		</cfif>
        
        <cfquery datasource="NorTechAP" name="qryInvoices">
        SELECT	TOP #Arguments.SearchRecord.NumberToDisplay#
                dbo.OEINVH.INVUNIQ, dbo.OEINVH.INVNUMBER, dbo.OEINVH.CUSTOMER, dbo.OEINVH.BILNAME, dbo.OEINVH.INVDATE
                <cfif SearchByItem>
		          	,dbo.OEINVD.ITEM, dbo.OEINVD.[DESC]
    			</cfif>            
        FROM	dbo.OEINVH 
                <cfif SearchByItem>
         			INNER JOIN dbo.OEINVD ON dbo.OEINVD.INVUNIQ = dbo.OEINVH.INVUNIQ
				</cfif>
        WHERE	0=0
                <cfif structKeyExists(Arguments.SearchRecord, "CUSTOMER")>
                    AND dbo.OEINVH.CUSTOMER = '#trim(Arguments.SearchRecord.CUSTOMER)#'
                </cfif>
                <cfif structKeyExists(Arguments.SearchRecord, "BILNAME")>
                    AND dbo.OEINVH.BILNAME LIKE '%#trim(Arguments.SearchRecord.BILNAME)#%'
                </cfif>
                <cfif structKeyExists(Arguments.SearchRecord, "INVNUMBER")>
                    AND dbo.OEINVH.INVNUMBER = '#trim(Arguments.SearchRecord.INVNUMBER)#'
                </cfif>
                <cfif structKeyExists(Arguments.SearchRecord, "ITEM")>
                    AND dbo.OEINVD.ITEM LIKE '%#trim(Arguments.SearchRecord.ITEM)#%'
                </cfif>
                <cfif structKeyExists(Arguments.SearchRecord, "DESC")>
                    AND dbo.OEINVD.[DESC] LIKE '%#trim(Arguments.SearchRecord.DESC)#%'
                </cfif>
                <cfif structKeyExists(Arguments.SearchRecord, "SystemOrdersOnly")>
                    AND (
                        <cfloop query="qryCompBuildItems">
                            dbo.OEINVD.ITEM = '#trim(qryCompBuildItems.ITEMNO)#'
                            <cfif qryCompBuildItems.CurrentRow NEQ qryCompBuildItems.RecordCount>
                                OR
                            </cfif>
                        </cfloop>
                    )
                </cfif>
        ORDER BY dbo.OEINVH.INVDATE DESC, dbo.OEINVH.INVNUMBER ASC
        </cfquery>
        <cfreturn qryInvoices>
	</cffunction>
		
</cfcomponent>