<cfcomponent extends="admin.assets.cfcs.Component" name="Admin" hint="I handle requests from the admin section dealing with admin accounts.">

	<cfif isDefined("APPLICATION.DSN_WWW")>
		<cfset THIS.DSN_WWW = APPLICATION.DSN_WWW>
	<cfelse>
		<cfset THIS.DSN_WWW = "NorTechWWW">
	</cfif>
	<cfset This.DataSourceName = THIS.DSN_WWW>
		
	<cfset THIS.ColumnNames = "UserID,EmailAddress,Passwd,VacationPassword,IsVacationPasswordActive,CoveringUserID,FName,LName,Active,Role,MaintainSystemDefault">
	<cfset THIS.TableName = "tblAdminAccts">
	<cfset THIS.PriKey = "UserID">
	<cfset This.PrimaryKey = "UserID">
	
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
		<cfargument name="sortby" type="string" required="no" default="fname" />
		<cfargument name="ascdesc" type="string" required="no" default="ASC" />
		<cfquery name="qListRecords" datasource="#THIS.DSN_WWW#">
		SELECT	#THIS.ColumnNames#
		FROM	#THIS.TableName#
		ORDER BY	#ARGUMENTS.SortBy# #AscDesc#
		</cfquery>
		<cfreturn qListRecords />
	</cffunction>

	<!---------------------------------------------------------------------------------->
	<cffunction name="listSalesReps" access="public" output="no" returntype="query">
		<cfquery name="qListRecords" datasource="#THIS.DSN_WWW#">
		SELECT	#THIS.TableName#.*, salesrep.CODESLSP
		FROM	#THIS.TableName#
				INNER JOIN salesrep ON #THIS.TableName#.UserID = salesrep.UserID
		WHERE	(tbladminaccts.Role = 'Sales Rep') AND 
        		(tbladminaccts.active = 1) AND
                (tbladminaccts.emailaddress  <> 'todds@nor-tech.com')
		ORDER BY	lname, fname
		</cfquery>
		<cfreturn qListRecords />
	</cffunction>

	<!---------------------------------------------------------------------------------->
	<!--- RAB 1/5/2016.  Don't select Nick Forga --->
	<cffunction name="listSalesReps011516" access="public" output="no" returntype="query">
		<cfquery name="qListRecords" datasource="#THIS.DSN_WWW#">
		SELECT	#THIS.TableName#.*, salesrep.CODESLSP
		FROM	#THIS.TableName#
				INNER JOIN salesrep ON #THIS.TableName#.UserID = salesrep.UserID
		WHERE	(tbladminaccts.Role = 'Sales Rep') AND 
        		(tbladminaccts.active = 1) AND
                (tbladminaccts.emailaddress  <> 'todds@nor-tech.com') AND
                (tbladminaccts.UserID  <> '9D5AF893-423B-5784-99724D976FDB66B7')
		ORDER BY	lname, fname
		</cfquery>
		<cfreturn qListRecords />
	</cffunction>
	
	

	
	
<!--- getRecordAsQuery() --->
	<cffunction name="getRecordAsQuery" access="public" output="no" returntype="query">
		<cfargument name="RecordID" required="yes" type="string" />
		
		<cfquery name="qGetRecord" datasource="#THIS.DSN_WWW#">
		SELECT
			#THIS.ColumnNames#
		FROM
			#THIS.TableName#
		WHERE
			#THIS.PriKey# = '#ARGUMENTS.RecordID#'
		;
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
<!--- insertRecord() --->
	<cffunction name="insertRecord" access="public" output="no" returntype="any">
		<cfargument name="Record" type="struct" required="yes" />
		
		<cfset var UserID = createUUID()>
	
		<cfquery name="qInsertRecord" datasource="#THIS.DSN_WWW#">
		INSERT INTO
			#THIS.TableName#
		(
			UserID,
			EmailAddress,
			Passwd,
			FName,
			LName,
			Active,
			Role,
            VacationPassword, 
            IsVacationPasswordActive, 
            CoveringUserID,
            MaintainSystemDefault
		)
		VALUES
		(
			'#UserID#',
			'#Record.EmailAddress#',
			'#Record.Passwd#',
			'#Record.FName#',
			'#Record.LName#',
			'#Record.Active#',
			'#Record.Role#',
			'#Record.VacationPassword#',
			'#Record.IsVacationPasswordActive#',
			'#Record.CoveringUserID#',
			'#Record.MaintainSystemDefault#'
		)
		</cfquery>
		<cfreturn UserID>
		
	</cffunction>
