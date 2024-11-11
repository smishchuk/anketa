<cfparam name="pageTitle" default="Россия: вызов-2020">

<cfquery name="qQuestion" datasource="#request.DS#">
select * from where respondent_id='#request.respondent_id#'
</cfquery>


<html>
<head>
	<title>#pageTitle#</title>
</head>

<body>



</body>
</html>
