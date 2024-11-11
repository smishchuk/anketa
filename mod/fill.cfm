<!--- проверяем заполнение --->
<cfset request.fill = structNew()>

<!--- верхний уровень 
<cfquery name="qRead" datasource="#request.DS#">
select q.question_id, case when count(a.answer_id) > 0 then 2 else 0 end as fill  
from question q left outer join answer a on (a.question_id=q.question_id AND a.response_id='#request.response_id#')
where parent_id is null
group by q.question_id
</cfquery>

<cfloop query="qRead">
	<cfset structInsert(request.fill,#question_id#,#fill#)>
</cfloop> --->

<!--- подгруппы --->
<cfquery name="qRead" datasource="#request.DS#">
select q.question_id, q.parent_id,
case 
when q.template = 'group_of_extras' then 2
when(count(a.answer_id) >= count(q1.question_id)) then 2 
when count(a.answer_id) > 0 then 1 
else 0 end as fill
from question q 
left outer join question q1 on (q1.parent_id=q.question_id)
left outer join answer a on (a.question_id=q1.question_id AND a.response_id='#request.response_id#')
where  (q1.template in ('group_of_questions', 'group_of_extras') OR q1.question_type='single_choice')
AND q.parent_id is null

group by q.question_id, q.parent_id, q.template
</cfquery>


<cfloop query="qRead">
	<cfset structInsert(request.fill, #question_id#,#fill#)>
</cfloop> 

<!---
<cfquery name="qGroup" datasource="#request.DS#">
select distinct q.question_id as group_id
from question q 
left join question q1 on (q1.parent_id=q.question_id)
where (q1.template in ('group_of_questions', 'group_of_extras') OR q1.question_type='single_choice') AND q.parent_id is null
</cfquery>


<cfquery name="qGroup2" datasource="#request.DS#">
select q.question_id as qroup_id, q1.question_id
from question q 
left join question q1 on (q1.parent_id=q.question_id)
where (q1.template in ('group_of_questions', 'group_of_extras') OR q1.question_type='single_choice') AND q.parent_id is null
</cfquery>


<cfloop query="qGroup">
	<cfif qGroup2.recordCount EQ 0>
		<cfset structUpdate(request.fill, qGroup.group_id, 2)>
		<cfset total_sum=0>
		<cfset i=0>
		<cfloop query="qGroup2">
			<cfif structKeyExists(request.fill, qGroup2.question_id)>
				<cfset i=i+1>
				<cfset total_sum=total_sum + structFind(request.fill, qGroup2.question_id)>	
			</cfif>
		</cfloop>

		<cfif total_sum EQ 0>
			<cfset total=0>
		<cfelseif total_sum GE i*2>
			<cfset total=2>
		<cfelse>
			<cfset total=1>
		</cfif>
		<cfoutput>#total_sum#</cfoutput>
		<cfset structUpdate(request.fill, qGroup.group_id, total)> 
	</cfif>
</cfloop>
--->


