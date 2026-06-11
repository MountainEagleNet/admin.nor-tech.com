<cfcomponent>
	
	<cffunction name="validateRequired" access="public" returntype="boolean" output="No">
	<cfargument name="Field" type="string" required="Yes">
		<cfset var Passed = 1>		
		<cfif trim(Arguments.Field) IS ""><cfset Passed = 0></cfif>
		<cfreturn Passed>
	</cffunction>
	
	<cffunction name="validateEmail" access="public" returntype="boolean" output="No">
	<cfargument name="Email" type="string" required="Yes">
		<cfset var Passed = 1>
		<cfif findNoCase("@", Arguments.Email) EQ 0>
			<cfset Passed = 0>
		<cfelseif findNoCase(".", Arguments.Email) EQ 0>
			<cfset Passed = 0>
		</cfif> 
		<cfreturn Passed>
	</cffunction>
	
	<cffunction name="validateDate" access="public" returntype="boolean" output="No">
	<cfargument name="DateField" type="any" required="Yes">
		<cfset var Passed = 0>
		<cfif isDate(Arguments.DateField)><cfset Passed = 1></cfif>
		<cfreturn Passed>
	</cffunction>
	
	<cffunction name="validateTime" access="public" returntype="boolean" output="No">
	<cfargument name="Field" type="any" required="Yes">
		<cfset var Passed = 1>
		<cfset FieldCopy = Arguments.Field>
		<cfset FieldCopy = replaceNoCase(FieldCopy, "am", "", "all")>
		<cfset FieldCopy = replaceNoCase(FieldCopy, "pm", "", "all")>
		<cfset FieldCopy = replaceNoCase(FieldCopy, ":", "", "all")>
	 	<cfset FieldCopy = replaceNoCase(FieldCopy, Variables.ASCII_SPACE, "", "all")>
		<cfif isNumeric(FieldCopy) EQ 0>
			<cfset Passed = 0>
		<cfelse>
			<cfif findNoCase(":", Arguments.Field) EQ 0>
				<cfset Passed = 0>
			<cfelseif findNoCase("am", Arguments.Field) EQ 0 AND findNoCase("pm", Arguments.Field) EQ 0>
				<cfset Passed = 0>
			</cfif>
		</cfif>
		<cfreturn Passed>
	</cffunction>
	
	<cffunction name="validateQuotedSQL" access="public" returntype="boolean">
	<cfargument name="Field" type="string" required="Yes">
		<cfset var Passed = 1>
		<cfif isBoolean(Arguments.Field)>
			<cfset Passed = 0>
		<cfelseif isNumeric(Arguments.Field)>
			<cfset Passed = 0>
		</cfif>
		<cfreturn Passed>
	</cffunction>
	
	<cffunction name="validateGUID" access="public" returntype="boolean" output="No">
	<cfargument name="StringData" type="string" required="Yes">
		<cfset var Passed = 1>
		<cfif len(Arguments.StringData) LT 39 OR len(Arguments.StringData) GT 50>
			<cfset Passed = 0>
		</cfif>
		<cfreturn Passed>
	</cffunction>
	
	<cffunction name="validateDecimal" access="public" returntype="boolean" output="No">
	<cfargument name="Field" type="any" required="Yes">
		<cfreturn isNumeric(Arguments.Field)>
	</cffunction>
	
	<cffunction name="validateNegativeDecimal" access="public" returntype="boolean" output="No">
	<cfargument name="Field" type="any" required="Yes">
		<cfset var Passed = 1>
		<cfset Passed = validateDecimal(Arguments.Field)>
		<cfif Passed EQ 1 AND Arguments.Field GTE 0><cfset Passed = 0></cfif>
		<cfreturn Passed>
	</cffunction>
	
	<cffunction name="validatePositiveDecimal" access="public" returntype="boolean" output="No">
	<cfargument name="Field" type="any" required="Yes">
		<cfset var Passed = 1>
		<cfset Passed = validateDecimal(Arguments.Field)>
		<cfif Passed EQ 1 AND Arguments.Field LTE 0><cfset Passed = 0></cfif>
		<cfreturn Passed>
	</cffunction>
	
	<cffunction name="validateZeroDecimal" access="public" returntype="boolean" output="No">
	<cfargument name="Field" type="any" required="Yes">
		<cfset var Passed = 1>
		<cfset Passed = validateDecimal(Arguments.Field)>
		<cfif Passed EQ 1 AND Arguments.Field LT 0><cfset Passed = 0></cfif>
		<cfreturn Passed>
	</cffunction>
	
	<cffunction name="validateInteger" access="public" returntype="boolean" output="No">
	<cfargument name="Field" type="any" required="Yes">
		<cfset var Passed = 1>
		<cfset Passed = validateDecimal(Arguments.Field)>
		<cfif Passed EQ 1 AND findNoCase(".", Arguments.Field) NEQ 0><cfset Passed = 0></cfif>
		<cfreturn Passed>
	</cffunction>
	
	<cffunction name="validateNegativeInteger" access="public" returntype="boolean" output="No">
	<cfargument name="Field" type="any" required="Yes">
		<cfset var Passed = 1>
		<cfset Passed = validateInteger(Arguments.Field)>
		<cfif Passed EQ 1 AND Arguments.Field GTE 0><cfset Passed = 0></cfif>
		<cfreturn Passed>
	</cffunction>
	
	<cffunction name="validatePositiveInteger" access="public" returntype="boolean" output="No">
	<cfargument name="Field" type="any" required="Yes">
		<cfset var Passed = 1>
		<cfset Passed = validateInteger(Arguments.Field)>
		<cfif Passed EQ 1 AND Arguments.Field LTE 0><cfset Passed = 0></cfif>
		<cfreturn Passed>
	</cffunction>
	
	<cffunction name="validateZeroInteger" access="public" returntype="boolean" output="No">
	<cfargument name="Field" type="any" required="Yes">
		<cfset var Passed = 1>
		<cfset Passed = validateInteger(Arguments.Field)>
		<cfif Passed EQ 1 AND Arguments.Field LT 0><cfset Passed = 0></cfif>
		<cfreturn Passed>
	</cffunction>

	<cffunction name="validateUSPhone" access="public" returntype="boolean" output="No">
	<cfargument name="Field" type="string" required="Yes">
		<cfset var Passed = 1>		
		<cfset RawNumber = trim(Arguments.Field)>
		<cfset FieldLength = len(RawNumber)>
		<cfset OnlyNumber = "">
		<cfloop index="L" from="1" to="#FieldLength#">
			<cfif mid(RawNumber, L, 1) EQ "0" 
				OR mid(RawNumber, L, 1) EQ "1"
				OR mid(RawNumber, L, 1) EQ "2"
				OR mid(RawNumber, L, 1) EQ "3"
				OR mid(RawNumber, L, 1) EQ "4"
				OR mid(RawNumber, L, 1) EQ "5"
				OR mid(RawNumber, L, 1) EQ "6"
				OR mid(RawNumber, L, 1) EQ "7"
				OR mid(RawNumber, L, 1) EQ "8"
				OR mid(RawNumber, L, 1) EQ "9">
				<cfset OnlyNumber = OnlyNumber & mid(RawNumber, L, 1)>
			</cfif>
		</cfloop>
		<cfif len(OnlyNumber) NEQ 10><cfset Passed = 0></cfif>
		<cfreturn Passed>
	</cffunction>
	
	<cffunction name="validateBoolean" access="public" returntype="boolean" output="No">
	<cfargument name="Field" type="string" required="Yes">
		<cfreturn isBoolean(Arguments.Field)>
	</cffunction>
	
	<cffunction name="validateZipCode" access="public" returntype="boolean" output="No">
	<cfargument name="Field" type="string" required="Yes">
		<cfset var Passed = 1>
		<cfset RawNumber = trim(Arguments.Field)>
		<cfset FieldLength = len(RawNumber)>
		<cfset OnlyNumber = "">
		<cfloop index="L" from="1" to="#FieldLength#">
			<cfif mid(RawNumber, L, 1) EQ "0" 
				OR mid(RawNumber, L, 1) EQ "1"
				OR mid(RawNumber, L, 1) EQ "2"
				OR mid(RawNumber, L, 1) EQ "3"
				OR mid(RawNumber, L, 1) EQ "4"
				OR mid(RawNumber, L, 1) EQ "5"
				OR mid(RawNumber, L, 1) EQ "6"
				OR mid(RawNumber, L, 1) EQ "7"
				OR mid(RawNumber, L, 1) EQ "8"
				OR mid(RawNumber, L, 1) EQ "9">
				<cfset OnlyNumber = OnlyNumber & mid(RawNumber, L, 1)>
			</cfif>
		</cfloop>
		<cfif len(OnlyNumber) NEQ 5 AND len(OnlyNumber) NEQ 9><cfset Passed = 0></cfif>
		<cfreturn Passed>
	</cffunction>

	<cffunction name="validateCreditCard" access="public" returntype="boolean" output="No">
	<cfargument name="cc" type="numeric" required="Yes">
		<cfset ccs = StructNew()>
		
		<cfset ccs["Visa"] = StructNew()>
		<cfset ccs["Visa"]["type"] = "Visa">
		<cfset ccs["Visa"]["length"] = ArrayNew(1)>
		<cfset temp = ArrayAppend(ccs["Visa"]["length"], "13")>
		<cfset temp = ArrayAppend(ccs["Visa"]["length"], "16")>
		<cfset ccs["Visa"]["f4d"] = ArrayNew(1)>
		<cfset temp = ArrayAppend(ccs["Visa"]["f4d"], "4000,4999")>
		<cfset ccs["Visa"]["mod"] = 10>
		
		<cfset ccs["MasterCard"] = StructNew()>
		<cfset ccs["MasterCard"]["type"] = "MasterCard">
		<cfset ccs["MasterCard"]["length"] = ArrayNew(1)>
		<cfset temp = ArrayAppend(ccs["MasterCard"]["length"], "16")>
		<cfset ccs["MasterCard"]["f4d"] = ArrayNew(1)>
		<cfset temp = ArrayAppend(ccs["MasterCard"]["f4d"], "5100,5599")>
		<cfset ccs["MasterCard"]["mod"] = 10>
		
		<cfset ccs["American Express"] = StructNew()>
		<cfset ccs["American Express"]["type"] = "American Express">
		<cfset ccs["American Express"]["length"] = ArrayNew(1)>
		<cfset temp = ArrayAppend(ccs["American Express"]["length"], "15")>
		<cfset ccs["American Express"]["f4d"] = ArrayNew(1)>
		<cfset temp = ArrayAppend(ccs["American Express"]["f4d"], "3400,3499")>
		<cfset temp = ArrayAppend(ccs["American Express"]["f4d"], "3700,3799")>
		<cfset ccs["American Express"]["mod"] = 10>
		
		<cfset ccs["Discover"] = StructNew()>
		<cfset ccs["Discover"]["type"] = "Discover">
		<cfset ccs["Discover"]["length"] = ArrayNew(1)>
		<cfset temp = ArrayAppend(ccs["Discover"]["length"], "16")>
		<cfset ccs["Discover"]["f4d"] = ArrayNew(1)>
		<cfset temp = ArrayAppend(ccs["Discover"]["f4d"], "6011")>
		<cfset ccs["Discover"]["mod"] = 10>
		
		<cfset ccs["Diners Club"] = StructNew()>
		<cfset ccs["Diners Club"]["type"] = "Diners Club">
		<cfset ccs["Diners Club"]["length"] = ArrayNew(1)>
		<cfset temp = ArrayAppend(ccs["Diners Club"]["length"], "14")>
		<cfset ccs["Diners Club"]["f4d"] = ArrayNew(1)>
		<cfset temp = ArrayAppend(ccs["Diners Club"]["f4d"], "3000,3059")>
		<cfset temp = ArrayAppend(ccs["Diners Club"]["f4d"], "3600,3699")>
		<cfset temp = ArrayAppend(ccs["Diners Club"]["f4d"], "3800,3889")>
		<cfset ccs["Diners Club"]["mod"] = 10>
		
		<cfset ccs["Carte Blanche"] = StructNew()>
		<cfset ccs["Carte Blanche"]["type"] = "Carte Blanche">
		<cfset ccs["Carte Blanche"]["length"] = ArrayNew(1)>
		<cfset temp = ArrayAppend(ccs["Carte Blanche"]["length"], "14")>
		<cfset ccs["Carte Blanche"]["f4d"] = ArrayNew(1)>
		<cfset temp = ArrayAppend(ccs["Carte Blanche"]["f4d"], "3890,3899")>
		<cfset ccs["Carte Blanche"]["mod"] = 10>
		
		<cfset ccs["JCB"] = StructNew()>
		<cfset ccs["JCB"]["type"] = "JCB">
		<cfset ccs["JCB"]["length"] = ArrayNew(1)>
		<cfset temp = ArrayAppend(ccs["JCB"]["length"], "16")>
		<cfset ccs["JCB"]["f4d"] = ArrayNew(1)>
		<cfset temp = ArrayAppend(ccs["JCB"]["f4d"], "3582,3589")>
		<cfset temp = ArrayAppend(ccs["JCB"]["f4d"], "3088")>
		<cfset ccs["JCB"]["mod"] = 10>
		
		<cfset ccs["JCB2"] = StructNew()>
		<cfset ccs["JCB2"]["type"] = "JCB">
		<cfset ccs["JCB2"]["length"] = ArrayNew(1)>
		<cfset temp = ArrayAppend(ccs["JCB2"]["length"], "15")>
		<cfset ccs["JCB2"]["f4d"] = ArrayNew(1)>
		<cfset temp = ArrayAppend(ccs["JCB2"]["f4d"], "2131")>
		<cfset temp = ArrayAppend(ccs["JCB2"]["f4d"], "1800")>
		<cfset ccs["JCB2"]["mod"] = 10>
		
		<cfset ccs["Austrailian Bankcard"] = StructNew()>
		<cfset ccs["Austrailian Bankcard"]["type"] = "Austrailian Bankcard">
		<cfset ccs["Austrailian Bankcard"]["length"] = ArrayNew(1)>
		<cfset temp = ArrayAppend(ccs["Austrailian Bankcard"]["length"], "16")>
		<cfset ccs["Austrailian Bankcard"]["f4d"] = ArrayNew(1)>
		<cfset temp = ArrayAppend(ccs["Austrailian Bankcard"]["f4d"], "5610")>
		<cfset ccs["Austrailian Bankcard"]["mod"] = 10>
		
		<cfset ccs["enRoute"] = StructNew()>
		<cfset ccs["enRoute"]["type"] = "enRoute">
		<cfset ccs["enRoute"]["length"] = ArrayNew(1)>
		<cfset temp = ArrayAppend(ccs["enRoute"]["length"], "15")>
		<cfset ccs["enRoute"]["f4d"] = ArrayNew(1)>
		<cfset temp = ArrayAppend(ccs["enRoute"]["f4d"], "2014")>
		<cfset temp = ArrayAppend(ccs["enRoute"]["f4d"], "2149")>
		<cfset ccs["enRoute"]["mod"] = 10>
		
		<cfset cc = Arguments.cc>
		<cfset cc = replaceNoCase(cc, " ", "", "all")>
		<cfset ccLength = Len(cc)>
		<cfif Not isNumeric(cc) OR findNoCase(chr(46), cc)>
			<cfreturn 0>
		</cfif>
		
		<cfset isCcValid = false>
		<cfset modVal = 10><!--- default to 10 --->
		<cfset ccType = "">
		<cfset ccF4D = left(cc, 4)><!--- first 4 digits --->
		<cfloop collection="#ccs#" item="card"><!--- look into the card table --->
			<cfloop from="1" to="#ArrayLen(ccs[card]["f4d"])#" index="i"><!--- check the first 4 digits --->
				<cfif ListLen(ccs[card]["f4d"][i]) IS 1><!--- this card has a fixed first 4 digits --->
					<cfif ListFind(ccs[card]["f4d"][i], ccF4D)><!--- the first 4 digits' match --->
						<cfloop from="1" to="#ArrayLen(ccs[card]["length"])#" index="k"><!--- long many digits should this card number be? --->
							<cfif ccLength IS ccs[card]["length"][k]><!--- the number of digits is valid --->
								<cfset isCcValid = true><!--- this card looks good --->
								<cfset modVal = ccs[card]["mod"]>
								<cfset ccType = ccs[card]["type"]>
								<cfbreak>
							</cfif>
						</cfloop>
					</cfif>
				<cfelseif ListLen(ccs[card]["f4d"][i]) IS 2><!--- first 4 digits are within a range --->
					<cfif ccF4D GTE ListGetAt(ccs[card]["f4d"][i],1) AND ccF4D LTE ListGetAt(ccs[card]["f4d"][i],2)><!--- first four digits are within range --->
						<cfloop from="1" to="#ArrayLen(ccs[card]["length"])#" index="k"><!--- what about the number of digits in the card? --->
							<cfif ccLength IS ccs[card]["length"][k]><!--- the number of digits is valid --->
								<cfset isCcValid = true><!--- this card looks good --->
								<cfset modVal = ccs[card]["mod"]>
								<cfset ccType = ccs[card]["type"]>
								<cfbreak>
							</cfif>
						</cfloop>
					</cfif>
				</cfif>
			</cfloop>
		</cfloop>
		<cfif NOT isCcValid><!--- not a valid credit card --->
			<cfreturn 0>
		</cfif>
		<cfset ccDigits = ArrayNew(1)><!--- going to populate this with the digits required --->
		<cfset x = 1><!--- set index --->
		<cfloop from="#Len(cc)#" to="1" step="-1" index="i"><!--- work from right to left --->
			<cfif x MOD 2 IS NOT 0><!--- index is odd --->
				<cfset temp = ArrayPrepend(ccDigits,Mid(cc,i,1))><!--- use the original digit --->
			<cfelse>
				<cfset temp = ArrayPrepend(ccDigits,Mid(cc,i,1) * 2)><!--- use the product of the original digit and 2 --->
			</cfif>
			<cfset x = x + 1><!--- move index --->
		</cfloop>
		<cfset numberSum = 0>
		<cfloop from="1" to="#ArrayLen(ccDigits)#" index="i">
			<cfif ccDigits[i] GT 9>
				<cfset numberSum = numberSum + (ccDigits[i] - 9)>
			<cfelse>
				<cfset numberSum = numberSum + ccDigits[i]>
			</cfif>
		</cfloop>
		<cfif numberSum MOD modVal IS 0>
			<cfreturn 1>
		<cfelse>
			<cfreturn 0>
		</cfif>
		<cfreturn 0>
	</cffunction>
</cfcomponent>