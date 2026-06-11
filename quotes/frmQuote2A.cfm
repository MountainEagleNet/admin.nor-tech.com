<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	08/28/2008
	Function: 		This page prompts the user to enter a Customer Number
	Template:		frmQuote2.cfm
	Task:			quotes_new2
--->
<cfset objResellerSystems = createObject("component", "admin.assets.cfcs.config.ResellerSystems")>
<cfset objLogin = createObject("component", "admin.assets.cfcs.Cust")>
<cfset objQuoteSystem = createObject("component", "admin.assets.cfcs.config.QuoteSystem")>
<cfset objCust = createObject("component", "admin.assets.cfcs.Cust")>
<cfset objClassifications = createObject("component", "admin.assets.cfcs.config.Classifications")>
<cfset objClassificationAliases = createObject("component", "admin.assets.cfcs.config.ClassificationAliases")>
<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>

<cfset objServerSelectionsSystems = createObject("component", "admin.assets.cfcs.config.ServerSelectionsSystems")>

<!---
FORM:<cfdump var="#FORM#">
--->
<cfif isDefined("FORM.HelpMeChooseMyServer")>
	<cfset PickServer = FORM.HelpMeChooseMyServer>
<cfelse>
	<cfset PickServer = 0>
</cfif>

<cfif isDefined("URL.UserID")>
	<cfset Variables.UserID = URL.UserID>
<cfelseif isDefined("FORM.UserID")>
	<cfset Variables.UserID = FORM.UserID>
</cfif>

<cfif isDefined("URL.CustomerID")>
	<cfset Variables.CustomerID = URL.CustomerID>
<cfelseif isDefined("FORM.CustomerID")>
	<cfset Variables.CustomerID = FORM.CustomerID>
</cfif>

<cfif isDefined("URL.Type")>
	<cfset Variables.SystemType = URL.Type>
<cfelseif isDefined("URL.SystemType")>
	<cfset Variables.SystemType = URL.SystemType>
<cfelseif isDefined("FORM.SystemType")>
	<cfset Variables.SystemType = FORM.SystemType>
</cfif>

<cfif isDefined("URL.FilterClassificationID")>
	<cfset Variables.FilterClassificationID = URL.FilterClassificationID>
<cfelseif isDefined("FORM.FilterClassificationID")>
	<cfset Variables.FilterClassificationID = FORM.FilterClassificationID>
<cfelse>
	<cfset Variables.FilterClassificationID = "">
</cfif>

<cfif isDefined("URL.SortByPrice")>
	<cfset Variables.SortByPrice = URL.SortByPrice>
<cfelse>
	<cfset Variables.SortByPrice = 0>
</cfif>    

<cfparam name="URL.INVUNIQ" default="">
<cfparam name="URL.CopyingQuote" default="0">

<cfset Variables.PartnersLocation = "Partners">
<cfif findNoCase("TEST",APPLICATION.AdminLocation) NEQ 0>
	<cfset Variables.PartnersLocation = "PartnersTEST">
</cfif>

<!---<cfset qryResellerSystems = objResellerSystems.listRecordsForParent("CustomerID", Variables.CustomerID, "SystemType, SystemName")>--->

<script language="javascript">
function openWindow(url_string, width, height)	{
	var options = "status=1,scrollbars=1,resizable=1,height="+height+",width="+width;
	new_window = window.open(url_string, "newwin", options );
	return false;
}	
</script>

<style type="text/css">

a:link {
	text-decoration: none;
	color:#003399; 
}
a:visited {
	text-decoration: none;
	color:#003399; 	
}
a:hover {
	text-decoration: underline;
	color:#003399; 
}
a:active {
	text-decoration: none; 
	color:#003399; 
}

#hintbox{ /*CSS for pop up hint box */
position:absolute;
top: 0;
background-color: lightyellow;
width: 150px; /*Default width of hint.*/ 
padding: 3px;
border:1px solid black;
font:normal 11px Verdana;
line-height:18px;
z-index:100;
border-right: 3px solid black;
border-bottom: 3px solid black;
visibility: hidden;
}

</style>

<script type="text/javascript">

/***********************************************
* Show Hint script- © Dynamic Drive (www.dynamicdrive.com)
* This notice MUST stay intact for legal use
* Visit http://www.dynamicdrive.com/ for this script and 100s more.
***********************************************/
		
var horizontal_offset="9px" //horizontal offset of hint box from anchor link

/////No further editting needed

var vertical_offset="0" //horizontal offset of hint box from anchor link. No need to change.
var ie=document.all
var ns6=document.getElementById&&!document.all

function getposOffset(what, offsettype){
var totaloffset=(offsettype=="left")? what.offsetLeft : what.offsetTop;
var parentEl=what.offsetParent;
while (parentEl!=null){
totaloffset=(offsettype=="left")? totaloffset+parentEl.offsetLeft : totaloffset+parentEl.offsetTop;
parentEl=parentEl.offsetParent;
}
return totaloffset;
}

