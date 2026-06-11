<cfsilent>
	<!---
	Coded By: Alternative Systems, Inc - Nicholas Tunney
	Create Date: 7/16/2005
	Edit Date: 
	Function: This page allows an admin to supply login credentials
	frmLogin.cfm
	--->
	
	<!--- kill SESSION.Auth variable, if it exists --->
	<cfscript>
		StructDelete(SESSION, "AdminAuth");
	</cfscript>
</cfsilent>

<!--- 11/24/06, Ron Barth --->
<!--- RAB 4/24/13
<cfif cgi.https is not "on">
	<cflocation url="https://#NorTechURL#/#APPLICATION.AdminLocation#/frmLogin.cfm" addtoken="No"> 
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
   <td><a href="https://partners.nor-tech.com/" onMouseOver="MM_swapImage('partners','','/imagesTemp/partnersF2.gif',1)" onMouseOut="MM_swapImgRestore()"><img name="partners" src="/imagesTemp/partners.gif" width="61" height="21" border="0" alt=""></a></td>
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
   <td colspan="9" class="productTitle"><!-- InstanceBeginEditable name="title" --><span class="pagetitle">Administration</span><!-- InstanceEndEditable --></td>
   <td><img src="/imagesTemp/spacer.gif" width="1" height="23" border="0" alt=""></td>
  </tr>
  <tr>
   <td rowspan="2" valign="top" background="/imagesTemp/leftvertline.gif"><!-- InstanceBeginEditable name="leftnav" -->
     <cfinclude template="includes/left_nav.cfm">
   <!-- InstanceEndEditable --></td>
   <td height="318" colspan="8" valign="top"><!-- InstanceBeginEditable name="main" -->
		<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
		<form name="LoginForm" action="actLogin.cfm" method="post">
			<tr>
				<td colspan="7" class="textmain">
					<br>
					<cfif IsDefined("URL.lo")><strong>You have been successfully logged out.</strong><br><br></cfif>
					<cfif IsDefined("URL.nid")><strong>Incorrect username or password.</strong><br><br></cfif>
					<table cellpadding="3" cellspacing="3">
					<tr>
						<td align="right" class="textmain"><strong>Username</strong></td>
						<td><input name="emailaddress" type="text" size="20" maxlength="75">
						</td>
					</tr>
					<tr>
						<td align="right" class="textmain"><strong>Password</strong></td>
						<td><input name="passwd" type="password" size="20" maxlength="50">
						</td>
					</tr>
					<tr>
						<td align="right"></td>
						<td><input name="submit" type="submit" value="Login">
						</td>
					</tr>
					</table>
				</td>
			</tr>
		</form>
		</table>
	 <!-- InstanceEndEditable --></td>
   <td><img name="temp_r5_c11" src="/imagesTemp/temp_r5_c11.gif" width="21" height="318" border="0" alt=""></td>
   <td><img src="/imagesTemp/spacer.gif" width="1" height="318" border="0" alt=""></td>
  </tr>
  <tr>
   <td colspan="10"><div align="center" class="textsmall"><a href="http://www.nor-tech.com">home</a> <font color="#003399">|</font> <a href="http://www.nor-tech.com/products/">products</a> <font color="#003399">|</font> <a href="http://www.nor-tech.com/solutions/index.html">solutions</a> <font color="#003399">|</font> <a href="https://partners.nor-tech.com/">partners</a> <font color="#003399">|</font> <a href="http://www.nor-tech.com/support/index.html">support</a> <font color="#003399">|</font> <a href="http://www.nor-tech.com/about/index.html">about
         us</a> <font color="#003399">|</font> <a href="http://www.nor-tech.com/contact/">contact
         us</a> <font color="#003399">|</font> <a href="http://www.nor-tech.com/news/">news</a> <font color="#003399">|</font> <a href="http://www.nor-tech.com/privacy.html">privacy
         statement</a><br>
         Copyright &copy; 2005 Northern Computer Technologies. All rights reserved.<br>
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
