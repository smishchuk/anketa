<cfparam name="attributes.question_id" type="numeric">
<cfparam name="attributes.action" type="string" default="display">

<cfif ATTRIBUTES.action EQ "save" AND NOT request.readonly>
	<!--- *** проверять trim! --->
	<cfparam name="answer_id" type="numeric" default="-1">
	<cfparam name="answer_text" type="string" default=""><!--- *** trim дает ошибку --->
	
	<cfif answer_id GT 0>
		<cfif len(answer_text) GT 0>
			<cfquery name="qUpdate" datasource="#request.DS#">
			update answer set answer_text=ltrim(rtrim('#answer_text#')) where answer_id='#answer_id#' 
			AND response_id='#request.response_id#' AND question_id='#request.question_id#'
			</cfquery> 
		<cfelse>
			<cfquery name="qDelete" datasource="#request.DS#">
			delete from answer where answer_id='#answer_id#' 
			AND response_id='#request.response_id#' AND question_id='#request.question_id#'
			</cfquery> 
			<cfset answer_id=-1>
		</cfif>
	<cfelseif len(answer_text) GT 0>
	<!--- *** защита от нарушения ключа --->
	<!--- *** добавить ключ --->
		<cfquery name="qInsert" datasource="#request.DS#">
		insert into answer(response_id, question_id, answer_text)
		values('#request.response_id#', '#request.question_id#', ltrim(rtrim('#answer_text#')))
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
	<cfquery name="qRead" datasource="#request.DS#">
	select answer_id, answer_text from answer where question_id='#attributes.question_id#' 
	AND response_id='#request.response_id#'
	</cfquery>
		
	<cfif qRead.recordCount EQ 0>
		<cfscript>
		queryAddRow(qRead);
		querySetCell(qRead,"answer_id", -1);
		querySetCell(qRead,"answer_text", "");
		</cfscript>
	</cfif>


<table align="center" height="200">
<tr>
	<td>		
	<cfoutput query="qRead" maxrows="1">
	<div align="center">
	
	<input type="hidden" name="answer_id" value="#answer_id#">
	<textarea name="answer_text" rows="7" cols="70"<cfif request.readonly> disabled="1"</cfif>>#answer_text#</textarea>
	
	</div>
	</cfoutput>
	
	 </td>
</tr>
</table>	
	
<br><br>



<cfinclude template="../inc/btn.cfm">

</cfif> <!--- ATTRIBUTES.action EQ "save" --->