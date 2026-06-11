<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/22/2006
	Edit Date: 		10/12/2006
	Function: 		This page displays the password form
	Template:		frmPassword.cfm
	Task:			serials_shipments_password
--->
	<cfset objOEORDH = createObject("component", "admin.assets.cfcs.OEORDH")>
	<cfset objOEORDD = createObject("component", "admin.assets.cfcs.OEORDD")>
<!---
	<cfset objOESHIH = createObject("component", "admin.assets.cfcs.OESHIH")>
	<cfset objOESHID = createObject("component", "admin.assets.cfcs.OESHID")>
--->
	<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>

	<cfset stRecord = objSerialsShipments.getDataRecord()>
	<cfset stWarnings = objSerialsShipments.getErrorRecord()>

	<!--- Get a structure of the Order header --->
	<cfset strHeader = objOEORDH.getRecord(stRecord.ORDUNIQ)>
	
	<!--- Get a query of the Order detail --->
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "ORDUNIQ", stRecord.ORDUNIQ, True)>
	<cfset structInsert(SearchRecord, "LINENUM", stRecord.ORDLINENUM, True)>
	<cfset qryDetail = objOEORDD.searchRecords(SearchRecord, "query")>
<!---
	<!--- Get a structure of the Shipment header --->
	<cfset strHeader = objOESHIH.getRecord(stRecord.SHIUNIQ)>
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "SHIUNIQ", stRecord.SHIUNIQ, True)>
	<cfset structInsert(SearchRecord, "LINENUM", stRecord.LINENUM, True)>
	<!--- Get a query of the Shipment detail --->
	<cfset qryDetail = objOESHID.searchRecords(SearchRecord, "query")>

	<!--- Get a query of the Order --->
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "ORDNUMBER", strHeader.ORDNUMBER, True)>
	<cfset qryOrder = objOEORDH.searchRecords(SearchRecord, "query")>
--->

	<!--- Determine the amount remaining to ship --->
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "ORDUNIQ", stRecord.ORDUNIQ, True)>
	<cfset structInsert(SearchRecord, "ORDLINENUM", stRecord.ORDLINENUM, True)>
	<cfset structInsert(SearchRecord, "Posted", 1, True)>
<!---<cfset structInsert(SearchRecord, "AttachedToInvoice", 1, True)>--->
	<cfset qrySerialsShipmentsAttached = objSerialsShipments.searchRecords(SearchRecord, "query")>
<!---<cfset RemainingQuantity = int(qryDetail.ORIGQTY - qrySerialsShipmentsAttached.RecordCount)>--->
	<cfif NOT isNumeric(qryDetail.QTYORDERED)><cfset qryDetail.QTYORDERED = 0></cfif>
	<cfif NOT isNumeric(qryDetail.QTYSHPTODT)><cfset qryDetail.QTYSHPTODT = 0></cfif>
	<cfset RemainingQuantity = int((qryDetail.QTYORDERED + qryDetail.QTYSHPTODT) - qrySerialsShipmentsAttached.RecordCount)>

</cfsilent>

<script language="JavaScript" type="text/JavaScript">
<!--
function disableButton() {
  document.detailform.ButtonClicked[1].disabled = true;
  document.getElementById("Posting").style.visibility = "visible";					
  window.document.detailform.submit();
}
//-->
</script>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<td valign="top" class="textmain" style="font-size:16px"><font color="FF0000"><b>Password Required</b></font></td>
</tr>

<tr>
<td valign="top" class="textmain">
	<!--- ORDER INFORMATION --->
	<cfinclude template="headerInfo.cfm">
	<!--- DETAIL INFORMATION --->
	<cfinclude template="detailInfo.cfm">
</td>
</tr>
<tr><td>&nbsp;</td></tr>

<tr>
	<td valign="top" class="textmain">
	Please enter the password to continue.<br> 
	</td>
</tr>


<tr>
<td valign="top" class="textmain">
	<form action="index.cfm?task=serials_shipments_password_act" method="Post" name="detailform">
	<input type="hidden" name="ORDUNIQ" value="#stRecord.ORDUNIQ#">
	<input type="hidden" name="ORDLINENUM" value="#stRecord.ORDLINENUM#">
	<cfif isDefined("URL.CorrectingSerialNumber")>
		<input type="hidden" name="CorrectingSerialNumber" value="1">
	</cfif>
<!---
	<cfif isDefined("stRecord.LargeQuantity")>
        <input type="hidden" name="LargeQuantity" value="#stRecord.LargeQuantity#">
	</cfif>
--->
	<cfset TabValue = 1>
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	<tr>
		<td width="15%" class="textmain" align="left">
			<strong>Password:</strong>
		</td>
		<td class="textmain" align="left">
			<input type="password" name="Password" size="20" maxlength="50" tabindex="#TabValue#">
			<cfset TabValue = TabValue + 1>
		</td>
	</tr>
	</table>
	
	<table cellpadding="4" cellspacing="0" border="0" width="80%" align="center">
	<tr><td>&nbsp;</td></tr>
	<tr>
		<!--- "BACK" BUTTON --->
		<td align="left">
			<input type="submit" name="ButtonClicked" value="&laquo;- Back&nbsp;">
		</td>
		<!--- "CONTINUE" BUTTON --->
		<td align="right">
			<input type="submit" name="ButtonClicked" value="&nbsp;Continue -&raquo;" tabindex="#TabValue#"  onclick="return disableButton()">
		</td>
	</tr>
	<tr id="Posting" style="visibility:hidden;">
		<td valign="top" colspan="2" align="center" class="textmain">
			<font color="FF0000">Posting Serial Numbers - Please Wait</font>
		</td>
	</tr>
	</table>
	</form>
</td>
</tr>

</table>
</cfoutput>

<script language="JavaScript" type="text/JavaScript">
<!--
document.detailform['Password'].focus();document.detailform['Password'].select()
-->
</script>