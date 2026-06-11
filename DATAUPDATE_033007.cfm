<cfoutput>

<cfset ThisOrderNumber = "115527">
<cfset ThisOrderLineNumber = "32">

<cfquery datasource="NorTechAP" name="qryOEORDH">
SELECT 	ORDUNIQ, ORDNUMBER, ORDDATE, CUSTOMER, BILNAME, SHPNAME, VIADESC
FROM    dbo.OEORDH
WHERE 	ORDNUMBER = '#ThisOrderNumber#'
</cfquery>

<cfquery datasource="NorTechAP" name="qryOEORDD">
SELECT 	ORDUNIQ, LINENUM, ITEM, [DESC], ORIGQTY, QTYSHPTODT, QTYSHIPPED, QTYORDERED
FROM    dbo.OEORDD
WHERE 	ORDUNIQ = '#qryOEORDH.ORDUNIQ#' AND
		LINENUM = '#ThisOrderLineNumber#'
</cfquery>

<!---
qryOEORDH:<cfdump var="#qryOEORDH#">
qryOEORDD:<cfdump var="#qryOEORDD#">
--->

<cfquery datasource="NorTechWWW" name="qrySerials">
SELECT 	*
FROM 	tblSerials
WHERE   (ITEMNO = 'dv-lg-gsa-4167b')
ORDER BY SerialNumber
</cfquery>


qrySerials.RecordCount: #qrySerials.RecordCount#<br>
<!---
<cfdump var="#qrySerials#">
--->

<cfloop query="qrySerials">
	<cfset CURRENTSerialID = qrySerials.SerialID>
	<cfset CURRENTSerialNumber = qrySerials.SerialNumber>
	<cfset CURRENTLOCATION = qrySerials.LOCATION>

	<cfset NEWSerialsShipmentsID = createUUID()>
	
	<cfquery datasource="NorTechWWW">
	INSERT INTO tblSerialsShipments (
		SerialsShipmentsID,	
		ORDNUMBER,
		SerialNumber,
		Posted,
		PostedDate,
		ORDUNIQ,
		ORDLINENUM,
		AttachedToInvoice
	)
	VALUES (
		'#NEWSerialsShipmentsID#',
		'#ThisOrderNumber#',
		'#CURRENTSerialNumber#',
		1,
		#now()#,
		'#qryOEORDH.ORDUNIQ#',
		'#ThisOrderLineNumber#',
		0
	)
	</cfquery>



	<cfquery datasource="NorTechAP" name="qryLocation">
	SELECT 	dbo.ICLOC.[DESC]
	FROM 	dbo.ICLOC
	WHERE 	dbo.ICLOC.LOCATION = '#CURRENTLOCATION#'
	</cfquery>

	<cfset NEWSerialNumberAuditTraiID = createUUID()>
	
	<cfquery datasource="NorTechWWW">
	INSERT INTO tblSerialNumberAuditTrail (
		SerialNumberAuditTrailID,
		TransactionType,
		TransactionNumber,
		CreationDate,
		UserFirstName,
		UserLastName,
		UserEmail,
		ITEMNO,
		ITEMDESC,
		SerialNumber,
		AddorRemove,
		LOCATION,
		LOCATIONDESC,
		CUSTOMER,
		BILNAME,
		SerialTable,
		SerialTableIDField,
		SerialTableIDValue
	)
	VALUES (
		'#NEWSerialNumberAuditTraiID#',
		'Order',
		'#ThisOrderNumber#',
		#now()#,
		'Ron',
		'Barth',
		'ron_barth@altsystem.com',
		'#qryOEORDD.ITEM#',
		'#qryOEORDD.DESC#',
		'#CURRENTSerialNumber#',
		'Remove',
		'#CURRENTLOCATION#',
		'#qryLocation.DESC#',
		'#qryOEORDH.CUSTOMER#',
		'#qryOEORDH.BILNAME#',
		'tblSerialsShipments',
		'SerialsShipmentsID',
		'#NEWSerialsShipmentsID#'
	)
	</cfquery>

	<cfquery datasource="NorTechWWW">
	Delete From tblSerials
	Where SerialID = '#CURRENTSerialID#'
	</cfquery>

</cfloop>

</cfoutput>

DONE!!!