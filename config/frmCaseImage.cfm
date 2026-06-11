<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	09/27/2010
	Function: 		This page displays a form for selecting case images
	Template:		frmCaseImage.cfm	
	Task:			config_setup_components_caseimage_edit
--->

<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>
<cfset objConfigComponents = createObject("component", "admin.assets.cfcs.config.ConfigComponents")>
<cfset objConfigPhotos = createObject("component", "admin.assets.cfcs.config.ConfigPhotos")>

<cfif isDefined("URL.Validation")>
	<cfset stRecord = objConfigComponents.getDataRecord()>
	<cfset stErrors = objConfigComponents.getErrorRecord()>
<cfelse>
	<cfset stRecord = structNew()>
    <cfset stRecord.ConfigSystemID = URL.ConfigSystemID>
    <cfset stRecord.ConfigComponentCategoryID = URL.ConfigComponentCategoryID>
	<cfset stErrors = structNew()>
</cfif>	

<cfset qryConfigComponents = objConfigComponents.getCases(stRecord.ConfigSystemID)>

<cfset qryConfigPhotos = objConfigPhotos.listCasePhotos()>

<cfoutput>

<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

<tr><!--- Page Title --->
	<td valign="top" class="subpagetitle">Case Images</td>
</tr>

<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objConfigComponents.getMessage()#</font></td>
</tr>



<cfset strSystemName = objConfigSystems.getRecord_Config(stRecord.ConfigSystemID)>
<tr>
	<td>	
		<table cellpadding="2" cellspacing="0" width="100%" border="0">
			<tr>
				<td valign="middle" class="textmain" width="25%"><b>System Name:</b></td>
				<td valign="top" class="textmain">#strSystemName.Name#</td>
			</tr>
		</table>
	</td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
    <td valign="top" class="textmain">
        Select an image for each case:
    </td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain">
	<table cellpadding="2" cellspacing="4" width="100%" border="0">
	<form action="index.cfm?task=config_setup_components_caseimage_save&RequestTimeout=6000" method="Post" name="detailform">
	<input type="hidden" name="ConfigSystemID" value="#stRecord.ConfigSystemID#">
	<input type="hidden" name="ConfigComponentCategoryID" value="#stRecord.ConfigComponentCategoryID#">
	<cfset TabValue = 1>
    
    <cfset NumberImagesPerRow = 3>

	<cfloop query="qryConfigComponents">
	    <cfset CURRENTCase_ConfigPhotoID = qryConfigComponents.Case_ConfigPhotoID>
        <tr>
        	<td height="18" bgcolor="006633" class="productTitle" colspan="#(NumberImagesPerRow *2)#">
            	<font color="FFFFFF">#qryConfigComponents.Description#<br />(#qryConfigComponents.ITEMNO#)</font>
           	</td>
		</tr> 
        
		<!--- "PLEASE PICK AN IMAGE --->
		<cfset ErrorFieldName = "IMAGE|" & qryConfigComponents.ConfigComponentID>
		<cfif structKeyExists(stErrors, ErrorFieldName)>
			<cfset ErrorFieldValue = stErrors[ErrorFieldName]>
			<tr>
				<td valign="top" class="textmain" colspan="#(NumberImagesPerRow *2)#"><font color="FF0000">&raquo; #ErrorFieldValue#</font></td>
			</tr>
		</cfif>


        <tr>
        <cfset FieldName = "IMAGE|" & qryConfigComponents.ConfigComponentID>
        <cfloop query="qryConfigPhotos">
	    	<cfset CURRENTConfigPhotoID = qryConfigPhotos.ConfigPhotoID>
            
<!---       <cfset ImageFullPath = "..\partners\images\systems\" & qryConfigPhotos.PhotoImage>		--->
            <cfset ImageFullPath = "http://partners.nor-tech.com/images/systems/" & qryConfigPhotos.PhotoImage>
            
            <cfif (structKeyExists(stRecord, FieldName) AND stRecord[FieldName]IS CURRENTConfigPhotoID) OR
				  (CURRENTCase_ConfigPhotoID IS CURRENTConfigPhotoID)>
            	<cfset SelectThisPhoto = 1>
            <cfelse>
            	<cfset SelectThisPhoto = 0>
          	</cfif>
            
            <td
				<cfif isDefined("stErrors") AND structKeyExists(stErrors, ErrorFieldName)>
                    style="border-top: 2px solid red; border-left: 2px solid red; border-bottom: 1px solid red; border-right: 1px solid red;"
                </cfif>
            >
                <table cellpadding="2" cellspacing="4" width="100%" border="0">
                	<tr>

                        <td valign="middle" width="1%">
                            <input type="radio" name="#FieldName#" value="#CURRENTConfigPhotoID#"
                                <cfif SelectThisPhoto>checked</cfif>
                            >
                        </td>
                        <td valign="middle" class="textmain">
                            <img src="#ImageFullPath#" border="0">
                        </td>

                    </tr>
                </table>
            </td>
            
            <!--- Display 3 photos per row --->
            <cfif qryConfigPhotos.CurrentRow MOD NumberImagesPerRow is 0>
                </tr>
                <tr>
            </tr></cfif>
        </cfloop>    

		<tr><td colspan="#(NumberImagesPerRow *2)#"><hr /></td></tr>    
    </cfloop>


	<tr>
		<td valign="top" colspan="3" align="center">
			<table cellpadding="4" cellspacing="0" border="0" width="60%">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td align="right"><!--- "CONTINUE" BUTTON --->
					<input type="submit" name="ButtonClicked" value="&nbsp;Continue -&raquo;" tabindex="#TabValue#">
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