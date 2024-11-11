<cfparam name="attributes.question_id" type="numeric">
<cfparam name="attributes.action" type="string" default="display">

<cfif ATTRIBUTES.action EQ "save" AND NOT request.readonly AND request.response_id GT 0>
	
	<cfparam name="choice_id" type="string" default="">	
		
	<cfquery name="qAnswer" datasource="#request.DS#">
	select a.answer_id from answer a where a.question_id='#attributes.question_id#' AND a.response_id='#request.response_id#'
	</cfquery>
		
	<cfif qAnswer.answer_id GT 0>
		<cfif isNumeric(choice_id)>
			<cfquery name="qUpdate" datasource="#request.DS#">
			update answer set choice_id='#choice_id#' where response_id='#request.response_id#' AND question_id='#attributes.question_id#'
			</cfquery> 
		<cfelse> 
			<cfquery name="qDelete" datasource="#request.DS#">
			delete from answer where response_id='#request.response_id#' AND question_id='#attributes.question_id#'
			</cfquery> 
			<cfset answer_id=-1>
		</cfif>
	<cfelseif isNumeric(choice_id)>
	<!--- *** защита от нарушения ключа --->
	<!--- *** добавить ключ --->
		<cfquery name="qInsert" datasource="#request.DS#">
		insert into answer(response_id, question_id, choice_id)
		values('#request.response_id#', '#attributes.question_id#', '#choice_id#')
		</cfquery>
		
		<cfquery name="qId" datasource="#request.DS#">
		select @@identity as id
		</cfquery>
		
		<cfset answer_id=qId.id>
	</cfif>

<cfelseif ATTRIBUTES.action EQ "display">

	<cfquery name="qAnswer" datasource="#request.DS#">
	select a.answer_id, c.choice, c.choice_id, a.choice_id as selected_choice_id 
	from question q join choice c on (c.enumeration_id=q.enumeration_id)
	left outer join answer a on (a.choice_id=c.choice_id AND a.response_id='#request.response_id#' AND a.question_id=q.question_id)
	where 
	q.question_id='#attributes.question_id#' 
	order by c.ord
	</cfquery>
	<cfquery name="qChoice" datasource="#request.DS#">
	select a.choice_id as selected_choice_id 
	from question q join answer a on (a.question_id=q.question_id)
	where q.question_id='#attributes.question_id#' AND a.response_id='#request.response_id#'
	</cfquery>
	
	<cfinclude template="../inc/btn.cfm">		
	<cfmodule template="../mod/display_question.cfm" question_id=#attributes.question_id#>
	
<table align="center" height="200">
<tr>
	<td>
	
	<div id="choice_id_group" class="voteRadio">
		<cfoutput><input type="hidden" id="choice_id" name="choice_id" value="#qChoice.selected_choice_id#" /></cfoutput>
		<cfoutput query="qAnswer">
			<cfif qAnswer.selected_choice_id GT 0>
				<cfset on_off = "on">
			<cfelse>
				<cfset on_off = "off">
			</cfif> 
			<span <cfif NOT request.readonly>onclick="setRadio(this)"</cfif> rel="choice_id" type="#on_off#" value="#choice_id#"><img border="0" src="img/radio_#on_off#.gif" align="absmiddle" width="18" height="18" />
				#choice#
			</span>
			<div style="height:7px"><spacer /></div>
		</cfoutput>	
	</div>
	
	</td>
</tr>
</table>
	
<br><br>




<cfinclude template="../inc/btn.cfm">

</cfif>