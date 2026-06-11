<cfcomponent>

	<cffunction name="init" access="public" returntype="any" output="false">
	<cfargument name="AccessLicenseNumber" type="string" required="true">
	<cfargument name="UserId" type="string" required="true">
	<cfargument name="Password" type="string" required="true">
	<cfargument name="sandbox" type="boolean" required="false" default="1">
		<cfset variables.AccessLicenseNumber = arguments.AccessLicenseNumber />
		<cfset variables.UserId = arguments.UserId />
		<cfset variables.Password = arguments.Password />
		<cfif arguments.sandbox eq 1>
			<cfset variables.UpsUrl = "https://www.ups.com/ups.app/xml/Rate">
		<cfelse>
			<cfset variables.UpsUrl = "https://www.ups.com/ups.app/xml/Rate">
		</cfif>
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getRates" access="public" returntype="struct" output="true">
	<cfargument name="record" type="struct" required="yes">
		<cfset UPSAccessRequest = getUPSAccessXML()>    
		<cfset UPSRateRequest = getUPSRateXML(arguments.record)>			
		<cfset UPSXMLFile = toString(UPSAccessRequest) & toString(UPSRateRequest)>
        <cfhttp method="post" url="#variables.UpsUrl#">
        	<cfhttpparam type="XML" value="#UPSXMLFile#">
        </cfhttp>
        <cfset ParsedContent = xmlParse(CFHTTP.FileContent)>
        <cfset xnTrackResponse = ParsedContent.XmlRoot>
		<cfif xnTrackResponse.Response.ResponseStatusCode.XmlText IS "0">
	   		<cfset arguments.record.result.success = 0>
            <cfset arguments.record.result.errormessage = xnTrackResponse.Response.Error.ErrorDescription.XmlText>
        <cfelse>
        	<cfif isDefined("xnTrackResponse.RatedShipment.NegotiatedRates.NetSummaryCharges.GrandTotal.MonetaryValue.XmlText")>
            	<cfset arguments.record.result.EstimatedFreight = xnTrackResponse.RatedShipment.NegotiatedRates.NetSummaryCharges.GrandTotal.MonetaryValue.XmlText>
            <cfelse>
            	<cfset arguments.record.result.EstimatedFreight = xnTrackResponse.RatedShipment.TotalCharges.MonetaryValue.XmlText>
            </cfif>
		</cfif>
		<cfreturn arguments.record.result>
	</cffunction>
	
	<cffunction name="getUPSRateXML" access="private" returntype="any" output="no">
	<cfargument name="record" type="struct" required="yes">
		<cfif Arguments.Record.params.ShippingMethod IS "Ground">
        	<cfset UPSShippingMethod = "03">
        <cfelseif Arguments.Record.params.ShippingMethod IS "2nd Day Air">
        	<cfset UPSShippingMethod = "02">
        <cfelseif Arguments.Record.params.ShippingMethod IS "Next Day Air">
        	<cfset UPSShippingMethod = "01">
       	</cfif>
		<cfxml variable="UPSRateRequest">
		<cfoutput>
		<RatingServiceSelectionRequest>
			<Request>
				<RequestAction>Rate</RequestAction>
				<RequestOption>Rate</RequestOption>
			</Request>
			<Shipment>
				<Shipper>
					<ShipperNumber>1204W0</ShipperNumber>
					<Address>
						<AddressLine1>901 East Cliff Road </AddressLine1>
						<City>Burnsville</City>
						<StateProvinceCode>MN</StateProvinceCode>
						<PostalCode>55337</PostalCode>
						<CountryCode>US</CountryCode>
					</Address>
				</Shipper>
				<ShipTo>
					<Address>
						<StateProvinceCode>#Arguments.Record.to.State#</StateProvinceCode><!--- State --->
						<PostalCode>#Arguments.Record.to.Zip#</PostalCode><!--- Zip Code --->
						<cfif arguments.record.to.residence eq 1>
						<ResidentialAddressIndicator></ResidentialAddressIndicator><!--- Residential Delivery --->	
						</cfif>
					</Address>
				</ShipTo>
				<Service>
					<Code>#UPSShippingMethod#</Code><!--- Shipping Method: 03 = Ground, 02 = 2nd Day Air, 01 = Next Day Air --->
				</Service>
				<Package>
					<PackagingType>
						<Code>02</Code>
					</PackagingType>
					<PackageWeight>
						<UnitOfMeasurement>
							<Code>LBS</Code>
						</UnitOfMeasurement>
						<Weight>#arguments.record.Weight#</Weight><!--- Weight --->
					</PackageWeight>
					<cfif Arguments.Record.to.signature eq 1>
					<PackageServiceOptions>
						<DeliveryConfirmation><!--- Signature Required; 2 = "Delivery Confirmation Signature Required" --->
							<DCISType>2</DCISType>
						</DeliveryConfirmation>
					</PackageServiceOptions>
					</cfif>
				</Package>
				<RateInformation>
					<NegotiatedRatesIndicator></NegotiatedRatesIndicator>
				</RateInformation>
			</Shipment>
		</RatingServiceSelectionRequest>
		</cfoutput>
		</cfxml>
		<cfreturn UPSRateRequest>
	</cffunction>
	
	<cffunction name="getUPSAccessXML" access="private" returntype="any" output="no">
		<cfxml variable="UPSAccessRequest">
		<cfoutput>
			<AccessRequest xml:lang="en-US">
				<AccessLicenseNumber>#variables.AccessLicenseNumber#</AccessLicenseNumber>
				<UserId>#variables.UserId#</UserId>
				<Password>#variables.Password#</Password>
			</AccessRequest>
		</cfoutput>
		</cfxml>
		<cfreturn UPSAccessRequest>
	</cffunction>

</cfcomponent>