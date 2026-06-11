<cfcomponent extends="admin.assets.cfcs.Component" name="Admin" hint="I handle requests from the admin section dealing with sales rep accounts.">

	<cfif isDefined("APPLICATION.DSN_WWW")>
		<cfset THIS.DSN_WWW = APPLICATION.DSN_WWW>
	<cfelse>
		<cfset THIS.DSN_WWW = "NorTechWWW">
	</cfif>
	<cfset This.DataSourceName = THIS.DSN_WWW>

	<cfset THIS.ColumnNames = "ID,UserID,repname,repemail,VacationEmail,repURL,username,password,repphone,repbutton,reppriceurl,message,MarkupPctWorkstations,MarkupPctNotebooks,MarkupPctServers,CODESLSP">
	<cfset This.Columns = THIS.ColumnNames>
	<cfset This.ViewColumns = This.Columns>
	
	<cfset THIS.TableName = "salesrep">
	<Cfset This.ViewName = THIS.TableName>
	<cfset THIS.PriKey = "ID">
	<cfset This.PrimaryKey = "ID">
	<cfset THIS.ForeignKey = "UserID">
	
<!--- newRecord() --->
	<cffunction name="newRecord" access="public" output="no" returntype="struct">
		<cfset var stRecord = StructNew()>
		
		<cfloop list="#THIS.ColumnNames#" index="x">
			<cfset "stRecord.#x#" = "">
		</cfloop>
		
		<cfreturn stRecord />
	</cffunction>

<!--- listRecords() --->
	<cffunction name="listRecords" access="public" output="no" returntype="query">
		<cfargument name="sortby" type="string" required="no" default="repname" />
		<cfargument name="ascdesc" type="string" required="no" default="ASC" />
		<cfquery name="qListRecords" datasource="#THIS.DSN_WWW#">
			SELECT	#THIS.ColumnNames#
			FROM	#THIS.TableName#
			ORDER BY	#ARGUMENTS.SortBy# #AscDesc#
		</cfquery>
		<cfreturn qListRecords />
	</cffunction>
	
<!--- getRecordAsQuery() --->
	<cffunction name="getRecordAsQuery" access="public" output="no" returntype="query">
		<cfargument name="RecordID" required="yes" type="string" />
		<cfquery name="qGetRecord" datasource="#THIS.DSN_WWW#">
		SELECT	#THIS.ColumnNames#
		FROM	#THIS.TableName#
		WHERE	#THIS.PriKey# = '#ARGUMENTS.RecordID#'
		</cfquery>
		<cfreturn qGetRecord />
	</cffunction>
	
<!--- getRecordAsStruct() --->
	<cffunction name="getRecordAsStruct" access="public" output="no" returntype="struct">
		<cfargument name="RecordID" required="yes" type="string" />
		<cfset var stRecord = newRecord()>
		<cfset qRecord = getRecordAsQuery(ARGUMENTS.RecordID)>
		<cfloop list="#THIS.ColumnNames#" index="Column">
			<cfset "stRecord.#Column#" = evaluate("qRecord.#Column#")>
		</cfloop>
		<cfreturn stRecord />
	</cffunction>

<!--- getSalesRepByUserID() --->
	<cffunction name="getSalesRepByUserID" access="public" output="no" returntype="struct">
		<cfargument name="UserID" required="yes" type="string" />
		<cfset var stRecord = newRecord()>
		<cfquery name="qRecord" datasource="#THIS.DSN_WWW#">
		SELECT	#THIS.ColumnNames#
		FROM	#THIS.TableName#
		WHERE	#THIS.ForeignKey# = '#ARGUMENTS.UserID#'
		</cfquery>
		<cfloop list="#THIS.ColumnNames#" index="Column">
			<cfset "stRecord.#Column#" = evaluate("qRecord.#Column#")>
		</cfloop>
		<cfreturn stRecord />
	</cffunction>
	
<!--- insertRecord() --->
	<cffunction name="insertRecord" access="public" output="no" returntype="numeric">
		<cfargument name="Record" type="struct" required="yes" />
		
		<cfset qrySalesReps = listRecords("ID","Desc")>
		<cfset NextSalesRepID = qrySalesReps.ID + 1>
		<cfset structInsert(Record, "ID", NextSalesRepID, True)>
		
		<cfquery name="qInsertRecord" datasource="#THIS.DSN_WWW#">
		INSERT INTO
			#THIS.TableName#
		(
			ID,
			UserID,
			repname,
			repemail,
			VacationEmail,
			repURL,
			CODESLSP,
			username,
			password,
			repphone,
			repbutton,
			reppriceurl,
			message
		)
		VALUES
		(
			#Record.ID#,
			'#Record.UserID#',
			'#Record.repname#',
			'#Record.repemail#',
			'#Record.VacationEmail#',
			'#Record.repURL#',
			'#Record.CODESLSP#',
			'#Record.username#',
			'#Record.password#',
			'#Record.repphone#',
			'#Record.repbutton#',
			'#Record.reppriceurl#',
			'#Record.message#'
		);
		</cfquery>
		<cfreturn NextSalesRepID>
		
	</cffunction>