<!--- updateRecord() --->
	<cffunction name="updateRecord" access="public" output="no" returntype="void">
		<cfargument name="Record" type="struct" required="yes" />
		
		<cfquery name="qUpdateRecord" datasource="#THIS.DSN_WWW#">

		UPDATE
			#THIS.TableName#
		SET
			EmailAddress = '#Record.EmailAddress#',
			Passwd = '#Record.Passwd#',
			FName = '#Record.FName#',
			LName = '#Record.LName#',
			Active = #Record.Active#,
			Role = '#Record.Role#',
            VacationPassword = '#Record.VacationPassword#',
            IsVacationPasswordActive = '#Record.IsVacationPasswordActive#',
            CoveringUserID = '#Record.CoveringUserID#'
			<cfif isDefined("Record.MaintainSystemDefault")>
	            ,MaintainSystemDefault = '#Record.MaintainSystemDefault#'
            </cfif>
		WHERE
			#THIS.PriKey# = '#Record.UserID#'
		;
		</cfquery>
		
	</cffunction>
	
	
	<cffunction name="UserNamePasswordValid" access="public" output="no" returntype="boolean">
	<cfargument name="Record" type="struct" required="yes"/>
		<cfset var isValid = 1>		
		<cfquery name="qryAdminAccts" datasource="#THIS.DSN_WWW#">
		SELECT	#THIS.ColumnNames#
		FROM	#THIS.TableName#
		WHERE	emailaddress = '#Arguments.Record.EmailAddress#' AND
				passwd = '#Arguments.Record.Passwd#' AND
				UserID <> '#Arguments.Record.UserID#'
		</cfquery>
		<cfif qryAdminAccts.RecordCount NEQ 0>
			<cfset isValid = 0>		
		</cfif>
		<cfreturn isValid />
	</cffunction>

	<cffunction name="sendVacationEmail" access="public" output="no" returntype="boolean">
	<cfargument name="UserID" type="string" required="yes"/>
		<cfset var Success = 0>		
		<cfset var strVacationingUser = structNew()>
		<cfset var strCoveringUser = structNew()>
		<cfset strVacationingUser = getRecordAsStruct(Arguments.UserID)>
		<cfset strCoveringUser = getRecordAsStruct(strVacationingUser.CoveringUserID)>
        <cfif NOT structIsEmpty(strVacationingUser) AND 
        	  NOT structIsEmpty(strCoveringUser) AND 
			  structKeyExists(strVacationingUser, "EmailAddress") AND
			  structKeyExists(strCoveringUser, "EmailAddress")>
            <cfmail from=	"#strVacationingUser.EmailAddress#"		
                    to=		"#strCoveringUser.EmailAddress#"
                    replyto="#strVacationingUser.EmailAddress#"
                    subject="Nor-Tech User Vacation Annoucement" 
                    
                    
                    type="html">
            <html>
            <head>
                <style type="text/css">
                    BODY	{font-family: Verdana, Arial, Helvetica, sans-serif; font-size:12px}
                </style>
            </head>
            <body>
                Hi #strCoveringUser.FName#,<br><br>
                
                #strVacationingUser.FName# #strVacationingUser.LName# is going to be out of the office, and has requested that you cover their accounts while they are gone.<br><br>
                
                You can log into their account using the following credentials:<br><br>
                
                UserName: #strVacationingUser.EmailAddress#<br>
                Password: #strVacationingUser.VacationPassword#<br><br>
                
                You will have limited access to view their customers and price lists, and will be able to maintain, create, and send quotes to their customers.<br><br>
                
                Thanks for helping out!           
            </body>
            </html>	
            </cfmail>
			<cfset Success = 1>		
		</cfif>
		<cfreturn Success>
	</cffunction>


	<!----------------------------------------------------------------------------------------------------------------------------->	
	<cffunction name="passwordHasExpired" access="public" output="No" returntype="boolean">
	<!---
		Function:		passwordHasExpired
		Coded By:		Ron Barth
		Create Date:	04/19/2013
	--->
	<cfargument name="UserID" type="string" required="Yes">
		<cfset var ForceNewPassword = 0>
		<cfset var qry_tblAdminaccts = queryNew("")>

		<!--- Force Password Change if number of logins > 1000 --->
        <cfset var LoginCountLimit = 1000>
        
		<!--- Force Password Change if last password change is more than 6 months ago --->
		<cfset var LoginDateLimit = dateAdd('m', -6, now())>

        <cfquery name="qry_tblAdminaccts" datasource="#THIS.DSN_WWW#">
        SELECT	LoginCount, LastPasswordChange
        FROM 	tbladminaccts
        WHERE 	UserID = '#Arguments.UserID#'
        </cfquery>

		<cfif qry_tblAdminaccts.LoginCount GT LoginCountLimit OR (isDate(qry_tblAdminaccts.LastPasswordChange) AND dateCompare(qry_tblAdminaccts.LastPasswordChange, LoginDateLimit) EQ -1)>
            <cfset ForceNewPassword = 1>
        </cfif>

        <cfreturn ForceNewPassword>
	</cffunction>

	<!----------------------------------------------------------------------------------------------------------------------------->	
	<cffunction name="stampLogin" access="public" output="No">
	<!---
		Function:		stampLogin
		Coded By:		Ron Barth
		Create Date:	04/19/2013
	--->
	<cfargument name="UserID" type="string" required="Yes">
		<cfset var qry_tblAdminaccts = queryNew("")>
        <cfset var NewLoginCount = 0>

        <cfquery name="qry_tblAdminaccts" datasource="#THIS.DSN_WWW#">
        SELECT	LoginCount
        FROM 	tbladminaccts
        WHERE 	UserID = '#Arguments.UserID#'
        </cfquery>
        
		<cfif isNumeric(qry_tblAdminaccts.LoginCount)>
			<cfset NewLoginCount = qry_tblAdminaccts.LoginCount + 1>
        <cfelse>
			<cfset NewLoginCount = 1>
        </cfif>

        <cfquery datasource="#THIS.DSN_WWW#">
        UPDATE 	tbladminaccts
        SET		LoginCount = '#NewLoginCount#'
        WHERE 	UserID = '#Arguments.UserID#'
		</cfquery>
        
	</cffunction>

	<!----------------------------------------------------------------------------------------------------------------------------->	
	<cffunction name="samePasswordEntered" access="public" output="No" returntype="boolean">
	<!---
		Function:		samePasswordEntered
		Coded By:		Ron Barth
		Create Date:	04/19/2013
	--->
	<cfargument name="UserID" type="string" required="Yes">
	<cfargument name="password" type="string" required="Yes">
		<cfset var samePasswordEntered = 0>
		<cfset var qry_tblAdminaccts = queryNew("")>

        <cfquery name="qry_tblAdminaccts" datasource="#THIS.DSN_WWW#">
        SELECT	passwd
        FROM 	tbladminaccts
        WHERE 	UserID = '#Arguments.UserID#'
        </cfquery>
        
        <cfif trim(qry_tblAdminaccts.passwd) IS trim(Arguments.password)>
			<cfset samePasswordEntered = 1>
        </cfif>
        
        <cfreturn samePasswordEntered>
	</cffunction>

	<!----------------------------------------------------------------------------------------------------------------------------->	
	<cffunction name="passwordIsNoGood" access="public" output="No" returntype="boolean">
	<!---
		Function:		passwordIsNoGood
		Coded By:		Ron Barth
		Create Date:	04/19/2013
	--->
	<cfargument name="password" type="string" required="Yes">
		<cfset var passwordIsNoGood = 0>
		<cfset var Column = "">
        <cfset var ColumnValue = "">
        <cfset var AsciiValue = "">
    	<cfset var LetterFound = 0>
    	<cfset var NumberFound = 0>
    	<cfset var SpecialCharacterFound = 0>

        <cfloop from="1" to="#len(trim(Arguments.password))#" index="Column">
            <cfset ColumnValue = mid(trim(Arguments.password), Column, 1)>
            <cfset AsciiValue = asc(ColumnValue)>
        
            <cfif (AsciiValue GE 65 AND AsciiValue LE 90) OR 
				  (AsciiValue GE 97 AND AsciiValue LE 122)>
                <cfset LetterFound = 1>
            </cfif>
            <cfif (AsciiValue GE 48 AND AsciiValue LE 57)>
                <cfset NumberFound = 1>
            </cfif>
            <cfif (AsciiValue GE 33 AND AsciiValue LE 47) OR 
				  (AsciiValue GE 58 AND AsciiValue LE 64) OR 
				  (AsciiValue GE 91 AND AsciiValue LE 96) OR 
				  (AsciiValue GE 123 AND AsciiValue LE 126)>
                <cfset SpecialCharacterFound = 1>
            </cfif>
        </cfloop>

		<cfif len(trim(Arguments.password)) LT 12 OR NOT LetterFound OR NOT NumberFound OR NOT SpecialCharacterFound>
			<cfset passwordIsNoGood = 1>
        </cfif>
        
        <cfreturn passwordIsNoGood>
	</cffunction>

	<!----------------------------------------------------------------------------------------------------------------------------->	
	<cffunction name="saveNewPassword" access="public" output="No">
	<!---
		Function:		saveNewPassword
		Coded By:		Ron Barth
		Create Date:	04/19/2013
	--->
	<cfargument name="UserID" type="string" required="Yes">
	<cfargument name="password" type="string" required="Yes">

        <cfquery datasource="#THIS.DSN_WWW#">
        UPDATE 	tbladminaccts
        SET		Passwd = '#Arguments.password#',
        		LastPasswordChange = #createODBCDateTime(now())#,
        		LoginCount = 0
        WHERE 	UserID = '#Arguments.UserID#'
		</cfquery>

	</cffunction>


	
</cfcomponent>