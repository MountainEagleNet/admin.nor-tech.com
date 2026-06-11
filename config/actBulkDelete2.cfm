<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	10/27/2008
	Function: 		Delete Component - Action Page
	Template:		actBulkDelete2.cfm
	Task:			config_setup_bulkdelete_act2
--->
<cfset objConfigComponents = createObject("component", "admin.assets.cfcs.config.ConfigComponents")>

<cfset stFormCopy = duplicate(FORM)>

<!--- VALIDATE AND SAVE --->
<cfset stErrors = objConfigComponents.validateBulkDelete2(stFormCopy)>

<cfif NOT structIsEmpty(stErrors)>
    <cfset objConfigComponents.setSessionValue("BulkComponent2", stFormCopy)>
    <cfset objConfigComponents.setErrorRecord(stErrors)>
    <cfset objConfigComponents.setMessage("Please correct the fields indicated below.")>
    <cflocation url="index.cfm?task=config_setup_bulkdelete_frm2&Validation=1">
<cfelse>

	<cfset strSystems = objConfigComponents.getSessionValue("BulkComponent1")>

	<cfset strBulkDelete = objConfigComponents.bulkDeleteComponent(strSystems, stFormCopy)>

	<!--- If deleting a component from default systems, delete the component in all sales rep systems that are being maintained by these default systems --->
	<cfset SystemDeleteCountMaint = objConfigComponents.bulkDeleteComponentMaint(strSystems, stFormCopy)>

	<cfset SystemDeleteCountTotal = strBulkDelete.qrySystemsDeleted.RecordCount + SystemDeleteCountMaint>

	<cfif SystemDeleteCountTotal EQ 0>
	    <cfset objConfigComponents.setMessage("The component wasn't deleted from any of your configurations.")>
	<cfelse>
		<cfif SystemDeleteCountMaint LE 0>
        	<cfset SystemMessage = "The component was successfully deleted ">
			<cfif SystemDeleteCountTotal EQ 1>
            	<cfset SystemMessage = SystemMessage & "once">
           	<cfelse>
            	<cfset SystemMessage = SystemMessage & "#SystemDeleteCountTotal# times">
            </cfif>
            <cfset SystemMessage = SystemMessage & ", as a combination of the systems/categories you selected.">
			<cfset objConfigComponents.setMessage(SystemMessage)>
		<cfelse>
        	<cfset SystemMessage = "The component was successfully deleted ">
			<cfif SystemDeleteCountTotal EQ 1>
            	<cfset SystemMessage = SystemMessage & "once">
           	<cfelse>
            	<cfset SystemMessage = SystemMessage & "#SystemDeleteCountTotal# times">
            </cfif>
            <cfset SystemMessage = SystemMessage & ".  This includes all of the systems/categories that you selected, and all sales rep's systems that are automatically maintained by their corresponding default system.">
			<cfset objConfigComponents.setMessage(SystemMessage)>
        </cfif>
	</cfif>

    <cfset objConfigComponents.setDataRecord(strBulkDelete)>

    <cflocation url="index.cfm?task=config_setup_bulkdelete_dsp&RequestTimeout=6000">
</cfif>