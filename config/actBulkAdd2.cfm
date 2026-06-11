<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	10/09/2008
	Function: 		Add Component - Action Page
	Template:		actBulkAdd2.cfm
	Task:			config_setup_bulkadd_act2
--->
<cfset objConfigComponents = createObject("component", "admin.assets.cfcs.config.ConfigComponents")>

<cfset stFormCopy = duplicate(FORM)>

<!--- VALIDATE AND SAVE --->
<cfset stErrors = objConfigComponents.validateBulkAdd2(stFormCopy)>

<cfif NOT structIsEmpty(stErrors)>
    <cfset objConfigComponents.setSessionValue("BulkComponent2", stFormCopy)>
    <cfset objConfigComponents.setErrorRecord(stErrors)>
    <cfset objConfigComponents.setMessage("Please correct the fields indicated below.")>
    <cflocation url="index.cfm?task=config_setup_bulkadd_frm2&Validation=1">
<cfelse>

	<cfset strSystems = objConfigComponents.getSessionValue("BulkComponent1")>

	<cfset SystemAddCount = objConfigComponents.bulkAddComponent(strSystems, stFormCopy)>

	<!--- If adding a component to default systems, add the component to all sales rep systems that are being maintained by these default systems --->
	<cfset SystemAddCountMaint = objConfigComponents.bulkAddComponentMaint(strSystems, stFormCopy)>

	<cfset SystemAddCountTotal = SystemAddCount + SystemAddCountMaint>
    
	<cfif SystemAddCountTotal EQ 0>
	    <cfset objConfigComponents.setMessage("The component wasn't added to any of your configurations; it must already be listed as a component on all of the configurations you selected!")>
	<cfelse>
		<cfif SystemAddCountMaint LE 0>
        	<cfset SystemMessage = "The component was successfully added ">
            <cfif SystemAddCountTotal EQ 1>
            	<cfset SystemMessage = SystemMessage & "once">
           	<cfelse>
            	<cfset SystemMessage = SystemMessage & "#SystemAddCountTotal# times">
            </cfif>
            <cfset SystemMessage = SystemMessage & ", as a combination of the systems/categories you selected.">
			<cfset objConfigComponents.setMessage(SystemMessage)>
		<cfelse>
        	<cfset SystemMessage = "The component was successfully added ">
            <cfif SystemAddCountTotal EQ 1>
            	<cfset SystemMessage = SystemMessage & "once">
           	<cfelse>
            	<cfset SystemMessage = SystemMessage & "#SystemAddCountTotal# times">
            </cfif>
            <cfset SystemMessage = SystemMessage & ".  This includes all of the systems/categories that you selected, and all sales rep's systems that are automatically maintained by their corresponding default system.">
			<cfset objConfigComponents.setMessage(SystemMessage)>
        </cfif>
	</cfif>
    <cflocation url="index.cfm?task=config_setup_bulkadd_dsp&RequestTimeout=6000">
</cfif>