<cfparam name="ATTRIBUTES.question_id" type="numeric">
<cfparam name="ATTRIBUTES.root_question_id" type="numeric" default=#attributes.question_id#>
<cfparam name="ATTRIBUTES.action" type="string" default="display">

<cfset request.question_id=#ATTRIBUTES.question_id#>
<cfset showSubgroups="Yes">

<cfquery name="qQuestion" datasource="#request.DS#">
select question_id, question_type, template from question where question_id='#ATTRIBUTES.question_id#'
</cfquery>

<!--- для группы находим первый вопрос с учетом фильтра --->
<cfif qQuestion.question_type EQ "group" AND qQuestion.template EQ ""><!--- *** классификацию на основе типа и шаблона можно признать неудачной --->
	<cfquery name="qSubgroup" datasource="#request.DS#" maxrows=1>
		select q.question_id 
		from question q 
		join answer a on (a.question_id=1 /* *** */AND a.response_id='#request.response_id#')
		join choice c on (c.choice_id=a.choice_id AND (c.choice)=q.title)
		where q.parent_id='#ATTRIBUTES.root_question_id#' order by q.ord
	</cfquery>
			
	<cfif qSubgroup.recordCount GT 0>
		<cfset ATTRIBUTES.question_id=qSubgroup.question_id>
		<cfset request.question_id=qSubgroup.question_id>
	<cfelse>
		<cfset showSubgroups="No">
	</cfif>		
	
</cfif>


<cfif ATTRIBUTES.action EQ "save" AND NOT request.readonly>
	
	<cfquery name="qQuestions" datasource="#request.DS#">
	select question_id from question where parent_id='#ATTRIBUTES.question_id#' 
	</cfquery>
	
	<cfset questionList="">
	<cfloop query="qQuestions">
		<cfset questionList=listAppend(questionList, qQuestions.question_id)>
	</cfloop>	
	
	<cfquery name="qClear" datasource="#request.DS#">
		delete from answer where question_id='#ATTRIBUTES.question_id#' AND response_id='#request.response_id#'
	</cfquery>
		
	<cfloop index="id" list=#questionList#>
		<cfquery name="qClear" datasource="#request.DS#">
		delete from answer where question_id='#id#' AND response_id='#request.response_id#'
		</cfquery>
	</cfloop>
	
	<cfparam name="choice_other" type="string" default="">
	<cfparam name="text_other" type="string" default="">
	<cfif len(text_other) GT 0>
		<cfquery name="qIns" datasource="#request.DS#">
		insert into answer(question_id, response_id, answer_text, choice_id)  
		values('#ATTRIBUTES.question_id#','#request.response_id#','#text_other#', 
		<cfif isNumeric(choice_other)>'#choice_other#'<cfelse>null</cfif>
		)
		</cfquery>
	</cfif>
	
	<cfloop index="id" list=#questionList#>
		<cfset fieldName="choice_#id#">
		<cfif isDefined(fieldName)>
			<cfset field=(evaluate(fieldName))>
			<cfif isNumeric(field)>
				<cfquery name="qIns" datasource="#request.DS#">
				insert into answer(question_id, response_id, choice_id)  
				values('#id#','#request.response_id#','#field#')
				</cfquery>
			</cfif>
		</cfif>
	</cfloop>

<cfelseif ATTRIBUTES.action EQ "display"><!--- display --->


<cfset question_id=ATTRIBUTES.question_id>


<cfif showSubgroups>


<cfinclude template="../inc/btn.cfm">	

<!--- отображаем вопрос корневой группы --->
<cfmodule template="../mod/display_question.cfm" question_id=#attributes.root_question_id#>

<!--- *** повторный селект --->
<cfquery name="qQuestion" datasource="#request.DS#">
select * from question where question_id='#ATTRIBUTES.question_id#'
</cfquery>


<cfquery name="qGroup" datasource="#request.DS#">
select * from question where question_id='#ATTRIBUTES.question_id#'
</cfquery> 


<cfquery name="qRootGroup" datasource="#request.DS#">
select q.title, q.question_id, q.enumeration_id, a.answer_id, c.choice from question q 
join answer a on (a.question_id=1 /* *** */AND a.response_id='#request.response_id#')
join choice c on (c.choice_id=a.choice_id AND (c.choice)=q.title)
where q.parent_id='#ATTRIBUTES.root_question_id#'
</cfquery>

<cfif qQuestion.template NEQ "group_of_questions">
	<cfoutput query=qRootGroup maxrows=1>
		<cfset question_id=qRootGroup.question_id>
	</cfoutput>
</cfif>




<cfquery name="qQuestions" datasource="#request.DS#">
select q.title, q.annonce, q.question_id, q.enumeration_id, a.choice_id from question q 
left outer join answer a on (a.question_id=q.question_id AND a.response_id='#request.response_id#')
where parent_id='#ATTRIBUTES.question_id#'
order by a.ord
</cfquery>

