<cfquery name="qMenu" datasource="#request.DS#">
select question_id, question_type, title, (case when length(COALESCE(annonce,''))=0 then descr else annonce end) as annonce, ord 
from question 
where parent_id is null order by ord
</cfquery>
<!--- <cfquery name="qSubject" datasource="#request.DS#">
	select usr_id, shortname from usr 
	where usr_id=<cfqueryparam cfsqltype="cf_sql_integer" value="#request.target_usr_id#" null=#!(request.target_usr_id GT 0)#/>
</cfquery> --->
<cfquery name="qSubject" datasource="#request.DS#">
	select u.login, u.firstname, u.middlename, u.lastname from respondent u
	where u.respondent_id=<cfqueryparam cfsqltype="cf_sql_integer" value=#request.target_usr_id# null=#!(request.target_usr_id GT 0)#/>
</cfquery>

<!-- page -->
<table border="0" align="center" cellpadding="0" cellspacing="0" class="votePage">
<tr>
	<td align="center">	
	<div style="height:10px">&nbsp;</div>
		<!-- header -->
		<!---<table border="0" cellpadding="0" cellspacing="0" class="voteHeader">
		<tr align="center">
			<td><a href="index.cfm" style="text-decoration:none;border: none;"><img src="img/head.gif" alt="" width="481" height="71" border="0"></a></td>
		</tr>
		</table>--->
		<!-- /header -->
	<a href="index.cfm">Опрос 360 градусов</a>
	<div style="height:10px">&nbsp;</div>
			
<div style="text-align:right;color:#cb3945; padding-right:20px;"><cfoutput query="qSubject">Оцениваемый сотрудник: #firstname# #middlename# #lastname# [#login# #request.target_usr_id#]</cfoutput></div>			
<table border="0" cellpadding="0" cellspacing="0" class="voteMenu">
<tr><td align="center" valign="middle">		
	
			<cfset cnt=0>
			<cfoutput query="qMenu">
				<cfset id=qMenu.question_id>
				<cfset cnt=cnt+1>
				
				<cfset fill=structFind(request.fill, qMenu.question_id)>
				
				<cfif #root_question_id# EQ #qMenu.question_id#>
					<cfset class = "Sel">
				<cfelseif fill EQ 0>
					<cfset class = "Off">
				<cfelseif fill EQ 1>
					<cfset class = "Off">	
				<cfelseif fill EQ 2>
					<cfset class = "On">
				</cfif>
				 
			&nbsp;&nbsp;<a id="vote#cnt#" href="javascript:saveAndGo(#id#);" class="#class#">#ord#. #title#</a>&nbsp;&nbsp;
		
</cfoutput>
</td>
</tr>
</table>	
	</td>
</tr>
<tr>
	<td>	
<div style="height:5px"><spacer /></div>				
			
			

		
<table align="center">
<tr>
	<td><img src="img/step_off.gif" alt=""></td>
	<td class="smFreeText">- не закончен</td>
	<td></td>
	<td><img src="img/step_on.gif" alt=""></td>
	<td class="smFreeText">- закончен</td>
	<td></td>
	<td><img src="img/step_sel.gif" alt=""></td>
	<td class="smFreeText">- текущий</td>
</tr>
</table>

<cfif request.readonly>
<p align="center" class="freeTextGreen"><b>Анкета доступна только для просмотра</b>
<div style="height:5px"><spacer /></div>	
</p>

</cfif>
		
		<!-- /step -->		
	</td>
</tr>
