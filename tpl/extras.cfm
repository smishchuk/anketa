<cfparam name="ATTRIBUTES.question_id" type="numeric">
<cfparam name="ATTRIBUTES.root_question_id" type="numeric" default=#attributes.question_id#>
<cfparam name="ATTRIBUTES.action" type="string" default="display">

<cfif ATTRIBUTES.action EQ "save" AND NOT request.readonly>
	
	<cfquery name="qAnswers" datasource="#request.DS#">
	select answer_id from answer where question_id='#ATTRIBUTES.question_id#' AND response_id='#request.response_id#'
	</cfquery>
	
	<cfset answerList="">
	
	<cfloop query="qAnswers">
		<cfset answerList=listAppend(answerList, qAnswers.answer_id)>
	</cfloop>
	
	<cfquery name="qClear" datasource="#request.DS#">
	delete from answer where question_id='#ATTRIBUTES.question_id#' AND response_id='#request.response_id#'
	</cfquery>

	<cfloop index="id" list=#answerList#>		
		<cfset fieldName="field_#id#">
		<cfset choiceName="choice_#id#">		
		<cfif isDefined(fieldName) and isDefined(choiceName)>
			<cfset field=(evaluate(fieldName))>
			<cfset choice_id=(evaluate(choiceName))>			
			<cfif isNumeric(choice_id) AND len(field) GT 0>
				<cfquery name="qIns" datasource="#request.DS#">
				insert into answer(question_id, response_id, answer_text, choice_id)  
				values('#ATTRIBUTES.question_id#','#request.response_id#','#field#','#choice_id#')
				</cfquery>
			</cfif>
		</cfif>
	</cfloop>
	
	<cfparam name="rowcount" type="numeric" default="-1">
	<cfloop index="i" from=0 to=#rowcount#>
		<cfset fieldName="field_#i#">
		<cfset choiceName="choice_extra_#i#">
		<cfif isDefined(fieldName) and isDefined(choiceName)>
			<cfset field=(evaluate(fieldName))>
			<cfset choice_id=(evaluate(choiceName))>			
			<cfif isNumeric(choice_id) AND len(field) GT 0>
				<cfquery name="qIns" datasource="#request.DS#">
				insert into answer(question_id, response_id, answer_text, choice_id)  
				values('#ATTRIBUTES.question_id#','#request.response_id#','#field#','#choice_id#')
				</cfquery>
			</cfif>
		</cfif>
	
	</cfloop>

<cfelseif ATTRIBUTES.action EQ "display"><!--- display --->


<cfset question_id=attributes.question_id>
<!--- отображаем вопрос корневой группы --->
<cfmodule template="../mod/display_question.cfm" question_id=#attributes.root_question_id#>

<!--- *** повторный селект --->
<cfquery name="qQuestion" datasource="#request.DS#">
select * from question where question_id='#ATTRIBUTES.question_id#' 
</cfquery>

<!--- если у нас группа групп, надо взять первую подргуппу --->
<!--- это некорректное решение, работает только для 2-уровенвых групп --->
<cfif qQuestion.template NEQ "group_of_questions">
	<cfquery name="qSubgroup" datasource="#request.DS#">
		select top 1 question_id from question where parent_id='#ATTRIBUTES.question_id#' order by ord
	</cfquery>
	<cfset question_id=qSubgroup.question_id>
</cfif>


<cfquery name="qGroup" datasource="#request.DS#">
select * from question where question_id='#ATTRIBUTES.question_id#'
</cfquery>

<cfquery name="qRootGroup" datasource="#request.DS#">
select title, question_id from question where parent_id='#ATTRIBUTES.root_question_id#'
</cfquery>

<cfquery name="qAnswers" datasource="#request.DS#">
select  a.answer_id, a.question_id, a.choice_id, a.answer_text from answer a
where a.question_id='#ATTRIBUTES.question_id#' AND a.response_id='#request.response_id#'
</cfquery>

<cfquery name="qChoice" datasource="#request.DS#">
select choice_id, choice from choice c join question q on (c.enumeration_id=q.enumeration_id)
where q.question_id='#ATTRIBUTES.question_id#'
</cfquery>

