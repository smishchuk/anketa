<cfparam name="attributes.question_id" type="numeric">
<cfparam name="attributes.extensible" type="boolean" default="Yes">
<cfparam name="attributes.action" type="string" default="display">

<cfif ATTRIBUTES.action EQ "save" AND NOT request.readonly>

	<cfquery name="qChoice" datasource="#request.DS#">
	select choice_id from choice c join question q on (c.enumeration_id=q.enumeration_id) 
	where q.question_id='#attributes.question_id#' 
	union all 
	select choice_id from choice c where enumeration_id=7
	</cfquery>
	<cfset choiceList="">	
	<cfloop query="qChoice">
		<cfset choiceList=listAppend(choiceList, qChoice.choice_id)>
	</cfloop>
		
	<cfquery name="qClear" datasource="#request.DS#">
	delete from answer where question_id='#attributes.question_id#' AND response_id='#request.response_id#'
	</cfquery>
	
	<!--- save predefined choice --->	
	<cfset i=0>
	<cfloop index="id" list=#choiceList#>
		<cfset i=i+1>
		
		<cfif isDefined("id_#id#")>
			<cfset choice_id=evaluate("id_#id#")><!--- избыточно --->
		<cfelse>
			<cfset choice_id="">
		</cfif>
		
		<cfif isDefined("comment_#id#")>
			<cfset comment=evaluate("comment_#id#")>
		<cfelse>
			<cfset comment="">
		</cfif>
		
		<cfif isNumeric(choice_id)>
		<!--- <cftry> --->
		<cfquery name="qIns" datasource="#request.DS#">
		insert into answer(question_id, response_id, choice_id, ord, answer_text)  
		values('#attributes.question_id#','#request.response_id#','#id#', '#i#', '#comment#')
		</cfquery>
		<!--- <cfcatch type="ANY"> </cfcatch></cftry> --->		
		</cfif>
		
	</cfloop>	
	
	<cfset choices_count=i>
	
	<cfparam name="fieldcount" type="numeric" default="0">
	<cfloop index="i" from=1 to=#fieldcount#>
		<cfset answer_field="field_#i#">
		<cfif isDefined(answer_field)>
			<cfset answer=evaluate(answer_field)>
			<cfset ord = choices_count + i>
			<cfif len(answer) GT 0>
				<cftry>
				<cfquery name="qIns" datasource="#request.DS#">
				insert into answer(question_id, response_id, answer_text, ord)  
				values('#attributes.question_id#','#request.response_id#','#answer#', '#ord#')
				</cfquery>
				<cfcatch type="ANY"><!--- *** ---></cfcatch></cftry>		
			</cfif>
		</cfif>
	
	</cfloop>	

<cfelseif ATTRIBUTES.action EQ "display"><!--- display --->
	<cfinclude template="../inc/btn.cfm">	
	<cfmodule template="../mod/display_question.cfm" question_id=#attributes.question_id#>
	
	<cfquery name="qChoice" datasource="#request.DS#">
	select c.choice, c.choice_id, c.ord, a.choice_id as selected_choice_id, c.commented, a.answer_text 
	from question q join choice c on (c.enumeration_id=q.enumeration_id)
	left outer join answer a on (a.choice_id=c.choice_id AND q.question_id=a.question_id AND a.response_id='#request.response_id#')
	where 
	q.question_id='#attributes.question_id#' 
	
	order by c.ord
	</cfquery>
	
	<cfquery name="qQuestion" datasource="#request.DS#">
	select q.question_id, q.title, c.choice_id, c.choice, a.choice_id as selected_choice_id from question q1
	join question q on q.parent_id=q1.question_id
	join choice c on (c.enumeration_id=7 /* *** */ AND (c.choice)=q.title)
	left outer join answer a on (a.choice_id=c.choice_id AND a.question_id='#request.question_id#' AND a.response_id='#request.response_id#')
	where not (q1.question_id in (
		select q2.question_id
		from question q2 
		join answer a2 on (a2.question_id=1 /* *** */AND a2.response_id='#request.response_id#')
		join choice c2 on (c2.choice_id=a2.choice_id AND (c2.choice)=q2.title)
		where q2.parent_id='2')
	) AND q1.parent_id='2'
	 order by q1.ord
	</cfquery>
		
	
	<cfquery name="qExt" datasource="#request.DS#">
	select a.answer_id, a.choice_id, a.answer_text, a.ord 
	from question q join answer a on (a.question_id=q.question_id AND a.response_id='#request.response_id#')
	where q.question_id='#attributes.question_id#' and length(answer_text)>0
	order by a.ord
	</cfquery>

	<cfset choiceList="">	
	<cfloop query="qChoice">
		<cfset choiceList=listAppend(choiceList, qChoice.choice_id)>
	</cfloop>
	
	<cfset extList="">	
	<cfloop query="qExt">
		<cfset extList=listAppend(extList, qExt.answer_id)>
	</cfloop>
	
	
	<div style="height:10px"><spacer /></div>

