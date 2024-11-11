<!--- combobox 
v3.0 12.08.2016 ATTRIBUTES.readonly
v2.1 04.05.2016 ATTRIBUTES.disabled 
v2 с форматным выводом

---><cfprocessingdirective suppresswhitespace="true">
<cfparam name="ATTRIBUTES.query" type="query" default=#queryNew("")#/>
<cfparam name="ATTRIBUTES.queryString" type="string" default=""/>
<cfparam name="ATTRIBUTES.DS" type="string" default="#request.DS#"/>
<cfparam name="ATTRIBUTES.combo"/><!--- имя контрола (name)--->
<cfparam name="ATTRIBUTES.key"/><!--- Имя ключевого поля---><!--- ограничение: не поддерживаем составные ключи --->
<cfparam name="ATTRIBUTES.display" default=""/><!--- имя поля резалтсета --->
<cfparam name="ATTRIBUTES.displayf" default=""/><!--- форматный вывод, поля резалтсета писать: ##field##, например "*##field1##:##field2##*" --->
<cfparam name="ATTRIBUTES.selected" default=""/><!--- в случае base64 - завернуто в base64--->
<cfparam name="ATTRIBUTES.base64" default="No"/><!---*** это архитектурная ошибка. Base64 is url unsafe. Но поскольку все передается POST-ом, обычно не проявляется --->
<cfparam name="ATTRIBUTES.disabled" type="boolean" default="No"/>
<cfparam name="ATTRIBUTES.style_selector" default=""/>
<cfparam name="ATTRIBUTES.style_spec" type="struct" default=#structNew()#/>
<cfparam name="ATTRIBUTES.class_selector" default=""/>
<cfparam name="ATTRIBUTES.class_spec" type="struct" default=#structNew()#/>
<cfparam name="ATTRIBUTES.flag_disabled" type="string" default=""/><!--- проверяется на > 0. Возможно, не следует отключать выбранное значение --->
<cfparam name="ATTRIBUTES.readonly" type="boolean" default="false"/><!--- в случае readonly выводится текст и скрытое поле с ID, если множественное выделение, то надо наверно выводить все выделенные элементы? --->
<cfparam name="ATTRIBUTES.extra" type="string" default=""/><!--- --->

<cfset attributeList="template,query,queryString,combo,key,display,displayf,selected,empty,DS,base64,disabled,style_selector,style_spec,class_selector,class_spec,flag_disabled,readonly,extra"/>

<cffunction name="escape64" returnType="string">
	<cfargument name="val" type="string">
	<cfif #ATTRIBUTES.base64#>
		<cfreturn ToBase64(val)>
	<cfelse>
		<cfreturn val>	
	</cfif>
</cffunction>

<cffunction name="isSelected" returnType="boolean">
	<!--- tests for presense of key (second arg) in passed array (first arg) or, if sel is simple value just compares key and sel.
	Used for checking against multiple alternatives like "save" OR "saveAndClose"
	--->
	<cfargument name="sel">
	<cfargument name="key">
	<cfscript>
		if (isArray(sel)) {
			for(i=1; i <= ArrayLen(sel); i++){
				if (sel[i]==key) {return true;}
			}
			return false;			
		} else { //считаем, что из сложных типов тут бывает только массив
			if (!isSimpleValue(sel)) {return false;}
			return (sel == key);
		}
	</cfscript>
</cffunction>

<cffunction name="strSelected" returnType="string">
	<cfargument name="sel">
	<cfargument name="key">
	<!---unsupported in CF8: <cfreturn (isSelected(sel,key)? " selected" : "")>--->
	<cfif isSelected(sel,key)>
		<cfreturn " selected">
	<cfelse>
		<cfreturn "">
	</cfif>
</cffunction>

<!--- функция условного обертывания --->
<cffunction name="w" returnType="string">
	<cfargument name="prefix"/>
	<cfargument name="input"/>
	<cfargument name="suffix" default=""/>
	
	<cfif len(input) GT 0>
		<cfreturn "#prefix##input##suffix#"/>
	<cfelse>
		<cfreturn ""/>
	</cfif>
</cffunction>

<cffunction name="strAttribute" returnType="string">
	<!---returns formatted string ' attribute="value"',  
	where attribute name is the first argument, 
	and value is taken from passed structure(third argument) by key (second argument)--->
	<cfargument name="name"/>
	<cfargument name="selector"/>
	<cfargument name="spec" type="struct"/>
		
	<cfif StructKeyExists(spec, selector)>
		<cfreturn ' #name#="#structFind(spec, selector)#"'/>
	<cfelse>
		<cfreturn "">
	</cfif>
