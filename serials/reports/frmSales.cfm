<cfsilent>
<!---
	Coded By: 		Alternative Systems, Inc - Ron Barth
	Create Date: 	11/08/2007
	Function: 		This page prompts the user to enter a Date Range, and an Item or Item Range
	Template:		frmSales.cfm
	Task:			serials_reports_sales_enter
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

		<cfelseif trim(FORM.BeginningItem) IS "">
			<cfset Error = 1>
			<cfset ErrorType = "BeginningItemBlank">
			
		<cfelse>
			<cfparam name="FORM.Export" default="0">
			<cflocation url="index.cfm?task=serials_reports_sales_disp&BeginningDate=#urlEncodedFormat(FORM.BeginningDate)#&EndingDate=#urlEncodedFormat(FORM.EndingDate)#&BeginningItem=#urlEncodedFormat(FORM.BeginningItem)#&EndingItem=#urlEncodedFormat(FORM.EndingItem)#&Export=#urlEncodedFormat(FORM.Export)#&RequestTimeout=6000">
		</cfif>
	</cfif>

</cfsilent>

<cfoutput>
<table width="549" border="0" align="center" cellpadding="3" cellspacing="1">
<!--- spacer --->
<tr><td class="textsmall" colspan="2">&nbsp;</td></tr>

<form name="SearchForm" action="index.cfm?task=serials_reports_sales_enter" method="post">
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
			<strong>Beginning Item Number:</strong> *
		</td>
		<td class="textmain" align="left">
			<input name="BeginningItem" size="20" maxlength="50"
				<cfif isDefined("FORM.BeginningItem")>
					value="#FORM.BeginningItem#"
				</cfif>
			>
		</td>
	</tr>
	<tr>
		<td class="textmain" align="left">
			<strong>Ending Item Number:</strong>
		</td>
		<td class="textmain" align="left">
			<input name="EndingItem" size="20" maxlength="50"
				<cfif isDefined("FORM.EndingItem")>
					value="#FORM.EndingItem#"
				</cfif>
			>
		</td>
	</tr>
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