<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/19/2006
	Function: 		This page displays a form for assigning systems to a reseller
	Template:		frmAssignSystems.cfm	
	Task:			admin_reseller_systems_edit
--->
<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>
<cfset objCust = createObject("component", "admin.assets.cfcs.Cust")>
<cfset objResellerSystems = createObject("component", "admin.assets.cfcs.config.ResellerSystems")>

<cfset qrylogin = objCust.getRecordAsQueryByCustomerID(URL.CustomerID)>

<cfset SearchRecord = structNew()>
<cfset structInsert(SearchRecord, "DefaultSystem", 0, True)>
<cfset structInsert(SearchRecord, "UserID", objConfigSystems.getSessionValue("adminuserid"), True)>
<cfset qryConfigSystems = objConfigSystems.searchRecords(SearchRecord, "query", "TypeSortOrder, Name")>

<cfset qryResellerSystems = objResellerSystems.listRecordsForParent("CustomerID", qrylogin.CustomerID)>

<script language="JavaScript">
	function checkAll (currField)
	{
		for (i=0;i<currField.length;i++)
    	currField[i].checked=true;
	}
	function uncheckAll (currField)
	{
		for (i=0;i<currField.length;i++)
    	currField[i].checked=false;
	}
	function doCheck (currField,checkfield)
	{
		if (checkfield.checked == true)
		{
			checkAll(currField);
		}
		else
		{
			uncheckAll(currField);
		}
	}
</script>

<cfoutput>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">Reseller's Assigned Systems</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objResellerSystems.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
	<td>	
		<table cellpadding="2" cellspacing="0" width="100%" border="0">
			<tr>
				<td valign="middle" class="textmain" width="30%"><b>Company:</b></td>
				<td valign="top" class="textmain">#qrylogin.Company#</td>
			</tr>
			<tr>
				<td valign="middle" class="textmain"><b>Account Number:</b></td>
				<td valign="top" class="textmain">#qrylogin.AcctNo#</td>
			</tr>
		</table>
	</td>
</tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	<form action="index.cfm?task=admin_reseller_systems_save&RequestTimeout=6000" method="Post" name="detailform">
	<input type="hidden" name="CustomerID" value="#qrylogin.CustomerID#">
	<cfset TabValue = 1>

    <tr>
        <td colspan="3" class="textmain">
        	<input type="checkbox" name="handleChecks" value="1" onClick="javascript: doCheck(document.detailform.SystemList,document.detailform.handleChecks)">
            &nbsp;Select All Systems
      	</td>
    </tr>
	
	<!--- LIST HEADINGS --->
	<tr>
		<td height="18" bgcolor="006633" class="productTitle" width="10%"><font color="FFFFFF">&nbsp;</font></td>
		<td height="18" bgcolor="006633" class="productTitle" width="25%"><font color="FFFFFF">System Type</font></td>
		<td height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">System Name</font></td>
	</tr>
	
	<!--- DATA --->
	<cfif qryConfigSystems.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="3" class="productTitle"><font color="FF0000">You have no systems defined.</font></td>
		</tr>
	</cfif>

	<cfloop query="qryConfigSystems">
	
		<cfset SystemIsAssigned = 0>
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "CustomerID", qrylogin.CustomerID, True)>
		<cfset structInsert(SearchRecord, "ConfigSystemID", qryConfigSystems.ConfigSystemID, True)>
		<cfset qryResellerSystems = objResellerSystems.searchRecords(SearchRecord, "query")>
		<cfif qryResellerSystems.RecordCount NEQ 0>
			<cfset SystemIsAssigned = 1>
		</cfif>
	
		<tr<cfif qryConfigSystems.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
			<td class="textsmall">
				<!--- Assigned CheckBox --->
<!---                
				<input type="checkbox" name="SYS_#qryConfigSystems.ConfigSystemID#" value="1" tabindex="#TabValue#"
					<cfif SystemIsAssigned>
						checked
					</cfif>
				>
				<cfset TabValue = TabValue + 1>
--->                
                <input type="checkbox" name="SystemList" value="#qryConfigSystems.ConfigSystemID#" tabindex="#TabValue#"
					<cfif SystemIsAssigned>
						checked
					</cfif>
                 />
				<cfset TabValue = TabValue + 1>
			</td>
			<td class="textsmall">
				#qryConfigSystems.Type#
			</td>
			<td class="textsmall">
				#qryConfigSystems.Name#
			</td>
		</tr>
	</cfloop>

	<tr>
		<td valign="top" colspan="3" align="center">
			<table cellpadding="4" cellspacing="0" border="0" width="100%">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td align="center"><!--- "CONTINUE" BUTTON --->
					<input type="submit" name="ButtonClicked" value="&nbsp;Continue -&raquo;" tabindex="#TabValue#">
				</td>
			</tr>
			<tr>
				<td class="textmain" align="center">
					<em><font color="##FF0000">
                    	<strong>PLEASE NOTE</strong>: Depending on the number of systems assigned to this reseller,<br />
                        this process could take a while after you click 'CONTINUE'.<br />
                        Please be patient!
                  	</font></em>
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