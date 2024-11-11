<cfparam name="attributes.question_id" type="numeric">
<cfparam name="attributes.extensible" type="boolean" default="No">
<cfparam name="attributes.action" type="string" default="display">

<cfif ATTRIBUTES.action EQ "save" AND NOT request.readonly>

	<cfquery name="qChoice" datasource="#request.DS#">
	select choice_id from choice c join question q on (c.enumeration_id=q.enumeration_id) 
	where q.question_id='#attributes.question_id#' 
	order by c.ord
	</cfquery>
	<cfset choiceList="">	
	<cfloop query="qChoice">
		<cfset choiceList=listAppend(choiceList, qChoice.choice_id)>
	</cfloop>
		
	<cfquery name="qClear" datasource="#request.DS#">
	delete from answer where question_id='#attributes.question_id#' AND response_id='#request.response_id#'
	</cfquery>
	
		
	<!--- <cftry> --->
	<cfset usedList=""><!--- *** --->
	<cfloop index="i" from=1 to=5>
		<cfset fieldName="sort#i#">
		<cfif isDefined(fieldName)>
			<cfset field=(evaluate(fieldName))>
			<cfif isNumeric(field) AND listFind(usedList,field) EQ 0>	
				<cfset usedList=listAppend(usedList,field)>		
						
				<cfif field LE listLen(choiceList)>			
										
					<cfset choice_id = listGetAt(choiceList,field)>
					<cfquery name="qIns" datasource="#request.DS#">
					insert into answer(question_id, response_id, choice_id, ord)  
					values('#attributes.question_id#','#request.response_id#','#choice_id#', '#i#')
					</cfquery>
					
				<cfelse>
				
					<cfset answer_field="field_#field#">
					<cfif isDefined(answer_field)>
						<cfset answer=evaluate(answer_field)>
						<cfif len(answer) GT 0>
							<cfquery name="qIns" datasource="#request.DS#">
							insert into answer(question_id, response_id, answer_text, ord)  
							values('#attributes.question_id#','#request.response_id#','#answer#', '#i#')
							</cfquery>
						</cfif>
					</cfif>
		
				</cfif>
				
				
			</cfif>
		</cfif>
	</cfloop>
	<!--- <cfcatch type="ANY"></cfcatch></cftry> --->
	
	
	

<cfelseif ATTRIBUTES.action EQ "display">
	<cfinclude template="../inc/btn.cfm">	
	<cfmodule template="../mod/display_question.cfm" question_id=#attributes.question_id#>
	
	<cfquery name="qChoice" datasource="#request.DS#">
	select c.choice, c.choice_id, c.ord, a.choice_id as selected_choice_id 
	from question q join choice c on (c.enumeration_id=q.enumeration_id)
	left outer join answer a on (a.choice_id=c.choice_id AND q.question_id=a.question_id AND a.response_id='#request.response_id#')
	where 
	q.question_id='#attributes.question_id#' 
	order by c.ord
	</cfquery>
	
	<cfquery name="qExt" datasource="#request.DS#">
	select a.answer_id, a.choice_id, a.answer_text, a.ord 
	from question q join answer a on (a.question_id=q.question_id AND a.response_id='#request.response_id#')
	where q.question_id='#attributes.question_id#' and datalength(answer_text)>0
	order by a.ord
	</cfquery>

	
	<cfquery name="qSelected" datasource="#request.DS#" maxrows=5>
	select a.answer_id, c.choice, c.choice_id, a.choice_id as selected_choice,  a.ord 
	from question q join choice c on (c.enumeration_id=q.enumeration_id)
	left outer join answer a on (a.choice_id=c.choice_id AND q.question_id=a.question_id AND a.response_id='#request.response_id#')
	where 
	q.question_id='#attributes.question_id#' AND a.ord > 0	
	union all
	select a.answer_id, a.answer_text as choice, null as choice_id, null as selected_choice, a.ord 	
	from answer a where 
	a.question_id='#attributes.question_id#' AND a.choice_id is null AND a.response_id='#request.response_id#'
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
	
<table border="0" cellpadding="0" cellspacing="0" width="980">
<tr>
	<td>
	
	<table border="0" cellpadding="2" cellspacing="0">
	<cfset selectedPositionList = "">
	<cfoutput query="qSelected" maxrows=5>
		<cfif qSelected.choice_id GT 0>
			<cfset i=listFind(choiceList,qSelected.choice_id)>
		<cfelse>
			<cfset i=listLen(choiceList)+listFind(extList,qExt.answer_id)>
		</cfif>	
		<cfset selectedPositionList=listAppend(selectedPositionList,i)>
		<tr>
			<td><b class="freeTextGreen">#currentRow#</b>&nbsp;&nbsp; <input type="hidden" id="sort#currentRow#" name="sort#currentRow#" value="#i#" /></td>
			<td class="freeText" id="sort#currentRow#text"><b>#choice#</b></td>
		</tr>
	</cfoutput>
	
	<cfset from=qSelected.RecordCount+1>
	<cfloop index="i" from=#from# to=5>
		<cfoutput>
			<tr>
				<td><b class="freeTextGreen">#i#</b>&nbsp;&nbsp; <input type="hidden" id="sort#i#" name="sort#i#" value="" /></td>
				<td class="freeText" id="sort#i#text"><b>...</b></td>
			</tr>
		</cfoutput>
	</cfloop>	
	</table>	
