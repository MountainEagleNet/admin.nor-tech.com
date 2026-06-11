<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	10/09/2008
	Function: 		This page displays a form for delete a component from all of a sales rep's systems.
	Template:		frmBulkDelete2.cfm	
	Task:			config_setup_bulkdelete_frm2
--->

<cfset objComponentCategories = createObject("component", "admin.assets.cfcs.config.ComponentCategories")>

<cfset strBulkComponent1 = objComponentCategories.getSessionValue("BulkComponent1")>

<cfset Category = objComponentCategories.getCategory(strBulkComponent1.DeleteComponent)>

<cfset SearchRecord = structNew()>
<cfset structInsert(SearchRecord, "CATEGORY", Category, True)>
<cfset qryComponentCategories = objComponentCategories.searchRecords(SearchRecord, "query", "SortOrder", 1)>

<cfif isDefined("URL.Validation")>
	<cfset stRecord = objComponentCategories.getSessionValue("BulkComponent2")>
	<cfset stErrors = objComponentCategories.getErrorRecord()>
<cfelse>
	<cfset stRecord = structNew()>
    <cfloop query="qryComponentCategories">
    	<cfset structInsert(stRecord, "CAT|#qryComponentCategories.ComponentCategoryID#", 1, True)>
    </cfloop>
	<cfset stErrors = structNew()>
</cfif>

<script language="javascript">
	function disableButton() {
		document.detailform.ButtonClicked.disabled = true;
		window.document.detailform.submit();
	}
</script>


<cfoutput>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">
		Delete System Component
	</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objComponentCategories.getMessage()#</font></td>
</tr>

<tr>
	<td valign="top" class="textmain">
    	The component you chose to delete, #strBulkComponent1.DeleteComponent#, is associated with the following categories.  Check the categories that you want to delete this component from, then click "Delete Component".<br />
        This function will delete this component from all of the categories that you check below, in all of the configurations you selected on the previous page.<br />
    </td>
</tr>    

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="4" width="100%" border="0">
	<form action="index.cfm?task=config_setup_bulkdelete_act2&RequestTimeout=6000" method="Post" name="detailform">
	<cfset TabValue = 1>

    <tr>
    <td valign="top" class="textmain" colspan="2">
        <table cellpadding="2" cellspacing="0" width="100%" border="0">
        
		<cfif structKeyExists(stErrors, "Categories")>
            <tr>
                <td colspan="3" valign="bottom" class="textmain"><font color="FF0000">&raquo; #stErrors.Categories#</font></td>
            </tr>
        </cfif>
        
        
        <!--- LIST HEADINGS --->
        <tr>
            <td height="18" bgcolor="006633" class="productTitle" width="10%"><font color="FFFFFF">&nbsp;</font></td>
            <td height="18" bgcolor="006633" class="productTitle" width="25%"><font color="FFFFFF">Category</font></td>
        </tr>
        
        <!--- DATA --->
        <cfif qryComponentCategories.RecordCount EQ 0>
            <tr>
                <td align="center" colspan="3" class="productTitle"><font color="FF0000">There are no categories associated with this part number.</font></td>
            </tr>
        </cfif>
    
        <cfloop query="qryComponentCategories">
			<cfset FieldName = "CAT|" & qryComponentCategories.ComponentCategoryID>
            <tr<cfif qryComponentCategories.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
                <td class="textsmall">
                    <!--- Assigned CheckBox --->
                    <input type="checkbox" name="#FieldName#" value="1" tabindex="#TabValue#"
                        <cfif structKeyExists(stRecord, FieldName)>
                            checked
                        </cfif>
                    >
                    <cfset TabValue = TabValue + 1>
                </td>
                <td class="textsmall">
                    #qryComponentCategories.Name#
                </td>
            </tr>
        </cfloop>
    
        </table>
    </td>
    </tr>

	<tr>
	<td valign="top" colspan="2" align="right">
		<table cellpadding="4" cellspacing="0" border="0" width="100%">
		<tr>
			<td align="center"><!--- "Delete Component" BUTTON --->
				<input type="submit" name="ButtonClicked" value="Delete Component" tabindex="#TabValue#" onclick="return disableButton()">
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