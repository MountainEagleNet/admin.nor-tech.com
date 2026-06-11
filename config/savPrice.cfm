<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/15/2006
	Function: 		This page saves the price information
	Template:		savPrice.cfm
	Task:			config_setup_price_save
--->
<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>

<cfset stFormCopy = duplicate(FORM)>
<!---
<cfset isMaintainedByDefault = objConfigSystems.isMaintainedByDefault(stFormCopy.ConfigSystemID)>
--->
<cfparam name="stFormCopy.DefaultComponentsOnly" default="0">

<!--- User Selected a New Price List --->
<cfif NOT structKeyExists(stFormCopy, "ButtonClicked")>
	<cflocation url="index.cfm?task=config_setup_price_edit&ConfigSystemID=#urlEncodedFormat(ConfigSystemID)#&PriceListID=#urlEncodedFormat(stFormCopy.PriceListID)#&DefaultComponentsOnly=#stFormCopy.DefaultComponentsOnly#&RequestTimeout=6000">
</cfif>

<!---
<cfif isMaintainedByDefault>
	<cfif NOT structKeyExists(stFormCopy, "ButtonClicked") OR stFormCopy.ButtonClicked IS "Refresh">
		<cflocation url="index.cfm?task=config_setup_price_edit&ConfigSystemID=#urlEncodedFormat(stFormCopy.ConfigSystemID)#&PriceListID=#urlEncodedFormat(stFormCopy.PriceListID)#&DefaultComponentsOnly=#stFormCopy.DefaultComponentsOnly#">
	<cfelse>
		<cflocation url="index.cfm?task=config_setup_resellers_edit&ConfigSystemID=#urlEncodedFormat(stFormCopy.ConfigSystemID)#">
	</cfif>
</cfif>
--->
<!--- VALIDATE --->
<cfset stErrors = objConfigSystems.validatePrice(stFormCopy)>
<cfif NOT structIsEmpty(stErrors)>
<!---
stFormCopy.Name:<cfdump var="#stFormCopy.Name#"><br />
--->
	<cfset objConfigSystems.setDataRecord(stFormCopy)>
	<cfset objConfigSystems.setErrorRecord(stErrors)>
	<cfset objConfigSystems.setMessage("Please correct the fields indicated below.")>
<!---    
<cfset rontest = objConfigSystems.getDataRecord()>
rontest.Name:<cfdump var="#rontest.Name#"><br />
<cfabort>
--->    
	<cflocation url="index.cfm?task=config_setup_price_edit&Validation=1&RequestTimeout=6000">
<!--- SAVE --->
<cfelse>

	<cfset structDelete(stFormCopy, "Name")>

	<cfset ConfigSystemID = objConfigSystems.saveRecord(stFormCopy)>
<!---
	<!--- 7/9/09, Update: this is now the only field that will be maintained by the sales rep, and not by the default --->
	<!--- If this is a default system, make all of these adjustments to sales rep systems that are being maintained by this system --->
    <cfset objConfigSystems.maintainSalesRepSystems5(stFormCopy)>
--->
	<cfset objConfigSystems.setMessage("The system base price has been saved.")>

	<!--- REFRESH --->
	<cfif NOT structKeyExists(stFormCopy, "ButtonClicked") OR stFormCopy.ButtonClicked IS "Refresh">
		<cflocation url="index.cfm?task=config_setup_price_edit&ConfigSystemID=#urlEncodedFormat(ConfigSystemID)#&PriceListID=#urlEncodedFormat(stFormCopy.PriceListID)#&DefaultComponentsOnly=#stFormCopy.DefaultComponentsOnly#&RequestTimeout=6000">
	<cfelse>
		<cfset DefaultSystems = objConfigSystems.getSessionValue("DefaultSystems")>
<!---	
		<cfset NewSystem = objConfigSystems.getSessionValue("NewSystem")>
		<cfset CopySystem = objConfigSystems.getSessionValue("CopySystem")>

		<cfif NOT isBoolean(DefaultSystems)>
			<cfset DefaultSystems = 0>
		</cfif>		
		<cfif NOT isBoolean(NewSystem)>
			<cfset NewSystem = 0>
		</cfif>		
		<cfif NOT isBoolean(CopySystem)>
			<cfset CopySystem = 0>
		</cfif>		
--->		

<!---	<cfif (NewSystem OR CopySystem) AND NOT DefaultSystems>	--->
		<cfif NOT DefaultSystems>
			<cflocation url="index.cfm?task=config_setup_resellers_edit&ConfigSystemID=#urlEncodedFormat(ConfigSystemID)#&RequestTimeout=6000">
		<cfelse>
			<cflocation url="index.cfm?task=config_setup_systems_list&DefaultSystems=#DefaultSystems#&RequestTimeout=6000">
		</cfif>

	</cfif>
</cfif>