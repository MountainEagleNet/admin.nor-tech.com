<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/08/2006
	Function: 		This page lists serial numbers for the selected item number
	Template:		lstSerials.cfm
	Task:			serials_corrections_serials_list
--->
	<cfset objSerials = createObject("component", "admin.assets.cfcs.Serials")>
	<cfset objICITEM = createObject("component", "admin.assets.cfcs.ICITEM")>
	<cfset objScannerBatchItems = createObject("component", "admin.assets.cfcs.ScannerBatchItems")>

	<cfparam name="URL.SortColumn" type="string" default="SerialNumber">
	<cfparam name="URL.SortOrder" type="string" default="Asc">

	<!--- set the new sort order for display --->
	<cfif URL.SortOrder IS "Desc">
		<cfset Variables.NewSortOrder = "Asc">
	<cfelse>
		<cfset Variables.NewSortOrder = "Desc">
	</cfif>

	<cfset Variables.OrderByList = URL.SortColumn & " " & URL.SortOrder>
	
	<cfset stRecord = structNew()>

	<cfif isDefined("FORM.ITEMNO")>
		<cfset stRecord.ITEMNO = FORM.ITEMNO>
	<cfelseif isDefined("URL.ITEMNO")>
		<cfset stRecord.ITEMNO = URL.ITEMNO>
	<cfelse>
		<cfset stRecord.ITEMNO = "">
	</cfif>
	
	<cfif isDefined("FORM.SerialNumber")>
		<cfset stRecord.SerialNumber = FORM.SerialNumber>
	<cfelseif isDefined("URL.SerialNumber")>
		<cfset stRecord.SerialNumber = URL.SerialNumber>
	<cfelse>
		<cfset stRecord.SerialNumber = "">
	</cfif>

	<!--- Get a structure of the header, item information --->
	<cfset strHeader = objICITEM.getRecord(stRecord.ITEMNO)>
	
	<!--- Get all the serial numbers for this item --->
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "SerialNumber", stRecord.SerialNumber, True)>
	<cfset structInsert(SearchRecord, "ITEMNO", stRecord.ITEMNO, True)>
	<cfset qrySerials = objSerials.findSerialNumberForCorrections(SearchRecord, Variables.OrderByList)>
	
</cfsilent>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objSerials.getMessage()#</font></td>
</tr>

<tr>
	<td valign="top" class="textmain">
		<!--- HEADER INFORMATION --->
		<cfinclude template="headerInfo.cfm">
	</td>
</tr>
<tr><td class="textsmall">&nbsp;</td></tr>

<cfset ThisIsABatchNumberItem = 0>
<cfset SearchRecord1 = structNew()>
<cfset structInsert(SearchRecord1, "ITEMNO", stRecord.ITEMNO, True)>
<cfset qryScannerBatchItems = objScannerBatchItems.searchRecords(SearchRecord1, "query")>
<cfif qryScannerBatchItems.RecordCount GT 0>
    <cfset ThisIsABatchNumberItem = 1>
</cfif>

<cfif NOT ThisIsABatchNumberItem>
    <tr>
        <td class="textsmall" align="right">
            <a href="index.cfm?task=serials_corrections_delete_duplicates&ITEMNO=#urlEncodedFormat(stRecord.ITEMNO)#&RequestTimeout=6000">
                Delete Duplicates
            </a>
        </td>
    </tr>
</cfif>

<tr>
	<td class="textsmall">
		To find a specific serial number in the list, enter it in the box provided and click "Search"
	</td>
</tr>
<tr>
	<td valign="top" class="textmain">
	<table width="100%" border="0" align="center" cellpadding="3" cellspacing="1">
		<form name="SerialNumberSearch" action="index.cfm?task=serials_corrections_serials_list" method="post">
		<input type="hidden" name="ITEMNO" value="#stRecord.ITEMNO#">
			<tr>
				<td class="textmain" width="21%"><strong>Serial Number:</strong></td>
				<td class="textmain" width="32%">
					<input name="SerialNumber" size="20" maxlength="50" 
					<cfif isDefined("stRecord.SerialNumber")>
						value="#stRecord.SerialNumber#"
					</cfif>
					>
				</td>
				<td class="textmain" align="left">
					<input type="submit" name="ProcessSearch" value="Search">
				</td>
			</tr>
		</form>
	</table>
	</td>
</tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="0" cellspacing="0" width="100%" border="0">
	
	<!--- LIST HEADINGS --->
	<tr>
		<td height="18" bgcolor="006633">
			<a class="menuwh" href="index.cfm?task=serials_corrections_serials_list&SortColumn=SerialNumber&SortOrder=#NewSortOrder#&ITEMNO=#urlEncodedFormat(stRecord.ITEMNO)#&SerialNumber=#urlEncodedFormat(stRecord.SerialNumber)#">
				Serial Number
			</a>
		</td>
		<td height="18" bgcolor="006633" class="productTitle" align="center"><font color="FFFFFF">Location</font></td>
	</tr>

	<!--- LIST DATA --->	
	<cfif qrySerials.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="2" class="productTitle">
				<font color="FF0000">
					<cfif isDefined("stRecord.SerialNumber") AND trim(stRecord.SerialNumber) IS NOT "">
						The serial number you entered was not found for this item.
					<cfelse>
						There are no Serial Numbers on file for this item.
					</cfif>
				</font>
			</td>
		</tr>
	</cfif>
	
	<cfloop query="qrySerials">
		<tr<cfif qrySerials.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
			<td class="textsmall" align="left">
				<a href="index.cfm?task=serials_corrections_serials_edit&SerialID=#urlEncodedFormat(qrySerials.SerialID)#">
					#qrySerials.SerialNumber#
				</a>
			</td>
			<td class="textsmall" align="center">
				#qrySerials.LOCATION# - #objSerials.getLocationDescription(qrySerials.LOCATION)#
			</td>
		</tr>
	</cfloop>

	</table>
</td>
</tr>


</table>
</cfoutput>