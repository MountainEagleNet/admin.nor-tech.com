<cfsilent>
	<!---
	Coded By: Alternative Systems, Inc - Ron Barth
	Create Date: 12/07/2007
	Edit Date: 
	Function: Index Page
	index.cfm 
	This page controls the layout of root pages and sets the root parameters.
	The template is created with <cfinclude>s for each of the main sections of the page
	--->
</cfsilent>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Northern Computer Technologies</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta name="KEYWORDS" content="Custom, Configuration, PCs, Laptops, Portables, Computer, Notebook, Hardware, Build, Value, Technology, Servers, Intel, Intel Premier Provider, AMD, Opteron, Dual Opteron, Athlon, Pentium, Xeon, Nor-Tech, Northern Computer Technologies, Voyageur PC, voyageurpc">
<meta name="TITLE" content="Northern Computer Technologies">
<meta name="DESCRIPTION" content="Nor-Tech is a premier wholesale OEM and a leading manufacturer of custom configured, build-to-order PCs, servers, notebooks and custom vertical market solutions.">
<meta name="AUTHOR" content="Northern Computer Technologies">
<meta name="LANGUAGE" content="en">
<meta name="DOCUMENTCOUNTRYCODE" content="us">

<link href="/techstyle.css" rel="stylesheet" type="text/css">
</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="756" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
   <td height="318" colspan="8" valign="top">
		<cfsilent>
			<cfparam name="task" default="main">
		</cfsilent>
		<cfswitch expression="#task#">
			<!--- DYNAMIC CONFIGURATOR - PRICE LISTS --->													
			<!--- New Price List, Form --->
			<cfcase value="config_pricelists_new_edit">
				<cfinclude template="frmNew.cfm">
			</cfcase>				
			<!--- New Price List, Action --->
			<cfcase value="config_pricelists_new_act">
				<cfinclude template="actNew.cfm">
			</cfcase>	
			<!--- Price List Name Page, Edit --->
			<cfcase value="config_pricelists_name_edit">
				<cfinclude template="frmName.cfm">
			</cfcase>	
			<!--- Price List Name Page, Save --->
			<cfcase value="config_pricelists_name_act">
				<cfinclude template="actName.cfm">
			</cfcase>							
			<!--- Export Price List --->
			<cfcase value="config_pricelists_export">
				<cfinclude template="actExport.cfm">
			</cfcase>				
			<!--- Delete Price List --->
			<cfcase value="config_pricelists_delete">
				<cfinclude template="delPriceList.cfm">
			</cfcase>	
			<!--- Category Page, Form --->
			<cfcase value="config_pricelists_categories_edit">
				<cfinclude template="frmCategories.cfm">
			</cfcase>	
			<!--- Category Page, Action --->
			<cfcase value="config_pricelists_categories_act">
				<cfinclude template="actCategories.cfm">
			</cfcase>

			<!--- Component Page, Form --->
			<cfcase value="config_pricelists_components_edit">
				<cfinclude template="frmComponents.cfm">
			</cfcase>	
			<cfcase value="config_pricelists_actSearch">
				<cfinclude template="actSearch.cfm">
			</cfcase>	
<!---            
			<cfcase value="config_pricelists_frmComponentsSearch">
				<cfinclude template="frmComponentsSearch.cfm">
			</cfcase>	
--->
			<!--- Component Page, Action --->
			<cfcase value="config_pricelists_components_act">
				<cfinclude template="actComponents.cfm">
			</cfcase>	

			<!--- Calculate Selling Prices --->
			<cfcase value="config_pricelists_updateprices">
				<cfinclude template="prices\actUpdatePrices.cfm">
			</cfcase>
			
			<cfcase value="admin_custaccounts_emailpricelist">
				<cfinclude template="../actEmailPriceList.cfm">
			</cfcase>	
						
			<!--- MAIN --->
			<cfdefaultcase>
				<cfset objPriceLists = createObject("component", "admin.assets.cfcs.prices.PriceLists")>
				<br><br>				
				<font color="FF0000"><cfoutput>#objPriceLists.getMessage()#</cfoutput></font>
				<br><br>Action Complete . . . Please close this browser window
			</cfdefaultcase>
		</cfswitch>
		
	</td>
  </tr>
</table>
<map name="logoMap">
<area shape="rect" coords="7,8,134,45" href="http://www.nor-tech.com" alt="Nor-tech Home">
</map>
</body>
</html>
