<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	07/20/2007
	Function: 		Export Serial Numbers to Excel - Action page
	Template:		actExport.cfm
	Task:			serials_reports_actExport
--->
<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>
<cfset stFormCopy = duplicate(FORM)>

<cfset stErrors = objSerialsShipments.validate_Export(stFormCopy)>

<cfif structIsEmpty(stErrors)>
	<cfset qrySerialNumbers = objSerialsShipments.findSerialNumbersForExport(stFormCopy)>
	<cfif qrySerialNumbers.RecordCount EQ 0>
		<cfset structInsert(stErrors, "NoneFound", "No serial numbers were found for the criteria you entered", True)>
	</cfif>
</cfif>
	
<cfif NOT structIsEmpty(stErrors)>
	<cfset objSerialsShipments.setDataRecord(stFormCopy)>
	<cfset objSerialsShipments.setErrorRecord(stErrors)>
	<cfset objSerialsShipments.setMessage("Please correct the fields indicated below.")>
	<cflocation url="index.cfm?task=serials_reports_frmExport&Validation=1">
<cfelse>
<!---<cfset objSerialsShipments.setDataRecord(stFormCopy)>--->
<!---<cflocation url="index.cfm?task=serials_reports_dspExport">--->
		
	<cfset textHeader = "COA#chr(10)#">

	<!--- loop over all serial numbers --->
	<cfloop query="qrySerialNumbers">
		<cfoutput>
			<!--- header file --->
			<cfsavecontent variable="tmpHeader">'#qrySerialNumbers.SerialNumber#'#chr(13)##chr(10)#</cfsavecontent>
			<cfset textHeader = textHeader & tmpHeader>
		</cfoutput>
	</cfloop>
	
<cfoutput>textHeader:#textHeader#</cfoutput>



	<cfset TempUUID = createUUID()>
	
	<!--- create the files --->
	<cffile action="write" file="c:\wwwexport\SNExport-#TempUUID#.csv" output="#textHeader#">
		
	<cfheader name="Content-Disposition" value="attachment; filename=c:\wwwexport\SNExport-#TempUUID#.csv" />
	<cfcontent type="text/plain" file="c:\wwwexport\SNExport-#TempUUID#.csv" />

</cfif>