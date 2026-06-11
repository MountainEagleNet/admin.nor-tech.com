<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/31/2007
	Function: 		Add/Edit a Part
	Template:		frmPartsAdmin.cfm	
	Task:			parts_admin_new, parts_admin_edit
--->
<cfset objPartsAdmin = createObject("component", "admin.assets.cfcs.parts.PartsAdmin")>

<cfif isDefined("URL.Validation")>
	<cfset stRecord = objPartsAdmin.getDataRecord()>
	<cfset stErrors = objPartsAdmin.getErrorRecord()>
<cfelseif NOT isDefined("URL.PartsAdminID")>
	<cfset stRecord = objPartsAdmin.newRecord()>
	<cfset stErrors = structNew()>
<cfelse>
	<cfset stRecord = objPartsAdmin.getRecord(URL.PartsAdminID)>
	<cfset stErrors = structNew()>
</cfif>

<cfoutput>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">
		Edit/New Part
	</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objPartsAdmin.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="4" width="100%" border="0">
	<form action="index.cfm?task=parts_admin_save&RequestTimeout=6000" method="Post" name="detailform">
	<input type="hidden" name="PartsAdminID" value="#stRecord.PartsAdminID#">
	<cfset TabValue = 1>

	<!--- ITEMNO --->
	<cfif structKeyExists(stErrors, "ITEMNO")>
		<tr>
			<td>&nbsp;</td>
			<td valign="bottom" class="textmain"><font color="FF0000">&raquo; #stErrors.ITEMNO#</font></td>
		</tr>
	</cfif>
	<tr>
		<td valign="middle" class="textmain" width="33%"><b>Item Number:</b> *</td>
		<td valign="top" class="textmain">
			<input name="ITEMNO" size="35" maxlength="50" tabindex="#TabValue#" value="#stRecord.ITEMNO#" 
				<cfif structKeyExists(stErrors, "ITEMNO")>style="border:1px solid red;"</cfif>
			>
			<cfset TabValue = TabValue + 1>
		</td>
	</tr>

	<!--- ITEMDESC --->
	<input type="hidden" name="ITEMDESC" value="#stRecord.ITEMDESC#">
	<cfif stRecord.PartsAdminID IS NOT "">
		<tr>
			<td valign="top" class="textmain"><b>Description:</b></td>
			<td valign="top" class="textmain">#stRecord.ITEMDESC#</td>
		</tr>
	</cfif>

	<!--- GarageSale --->
	<tr>
		<td valign="middle" class="textmain"><b>Nor-Tech Closeout Specials Item?</b></td>
		<td valign="top" class="textmain">
			<input type="checkbox" name="GarageSale" value="1" tabindex="#TabValue#"
				<cfif stRecord.GarageSale EQ 1>
					checked
				</cfif>
			>
			<cfset TabValue = TabValue + 1>
		</td>
	</tr>

	<!--- SellPrice --->
	<cfif structKeyExists(stErrors, "SellPrice")>
		<tr>
			<td>&nbsp;</td>
			<td valign="bottom" class="textmain"><font color="FF0000">&raquo; #stErrors.SellPrice#</font></td>
		</tr>
	</cfif>
	<tr>
		<td valign="middle" class="textmain"><b>Selling Price ($):</b></td>
		<td valign="bottom" class="textmain">
			<input name="SellPrice" size="5" maxlength="50" tabindex="#TabValue#" value="#stRecord.SellPrice#" 
				<cfif structKeyExists(stErrors, "SellPrice")>style="border:1px solid red;"</cfif>
			>
			<cfset TabValue = TabValue + 1>
		</td>
	</tr>
	
	<!--- VendorURL --->
	<cfif structKeyExists(stErrors, "VendorURL")>
		<tr>
			<td>&nbsp;</td>
			<td valign="bottom" class="textmain"><font color="FF0000">&raquo; #stErrors.VendorURL#</font></td>
		</tr>
	</cfif>
	<tr>
		<td valign="middle" class="textmain"><b>Vendor Website / URL:</b></td>
		<td valign="top" class="textmain">
			<input name="VendorURL" size="50" maxlength="200" tabindex="#TabValue#" value="#stRecord.VendorURL#" 
				<cfif structKeyExists(stErrors, "VendorURL")>style="border:1px solid red;"</cfif>
			>
			<cfset TabValue = TabValue + 1>
		</td>
	</tr>
	<cfif trim(stRecord.VendorURL) IS NOT "">
		<tr>
			<td valign="middle" class="textmain">&nbsp;</b></td>
			<td valign="top" class="textmain">
				<a target="_blank" href="#trim(stRecord.VendorURL)#">
					#trim(stRecord.VendorURL)#
				</a>
			</td>
		</tr>
	</cfif>
	
	<!--- Inactive --->
	<tr>
		<td valign="middle" class="textmain"><b>Inactive?</b></td>
		<td valign="top" class="textmain">
			<input type="checkbox" name="Inactive" value="1" tabindex="#TabValue#"
				<cfif stRecord.Inactive EQ 1>
					checked
				</cfif>
			>
			<cfif stRecord.Inactive EQ 1 AND isDate(stRecord.DateInactive)>
				<i>(made inactive on #dateFormat(stRecord.DateInactive, 'mm/dd/yyyy')#)</i>
			</cfif>
			<cfset TabValue = TabValue + 1>
		</td>
	</tr>
	
	<tr>
	<td valign="top" colspan="2" align="center">
		<table cellpadding="4" cellspacing="0" border="0" width="80%">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center"><!--- "SAVE" BUTTON --->
				<input type="submit" name="ButtonClicked" value="Save" tabindex="#TabValue#">
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

<cfif structKeyExists(stErrors, "ITEMNO")>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['ITEMNO'].focus(); document.detailform['ITEMNO'].select()
	-->
	</script>
<cfelseif structKeyExists(stErrors, "SellPrice")>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['SellPrice'].focus(); document.detailform['SellPrice'].select()
	-->
	</script>
<cfelse>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['ITEMNO'].focus();
	-->
	</script>
</cfif>	