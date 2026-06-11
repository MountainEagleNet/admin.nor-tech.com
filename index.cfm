<cfsilent>
	<!---
	Coded By: Alternative Systems, Inc - Nicholas Tunney
	Create Date: 7/16/2005
	Edit Date: 
	Function: Index Page
	index.cfm 
	This page controls the layout of root pages and sets the root parameters.
	The template is created with <cfinclude>s for each of the main sections of the page
	--->
</cfsilent>

<!--- 11/24/06, Ron Barth --->
<!--- RAB 4/24/13
<cfif cgi.https is not "on">
	<cflocation url="https://#NorTechURL#/#APPLICATION.AdminLocation#/index.cfm" addtoken="No"> 
<CFABORT>
</cfif> 
--->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- InstanceBegin template="/Templates/main.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Northern Computer Technologies</title>
<!-- InstanceEndEditable --><meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta name="KEYWORDS" content="Custom, Configuration, PCs, Laptops, Portables, Computer, Notebook, Hardware, Build, Value, Technology, Servers, Intel, Intel Premier Provider, AMD, Opteron, Dual Opteron, Athlon, Pentium, Xeon, Nor-Tech, Northern Computer Technologies, Voyageur PC, voyageurpc">
<meta name="TITLE" content="Northern Computer Technologies">
<meta name="DESCRIPTION" content="Nor-Tech is a premier wholesale OEM and a leading manufacturer of custom configured, build-to-order PCs, servers, notebooks and custom vertical market solutions.">
<meta name="AUTHOR" content="Northern Computer Technologies">
<meta name="LANGUAGE" content="en">
<meta name="DOCUMENTCOUNTRYCODE" content="us">
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-->
</script>

<!--- Include scanner.js for scanner functionality --->
<cfif isDefined("task")>
	<cfset objScannerSettings = createObject("component", "admin.assets.cfcs.ScannerSettings")>	


	<cfset SearchRecord = structNew()>
	<cfset structInsert(SearchRecord, "Task", task, True)>
	<cfset qryScannerSettings = objScannerSettings.searchRecords(SearchRecord, "query")>
	<cfif qryScannerSettings.RecordCount NEQ 0>
		<script src="scripts/scanner.js"></script>
	</cfif>
</cfif>

<link href="techstyle.css" rel="stylesheet" type="text/css">
<!-- InstanceBeginEditable name="head" --><!-- InstanceEndEditable -->
</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('/imagesTemp/homeF2.gif','/imagesTemp/productsF2.gif','/imagesTemp/solutionsF2.gif','/imagesTemp/partnersF2.gif','/imagesTemp/supportF2.gif','/imagesTemp/aboutF2.gif','/imagesTemp/contactF2.gif')">
<table width="756" border="0" align="center" cellpadding="0" cellspacing="0">
<!-- fwtable fwsrc="nortechNewTempInterior.png" fwbase="temp.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
  <tr>
   <td><img src="/imagesTemp/spacer.gif" width="150" height="1" border="0" alt=""></td>
   <td><img src="/imagesTemp/spacer.gif" width="14" height="1" border="0" alt=""></td>
   <td><img src="/imagesTemp/spacer.gif" width="40" height="1" border="0" alt=""></td>
   <td><img src="/imagesTemp/spacer.gif" width="63" height="1" border="0" alt=""></td>
   <td><img src="/imagesTemp/spacer.gif" width="65" height="1" border="0" alt=""></td>
   <td><img src="/imagesTemp/spacer.gif" width="61" height="1" border="0" alt=""></td>
   <td><img src="/imagesTemp/spacer.gif" width="59" height="1" border="0" alt=""></td>
   <td><img src="/imagesTemp/spacer.gif" width="64" height="1" border="0" alt=""></td>
   <td><img src="/imagesTemp/spacer.gif" width="69" height="1" border="0" alt=""></td>
   <td><img src="/imagesTemp/spacer.gif" width="150" height="1" border="0" alt=""></td>
   <td><img src="/imagesTemp/spacer.gif" width="21" height="1" border="0" alt=""></td>
   <td><img src="/imagesTemp/spacer.gif" width="1" height="1" border="0" alt=""></td>
  </tr>

  <tr>
   <td rowspan="3"><img src="/imagesTemp/logo.gif" alt="" name="logo" width="150" height="61" border="0" usemap="#logoMap"></td>
   <td colspan="10"><img name="top" src="/imagesTemp/top.gif" width="606" height="23" border="0" alt=""></td>
   <td><img src="/imagesTemp/spacer.gif" width="1" height="23" border="0" alt=""></td>
  </tr>
  <tr>
   <td colspan="2"><a href="http://www.nor-tech.com" onMouseOver="MM_swapImage('home','','/imagesTemp/homeF2.gif',1)" onMouseOut="MM_swapImgRestore()"><img name="home" src="/imagesTemp/home.gif" width="54" height="21" border="0" alt=""></a></td>
   <td><a href="http://www.nor-tech.com/products/index.html" onMouseOver="MM_swapImage('products','','/imagesTemp/productsF2.gif',1)" onMouseOut="MM_swapImgRestore()"><img name="products" src="/imagesTemp/products.gif" width="63" height="21" border="0" alt=""></a></td>
   <td><a href="http://www.nor-tech.com/solutions/index.html" onMouseOver="MM_swapImage('solutions','','/imagesTemp/solutionsF2.gif',1)" onMouseOut="MM_swapImgRestore()"><img name="solutions" src="/imagesTemp/solutions.gif" width="65" height="21" border="0" alt=""></a></td>
   <td><a href="https://partners.nor-tech.com" onMouseOver="MM_swapImage('partners','','/imagesTemp/partnersF2.gif',1)" onMouseOut="MM_swapImgRestore()"><img name="partners" src="/imagesTemp/partners.gif" width="61" height="21" border="0" alt=""></a></td>
   <td><a href="http://www.nor-tech.com/support/index.html" onMouseOver="MM_swapImage('support','','/imagesTemp/supportF2.gif',1)" onMouseOut="MM_swapImgRestore()"><img name="support" src="/imagesTemp/support.gif" width="59" height="21" border="0" alt=""></a></td>
   <td><a href="http://www.nor-tech.com/about/index.html" onMouseOver="MM_swapImage('about','','/imagesTemp/aboutF2.gif',1)" onMouseOut="MM_swapImgRestore()"><img name="about" src="/imagesTemp/about.gif" width="64" height="21" border="0" alt=""></a></td>
   <td><a href="http://www.nor-tech.com/contact/index.cfm" onMouseOver="MM_swapImage('contact','','/imagesTemp/contactF2.gif',1)" onMouseOut="MM_swapImgRestore()"><img name="contact" src="/imagesTemp/contact.gif" width="69" height="21" border="0" alt=""></a></td>
   <td colspan="2"><img name="phone" src="/imagesTemp/phoneBlank.gif" width="171" height="21" border="0" alt=""></td>
   <td><img src="/imagesTemp/spacer.gif" width="1" height="21" border="0" alt=""></td>
  </tr>
  <tr>
   <td colspan="10"><img name="temp_r3_c2" src="/imagesTemp/temp_r3_c2.gif" width="606" height="17" border="0" alt=""></td>
   <td><img src="/imagesTemp/spacer.gif" width="1" height="17" border="0" alt=""></td>
  </tr>
  <tr>
   <td><!-- InstanceBeginEditable name="leftNavTitle" --><img name="productsNav" src="/imagesTemp/productsNav.gif" width="150" height="23" border="0" alt=""><!-- InstanceEndEditable --></td>
   <td rowspan="2"><img name="temp_r4_c2" src="/imagesTemp/temp_r4_c2.gif" width="14" height="341" border="0" alt=""></td>
	<td colspan="7" class="productTitle"><!-- InstanceBeginEditable name="title" -->
		<span class="pagetitle">
			<cfif NOT isDefined("task")>
				Administration
			<cfelseif findNoCase("serials_receipts_", task) NEQ 0>
				Receipts
			<cfelseif findNoCase("serials_orders_", task) NEQ 0 OR findNoCase("serials_shipments", task) NEQ 0>
				Orders
			<cfelseif findNoCase("serials_attach_", task) NEQ 0 OR findNoCase("serials_shipments", task) NEQ 0>
				Serial Number List
			<cfelseif findNoCase("serials_returns_", task) NEQ 0>
				Returns/RMAs
			<cfelseif findNoCase("serials_returnsvendor_", task) NEQ 0>
				Returns to Vendor
			<cfelseif findNoCase("serials_adjustments_", task) NEQ 0>
				Adjustments
			<cfelseif findNoCase("serials_transfers_", task) NEQ 0>
				Transfers
			<cfelseif findNoCase("serials_counts_", task) NEQ 0>
				Counts
			<cfelseif findNoCase("serials_corrections_", task) NEQ 0>
				Corrections
			<cfelseif findNoCase("serials_reports_", task) NEQ 0>
				Reports

			<cfelseif findNoCase("config_setup_", task) NEQ 0>
				Dynamic Configurator Setup		
			<cfelseif findNoCase("pricelists", task) NEQ 0>
				Price Lists	
