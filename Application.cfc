<cfcomponent
    displayname="Application"
    output="true"
    hint="Handle the application.">
	

    <!--- Set up the application. --->
    <cfset this.Name = "anketa" />
	<cfset this.applicationTimeout = createTimeSpan( 0, 0, 3, 0 ) />
  	<cfset this.sessionmanagement="Yes"/>
  	<cfset this.clientmanagement="No"/>
  	<cfset this.sessiontimeout=CreateTimeSpan(0, 0, 120, 0)/>
  	<cfset this.setclientcookies="No"/>	
	
	<cfset request.thisPage=getFileFromPath(getBaseTemplatePath())>

<!--- правильно ли определять тут прикладные переменные? категорически неправильно! например, тут сессии не видно. И вообще это инфраструктурная секция --->
		
		
    <!--- Define the page request properties. --->
    <cfsetting
        requesttimeout="20"
        showdebugoutput="false"
        enablecfoutputonly="false"
     /> 
	<!--- эспериментально установлено, что cfquery в этой секции не видит DATASOURCES, определенных здесь же. А в методе onRequest - видит --->
	<!--- эспериментально установлено, что сессия, видимая в методах и дальше в страницах, здесь не видна --->
	<!--- Некорректно сконфигурированный датасорс, помещенный в  коллекцию this.datasources, не виден в ней! cfquery ругается не на некорректный источник данных, а на то, что такого источника нет! То ли сеттер такой слишком умный. По всей видимости, набор параметров может работать на одной платформе и не работать на другой (скажем, Commandbox и обычная Lucee). Соответствующую ошибку можно очень долго искать. --->
	
