<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	07/15/2008
	Function: 		This page prompts the user to enter a Date Range, and an Item or Item Range
	Template:		frmIntel.cfm
	Task:			serials_reports_frmIntel
--->
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

		<cfelseif trim(FORM.BeginningItem1) IS "">
			<cfset Error = 1>
			<cfset ErrorType = "BeginningItemBlank">

		<cfelseif trim(FORM.BeginningItem2) IS "" AND trim(FORM.EndingItem2) IS NOT "" >
			<cfset Error = 1>
			<cfset ErrorType = "BeginningItemBlank">

		<cfelseif trim(FORM.BeginningItem3) IS "" AND trim(FORM.EndingItem3) IS NOT "" >
			<cfset Error = 1>
			<cfset ErrorType = "BeginningItemBlank">

		<cfelseif trim(FORM.BeginningItem4) IS "" AND trim(FORM.EndingItem4) IS NOT "" >
			<cfset Error = 1>
			<cfset ErrorType = "BeginningItemBlank">
			
		<cfelse>
			<cflocation url="index.cfm?task=serials_reports_actIntel&BeginningDate=#urlEncodedFormat(FORM.BeginningDate)#&EndingDate=#urlEncodedFormat(FORM.EndingDate)#&BeginningItem1=#urlEncodedFormat(FORM.BeginningItem1)#&EndingItem1=#urlEncodedFormat(FORM.EndingItem1)#&BeginningItem2=#urlEncodedFormat(FORM.BeginningItem2)#&EndingItem2=#urlEncodedFormat(FORM.EndingItem2)#&BeginningItem3=#urlEncodedFormat(FORM.BeginningItem3)#&EndingItem3=#urlEncodedFormat(FORM.EndingItem3)#&BeginningItem4=#urlEncodedFormat(FORM.BeginningItem4)#&EndingItem4=#urlEncodedFormat(FORM.EndingItem4)#&RequestTimeout=6000">
		</cfif>
	</cfif>

</cfsilent>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<!--- spacer --->
<tr><td class="textsmall" colspan="2">&nbsp;</td></tr>

<form name="SearchForm" action="index.cfm?task=serials_reports_frmIntel" method="post">
	<tr>
		<td class="textmain" align="left" width="35%">
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
		<td class="textmain" align="left">
			<strong>Item Number Range 1:</strong> *
		</td>
		<td class="textmain" align="left">
			<input name="BeginningItem1" size="20" maxlength="50"
				<cfif isDefined("FORM.BeginningItem1")>
					value="#FORM.BeginningItem1#"
				</cfif>
			> -
			<input name="EndingItem1" size="20" maxlength="50"
				<cfif isDefined("FORM.EndingItem1")>
					value="#FORM.EndingItem1#"
				</cfif>
			>
		</td>
	</tr>
	
	<tr>
		<td class="textmain" align="left">
			<strong>Item Number Range 2:</strong> 
		</td>
		<td class="textmain" align="left">
			<input name="BeginningItem2" size="20" maxlength="50"
				<cfif isDefined("FORM.BeginningItem2")>
					value="#FORM.BeginningItem2#"
				</cfif>
			> -
			<input name="EndingItem2" size="20" maxlength="50"
				<cfif isDefined("FORM.EndingItem2")>
					value="#FORM.EndingItem2#"
				</cfif>
			>
		</td>
	</tr>
	
	<tr>
		<td class="textmain" align="left">
			<strong>Item Number Range 3:</strong>
		</td>
		<td class="textmain" align="left">
			<input name="BeginningItem3" size="20" maxlength="50"
				<cfif isDefined("FORM.BeginningItem3")>
					value="#FORM.BeginningItem3#"
				</cfif>
			> -
			<input name="EndingItem3" size="20" maxlength="50"
				<cfif isDefined("FORM.EndingItem3")>
					value="#FORM.EndingItem3#"
				</cfif>
			>
		</td>
	</tr>	

	<tr>
		<td class="textmain" align="left">
			<strong>Item Number Range 4:</strong>
		</td>
		<td class="textmain" align="left">
			<input name="BeginningItem4" size="20" maxlength="50"
				<cfif isDefined("FORM.BeginningItem4")>
					value="#FORM.BeginningItem4#"
				</cfif>
			> -
			<input name="EndingItem4" size="20" maxlength="50"
				<cfif isDefined("FORM.EndingItem4")>
					value="#FORM.EndingItem4#"
				</cfif>
			>
		</td>
	</tr>	
<!---		
	<tr>
		<td class="textmain" align="left">
			<strong>Export to CSV?</strong>
		</td>
		<td class="textmain" align="left">
			<input type="checkbox" name="Export" value="1" 
				<cfif isDefined("FORM.Export") AND FORM.Export EQ 1>checked</cfif>
			>			
		</td>
	</tr>
--->	
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
				<cfelseif ErrorType IS "BeginningItemBlank">
					Please enter the Beginning Item Number (you may leave the Ending Item Number blank if you are searching for only one item).
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
<cfelseif isDefined("ErrorType") AND ErrorType IS "BeginningItemBlank">
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.SearchForm['BeginningItem'].focus();document.SearchForm['BeginningItem'].select()
	-->
	</script>
<cfelse>
	<script language="JavaScript" type="text/JavaScript">
	<!--
	document.SearchForm['BeginningDate'].focus();document.SearchForm['BeginningDate'].select()
	-->
	</script>
</cfif>