<!---								
			<cfelseif findNoCase("config_setup_sysmarkup_", task) NEQ 0>
				Default Markup Percentages		
			<cfelseif findNoCase("config_setup_compcats_", task) NEQ 0>
				Component Categories				
			<cfelseif findNoCase("config_setup_systems_", task) NEQ 0 OR 
					  findNoCase("config_setup_categories_", task) NEQ 0 OR 
					  findNoCase("config_setup_components_", task) NEQ 0 OR 
					  findNoCase("config_setup_markup_", task) NEQ 0 OR 
					  findNoCase("config_setup_markupreseller_", task) NEQ 0 OR 
					  findNoCase("config_setup_price_", task) NEQ 0>
				Systems
--->
								
			<cfelse>
				Administration
			</cfif>
		</span><!-- InstanceEndEditable -->
	</td>
	<td colspan="2" class="textmain" align="right">
		<cfif isDefined("SESSION.fname")><cfoutput>#SESSION.fname#</cfoutput></cfif>
		<cfif isDefined("SESSION.lname")><cfoutput>#SESSION.lname#</cfoutput></cfif>
	</td>
   <td><img src="/imagesTemp/spacer.gif" width="1" height="23" border="0" alt=""></td>
  </tr>
  <tr>
   <td rowspan="2" valign="top" background="/imagesTemp/leftvertline.gif"><!-- InstanceBeginEditable name="leftnav" -->
		<cfinclude template="includes/left_nav.cfm">
   <!-- InstanceEndEditable --></td>
   <td height="318" colspan="8" valign="top"><!-- InstanceBeginEditable name="main" -->
		<cfsilent>
			<cfparam name="task" default="main">
		</cfsilent>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td><cfoutput>
				<div align="right" class="textsmall"><strong><a href="actLogout.cfm" class="textsmall"> Logout</a> </strong></div>
			</cfoutput></td>
		</tr>
		</table>
		
	<cftry>	<!---RAB--->
		<cfswitch expression="#task#">
			<!--- CUSTOMER ACCOUNTS --->
			<!--- search cust accounts --->
			<cfcase value="admin_custaccounts_search">
				<cfinclude template="frmCustAccountSearch.cfm">
			</cfcase>
			<!--- list all cust accounts from search --->
			<cfcase value="admin_custaccounts_list">
				<cfinclude template="lstCustAccounts.cfm">
			</cfcase>
			<!--- new cust account --->
			<cfcase value="admin_custaccounts_new">
				<cfinclude template="frmCustAccount.cfm">
			</cfcase>
			<!--- view/edit cust accounts --->
			<cfcase value="admin_custaccounts_edit">
				<cfinclude template="frmCustAccount.cfm">
			</cfcase>
			<!--- save cust account details from edit --->
			<cfcase value="admin_custaccounts_update">
				<cfinclude template="actCustAccountSave.cfm">
			</cfcase>
			<!--- list incomplete accounts --->
			<cfcase value="admin_accounts_incomplete">
				<cfinclude template="lstIncAccounts.cfm">
			</cfcase>
			<!--- view/edit incomplete cust accounts --->
			<cfcase value="admin_custaccounts_incomplete_edit">
				<cfinclude template="frmCustAccount.cfm">
			</cfcase>
			<!--- save incomplete cust account details from edit --->
			<cfcase value="admin_custaccounts_incomplete_update">
				<cfinclude template="actCustAccountSave.cfm">
			</cfcase>
			<!--- view cust accounts --->
			<cfcase value="admin_custaccounts_view">
				<cfinclude template="dspCustAccount.cfm">
			</cfcase>
			<!--- send customer email --->
			<cfcase value="admin_custaccounts_sendemail">
				<cfinclude template="actSendCustEmail.cfm">
			</cfcase>
			<cfcase value="admin_custaccounts_emailpricelist">
				<cfinclude template="actEmailPriceList.cfm">
			</cfcase>	

			<!--- Set Freight Estimator, form --->
			<cfcase value="admin_freightestimator_frm">
				<cfinclude template="frmFreightEst.cfm">
			</cfcase>
			<!--- Set Freight Estimator, save --->
			<cfcase value="admin_freightestimator_act">
				<cfinclude template="actFreightEst.cfm">
			</cfcase>
            
            <!--- PASSWORD --->
			<cfcase value="admin_password_form">
				<cfinclude template="frmPassword.cfm">
			</cfcase>	
			<cfcase value="admin_password_update">
				<cfinclude template="actPasswordSave.cfm">
			</cfcase>	
			
			<!--- ADMIN ACCOUNTS --->
			<!--- list all admin accounts --->
			<cfcase value="admin_accounts_list">
				<cfinclude template="lstAdminAccounts.cfm">
			</cfcase>
			<!--- new admin account --->
			<cfcase value="admin_accounts_new">
				<cfinclude template="frmAdminAccount.cfm">
			</cfcase>
			<!--- view/edit admin accounts --->
			<cfcase value="admin_accounts_edit">
				<cfinclude template="frmAdminAccount.cfm">
			</cfcase>
			<!--- save admin account details from edit --->
			<cfcase value="admin_accounts_update">
				<cfinclude template="actAdminAccountSave.cfm">
			</cfcase>
			<!--- delete admin account --->
			<cfcase value="admin_accounts_delete">
				<cfinclude template="actAdminAccountDelete.cfm">
			</cfcase>
			
			<!--- SALES REP ACCOUNTS --->
			<!--- new sales rep account --->
			<cfcase value="admin_salesrep_new">
				<cfinclude template="frmSalesRep.cfm">
			</cfcase>
			<!--- view/edit sales rep accounts --->
			<cfcase value="admin_salesrep_edit">
				<cfinclude template="frmSalesRep.cfm">
			</cfcase>
			<!--- save sales rep account details from edit --->
			<cfcase value="admin_salesrep_update">
				<cfinclude template="actSalesRepSave.cfm">
			</cfcase>
			
			<!--- ACCPAC IMPORT --->
			<cfcase value="admin_accounts_import_landing">
				<cfinclude template="dspCustomerImport.cfm">
			</cfcase>
			<cfcase value="admin_accounts_import">
				<cfinclude template="actCustomerImport.cfm">
			</cfcase>


			<!---*****************************************************************--->
			<!--- DYNAMIC CONFIGURATOR --->
			
			<!--- DEFAULT SYSTEMS or SYSTEMS --->
			<cfcase value="config_setup_systems_list">
				<cfinclude template="config\lstSystems.cfm">
			</cfcase>
			<cfcase value="config_setup_systems_sort">
				<cfinclude template="config\lstSystemsSort.cfm">
			</cfcase>
			<cfcase value="config_setup_systems_sortup">
				<cfinclude template="config\sortupSystem.cfm">
			</cfcase>	
			<cfcase value="config_setup_systems_sortdown">
				<cfinclude template="config\sortdownSystem.cfm">
			</cfcase>	
            
            <!--- BULK ADD COMPONENTS --->
			<cfcase value="config_setup_bulkadd_frm">
				<cfinclude template="config\frmBulkAdd.cfm">
			</cfcase>	
			<cfcase value="config_setup_bulkadd_act">
				<cfinclude template="config\actBulkAdd.cfm">
			</cfcase>	
			<cfcase value="config_setup_bulkadd_frm2">
				<cfinclude template="config\frmBulkAdd2.cfm">
			</cfcase>	
			<cfcase value="config_setup_bulkadd_act2">
				<cfinclude template="config\actBulkAdd2.cfm">
			</cfcase>	
			<cfcase value="config_setup_bulkadd_dsp">
				<cfinclude template="config\dspBulkAdd.cfm">
			</cfcase>	
            
            <!--- BULK REPLACE COMPONENTS --->
			<cfcase value="config_setup_bulkreplace_frm">
				<cfinclude template="config\frmBulkReplace.cfm">
			</cfcase>	
			<cfcase value="config_setup_bulkreplace_act">
				<cfinclude template="config\actBulkReplace.cfm">
			</cfcase>	
			<cfcase value="config_setup_bulkreplace_frm2">
				<cfinclude template="config\frmBulkReplace2.cfm">
			</cfcase>	
			<cfcase value="config_setup_bulkreplace_act2">
				<cfinclude template="config\actBulkReplace2.cfm">
			</cfcase>	
			<cfcase value="config_setup_bulkreplace_dsp">
				<cfinclude template="config\dspBulkReplace.cfm">
			</cfcase>	
            
            <!--- BULK DELETE COMPONENTS --->
			<cfcase value="config_setup_bulkdelete_frm">
				<cfinclude template="config\frmBulkDelete.cfm">
			</cfcase>	
			<cfcase value="config_setup_bulkdelete_act">
				<cfinclude template="config\actBulkDelete.cfm">
			</cfcase>	
			<cfcase value="config_setup_bulkdelete_frm2">
				<cfinclude template="config\frmBulkDelete2.cfm">
			</cfcase>	
			<cfcase value="config_setup_bulkdelete_act2">
				<cfinclude template="config\actBulkDelete2.cfm">
			</cfcase>	
			<cfcase value="config_setup_bulkdelete_dsp">
				<cfinclude template="config\dspBulkDelete.cfm">
			</cfcase>	
			
			<cfcase value="config_setup_systems_edit">
				<cfinclude template="config\frmSystem.cfm">
			</cfcase>
			<cfcase value="config_setup_systems_new">
				<cfinclude template="config\frmSystem.cfm">
			</cfcase>
			<cfcase value="config_setup_systems_save">
				<cfinclude template="config\savSystem.cfm">
			</cfcase>




			<cfcase value="config_setup_serveroptions_edit">
				<cfinclude template="config\frmServerOptions.cfm">
			</cfcase>
			<cfcase value="config_setup_serveroptions_save">
				<cfinclude template="config\savServerOptions.cfm">
			</cfcase>






			<cfcase value="config_setup_systems_copy">
				<cfinclude template="config\copySystem.cfm">
			</cfcase>			
			<cfcase value="config_setup_systems_delete">
				<cfinclude template="config\delSystem.cfm">
			</cfcase>	
			<cfcase value="config_setup_categories_edit">
				<cfinclude template="config\frmComponentCategories.cfm">
			</cfcase>	
			<cfcase value="config_setup_categories_save">
				<cfinclude template="config\savComponentCategories.cfm">
			</cfcase>
			<cfcase value="config_setup_categories_list">
				<cfinclude template="config\lstComponentCategories.cfm">
			</cfcase>					
			<cfcase value="config_setup_categories_list_act">
				<cfinclude template="config\actComponentCategories.cfm">
			</cfcase>
            
			<cfcase value="config_setup_components_edit">
				<cfinclude template="config\frmComponents.cfm">
			</cfcase>	
			<cfcase value="config_setup_components_save">
				<cfinclude template="config\savComponents.cfm">
			</cfcase>	
            
            
			<cfcase value="config_setup_components_caseimage_edit">
				<cfinclude template="config\frmCaseImage.cfm">
			</cfcase>	
			<cfcase value="config_setup_components_caseimage_save">
				<cfinclude template="config\savCaseImage.cfm">
			</cfcase>	
            
            
            
			<cfcase value="config_setup_warranty_edit">
				<cfinclude template="config\frmWarranty.cfm">
			</cfcase>	
			<cfcase value="config_setup_warranty_save">
				<cfinclude template="config\savWarranty.cfm">
			</cfcase>	
            			
			<cfcase value="config_setup_markup_edit">
				<cfinclude template="config\frmMarkUp.cfm">
			</cfcase>	
			<cfcase value="config_setup_markup_save">
				<cfinclude template="config\savMarkUp.cfm">
			</cfcase>	
			<cfcase value="config_setup_markupreseller_edit">
				<cfinclude template="config\frmMarkUpReseller.cfm">
			</cfcase>	
			<cfcase value="config_setup_markupreseller_save">
				<cfinclude template="config\savMarkUpReseller.cfm">
			</cfcase>	
			<cfcase value="config_setup_markupreseller_delete">
				<cfinclude template="config\delMarkUpReseller.cfm">
			</cfcase>	
			<cfcase value="config_setup_price_edit">
				<cfinclude template="config\frmPrice.cfm">
			</cfcase>	
			<cfcase value="config_setup_price_save">
				<cfinclude template="config\savPrice.cfm">
			</cfcase>	
			<cfcase value="config_setup_resellers_edit">
				<cfinclude template="config\frmAssignResellers.cfm">
			</cfcase>	
			<cfcase value="config_setup_resellers_save">
				<cfinclude template="config\savAssignResellers.cfm">
			</cfcase>
			<cfcase value="admin_reseller_systems_edit">
				<cfinclude template="config\frmAssignSystems.cfm">
			</cfcase>
			<cfcase value="admin_reseller_systems_save">
				<cfinclude template="config\savAssignSystems.cfm">
			</cfcase>			

			<cfcase value="config_setup_defaultsystems_list">
				<cfinclude template="config\lstDefaultSystems.cfm">
			</cfcase>					
			<cfcase value="config_setup_defaultsystems_copy">
				<cfinclude template="config\copyDefaultSystems.cfm">
			</cfcase>	

			<cfcase value="config_setup_salesrepsystems_list">
				<cfinclude template="config\lstSalesRepSystems.cfm">
			</cfcase>					
			<cfcase value="config_setup_salesrepsystems_copy">
				<cfinclude template="config\copySalesRepSystems.cfm">
			</cfcase>	

			<!--- SYSTEM CLASSIFICATIONS --->
			<cfcase value="classifications_list">
				<cfinclude template="classifications\lstClassifications.cfm">
			</cfcase>
			<cfcase value="classifications_delete">
				<cfinclude template="classifications\delClassification.cfm">
			</cfcase>
			<cfcase value="classifications_new">
				<cfinclude template="classifications\frmClassification.cfm">
			</cfcase>
			<cfcase value="classifications_edit">
				<cfinclude template="classifications\frmClassification.cfm">
			</cfcase>
			<cfcase value="classifications_save">
				<cfinclude template="classifications\savClassification.cfm">
			</cfcase>
												
			<!--- COMPONENT CATEGORIES --->
			<cfcase value="config_setup_compcats_list">
				<cfinclude template="config\lstCompCats.cfm">
			</cfcase>
			<cfcase value="config_setup_compcats_edit">
				<cfinclude template="config\frmCompCat.cfm">
			</cfcase>			
			<cfcase value="config_setup_compcats_new">
				<cfinclude template="config\frmCompCat.cfm">
			</cfcase>				
			<cfcase value="config_setup_compcats_save">
				<cfinclude template="config\savCompCat.cfm">
			</cfcase>					
			<cfcase value="config_setup_compcats_delete">
				<cfinclude template="config\delCompCat.cfm">
			</cfcase>	
			<cfcase value="config_setup_compcats_sortup">
				<cfinclude template="config\sortupCompCat.cfm">
			</cfcase>	
			<cfcase value="config_setup_compcats_sortdown">
				<cfinclude template="config\sortdownCompCat.cfm">
			</cfcase>	

			<!--- SYSTEM IMAGES --->
			<cfcase value="config_setup_photos_list">
				<cfinclude template="config\lstPhotos.cfm">
			</cfcase>
			<cfcase value="config_setup_photos_edit">
				<cfinclude template="config\frmPhoto.cfm">
			</cfcase>
			<cfcase value="config_setup_photos_new">
				<cfinclude template="config\frmPhoto.cfm">
			</cfcase>
			<cfcase value="config_setup_photos_save">
				<cfinclude template="config\savPhoto.cfm">
			</cfcase>
			<cfcase value="config_setup_photos_delete">
				<cfinclude template="config\delPhoto.cfm">
			</cfcase>
						
			<!--- DEFAULT MARKUP PERCENTAGES --->
			<cfcase value="config_setup_sysmarkup_edit">
				<cfinclude template="config\frmSysMarkup.cfm">
			</cfcase>				
			<cfcase value="config_setup_sysmarkup_save">
				<cfinclude template="config\savSysMarkup.cfm">
			</cfcase>
			
			<!---*****************************************************************--->
			<!--- DYNAMIC CONFIGURATOR - PRICE LISTS --->													

			<!--- List Price Lists --->
			<cfcase value="config_pricelists_list">
				<cfinclude template="prices\lstPriceLists.cfm">
			</cfcase>
