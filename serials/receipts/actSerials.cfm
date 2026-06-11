<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	04/21/2006
	Function: 		Action page, executed when any of the buttons is clicked on the serial number page
	Template:		actSerials.cfm
	Task:			serials_receipts_serials_act
--->

<cfsetting requesttimeout="12000">

<cfset objSerialsReceipts = createObject("component", "admin.assets.cfcs.SerialsReceipts")>
<cfset objSerialBatch2 = createObject("component", "admin.assets.cfcs.SerialBatch2")>

<cfif isDefined("URL.ConsecutiveOrder3")>
	<cfset stFormCopy = objSerialsReceipts.getDataRecord()>
<cfelse>
	<cfset stFormCopy = duplicate(FORM)>
</cfif>



<!---stFormCopy:<cfdump var="#stFormCopy#"><br>--->


<!--- If this is a "Batch 2" Item, strip all non-numeric characters from the serial numbers --->
<cfset stFormCopy = objSerialBatch2.formatSerialNumbers(stFormCopy)>

<cfparam name="stFormCopy.PrintBarCodeLabels" default="">

<cfif NOT isDefined("stFormCopy.WhichButton")>
	<cflocation url="index.cfm?task=serials_receipts_serials_edit&RCPHSEQ=#urlEncodedFormat(stFormCopy.RCPHSEQ)#&RCPLREV=#urlEncodedFormat(stFormCopy.RCPLREV)#">
</cfif>


<!--- REPLICATE was clicked --->
<cfif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Replicate">
	<!--- Make sure the first SN box is not empty --->
	<cfset stErrors = objSerialsReceipts.validateReplicate(stFormCopy)>
	<cfset objSerialsReceipts.setDataRecord(stFormCopy)>
	<cfset objSerialsReceipts.setErrorRecord(stErrors)>
	<cfif NOT structIsEmpty(stErrors)>
		<cflocation url="index.cfm?task=serials_receipts_serials_edit&Validation=1">
	<cfelse>
		<cfset structInsert(stFormCopy, "EndBoxNumber", stFormCopy.RQRECEIVED, True)>
		<cfset stFormCopy = objSerialsReceipts.replicate(stFormCopy)>
		<cfset structInsert(stFormCopy, "WhichButton", "Post", True)>
		<cfset structInsert(stFormCopy, "ReadyToPost", 1, True)>
		<cfset objSerialsReceipts.setDataRecord(stFormCopy)>
	</cfif>
</cfif>

<!--- CONSECUTIVE ORDER was clicked --->
<cfif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Consecutive Order">
	<!--- Make sure no serial number boxes are filled in --->
	<cfset stErrors = objSerialsReceipts.validateConsecutiveOrder(stFormCopy)>
	<cfset objSerialsReceipts.setDataRecord(stFormCopy)>
	<cfset objSerialsReceipts.setErrorRecord(stErrors)>
	<cfif NOT structIsEmpty(stErrors)>
		<cflocation url="index.cfm?task=serials_receipts_serials_edit&Validation=1">
	<cfelse>
		<cflocation url="index.cfm?task=serials_receipts_serials_edit&ConsecutiveOrder=1">
	</cfif>

<!--- CONSECUTIVE ORDER 2 was clicked --->
<cfelseif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Consecutive Order 2">
	<!--- Make sure the last SN box filled contains a numeric value --->
	<cfset stErrors = objSerialsReceipts.validateConsecutiveOrder2(stFormCopy)>
	<cfset objSerialsReceipts.setDataRecord(stFormCopy)>
	<cfset objSerialsReceipts.setErrorRecord(stErrors)>
	<cfif NOT structIsEmpty(stErrors)>
		<cflocation url="index.cfm?task=serials_receipts_serials_edit&Validation=1">
	<cfelse>
		<cflocation url="index.cfm?task=serials_receipts_consec_qty">
	</cfif>

<!--- CONSECUTIVE ORDER 3 was clicked --->
<cfelseif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Consecutive Order 3">
	<!--- Make sure all SN boxes are blank --->
	<cfset stErrors = objSerialsReceipts.validateConsecutiveOrder(stFormCopy)>
	<cfset objSerialsReceipts.setDataRecord(stFormCopy)>
	<cfset objSerialsReceipts.setErrorRecord(stErrors)>
	<cfif NOT structIsEmpty(stErrors)>
		<cflocation url="index.cfm?task=serials_receipts_serials_edit&Validation=1">
	<cfelse>
		<cflocation url="index.cfm?task=serials_receipts_consec3_qty">
	</cfif>

<!--- CLEAR DUPLICATES was clicked --->
<cfelseif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Clear Duplicates">
	<cfset stErrors = objSerialsReceipts.getErrorRecord()>
	<cfset stRecord = objSerialsReceipts.getDataRecord()>
	<cfset lstErrors = structKeyList(stErrors)>
	<cfloop list="#lstErrors#" index="SNColumn">
		<cfif findNoCase("SN_", SNColumn) NEQ 0>
			<cfset structInsert(stRecord, SNColumn, "", True)>
		</cfif>
	</cfloop>
	<cfset stErrors = structNew()>
	<cfset objSerialsReceipts.setDataRecord(stRecord)>
	<cfset objSerialsReceipts.setErrorRecord(stErrors)>
	<cflocation url="index.cfm?task=serials_receipts_serials_edit&Validation=1">

