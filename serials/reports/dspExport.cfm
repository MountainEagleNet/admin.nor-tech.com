<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	07/20/2007
	Function: 		Export Serial Numbers to Excel - Display Page
	Template:		dspExport.cfm
	Task:			serials_reports_dspExport
--->
<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>

<cfset stFormCopy = objSerialsShipments.getDataRecord()>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<tr><!--- Display Message --->
	<td valign="top" class="textmain"><font color="FF0000">#objSerialsShipments.getMessage()#</font></td>
</tr>
<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>
<tr>
	<td class="textmain" style="font-size:16px; color:0033CC" height="18">
		<strong>Export Serial Numbers to Excel</strong>
	<td>
</tr>

<tr><!--- Instructions --->
	<td valign="top" class="textmain">
			The Export Process ran successfully.
	</td>
</tr>
<tr><td>&nbsp;</td></tr>

</table>


	<cfset qrySerialNumbers = objSerialsShipments.findSerialNumbersForExport(stFormCopy)>

	<cfset textHeader = "COA#chr(10)#">

	<!--- loop over all serial numbers --->
	<cfloop query="qrySerialNumbers">
		<cfoutput>
			<!--- header file --->
			<cfsavecontent variable="tmpHeader">#qrySerialNumbers.SerialNumber##chr(13)##chr(10)#</cfsavecontent>
			<cfset textHeader = textHeader & tmpHeader>
		</cfoutput>
	</cfloop>
	
	<cfset TempUUID = createUUID()>
	
	<!--- create the files --->
	<cffile action="write" file="c:\wwwexport\SNExport-#TempUUID#.csv" output="#textHeader#">
	
	<cfheader name="Content-Disposition" value="attachment; filename=c:\wwwexport\SNExport-#TempUUID#.csv" />
	<cfcontent type="text/plain" file="c:\wwwexport\SNExport-#TempUUID#.csv" />	
</cfoutput>	