<!---		
			<!--- New Price List, Form --->
			<cfcase value="config_pricelists_new_edit">
				<cfinclude template="prices\frmNew.cfm">
			</cfcase>				
			<!--- New Price List, Action --->
			<cfcase value="config_pricelists_new_act">
				<cfinclude template="prices\actNew.cfm">
			</cfcase>				

			<!--- Price List Name Page, Edit --->
			<cfcase value="config_pricelists_name_edit">
				<cfinclude template="prices\frmName.cfm">
			</cfcase>				
			<!--- Price List Name Page, Save --->
			<cfcase value="config_pricelists_name_act">
				<cfinclude template="prices\actName.cfm">
			</cfcase>
			<!--- Export Price List --->
			<cfcase value="config_pricelists_export">
				<cfinclude template="prices\actExport.cfm">
			</cfcase>				
			<!--- Delete Price List --->
			<cfcase value="config_pricelists_delete">
				<cfinclude template="prices\delPriceList.cfm">
			</cfcase>	
						
						
			<!--- Calculate Selling Prices --->
			<cfcase value="config_pricelists_updateprices">
				<cfinclude template="prices\actUpdatePrices.cfm">
			</cfcase>
						
			<!--- Category Page, Form --->
			<cfcase value="config_pricelists_categories_edit">
				<cfinclude template="prices\frmCategories.cfm">
			</cfcase>	
			<!--- Category Page, Action --->
			<cfcase value="config_pricelists_categories_act">
				<cfinclude template="prices\actCategories.cfm">
			</cfcase>					
			<!--- Component Page, Form --->
			<cfcase value="config_pricelists_components_edit">
				<cfinclude template="prices\frmComponents.cfm">
			</cfcase>	
			<!--- Component Page, Action --->
			<cfcase value="config_pricelists_components_act">
				<cfinclude template="prices\actComponents.cfm">
			</cfcase>				
