<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/05/2008
	Function: 		Remove parts from Price Lists that aren’t web-enabled in ACCPAC					
	Template:		frmWebDisabled.cfm
	Task:			config_pricelists_webdisabled_edit
--->
	<cfset objPriceLists = createObject("component", "admin.assets.cfcs.prices.PriceLists")>
</cfsilent>

<cfoutput>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objPriceLists.getMessage()#</font></td>
</tr>
<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr><!--- Instructions --->
	<td valign="top" class="textmain">
		Enter a part number in the box below, then click "Continue".  If the part has been "web-disabled" in ACCPAC 
		(by setting the "web-ready" field to NO), then that part will be removed from all price lists and all configurations.<br><br>
		
<!---	<font color="FF0000">Note:</font> This process will take a while to run.  Click the "Continue" button only once.	--->
	</td>
</tr>
<tr><td>&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
	<form action="index.cfm?task=config_pricelists_webdisabled_act&RequestTimeout=6000" method="Post" name="detailform">

	<cfif isDefined("URL.ErrorFound")>
		<tr>
			<td class="textmain">
				<font color="FF0000">
					<cfif URL.ErrorFound IS "Item_Not_Entered">
						Please enter an item number before clicking "Continue".
					<cfelseif URL.ErrorFound IS "Item_Not_Found">
						The item number you entered was not found in ACCPAC.  Please try again.
					<cfelseif URL.ErrorFound IS "Item_is_web_enabled">
						The item number you entered is not "web-disabled" in ACCPAC.  Please try again.
					</cfif>
				</font>
			</td>
		</tr>
	</cfif>

	<tr>
		<td valign="top" align="center">
			<table cellpadding="4" cellspacing="0" border="0" width="90%">
				<tr><td>&nbsp;</td></tr>
				<tr>
					<!--- ITEM NUMBER --->
					<td align="left" class="textmain" valign="middle">
						Item Number: 
						<input name="ITEMNO" size="20" 
							<cfif isDefined("URL.ITEMNO")>
								value="#URL.ITEMNO#"
							</cfif>
						 maxlength="50">
					</td>

					<!--- "CONTINUE" BUTTON --->
					<td align="right">
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