<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/28/2008
	Function: 		This page prompts the user to enter a Customer Number
	Template:		frmQuote2.cfm
	Task:			quotes_new2
--->
<cfset objResellerSystems = createObject("component", "admin.assets.cfcs.config.ResellerSystems")>
<cfset objLogin = createObject("component", "admin.assets.cfcs.Cust")>
<cfset objQuoteSystem = createObject("component", "admin.assets.cfcs.config.QuoteSystem")>

<cfif isDefined("URL.UserID")>
	<cfset Variables.UserID = URL.UserID>
<cfelseif isDefined("FORM.UserID")>
	<cfset Variables.UserID = FORM.UserID>
</cfif>

<cfif isDefined("URL.CustomerID")>
	<cfset Variables.CustomerID = URL.CustomerID>
<cfelseif isDefined("FORM.CustomerID")>
	<cfset Variables.CustomerID = FORM.CustomerID>
</cfif>

<cfparam name="URL.INVUNIQ" default="">
<cfparam name="URL.CopyingQuote" default="0">

<!--- If Copying a Quote --->
<cfif URL.CopyingQuote>

	<!--- If Copying a quoting (as opposed to updating one) --->
	<cfif URL.Cpyx>
		<cfset strResult = objQuoteSystem.copyQuote(URL.QuoteSystemID, URL.CustomerID)>
		<cfset objQuoteSystem.setSessionValue("CopyErrorQuery", strResult.Errors)>
        <cflocation url="index.cfm?task=quotes_list&NewQuoteSystemID=#urlEncodedFormat(strResult.NewQuoteSystemID)#">
    </cfif>    


	<cfset strQuoteSystem = objQuoteSystem.getRecord(URL.QuoteSystemID)>
    <cfif strQuoteSystem.CustomerID IS Variables.CustomerID>
        <cflocation url="index.cfm?task=quotes_new3&QuoteSystemID=#urlEncodedFormat(URL.QuoteSystemID)#&CopyingQuote=1&RequestTimeout=6000">
	<cfelse>

		<cfset SearchRecord = structNew()>
        <cfset structInsert(SearchRecord, "CustomerID", Variables.CustomerID, True)>
        <cfset qryLogin = objLogin.searchRecords(SearchRecord)>
        <cfset Variables.PriceListID = qrylogin.PriceListID>
        
        <cfset strQuoteScreen3 = structNew()>
        <cfset structInsert(strQuoteScreen3, "CustomerID", Variables.CustomerID, True)>
        <cfset structInsert(strQuoteScreen3, "ConfigSystemID", "", True)>
        <cfset structInsert(strQuoteScreen3, "UserID", Variables.UserID, True)>
        <cfset objResellerSystems.setSessionValue("QuoteScreen3", strQuoteScreen3)>
        
        <cflocation url="index.cfm?task=quotes_new4&UserID=#urlEncodedFormat(Variables.UserID)#&CustomerID=#urlEncodedFormat(Variables.CustomerID)#&PriceListID=#urlEncodedFormat(Variables.PriceListID)#&CameFromScreen5=0&INVUNIQ=#urlEncodedFormat(URL.INVUNIQ)#&CopyQuoteNewCustomer=1&QuoteSystemID=#urlEncodedFormat(URL.QuoteSystemID)#">
    
	</cfif>
</cfif>

<!--- If creating an invoice out of ACCPAC --->
<cfif URL.INVUNIQ IS NOT "">
	<cfset SearchRecord = structNew()>
    <cfset structInsert(SearchRecord, "CustomerID", Variables.CustomerID, True)>
    <cfset qryLogin = objLogin.searchRecords(SearchRecord)>
    <cfset Variables.PriceListID = qrylogin.PriceListID>
    
	<cfset strQuoteScreen3 = structNew()>
    <cfset structInsert(strQuoteScreen3, "CustomerID", Variables.CustomerID, True)>
    <cfset structInsert(strQuoteScreen3, "ConfigSystemID", "", True)>
    <cfset structInsert(strQuoteScreen3, "UserID", Variables.UserID, True)>
	<cfset objResellerSystems.setSessionValue("QuoteScreen3", strQuoteScreen3)>
    
    <cflocation url="index.cfm?task=quotes_new4&UserID=#urlEncodedFormat(Variables.UserID)#&CustomerID=#urlEncodedFormat(Variables.CustomerID)#&PriceListID=#urlEncodedFormat(Variables.PriceListID)#&CameFromScreen5=0&INVUNIQ=#urlEncodedFormat(URL.INVUNIQ)#">
</cfif>

<cfparam name="URL.TypeOfQuote" default="">
<cfparam name="URL.Type" default="">

<!---
<cfset qryResellerSystems = objResellerSystems.listRecordsForParent("CustomerID", Variables.CustomerID, "SystemType, SystemName")>
--->
<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objResellerSystems.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<form name="WhichTypeOfSystem" action="index.cfm?task=quotes_new2_act&RequestTimeout=6000" method="post">
<input type="hidden" name="UserID" value="#Variables.UserID#">
<input type="hidden" name="CustomerID" value="#Variables.CustomerID#">
	<tr>
		<td colspan="2" class="textmain" align="left">
        	Does this quote include a Base System, or is it for Misc Parts only?<br />
            Please choose one of the following:
		</td>
  	</tr>
	<cfif isDefined("URL.Error") AND URL.Error IS "Blank">
        <tr>
            <td>&nbsp;</td>
            <td class="textmain" align="left">
                <font color="FF0000">
                    Please choose one of the following before clicking "Continue":
                </font>
            </td>
        </tr>
    </cfif>
	<tr>
    	<td width="15%">&nbsp;</td>
		<td class="textmain" align="left">
			<input type="radio" name="TypeOfQuote" value="Include Base System" 
				<cfif URL.TypeOfQuote IS "Include Base System">checked</cfif>
				>Include Base System <br>
			<input type="radio" name="TypeOfQuote" value="Misc Parts Only" 
				<cfif URL.TypeOfQuote IS "Misc Parts Only">checked</cfif>
				>Misc Parts Only 
		</td>
  	</tr>
    <tr><td>&nbsp;</td></tr>

	<tr>
		<td colspan="2" class="textmain" align="left">
        	If you checked "Include Base System" above, choose which type of system you want to include:
		</td>
  	</tr>
	<cfif isDefined("URL.Error") AND URL.Error IS "NoSystemType">
        <tr>
            <td>&nbsp;</td>
            <td class="textmain" align="left">
                <font color="FF0000">
                    Please choose the type of system you want to include before clicking "Continue":
                </font>
            </td>
        </tr>
    </cfif>
	<tr>
    	<td>&nbsp;</td>
		<td class="textmain" align="left">
			<input type="radio" name="Type" value="Workstation"
				<cfif URL.Type IS "Workstation">checked</cfif>
           		>Workstation <br />
			<input  type="radio" name="Type" value="Notebook"
            	<cfif URL.Type IS "Notebook">checked</cfif>
				>Notebook <br />
			<input type="radio" name="Type" value="Server"
            	<cfif URL.Type IS "Server">checked</cfif>
				>Server <br />
			<input type="radio" name="Type" value="MiniMountablePC"
            	<cfif URL.Type IS "MiniMountablePC">checked</cfif>
                >Mini/Mountable PC <br />
		</td>
  	</tr>
    <tr><td>&nbsp;</td></tr>


	<tr>
		<td colspan="2" class="textmain" align="center">
			<input type="submit" name="Continue" value="Continue">
		</td>
  	</tr>      
     
</form>

<tr><td class="textsmall">&nbsp;</td></tr>

</table>
</cfoutput>
