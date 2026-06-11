<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	12/28/2009
	Function: 		Add/Edit an AdditionalWarranty
	Template:		frmadditionalwarranty.cfm	
	Task:			additionalwarranty_new, additionalwarranty_edit
--->
<cfset objAdditionalWarranty = createObject("component", "admin.assets.cfcs.config.AdditionalWarranty")>

<cfif isDefined("URL.Validation")>
	<cfset stRecord = objAdditionalWarranty.getDataRecord()>
	<cfset stErrors = objAdditionalWarranty.getErrorRecord()>
<cfelseif NOT isDefined("URL.AdditionalWarrantyID")>
	<cfset stRecord = objAdditionalWarranty.newRecord()>
	<cfset stErrors = structNew()>
<cfelse>
	<cfset stRecord = objAdditionalWarranty.getRecord(URL.AdditionalWarrantyID)>
	<cfset stErrors = structNew()>
</cfif>


<cfoutput>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">
		Edit/New Depot Warranty
	</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objAdditionalWarranty.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="4" width="100%" border="0">
	<form action="index.cfm?task=additionalwarranty_save&RequestTimeout=6000" method="Post" name="detailform">
	<input type="hidden" name="AdditionalWarrantyID" value="#stRecord.AdditionalWarrantyID#">
	<cfset TabValue = 1>

	<!--- Name --->
	<cfif structKeyExists(stErrors, "Name")>
		<tr>
			<td>&nbsp;</td>
			<td valign="bottom" class="textmain"><font color="FF0000">&raquo; #stErrors.Name#</font></td>
		</tr>
	</cfif>
	<tr>
		<td valign="middle" class="textmain" width="30%"><b>Name:</b> *</td>
		<td valign="top" class="textmain">
			<input name="Name" size="35" maxlength="50" tabindex="#TabValue#" value="#stRecord.Name#" 
				<cfif structKeyExists(stErrors, "Name")>style="border:1px solid red;"</cfif>
			>
			<cfset TabValue = TabValue + 1>
		</td>
	</tr>

	<!--- PercentMarkUp --->
	<cfif structKeyExists(stErrors, "PercentMarkUp")>
		<tr>
			<td>&nbsp;</td>
			<td valign="bottom" class="textmain"><font color="FF0000">&raquo; #stErrors.PercentMarkUp#</font></td>
		</tr>
	</cfif>
	<tr>
		<td valign="middle" class="textmain"><b>Percent Mark-Up:</b> *</td>
		<td valign="top" class="textmain">
			<input name="PercentMarkUp" size="10" maxlength="50" tabindex="#TabValue#" value="#stRecord.PercentMarkUp#" 
				<cfif structKeyExists(stErrors, "PercentMarkUp")>style="border:1px solid red;"</cfif>
			> %
			<cfset TabValue = TabValue + 1>
		</td>
	</tr>
    <tr>
    	<td>&nbsp;</td>
        <td class="textmain" align="left" style="color:666; font-style:italic">
            <strong>NOTE:</strong>	Enter the percentage as an integer.<br />For example, enter "10" for 10%
        </td>
    </tr>
    

	<!--- SortOrder --->
	<cfif structKeyExists(stErrors, "SortOrder")>
		<tr>
			<td>&nbsp;</td>
			<td valign="bottom" class="textmain"><font color="FF0000">&raquo; #stErrors.SortOrder#</font></td>
		</tr>
	</cfif>
	<tr>
		<td valign="middle" class="textmain"><b>Sort Order:</b> *</td>
		<td valign="top" class="textmain">
			<input name="SortOrder" size="5" maxlength="50" tabindex="#TabValue#" value="#stRecord.SortOrder#" 
				<cfif structKeyExists(stErrors, "SortOrder")>style="border:1px solid red;"</cfif>
			>
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

<cfif structKeyExists(stErrors, "Name")>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['Name'].focus(); document.detailform['Name'].select()
	-->
	</script>
<cfelseif structKeyExists(stErrors, "PercentMarkUp")>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['PercentMarkUp'].focus(); document.detailform['PercentMarkUp'].select()
	-->
	</script>
<cfelseif structKeyExists(stErrors, "SortOrder")>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['SortOrder'].focus(); document.detailform['SortOrder'].select()
	-->
	</script>
<cfelse>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.detailform['Name'].focus();
	-->
	</script>
</cfif>	