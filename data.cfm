<!---
<cfset objCategories = createObject("component", "admin.assets.cfcs.config.ComponentCategories")>	
<cfset qryCategories = objCategories.listACCPACCategories()>
<cfoutput query="qryCategories">
	INSERT INTO tblcatcodes(catcode_id,catcode_abbrev,catcode_name,catcode_sort,catcode_status)<br>
	VALUES('#qryCategories.CATEGORY#', '#qryCategories.CATEGORY#', '#qryCategories.DESC#', #qryCategories.CurrentRow#,'active');<br>
	&nbsp;<br>
</cfoutput>
--->