<!--- --------------------------------------------------------------------- --->
<!--- закончили псевдоконструктор см.тж. https://www.bennadel.com/blog/4269-dynamically-enabling-disabling-session-management-in-lucee-cfml-5-3-8-201.htm  --->
<!--- --------------------------------------------------------------------- --->

    <cffunction
        name="OnApplicationStart"
        access="public"
        returntype="boolean"
        output="false"
        hint="Fires when the application is first created.">

        <cfreturn true />
    </cffunction>


    <cffunction
        name="OnRequest"
        access="public"
        returntype="void"
        output="true"
        hint="Fires after pre page processing is complete.">		
		<cfargument name="template" type="string" required="true"/>	
		
		<cfset request.startTickCount=getTickCount()/>
        
		<cfset setEncoding("FORM", "UTF-8")>
		<cfset setEncoding("URL", "UTF-8")>
	
		<!--- global settings --->
		
		<cfset this.datasource = "anketa"/><!--- default datasource name --->
		<cfset this.defaultdatasource = this.datasource/><!--- default datasource name --->
		<cfset request.DS = "#this.datasource#">
		<cfset this.datasources["#this.datasource#"]=getDS("#this.datasource#","cfconfig_datasources_#this.datasource#")/><!--- datasource name, environment variable prefix without "_" --->	
		
		<cfset request.APP_VERSION="0.00.001"/><!---2024-10-13 15:26:10--->		
		<cflock scope="application" type="readonly" timeout=3>
			<cfset request.DS=this.datasource/>
			<cfset request.APP_NAME=this.Name/>
		</cflock>
		
		<cfset request.respondent_id=-1>
		<cfset request.target_usr_id=-1>
		<cfset request.questionary_id=1>

		<!---*** криво, потому что обработка поста (гета) не должна быть разбросана. И вообще это не делают в Application.cfc---> 
		<cfparam name="target_usr_id" default=-1/>
		<cfif target_usr_id GT 0>
			<cflock scope="SESSION" type="EXCLUSIVE" timeout=1>		
				<cfset session.target_usr_id=target_usr_id/>
			</cflock>
		</cfif>

		<cflock scope="SESSION" type="READONLY" timeout=1>
			<cfif isDefined("session.respondent_id") AND session.respondent_id GT 0>
				<cfset request.respondent_id=session.respondent_id />
				<cfif isDefined("session.target_usr_id") AND session.target_usr_id GT 0>
					<cfset request.target_usr_id=session.target_usr_id>
				<cfelse>
					<!---<cflocation url="welcome.cfm" addtoken="No">--->
				</cfif>
			<cfelse>
				<cfif #request.thisPage# NEQ "login.cfm">
					<cflocation url="login.cfm" addtoken="No">
				</cfif>
			</cfif>
		</cflock>		
		
		<cftry>
			<cfquery name="qIsolation" datasource="#request.DS#">
			set transaction isolation level read uncommitted;
			</cfquery>
			
			<cfcatch type="any">
				<cfdump var=#cfcatch#/>
				<cfdump var=#this#/>
				<cfdump var=#createObject("java", "java.lang.System").getEnv()#/>	
			</cfcatch>
		</cftry>
		
		
		<!--- <cfset dbInit()/> --->
		

		<cfquery name="qResponse" datasource="#request.DS#">
		select response_id as response_id, dt_completed from response where respondent_id=#request.respondent_id# 
		AND questionary_id=<cfqueryparam cfsqltype="cf_sql_integer" value="#request.questionary_id#"/> AND target_usr_id=<cfqueryparam cfsqltype="cf_sql_integer" value="#request.target_usr_id#"/>
		</cfquery> 
		
		<cfset request.readonly="No">
		<cfif qResponse.recordCount EQ 0>
			<!---<cfquery name="qReqisterResponse" datasource="#request.DS#">
			insert into response(respondent_id,questionary_id,target_usr_id,dt_completed)
			values (
			<cfqueryparam cfsqltype="cf_sql_integer" value="#request.respondent_id#"/>,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#request.questionary_id#"/>,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#request.target_usr_id#" null=#!(request.target_usr_id GT 0)#/>, 
			null)
			</cfquery>
			<cfquery name="qId" datasource="#request.DS#">
			select scope_identity() as id
			</cfquery>
			<cfset request.response_id=qId.id>--->
		<cfelseif isDate(qResponse.dt_completed) AND #request.thisPage# NEQ "finish.cfm" AND #request.thisPage# NEQ "login.cfm">
			<cfset request.readonly="Yes">
		</cfif>

		<!--- <cfdump var=#qResponse#/> --->
		<cfset request.response_id=-1>
		<cfif qResponse.recordCount GT 0>
			<cfset request.response_id=qResponse.response_id>
		</cfif>
		
        <!--- *** в одном методе перемешана прикладная и инфраструктурная логика (причем прикладная идет раньше, что совсем плохо) --->		

		<cfset local = {} />

        <cfset local.basePath = getDirectoryFromPath(
            getCurrentTemplatePath()
            ) />

        <cfset local.targetPath = getDirectoryFromPath(
            expandPath( arguments.template )
            ) />

        <cfset local.requestDepth = (
            listLen( local.targetPath, "\/" ) -
            listLen( local.basePath, "\/" )
            ) />

        <cfset request.webRoot = repeatString(
            "../",
            local.requestDepth
            ) />

        <!---
            While we wouldn't normally do this for every page
            request (it would normally be cached in the
            application initialization), I'm going to calculate
            the site URL based on the web root.
        --->
        <cfset request.siteUrl = (
			IIF(
				(CGI.server_port_secure <!--- CGI.https EQ "On" does not work with apache+tomcat and nginx+tomcat --->),
				DE( "https://" ),
				DE( "http://" )
				) &
            cgi.http_host &
            reReplace(
                getDirectoryFromPath( arguments.template ), 
				"([^\\/]+[\\/]){#local.requestDepth#}$",
                "",
                "one"
                )
            ) />

		<cfset request.thisPage=Replace(ReplaceNoCase(expandPath(ARGUMENTS.template), local.basePath, ""), "\", "/")/>		
		
		<cfcookie name="CFID" value="#session.CFID#">
		<cfcookie name="CFTOKEN" value="#session.CFTOKEN#">
		
		<cfinclude template="#ARGUMENTS.template#"/>
		
<!--- 		<cfdump var=#request#/>
		<cfdump var=#this.datasources#/> --->
		
		

        <cfreturn />
    </cffunction>
	


    <cffunction
        name="OnRequestEnd"
        access="public"
        returntype="void"
        output="true"
        hint="Fires after the page processing is complete.">
		<!--- Attention! Before CF9, OnrequestEnd is not executed in case of redirect. That is why we use session.save_login --->
        <cfreturn />
    </cffunction>
	
<!--- 	<cffunction
        name="dbInit"
        access="public"
        returntype="void"
        output="true"
        hint="Init the database">
		<!--- should specify datasource, too early call --->
		<cfquery name="dbInit" datasource="#request.DS#">
			<cfinclude template="etc/db/anketa.sql"/>
		</cfquery>
		<cfdump var=#dbInit#/>
		<cfabort/>
		
        <cfreturn />
    </cffunction> --->
	
	<cffunction
        name="getDS"
        access="private"
        returntype="struct"
        output="true"
        hint="Configure data source from environment variables. Convention: data source name is an environment varialble prefix">
		
		<cfargument name="dsname" type="string" required="true"/>
		<cfargument name="prefix" type="string" default=#dsname#/>
		
		<cfset system = createObject("java", "java.lang.System")/>
		<cfset var ds={}/>
		
		<cfloop list="class,connectionString,database,driver,dbdriver,host,port,type,url,username,password,bundleName,bundleVersion,connectionLimit,liveTimeout,validate" item="field"><!--- driver vs dbdriver --->
			<cfset var value=system.getEnv("#arguments.prefix#_#field#")/>
			<cfif isDefined("value") AND len(value)>
				<cfset structInsert(ds,field,value)/>
			</cfif>			
		</cfloop>		
		
		<!--- test datasource (just to get exception if invalid) --->
		<cfquery name="qTestDs" datasource=#ds#>
			select 1;
		</cfquery>

        <cfreturn ds/>
		<!--- this.datasources["cmdb"] = {
			class: "org.postgresql.Driver", 
			//bundleName: "org.postgresql.jdbc", 
			//bundleVersion: "42.6.0",
			connectionString: "jdbc:postgresql://localhost:5432/cmdb-prod",
			username: "appserver",
			password: "encrypted:*********************",			
			// optional settings
			connectionLimit:5, // default:-1
			liveTimeout:15, // default: -1; unit: minutes
			validate:false, // default: false
		}; --->
    </cffunction>

</cfcomponent>