</td>
	<td align="right"><img src="img/hint.gif" alt=""></td>
</tr>
</table>	
	
	
	<!-- sort -->
	<div id="sort" onmouseover="openSortDiv()" onmouseout="hideSortTimeout()">
		<table border="0" cellpadding="0" cellspacing="0" width="150" height="32">
		<tr>
			<td style="background:#000000">
				<table border="0" cellpadding="5" cellspacing="0" align="center">
				<tr>
					<cfset sortColorList="">
					<cfset sortList="">
					<cfoutput query="qSelected" maxrows=5>
						<cfset sortColorList=listAppend(sortList,1)>
						<td id="sort#currentRow#num" class="voteSortOn" onclick="return setSort(#currentRow#)">#currentRow#</td>
					</cfoutput>
					<cfset from=qSelected.RecordCount+1>
					<cfloop index="i" from=#from# to=5>
						<cfoutput>
							<cfset sortColorList=listAppend(sortList,0)>
							<td id="sort#i#num" class="voteSortOff" onclick="return setSort(#i#)">#i#</td>
						</cfoutput>
					</cfloop>
					
					<cfset sortCount=qChoice.recordCount + qExt.recordCount-1>
					<cfset sortMax=sortCount + 1>
					<cfoutput>	
						<script language="javascript">
						/* set sort color */
						var _sortCount = #sortCount#;
						var _sortMax = #sortMax#;
						var _sortColor = [#sortColorList#];
						function setSortColor(){
							for(i = 1; i <= _sortMax; i++){
									$("num" + i).className = "voteNum0";
							}
							for(i = 1; i < _sortColor.length; i++){
								if(_sortColor[i]) {
									$("sort" + i + "num").className = "voteSortOn";
									$("num" + _sortColor[i]).className = "voteNum" + i;
								}else{
									$("sort" + i + "num").className = "voteSortOff";
								}
							}
						}
						</script>
					</cfoutput>
				</tr>
				</table>
			</td>
		</td>
		</table>
	</div>
	<!-- sort -->				

				
	
	<div style="height:10px"><spacer /></div>
	
	<table border="0" cellpadding="0" cellspacing="0" class="voteNum">
	<cfset class="on">		
	<cfset i=0>	

	<cfoutput query="qChoice">
	
		<cfif class EQ "on">
			<cfset class="off">
		<cfelse>
			<cfset class="on">
		</cfif>
		<cfset i=#qChoice.currentRow#>
		<tr>
			<th class="#class#">
			<!--- *** подсветка отобранных --->
			<!--- *** исключение дублирования --->
				<cfset pos=listFind(selectedPositionList,qChoice.currentRow)>
				<div align="center" style="width:160px">
					<div id="num#i#" class="voteNum#pos#" onmouseover="openSort(#i#)"><spacer /></div>
					<div id="num#i#sel" class="voteNumNone" onmouseover="openSortDiv()" onmouseout="hideSortTimeout()"><spacer /></div>
				</div>
			</th>
			<td id="num#i#text" class="#class#" width="100%">#choice#</td>
		</tr>
		
	</cfoutput>
	</table>
	
	<cfif ATTRIBUTES.extensible>
	
	
	<div style="height:10px"><spacer /></div>
	<div class="freeText"><b>Ваш вариант:</b></div>
	<div style="height:10px"><spacer /></div>
		<input type="hidden" id="fieldcount" name="fieldcount" value="1" />
		<div id="fields2" style="border-bottom:1px solid #d3d3d3">	

		
		<table border="0" cellpadding="0" cellspacing="0" class="voteNumTbl" style="width:100%">
		<cfoutput query="qExt">
		<cfset i=i+1>
		<tr>
			<th class="off">
				<cfset pos=listFind(selectedPositionList,i)>
				<div align="center" style="width:160px">
					<div id="num#i#" class="voteNum#pos#" onmouseover="openSort(#i#)"><spacer /></div>
					<div id="num#i#sel" class="voteNumNone" onmouseover="openSortDiv()" onmouseout="hideSortTimeout()"><spacer /></div>
				</div>
			</th>
			<td class="off" width="100%"><input type="text" id="num#i#text" name="field_#i#" value="#answer_text#" style="width:100%" <cfif request.readonly> disabled="1"</cfif> /></td>
		</tr>
		</cfoutput>
		
		<cfoutput>
		<cfset i=i+1>
		<tr>
			<th class="off">
				<div align="center" style="width:160px">
					<div id="num#i#" class="voteNum0" onmouseover="openSort(#i#)"><spacer /></div>
					<div id="num#i#sel" class="voteNumNone" onmouseover="openSortDiv()" onmouseout="hideSortTimeout()"><spacer /></div>
				</div>
			</th>
			<td class="off" width="100%"><input type="text" id="num#i#text" name="field_#i#" value="" onkeydown="addField2(#i#)" style="width:100%" <cfif request.readonly> disabled="1"</cfif> /></td>
		</tr>
		</table>
		</cfoutput>
		</div>
	
	
	<cfscript>
	function escapeQuotes(s) {
		return replace(s,'"','&quot;',"ALL"); 
	}
	</cfscript>
	
	
	<!--- *** возможный косяк: добавленные риски не сохранятся, если не войдут в пятерку --->
	

	
	</cfif>
	
	<br><br>


	
	<cfinclude template="../inc/btn.cfm">

</cfif>