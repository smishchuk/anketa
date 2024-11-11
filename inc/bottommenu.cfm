<cfquery name="qMenu" datasource="#request.DS#">
select question_id, title, (case when datalength(isnull(annonce,''))=0 then descr else annonce end) as annonce, ord 
from question 
where parent_id is null order by ord
</cfquery>
<cfset firstColumnCount = int(qMenu.RecordCount / 2)>
<cfset secondColumnStart = firstColumnCount + 1>
<tr valign="bottom">
	<td>

		<!-- footer -->

		<!-- /footer -->

	</td>
</tr>