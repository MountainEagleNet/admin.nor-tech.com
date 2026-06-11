<cfsilent>
	<!---
	Coded By: 		Alternative Systems, Inc -  Ron Barth
	Create Date: 	01/30/2009
	Template:		frmFreightEst.cfm 
	--->
	<cfset objComponent = createObject("component", "admin.assets.cfcs.Component")>
	<cfset objConfigComponentsResellers = createObject("component", "admin.assets.cfcs.config.ConfigComponentsResellers")>

	<cfset qryResellers = objConfigComponentsResellers.listResellersForSalesRep()>

</cfsilent>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Display Message --->
	<td colspan="2" valign="top" class="textmain"><font color="FF0000">#objComponent.getMessage()#</font></td>
</tr>

<!--- spacer --->
<tr>
	<td class="textsmall">&nbsp;</td>
</tr>

<tr><!--- Instructions --->
	<td colspan="2" valign="top" class="textmain">This function allows you to set the UPS Freight Estimator function for all of your customers.  Check one of the radio buttons below, then click "Continue"</td>
</tr>
<tr><td>&nbsp;</td></tr>

<cfset TabValue = 1>

<form name="DetailForm" action="index.cfm?task=admin_freightestimator_act" method="post">
    <tr>
        <td colspan="2" class="textmain" align="left">
            <input type="radio" name="FreightEstimatorFunction" value="TurnOn" tabindex="#TabValue#"> Turn the function ON for all of your resellers <br />
			<cfset TabValue = TabValue + 1>
            <input type="radio" name="FreightEstimatorFunction" value="TurnOff"tabindex="#TabValue#"> Turn the function OFF for all of your resellers <br />
			<cfset TabValue = TabValue + 1>
            <input type="radio" name="FreightEstimatorFunction" value="Pick"tabindex="#TabValue#"> Turn the function on only for resellers that are checked below
			<cfset TabValue = TabValue + 1>
        </td>
    </tr>
    
	<!--- LIST HEADINGS --->
	<tr>
		<td colspan="2" height="18" bgcolor="006633" class="productTitle"><font color="FFFFFF">Resellers</font></td>
	</tr>
	
	<!--- DATA --->
	<cfif qryResellers.RecordCount EQ 0>
		<tr>
			<td align="center" colspan="2" class="productTitle"><font color="FF0000">You have no Resellers defined.</font></td>
		</tr>
	</cfif>

	<cfloop query="qryResellers">
	
		<cfset ResellerIsAssigned = 0>
        <cfif qryResellers.FreightEstimator EQ 1>
			<cfset ResellerIsAssigned = 1>
        </cfif>
		<tr<cfif qryResellers.CurrentRow mod 2> style="background-color:##e5e5e6"</cfif>>
			<td class="textsmall" width="10%" align="center">
				<!--- Assigned CheckBox --->
				<input type="checkbox" name="RESELLER|#qryResellers.CustomerID#" value="1" tabindex="#TabValue#"
					<cfif ResellerIsAssigned>
						checked
					</cfif>
				>
				<cfset TabValue = TabValue + 1>
			</td>
			<td class="textsmall">
				#qryResellers.Company#
			</td>
		</tr>
	</cfloop>

    <tr>
        <!--- "CONTINUE" BUTTON --->
        <td colspan="2" align="center">
            <input type="submit" value="Continue" tabindex="#TabValue#">
        </td>
    </tr>
</form>
</table>
</cfoutput>