--->	

		
			<!--- Import from ACCPAC --->
			<cfcase value="config_pricelists_import_edit">
				<cfinclude template="prices\frmImportComponents.cfm">
			</cfcase>	
			<cfcase value="config_pricelists_import_act">
				<cfinclude template="prices\actImportComponents.cfm">
			</cfcase>				
			<cfcase value="config_pricelists_import_view">
				<cfinclude template="prices\dspImportComponents.cfm">
			</cfcase>	

			<!--- Remove parts from Price Lists that aren’t web-enabled in ACCPAC --->
			<cfcase value="config_pricelists_webdisabled_edit">
				<cfinclude template="prices\frmWebDisabled.cfm">
			</cfcase>	
			<cfcase value="config_pricelists_webdisabled_act">
				<cfinclude template="prices\actWebDisabled.cfm">
			</cfcase>				
			<cfcase value="config_pricelists_webdisabled_view">
				<cfinclude template="prices\dspWebDisabled.cfm">
			</cfcase>	
						
			<!--- Update Category Descriptions from ACCPAC --->
			<cfcase value="config_pricelists_import_categories_edit">
				<cfinclude template="prices\frmImportCategories.cfm">
			</cfcase>	
			<cfcase value="config_pricelists_import_categories_act">
				<cfinclude template="prices\actImportCategories.cfm">
			</cfcase>				
			<cfcase value="config_pricelists_import_categories_view">
				<cfinclude template="prices\dspImportCategories.cfm">
			</cfcase>
			
			<!---*****************************************************************--->
			<!--- SERIALIZATION SYSTEM --->
			
			<!--- RECEIPTS --->
			<!--- List Receipts --->
			<cfcase value="serials_receipts_list">
				<cfinclude template="serials\receipts\lstReceipts.cfm">
			</cfcase>
			<!--- Find a Receipt --->
			<cfcase value="serials_receipts_find">
				<cfinclude template="serials\receipts\findReceipt.cfm">
			</cfcase>			
			<!--- List Items for Receipt --->
			<cfcase value="serials_receipts_items_list">
				<cfinclude template="serials\receipts\lstItems.cfm">
			</cfcase>		
			<!--- Enter Serial Numbers --->
			<cfcase value="serials_receipts_serials_edit">
				<cfinclude template="serials\receipts\frmSerials.cfm">
			</cfcase>				
			<!--- Action Page --->
			<cfcase value="serials_receipts_serials_act">
				<cfinclude template="serials\receipts\actSerials.cfm">
			</cfcase>
			<!--- Enter Quantity for Consec Function --->
			<cfcase value="serials_receipts_consec_qty">
				<cfinclude template="serials\receipts\frmConsecutive.cfm">
			</cfcase>
			
			<!--- Consecutive Order 3 Function, Enter Quantity --->
			<cfcase value="serials_receipts_consec3_qty">
				<cfinclude template="serials\receipts\frmCons3Quantity.cfm">
			</cfcase>
			<!--- Consecutive Order 3 Function, Quantity Action Page --->
			<cfcase value="serials_receipts_consec3_qty_act">
				<cfinclude template="serials\receipts\actCons3Quantity.cfm">
			</cfcase>						
			<!--- Consecutive Order 3 Function, Enter Serial Numbers --->
			<cfcase value="serials_receipts_consec3_serials">
				<cfinclude template="serials\receipts\frmCons3Serials.cfm">
			</cfcase>			
			<!--- Consecutive Order 3 Function, Serial Number Action Page --->
			<cfcase value="serials_receipts_consec3_serials_act">
				<cfinclude template="serials\receipts\actCons3Serials.cfm">
			</cfcase>
						
			<!--- Warning Page --->
			<cfcase value="serials_receipts_warning">
				<cfinclude template="serials\receipts\frmWarning.cfm">
			</cfcase>							
			<!--- Warning Action Page --->
			<cfcase value="serials_receipts_warning_act">
				<cfinclude template="serials\receipts\actWarning.cfm">
			</cfcase>	
			<!--- Password Page --->
			<cfcase value="serials_receipts_password">
				<cfinclude template="serials\receipts\frmPassword.cfm">
			</cfcase>							
			<!--- Password Action Page --->
			<cfcase value="serials_receipts_password_act">
				<cfinclude template="serials\receipts\actPassword.cfm">
			</cfcase>	
			<!--- Post Serial Numbers --->
			<cfcase value="serials_receipts_serials_post">
				<cfinclude template="serials\receipts\actPost.cfm">
			</cfcase>					
			<!--- Add S/N boxes --->
			<cfcase value="serials_receipts_serials_add">
				<cfinclude template="serials\receipts\frmAdd.cfm">
			</cfcase>					
			<!--- Display Serial Numbers --->
			<cfcase value="serials_receipts_serials_view">
				<cfinclude template="serials\receipts\dspSerials.cfm">
			</cfcase>		
			<!--- Reprint Bar Code Labels --->
			<cfcase value="serials_receipts_serials_reprint">
				<cfinclude template="serials\receipts\actReprint.cfm">
			</cfcase>							
			<!--- Remove Receipt from List --->
			<cfcase value="serials_receipts_list_remove_form">
				<cfinclude template="serials\receipts\frmRemove.cfm">
			</cfcase>	
			<cfcase value="serials_receipts_list_remove">
				<cfinclude template="serials\receipts\actRemove.cfm">
			</cfcase>		
			<!--- Delete Serial Numbers --->
			<cfcase value="serials_receipts_serials_delete">
				<cfinclude template="serials\receipts\actDeleteSerials.cfm">
			</cfcase>				
						
			<!--- ORDERS --->
			<!--- Enter Order Number --->
			<cfcase value="serials_orders_enter">
				<cfinclude template="serials\orders\enterOrder.cfm">
			</cfcase>
			<!--- Find an Order --->
			<cfcase value="serials_orders_find">
				<cfinclude template="serials\orders\findOrder.cfm">
			</cfcase>
			<!--- List Items for Order --->
			<cfcase value="serials_orders_items_list">
				<cfinclude template="serials\orders\lstOrderItems.cfm">
			</cfcase>				
			<!--- List Shipments --->
			<cfcase value="serials_shipments_list">
				<cfinclude template="serials\orders\lstShipments.cfm">
			</cfcase>				
			<!--- List Items for Shipment --->
			<cfcase value="serials_shipments_items_list">
				<cfinclude template="serials\orders\lstItems.cfm">
			</cfcase>
			<!--- Report Backorders --->
			<cfcase value="serials_shipments_report_backorders">
				<cfinclude template="serials\orders\actBackOrder.cfm">
			</cfcase>					
			<!--- Enter Serial Numbers --->
			<cfcase value="serials_shipments_serials_edit">
				<cfinclude template="serials\orders\frmSerials.cfm">
			</cfcase>				
			<!--- Action Page --->
			<cfcase value="serials_shipments_serials_act">
				<cfinclude template="serials\orders\actSerials.cfm">
			</cfcase>
			<!--- Enter Quantity for Consec Function --->
			<cfcase value="serials_shipments_consec_qty">
				<cfinclude template="serials\orders\frmConsecutive.cfm">
			</cfcase>	

			<!--- Consecutive Order 3 Function, Enter Quantity --->
			<cfcase value="serials_shipments_consec3_qty">
				<cfinclude template="serials\orders\frmCons3Quantity.cfm">
			</cfcase>
			<!--- Consecutive Order 3 Function, Quantity Action Page --->
			<cfcase value="serials_shipments_consec3_qty_act">
				<cfinclude template="serials\orders\actCons3Quantity.cfm">
			</cfcase>						
			<!--- Consecutive Order 3 Function, Enter Serial Numbers --->
			<cfcase value="serials_shipments_consec3_serials">
				<cfinclude template="serials\orders\frmCons3Serials.cfm">
			</cfcase>			
			<!--- Consecutive Order 3 Function, Serial Number Action Page --->
			<cfcase value="serials_shipments_consec3_serials_act">
				<cfinclude template="serials\orders\actCons3Serials.cfm">
			</cfcase>
			
			<!--- Enter Quantity for Replicate Function --->
			<cfcase value="serials_shipments_replicate_qty">
				<cfinclude template="serials\orders\frmReplicate.cfm">
			</cfcase>												
			<!--- Action Page for Replicate Function --->
			<cfcase value="serials_shipments_replicate_act">
				<cfinclude template="serials\orders\actReplicate.cfm">
			</cfcase>				<!--- Warning Page --->
			<cfcase value="serials_shipments_warning">
				<cfinclude template="serials\orders\frmWarning.cfm">
			</cfcase>							
			<!--- Warning Action Page --->
			<cfcase value="serials_shipments_warning_act">
				<cfinclude template="serials\orders\actWarning.cfm">
			</cfcase>		
			<!--- Password Page --->
			<cfcase value="serials_shipments_password">
				<cfinclude template="serials\orders\frmPassword.cfm">
			</cfcase>							
			<!--- Password Action Page --->
			<cfcase value="serials_shipments_password_act">
				<cfinclude template="serials\orders\actPassword.cfm">
			</cfcase>	
			<!--- Post Serial Numbers --->
			<cfcase value="serials_shipments_serials_post">
				<cfinclude template="serials\orders\actPost.cfm">
			</cfcase>					
			<!--- Display Serial Numbers --->
			<cfcase value="serials_shipments_serials_view">
				<cfinclude template="serials\orders\dspSerials.cfm">
			</cfcase>
			<!--- Delete Serial Numbers --->
			<cfcase value="serials_shipments_serials_delete">
				<cfinclude template="serials\orders\actDeleteSerials.cfm">
			</cfcase>					
			<!--- Correct Serial Number --->
			<cfcase value="serials_shipments_correct_edit">
				<cfinclude template="serials\orders\frmCorrectSerial.cfm">
			</cfcase>				
			<!--- Correct Serial Number, Action Page --->
			<cfcase value="serials_shipments_correct_act">
				<cfinclude template="serials\orders\actCorrectSerial.cfm">
			</cfcase>
			<!--- Apply Serial Numbers from Receipt, Enter Receipt Number --->
			<cfcase value="serials_shipments_apply_edit">
				<cfinclude template="serials\orders\frmSerialsApply.cfm">
			</cfcase>								
			<!--- Apply Serial Numbers from Receipt, Action Page --->
			<cfcase value="serials_shipments_apply_act">
				<cfinclude template="serials\orders\actSerialsApply.cfm">
			</cfcase>		
			<!--- Copy Serial Numbers from Another Order, Enter Order Number --->
			<cfcase value="serials_shipments_orderapply_edit">
				<cfinclude template="serials\orders\frmSerialsOrderApply.cfm">
			</cfcase>								
			<!--- Copy Serial Numbers from Another Order, Action Page --->
			<cfcase value="serials_shipments_orderapply_act">
				<cfinclude template="serials\orders\actSerialsOrderApply.cfm">
			</cfcase>		
						
			<!--- SERIAL NUMBER LIST --->
			<!--- Enter Order Number --->
			<cfcase value="serials_attach_order_enter">
				<cfinclude template="serials\orders\enterAttachOrder.cfm">
			</cfcase>			
			<!--- Find an Order --->
			<cfcase value="serials_attach_order_find">
				<cfinclude template="serials\orders\findAttachOrder.cfm">
			</cfcase>				
			<!--- List Order to Attach --->
			<cfcase value="serials_attach_list">
				<cfinclude template="serials\orders\lstAttach.cfm">
			</cfcase>		
			<!--- Attach Action Page --->
			<cfcase value="serials_attach_act">
				<cfinclude template="serials\orders\actAttach.cfm">
			</cfcase>		
			<!--- Attach Confirmation Page --->
			<cfcase value="serials_attach_confirm">
				<cfinclude template="serials\orders\confAttach.cfm">
			</cfcase>	
			<!--- Confirmation Action Page --->
			<cfcase value="serials_attach_confirm_act">
				<cfinclude template="serials\orders\actConfAttach.cfm">
			</cfcase>	
			<!--- Response Page --->
			<cfcase value="serials_attach_confirm_view">
				<cfinclude template="serials\orders\dspAttach.cfm">
			</cfcase>	
			<!--- Serial Number List Page --->
			<cfcase value="serials_attach_print">
				<cfinclude template="serials\orders\printSerialList.cfm">
			</cfcase>	
			
			<!--- RETURNS/RMAS --->
			<!--- Choose Auth or Rcv --->
			<cfcase value="serials_returns_select">
				<cfinclude template="serials\returns\selectAction.cfm">
			</cfcase>			
			<!--- Enter RMA Number --->
			<cfcase value="serials_returns_enter">
				<cfinclude template="serials\returns\enterRMA.cfm">
			</cfcase>
			<!--- Find an RMA --->
			<cfcase value="serials_returns_find">
				<cfinclude template="serials\returns\findRMA.cfm">
			</cfcase>			
			<!--- List Items for RMA --->
			<cfcase value="serials_returns_items_list">
				<cfinclude template="serials\returns\lstItems.cfm">
			</cfcase>		
			<!--- Enter S/N's (authorization) --->
			<cfcase value="serials_returns_serialsauth_edit">
				<cfinclude template="serials\returns\frmSerialsAuth.cfm">
			</cfcase>	
			<!--- Enter S/N's (receiving) --->
			<cfcase value="serials_returns_serialsrcv_edit">
				<cfinclude template="serials\returns\frmSerialsRcv.cfm">
			</cfcase>			
			<!--- Action Page --->
			<cfcase value="serials_returns_serials_act">
				<cfinclude template="serials\returns\actSerials.cfm">
			</cfcase>
			<!--- Enter Quantity for Consec Function --->
			<cfcase value="serials_returns_consec_qty">
				<cfinclude template="serials\returns\frmConsecutive.cfm">
			</cfcase>			
			<!--- Warning Page --->
			<cfcase value="serials_returns_warning">
				<cfinclude template="serials\returns\frmWarning.cfm">
			</cfcase>							
			<!--- Warning Action Page --->
			<cfcase value="serials_returns_warning_act">
				<cfinclude template="serials\returns\actWarning.cfm">
			</cfcase>			
			<!--- Post Serial Numbers --->
			<cfcase value="serials_returns_serials_post">
				<cfinclude template="serials\returns\actPost.cfm">
			</cfcase>					
			<!--- Display Serial Numbers --->
			<cfcase value="serials_returns_serials_view">
				<cfinclude template="serials\returns\dspSerials.cfm">
			</cfcase>	
			<!--- Delete Serial Numbers --->
			<cfcase value="serials_returns_serials_delete">
				<cfinclude template="serials\returns\actDeleteSerials.cfm">
			</cfcase>
			<!--- Reprint Bar Code Labels --->
			<cfcase value="serials_returns_serials_reprint">
				<cfinclude template="serials\returns\actReprint.cfm">
			</cfcase>
			<!--- Receive Serial Numbers --->
			<cfcase value="serials_returns_serials_receive">
				<cfinclude template="serials\returns\actReceive.cfm">
			</cfcase>			
								
						
			<!--- RETURNS TO VENDOR --->
			<!--- List Returns --->
			<cfcase value="serials_returnsvendor_list">
				<cfinclude template="serials\vendorreturns\lstReturnsVnd.cfm">
			</cfcase>
			<!--- Find a Return --->
			<cfcase value="serials_returnsvendor_find">
				<cfinclude template="serials\vendorreturns\findReturnVnd.cfm">
			</cfcase>			
			<!--- List Items for Return --->
			<cfcase value="serials_returnsvendor_items_list">
				<cfinclude template="serials\vendorreturns\lstItems.cfm">
			</cfcase>		
			<!--- Enter Serial Numbers --->
			<cfcase value="serials_returnsvendor_serials_edit">
				<cfinclude template="serials\vendorreturns\frmSerials.cfm">
			</cfcase>				
			<!--- Action Page --->
			<cfcase value="serials_returnsvendor_serials_act">
				<cfinclude template="serials\vendorreturns\actSerials.cfm">
			</cfcase>	
			<!--- Enter Quantity for Consec Function --->
			<cfcase value="serials_returnsvendor_consec_qty">
				<cfinclude template="serials\vendorreturns\frmConsecutive.cfm">
			</cfcase>							
			<!--- Warning Page --->
			<cfcase value="serials_returnsvendor_warning">
				<cfinclude template="serials\vendorreturns\frmWarning.cfm">
			</cfcase>							
			<!--- Warning Action Page --->
			<cfcase value="serials_returnsvendor_warning_act">
				<cfinclude template="serials\vendorreturns\actWarning.cfm">
			</cfcase>			
			<!--- Post Serial Numbers --->
			<cfcase value="serials_returnsvendor_serials_post">
				<cfinclude template="serials\vendorreturns\actPost.cfm">
			</cfcase>					
			<!--- Add S/N boxes --->
			<cfcase value="serials_returnsvendor_serials_add">
				<cfinclude template="serials\vendorreturns\frmAdd.cfm">
			</cfcase>					
			<!--- Display Serial Numbers --->
			<cfcase value="serials_returnsvendor_serials_view">
				<cfinclude template="serials\vendorreturns\dspSerials.cfm">
			</cfcase>					
			<!--- Delete Serial Numbers --->
			<cfcase value="serials_returnsvendor_serials_delete">
				<cfinclude template="serials\vendorreturns\actDeleteSerials.cfm">
			</cfcase>	
			
			<!--- ADJUSTMENTS --->
			<!--- List Adjustments --->
			<cfcase value="serials_adjustments_list">
				<cfinclude template="serials\adjustments\lstAdjustments.cfm">
			</cfcase>
			<!--- Find an Adjustment --->
			<cfcase value="serials_adjustments_find">
				<cfinclude template="serials\adjustments\findAdjustment.cfm">
			</cfcase>			
			<!--- List Items for Adjustment --->
			<cfcase value="serials_adjustments_items_list">
				<cfinclude template="serials\adjustments\lstItems.cfm">
			</cfcase>		
			<!--- Enter Serial Numbers --->
			<cfcase value="serials_adjustments_serials_edit">
				<cfinclude template="serials\adjustments\frmSerials.cfm">
			</cfcase>				
			<!--- Action Page --->
			<cfcase value="serials_adjustments_serials_act">
				<cfinclude template="serials\adjustments\actSerials.cfm">
			</cfcase>
			<!--- Enter Quantity for Consec Function --->
			<cfcase value="serials_adjustments_consec_qty">
				<cfinclude template="serials\adjustments\frmConsecutive.cfm">
			</cfcase>		
			<!--- Warning Page --->
			<cfcase value="serials_adjustments_warning">
				<cfinclude template="serials\adjustments\frmWarning.cfm">
			</cfcase>							
			<!--- Warning Action Page --->
			<cfcase value="serials_adjustments_warning_act">
				<cfinclude template="serials\adjustments\actWarning.cfm">
			</cfcase>	
			<!--- Confirm Posting Page --->
			<cfcase value="serials_adjustments_serials_confirm">
				<cfinclude template="serials\adjustments\frmConfirm.cfm">
			</cfcase>						
			<!--- Post Serial Numbers --->
			<cfcase value="serials_adjustments_serials_post">
				<cfinclude template="serials\adjustments\actPost.cfm">
			</cfcase>					
			<!--- Display Serial Numbers --->
			<cfcase value="serials_adjustments_serials_view">
				<cfinclude template="serials\adjustments\dspSerials.cfm">
			</cfcase>
			<!--- Reprint Bar Code Labels --->
			<cfcase value="serials_adjustments_serials_reprint">
				<cfinclude template="serials\adjustments\actReprint.cfm">
			</cfcase>					
			<!--- Remove Adjustment from List --->
			<cfcase value="serials_adjustments_list_remove_form">
				<cfinclude template="serials\adjustments\frmRemove.cfm">
			</cfcase>					
			<cfcase value="serials_adjustments_list_remove">
				<cfinclude template="serials\adjustments\actRemove.cfm">
			</cfcase>	
			<!--- Delete Serial Numbers --->
			<cfcase value="serials_adjustments_serials_delete">
				<cfinclude template="serials\adjustments\actDeleteSerials.cfm">
			</cfcase>	
			<!--- Copy Serial Numbers to Other Lines --->
			<cfcase value="serials_adjustments_serials_copy">
				<cfinclude template="serials\adjustments\actCopySerials.cfm">
			</cfcase>	
			<!--- Copy Serial Numbers from Receipt --->
			<cfcase value="serials_adjustments_serials_copy_edit">
				<cfinclude template="serials\adjustments\frmSerialsCopy.cfm">
			</cfcase>	
			<cfcase value="serials_adjustments_serials_copy_act">
				<cfinclude template="serials\adjustments\actSerialsCopy.cfm">
			</cfcase>	
												
			<!--- TRANSFERS --->
			<!--- List Transfers --->
			<cfcase value="serials_transfers_list">
				<cfinclude template="serials\transfers\lstTransfers.cfm">
			</cfcase>
			<!--- Find a Transfer --->
			<cfcase value="serials_transfers_find">
				<cfinclude template="serials\transfers\findTransfer.cfm">
			</cfcase>			
			<!--- List Items for Transfer --->
			<cfcase value="serials_transfers_items_list">
				<cfinclude template="serials\transfers\lstItems.cfm">
			</cfcase>		
			<!--- Enter Serial Numbers --->
			<cfcase value="serials_transfers_serials_edit">
				<cfinclude template="serials\transfers\frmSerials.cfm">
			</cfcase>				
			<!--- Action Page --->
			<cfcase value="serials_transfers_serials_act">
				<cfinclude template="serials\transfers\actSerials.cfm">
			</cfcase>
			<!--- Enter Quantity for Consec Function --->
			<cfcase value="serials_transfers_consec_qty">
				<cfinclude template="serials\transfers\frmConsecutive.cfm">
			</cfcase>								
			<!--- Warning Page --->
			<cfcase value="serials_transfers_warning">
				<cfinclude template="serials\transfers\frmWarning.cfm">
			</cfcase>							
			<!--- Warning Action Page --->
			<cfcase value="serials_transfers_warning_act">
				<cfinclude template="serials\transfers\actWarning.cfm">
			</cfcase>	
			<!--- Post Serial Numbers --->
			<cfcase value="serials_transfers_serials_post">
				<cfinclude template="serials\transfers\actPost.cfm">
			</cfcase>					
			<!--- Display Serial Numbers --->
			<cfcase value="serials_transfers_serials_view">
				<cfinclude template="serials\transfers\dspSerials.cfm">
			</cfcase>
			<!--- Delete Serial Numbers --->
			<cfcase value="serials_transfers_serials_delete">
				<cfinclude template="serials\transfers\actDeleteSerials.cfm">
			</cfcase>	
			
			<!--- COUNTS --->
			<!--- Enter Item Number, etc --->
			<cfcase value="serials_counts_enter">
				<cfinclude template="serials\counts\frmCount.cfm">
			</cfcase>
			<!--- Validate/Save Item, etc --->
			<cfcase value="serials_counts_save">
				<cfinclude template="serials\counts\savCount.cfm">
			</cfcase>
			
			<!--- "Quit" Page --->
			<cfcase value="serials_counts_quit">
				<cfinclude template="serials\counts\frmQuit.cfm">
			</cfcase>			
			<!--- "Quit" Action Page --->
			<cfcase value="serials_counts_quit_act">
				<cfinclude template="serials\counts\actQuit.cfm">
			</cfcase>	
									
			<!--- Enter Serial Numbers --->
			<cfcase value="serials_counts_serials_edit">
				<cfinclude template="serials\counts\frmSerials.cfm">
			</cfcase>				
			<!--- Action Page --->
			<cfcase value="serials_counts_serials_act">
				<cfinclude template="serials\counts\actSerials.cfm">
			</cfcase>		
			<!--- Enter Quantity for Consec Function --->
			<cfcase value="serials_counts_consec_qty">
				<cfinclude template="serials\counts\frmConsecutive.cfm">
			</cfcase>						

			<!--- Consecutive Order 3 Function, Enter Quantity --->
			<cfcase value="serials_counts_consec3_qty">
				<cfinclude template="serials\counts\frmCons3Quantity.cfm">
			</cfcase>
			<!--- Consecutive Order 3 Function, Quantity Action Page --->
			<cfcase value="serials_counts_consec3_qty_act">
				<cfinclude template="serials\counts\actCons3Quantity.cfm">
			</cfcase>						
			<!--- Consecutive Order 3 Function, Enter Serial Numbers --->
			<cfcase value="serials_counts_consec3_serials">
				<cfinclude template="serials\counts\frmCons3Serials.cfm">
			</cfcase>			
			<!--- Consecutive Order 3 Function, Serial Number Action Page --->
			<cfcase value="serials_counts_consec3_serials_act">
				<cfinclude template="serials\counts\actCons3Serials.cfm">
			</cfcase>

			<!--- Warning Page --->
			<cfcase value="serials_counts_warning">
				<cfinclude template="serials\counts\frmWarning.cfm">
			</cfcase>							
			<!--- Warning Action Page --->
			<cfcase value="serials_counts_warning_act">
				<cfinclude template="serials\counts\actWarning.cfm">
			</cfcase>	
			<!--- Display discrepancies --->
			<cfcase value="serials_counts_serials_confirm">
				<cfinclude template="serials\counts\dspDiscrepancies.cfm">
			</cfcase>				
			<!--- Post Serial Numbers --->
			<cfcase value="serials_counts_serials_post">
				<cfinclude template="serials\counts\actPost.cfm">
			</cfcase>
			<!--- Add S/N boxes --->
			<cfcase value="serials_counts_serials_add">
				<cfinclude template="serials\counts\frmAdd.cfm">
			</cfcase>									
			<!--- Display Serial Numbers --->
			<cfcase value="serials_counts_serials_view">
				<cfinclude template="serials\counts\dspSerials.cfm">
			</cfcase>
			<!--- Delete Count --->
			<cfcase value="serials_counts_delete">
				<cfinclude template="serials\counts\delCount.cfm">
			</cfcase>			
						
			<!--- CORRECTIONS --->
			<!--- Enter/Find Item Number --->
			<cfcase value="serials_corrections_item_list">
				<cfinclude template="serials\corrections\lstItems.cfm">
			</cfcase>
			<!--- List Serial Numbers --->
			<cfcase value="serials_corrections_serials_list">
				<cfinclude template="serials\corrections\lstSerials.cfm">
			</cfcase>			
			<!--- Edit Serial Number --->
			<cfcase value="serials_corrections_serials_edit">
				<cfinclude template="serials\corrections\frmSerial.cfm">
			</cfcase>				
			<!--- Confirm Serial Number --->
			<cfcase value="serials_corrections_serials_confirm">
				<cfinclude template="serials\corrections\frmConfirm.cfm">
			</cfcase>					
			<!--- Validate/Save S/N's --->
			<cfcase value="serials_corrections_serials_save">
				<cfinclude template="serials\corrections\savSerial.cfm">
			</cfcase>							
			<!--- Display Correction --->
			<cfcase value="serials_corrections_serials_view">
				<cfinclude template="serials\corrections\dspSerials.cfm">
			</cfcase>
            <!--- Delete Duplicate Serial Numbers --->
			<cfcase value="serials_corrections_delete_duplicates">
				<cfinclude template="serials\corrections\actDuplicates.cfm">
			</cfcase>			

			<!--- REPORTS --->
			<!--- List All Reports --->
			<cfcase value="serials_reports_list">
				<cfinclude template="serials\reports\lstReports.cfm">
			</cfcase>

			<!--- Bar Code, Enter S/N --->
			<cfcase value="serials_reports_label_enter">
				<cfinclude template="serials\reports\frmLabel.cfm">
			</cfcase>			
			<!--- Bar Code, Display --->
			<cfcase value="serials_reports_label_disp">
				<cfinclude template="serials\reports\dspLabel.cfm">
			</cfcase>	
			<!--- Bar Code, Print --->
			<cfcase value="serials_reports_label_print">
				<cfinclude template="serials\reports\actLabelPrint.cfm">
			</cfcase>
			<!--- Bar Code, Response --->
			<cfcase value="serials_reports_label_response">
				<cfinclude template="serials\reports\rspLabelPrint.cfm">
			</cfcase>
			
			<!--- Out of Stock Report --->
			<cfcase value="serials_reports_frmStock">
				<cfinclude template="serials\reports\frmStock.cfm">
			</cfcase>				
			<cfcase value="serials_reports_actStock">
				<cfinclude template="serials\reports\actStock.cfm">
			</cfcase>							
			<cfcase value="serials_reports_dspStock">
				<cfinclude template="serials\reports\dspStock.cfm">
			</cfcase>
			
			<!--- Export Serial Numbers to Excel --->
			<cfcase value="serials_reports_frmExport">
				<cfinclude template="serials\reports\frmExport.cfm">
			</cfcase>				
			<cfcase value="serials_reports_actExport">
				<cfinclude template="serials\reports\actExport.cfm">
			</cfcase>							
			<cfcase value="serials_reports_dspExport">
				<cfinclude template="serials\reports\dspExport.cfm">
			</cfcase>

			<!--- Intel Sales Report --->
			<cfcase value="serials_reports_frmIntel">
				<cfinclude template="serials\reports\frmIntel.cfm">
			</cfcase>				
			<cfcase value="serials_reports_actIntel">
				<cfinclude template="serials\reports\actIntel.cfm">
			</cfcase>							
						
			<!--- Close-Out Specials (Spiff) Report --->
			<cfcase value="serials_reports_frmSpiff">
				<cfinclude template="serials\reports\frmSpiff.cfm">
			</cfcase>				
			<cfcase value="serials_reports_actSpiff">
				<cfinclude template="serials\reports\actSpiff.cfm">
			</cfcase>			
			
			<!--- ADMINISTRATION --->
			<cfcase value="serials_admin_menu">
				<cfinclude template="serials\administration\menuAdmin.cfm">
			</cfcase>			
			<!--- Scanner Batch Items --->
			<cfcase value="serials_admin_batch_list">
				<cfinclude template="serials\administration\lstBatch.cfm">
			</cfcase>
			<cfcase value="serials_admin_batch_delete">
				<cfinclude template="serials\administration\delBatch.cfm">
			</cfcase>
			<cfcase value="serials_admin_batch_new">
				<cfinclude template="serials\administration\frmBatch.cfm">
			</cfcase>
			<cfcase value="serials_admin_batch_save">
				<cfinclude template="serials\administration\savBatch.cfm">
			</cfcase>
			<cfcase value="serials_admin_batch_serials">
				<cfinclude template="serials\administration\lstBatchSNs.cfm">
			</cfcase>
			
			<!--- Batch 2 Items --->
			<cfcase value="serials_admin_batch2_list">
				<cfinclude template="serials\administration\lstBatch2.cfm">
			</cfcase>
			<cfcase value="serials_admin_batch2_delete">
				<cfinclude template="serials\administration\delBatch2.cfm">
			</cfcase>
			<cfcase value="serials_admin_batch2_new">
				<cfinclude template="serials\administration\frmBatch2.cfm">
			</cfcase>
			<cfcase value="serials_admin_batch2_save">
				<cfinclude template="serials\administration\savBatch2.cfm">
			</cfcase>

			<!--- Print Bar Code Items --->
			<cfcase value="serials_admin_barcode_list">
				<cfinclude template="serials\administration\lstBarCode.cfm">
			</cfcase>
			<cfcase value="serials_admin_barcode_delete">
				<cfinclude template="serials\administration\delBarCode.cfm">
			</cfcase>
			<cfcase value="serials_admin_barcode_new">
				<cfinclude template="serials\administration\frmBarCode.cfm">
			</cfcase>
			<cfcase value="serials_admin_barcode_save">
				<cfinclude template="serials\administration\savBarCode.cfm">
			</cfcase>
			<!--- Virtual Items --->
			<cfcase value="serials_admin_virtual_list">
				<cfinclude template="serials\administration\lstVirtual.cfm">
			</cfcase>
			<cfcase value="serials_admin_virtual_delete">
				<cfinclude template="serials\administration\delVirtual.cfm">
			</cfcase>
			<cfcase value="serials_admin_virtual_new">
				<cfinclude template="serials\administration\frmVirtual.cfm">
			</cfcase>
			<cfcase value="serials_admin_virtual_save">
				<cfinclude template="serials\administration\savVirtual.cfm">
			</cfcase>
			<!--- Create Serial Numbers /  Bar Codes --->
			<cfcase value="serials_admin_create_enter">
				<cfinclude template="serials\administration\frmCreate.cfm">
			</cfcase>
			<cfcase value="serials_admin_create_act">
				<cfinclude template="serials\administration\actCreate.cfm">
			</cfcase>
			<cfcase value="serials_admin_create_view">
				<cfinclude template="serials\administration\dspCreate.cfm">
			</cfcase>

			<!--- Software Excluded Items --->
			<cfcase value="serials_admin_SW_list">
				<cfinclude template="serials\administration\lstSoftwareExclude.cfm">
			</cfcase>
			<cfcase value="serials_admin_SW_delete">
				<cfinclude template="serials\administration\delSoftwareExclude.cfm">
			</cfcase>
			<cfcase value="serials_admin_SW_new">
				<cfinclude template="serials\administration\frmSoftwareExclude.cfm">
			</cfcase>
			<cfcase value="serials_admin_SW_save">
				<cfinclude template="serials\administration\savSoftwareExclude.cfm">
			</cfcase>

			<!--- Comp Build Items --->
			<cfcase value="serials_admin_compbuild_list">
				<cfinclude template="serials\administration\lstCompBuild.cfm">
			</cfcase>
			<cfcase value="serials_admin_compbuild_delete">
				<cfinclude template="serials\administration\delCompBuild.cfm">
			</cfcase>
			<cfcase value="serials_admin_compbuild_new">
				<cfinclude template="serials\administration\frmCompBuild.cfm">
			</cfcase>
			<cfcase value="serials_admin_compbuild_save">
				<cfinclude template="serials\administration\savCompBuild.cfm">
			</cfcase>
						
			<!--- Delete Orphaned Serial Numbers --->
			<cfcase value="serials_admin_orphans_form">
				<cfinclude template="serials\administration\frmOrphans.cfm">
			</cfcase>
			<cfcase value="serials_admin_orphans_list">
				<cfinclude template="serials\administration\lstOrphans.cfm">
			</cfcase>
			<cfcase value="serials_admin_orphans_act">
				<cfinclude template="serials\administration\actOrphans.cfm">
			</cfcase>
			<cfcase value="serials_admin_orphans_display">
				<cfinclude template="serials\administration\dspOrphans.cfm">
			</cfcase>

			<!--- Update component descriptions from ACCPAC --->
			<cfcase value="serials_admin_ACCPACDescriptions_form">
				<cfinclude template="serials\administration\frmACCPACDesc.cfm">
			</cfcase>
			<cfcase value="serials_admin_ACCPACDescriptions_act">
				<cfinclude template="serials\administration\actACCPACDesc.cfm">
			</cfcase>
			<cfcase value="serials_admin_ACCPACDescriptions_display">
				<cfinclude template="serials\administration\dspACCPACDesc.cfm">
			</cfcase>

			<!--- Parts Admin --->
			<cfcase value="parts_admin_list">
				<cfinclude template="parts\lstPartsAdmin.cfm">
			</cfcase>
			<cfcase value="parts_admin_delete">
				<cfinclude template="parts\delPartsAdmin.cfm">
			</cfcase>
			<cfcase value="parts_admin_new">
				<cfinclude template="parts\frmPartsAdmin.cfm">
			</cfcase>
			<cfcase value="parts_admin_edit">
				<cfinclude template="parts\frmPartsAdmin.cfm">
			</cfcase>
			<cfcase value="parts_admin_save">
				<cfinclude template="parts\savPartsAdmin.cfm">
			</cfcase>

			<!--- Misc Parts --->
			<cfcase value="misc_parts_list">
				<cfinclude template="miscparts\lstMiscParts.cfm">
			</cfcase>
			<cfcase value="misc_parts_delete">
				<cfinclude template="miscparts\delMiscParts.cfm">
			</cfcase>
			<cfcase value="misc_parts_new">
				<cfinclude template="miscparts\frmMiscParts.cfm">
			</cfcase>
			<cfcase value="misc_parts_edit">
				<cfinclude template="miscparts\frmMiscParts.cfm">
			</cfcase>
			<cfcase value="misc_parts_save">
				<cfinclude template="miscparts\savMiscParts.cfm">
			</cfcase>


			<!--- Server Options --->
			<cfcase value="server_options_list">
				<cfinclude template="serveroptions\lstServerOptions.cfm">
			</cfcase>
			<cfcase value="server_options_delete">
				<cfinclude template="serveroptions\delServerOptions.cfm">
			</cfcase>
			<cfcase value="server_options_new">
				<cfinclude template="serveroptions\frmServerOptions.cfm">
			</cfcase>
			<cfcase value="server_options_edit">
				<cfinclude template="serveroptions\frmServerOptions.cfm">
			</cfcase>
			<cfcase value="server_options_save">
				<cfinclude template="serveroptions\savServerOptions.cfm">
			</cfcase>


			<cfcase value="server_options_selections_new">
				<cfinclude template="serveroptions\frmServerOptionSelection.cfm">
			</cfcase>
			<cfcase value="server_options_selections_edit">
				<cfinclude template="serveroptions\frmServerOptionSelection.cfm">
			</cfcase>
			<cfcase value="server_options_selections_save">
				<cfinclude template="serveroptions\savServerOptionSelection.cfm">
			</cfcase>



			<!--- ADDITIONAL WARRANTY --->
			<cfcase value="additionalwarranty_list">
				<cfinclude template="additionalwarranty\lstAdditionalWarranty.cfm">
			</cfcase>
