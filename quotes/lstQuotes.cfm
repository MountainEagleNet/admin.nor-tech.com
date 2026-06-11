<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/31/2007
	Function: 		This page displays a list of parts
	Template:		lstQuotes.cfm
	Task:			quotes_list
--->
	<cfset objQuoteSystem = createObject("component", "admin.assets.cfcs.config.QuoteSystem")>
	<cfset Error = "">

	<cfparam name="URL.SortColumn" type="string" default="QuoteDate">
	<cfparam name="URL.SortOrder" type="string" default="Desc">

	<cfparam name="URL.qsr" default="1">
	<cfparam name="URL.qmr" default="50">


	<cfif isDefined("FORM.QuoteNumber")>
    	<cfset Variables.QuoteNumber = FORM.QuoteNumber>
	<cfelseif isDefined("URL.QuoteNumber")>
    	<cfset Variables.QuoteNumber = URL.QuoteNumber>
	<cfelse>
    	<cfset Variables.QuoteNumber = "">
    </cfif>

	<cfif isDefined("FORM.QuoteDate")>
    	<cfset Variables.QuoteDate = FORM.QuoteDate>
	<cfelseif isDefined("URL.QuoteDate")>
    	<cfset Variables.QuoteDate = URL.QuoteDate>
	<cfelse>
    	<cfset Variables.QuoteDate = "">
    </cfif>


	<cfif isDefined("FORM.CustomerNumber")>
    	<cfset Variables.CustomerNumber = FORM.CustomerNumber>
	<cfelseif isDefined("URL.CustomerNumber")>
    	<cfset Variables.CustomerNumber = URL.CustomerNumber>
	<cfelse>
    	<cfset Variables.CustomerNumber = "">
    </cfif>

	<cfif isDefined("FORM.CustomerName")>
    	<cfset Variables.CustomerName = FORM.CustomerName>
	<cfelseif isDefined("URL.CustomerName")>
    	<cfset Variables.CustomerName = URL.CustomerName>
	<cfelse>
    	<cfset Variables.CustomerName = "">
    </cfif>
	
	<cfif isDefined("FORM.ResellerPONumber")>
    	<cfset Variables.ResellerPONumber = FORM.ResellerPONumber>
	<cfelseif isDefined("URL.ResellerPONumber")>
    	<cfset Variables.ResellerPONumber = URL.ResellerPONumber>
	<cfelse>
    	<cfset Variables.ResellerPONumber = "">
    </cfif>

<!---
	<cfif isDefined("FORM.ProcessSearch")>
    	<cfset Variables.ProcessSearch = FORM.ProcessSearch>
	<cfelseif isDefined("URL.ProcessSearch")>
    	<cfset Variables.ProcessSearch = URL.ProcessSearch>
	<cfelse>
    	<cfset Variables.ProcessSearch = "">
    </cfif>
--->

	<!--- set the new sort order for display --->
	<cfif URL.SortOrder IS "Desc">
		<cfset Variables.NewSortOrder = "Asc">
	<cfelse>
		<cfset Variables.NewSortOrder = "Desc">
	</cfif>

	<cfset Variables.OrderByList = URL.SortColumn & " " & URL.SortOrder>

	<cfset SearchRecord = structNew()>
<!---
	<cfif isDefined("FORM.ProcessSearch") <!---AND isDefined("FORM.ITEMDESC") AND isDefined("FORM.InactiveStatus")--->>