<cfquery name="qOther" datasource="#request.DS#">
select a.answer_id, a.answer_text, a.choice_id from answer a
where a.question_id='#ATTRIBUTES.question_id#'
</cfquery>

<cfquery name="qChoice" datasource="#request.DS#">
select * from choice where enumeration_id='#qQuestions.enumeration_id#'
</cfquery>

<div align="center">
<cfoutput query="qRootGroup">
	<cfset fill=structFind(request.fill,#qRootGroup.question_id#)>
	<cfif #qRootGroup.question_id# EQ #request.question_id#>
		<cfset class = "bcQGroupSel">
	<cfelseif fill EQ 0>
		<cfset class = "bcQGroupOff">
	<cfelseif fill EQ 1>
		<cfset class = "bcQGroupOff">	
	<cfelseif fill EQ 2>
		<cfset class = "bcQGroupOn">
	</cfif>
	&nbsp;<img src="img/arrow.gif" border="0" >&nbsp;<a href="javascript:saveAndGo(#question_id#);" 
	class="#class#">#title#</a>&nbsp; 
</cfoutput>
</div>



<div align="center">

<table cellpadding="20" cellspacing="0" border=0>
<tr>
	<td>


<table cellpadding="0" cellspacing="0" width="100%" border=0 class="tableQGroup">
<tr>
<cfoutput>
<td bgcolor="f3f3f3" rowspan="2" width="15%">Компетенция</td>
<td bgcolor="e9e9e9" rowspan="2" width="30%">Индикаторы</td>
<td bgcolor="dddddd" colspan="#qChoice.recordCount#" align="center"></td>
</cfoutput>
</tr>

<tr bgcolor="f3f3f3">
<cfset choiceList="">
<cfoutput query="qChoice">
	<cfset choiceList=listAppend(choiceList, #qChoice.choice_id#)>
	<td align="center">#choice#</td>
	</cfoutput>
</tr>


<!--- список надо привязывать  --->

<cfoutput query="qQuestions">
	<tr id="choice_#qQuestions.question_id#_group">
	<cfset rowspan=qQuestions.recordCount+1>
	<cfif qQuestions.currentRow EQ 1><td width="15%" rowspan="#rowspan#"><b>#qGroup.title#</b></td></cfif>
	<td class="subquest"><cfif len(qQuestions.title)>#qQuestions.title#<cfelseif len(qQuestions.annonce)>#qQuestions.annonce#<cfelse>#qQuestions.descr#</cfif>
	<input type="hidden" id="choice_#qQuestions.question_id#" name="choice_#qQuestions.question_id#" value="#qQuestions.choice_id#" />
	</td>
	<cfloop index="id" list=#choiceList#>
	<td class="subquest" align="center">
	<cfif id EQ qQuestions.choice_id>
		<cfset on_off = "on">
	<cfelse>
		<cfset on_off = "off">
	</cfif> 	
	<span <cfif NOT request.readonly>onclick="setRadio(this)"</cfif> rel="choice_#qQuestions.question_id#" type="#on_off#" value="#id#"><img border="0" src="img/radio_#on_off#.gif" style="cursor: pointer;" align="absmiddle" width="18" height="18" />
	</span>
	</td>
	</cfloop>
	</tr>	
</cfoutput>

<!---
<cfoutput>
<tr id="choice_other_group">
<td class="subquest">
<i>Другое:</i>&nbsp;&nbsp;&nbsp;<textarea  cols="90" rows="2" name="text_other" <!--- onkeydown="addField(#cnt#)" ---> style="font-size:100%"
<cfif request.readonly> disabled="1"</cfif>>#qOther.answer_text#</textarea>
<input type="hidden" id="choice_other" name="choice_other" value="#qOther.choice_id#" />
</td>
<cfloop index="id" list=#choiceList#>
<td class="subquest" align="center">
	<cfif id EQ qOther.choice_id>
		<cfset on_off = "on">
	<cfelse>
		<cfset on_off = "off">
	</cfif> 	
	<span <cfif NOT request.readonly>onclick="setRadio(this)"</cfif> rel="choice_other" type="#on_off#" value="#id#"><img border="0" src="img/radio_#on_off#.gif" style="cursor: pointer;" align="absmiddle" width="18" height="18" />
	</span>
	</td>
</cfloop>	
</tr>
</cfoutput>
--->
</table>

</td>
</tr>
</table>

<cfelse>
<cfinclude template="../inc/btn.cfm">	


<br><br>
<div style="height:15px"><spacer /></div>
<table align="center" height="200">
<tr>
	<td>	
<div align="center"><b class="freeTextRed">Пожалуйста, выберите один или более критериев в вопросе 1</b></div>

<div style="height:15px"><spacer /></div>
	</td>
</tr>
</table>
</cfif>


<cfinclude template="../inc/btn.cfm">

</div>



</cfif>