<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	06/01/2012
	Function: 		This page displays a form for selection server options
	Template:		frmQuote2AServer.cfm
	Task:			quotes_new2AServer
--->

<cfset objLogin = createObject("component", "admin.assets.cfcs.Cust")>
<cfset objServerOptions = createObject("component", "admin.assets.cfcs.config.ServerOptions")>
<cfset objServerOptionSelections = createObject("component", "admin.assets.cfcs.config.ServerOptionSelections")>

<cfset qryServerOptions = objServerOptions.listRecords()>
<!---
<cfset objResellerSystems = createObject("component", "admin.assets.cfcs.config.ResellerSystems")>
<cfset objQuoteSystem = createObject("component", "admin.assets.cfcs.config.QuoteSystem")>
<cfset objCust = createObject("component", "admin.assets.cfcs.Cust")>
<cfset objClassifications = createObject("component", "admin.assets.cfcs.config.Classifications")>
<cfset objClassificationAliases = createObject("component", "admin.assets.cfcs.config.ClassificationAliases")>
<cfset objConfigSystems = createObject("component", "admin.assets.cfcs.config.ConfigSystems")>
--->
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

<cfif isDefined("URL.SystemType")>
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



<!---
<cfparam name="URL.INVUNIQ" default="">
<cfparam name="URL.CopyingQuote" default="0">
--->
<!---
<cfset Variables.PartnersLocation = "Partners">
<cfif findNoCase("TEST",APPLICATION.AdminLocation) NEQ 0>
	<cfset Variables.PartnersLocation = "PartnersTEST">
</cfif>
--->
<!---<cfset qryResellerSystems = objResellerSystems.listRecordsForParent("CustomerID", Variables.CustomerID, "SystemType, SystemName")>--->
<!---
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
--->

<!---
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
--->

<!---
<cfset qryLogin = objLogin.getRecordAsQueryByCustomerID(Variables.CustomerID)>
<cfset Variables.PricelistID = qryLogin.PricelistID>
<!--- If this customer doesn't have a price list, use the Master price list --->
<cfif Variables.PriceListID IS "">
	<cfset Variables.PriceListID = "MASTERPRICELISTUUID">
</cfif>

<cfset qryResellerSystems = objResellerSystems.getResellerSystems(Variables.SystemType, Variables.FilterClassificationID, Variables.SortByPrice, qryLogin.ID, 0)>
<!---
qryResellerSystems:<cfdump var="#qryResellerSystems#">
<cfabort>
--->
<cfset customerUsesClassifications = objCust.customerUsesClassifications(qryLogin.ID)>
--->

<cfset TabValue = 1>

<cfoutput>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">

<form name="PickServer" action="index.cfm?task=quotes_new2A&RequestTimeout=6000" method="post">

<input type="hidden" name="UserID" value="#Variables.UserID#">
<input type="hidden" name="CustomerID" value="#Variables.CustomerID#">
<input type="hidden" name="SystemType" value="#Variables.SystemType#">
<input type="hidden" name="SortByPrice" value="#Variables.SortByPrice#">
<input type="hidden" name="FilterClassificationID" value="#Variables.FilterClassificationID#">

<input type="hidden" name="HelpMeChooseMyServer" value="1">



<tr><!--- Display Message --->
	<td valign="top" class="textmain" colspan="2"><font color="FF0000">#objLogin.getMessage()#</font></td>
</tr>
<tr><!--- Instructions --->
    <td valign="top" class="textmain">
        Make selections for the various server options below, then click "Continue".
    </td>
</tr>

<!--- spacer --->
<tr><td class="textsmall">&nbsp;</td></tr>

<tr>
<td valign="top" class="textmain" colspan="2">
	<table width="100%" border="0" align="center" cellpadding="3" cellspacing="6">
		<cfif qryServerOptions.RecordCount EQ 0>
			<tr>
				<td class="textmain" style="color:FF0000" colspan="2">
					There are no Server Options defined
				</td>
			</tr>
		</cfif>
        
		<!--- SERVER OPTIONS --->
        <cfloop query="qryServerOptions">
            <cfset CURRENTServerOptionID = qryServerOptions.ServerOptionID>
    
            <cfset qryServerOptionSelections = objServerOptionSelections.getSelections(CURRENTServerOptionID)>
        
            <tr <!---style="background-color:##e5e5e6"--->>
                <!--- SERVER OPTION NAME --->
                <td class="textmain" width="30%">#qryServerOptions.Name#</td>

               	<cfset FieldName = "SERVOPT|" & CURRENTServerOptionID>
                
                <td class="textmain">
                    <select name="#FieldName#" size="1" tabindex="#TabValue#" class="textmain">
						<option value="">- Any -</option>
                    	<cfloop query="qryServerOptionSelections">
                            <option value="#qryServerOptionSelections.ServerOptionSelectionID#">#qryServerOptionSelections.Name#</option>
                        </cfloop>
                    </select>
					<cfset TabValue = TabValue + 1>
                </td>
            </tr>
        </cfloop>
        
        <tr>
            <td colspan="2" align="center" valign="middle">
                <font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                    <img src="/images/lineHoriz.gif" width="100%" height="6" />
                </font>
            </td>
        </tr>

		<!--- "CONTINUE" BUTTON --->
        <tr>
        	<td>&nbsp;</td>
            <td>
                <input type="submit" name="ButtonClicked" value="&nbsp;Continue -&raquo;" tabindex="#TabValue#">
            </td>
        </tr>
        
	</table>
</td>
</tr>
</form>
</table>
</cfoutput>