<cfcomponent extends="admin.assets.cfcs.Component">
	<cfset This.DataSourceName = APPLICATION.DSN_AP>

	<cfset This.Columns = "INVUNIQ,COIN">
	
	<cfset This.ViewColumns = This.Columns>
	<cfset This.DESCColumn = "">

	<cfset This.TableName = "dbo.OECOINI">
	<cfset This.ViewName = This.TableName>
	
	<cfset This.PrimaryKey = "INVUNIQ">
	<cfset This.ITEMNOKey = "">
	<cfset This.GenerateUUIDKey = 0>
	<cfset This.Format = "query">
	<cfset This.SortColumn = "INVUNIQ">
	<cfset This.SortOrder = "Asc">

	<cfset This.SortOrderList = "">
	<cfset This.SortKey = "">
	<cfset This.ParentKey = "">
	<cfset This.CreatedKey = "">
	<cfset This.ModifiedKey = "">
	<cfset This.ZipCode1Key = "">
	<cfset This.ZipCode2Key = "">
	<cfset This.SavePrimaryKey = 0>
	<cfset This.ExcludeInUpdates = "">
	<cfset This.ExcludeInInserts = "">

    <!--- RAB 10/16/2012 --->
	<!---------------------------------------------------------------------------------------------------------->
	<cffunction name="getFEDEXTrackingNumber" access="public" returntype="string" output="no">
	<cfargument name="INVUNIQ" type="string" required="yes">
		<cfset var TrackingNumber = "">
		<cfset var qInvoiceMain = queryNew("")>
        <cfset var qryOEINVH = queryNew("")>
        <cfset var InvoiceCount = 0>
        <cfset var qryShippingInfo = queryNew("")>
        <cfset var LoopCount = 0>
        
		<cfquery name="qInvoiceMain" datasource="#This.DataSourceName#">
		SELECT	ORDNUMBER, INVNUMBER, INVDATE
		FROM	dbo.OEINVH
		WHERE	InvUniq = '#Arguments.INVUNIQ#'
		</cfquery>
        
        <cfif qInvoiceMain.INVDATE LT 20121011>
			<cfset TrackingNumber = getTrackingNumber(Arguments.INVUNIQ)>
        
        <cfelse>
        
			<!--- Get all Invoices for this order --->
            <cfquery name="qryOEINVH" datasource="#This.DataSourceName#">
            SELECT	INVNUMBER
            FROM	dbo.OEINVH
            WHERE	ORDNUMBER = '#qInvoiceMain.ORDNUMBER#'
            ORDER BY INVNUMBER
            </cfquery>
    
            <cfset InvoiceCount = 1>
            <cfloop query="qryOEINVH">
                <cfif trim(qryOEINVH.INVNUMBER) IS trim(qInvoiceMain.INVNUMBER)>
                    <cfbreak>
                <cfelse>
                    <cfset InvoiceCount = InvoiceCount + 1>
                </cfif>
            </cfloop>
    
            <!--- Get the tracking number from tblShippingInfo --->
            <cfquery name="qryShippingInfo" datasource="NorTechWWW">
            SELECT	CreationDate, TrackingNumber, DiscountedShippingCharge, ORDNUMBER
            FROM	tblShippingInfo
            WHERE	ORDNUMBER = '#qInvoiceMain.ORDNUMBER#'
            ORDER BY ShippingInfoID
            </cfquery>
    
            <cfset LoopCount = 1>
            <cfloop query="qryShippingInfo">
                <cfif LoopCount EQ InvoiceCount>
                    <cfset TrackingNumber = trim(qryShippingInfo.TrackingNumber)>
                    <cfbreak>
                <cfelse>
                    <cfset LoopCount = LoopCount + 1>
                </cfif>
            </cfloop>
        
        </cfif>

		<cfreturn TrackingNumber>
	</cffunction>

    <!--- RAB 11/01/2012 --->
	<!---------------------------------------------------------------------------------------------------------->
	<cffunction name="getUPSTrackingNumber" access="public" returntype="string" output="no">
	<cfargument name="INVUNIQ" type="string" required="yes">
		<cfset var TrackingNumber = "">
		<cfset var qInvoiceMain = queryNew("")>
        <cfset var qryOEINVH = queryNew("")>
        <cfset var InvoiceCount = 0>
        <cfset var qryShippingInfo = queryNew("")>
        <cfset var LoopCount = 0>
		<cfset var qryShippingInfo_Void = queryNew("")>
        <cfset var qryShippingInfo_Final = queryNew("TrackingNumber")>
        
        
		<cfquery name="qInvoiceMain" datasource="#This.DataSourceName#">
		SELECT	ORDNUMBER, INVNUMBER, INVDATE
		FROM	dbo.OEINVH
		WHERE	InvUniq = '#Arguments.INVUNIQ#'
		</cfquery>
        
        <cfif qInvoiceMain.INVDATE LT 20121031>
			<cfset TrackingNumber = getTrackingNumber(Arguments.INVUNIQ)>
        
        <cfelse>
        
			<!--- Get all Invoices for this order --->
            <cfquery name="qryOEINVH" datasource="#This.DataSourceName#">
            SELECT	INVNUMBER
            FROM	dbo.OEINVH
            WHERE	ORDNUMBER = '#qInvoiceMain.ORDNUMBER#'
            ORDER BY INVNUMBER
            </cfquery>
    
            <cfset InvoiceCount = 1>
            <cfloop query="qryOEINVH">
                <cfif trim(qryOEINVH.INVNUMBER) IS trim(qInvoiceMain.INVNUMBER)>
                    <cfbreak>
                <cfelse>
                    <cfset InvoiceCount = InvoiceCount + 1>
                </cfif>
            </cfloop>
    
            <!--- Get the tracking number from tblShippingInfo --->
            <cfquery name="qryShippingInfo" datasource="NorTechWWW">
            SELECT	CreationDate, TrackingNumber, DiscountedShippingCharge, ORDNUMBER
            FROM	tblShippingInfo
            WHERE	ORDNUMBER = '#qInvoiceMain.ORDNUMBER#' AND
            		ShipmentVoid <> 'Y'
            ORDER BY ShippingInfoID
            </cfquery>

            
            <!--- Remove the Voids --->
            <cfloop query="qryShippingInfo">
                <cfquery name="qryShippingInfo_Void" datasource="NorTechWWW">
                SELECT	ShippingInfoID
                FROM	tblShippingInfo
                WHERE	ORDNUMBER = '#qInvoiceMain.ORDNUMBER#' AND
                		TrackingNumber = '#trim(qryShippingInfo.TrackingNumber)#' AND
                        ShipmentVoid = 'Y'
                </cfquery>
                <cfif qryShippingInfo_Void.RecordCount EQ 0>
                	<cfset queryAddRow(qryShippingInfo_Final)>
                    <cfset querySetCell(qryShippingInfo_Final, "TrackingNumber", qryShippingInfo.TrackingNumber)>
                </cfif>
            </cfloop>
    
            <cfset LoopCount = 1>
            <cfloop query="qryShippingInfo_Final">
                <cfif LoopCount EQ InvoiceCount>
                    <cfset TrackingNumber = trim(qryShippingInfo_Final.TrackingNumber)>
                    <cfbreak>
                <cfelse>
                    <cfset LoopCount = LoopCount + 1>
                </cfif>
            </cfloop>
        
        </cfif>

		<cfreturn TrackingNumber>
	</cffunction>
    
	<!---------------------------------------------------------------------------------------------------------->
	<cffunction name="getTrackingNumber" access="public" returntype="string" output="no">
	<cfargument name="INVUNIQ" type="string" required="yes">
		<cfset var TrackingNumber = "">
		<cfset SearchRecord = structNew()>
		<cfset structInsert(SearchRecord, "INVUNIQ", Arguments.INVUNIQ, True)>
		<cfset qryOECOINI = searchRecords(SearchRecord, "query")>
		<cfif isDefined("qryOECOINI.COIN")>
			<cfset TrackingNumber = trim(qryOECOINI.COIN)>
		</cfif>
		<cfreturn TrackingNumber>
	</cffunction>

	<!---------------------------------------------------------------------------------------------------------->
	<cffunction name="getTrackingURL" access="public" returntype="string" output="no">
	<cfargument name="ShippingMethod" type="string" required="yes">
	<cfargument name="TrackingNumber" type="string" required="yes">
		<cfset var TrackingURL = "">
		<cfif findNoCase("UPS", Arguments.ShippingMethod) NEQ 0>		
<!---		<cfset TrackingURL = "https://wwwapps.ups.com/WebTracking/processInputRequest?HTMLVersion=5.0&loc=en_US&Requester=UPSHome&tracknum=#Arguments.TrackingNumber#+&track.x=39&track.y=14">	--->
<!---		<cfset TrackingURL = "http://www.ups.com/WebTracking/track?loc=en_US">	--->
			<cfset TrackingURL = "http://wwwapps.ups.com/tracking/tracking.cgi?tracknum=#Arguments.TrackingNumber#">
		<cfelseif findNoCase("FED EX", Arguments.ShippingMethod) NEQ 0>
			<cfset TrackingURL = "http://fedex.com/Tracking?ascend_header=1&clienttype=dotcom&cntry_code=us&language=english&tracknumbers=#Arguments.TrackingNumber#">
		</cfif>
		<cfreturn TrackingURL>
	</cffunction>
	
</cfcomponent>