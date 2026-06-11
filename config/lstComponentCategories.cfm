<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/16/2007
	Function: 		This page displays a list of selected categories
	Template:		lstComponentCategories.cfm	
	Task:			config_setup_categories_list
--->
<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>
<cfset objConfigComponentCategories = createObject("component", "admin.assets.cfcs.config.ConfigComponentCategories")>

<cfset strConfigSystem = objConfigSystems.getRecord(URL.ConfigSystemID, "struct")>

<cfset qryConfigComponentCategories = objConfigComponentCategories.listRecordsForParent("ConfigSystemID", URL.ConfigSystemID, "CategorySortOrder")>

<cfset isMaintainedByDefault = objConfigSystems.isMaintainedByDefault(URL.ConfigSystemID)>

<cfoutput>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">Category List</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objConfigComponentCategories.getMessage()#</font></td>
</tr>

<tr>
	<td valign="top" class="textmain">
		This page lists all Component Categories that were selected for this system.  Click a category name to view<cfif NOT isMaintainedByDefault>/assign</cfif> components for that category.  When done<cfif NOT isMaintainedByDefault> picking components</cfif>, click "Continue" to go to the Default Component Selection Page.
	</td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<td>	
		<table cellpadding="2" cellspacing="0" width="100%" border="0">
			<tr>
				<td valign="middle" class="textmain" width="20%"><b>System Name:</b></td>
				<td valign="top" class="textmain">#strConfigSystem.Name#</td>
			</tr>
		</table>
	</td>
</tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	<form action="index.cfm?task=config_setup_categories_list_act" method="Post" name="detailform">
	<input type="hidden" name="ConfigSystemID" value="#strConfigSystem.ConfigSystemID#">

	<!--- LIST HEADINGS --->
	<tr>
		<td height="18" bgcolor="006633" class="productTitle" colspan="2"><font color="FFFFFF">Component Categories</font></td>
	</tr>
	
	<!--- DATA --->
	<cfif qryConfigComponentCategories.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="2" class="productTitle"><font color="FF0000">There are no Component Categories defined for this System.</font></td>
		</tr>
	</cfif>
<!---
qryConfigComponentCategories:<cfdump var="#qryConfigComponentCategories#"><br />
--->
	<cfloop query="qryConfigComponentCategories">
	
		<tr<cfif qryConfigComponentCategories.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
			<td class="textsmall">
            	<cfif qryConfigComponentCategories.CategoryName IS "EnergyStar" OR 
					 (qryConfigComponentCategories.CategoryName IS "Power Supply" AND 
					  objConfigSystems.isPowerSupplyAutoSelect(strConfigSystem.ConfigSystemID))>
                        #qryConfigComponentCategories.CategoryName#
            	<cfelseif qryConfigComponentCategories.isAdditionalWarranty IS NOT "1">
                    <a href="index.cfm?task=config_setup_components_edit&ConfigSystemID=#urlEncodedFormat(URL.ConfigSystemID)#&ConfigComponentCategoryID=#urlEncodedFormat(qryConfigComponentCategories.ConfigComponentCategoryID)#&RequestTimeout=6000">
                        #qryConfigComponentCategories.CategoryName#
                    </a>
                <cfelse>
                    <a href="index.cfm?task=config_setup_warranty_edit&ConfigSystemID=#urlEncodedFormat(URL.ConfigSystemID)#&ConfigComponentCategoryID=#urlEncodedFormat(qryConfigComponentCategories.ConfigComponentCategoryID)#&RequestTimeout=6000">
                        #qryConfigComponentCategories.CategoryName#
                    </a>
                </cfif>
			</td>
		</tr>
	</cfloop>

	<tr>
		<td valign="top" colspan="2" align="center">
			<table cellpadding="4" cellspacing="0" border="0" width="60%">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td align="right"><!--- "CONTINUE" BUTTON --->
					<input type="submit" name="ButtonClicked" value="&nbsp;Continue -&raquo;">
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