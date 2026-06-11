<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	12/12/2007
	Function: 		This page prompts the user to enter a Date Range, and up to 25 items
	Template:		frmMicrosoft.cfm
	Task:			serials_reports_microsoft_enter
--->
	<cfset objSerialsShipments = createObject("component", "admin.assets.cfcs.SerialsShipments")>
	<cfset Error = 0>
	
	<cfif isDefined("FORM.BeginningDate")>

		<cfif trim(FORM.BeginningDate) IS "" OR NOT isDate(FORM.BeginningDate)>
			<cfset Error = 1>
			<cfset ErrorType = "BeginningDateBlank">

		<cfelseif trim(FORM.EndingDate) IS "" OR NOT isDate(FORM.EndingDate)>
			<cfset Error = 1>
			<cfset ErrorType = "EndingDateBlank">
			
		<cfelseif isDate(FORM.BeginningDate) AND isDate(FORM.EndingDate) AND 
			 	  dateCompare(FORM.BeginningDate,FORM.EndingDate) EQ 1>
			<cfset Error = 1>
			<cfset ErrorType = "DateInvalidRange">

		<cfelseif trim(FORM.Item1) IS "">
			<cfset Error = 1>
			<cfset ErrorType = "Item1Blank">
			
		<cfelse>
			<cfset stFormCopy = duplicate(FORM)>
			<cfset objSerialsShipments.setSessionValue("MicrosoftItems", stFormCopy)>
			<cflocation url="index.cfm?task=serials_reports_microsoft_disp&RequestTimeout=6000">
		</cfif>
	</cfif>

</cfsilent>

<cfoutput>
<table width="850" border="0" align="center" cellpadding="3" cellspacing="1">
<!--- spacer --->
<tr><td class="textsmall" colspan="2">&nbsp;</td></tr>

<form name="SearchForm" action="index.cfm?task=serials_reports_microsoft_enter" method="post">
	<tr>
		<td class="textmain" align="left" width="22%">
			<strong>Beginning Invoice Date:</strong> *
		</td>
		<td class="textmain" align="left">
			<input name="BeginningDate" size="20" maxlength="50"
				<cfif isDefined("FORM.BeginningDate")>
					value="#FORM.BeginningDate#"
				</cfif>
			> <i>(mm/dd/yyyy)</i>
		</td>
	</tr>
	<tr>
		<td class="textmain" align="left">
			<strong>Ending Invoice Date:</strong> *
		</td>
		<td class="textmain" align="left">
			<input name="EndingDate" size="20" maxlength="50"
				<cfif isDefined("FORM.EndingDate")>
					value="#FORM.EndingDate#"
				</cfif>
			> <i>(mm/dd/yyyy)</i>
		</td>
	</tr>
	<tr>
		<td class="textmain" align="left" valign="top">
			<strong>Item Number(s):</strong> *
		</td>
		<td class="textmain" align="left">
			<input name="Item1" size="20" maxlength="50" <cfif isDefined("FORM.Item1")>value="#FORM.Item1#"</cfif>>
			<input name="Item2" size="20" maxlength="50" <cfif isDefined("FORM.Item2")>value="#FORM.Item2#"</cfif>>
			<input name="Item3" size="20" maxlength="50" <cfif isDefined("FORM.Item3")>value="#FORM.Item3#"</cfif>>
			<input name="Item4" size="20" maxlength="50" <cfif isDefined("FORM.Item4")>value="#FORM.Item4#"</cfif>>
			<br>
			<input name="Item5" size="20" maxlength="50" <cfif isDefined("FORM.Item5")>value="#FORM.Item5#"</cfif>>
			<input name="Item6" size="20" maxlength="50" <cfif isDefined("FORM.Item6")>value="#FORM.Item6#"</cfif>>
			<input name="Item7" size="20" maxlength="50" <cfif isDefined("FORM.Item7")>value="#FORM.Item7#"</cfif>>
			<input name="Item8" size="20" maxlength="50" <cfif isDefined("FORM.Item8")>value="#FORM.Item8#"</cfif>>
			<br>
			<input name="Item9" size="20" maxlength="50" <cfif isDefined("FORM.Item9")>value="#FORM.Item9#"</cfif>>
			<input name="Item10" size="20" maxlength="50" <cfif isDefined("FORM.Item10")>value="#FORM.Item10#"</cfif>>
			<input name="Item11" size="20" maxlength="50" <cfif isDefined("FORM.Item11")>value="#FORM.Item11#"</cfif>>
			<input name="Item12" size="20" maxlength="50" <cfif isDefined("FORM.Item12")>value="#FORM.Item12#"</cfif>>
			<br>
			<input name="Item13" size="20" maxlength="50" <cfif isDefined("FORM.Item13")>value="#FORM.Item13#"</cfif>>
			<input name="Item14" size="20" maxlength="50" <cfif isDefined("FORM.Item14")>value="#FORM.Item14#"</cfif>>
			<input name="Item15" size="20" maxlength="50" <cfif isDefined("FORM.Item15")>value="#FORM.Item15#"</cfif>>
			<input name="Item16" size="20" maxlength="50" <cfif isDefined("FORM.Item16")>value="#FORM.Item16#"</cfif>>
			<br>
			<input name="Item17" size="20" maxlength="50" <cfif isDefined("FORM.Item17")>value="#FORM.Item17#"</cfif>>
			<input name="Item18" size="20" maxlength="50" <cfif isDefined("FORM.Item18")>value="#FORM.Item18#"</cfif>>
			<input name="Item19" size="20" maxlength="50" <cfif isDefined("FORM.Item19")>value="#FORM.Item19#"</cfif>>
			<input name="Item20" size="20" maxlength="50" <cfif isDefined("FORM.Item20")>value="#FORM.Item20#"</cfif>>
			<br>
			<input name="Item21" size="20" maxlength="50" <cfif isDefined("FORM.Item21")>value="#FORM.Item21#"</cfif>>
			<input name="Item22" size="20" maxlength="50" <cfif isDefined("FORM.Item22")>value="#FORM.Item22#"</cfif>>
			<input name="Item23" size="20" maxlength="50" <cfif isDefined("FORM.Item23")>value="#FORM.Item23#"</cfif>>
			<input name="Item24" size="20" maxlength="50" <cfif isDefined("FORM.Item24")>value="#FORM.Item24#"</cfif>>
			<br>
			<input name="Item25" size="20" maxlength="50" <cfif isDefined("FORM.Item25")>value="#FORM.Item25#"</cfif>>
			<input name="Item26" size="20" maxlength="50" <cfif isDefined("FORM.Item26")>value="#FORM.Item26#"</cfif>>
			<input name="Item27" size="20" maxlength="50" <cfif isDefined("FORM.Item27")>value="#FORM.Item27#"</cfif>>
			<input name="Item28" size="20" maxlength="50" <cfif isDefined("FORM.Item28")>value="#FORM.Item28#"</cfif>>
			<br>
		</td>
	</tr>
	
	<tr>
		<td class="textmain">&nbsp;</td>
		<td class="textmain">
			<input type="submit" name="Continue" value="Continue">
		</td>
	</tr>
	
