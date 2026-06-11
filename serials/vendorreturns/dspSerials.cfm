<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/03/2006
	Function: 		This page displays serial numbers in view-only format
	Template:		dspSerials.cfm
	Task:			serials_returnsvendor_serials_view
--->
	<cfset objPORETH1 = createObject("component", "admin.assets.cfcs.PORETH1")>
	<cfset objPORETL = createObject("component", "admin.assets.cfcs.PORETL")>
	<cfset objSerialsVendorReturns = createObject("component", "admin.assets.cfcs.SerialsVendorReturns")>

	<!--- Get a structure of the Return to Vendor header --->
	<cfset strHeader = objPORETH1.getRecord(URL.RETHSEQ)>
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "RETHSEQ", URL.RETHSEQ, True)>
	<cfset structInsert(SearchRecord, "RETLREV", URL.RETLREV, True)>
	<!--- Get a query of the Return to Vendor detail --->
	<cfset qryDetail = objPORETL.searchRecords(SearchRecord, "query")>
	<!--- Get a query of the serial numbers entered --->
	<cfset qrySerialsVendorReturns = objSerialsVendorReturns.searchRecords(SearchRecord, "query")>
</cfsilent>

<script language="javascript">
	window.onload = init;
	function init() {
		var ref = document.getElementById("LinkBack");
		ref.focus();
	}
	function confirmDelete() {
		var msg = "This function will DELETE all serial numbers posted for this item, and reverse all entries that were made in the master list of serial numbers and serial number audit trail.  It will essentially allow you to start over with this item.  Are you sure you want to continue?";
		if(confirm(msg)) { 
			document.detailform.ButtonClicked.disabled = true;
			document.getElementById("Posting").style.visibility = "visible";		
		    window.document.detailform.submit();
		}
		else { return false; }
	}
</script>

<cfoutput>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objSerialsVendorReturns.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<!--- link back --->
<tr>
	<td class="textsmall" align="right">
		<a href="index.cfm?task=serials_returnsvendor_items_list&RETHSEQ=#urlEncodedFormat(URL.RETHSEQ)#" id="LinkBack">
			<font style="background-color:FFFFCC; text-decoration:underline">Back to Vendor Return Item List</font>
		</a>
	</td>
</tr>

<tr>
<td valign="top" class="textmain">
	<!--- HEADER INFORMATION --->
	<cfinclude template="headerInfo.cfm">
	
	<!--- DETAIL INFORMATION --->
	<cfinclude template="detailInfo.cfm">
</td>
</tr>
<tr><td>&nbsp;</td></tr>

<cfif NOT isDefined("URL.PostingAll")>
    <tr>
    <td valign="top" class="textmain">
        <table cellpadding="2" cellspacing="0" width="100%" border="0">
    
        <form action="index.cfm?task=serials_returnsvendor_serials_delete" method="Post" name="detailform">
        <input type="hidden" name="RETHSEQ" value="#URL.RETHSEQ#">
        <input type="hidden" name="RETLREV" value="#URL.RETLREV#">
            <tr><td>&nbsp;</td></tr>
            <tr>
                <!--- "DELETE ALL" BUTTON --->
                <td colspan="2">
                    <input type="submit" name="ButtonClicked" value="Delete All" onclick="return confirmDelete()">
                </td>
            </tr>
            <tr id="Posting" style="visibility:hidden;">
                <td valign="top" colspan="2" align="center" class="textmain">
                    <font color="FF0000">Deleting Serial Numbers - Please Wait</font>
                </td>
            </tr>
        </form>
    
        <tr>
            <td valign="top" class="textmain" colspan="2"><b>Serial Numbers:</b></td>
        </tr>
        
        <cfloop query="qrySerialsVendorReturns">
            <tr>
                <td valign="top" class="textmain" width="20%">&nbsp;</td>
                <td valign="top" class="textmain">#qrySerialsVendorReturns.SerialNumber#</td>
            </tr>
        </cfloop>
        </table>
    </td>
    </tr>
<cfelse>
	<tr>
		<td valign="top" class="textmain">
			All serial numbers have been sucessfully posted for all items of this Vendor Return.<br>
			Click the above <a href="index.cfm?task=serials_returnsvendor_items_list&RETHSEQ=#urlEncodedFormat(URL.RETHSEQ)#">link</a> to review individual items and their serial numbers.
		</td>
	</tr>
</cfif>

<tr><td>&nbsp;</td></tr>
</table>
</cfoutput>