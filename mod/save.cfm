<cfparam name="ATTRIBUTES.question_id" type="numeric">
<cfquery name="qRead" datasource="#request.DS#">
select question_id, question_type from question 
where question_id='#ATTRIBUTES.question_id#'
</cfquery>