<!--- updateRecord() --->
	<cffunction name="updateRecord" access="public" output="no" returntype="void">
		<cfargument name="Record" type="struct" required="yes" />

		<cfquery name="qUpdateRecord" datasource="#THIS.DSN_WWW#">
		UPDATE
			#THIS.TableName#
		SET
			UserID = '#Record.UserID#',
			repname = '#Record.repname#',
			repemail = '#Record.repemail#',
			VacationEmail = '#Record.VacationEmail#',
			repURL = '#Record.repURL#',
			CODESLSP = '#Record.CODESLSP#',
			username = '#Record.username#',
			password = '#Record.password#',
			repphone = '#Record.repphone#',
			repbutton = '#Record.repbutton#',
			reppriceurl = '#Record.reppriceurl#',
			message = '#Record.message#'
		WHERE
			#THIS.PriKey# = '#Record.ID#'
		;
		</cfquery>
		
	</cffunction>

	<cffunction name="updateMarkupPercentages" access="public" output="no" returntype="void">
		<cfargument name="Record" type="struct" required="yes" />
		<cfquery name="qUpdateRecord" datasource="#THIS.DSN_WWW#" result="result_name">
		UPDATE
			#THIS.TableName#
		SET
			MarkupPctWorkstations = '#Arguments.Record.MarkupPctWorkstations#',
			MarkupPctNotebooks = '#Arguments.Record.MarkupPctNotebooks#',
			MarkupPctServers = '#Arguments.Record.MarkupPctServers#'
		WHERE
			#THIS.PriKey# = '#Arguments.Record.ID#'
		;
		</cfquery>
	</cffunction>
	
	<cffunction name="validateMarkupPercentages" access="public" returntype="struct" output="No">
	<cfargument name="Record" type="struct" required="Yes">
		<cfset var stErrors = structNew()>
		<cfif validateZeroDecimal(Arguments.Record.MarkupPctWorkstations) EQ 0>
			<cfset stErrors.MarkupPctWorkstations = "Please enter a decimal greater than or equal to zero">
		</cfif>
		<cfif validateZeroDecimal(Arguments.Record.MarkupPctNotebooks) EQ 0>
			<cfset stErrors.MarkupPctNotebooks = "Please enter a decimal greater than or equal to zero">
		</cfif>
		<cfif validateZeroDecimal(Arguments.Record.MarkupPctServers) EQ 0>
			<cfset stErrors.MarkupPctServers = "Please enter a decimal greater than or equal to zero">
		</cfif>
		<cfreturn stErrors>
	</cffunction>

	<cffunction name="getReplyToAddress" access="public" returntype="string" output="No">
	<cfargument name="CustomerID" type="string" required="Yes">
		<cfset var ReplyToAddress = "info@nor-tech.com">
		<cfset objCust = createObject("component", "admin.assets.cfcs.Cust")>
		<cfset qryLogin = objCust.getLoginRecord(Arguments.CustomerID)>
		<cfif qryLogin.RecordCount GT 0>
			<cfset qrySalesRep = getRecordAsQuery(qryLogin.salesrepID)>
			<cfif qrySalesRep.RecordCount NEQ 0 AND trim(qrySalesRep.repemail) IS NOT "">
				<cfset ReplyToAddress = trim(qrySalesRep.repemail)>
			</cfif>
		</cfif>
		<cfreturn ReplyToAddress>
	</cffunction>

	<!----------------------------------------------------------------------------------------------------------->
	<cffunction name="updateVacationEmail" access="public" output="no" returntype="void">
		<cfargument name="UserID" type="string" required="yes" />
		<cfargument name="VacationEmail" type="string" required="yes" />
<!---        
		<cfif trim(Arguments.VacationEmail) IS NOT "">
--->
            <cfquery datasource="#THIS.DSN_WWW#">
            UPDATE	salesrep
            SET		VacationEmail = '#trim(Arguments.VacationEmail)#'
            WHERE	UserID = '#Arguments.UserID#'
            </cfquery>
<!---
        </cfif>
--->
	</cffunction>        
	
</cfcomponent>