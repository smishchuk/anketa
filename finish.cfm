<cfif isDefined("finish")>
	<cfquery name="qFinish" datasource="#request.DS#">
	update response set dt_completed=getdate() where questionary_id='#request.questionary_id#' AND response_id='#request.response_id#'
	</cfquery> 
	
	<!---
	<cfquery name="qClearQ2" datasource="#request.DS#">
	delete from answer where answer_id in (
	select a1.answer_id from question q1 
		join question q on q.parent_id=q1.question_id 
		join answer a1 on a1.question_id=q.question_id
	where not (q1.question_id in (
		select q2.question_id
		from question q2 
		join answer a2 on (a2.question_id=1 /* *** */AND a2.response_id='#request.response_id#')
		join choice c2 on (c2.choice_id=a2.choice_id AND convert(varchar(255),c2.choice)=q2.title)
		where q2.parent_id='2')
	) 
	AND q1.parent_id='2' AND a1.response_id = '#request.response_id#'	
	) 
	</cfquery>
	--->
	<cflock scope="SESSION" type="EXCLUSIVE" timeout=1>	
		<cfset structDelete(session, "target_usr_id")/>
		<cfset structDelete(session, "response_id")/>
		<cfset request.target_usr_id=-1/>
		<cfset request.response_id=-1/>
	</cflock>
</cfif>


<cfquery name="qResponse" datasource="#request.DS#">
select (case when dt_completed is null then 0 else 1 end) as closed from response where response_id='#request.response_id#' 
</cfquery>

<cfquery name="qSubject" datasource="#request.DS#">
	select usr_id, shortname from usr 
	where usr_id=<cfqueryparam cfsqltype="cf_sql_integer" value="#request.target_usr_id#" null=#!(request.target_usr_id GT 0)#/>
</cfquery>

<cfinclude template="inc/header.cfm">

<!-- page -->
<table border="0" align="center" cellpadding="0" cellspacing="0" class="votePage">
<tr>
	<td>	
	<div style="height:10px"><spacer /></div>
		<!-- header -->
		<table border="0" cellpadding="0" cellspacing="0" class="voteHeader">
		<tr align="center">
			<td><a href="index.cfm" style="text-decoration:none;border: none;">
				Опрос 360 градусов		
			</a></td>
		</tr>
		</table>
		<div style="text-align:right;color:#cb3945; padding-right:20px;"><cfoutput query="qSubject">Оцениваемый сотрудник: #shortname#</cfoutput></div>		
		<!-- /header -->					

	</td>