<table cellpadding="20" cellspacing="0" border=0 width="100%">
<tr>
	<td>		
	
	<table border="0" cellpadding="0" cellspacing="0" class="voteNum">

	<cfoutput query="qChoice">	
		<tr style="height:43px">
			<td width="6%" class="off" valign="middle">
				<!--- <input type="checkbox" name="choice_id_#choice_id#" value="#choice_id#"
				<cfif isNumeric(selected_choice_id)> checked="1"</cfif> 
				<cfif request.readonly> disabled="1"</cfif> /> --->
				<cfif isNumeric(selected_choice_id)>
					<cfset on_off="on">
					<cfset val="1">
				<cfelse>
					<cfset on_off="off">
					<cfset val="">
				</cfif>

				<input type="hidden" id="id_#choice_id#" name="id_#choice_id#" value="#val#" />
				<span class="voteCbox" <cfif NOT request.readonly>onclick="setCbox(this)"</cfif> rel="id_#choice_id#" type="#on_off#" value="1"><img border="0" src="img/cbox_#on_off#.gif" align="absmiddle" width="18" height="18" /></span>

			</td>
			<td width="47%" class="off">#choice#</td>
			<td width="47%" class="off">
			<cfif qChoice.commented GT 0>
				<textarea  cols="90" rows="2" name="comment_#choice_id#" style="font-size:100%" <cfif request.readonly> disabled="1"</cfif>>#answer_text#</textarea>
			</cfif>			
			</td>
		</tr>		
	</cfoutput>
	<cfoutput query="qQuestion">	
		<tr style="height:43px">
			<td width="6%" class="off" valign="middle">
				<!--- <input type="checkbox" name="choice_id_#choice_id#" value="#choice_id#"
				<cfif isNumeric(selected_choice_id)> checked="1"</cfif> 
				<cfif request.readonly> disabled="1"</cfif> /> --->
				<cfif isNumeric(selected_choice_id)>
					<cfset on_off="on">
					<cfset val="1">
				<cfelse>
					<cfset on_off="off">
					<cfset val="">
				</cfif>

				<input type="hidden" id="id_#choice_id#" name="id_#choice_id#" value="#val#" />
				<span class="voteCbox" <cfif NOT request.readonly>onclick="setCbox(this)"</cfif> rel="id_#choice_id#" type="#on_off#" value="1"><img border="0" src="img/cbox_#on_off#.gif" align="absmiddle" width="18" height="18" /></span>
			</td>
			<td width="47%" class="off">#choice#</td>
			<td width="47%" class="off">
			<cfif qChoice.commented GT 0>
				<textarea  cols="90" rows="2" name="comment_#choice_id#" style="font-size:100%" <cfif request.readonly> disabled="1"</cfif>>#answer_text#</textarea>
			</cfif>			
			</td>
		</tr>		
	</cfoutput>
	</table>
	
	<cfif ATTRIBUTES.extensible>
	
	
	<div style="height:10px"><spacer /></div>
	<div class="freeText"><b>Ваш вариант:</b></div>
	<div style="height:10px"><spacer /></div>
	
		<cfset fieldcount = qExt.recordCount + 1>
		<cfoutput>
		<input type="hidden" id="fieldcount" name="fieldcount" value="#fieldcount#" />
		</cfoutput>
		
		<div id="fields3" style="border-bottom:1px solid #d3d3d3">	
		<table border="0" cellpadding="0" cellspacing="0" class="voteNumTbl" style="width:100%">
		<cfset i=1>
		<cfoutput query="qExt">		
		<tr>
			<td width="100%" class="off"><input type="text" id="num_#i#_text" name="field_#i#" value="#answer_text#" style="width:100%"
			<cfif request.readonly> disabled="1"</cfif> /></td>
		</tr>
		<cfset i=i+1>
		</cfoutput>		
		
		<cfoutput>
		<tr>
			<td width="100%" class="off"><input type="text" id="num_#i#_text" name="field_#i#" value="" onkeydown="addField3(#i#)" style="width:100%" <cfif request.readonly> disabled="1"</cfif> /></td>
		</tr>
		</table>
		</cfoutput>
		</div>
	
	
	<cfscript>
	function escapeQuotes(s) {
		return replace(s,'"','&quot;',"ALL"); 
	}
	</cfscript>
	
	
	
	</cfif>
	
</td>
</tr>
</table>
	

	
	<cfinclude template="../inc/btn.cfm">

</cfif>