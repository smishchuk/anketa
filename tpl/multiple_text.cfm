<cfparam name="attributes.question_id" type="numeric">
<cfparam name="attributes.action" type="string" default="display">

<cfif ATTRIBUTES.action EQ "save" AND NOT request.readonly>

	<cfparam name="fieldcount" type="numeric" default="0">
	
	<cfquery name="qClear" datasource="#request.DS#">
	delete from answer where question_id='#attributes.question_id#' AND response_id='#request.response_id#'
	</cfquery>
	
	<cfloop index="i" from=0 to=#fieldcount#>
		<cfset fieldName="field_#i#"> 
		<cfif isDefined(fieldName)>
			<cfset field=replaceList(evaluate(fieldName),"<,>","&lt;,&gt;")>
			<cfif len(field) GT 0>
				<cfquery name="qIns" datasource="#request.DS#">
				insert into answer(question_id, response_id, answer_text)  
				values('#attributes.question_id#','#request.response_id#',ltrim(rtrim('#field#')))
				</cfquery>
			</cfif>
		</cfif>
	</cfloop>
	
<cfelseif ATTRIBUTES.action EQ "display">

	<cfinclude template="../inc/btn.cfm">	
	<cfmodule template="../mod/display_question.cfm" question_id=#attributes.question_id#>
	
	<cfquery name="qAnswer" datasource="#request.DS#">
	select a.answer_id, a.answer_text
	from question q join answer a on (a.question_id=q.question_id)
	where 
	q.question_id='#attributes.question_id#' AND a.response_id='#request.response_id#'
	order by a.ord
	</cfquery>
	
	
	<cfscript>
	function escapeQuotes(s) {
		return replace(s,'"','&quot;',"ALL"); 
	}
	</cfscript>
	
	<cfset cnt=0>
	
<div style="height:10px"><spacer /></div>
	
<table align="center" height="200">
<tr>
	<td>
	
		
	<div id="fields">
		<cfoutput query="qAnswer">
			<div id="field#cnt#">
			<textarea  cols="90" rows="2" name="field_#cnt#" onkeydown="addField(#cnt#)" <cfif request.readonly> disabled="1"</cfif>><!--- 
			 --->#escapeQuotes(answer_text)#<!--- 
			 ---></textarea>
			</div>
			<cfset cnt = cnt +1>
		</cfoutput>
	
		<cfoutput>
		<div id="field#cnt#">
		<textarea  cols="90" rows="2" name="field_#cnt#" onkeydown="addField(#cnt#)" <cfif request.readonly> disabled="1"</cfif>></textarea>
		</div>
		</cfoutput>
	</div>
	
	<cfoutput>
		<input type="hidden" id="fieldcount" name="fieldcount" value="#cnt#" />
	</cfoutput>
	
	</td>
</tr>
</table>	

	<br><br>
	

		
	<cfinclude template="../inc/btn.cfm">

</cfif>