--->    
    
		<cfif trim(Variables.QuoteNumber) IS NOT "">
			<cfset structInsert(SearchRecord, "QuoteNumber", Variables.QuoteNumber, True)>
		</cfif>
        
        
		<cfif trim(Variables.QuoteDate) IS NOT "">
			<cfset structInsert(SearchRecord, "QuoteDate", Variables.QuoteDate, True)>
		</cfif>
        
		<cfif trim(Variables.CustomerNumber) IS NOT "">
			<cfset structInsert(SearchRecord, "CustomerNumber", Variables.CustomerNumber, True)>
		</cfif>
        
		<cfif trim(Variables.CustomerName) IS NOT "">
			<cfset structInsert(SearchRecord, "CustomerName", Variables.CustomerName, True)>
		</cfif>
		
		<cfif trim(Variables.ResellerPONumber) IS NOT "">
			<cfset structInsert(SearchRecord, "ResellerPONumber", Variables.ResellerPONumber, True)>
		</cfif>

		<cfset qryQuotes = objQuoteSystem.findSalesRepQuotes(SearchRecord, Variables.OrderByList)>

		<cfif qryQuotes.RecordCount EQ 0>
			<cfset Error = "No Match Found">
		</cfif>
<!---        
	<cfelse>
		<cfset qryQuotes = objQuoteSystem.findSalesRepQuotes(SearchRecord, Variables.OrderByList)>
	</cfif>
--->    
    

</cfsilent>

<!---
<cfdump var="#qryQuotes#">
--->
<!---
Variables.CustomerNumber:<cfdump var="#Variables.CustomerNumber#"><br />
--->
<cfoutput>
<table width="575" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle" colspan="3">Sales Rep Quotes</td>
</tr>

<!--- Link to "Create a New Quote" --->
<tr>
	<td valign="top" class="textmain" colspan="3" align="right">
		<a href="index.cfm?task=quotes_new1">
			Create a New Quote
		</a>
	</td>
</tr>

<tr><!--- Link to "Create a New Quote from ACCPAC" --->
	<td valign="top" class="textmain" colspan="3" align="right">
		<a href="index.cfm?task=quotes_new_lstACCPAC">
			Create a New Quote from ACCPAC
		</a>
	</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain" colspan="3"><font color="FF0000">#objQuoteSystem.getMessage()#</font></td>
</tr>


<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>


<cfif isDefined("URL.NewQuoteSystemID")>

	<cfset qryCopyErrors = objQuoteSystem.getSessionValue("CopyErrorQuery")>

    <tr>
        <td valign="top" class="textsmall" colspan="3" style="color:##F00">
        	<cfif qryCopyErrors.RecordCount EQ 0>
                <strong>Your quote was successfully copied!  The newly-created quote is highlighted in the list below.</strong>
            <cfelse>
                <strong>
                	Your quote was copied.  The newly-created quote is highlighted in the list below.<br /><br />
                    
                    Note: The following component<cfif qryCopyErrors.RecordCount GT 1>s</cfif> could not be found, and therefore could not be copied to the new quote:<br />
                    <cfloop query="qryCopyErrors">
                    	&nbsp;&nbsp; #trim(qryCopyErrors.ITEMNO)#<br />
                    </cfloop>
               	</strong>
            </cfif>
        </td>
    </tr>
</cfif>

<tr>
	<td valign="top" class="textsmall" colspan="3">
		The following list displays all of your customer's quotes.<br />
        In the column labeled "Entry": "SR" indicates that the sales rep (you) created the quote here in the admin section; "CUST" means the customer created the quote in the partners section.        
	</td>
</tr>

<form name="QuoteSearch" action="index.cfm?task=quotes_list" method="post">
	<tr>
		<td class="textmain" width="25%"><strong>Quote Number:</strong></td>
		<td class="textmain" width="40%">
			<input name="QuoteNumber" size="20" maxlength="50" tabindex="1"
<!---				<cfif isDefined("FORM.QuoteNumber")>
--->					value="#Variables.QuoteNumber#"
<!---				</cfif>
--->			>
		</td>
		<td class="textmain" align="left">
			<input type="submit" name="ProcessSearch" value="Search">
		</td>
	</tr>
	<tr>
		<td class="textmain"><strong>Quote Date:</strong></td>
		<td class="textmain">
			<input name="QuoteDate" size="20" maxlength="50" tabindex="2"
