<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	10/21/2008
	Function: 		Replace Component - Action Page
	Template:		actBulkReplace2.cfm
	Task:			config_setup_bulkreplace_act2
--->
<cfset objConfigComponents = createObject("component", "admin.assets.cfcs.config.ConfigComponents")>

<cfset stFormCopy = duplicate(FORM)>

<!--- VALIDATE AND SAVE --->
<cfset stErrors = objConfigComponents.validateBulkReplace2(stFormCopy)>

<cfif NOT structIsEmpty(stErrors)>
    <cfset objConfigComponents.setSessionValue("BulkComponent2", stFormCopy)>
    <cfset objConfigComponents.setErrorRecord(stErrors)>
    <cfset objConfigComponents.setMessage("Please correct the fields indicated below.")>
    <cflocation url="index.cfm?task=config_setup_bulkreplace_frm2&Validation=1">
<cfelse>

	<cfset strSystems = objConfigComponents.getSessionValue("BulkComponent1")>

	<cfset SystemReplaceCount = objConfigComponents.bulkReplaceComponent(strSystems, stFormCopy)>

	<!--- If replacing a component in default systems, replace the component in all sales rep systems that are being maintained by these default systems --->
	<cfset SystemReplaceCountMaint = objConfigComponents.bulkReplaceComponentMaint(strSystems, stFormCopy)>

	<cfset SystemReplaceCountTotal = SystemReplaceCount + SystemReplaceCountMaint>

	<cfif SystemReplaceCountTotal EQ 0>
	    <cfset objConfigComponents.setMessage("The component wasn't replaced in any of your configurations; it wasn't found in any of the systems/categories you selected!")>
	<cfelse>
		<cfif SystemReplaceCountMaint LE 0>
        	<cfset SystemMessage = "The component was successfully replaced ">            
			<cfif SystemReplaceCountTotal EQ 1>
            	<cfset SystemMessage = SystemMessage & "once">
           	<cfelse>
            	<cfset SystemMessage = SystemMessage & "#SystemReplaceCountTotal# times">
            </cfif>
            <cfset SystemMessage = SystemMessage & ", as a combination of the systems/categories you selected.">
			<cfset objConfigComponents.setMessage(SystemMessage)>
		<cfelse>
        	<cfset SystemMessage = "The component was successfully replaced ">
			<cfif SystemReplaceCountTotal EQ 1>
            	<cfset SystemMessage = SystemMessage & "once">
           	<cfelse>
            	<cfset SystemMessage = SystemMessage & "#SystemReplaceCountTotal# times">
            </cfif>
            <cfset SystemMessage = SystemMessage & ".  This includes all of the systems/categories that you selected, and all sales rep's systems that are automatically maintained by their corresponding default system.">
			<cfset objConfigComponents.setMessage(SystemMessage)>
        </cfif>
	</cfif>
    <cflocation url="index.cfm?task=config_setup_bulkreplace_dsp&RequestTimeout=6000">
</cfif>