<!---            
			<cfcase value="additionalwarranty_delete">
				<cfinclude template="additionalwarranty\delAdditionalWarranty.cfm">
			</cfcase>
--->            
			<cfcase value="additionalwarranty_new">
				<cfinclude template="additionalwarranty\frmAdditionalWarranty.cfm">
			</cfcase>
			<cfcase value="additionalwarranty_edit">
				<cfinclude template="additionalwarranty\frmAdditionalWarranty.cfm">
			</cfcase>
			<cfcase value="additionalwarranty_save">
				<cfinclude template="additionalwarranty\savAdditionalWarranty.cfm">
			</cfcase>           

			<!--- Sales Rep Quotes --->
			<cfcase value="quotes_list">
				<cfinclude template="quotes\lstQuotes.cfm">
			</cfcase>

			<cfcase value="quotes_new_lstACCPAC">
				<cfinclude template="quotes\lstACCPAC.cfm">
			</cfcase>
			<cfcase value="quotes_new_frmACCPAC">
				<cfinclude template="quotes\frmACCPAC.cfm">
			</cfcase>
			<cfcase value="quotes_new_actACCPAC">
				<cfinclude template="quotes\actACCPAC.cfm">
			</cfcase>
            
			<cfcase value="quotes_new1">
				<cfinclude template="quotes\frmQuote1.cfm">
			</cfcase>
			<cfcase value="quotes_new1_act">
				<cfinclude template="quotes\actQuote1.cfm">
			</cfcase>			
			<cfcase value="quotes_new2">
				<cfinclude template="quotes\frmQuote2.cfm">
			</cfcase>
			<cfcase value="quotes_new2_act">
				<cfinclude template="quotes\actQuote2.cfm">
			</cfcase>	

			<cfcase value="quotes_new2A">
				<cfinclude template="quotes\frmQuote2A.cfm">
			</cfcase>
			<cfcase value="quotes_new2A_act">
				<cfinclude template="quotes\actQuote2A.cfm">
			</cfcase>


			<cfcase value="quotes_new2AServer">
				<cfinclude template="quotes\frmQuote2AServer.cfm">
			</cfcase>


			<cfcase value="quotes_new3">
				<cfinclude template="quotes\frmQuote3.cfm">
			</cfcase>
			<cfcase value="quotes_error">
				<cfinclude template="quotes\dspError.cfm">
			</cfcase>
			<cfcase value="quotes_new3_act">
				<cfinclude template="quotes\actQuote3.cfm">
			</cfcase>	
			<cfcase value="quotes_new4">
				<cfinclude template="quotes\frmQuote4.cfm">
			</cfcase>			
			<cfcase value="quotes_new4_act">
				<cfinclude template="quotes\actQuote4.cfm">
			</cfcase>
			<cfcase value="quotes_new4_removepart">
				<cfinclude template="quotes\actRemovePart.cfm">
			</cfcase>

			<cfcase value="quotes_new4_categories">
				<cfinclude template="quotes\lstCategories.cfm">
			</cfcase>			
			<cfcase value="quotes_new4_categories_act">
				<cfinclude template="quotes\actCategories.cfm">
			</cfcase>			
			<cfcase value="quotes_new4_components">
				<cfinclude template="quotes\frmComponents.cfm">
			</cfcase>			
			<cfcase value="quotes_new4_components_act">
				<cfinclude template="quotes\actComponents.cfm">
			</cfcase>		
            
			<cfcase value="quotes_new4_actSearch">
				<cfinclude template="quotes\actSearch.cfm">
			</cfcase>			
			<cfcase value="quotes_new4_frmComponentsSearch">
				<cfinclude template="quotes\frmComponentsSearch.cfm">
			</cfcase>			
            	
            	
			<cfcase value="quotes_new5">
				<cfinclude template="quotes\frmQuote5.cfm">
			</cfcase>			
			<cfcase value="quotes_new5_act">
				<cfinclude template="quotes\actQuote5.cfm">
			</cfcase>						
			<cfcase value="quotes_view">
				<cfinclude template="quotes\dspQuote.cfm">
			</cfcase>
			<cfcase value="quotes_copy">
				<cfinclude template="quotes\actCopyQuote.cfm">
			</cfcase>
			<!--- QUOTE DETAIL --->
            <cfcase value="quote_detail">
                <cfinclude template="quotes\quoteDetail.cfm">
            </cfcase>
            <!--- SUBMIT QUOTE --->
            <cfcase value="quote_submit_selectEmails">
                <cfinclude template="quotes\frmSubmitEmails.cfm">
            </cfcase>   
            <cfcase value="quote_submit">
                <cfinclude template="quotes\actSubmit.cfm">
            </cfcase>   

            <!--- UPDATE QUOTE --->
            <cfcase value="quote_update">
                <cfinclude template="quotes\actUpdate.cfm">
            </cfcase>  
            
            
            <!--- SUBMIT QUOTE RESPONSE PAGE --->
            <cfcase value="quote_submit_response">
                <cfinclude template="quotes\dspReceipt.cfm">
            </cfcase>
            <!--- DELETE QUOTE --->
            <cfcase value="quote_delete">
                <cfinclude template="quotes\actDelete.cfm">
            </cfcase>
            <!--- EMAIL QUOTE --->
            <cfcase value="config_dyn_email_form">
                <cfinclude template="quotes\frmEmailQuote.cfm">
            </cfcase>
            <cfcase value="config_dyn_email_act">
                <cfinclude template="quotes\actEmailQuote.cfm">
            </cfcase>
            <cfcase value="config_dyn_receipt">
                <cfinclude template="quotes\dspEmailReceipt.cfm">
            </cfcase>


			<!--- ADMIN ORDERS --->
            <cfcase value="admin_orders_actEmail">
				<cfinclude template="orders\actEmail.cfm">
			</cfcase>
			<cfcase value="admin_orders_lstOrders">
                <cfinclude template="orders\lstOrders.cfm">
            </cfcase>
            <cfcase value="admin_orders_dspOrderDetail">
                <cfinclude template="orders\dspOrderDetail.cfm">
            </cfcase>
            <cfcase value="admin_orders_frmOrderSearch">
                <cfinclude template="orders\frmOrderSearch.cfm">
            </cfcase>
            <cfcase value="admin_orders_lstOrderSearch">
                <cfinclude template="orders\lstOrderSearch.cfm">
            </cfcase>
            <cfcase value="admin_orders_frmOrderSearchCust">
                <cfinclude template="orders\frmOrderSearchCust.cfm">
            </cfcase>


			<cfcase value="config_RAB092415">
				<cfinclude template="config\actUpdateComponentPrices.cfm">
			</cfcase>            
																					
			<!--- MAIN --->
			<cfdefaultcase>
				<cfinclude template="dspMain.cfm">
			</cfdefaultcase>
		</cfswitch>