<!--- SAVE & POSTPONE was clicked --->
<cfelseif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Save & Postpone">
	<cfset objSerialsReceipts.saveSerialNumberInput(stFormCopy)>
	<cfset objSerialsReceipts.setMessage("Serial Numbers were successfully saved (but not posted).")>
	<cflocation url="index.cfm?task=serials_receipts_list">

<!--- CLEAR ALL was clicked --->
<cfelseif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Clear All">
	<cfset objSerialsReceipts.setDataRecord(stFormCopy)>
	<cfset objSerialsReceipts.deleteSerialNumbers(stFormCopy)>
	<cflocation url="index.cfm?task=serials_receipts_serials_edit&RCPHSEQ=#urlEncodedFormat(stFormCopy.RCPHSEQ)#&RCPLREV=#urlEncodedFormat(stFormCopy.RCPLREV)#&StartBoxNumber=#stFormCopy.StartBoxNumber#">

<!--- ADD was clicked --->
<cfelseif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Add">
	<cfset stErrors = structNew()>
	<cfset objSerialsReceipts.setDataRecord(stFormCopy)>
	<cfset objSerialsReceipts.setErrorRecord(stErrors)>
	<cflocation url="index.cfm?task=serials_receipts_serials_add">

<!--- CANCEL was clicked --->
<cfelseif isDefined("stFormCopy.WhichButton") AND stFormCopy.WhichButton IS "Cancel">
	<cflocation url="index.cfm?task=serials_receipts_list">

<!--- POST or CONTINUE was clicked --->
<cfelse>


	<!--- Check for Batch Item Error:  Make sure that the same entry is made in all of the serial number input boxes  --->
	<cfset stErrors = objSerialsReceipts.checkForBatchItemError(stFormCopy)>
	<cfif NOT structIsEmpty(stErrors)>
		<cfset objSerialsReceipts.setDataRecord(stFormCopy)>
		<cfset objSerialsReceipts.setErrorRecord(stErrors)>
		<cflocation url="index.cfm?task=serials_receipts_serials_edit&Validation=1">
	</cfif>
	
	<!--- Check for Duplicates --->
	<cfset stErrors = objSerialsReceipts.checkForDuplicates(stFormCopy)>
	<cfif NOT structIsEmpty(stErrors)>
		<cfset objSerialsReceipts.setDataRecord(stFormCopy)>
		<cfset objSerialsReceipts.setErrorRecord(stErrors)>
		<cflocation url="index.cfm?task=serials_receipts_serials_edit&Validation=1">
	</cfif>

<!---
stFormCopy:<cfdump var="#stFormCopy#"><br>
<cfabort>
--->



	<!--- Check for Warnings --->
	<!--- RAB 02/26/2015: Skipping this checking routine if using consecutive order 3 function.  It was throwing an error on Receipt # 191066 --->
    <!--- RAB 04/27/2016: I'm going to skip this checking routing for all receipts (commented out below).  
						  Larry says we get one of those timeeout failures once a month or so; this should fix it --->
                          
<!---
	<cfif isDefined("stFormCopy.RCPHSEQ") AND 
		  (stFormCopy.RCPHSEQ IS "16450714" OR 
		   stFormCopy.RCPHSEQ IS "16722265" OR 
		   stFormCopy.RCPHSEQ IS "17180065" OR 
		   stFormCopy.RCPHSEQ IS "17372236" OR 
		   stFormCopy.RCPHSEQ IS "17470332" OR 
		   stFormCopy.RCPHSEQ IS "17850997" OR 
		   stFormCopy.RCPHSEQ IS "17988715")
		  >
		<cfset SkipTheWarningCheck = 1>
	<cfelse>
		<cfset SkipTheWarningCheck = 0>	
	</cfif>			

	<cfif NOT SkipTheWarningCheck>	

		<cfset stWarnings = objSerialsReceipts.checkForWarnings(stFormCopy)>
		<cfif NOT structIsEmpty(stWarnings)>
			<cfset objSerialsReceipts.setDataRecord(stFormCopy)>
			<cfset objSerialsReceipts.setErrorRecord(stWarnings)>
			<cfif isDefined("URL.ConsecutiveOrder3")>
				<cfset CameFromConsecutiveOrder3 = 1>
			<cfelse>
				<cfset CameFromConsecutiveOrder3 = 0>
			</cfif>
			<cflocation url="index.cfm?task=serials_receipts_warning&CameFromConsecutiveOrder3=#CameFromConsecutiveOrder3#">	
		</cfif>

	</cfif>
--->

<!---
stFormCopy:<cfdump var="#stFormCopy#"><br>
--->
	
	<cfset objSerialsReceipts.setDataRecord(stFormCopy)>
		
	<cflocation url="index.cfm?task=serials_receipts_serials_post&RequestTimeout=12000">
	
</cfif>