function iecompattest(){
return (document.compatMode && document.compatMode!="BackCompat")? document.documentElement : document.body
}

function clearbrowseredge(obj, whichedge){
var edgeoffset=(whichedge=="rightedge")? parseInt(horizontal_offset)*-1 : parseInt(vertical_offset)*-1
if (whichedge=="rightedge"){
var windowedge=ie && !window.opera? iecompattest().scrollLeft+iecompattest().clientWidth-30 : window.pageXOffset+window.innerWidth-40
dropmenuobj.contentmeasure=dropmenuobj.offsetWidth
if (windowedge-dropmenuobj.x < dropmenuobj.contentmeasure)
edgeoffset=dropmenuobj.contentmeasure+obj.offsetWidth+parseInt(horizontal_offset)
}
else{
var windowedge=ie && !window.opera? iecompattest().scrollTop+iecompattest().clientHeight-15 : window.pageYOffset+window.innerHeight-18
dropmenuobj.contentmeasure=dropmenuobj.offsetHeight
if (windowedge-dropmenuobj.y < dropmenuobj.contentmeasure)
edgeoffset=dropmenuobj.contentmeasure-obj.offsetHeight
}
return edgeoffset
}

function showhint(menucontents, obj, e, tipwidth){
if ((ie||ns6) && document.getElementById("hintbox")){
dropmenuobj=document.getElementById("hintbox")
dropmenuobj.innerHTML=menucontents
dropmenuobj.style.left=dropmenuobj.style.top=-500
if (tipwidth!=""){
dropmenuobj.widthobj=dropmenuobj.style
dropmenuobj.widthobj.width=tipwidth
}
dropmenuobj.x=getposOffset(obj, "left")
dropmenuobj.y=getposOffset(obj, "top")
dropmenuobj.style.left=dropmenuobj.x-clearbrowseredge(obj, "rightedge")+obj.offsetWidth+"px"
dropmenuobj.style.top=dropmenuobj.y-clearbrowseredge(obj, "bottomedge")+"px"
dropmenuobj.style.visibility="visible"
obj.onmouseout=hidetip
}
}

function hidetip(e){
dropmenuobj.style.visibility="hidden"
dropmenuobj.style.left="-500px"
}

function createhintbox(){
var divblock=document.createElement("div")
divblock.setAttribute("id", "hintbox")
document.body.appendChild(divblock)
}

if (window.addEventListener)
window.addEventListener("load", createhintbox, false)
else if (window.attachEvent)
window.attachEvent("onload", createhintbox)
else if (document.getElementById)
window.onload=createhintbox

</script>

<cfset qryLogin = objLogin.getRecordAsQueryByCustomerID(Variables.CustomerID)>
<cfset Variables.PricelistID = qryLogin.PricelistID>
<!--- If this customer doesn't have a price list, use the Master price list --->
<cfif Variables.PriceListID IS "">
	<cfset Variables.PriceListID = "MASTERPRICELISTUUID">
</cfif>




																																								 <!--- RAB 05/14/14 --->
<cfset qryResellerSystems = objResellerSystems.getResellerSystems(Variables.SystemType, Variables.FilterClassificationID, Variables.SortByPrice, qryLogin.ID, 0, Variables.UserID)>

<!---
qryResellerSystems:<cfdump var="#qryResellerSystems#"><br />
--->
<!--- HELP ME CHOOSE MY SERVER --->
<cfif PickServer>
	<cfset stFormCopy = duplicate(FORM)>
	<cfset qryResellerSystems = objServerSelectionsSystems.selectServers(qryResellerSystems, stFormCopy)>
</cfif>
<!---
qryResellerSystems:<cfdump var="#qryResellerSystems#"><br />
--->
<!---
<cfabort>
--->
<cfset customerUsesClassifications = objCust.customerUsesClassifications(qryLogin.ID)>

<cfoutput>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">

<form name="PickSystem" action="index.cfm?task=quotes_new2A_act&RequestTimeout=6000" method="post">
<input type="hidden" name="UserID" value="#Variables.UserID#">
<input type="hidden" name="CustomerID" value="#Variables.CustomerID#">
<input type="hidden" name="SystemType" value="#Variables.SystemType#">
<input type="hidden" name="SortByPrice" value="#Variables.SortByPrice#">

<!---
<tr><!--- Page Title --->
	<td valign="top" class="pagetitle">
		<cfif NOT isDefined("Variables.SystemType")>
			Nor-Tech Configurator
		<cfelseif Variables.SystemType IS "Workstation">
			<!---Voyageur---> Workstation Configurator
		<cfelseif Variables.SystemType IS "Notebook">
			Notebook Configurator
		<cfelseif Variables.SystemType IS "Server">
			Server Configurator
		<cfelseif Variables.SystemType IS "MiniMountablePC">
			Mini/Mountable PCs Configurator
		</cfif>
	</td>