<!---RAB--->		
		<cfcatch type="any">	
		<!--- Development: uncomment the <cfrethrow>.  Production: uncomment the <cfinclude> --->
			<cfrethrow>	
<!---		<cfinclude template="dspError.cfm">	--->
		</cfcatch>
<!---RAB--->
		
	</cftry>	<!---RAB--->
		
	 <!-- InstanceEndEditable --></td>
   <td><img name="temp_r5_c11" src="/imagesTemp/temp_r5_c11.gif" width="21" height="318" border="0" alt=""></td>
   <td><img src="/imagesTemp/spacer.gif" width="1" height="318" border="0" alt=""></td>
  </tr>
  <tr>
   <td colspan="10"><div align="center" class="textsmall"><a href="http://www.nor-tech.com">home</a> <font color="#003399">|</font> <a href="http://www.nor-tech.com/products/">products</a> <font color="#003399">|</font> <a href="http://www.nor-tech.com/solutions/index.html">solutions</a> <font color="#003399">|</font> <a href="https://partners.nor-tech.com">partners</a> <font color="#003399">|</font> <a href="http://www.nor-tech.com/support/">support</a> <font color="#003399">|</font> <a href="http://www.nor-tech.com/about/">about
         us</a> <font color="#003399">|</font> <a href="http://www.nor-tech.com/contact/">contact
         us</a> <font color="#003399">|</font> <a href="http://www.nor-tech.com/news/">news</a> <font color="#003399">|</font> <a href="http://www.nor-tech.com/privacy.html">privacy
         statement</a><br>
         Copyright &copy; 2005 Northern Computer Technologies. All rights reserved.  
		 
		 
		 <br>
         <br>
   </div></td>
   <td><img src="/imagesTemp/spacer.gif" width="1" height="36" border="0" alt=""></td>
  </tr>
</table>
<map name="logoMap">
<area shape="rect" coords="7,8,134,45" href="http://www.nor-tech.com" alt="Nor-tech Home">
</map>
</body>
<!-- InstanceEnd --></html>