</form>
<cfif Error>
	<tr>
		<td class="textmain" align="left" colspan="2">
			<font color="FF0000">
				<cfif ErrorType IS "BeginningDateBlank">
					Please enter a valid Beginning Invoice Date in the form mm/dd/yyyy before clicking "Continue".
				<cfelseif ErrorType IS "EndingDateBlank">
					Please enter a valid  Ending Invoice Date in the form mm/dd/yyyy before clicking "Continue".
				<cfelseif ErrorType IS "DateInvalidRange">
					Ending Invoice Date must be greater than Beginning Invoice Date.
				<cfelseif ErrorType IS "Item1Blank">
					Please enter at least one item number.
				</cfif>
			</font>
		</td>
	</tr>
</cfif>

<tr><td class="textsmall" colspan="2">&nbsp;</td></tr>
</cfoutput>

</table>


<cfif isDefined("ErrorType") AND ErrorType IS "BeginningDateBlank">
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.SearchForm['BeginningDate'].focus();document.SearchForm['BeginningDate'].select()
	-->
	</script>
<cfelseif isDefined("ErrorType") AND ErrorType IS "EndingDateBlank">
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.SearchForm['EndingDate'].focus();document.SearchForm['EndingDate'].select()
	-->
	</script>
<cfelseif isDefined("ErrorType") AND ErrorType IS "DateInvalidRange">
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.SearchForm['EndingDate'].focus();document.SearchForm['EndingDate'].select()
	-->
	</script>
<cfelseif isDefined("ErrorType") AND ErrorType IS "Item1Blank">
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.SearchForm['Item1'].focus();document.SearchForm['Item1'].select()
	-->
	</script>
<cfelse>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.SearchForm['BeginningDate'].focus();document.SearchForm['BeginningDate'].select()
	-->
	</script>
</cfif>