<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	07/16/2009
	Function: 		Update component descriptions from ACCPAC
	Template:		actACCPACDesc.cfm
	Task:			serials_admin_ACCPACDescriptions_act
--->

<cfquery name="qryConfigComponents" datasource="#APPLICATION.DSN_WWW#">
SELECT DISTINCT ITEMNO
FROM  	tblConfigComponents
WHERE	ITEMNO <> '[NONE]'
ORDER BY ITEMNO
</cfquery>

<cfloop query="qryConfigComponents">

	<cfset ItemDescription = "">
    <cfquery datasource="#APPLICATION.DSN_AP#" name="qryItem">
    SELECT 	dbo.ICITEM.[DESC]
    FROM 	dbo.ICITEM
    WHERE 	dbo.ICITEM.ITEMNO = '#qryConfigComponents.ITEMNO#'
    </cfquery>
    <cfif isDefined("qryItem.Desc")>
        <cfset ItemDescription = trim(qryItem.Desc)>
    </cfif>
	
	<cfif ItemDescription IS NOT "">
		<cfquery datasource="#APPLICATION.DSN_WWW#">
		UPDATE	tblConfigComponents 
		SET		DESCRIPTION = '#ItemDescription#'
		WHERE 	ITEMNO = '#qryConfigComponents.ITEMNO#'
		</cfquery>	
	</cfif>

</cfloop>

<cflocation url="index.cfm?task=serials_admin_ACCPACDescriptions_display">