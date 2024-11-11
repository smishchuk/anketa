<cfparam name="question_id" type="numeric" default="0">
<cfparam name="target_id" type="numeric" default="#question_id#">

<cfset request.question_id=question_id><!--- неправльино, нельзя менять глобальную переменную --->

<cfquery name="qReadToSave" datasource="#request.DS#">
select question_id, question_type, template from question 
where question_id='#request.question_id#'
</cfquery>

<cfswitch expression="#qReadToSave.question_type#">
	<cfcase value="group">
		<cfif qReadToSave.template EQ 'group_of_questions'>
			<cfmodule template="tpl/group.cfm" question_id="#question_id#" action="save">
		<cfelseif qReadToSave.template EQ 'group_of_questions2'>	
			<cfmodule template="tpl/group2.cfm" question_id="#question_id#" action="save">
		<cfelseif qReadToSave.template EQ 'group_of_extras'>	
			<cfmodule template="tpl/extras.cfm" question_id="#question_id#" action="save">
		</cfif>
	</cfcase>
	<cfcase value="multiple_choice_ranged">
		<cfmodule template="tpl/multiple_choice_ranged.cfm" question_id="#question_id#" extensible="No" action="save">
	</cfcase>
	<cfcase value="multiple_choice_ranged_extensible">
		<cfmodule template="tpl/multiple_choice_ranged.cfm" question_id="#question_id#" extensible="Yes" action="save">
	</cfcase>
	<cfcase value="multiple_choice">
		<cfmodule template="tpl/multiple_choice.cfm" question_id="#question_id#" extensible="No" action="save">
	</cfcase>
	<cfcase value="multiple_choice_13">
		<cfmodule template="tpl/multiple_choice_13.cfm" question_id="#question_id#" extensible="Yes" action="save">
	</cfcase>
	<cfcase value="multiple_choice_extensible">
		<cfmodule template="tpl/multiple_choice.cfm" question_id="#question_id#" extensible="Yes" action="save">
	</cfcase>
	<cfcase value="multiple_text">
		<cfmodule template="tpl/multiple_text.cfm" question_id="#question_id#" action="save">
	</cfcase>
	<cfcase value="number">
		<cfmodule template="tpl/number.cfm" question_id="#question_id#" action="save">
	</cfcase>
	<cfcase value="single_choice">
		<cfmodule template="tpl/single_choice.cfm" question_id="#question_id#" action="save">
	</cfcase>
	<cfcase value="text">
		<cfmodule template="tpl/text.cfm" question_id="#question_id#" action="save">
	</cfcase>
	<cfdefaultcase></cfdefaultcase>
</cfswitch>

<cfmodule template="mod/fill.cfm">


<!--- /save --->

<cfif target_id EQ -1>
	<cflocation url="finish.cfm" addtoken="No">
</cfif>

<cfset question_id=target_id>
<cfset request.question_id=question_id>

<!--- <cfoutput>question_id=#question_id# target_id=#target_id#</cfoutput> --->

<cfquery name="qRootQuestion" datasource="#request.DS#">
select * from question where question_id=
(select max(case 
     when q.parent_id is null then q.question_id
     when q1.parent_id is null then q1.question_id
     else q2.question_id end)
from question q
left outer join question q1 on (q.parent_id=q1.question_id)
left outer join question q2 on (q1.parent_id=q2.question_id)
where q.question_id = '#request.question_id#')
</cfquery>

<!--- <cfoutput>qRootQuestion.question_id=#qRootQuestion.question_id#</cfoutput> --->

<cfset question_type=#qRootQuestion.question_type#>
<cfset template=#qRootQuestion.template#>
<cfset root_question_id=#qRootQuestion.question_id#>




<cfinclude template="inc/header.cfm">
<form name="frmQuestion" id="frmQuestion" method="get" action="<cfoutput>#request.thisPage#</cfoutput>">
<input type="hidden" name="target_id" id="target_id" value="0">



<!--- *** --->
<script language="javaScript">
function saveAndGo(target_id){
	if (document.getElementById("frmQuestion")) {
		document.getElementById("target_id").value=target_id;
		document.getElementById("frmQuestion").submit();
	} else {
		//alert('no form');
	}
}
</script>

<cfinclude template="inc/topmenu.cfm">

<tr height="100%" valign="top">
	<td valign="top">
		<!-- content -->
		<table border="0" cellpadding="0" cellspacing="0" width="980" align="center">
		<tr>
			<td valign="top">
			
<cfquery name="qRead" datasource="#request.DS#">
select question_id, question_type, template from question 
where question_id='#request.question_id#'
</cfquery>			

<cfswitch expression="#question_type#">
	<cfcase value="group">		
		<cfif qRead.template EQ 'group_of_questions' OR qRead.template EQ ''>
			<cfmodule template="tpl/group.cfm" question_id="#question_id#" root_question_id="#root_question_id#">
		<cfelseif qRead.template EQ 'group_of_questions2'>	
			<cfmodule template="tpl/group2.cfm" question_id="#question_id#" root_question_id="#root_question_id#">
		<cfelseif qRead.template EQ 'group_of_extras'>	
			<cfmodule template="tpl/extras.cfm" question_id="#question_id#" root_question_id="#root_question_id#">
		</cfif>
	</cfcase>
	<cfcase value="multiple_choice_ranged">
		<cfmodule template="tpl/multiple_choice_ranged.cfm" question_id="#question_id#" extensible="No">
	</cfcase>
	<cfcase value="multiple_choice_ranged_extensible">
		<cfmodule template="tpl/multiple_choice_ranged.cfm" question_id="#question_id#" extensible="Yes">
	</cfcase>
	<cfcase value="multiple_choice">
		<cfmodule template="tpl/multiple_choice.cfm" question_id="#question_id#" extensible="No">
	</cfcase>
	<cfcase value="multiple_choice_13">
		<cfmodule template="tpl/multiple_choice_13.cfm" question_id="#question_id#" extensible="Yes">
	</cfcase>
	<cfcase value="multiple_choice_extensible">
		<cfmodule template="tpl/multiple_choice.cfm" question_id="#question_id#" extensible="Yes">
	</cfcase>
	<cfcase value="multiple_text">
		<cfmodule template="tpl/multiple_text.cfm" question_id="#question_id#">
	</cfcase>
	<cfcase value="number">
		<cfmodule template="tpl/number.cfm" question_id="#question_id#">
	</cfcase>
	<cfcase value="single_choice">
		<cfmodule template="tpl/single_choice.cfm" question_id="#question_id#">
	</cfcase>
	<cfcase value="text">
		<cfmodule template="tpl/text.cfm" question_id="#question_id#">
	</cfcase>
	<cfdefaultcase>
		<cfmodule template="tpl/welcome.cfm">
	</cfdefaultcase>
</cfswitch>


			</td>
		</tr>
		</table>
		<!-- /content -->
		
	</td>
</tr>


<input type="hidden" name="question_id" value="<cfoutput>#request.question_id#</cfoutput>">
</form>

<cfinclude template="inc/footer.cfm">