</tr>
--->

<tr><!--- Display Message --->
	<td valign="top" class="textmain" colspan="2"><font color="FF0000">#objLogin.getMessage()#</font></td>
</tr>
<tr><!--- Instructions --->
    <td valign="top" class="textmain">
        Choose the base system you want to use by clicking the corresponding "Configure" button.
    </td>
</tr>
<cfif isDefined("URL.Error")>
	<tr>
		<td class="textmain" align="left" colspan="2">
			<font color="FF0000">
				<cfif URL.Error IS "Blank">
					Please select a System before clicking "Continue".
				</cfif>
			</font>
		</td>
	</tr>
</cfif>

<!--- CLASSIFICATION FILTER --->
<cfif customerUsesClassifications>
	<tr><td>&nbsp;</td></tr>
	<tr>
        <td class="listSortSelect" colspan="2">
            <cfif customerUsesClassifications>
                <cfset lstClassifications = objClassifications.getClassificationList(Variables.SystemType, qryLogin.ID)>
                <cfif listLen(lstClassifications) LE 1>
                    &nbsp;
                <cfelse>
                    Select by Classification:<br />
                    <input type="radio" name="FilterClassificationID" value="" onclick="submit()" 
                        <cfif Variables.FilterClassificationID IS "">checked</cfif>
                        >All &nbsp;&nbsp;      
                    <cfloop list="#lstClassifications#" index="CurrentClassificationID">
                        <input type="radio" name="FilterClassificationID" value="#CurrentClassificationID#" onclick="submit()"
                            <cfif Variables.FilterClassificationID IS CurrentClassificationID>checked</cfif>
                            >#objClassificationAliases.getClassificationName(Variables.CustomerID,CurrentClassificationID,1)# &nbsp;&nbsp;      
                    </cfloop>
				</cfif>
            <cfelse>
                &nbsp;
            </cfif>    
        </td>
    </tr>
</cfif>
<tr><td>&nbsp;</td></tr>

<!--- SORT BY PRICE --->
<tr>
    <td class="listSortSelect" colspan="2">
    	<cfif NOT Variables.SortByPrice>
            <a href="index.cfm?task=quotes_new2a&UserID=#urlEncodedFormat(Variables.UserID)#&CustomerID=#urlEncodedFormat(Variables.CustomerID)#&SystemType=#urlEncodedFormat(Variables.SystemType)#&FilterClassificationID=#urlEncodedFormat(Variables.FilterClassificationID)#&SortByPrice=1&RequestTimeout=6000" class="listSortSelect">Sort by Price</a>
		<cfelse>
            <a href="index.cfm?task=quotes_new2a&UserID=#urlEncodedFormat(Variables.UserID)#&CustomerID=#urlEncodedFormat(Variables.CustomerID)#&SystemType=#urlEncodedFormat(Variables.SystemType)#&FilterClassificationID=#urlEncodedFormat(Variables.FilterClassificationID)#&SortByPrice=0&RequestTimeout=6000" class="listSortSelect">Sort by Classification</a>
        </cfif>
	</td>
</tr>    

<!--- HELP ME CHOOSE MY SERVER --->
<cfif Variables.SystemType IS "Server">
    <tr>
        <td class="listSortSelect" colspan="2">
        	<br />
            <a href="index.cfm?task=quotes_new2AServer&UserID=#urlEncodedFormat(Variables.UserID)#&CustomerID=#urlEncodedFormat(Variables.CustomerID)#&SystemType=#urlEncodedFormat(Variables.SystemType)#&FilterClassificationID=#urlEncodedFormat(Variables.FilterClassificationID)#&SortByPrice=1&RequestTimeout=6000" class="listSortSelect">Help me choose my server</a>           
        </td>
    </tr>    
</cfif>



