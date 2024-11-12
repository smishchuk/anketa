<!--- конструируем навигационный массив вопросов --->
<cfparam name="ATTRIBUTES.parent_id" type="numeric" default="-1">
<cfparam name="ATTRIBUTES.questions" type="struct">
<cfparam name="ATTRIBUTES.setFilter" type="boolean" default="No">

<cfif ATTRIBUTES.setFilter>
	<cfquery name="qRead" datasource="#request.DS#">
		select q.question_id, q.parent_id, q.question_type, q.template, q.ord 
		from question q 
		join answer a on (a.question_id=1 /* *** */AND a.response_id='#request.response_id#')
		join choice c on (c.choice_id=a.choice_id AND (c.choice)=q.title)
		where q.parent_id='#ATTRIBUTES.parent_id#' order by q.ord
	</cfquery>
	<cfif qRead.recordCount EQ 0>
		<cfset i=structCount(ATTRIBUTES.questions)+1>
		<cfset structInsert(ATTRIBUTES.questions, i, ATTRIBUTES.parent_id)>
	</cfif> 
<cfelse>
	<cfquery name="qRead" datasource="#request.DS#">
	select question_id, parent_id, question_type, template, ord from question 
	where <cfif ATTRIBUTES.parent_id GT 0> parent_id='#ATTRIBUTES.parent_id#' <cfelse> parent_id is null </cfif> order by ord
	</cfquery>
</cfif>


<cfloop query="qRead">
	<cfif qRead.question_type EQ "group" AND qRead.template NEQ "group_of_questions" AND qRead.template NEQ "group_of_extras">
		<cfmodule template="qlist.cfm" parent_id=#qRead.question_id# questions=#ATTRIBUTES.questions# setFilter="Yes">
	<cfelse> 
		<cfset i=structCount(ATTRIBUTES.questions)+1>
		<cfset structInsert(ATTRIBUTES.questions, i, qRead.question_id)>
	</cfif>	
</cfloop>



