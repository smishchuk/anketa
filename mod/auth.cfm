<cfif thisTag.executionMode EQ "end">
  <cfexit method="EXITTAG">
</cfif>

<cfparam name="ATTRIBUTES.do" type="string">

<cfswitch expression="#ATTRIBUTES.do#">


  <cfcase value="login">
    <cfparam name="ATTRIBUTES.username" type="string">
    <cfparam name="ATTRIBUTES.password" type="string">
    <cfparam name="ATTRIBUTES.granted">

    <cfquery name="qUserAuth" datasource="#request.DS#">
      select usr_id, 
             domain_auth,
             domain,
             dtln_auth,
             locked, 
             pwdcompare(<cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.password#">
                         ,password
                         ,0) pwd
        from usr
       where login=<cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.username#">  
    </cfquery>

    <cfset err=""/>
    <cfif (qUserAuth.RecordCount NEQ 1) >
      <cfset err="Пользователь не зарегистрирован в системе.<br/>Проверьте правильность указания имени пользователя и пароля.">
    </cfif>

    
    <cfif (len(err) EQ 0) AND (qUserAuth.domain_auth EQ 1)>
      <cfif UCase(qUserAuth.domain) EQ "DTLN">
        <cftry>
         <CFLDAP  ACTION="QUERY"
                  SERVER="DAT-DC-001.dtln.local"
                  PORT="636"
                  secure="CFSSL_BASIC"
                  START="dc=dtln,dc=local"
                  USERNAME="#qUserAuth.domain#\#ATTRIBUTES.username#"
                  PASSWORD="#ATTRIBUTES.password#"
                  NAME="authentication"
                  filter="sAMAccountName=#ATTRIBUTES.username#"
                  ATTRIBUTES="samaccountName, cn, dn, userprincipalname, name, lastlogontimestamp, mail"
                  SCOPE="SubTree"
                  MAXROWS="100"/> 
                  
         <cfif authentication.RecordCount NEQ 1>
           <cfset err="Пользователь #ATTRIBUTES.username# не найден в домене #qUserAuth.domain#"/>
         </cfif>         
        
        <cfcatch type="any">

          <cfif (findnocase("Authentication failed", cfcatch.message) GT 0) <!--- cold check--->
                OR (findnocase("LDAP: error code 49", cfcatch.message) GT 0) <!--- railo check --->
                >
            <cfset err="Вход в домен невозможен.<br/>Проверьте правильность указания имени пользователя и пароля.">
          <cfelse>
            <cfset err="Ошибка авторизации в домене #qUserAuth.domain#:<br/> #cfcatch.message# #cfcatch.detail#"/>
          </cfif>
          
        </cfcatch>
        </cftry>
        
      <cfelse>
        <cfset err="Неизвестный домен #qUserAuth.domain#. Обратитесь к администратору."/>
      </cfif>

    </cfif>


    <!---- авторизация в базе sales ---->
    <cfif (len(err) EQ 0) AND (qUserAuth.dtln_auth EQ 1)>
    
      <cfquery name="qDtlnAuth" datasource="dtln">
        select id, 
               pwdcompare(<cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.password#">
                           ,passwd
                           ,0) pwd
          from worker
         where id>2 and actual=1 and login=<cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.username#">  
      </cfquery>
      <cfif (qDtlnAuth.RecordCount NEQ 1) >
        <cfset err="Сотрудник не найден либо отмечен как уволеный.<br/> Для получения доступа обратитесь к администратору системы.">
      </cfif>    
    
      <cfif (len(err) EQ 0) AND (qDtlnAuth.pwd EQ 0)>
         <cfset err="Вход в систему невозможен.<br/>Проверьте правильность указания имени пользователя и пароля.">
      </cfif>


    </cfif>

    <cfif (len(err) EQ 0) 
           AND (qUserAuth.domain_auth+qUserAuth.dtln_auth EQ 0) 
           AND (qUserAuth.pwd EQ 0)>
       <cfset err="Вход в систему невозможен.<br/>Проверьте правильность указания имени пользователя и пароля.">
    </cfif>

    <cfif (len(err) EQ 0) AND (qUserAuth.locked NEQ 0)>
      <cfset err="Пользователь заблокирован. Для получения доступа обратитесь к администратору системы.">
    </cfif>



       
    <cfif (len(err) EQ 0)>

      <cfquery name="qUserLast" datasource="#request.DS#">
        update usr
          set dt_lastlogin=getdate()
        where usr_id=<cfqueryparam cfsqltype="cf_sql_integer" value="#qUserAuth.usr_id#">  
      </cfquery>


      <cfset info={id=-1,
                   login="anonimus", 
                   fullname="anonimus", 
                   shortname="anonimus",
                   domain_auth=false,
                   domain="",
                   email="",
                   phone="",
                   session_timeout_min=20,
                   table_column_resize=false,
                   table_column_move=false  
                   }/>
      
      
      <cfquery name="qUserInfo" datasource="#request.DS#">
        select usr_id id, 
               login, 
               fullname, 
               shortname,
               domain_auth,
               domain,
               email,
               phone,
               session_timeout_min,
               table_column_resize,
               table_column_move 
          from usr
        where usr_id=<cfqueryparam cfsqltype="cf_sql_integer" value="#qUserAuth.usr_id#">  
      </cfquery>
      
      <cfloop list="#qUserInfo.columnList#" index="col">
        <cfset setVariable("info.#col#", qUserInfo[col])>
      </cfloop>

      <cfset session.usr=info/>

    </cfif>  
    
    <cfif structkeyexists(ATTRIBUTES, "alert")>
      <cfset setVariable("CALLER.#ATTRIBUTES.alert#", err)>
    </cfif>
    
    <cfset setVariable("CALLER.#ATTRIBUTES.granted#", (len(err) EQ 0))>
  </cfcase>






  <cfcase value="logoff">
    <cfset structdelete(session, "usr")>
  </cfcase>






  <cfcase value="check">
    <cfparam name="ATTRIBUTES.granted">
    
    <cfset granted=isAuth()/>
    
    <cfset setVariable("CALLER.#ATTRIBUTES.granted#", granted)>

    <cfif granted and structkeyexists(ATTRIBUTES, "usr")>
      <cfset setVariable("CALLER.#ATTRIBUTES.usr#", session.usr)>
    </cfif>

  
  </cfcase>

</cfswitch>

  
  
<cffunction name="isAuth" output="false">
    <cfset var granted = false/>
    <cfif structkeyexists(session, "usr")>
  
      <cfquery name="qUserCheck" datasource="#request.DS#">
        select 1
          from usr
        where usr_id=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.usr.id#">  
        and locked=0
      </cfquery>
  
      <cfset granted = (session.usr.id GT 0) AND (qUserCheck.RecordCount EQ 1)/>
    </cfif>
    
    <cfreturn granted>
</cffunction>  
  