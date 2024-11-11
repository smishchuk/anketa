



<table cellpadding="20" cellspacing="0" border=0 width="100%">
<tr>
	<td>	
<div>
<div style="height:10px">&nbsp;</div>


<h3>
Дорогой друг!
</h3>

<p align="justify">
Ты принимаешь участие в процессе оценки методом «360 градусов». Этот опрос поможет твоему коллеге (оцениваемому) лучше понять свои сильные и слабые стороны и увидеть потенциал дальнейшего роста и развития. 
</p>
<p align="justify">
Мы гарантируем анонимность и конфиденциальность. В связи с этим просим тебя давать максимально правдивые, откровенные и обдуманные ответы. Если по характеру взаимодействия с этим человеком ты не видишь проявления некоторых аспектов поведения и не можешь судить о том, как он проявляет себя в описываемых ситуациях, пожалуйста, выбирай ответ: «Не могу оценить». 
</p>
<p align="justify">
Наш опросник содержит несколько вопросов, ответы на которые позволят нам оценить достоверность результата; в случае низкой достоверности опросный лист придется заполнять заново. 
Опрос занимает в среднем от 30 до 45 минут. Рекомендуем тебе заполнить анкету сразу же от начала до конца, не отвлекаясь. Так ты сможешь сэкономить время и повысить достоверность результатов. 
</p>

<cfquery name="qTargetUsr" datasource="#request.DS#">
	select r.target_usr_id, u.shortname from response r join usr u on (r.target_usr_id=u.usr_id)
	where respondent_id=<cfqueryparam cfsqltype="cf_sql_integer" value='#request.respondent_id#'/> AND r.dt_completed is null
</cfquery>
Пожалуйста, выбери оцениваемого сотрудника:
<cfmodule template="../mod/combo.cfm" query=#qTargetUsr# combo="target_usr_id" id="target_usr_id" key="target_usr_id" selected="#request.target_usr_id#"
			displayf="##shortname##" 
			class=""/>

</td>
</tr>
</table>


<table width="100%" bgcolor="f3f3f3" border="0" cellpadding="5" cellspacing="0">
<tr valign="middle">
<td>

<table border="0" cellpadding="5" cellspacing="0" align="center">
	<tr valign="middle"><!--- *** прибито гвоздями--->
		<td><cfoutput><img name="start" src="img/btn_start.gif" style="cursor:pointer;" title="Начать опрос" width="112" height="18" border="0" onClick="saveAndGo(13);"></cfoutput></td>
	</tr>
</table>

</td>
	</tr>
</table>
</div>