<!---				<cfif isDefined("FORM.QuoteDate")>
--->					value="#Variables.QuoteDate#"
<!---				</cfif>
--->			>
		</td>
	</tr>
	<tr>
		<td class="textmain"><strong>Customer Number:</strong></td>
		<td class="textmain">
			<input name="CustomerNumber" size="20" maxlength="50" tabindex="3"
<!---            
				<cfif isDefined("FORM.CustomerNumber")>
					value="#FORM.CustomerNumber#"
				</cfif>
--->                
					value="#Variables.CustomerNumber#"
			>
		</td>
	</tr>
	<tr>
		<td class="textmain"><strong>Customer Name:</strong></td>
		<td class="textmain">
			<input name="CustomerName" size="20" maxlength="50" tabindex="4"
<!---				<cfif isDefined("FORM.CustomerName")>
--->					value="#Variables.CustomerName#"
<!---				</cfif>
--->			>
		</td>
	</tr>
	<tr>
		<td class="textmain"><strong>Reseller PO ##:</strong></td>
		<td class="textmain">
			<input name="ResellerPONumber" size="20" maxlength="50" tabindex="4"
<!---				<cfif isDefined("FORM.ResellerPONumber")>
--->					value="#Variables.ResellerPONumber#"
<!---				</cfif>
--->			>
		</td>
	</tr>
</form>
<!---
<cfif Error IS NOT "">
	<tr><td class="textsmall">&nbsp;</td></tr>
	<tr>
		<td class="textmain" align="left" colspan="3">
			<font color="FF0000">
				<cfif Error IS "No Match Found">
					<cfif trim(FORM.QuoteDate) IS NOT "">
						Quote Date '#FORM.QuoteDate#' was not found.
					<cfelseif trim(FORM.CustomerNumber) IS NOT "">
						Customer Number '#FORM.CustomerNumber#' was not found.
                    <cfelse>
						No quotes were found matching your search critera.
					</cfif>
				</cfif>
			</font>
		</td>
	</tr>
</cfif>
--->
<tr>
<td valign="top" class="textmain" colspan="3">
	<table cellpadding="0" cellspacing="0" width="100%" border="0">

    <tr>
<!---
        <td colspan="9" class="textmain" align="center"><b><cf_nextprev queryname="qryQuotes" actionstring="index.cfm?task=quotes_list" querystartrow="#URL.qsr#" querymaxrows="#URL.qmr#"></b></td>
