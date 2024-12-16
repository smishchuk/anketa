<cfparam name="key" type="string" default="">

<cfset msg="">	
<cfif isDefined("enter")>
	<cfquery name="qRead" datasource="#request.DS#">
	select respondent_id from respondent where passwd='#key#' 
	</cfquery>	

	<cfif qRead.recordCount GT 0>
		<cflock scope="SESSION" type="EXCLUSIVE" timeout=1>
			<cfset session.respondent_id=qRead.respondent_id>
		</cflock>

		<cflocation url="index.cfm" addtoken="No"/>
	<cfelse>
		<cfset msg="Вы ввели несуществующий ключ. <br>Пожалуйста, повторите попытку.">	
	</cfif>
<cfelseif isDefined("exit")>
	<cflock scope="SESSION" type="EXCLUSIVE" timeout=1>
		<cfset session.respondent_id=-1>
	</cflock>
</cfif>

<cfinclude template="inc/header.cfm">

<!-- page -->
<table border="0" align="center" cellpadding="0" cellspacing="0" class="votePage">
<tr>
	<td align="center">
	<div style="height:10px"><spacer /></div>
		<!-- header -->
		<table border="0" cellpadding="0" cellspacing="0" class="voteHeader">
		<tr valign="top">
			<td align="center"><img src="img/head.png" alt="" width="481" height="71" border="0"></td>
		</tr>
		</table>
		<!-- /header -->

	</td>
</tr>
<tr height="100%" valign="top">
	<td>

		<!-- content -->
		<table border="0" cellpadding="0" cellspacing="0" height="100%" align="center">
		<tr>
			<td>
	Себастьян Перейра здесь был

				<form action="<cfoutput>#request.thisPage#</cfoutput>" method="post">
				<div class="voteLoginHead">Вход в систему</div>
				<table border="1" cellpadding="0" cellspacing="0" class="voteLogin">
				<tr>
					<td class="voteBkg">
						<table border="0" cellpadding="0" cellspacing="10" align="center" class="voteLoginForm">
						<tr>
							<td>Ключ: </td>
							<td><input type="password" name="key" value="" /></td>
						</tr>
						</table>
					</td>
				</tr>
				</table>
				<div align="center"><input type="image" name="login" src="img/btn_enter.gif" class="nline" title="Вход" width="86" height="18" vspace="7" border="0" /></div>
				<input type="hidden" name="enter" value="">
				</form>
				<div align="center" class="voteLoginErr"><cfoutput>#msg#</cfoutput></div>

			</td>
		</tr>
		</table>
		<!-- /content -->

	</td>
</tr>
</table>
<!-- /page -->





	</td>
</tr>
</table>


<!-- /page -->

</body>
</html>