<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain" colspan="2">
	<table width="100%" border="0" align="center" cellpadding="3" cellspacing="6">
		<cfif qryResellerSystems.RecordCount EQ 0>
			<tr>
				<td class="textmain" style="color:FF0000">
                	<cfif PickServer>
                    	No servers were found that match the criteria you entered.
                    <cfelse>
						We're sorry, this customer has no systems defined.
                    </cfif>
				</td>
			</tr>
		</cfif>
        
		<tr>
            <td valign="top">
                <table border="0" cellpadding="6" cellspacing="6">
                
                	<!--- HEADINGS --->
                	<tr>
                    	<td class="listSystemHeadings" valign="bottom" width="15%">&nbsp;</td>
                    	<td class="listSystemHeadings" valign="bottom" width="60%">Description</td>
                        <cfif customerUsesClassifications>
	                    	<td class="listSystemHeadings" valign="bottom">Classification</td>
						</cfif>
                    	<td class="listSystemHeadings" valign="bottom" align="center">Price *</td>
                    </tr>
                    
					<cfloop query="qryResellerSystems">
						<cfset SystemDescription = qryResellerSystems.Description>
                        <cfif len(trim(SystemDescription)) GT 200>
                            <cfset SystemDescription = left(trim(qryResellerSystems.Description), 200) & "...">
                        </cfif>
                        <cfset SystemDescription = SystemDescription & " <em><strong>(Click Here for specs)</strong></em>">
                        
                        <cfset FullDescriptionForPopup = replace(qryResellerSystems.Specs,'"', '&quot;', "all")>
                        <cfset FullDescriptionForPopup = replace(FullDescriptionForPopup, "'", "&rsquo;", "all")>
<!---                        
						<cfset ImageName = objConfigSystems.getImageName(qryResellerSystems.ConfigSystemID)>
--->                        
                        <tr>                    

							<!--- PHOTO --->
							<td align="center" valign="middle">
                            	<a href="javascript:void(0)" onclick="openWindow('quotes/popupPhoto.cfm?ConfigSystemID=#urlEncodedFormat(qryResellerSystems.ConfigSystemID)#',450,650)"
								<cfif trim(FullDescriptionForPopup) IS NOT "">
                                    onMouseover="showhint('#trim(FullDescriptionForPopup)#', this, event, '350')"
                                </cfif>                                
                                >
									<img width="142px" src="http://partners.nor-tech.com/images/systems/#qryResellerSystems.PhotoImage#" border="0">  
<!---                                                            
									<img width="142px" src="../../#Variables.PartnersLocation#/images/systems/#ImageName#" border="0">
--->
                                </a>
							</td>
                            
                            <td valign="middle">
                            	<table border="0" cellpadding="0" cellspacing="0">
									<!--- SYSTEM NAME --->
									<tr>
                                        <td align="left" valign="top" class="listSystemName">
                                            #qryResellerSystems.SystemName#
                                        </td>
                                    </tr>
                                    
									<!--- SYSTEM DESCRIPTION --->
                                    <tr>
                                   		<td align="left" valign="top" class="listSystemDescription">
                                            <a href="javascript:void(0)" 
                                           		onclick="openWindow('quotes/popupPhoto.cfm?ConfigSystemID=#urlEncodedFormat(qryResellerSystems.ConfigSystemID)#',450,650)">					
                                                #SystemDescription#
                                            </a>                                            
                                        </td>
                                    </tr>

                            	</table>
                            </td>
                            
							<!--- CLASSIFICATION --->
                            <td align="left" valign="middle" class="listSystemDescription">
                               	#objClassificationAliases.getClassificationName(Variables.CustomerID,qryResellerSystems.ClassificationID,1)#
                            </td>

							<!--- PRICE / "CONFIGURE" BUTTON --->
							<cfset ThisSystemTotal = objConfigSystems.getSystemPrice(qryResellerSystems.ConfigSystemID, qryResellerSystems.SystemBasePrice, Variables.PriceListID)>
							<!--- (The old way) --->
                            <cfif ThisSystemTotal EQ 0>
                                <cfset ThisSystemTotal = ceiling(objConfigSystems.getSystemTotalPriceDefault(qryResellerSystems.ConfigSystemID, Variables.PriceListID))>
                            </cfif>
                          	<td align="center" valign="middle" class="listSystemPrice">
								<cfif ThisSystemTotal NEQ 0>
	                            	#numberFormat(ThisSystemTotal, '$,')#<br /><br />
                                </cfif>
                                <a href="index.cfm?task=quotes_new2A_act&UserID=#urlEncodedFormat(Variables.UserID)#&CustomerID=#urlEncodedFormat(Variables.CustomerID)#&ConfigSystemID=#urlEncodedFormat(qryResellerSystems.ConfigSystemID)#&RequestTimeout=6000">
                                    <img src="images/configureBtnNew.gif" alt="Configure" width="100" height="28" border="0">
                                </a>
                            </td>

                        </tr>

                        <tr>
                            <td colspan="4" align="center" valign="middle">
                                <font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                                    <img src="/images/lineHoriz.gif" width="100%" height="6" />
                                </font>
                            </td>
                        </tr>

                    </cfloop>        
                    <tr>
                        <td colspan="4" align="center" valign="middle" class="textsmall">
							* Prices shown are as of 6:00am this morning, #dateFormat(now(), 'm/d/yyyy')#; please click "Configure" to see the actual price.
                        </td>
                    </tr>
                </table>
      		</td>
     	</tr>
        
	</table>
</td>
</tr>
</form>
</table>
</cfoutput>