<cfparam name="attributes.question_id" type="numeric">
<cfparam name="attributes.action" type="string" default="display">

<cfif ATTRIBUTES.action EQ "save" AND NOT request.readonly>
	
	<cfparam name="answer_number" type="string" default="">	
	<cfif isNumeric(answer_number)>
		<cfif answer_number GT 100><cfset answer_number=100></cfif>
		<cfif answer_number LT 0><cfset answer_number=0></cfif>
	</cfif>	
	<cfset answer_number = trim(answer_number)>
	
	<cfquery name="qAnswer" datasource="#request.DS#">
	select a.answer_id from answer a where a.question_id='#attributes.question_id#' AND a.response_id='#request.response_id#'
	</cfquery>
		
	<cfif qAnswer.answer_id GT 0>
		<cfif len(answer_number) GT 0 AND isNumeric(answer_number)>
			<cfquery name="qUpdate" datasource="#request.DS#">
			update answer set answer_number='#answer_number#' where response_id='#request.response_id#' AND question_id='#attributes.question_id#'
			</cfquery> 
		<cfelse> 
			<cfquery name="qDelete" datasource="#request.DS#">
			delete from answer where response_id='#request.response_id#' AND question_id='#attributes.question_id#'
			</cfquery> 
			<cfset answer_id=-1>
		</cfif>
	<cfelseif len(answer_number) GT 0 AND isNumeric(answer_number)>
	<!--- *** защита от нарушения ключа --->
	<!--- *** добавить ключ --->
		<cfquery name="qInsert" datasource="#request.DS#">
		insert into answer(response_id, question_id, answer_number)
		values('#request.response_id#', '#attributes.question_id#', '#answer_number#')
		</cfquery>
		
		<cfquery name="qId" datasource="#request.DS#">
		select @@identity as id
		</cfquery>
		
		<cfset answer_id=qId.id>
	</cfif>

<cfelseif ATTRIBUTES.action EQ "display">

	<cfinclude template="../inc/btn.cfm">	
	<cfmodule template="../mod/display_question.cfm" question_id=#attributes.question_id#>
	<div style="height:10px"><spacer /></div>
	<cfquery name="qAnswer" datasource="#request.DS#">
	select a.answer_number from answer a where a.question_id='#attributes.question_id#' AND a.response_id='#request.response_id#'
	</cfquery>
	
	<cfif qAnswer.recordCount EQ 0>
		<cfscript>
		queryAddRow(qAnswer);
		querySetCell(qAnswer,"answer_number", "");
		</cfscript>
	</cfif>
<table align="center" height="200">
<tr>
	<td>	
	<!--- *** может быть пробелма с приведением типа --->
	<cfoutput query="qAnswer" maxrows="1">
	<div align="center">
	<!--- *** контроль ввода --->
	<input type="text" name="answer_number" value="#answer_number#" size="5" maxlength="3" 
	<cfif request.readonly> disabled="1"</cfif>>&nbsp;<b>%</b>
	</div>
	</cfoutput>
	</td>
</tr>
</table>

	<br><br>
	

	
	<cfinclude template="../inc/btn.cfm">

</cfif>