</cffunction>

<!--- ---------------------------------------------------------------------------------- --->

<cfif ATTRIBUTES.queryString EQ "">
	<cfset qSel=ATTRIBUTES.query>
<cfelse>
	<cfquery name="qSel" datasource="#ATTRIBUTES.DS#">
	#preserveSingleQuotes(ATTRIBUTES.queryString)#
	</cfquery>
</cfif>


<!--- parse class specifications--->
<cfscript>
</cfscript>

<cfif ATTRIBUTES.readonly>
	<cfif isArray(ATTRIBUTES.selected)>
		<cfset selectedList=ArrayToList(ATTRIBUTES.selected)/>
	<cfelse>
		<cfset selectedList=ATTRIBUTES.selected/>
	</cfif>
	
	<cfquery name="qSelFiltered" dbtype="query">
	select * from qSel where <cfif len(selectedList)>#ATTRIBUTES.key# in (#selectedList#)<cfelse>1=0</cfif>
	</cfquery>

	<cfoutput>
	<div style="display:inline-block;"<cfloop collection=#ATTRIBUTES# item="attr"><!---
	---><cfif NOT listFindNoCase(attributeList,attr)> #attr#="#structFind(ATTRIBUTES,attr)#"</cfif><!---
---></cfloop>>
	<cfif qSelFiltered.recordCount GT 0>
		<cfloop query="qSelFiltered"><!---
		---><cfset key=evaluate("#ATTRIBUTES.key#")/><!---
		---><cfset key=trim(escape64(key))/><!---
		---><div><input type="hidden" name="#ATTRIBUTES.combo#" value="#key#"/>#Evaluate(ATTRIBUTES.display)#<cfset Evaluate("WriteOutput('#ATTRIBUTES.displayf#')")/></div>
		</cfloop>
	<cfelseif isDefined("ATTRIBUTES.empty")>
		<input type="hidden" name="#ATTRIBUTES.combo#" value="#ATTRIBUTES.empty#"/><!-- #ATTRIBUTES.combo#: nothing selected -->
	</cfif>
	</div>
	</cfoutput>
<cfelse><!--- ATTRIBUTES.readonly --->

<cfoutput>
<select name="#ATTRIBUTES.combo#"<!---
passthrough additional attributes 
---><cfloop collection=#ATTRIBUTES# item="attr"><!---
	---><cfif NOT listFindNoCase(attributeList,attr)> #attr#="#structFind(ATTRIBUTES,attr)#"</cfif><!---
---></cfloop><cfif ATTRIBUTES.disabled> disabled="disabled"</cfif><cfif len(ATTRIBUTES.extra)>#ATTRIBUTES.extra#</cfif>>
<cfif isDefined("ATTRIBUTES.empty")>
<option value="#ATTRIBUTES.empty#"></option>
</cfif>
<cfloop query=qSel>
		<cfset key=evaluate("#ATTRIBUTES.key#")/><!--- в контексте запроса, поэтому находится в цикле! *** не самый лучший способ в смысле производительности --->			
		<cfset key=trim(escape64(key))/>
		<cfset str_sel=strSelected(ATTRIBUTES.selected, key)/>
		<option value="#key#"#str_sel#<!---
		---><cfif len(ATTRIBUTES.style_selector) GT 0>#strAttribute("style",
		Evaluate(ATTRIBUTES.style_selector),ATTRIBUTES.style_spec)#</cfif><!---
		---><cfif len(ATTRIBUTES.class_selector) GT 0>#strAttribute("class", Evaluate(ATTRIBUTES.class_selector),ATTRIBUTES.class_spec)#</cfif><!--- 			
		---><cfif len(ATTRIBUTES.flag_disabled) GT 0><cfif Evaluate(ATTRIBUTES.flag_disabled) GT 0> disabled="1"</cfif></cfif><!--- 			
		--->>#Evaluate(ATTRIBUTES.display)#<cfset Evaluate("WriteOutput('#ATTRIBUTES.displayf#')")/></option>
</cfloop>
</select> 
</cfoutput>
</cfif>

</cfprocessingdirective><cfexit method="EXITTAG"/>



