<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/21/2006
	Function: 		This page displays the administration menu
	Template:		menuAdmin.cfm
	Task:			serials_admin_menu
--->

<cfoutput>
<table width="500" border="0" align="center" cellpadding="3" cellspacing="1">

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr><td class="textleftnav" style="font-size:14px"><strong><em>Serialization System</em></strong></td></tr>

<tr>
	<td valign="top" class="textmain">
		<a href="index.cfm?task=serials_admin_batch_list">
			Batch Number Item List
		</a>
	</td>
</tr>

<tr>
	<td valign="top" class="textmain">
		<a href="index.cfm?task=serials_admin_batch2_list">
			Batch 2 Item List
		</a>
	</td>
</tr>

<tr>
	<td valign="top" class="textmain">
		<a href="index.cfm?task=serials_admin_barcode_list">
			Print Bar Code Labels List
		</a>
	</td>
</tr>

<tr>
	<td valign="top" class="textmain">
		<a href="index.cfm?task=serials_admin_virtual_list">
			Virtual Items List
		</a>
	</td>
</tr>

<tr>
	<td valign="top" class="textmain">
		<a href="index.cfm?task=serials_admin_create_enter">
			Create Serial Numbers and Bar Code Labels
		</a>
	</td>
</tr>

<tr><td>&nbsp;</td></tr>

<tr>
	<td valign="top" class="textmain">
		<a href="index.cfm?task=serials_admin_SW_list">
			Software Excluded Items List
		</a>
	</td>
</tr>
<tr>
	<td valign="top" class="textmain">
		<a href="index.cfm?task=serials_admin_compbuild_list">
			Comp Build Items List
		</a>
	</td>
</tr>

<tr><td>&nbsp;</td></tr>

<tr>
	<td valign="top" class="textmain">
		<a href="index.cfm?task=serials_admin_orphans_form&RequestTimeout=6000">
			Delete Orphaned Serial Numbers
		</a>
	</td>
</tr>


<tr><td>&nbsp;</td></tr>
<cfif SESSION.Role IS "Administrator">
    <tr><td class="textleftnav" style="font-size:14px"><strong><em>Configurator</em></strong></td></tr>
    <tr>
        <td valign="top" class="textmain">
            <a href="index.cfm?task=serials_admin_ACCPACDescriptions_form&RequestTimeout=6000">
                Update component descriptions from ACCPAC
            </a>
        </td>
    </tr>
</cfif>

<!--- Future administration menu options will go here --->

</table>
</cfoutput>