--->
        <td colspan="9" class="textmain" align="center"><b><cf_nextprev queryname="qryQuotes" actionstring="index.cfm?task=quotes_list&QuoteNumber=#urlEncodedFormat(Variables.QuoteNumber)#&QuoteDate=#urlEncodedFormat(Variables.QuoteDate)#&CustomerNumber=#urlEncodedFormat(Variables.CustomerNumber)#&CustomerName=#urlEncodedFormat(Variables.CustomerName)#" querystartrow="#URL.qsr#" querymaxrows="#URL.qmr#"></b></td>


    </tr>

	<!--- LIST HEADINGS --->
	<tr>
		<td valign="bottom" height="18" bgcolor="006633" width="8%">
			<a class="menuwh" href="index.cfm?task=quotes_list&SortColumn=QuoteNumber&SortOrder=#NewSortOrder#&QuoteNumber=#urlEncodedFormat(Variables.QuoteNumber)#&QuoteDate=#urlEncodedFormat(Variables.QuoteDate)#&CustomerNumber=#urlEncodedFormat(Variables.CustomerNumber)#&CustomerName=#urlEncodedFormat(Variables.CustomerName)#&ResellerPONumber=#urlEncodedFormat(Variables.ResellerPONumber)#">
				Quote
			</a>
		</td>
		<td valign="bottom" height="18" bgcolor="006633" width="9%">
			<a class="menuwh" href="index.cfm?task=quotes_list&SortColumn=QuoteDate&SortOrder=#NewSortOrder#&QuoteNumber=#urlEncodedFormat(Variables.QuoteNumber)#&QuoteDate=#urlEncodedFormat(Variables.QuoteDate)#&CustomerNumber=#urlEncodedFormat(Variables.CustomerNumber)#&CustomerName=#urlEncodedFormat(Variables.CustomerName)#&ResellerPONumber=#urlEncodedFormat(Variables.ResellerPONumber)#">
				Date
			</a>
		</td>
		<td valign="bottom" height="18" bgcolor="006633">
			<a class="menuwh" href="index.cfm?task=quotes_list&SortColumn=CustomerNumber&SortOrder=#NewSortOrder#&QuoteNumber=#urlEncodedFormat(Variables.QuoteNumber)#&QuoteDate=#urlEncodedFormat(Variables.QuoteDate)#&CustomerNumber=#urlEncodedFormat(Variables.CustomerNumber)#&CustomerName=#urlEncodedFormat(Variables.CustomerName)#&ResellerPONumber=#urlEncodedFormat(Variables.ResellerPONumber)#">
				Customer
			</a>
		</td>
		<td valign="bottom" height="18" bgcolor="006633">
			<a class="menuwh" href="index.cfm?task=quotes_list&SortColumn=SystemName&SortOrder=#NewSortOrder#&QuoteNumber=#urlEncodedFormat(Variables.QuoteNumber)#&QuoteDate=#urlEncodedFormat(Variables.QuoteDate)#&CustomerNumber=#urlEncodedFormat(Variables.CustomerNumber)#&CustomerName=#urlEncodedFormat(Variables.CustomerName)#&ResellerPONumber=#urlEncodedFormat(Variables.ResellerPONumber)#">
				Base System
			</a>
		</td>
		<td valign="bottom" height="18" bgcolor="006633" align="center">
			<a class="menuwh" href="index.cfm?task=quotes_list&SortColumn=Quantity&SortOrder=#NewSortOrder#&QuoteNumber=#urlEncodedFormat(Variables.QuoteNumber)#&QuoteDate=#urlEncodedFormat(Variables.QuoteDate)#&CustomerNumber=#urlEncodedFormat(Variables.CustomerNumber)#&CustomerName=#urlEncodedFormat(Variables.CustomerName)#&ResellerPONumber=#urlEncodedFormat(Variables.ResellerPONumber)#">
				Qty
			</a>
		</td>
		<td valign="bottom" height="18" bgcolor="006633" align="center">
			<a class="menuwh" href="index.cfm?task=quotes_list&SortColumn=ResellerTotal&SortOrder=#NewSortOrder#&QuoteNumber=#urlEncodedFormat(Variables.QuoteNumber)#&QuoteDate=#urlEncodedFormat(Variables.QuoteDate)#&CustomerNumber=#urlEncodedFormat(Variables.CustomerNumber)#&CustomerName=#urlEncodedFormat(Variables.CustomerName)#&ResellerPONumber=#urlEncodedFormat(Variables.ResellerPONumber)#">
				Price
			</a>
		</td>
		<td valign="bottom" height="18" bgcolor="006633" align="center">
			<a class="menuwh" href="index.cfm?task=quotes_list&SortColumn=QuoteSent&SortOrder=#NewSortOrder#&QuoteNumber=#urlEncodedFormat(Variables.QuoteNumber)#&QuoteDate=#urlEncodedFormat(Variables.QuoteDate)#&CustomerNumber=#urlEncodedFormat(Variables.CustomerNumber)#&CustomerName=#urlEncodedFormat(Variables.CustomerName)#&ResellerPONumber=#urlEncodedFormat(Variables.ResellerPONumber)#">
				Sent?
			</a>
		</td>
		<td valign="bottom" height="18" bgcolor="006633" align="center">
			<a class="menuwh" href="index.cfm?task=quotes_list&SortColumn=SalesRepQuote&SortOrder=#NewSortOrder#&QuoteNumber=#urlEncodedFormat(Variables.QuoteNumber)#&QuoteDate=#urlEncodedFormat(Variables.QuoteDate)#&CustomerNumber=#urlEncodedFormat(Variables.CustomerNumber)#&CustomerName=#urlEncodedFormat(Variables.CustomerName)#&ResellerPONumber=#urlEncodedFormat(Variables.ResellerPONumber)#">
				Entry
			</a>
		</td>
		<td valign="bottom" height="18" bgcolor="006633" align="center">
			<a class="menuwh" href="index.cfm?task=quotes_list&SortColumn=ResellerPONumber&SortOrder=#NewSortOrder#&QuoteNumber=#urlEncodedFormat(Variables.QuoteNumber)#&QuoteDate=#urlEncodedFormat(Variables.QuoteDate)#&CustomerNumber=#urlEncodedFormat(Variables.CustomerNumber)#&CustomerName=#urlEncodedFormat(Variables.CustomerName)#&ResellerPONumber=#urlEncodedFormat(Variables.ResellerPONumber)#">
				PO ##
			</a>
		</td>
	</tr>
