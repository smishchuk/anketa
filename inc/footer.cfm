


<tr valign="bottom">
	<td>

		<!-- footer -->
<div style="text-align: right; margin: 10px 20px 10px 10px;">
<cfquery name="qUsr" datasource="#request.DS#">
	select usr_id, shortname from usr 
	where usr_id='#request.respondent_id#'
</cfquery>

&nbsp;&nbsp;
<cfoutput>#qUsr.shortname#</cfoutput>
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