</tr>
<!---
<cfoutput>
request.target_usr_id #request.target_usr_id#
request.respondent_id #request.respondent_id#
request.response_id #request.response_id#
</cfoutput>
--->
<cfif qResponse.closed EQ 1 OR NOT (request.response_id GT 0) OR NOT (request.target_usr_id GT 0)>
<tr height="100%" valign="top">
	<td>
		<div style="height:10px"><spacer /></div>		
		<table width="100%" bgcolor="f3f3f3" border="0" cellpadding="5" cellspacing="0">
			<tr valign="middle">
				<td>
				<div style="height:15px"><spacer /></div>	
				</td>
			</tr>
		</table>
		
		<div style="height:50px"><spacer /></div>	
		<table align="center" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td class="voteError">Опрос завершен</td>
		</tr>
		</table>		
		<div style="height:50px"><spacer /></div>
				
		<table width="100%" bgcolor="f3f3f3" border="0" cellpadding="5" cellspacing="0">
			<tr valign="middle">
				<td>
				<div style="height:15px"><spacer /></div>	
				</td>
			</tr>
		</table>					

		<!-- content -->
		<table border="0" cellpadding="0" cellspacing="0" height="100%" align="center" width="650">
		<tr>
			<td valign="top">

				<div style="height:30px"><spacer /></div>
				<h3>
				Дорогой друг!
				</h3>
				<p align="justify">
				Большое спасибо за то, что ты нашел время заполнить нашу анкету. 
				<br><br>
				<span style="text-decoration:line-through;"/>Если тебе нечем заняться в своей Маскве </span>
				<br><br>
				Твой звонок очень важе .
				</p>
				<br><br>
				<p align="right">
				<b>С уважением,</b>

				<p align="right"><b>Харченко Оля,</b><br>
				<b>работаю на станции</b>	
				</p>
				
				<br><br>
				
				<script language="javaScript">
					function saveAndGo(target_id){
						if (document.getElementById("frmQuestion")) {
							document.getElementById("target_id").value=target_id;
							document.getElementById("frmQuestion").submit();
						} else {
							//alert('no form');
						}
					}
				</script>
				
				<form name="frmQuestion" id="frmQuestion" method="get" action="index.cfm">
				<input type="hidden" name="target_id" id="target_id" value="0"/>
				
				<cfquery name="qTargetUsr" datasource="#request.DS#">
					select r.target_usr_id, u.shortname from response r join usr u on (r.target_usr_id=u.usr_id)
					where respondent_id=<cfqueryparam cfsqltype="cf_sql_integer" value='#request.respondent_id#'/> AND r.dt_completed is null
				</cfquery>
				
				<cfif qTargetUsr.recordCount GT 0>
				<p>Опаньки! Ты еще не всех оценил. Продолжим?</p>
				<p>Пожалуйста, выбери оцениваемого сотрудника:
				<cfmodule template="mod/combo.cfm" query=#qTargetUsr# combo="target_usr_id" id="target_usr_id" key="target_usr_id" selected="#request.target_usr_id#"
					displayf="##shortname##" 
					class=""/>		
				</p>	
				<p align="center">
				<cfoutput><img name="start" src="img/btn_start.gif" style="cursor:pointer;" title="Начать опрос" width="112" height="18" border="0" onClick="saveAndGo(13);"></cfoutput>
				</p>
				</form>
				</cfif>
			</td>
		</tr>
		</table>
		<!-- /content -->

	</td>
</tr>
<cfelse>
<tr height="100%" valign="top">
	<td>
	
		<div style="height:10px"><spacer /></div>	
			
		<table width="100%" bgcolor="f3f3f3" border="0" cellpadding="5" cellspacing="0">
			<tr valign="middle">
				<td>
				<div style="height:15px"><spacer /></div>	
				</td>
			</tr>
		</table>
		
		<div style="height:50px"><spacer /></div>
		
		<table align="center" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td class="voteError">Завершение опроса</td>
		</tr>
		</table>
		
		<div style="height:50px"><spacer /></div>
		
		<table width="100%" bgcolor="f3f3f3" border="0" cellpadding="5" cellspacing="0">
			<tr valign="middle">
				<td>
				<div style="height:15px">&nbsp;</div>	
				</td>
			</tr>
		</table>		

		<!-- content -->
		<table border="0" cellpadding="0" cellspacing="0" height="200" align="center" width="650">
		<tr>
			<td valign="top">

				<div style="height:20px">&nbsp;</div>
				<h3>
				Дорогой друг!
				</h3>
				<p align="justify">
				Пожалуйста, обрати внимание: после того, как ты подтвердишь завершение опроса, 
				нажав кнопку "Закончить опрос",
				анкета станет недоступной для изменения.
				</p>
				
				<div style="height:15px">&nbsp;</div>
				
		
				

				
			</td>
		</tr>
		</table>
		
<cfoutput>		
<table width="100%" bgcolor="f3f3f3" border="0" cellpadding="5" cellspacing="0">
<tr valign="middle">
<td>

<table border="0" cellpadding="5" cellspacing="0" align="center">
	<tr valign="middle">
		<td><img name="prev" src="img/btn_prev.gif" style="cursor:pointer;" title="Назад" width="84" height="18" border="0" onClick="document.location.href='index.cfm?target_id=13';"></td>
		<td><img name="end" src="img/btn_end.gif" style="cursor:pointer;" title="Закончить опрос" width="124" height="18" border="0" onClick="document.location.href='#request.thisPage#?finish=yes';"></td>
	</tr>
</table>

</td>
	</tr>
</table>
</cfoutput>

		<!-- /content -->

	</td>
</tr>

</cfif>


<cfinclude template="inc/footer.cfm">