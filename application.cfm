<cfcontent type="text/html; charset=windows-1251">


<CFAPPLICATION NAME="questionary" SESSIONMANAGEMENT="Yes" CLIENTMANAGEMENT="No" sessiontimeout="#CreateTimeSpan(1, 1, 120, 1)#" setclientcookies="Yes">
<cfset request.DS = "anketa">
<cfset request.thisPage=getFileFromPath(getBaseTemplatePath())>

<cfset request.respondent_id=-1>
<cfset request.target_usr_id=-1>
<cfset request.questionary_id=1>


<!---*** криво, потому что обработка поста (гета) не должна быть разбросана--->
<cfparam name="target_usr_id" type="integer" default="-1"/>
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


<cfquery name="qIsolation" datasource="#request.DS#">
set transaction isolation level read uncommitted
</cfquery>

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
<cfdump var=#qResponse#/>
<cfset request.response_id=qResponse.response_id>


<cfscript>
function escapeQuotes(s) {
	return replace(s,'"','&quot;',"ALL"); 
}
</cfscript>



