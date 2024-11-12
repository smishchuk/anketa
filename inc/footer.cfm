<tr valign="bottom">
	<td>
		<!-- footer -->
		<div style="text-align: right; margin: 10px 20px 10px 10px;">
			
			<cfquery name="qRespondent">
				select u.login, u.firstname, u.middlename, u.lastname from respondent u
				where u.respondent_id=<cfqueryparam cfsqltype="cf_sql_integer" value=#request.respondent_id#/>
			</cfquery>
			
			<cfquery name="qTarget">
				select u.login, u.firstname, u.middlename, u.lastname from respondent u
				where u.respondent_id=<cfqueryparam cfsqltype="cf_sql_integer" value=#request.target_usr_id#/>
			</cfquery>
			&nbsp;&nbsp;
			<cfoutput><b>Участник:</b> #qRespondent.firstname# #qRespondent.middlename# #qRespondent.lastname# [#qRespondent.login# #request.respondent_id#]</cfoutput>
			&nbsp;&nbsp;
			<cfoutput><b>Оцениваемый:</b> #qTarget.firstname# #qTarget.middlename# #qTarget.lastname# [#qTarget.login# #request.target_usr_id#]</cfoutput>
			&nbsp;&nbsp;
			&nbsp;&nbsp;
			&nbsp;&nbsp;
			<a href="login.cfm?exit">Выход</a>
		</div>
		<!-- /footer -->
	</td>
</tr>
</table>

<!-- /page -->
</body>
</html>
