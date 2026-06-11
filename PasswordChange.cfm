<cfsilent>
	<!---
	Coded By: Alternative Systems, Inc - Nicholas Tunney
	Create Date: 04/19/2013
	Edit Date: 
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
   <td><a href="http://www.nor-tech.com/products/" onMouseOver="MM_swapImage('products','','/imagesTemp/productsF2.gif',1)" onMouseOut="MM_swapImgRestore()"><img name="products" src="/imagesTemp/products.gif" width="63" height="21" border="0" alt=""></a></td>
   <td><a href="http://www.nor-tech.com/solutions/" onMouseOver="MM_swapImage('solutions','','/imagesTemp/solutionsF2.gif',1)" onMouseOut="MM_swapImgRestore()"><img name="solutions" src="/imagesTemp/solutions.gif" width="65" height="21" border="0" alt=""></a></td>
   <td><a href="https://partners.nor-tech.com/" onMouseOver="MM_swapImage('partners','','/imagesTemp/partnersF2.gif',1)" onMouseOut="MM_swapImgRestore()"><img name="partners" src="/imagesTemp/partners.gif" width="61" height="21" border="0" alt=""></a></td>
   <td><a href="http://www.nor-tech.com/support/" onMouseOver="MM_swapImage('support','','/imagesTemp/supportF2.gif',1)" onMouseOut="MM_swapImgRestore()"><img name="support" src="/imagesTemp/support.gif" width="59" height="21" border="0" alt=""></a></td>
   <td><a href="http://www.nor-tech.com/about/" onMouseOver="MM_swapImage('about','','/imagesTemp/aboutF2.gif',1)" onMouseOut="MM_swapImgRestore()"><img name="about" src="/imagesTemp/about.gif" width="64" height="21" border="0" alt=""></a></td>
   <td><a href="http://www.nor-tech.com/contact/" onMouseOver="MM_swapImage('contact','','/imagesTemp/contactF2.gif',1)" onMouseOut="MM_swapImgRestore()"><img name="contact" src="/imagesTemp/contact.gif" width="69" height="21" border="0" alt=""></a></td>
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
   
<!---   
     <cfinclude template="includes/left_nav.cfm">
--->     
     
     
   <!-- InstanceEndEditable --></td>
   <td height="318" colspan="8" valign="top"><!-- InstanceBeginEditable name="main" -->
   
   
		<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">

			<cfset objComponent = createObject("component", "admin.assets.cfcs.Component")>
            
            <!--- VALIDATION ERRORS --->
            <cfif isDefined("URL.Validation")>		
                <cfset stRecord = objComponent.getSessionValue("PasswordChangeForm")>
                <cfset stErrors = objComponent.getSessionValue("PasswordChangeErrors")>
            <!--- CREATING A NEW RECORD --->
            <cfelse> 
                <cfset stRecord = structNew()>
                <cfset structInsert(stRecord, "password", "", True)>
                <cfset structInsert(stRecord, "passwordConfirm", "", True)>
                <cfset structInsert(stRecord, "UserID", URL.UserID, True)>
                <cfset stErrors = structNew()>
            </cfif>
            
            <cfoutput>
            <form action="PasswordChange_act.cfm" method="post" name="detailform">
            <input type="hidden" name="UserID" value="#stRecord.UserID#" />
            <cfset TabValue = 1>
        
            <tr>
                  <td colspan="2" align="center" class="textmain" style="color:##F00; font-size:14px; font-weight:bold">
                       Your Password has Expired
                  </td>
             </tr>
        
            <tr><td colspan="2">&nbsp;</td></tr>
        
             <tr>
                  <td colspan="2" class="textmain">
                       Please create a new password and enter it in both fields below.<br />
                       The format of your password must be as follows:
                       
                        <ul>
                            <li>At least 12 characters in length</li>
                            <li>Must contain at least one letter</li>
                            <li>Must contain at least one number</li>
                            <li>Must contain at least one special character (such as ! or @)</li>                
                        </ul>
                  </td>
             </tr>
        
            <tr><td colspan="2"><hr /></td></tr>
        

			<!--- password --->
            <cfif structKeyExists(stErrors, "password")>
                <tr>
                    <td colspan="2" class="textmain" style="color:red; font-style:italic">
                        #stErrors.password#
                    </td>
                </tr>
            </cfif>
            <tr>
                <td class="textmain" valign="top"><strong>New Password:</strong> <span style="color:red">*</span></td>
                <td class="textmain" valign="top">
                    <input name="password" value="#stRecord.password#" type="password" size="30" maxlength="50" class="textmain" 
                        <cfif isDefined("stErrors") AND structKeyExists(stErrors, "password")>
                            style="border-top: 2px solid red; border-left: 2px solid red; border-bottom: 1px solid red; border-right: 1px solid red;"
                        </cfif>			
                    tabindex="#TabValue#">
                    <cfset TabValue = TabValue + 1>
                </td>
            </tr> 


			<!--- passwordConfirm --->
            <cfif structKeyExists(stErrors, "passwordConfirm")>
                <tr>
                    <td colspan="2" class="textmain" style="color:red; font-style:italic">
                        #stErrors.passwordConfirm#
                    </td>
                </tr>
            </cfif>
            <tr>
                <td class="textmain" valign="top"><strong>Re-type Password:</strong> <span style="color:red">*</span></td>
                <td class="textmain" valign="top">
                    <input name="passwordConfirm" value="#stRecord.passwordConfirm#" type="password" size="30" maxlength="50" class="textmain" 
                        <cfif isDefined("stErrors") AND structKeyExists(stErrors, "passwordConfirm")>
                            style="border-top: 2px solid red; border-left: 2px solid red; border-bottom: 1px solid red; border-right: 1px solid red;"
                        </cfif>			
                    tabindex="#TabValue#">
                    <cfset TabValue = TabValue + 1>
                </td>
            </tr> 
            
            
            <tr><td colspan="2"><hr /></td></tr>

            <tr>
                <td colspan="2" align="center">
                    <input type="submit" name="submit" value="Continue" tabindex="#TabValue#">
                </td>
            </tr> 
            </form>
            </cfoutput>
        
        
		</table>
        
        
        
        
        
	 <!-- InstanceEndEditable --></td>
   <td><img name="temp_r5_c11" src="/imagesTemp/temp_r5_c11.gif" width="21" height="318" border="0" alt=""></td>
   <td><img src="/imagesTemp/spacer.gif" width="1" height="318" border="0" alt=""></td>
  </tr>
  <tr>
   <td colspan="10"><div align="center" class="textsmall"><a href="http://www.nor-tech.com">home</a> <font color="#003399">|</font> <a href="http://www.nor-tech.com/products/">products</a> <font color="#003399">|</font> <a href="http://www.nor-tech.com/solutions/">solutions</a> <font color="#003399">|</font> <a href="https://partners.nor-tech.com/">partners</a> <font color="#003399">|</font> <a href="http://www.nor-tech.com/support/">support</a> <font color="#003399">|</font> <a href="http://www.nor-tech.com/about/">about
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
