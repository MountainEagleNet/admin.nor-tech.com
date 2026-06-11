<cfsilent>
	<!---
	Coded By: Alternative Systems, Inc - Ron Barth
	Create Date: 10/16/2006
	Edit Date: 
	Function: Index Page
	index.cfm 
	NOTE: This page is used ONLY when printing the serial number list (so that it can be displayed in a window without header or footer)
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
		
			<!--- ATTACH INVOICE, PRINT SERIAL NUMBER LIST --->
			
			<!--- Enter Order Number --->
			<cfcase value="serials_attach_order_enter">
				<cfinclude template="enterAttachOrder.cfm">
			</cfcase>	
			<!--- Find an Order --->
			<cfcase value="serials_attach_order_find">
				<cfinclude template="findAttachOrder.cfm">
			</cfcase>	
			<!--- Attach Confirmation Page --->
			<cfcase value="serials_attach_confirm">
				<cfinclude template="confAttach.cfm">
			</cfcase>	
			<!--- Confirmation Action Page --->
			<cfcase value="serials_attach_confirm_act">
				<cfinclude template="actConfAttach.cfm">
			</cfcase>	
			<!--- Serial Number List Page --->
			<cfcase value="serials_attach_print">
				<cfinclude template="printSerialList.cfm">
			</cfcase>	


			<!--- REPRINT SERIAL NUMBER LIST --->
			
			<!--- Enter Invoice Number --->
			<cfcase value="serials_reprint_invoice_enter">
				<cfinclude template="enterInvoice.cfm">
			</cfcase>	
			<!--- Find Invoice --->
			<cfcase value="serials_reprint_invoice_find">
				<cfinclude template="findInvoice.cfm">
			</cfcase>	
			<!--- Serial Number List Reprint Form --->
			<cfcase value="serials_attach_reprint">
				<cfinclude template="frmReprint.cfm">
			</cfcase>	
									
			<!--- MAIN --->
			<cfdefaultcase>
				<cfinclude template="../../dspMain.cfm">
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
