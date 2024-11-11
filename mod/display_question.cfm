<cfparam name="ATTRIBUTES.question_id" type="numeric">

<cfquery name="qQuestion" datasource="#request.DS#">
select * from question where question_id='#ATTRIBUTES.question_id#'
</cfquery>

<cfif len(qQuestion.descr)>
<div style="height:5px">&nbsp;</div>

<table cellpadding="4" cellspacing="0" class="tableQuestion">
<tr>
	<td></td>
	<td>

<cfoutput query="qQuestion">
<p>#descr#</p>
</cfoutput>

</td>
<td></td>
</tr>
</table>
</cfif>
