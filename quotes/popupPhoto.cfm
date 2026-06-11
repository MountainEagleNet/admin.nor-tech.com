<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	05/13/2009
	Function: 		Larger System Photo
	Template:		popupPhoto.cfm
	Task:			N/A
--->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
	<title>System Details</title>
    <link href="/techstyle.css" rel="stylesheet" type="text/css">
</head>
<body>


<script language="javascript">
	function printit() {
		window.print();
	}
</script>

<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>
<cfset objConfigComponents = createObject("component", "admin.assets.cfcs.config.ConfigComponents")>
<cfset objPartsAdmin = createObject("component", "admin.assets.cfcs.parts.PartsAdmin")>

<cfset Variables.PartnersLocation = "Partners">
<cfif findNoCase("TEST",APPLICATION.AdminLocation) NEQ 0>
	<cfset Variables.PartnersLocation = "PartnersTEST">
</cfif>

<cfoutput>

<cfset strResellerSystem = objConfigSystems.getRecord_Config(URL.ConfigSystemID)>

<form>
<table width="100%" cellspacing="0" cellpadding="2" border="0">

<!--- SYSTEM NAME --->
<tr>
    <td align="left" valign="middle" class="listSystemName">
        #strResellerSystem.Name#
    </td>
</tr>

<!--- DESCRIPTION --->
<tr>
    <td align="left" valign="top" class="listSystemDescription">
        #strResellerSystem.Description#
    </td>
</tr>
<tr><td>&nbsp;</td></tr>

<!--- SPECS --->
<tr>
    <td align="left" valign="top" class="listSystemDescription">
        #strResellerSystem.Specs#
    </td>
</tr>

<!--- PHOTO --->
<tr><td>&nbsp;</td></tr>
<tr>
	<td valign="top" align="center">
        <img src="https://partners.nor-tech.com/images/systems/#strResellerSystem.PhotoImage#"> 
   	</tr>                           
</tr>

<!--- VENDOR URL --->
<cfset MotherboardITEMO = objConfigComponents.getMotherBoardITEMNO(URL.ConfigSystemID)>
<cfset SystemITEMO = objConfigComponents.getSystemITEMNO(URL.ConfigSystemID)>

<cfset VendorURL = "">
<cfif MotherboardITEMO IS NOT "">
	<cfset VendorURL = objPartsAdmin.getVendorURL(MotherboardITEMO)>
<cfelseif SystemITEMO IS NOT "">
	<cfset VendorURL = objPartsAdmin.getVendorURL(SystemITEMO)>
</cfif>

<cfif VendorURL IS NOT "">
    <tr><td>&nbsp;</td></tr>
    <tr>
        <td valign="top" align="center" class="listSystemDescription">
        	<cfif MotherboardITEMO IS NOT "">
                <a href="#VendorURL#" target="_blank">Click Here</a> for details about the motherboard.
			<cfelse>
                <a href="#VendorURL#" target="_blank">Click Here</a> for additional details about the system.
            </cfif>                
        </tr>                           
    </tr>
</cfif>

<tr><td>&nbsp;</td></tr>

<!--- PRINT --->
<tr>
	<td align="center">
    	<input type="button" class="formButton" value="Print" onClick="printit()">
  	</td>
</tr>

<!--- CLOSE --->
<tr>
	<td align="center">
    	<input type="button" class="formButton" value="Close Window" onClick="self.close()">
  	</td>
</tr>

</table>
<br><br>
</form>
</cfoutput>

</body>
</html>