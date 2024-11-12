<!--- <cfquery name=qSiblings datasource="#request.DS#">
select q.question_id, COALESCE(q.parent_id,0) as parent_id from question q 
join question q1 on (COALESCE(q1.parent_id,0)=COALESCE(q.parent_id,0))
where q1.question_id=#request.question_id#
order by q.ord
</cfquery> --->
<cfset fin=true/>
<cfloop collection=#request.fill# index="q">
	<cfif structFind(request.fill, q) NEQ 2>
		<cfset fin=false/>
		<cfbreak/>
	</cfif>
</cfloop>

<cfif #request.question_id# GT 13><!--- *** --->
	<cfquery name="qSiblings" datasource="#request.DS#">
	select q.question_id from question q 
	join answer a on (a.question_id=1 /* *** */AND a.response_id='#request.response_id#')
	join choice c on (c.choice_id=a.choice_id AND (c.choice)=q.title)
	where q.parent_id=2 /* *** */
	</cfquery>
<cfelse>
	<cfquery name=qSiblings datasource="#request.DS#">
	select q.question_id from question q where q.parent_id is null AND q.questionary_id='#request.questionary_id#' order by q.ord
	</cfquery>
</cfif>

<cfset next_id=0>
<cfset prev_id=0>

<cfset siblings="">
<cfloop query="qSiblings">
	<cfset siblings=listAppend(siblings,qSiblings.question_id)>
</cfloop>

<!--- <cfoutput>siblings=#siblings#</cfoutput> --->

<cfset currentPos=listFind(siblings,"#request.question_id#")>
<!--- <cfoutput>currentPos=#currentPos#</cfoutput> --->
<cfif currentPos GT 1>
	<cfset prev_id=listGetAt(siblings, currentPos-1)>
</cfif> 
<cfif currentPos LT listLen(siblings)>
	<cfset next_id=listGetAt(siblings, currentPos+1)>
</cfif> 
<!--- <cfoutput>prev_id=#prev_id# next_id=#next_id#</cfoutput> --->

<!--- *** отказались от общего решения 
<cfif #request.question_id# GT 13>
	<cfif prev_id EQ 0><cfset prev_id=1></cfif>
	<cfif next_id EQ 0><cfset next_id=3></cfif>
</cfif> --->


<div style="height:5px"><spacer /></div>
<table width="100%" bgcolor="f3f3f3" border="0" cellpadding="5" cellspacing="0">
	<tr valign="middle">
		<td>
		
<table border="0" cellpadding="5" cellspacing="0" align="center">
	<tr valign="middle">
			
		<td><cfoutput><img name="prev" src="img/btn_prev.gif" style="cursor:pointer;" title="Назад" width="84" height="18" border="0" onClick="saveAndGo(#prev_id#);"></cfoutput></td>

		<cfif next_id GT 0>
			<td><cfoutput><img name="next" src="img/btn_next.gif" style="cursor:pointer;" title="Вперед" width="84" height="18" border="0" onClick="saveAndGo(#next_id#);"></cfoutput></td>
		<cfelseif fin>
		<td>
		<cfoutput><img name="end" src="img/btn_end.gif" style="cursor:pointer;" title="Закончить опрос" width="124" height="18" border="0" onClick="saveAndGo(-1);"></cfoutput></td>
		</cfif>
		
	</tr>
</table>

</td>
	</tr>
</table>