<cfset choiceList="">
<cfloop query="qChoice">
	<cfset choiceList=listAppend(choiceList, #qChoice.choice_id#)>
</cfloop>

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

<div style="height:15px"><spacer /></div>

<cfoutput>
<script language="javascript">
var _rowCount = 1;
function addRow(_num){
	var _numNew = _num + 1;
	if(!$("row" + _numNew)){
		var _fieldDiv = document.createElement('div');
		_fieldDiv.setAttribute("id", "row" + _numNew);
		_fieldDiv.setAttribute("style", "margin:0;");
		$("rows").appendChild(_fieldDiv);
		//alert($("rows").innerHTML);
		var rowHtml='<table cellpadding="0" cellspacing="0" width="100%"  border="0" class="tableQGroup" id="choice_extra_' + _numNew + '_group">';
		rowHtml += '<tr><td width="15%">&nbsp;</td><td class="subquest">';
		rowHtml += '<textarea cols="90" ros="2" name="field_' + _numNew + '" onkeydown="addRow(' + _numNew + ')"  style="font-size:100%;"></textarea>';		
		rowHtml += '<input type="hidden" id="choice_extra_' + _numNew + '" name="choice_extra_' + _numNew + '" value="" />';
		rowHtml += '</td>';
		
		<cfloop index="id" list=#choiceList#>
		rowHtml += '<td width="12%" class="subquest" align="center">';
		rowHtml += '<span onclick="setRadio(this)" rel="choice_extra_' + _numNew + '" type="off" value="#id#">';
		rowHtml += '<img border="0" src="img/radio_off.gif" align="absmiddle" width="16" height="16" />';
		rowHtml += '</span>';
		rowHtml += '</td>';
		</cfloop>		
		
		rowHtml += '</tr></table>';
		$("row" + _numNew).innerHTML = rowHtml;
		_rowCount++;
		$("rowcount").value = _rowCount;
	}
}
</script>
</cfoutput>
<cfinclude template="../inc/btn.cfm">	
<table cellpadding="0" cellspacing="0" width="100%" border=0 class="tableQGroup">
<tr>
<cfoutput>
<td bgcolor="f3f3f3" rowspan="2">Критерии</td>
<td bgcolor="e9e9e9" rowspan="2">Проблемы</td>
<td bgcolor="dddddd" colspan="#qChoice.recordCount#" align="center">Вероятность того, что данная проблема окажется важной в 2020 г.</td>
</cfoutput>
</tr>

<tr bgcolor="f3f3f3">
<cfoutput query="qChoice">
	<td width="12%" align="center"><b>#choice#</b></td>
</cfoutput>
</tr>

<cfoutput query="qAnswers">
	<tr id="choice_#qAnswers.answer_id#_group">
	<cfset rowspan=qAnswers.recordCount + 1 >
	<cfif qAnswers.currentRow EQ 1><td width="15%" rowspan="#rowspan#"><b>Другое</b></td></cfif>
	<td class="subquest">
		<textarea  cols="90" rows="2" name="field_#qAnswers.answer_id#" style="font-size:100%;"
		<cfif request.readonly> disabled="1"</cfif>>#answer_text#</textarea></span>
		<input type="hidden" id="choice_#qAnswers.answer_id#" name="choice_#qAnswers.answer_id#" value="#qAnswers.choice_id#" />
	</td>
	<cfloop index="id" list=#choiceList#>
	<td class="subquest" align="center">
	<cfif id EQ qAnswers.choice_id>
		<cfset on_off = "on">
	<cfelse>
		<cfset on_off = "off">
	</cfif> 	
	<span <cfif NOT request.readonly>onclick="setRadio(this)"</cfif> rel="choice_#qAnswers.answer_id#" type="#on_off#" value="#id#">
		<img border="0" src="img/radio_#on_off#.gif" align="absmiddle" width="16" height="16" />
	</span>
	</td>
	</cfloop>
	</tr>
</cfoutput>


<cfoutput>
	<tr id="choice_extra_0_group">
	<cfif qAnswers.recordCount EQ 0><td width="15%"><b>Другое</b></td></cfif>
	<td class="subquest">
		<textarea  cols="90" rows="2" name="field_0" onkeydown="addRow(1)" style="font-size:100%;"></textarea>
		<input type="hidden" id="choice_extra_0" name="choice_extra_0" value="" />
	</td>
	<cfloop index="id" list=#choiceList#>
	<td class="subquest" align="center">
	<span onclick="setRadio(this)" rel="choice_extra_0" type="off" value="#id#">
		<img border="0" src="img/radio_off.gif" align="absmiddle" width="16" height="16" />
	</span>
	</td>
	</cfloop>
	</tr>
</cfoutput>

</table>
<div id="rows" style="margin:0;"></div>
<input type="hidden" name="rowcount" name="rowcount" value="0"/> 

<br><br>


<cfinclude template="../inc/btn.cfm">

</div>



</cfif>