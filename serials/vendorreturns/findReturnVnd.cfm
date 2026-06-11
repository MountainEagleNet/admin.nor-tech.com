<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/03/2006
	Function: 		This page finds a vendor return after entering a return to vendor number and clicking "Go"
	Template:		findReturnVnd.cfm
	Task:			serials_returnsvendor_find
--->
<cfset objPORETH1 = createObject("component", "admin.assets.cfcs.PORETH1")>

<cfif NOT isDefined("Form.VendorReturnNumber") OR trim(Form.VendorReturnNumber) IS "">
	<!--- Return to Vendor Number not entered (blank) --->
	<cflocation url="index.cfm?task=serials_returnsvendor_list&Error=Blank">
<cfelse>
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "RETNUMBER", trim(Form.VendorReturnNumber), True)>
	<cfset qryVendorReturns = objPORETH1.searchRecords(SearchRecord, "query")>
	
	<!--- Return to Vendor not found --->
	<cfif qryVendorReturns.RecordCount EQ 0>
		<cflocation url="index.cfm?task=serials_returnsvendor_list&Error=NotFound&VendorReturnNumber=#Form.VendorReturnNumber#">

	<!--- Multiple Return to Vendors found for this Return to Vendor number --->
	<cfelseif qryVendorReturns.RecordCount GT 1>
		<cflocation url="index.cfm?task=serials_returnsvendor_list&Error=MultipleFound&VendorReturnNumber=#Form.VendorReturnNumber#">

	<!--- Return to Vendor Found --->
	<cfelse>
		<cflocation url="index.cfm?task=serials_returnsvendor_items_list&RETHSEQ=#urlEncodedFormat(qryVendorReturns.RETHSEQ)#">
	</cfif>
	
</cfif>