<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/29/2007
	Function: 		This page displays the form for entering quantity for the "Replicate" function
	Template:		frmReplicate.cfm
	Task:			serials_shipments_replicate_qty
--->
	<cfset objOEORDH = createObject("component", "admin.assets.cfcs.OEORDH")>
	<cfset objOEORDD = createObject("component", "admin.assets.cfcs.OEORDD")>
	<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>

	<cfset stRecord = objSerialsShipments.getDataRecord()>

	<!--- Get a structure of the Order header --->
	<cfset strHeader = objOEORDH.getRecord(stRecord.ORDUNIQ)>
	
	<!--- Get a query of the Order detail --->
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "ORDUNIQ", stRecord.ORDUNIQ, True)>
	<cfset structInsert(SearchRecord, "LINENUM", stRecord.ORDLINENUM, True)>
	<cfset qryDetail = objOEORDD.searchRecords(SearchRecord, "query")>

	<!--- Determine the amount remaining to ship --->
	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "ORDUNIQ", stRecord.ORDUNIQ, True)>
	<cfset structInsert(SearchRecord, "ORDLINENUM", stRecord.ORDLINENUM, True)>
	<cfset structInsert(SearchRecord, "Posted", 1, True)>
	<cfset qrySerialsShipmentsAttached = objSerialsShipments.searchRecords(SearchRecord, "query")>
	<cfif NOT isNumeric(qryDetail.QTYORDERED)><cfset qryDetail.QTYORDERED = 0></cfif>
	<cfif NOT isNumeric(qryDetail.QTYSHPTODT)><cfset qryDetail.QTYSHPTODT = 0></cfif>
	<cfset RemainingQuantity = int((qryDetail.QTYORDERED + qryDetail.QTYSHPTODT) - qrySerialsShipmentsAttached.RecordCount)>

</cfsilent>

<script language="javascript">
	function confirmPost() {
		disableAllButtons();
		window.document.detailform.submit();
	}
	function disableAllButtons() {
		document.detailform.ButtonClicked.disabled = true;
		return true;
	}
</script>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<!--- HEADER INFORMATION --->
	<cfinclude template="headerInfo.cfm">
	<!--- DETAIL INFORMATION --->
	<cfinclude template="detailInfo.cfm">
</td>
</tr>
<tr><td>&nbsp;</td></tr>

<tr>
	<td valign="top" class="textmain">
		Enter the <i>total</i> quantity of serial numbers that you want to replicate (including the one that you scanned), then click "Post".
	</td>
</tr>
<tr><td>&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	<form action="index.cfm?task=serials_shipments_replicate_act&RequestTimeout=6000" method="Post" name="detailform" onSubmit="return disableAllButtons()">

	<cfif isDefined("URL.QuantityError")>
		<tr>
			<td valign="top" class="textmain" colspan="2">
				<font color="FF0000">
					Please enter a numeric value in the quantity field:
				</font>
			</td>
		</tr>
	</cfif>
	<cfif isDefined("URL.TooMuchError")>
		<tr>
			<td valign="top" class="textmain" colspan="2">
				<font color="FF0000">
					The quantity to replicate cannot be greater than the remaining quantity (#RemainingQuantity#):
				</font>
			</td>
		</tr>
	</cfif>

	<tr>
		<td valign="top" class="textmain" width="30%"><b>Quantity:</b></td>
		<td valign="top" class="textmain">
			<input name="ReplicateQuantity" value="#RemainingQuantity#" size="10" maxlength="50">
		</td>
	</tr>

	<tr><td>&nbsp;</td></tr>
	<tr>
	<td valign="top" colspan="2" align="center">
		<table cellpadding="4" cellspacing="0" border="0" width="50%" align="center">
		<tr>
			<!--- "POST" BUTTON --->
			<td align="center">
				<input type="submit" name="ButtonClicked" value="Post" <!---onclick="return confirmPost()"--->>
			</td>
		</tr>
		</table>
	</td>
	</tr>
		
	</form>
	</table>

</td>
</tr>

</table>
</cfoutput>

<script language="JavaScript" type="text/JavaScript">
<!--
document.detailform['ReplicateQuantity'].focus(); document.detailform['ReplicateQuantity'].select();
-->
</script>