</cfoutput>

	<!--- LIST DATA --->	
	<cfif qryQuotes.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="9" class="productTitle">
            	<font color="FF0000">
					<cfif Error IS "No Match Found">
                     	No quotes were found matching your search critera.
					<cfelse>
                        You currently have no quotes entered on the system.
                    </cfif>
               	</font>
       		</td>
		</tr>
	</cfif>
	
	<cfoutput query="qryQuotes" maxrows="#URL.qmr#" startrow="#URL.qsr#">
<!---<cfoutput query="qryQuotes">--->

    	<cfif isDefined("URL.NewQuoteSystemID") AND  qryQuotes.QuoteSystemID IS URL.NewQuoteSystemID>
        	<cfset StyleText = "style='background-color:##FF0'">
		<cfelseif qryQuotes.CurrentRow mod 2>            
        	<cfset StyleText = "style='background-color:##e5e5e6'">
        <cfelse>
        	<cfset StyleText = "">
        </cfif>

<!---
		<tr<cfif qryQuotes.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
--->        
        <tr #StyleText#>
			<td class="textsmall" align="left" valign="top">
                <a href="index.cfm?task=quote_detail&QuoteSystemID=#urlEncodedFormat(qryQuotes.QuoteSystemID)#">
            		#qryQuotes.QuoteNumber#
                </a>
            </td>
            
            
			<td class="textsmall" align="left" valign="top">#dateFormat(qryQuotes.QuoteDate, 'mm/dd/yy')#</td>
			<td class="textsmall" align="left" valign="top">
            	#qryQuotes.CustomerNumber#<br />
            	<cfif len(trim(qryQuotes.CustomerName)) GT 21>
                    #left(trim(qryQuotes.CustomerName), 20)#...
				<cfelse>
                    #trim(qryQuotes.CustomerName)#
				</cfif>
            </td>	
			<td class="textsmall" align="left" valign="top">
            	<cfif len(trim(qryQuotes.SystemName)) GT 27>
                    #left(trim(qryQuotes.SystemName), 26)#...
				<cfelse>
                    #trim(qryQuotes.SystemName)#
				</cfif>
            </td>
			<td class="textsmall" align="center" valign="top">#qryQuotes.Quantity#</td>
			<td class="textsmall" align="center" valign="top">#dollarFormat(qryQuotes.ResellerTotal)#</td>
			<td class="textsmall" align="center" valign="top">#yesNoFormat(qryQuotes.QuoteSent)#</td>
			<td class="textsmall" align="center" valign="top">
            	<cfif qryQuotes.SalesRepQuote EQ 1>
					SR
                <cfelse>
                	CUST
				</cfif>
            </td>
			<td class="textsmall" align="center" valign="top"><cfif trim(qryQuotes.ResellerPONumber) is not "">#qryQuotes.ResellerPONumber#<cfelse>&nbsp;</cfif></td>
			
		</tr>
	</cfoutput>

	</table>
</td>
</tr>
</table>