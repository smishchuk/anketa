SET ROLE dbo;
/*
GRANT USAGE ON SCHEMA cmdb TO appserver;
GRANT ALL ON ALL TABLES IN SCHEMA cmdb TO appserver;
GRANT ALL ON ALL SEQUENCES IN SCHEMA cmdb TO appserver;
--ALTER DEFAULT PRIVILEGES IN SCHEMA cmdb GRANT ALL ON TABLES TO appserver;
--ALTER DEFAULT PRIVILEGES IN SCHEMA cmdb GRANT ALL ON SEQUENCES TO appserver;
ALTER DEFAULT PRIVILEGES FOR ROLE dbo GRANT ALL ON TABLES TO appserver;
ALTER DEFAULT PRIVILEGES FOR ROLE dbo GRANT ALL ON SEQUENCES TO appserver;
*/

drop table if exists respondent;
create table respondent(
respondent_id int generated by default as identity primary key not null,
login varchar(255) not null,
passwd varchar(255) not null,
firstname varchar(63) not null,
middlename varchar(63) not null,
lastname varchar(255) not null,
gender int not null, -- 0=Ж, 1=M
descr varchar(255),
dt_lastvisited timestamptz null
);

/* 
todo добавить уровень обобщения
чтобы можно было завести несколько анкет,
на которые респондент может отвечать 
*/

-- анкета
drop table if exists questionary;
create table questionary (
questionary_id int generated by default as identity primary key not null,
title varchar(255) not null,
descr text not null
);

drop table if exists response;
create table response (
response_id int generated by default as identity primary key not null,
respondent_id int not null,
questionary_id int not null,
dt_completed timestamptz null, -- дата завершения, not null: признак завершения
--
target_usr_id int NOT NULL
);

/*
дилемма: для группы вопросов с 1 вопросом: держать тексты в вопросе или в группе?
решил: в вопросе
то же для тайтла при вырожденном случае, когда группы не нужны
*/

-- вопрос или группа
drop table if exists question;
create table question(
question_id int generated by default as identity primary key not null,
questionary_id int not null,
parent_id int null, -- поддерживается только для группы
question_type varchar(255) not null, -- возможность добавления пользовательских значений определяется типом
template varchar(255) null, -- вариант отображения, ограничен типом
ord int not null,
title varchar(255) null,
annonce text  null, -- если null или пусто - берется из descr
descr text null,
-- расширения для вопроса
enumeration_id int null,
max_count int null -- для ранжируемого списка: число ранжируемых элементов. ?<=0 - все ?
);
/*
дилемма: при пустом анонсе выбирать из дескрипшена, или дублировать?
анонс превратить в варчар?
слить question_type и template?
слить вопрос и группу? Исключит дублирование в тривиальных случаях. проверка: только группа может иметь чилдов
*/

/*
типы вопросов:
да-нет (реализуется как выбор из списка)
выбор из списка
множественный выбор из списка
множественный выбор из списка с ранжированием (параметр: число ранжируемых пунктов)
число (целое)
текст
множественный текст (реализовать как одно поле?)
*/

-- список 
drop table if exists enumeration;
create table enumeration(
enumeration_id int generated by default as identity primary key not null,
enumeration varchar(255) not null
);

-- вариант ответа
drop table if exists choice;
create table choice( 
choice_id int generated by default as identity primary key not null,
enumeration_id int not null,
ord int not null,
choice text not null,
commented int not null
);

-- alter table choice alter column choice text not null

-- ответ
drop table if exists answer;
create table answer(
answer_id int generated by default as identity primary key not null,
response_id int not null,
question_id int not null,
choice_id int null,
answer_text text null, 
answer_number int null,
ord int null -- порядок имеет значение для множественных расширяемых ответов (например, несколько текстов)
/*,
неправильно
master_question_id int null, -- вопрос, дополнительные ответны на который используются для группировки
added_choice_id int null
*/
);
--alter table answer alter column answer_text text null


/*
проблема. Группы вопросов 2 ссылаются на список, определенный в 1.
- зависимость, надо жестко кодировать, как организовать метаданные?
- проблема целостности (запрет удаления,?редактирования)
Коррелированные вопросы 1<-2 . Образуется динамическая группа
*/

/*
if exists(select * from sysobjects where name='usr' and type='V') drop view usr
go

create view usr as
select id as usr_id, 
	login as login,
	passwd as password,
	firstname,
	middlename,
	lastname,
	isnull(lastname,'') + ' ' + isnull(firstname,'') + ' ' + isnull(middlename,'') as fullname,
	isnull(lastname,'') + ' ' 
		+ isnull(left(firstname, 1), '') + case when (len(firstname)>1) then '.' else '' end + ' ' 
		+ isnull(left(middlename, 1), '') + case when (len(middlename)>1) then '.' else '' end  
		as shortname,
	email,
	phone_local, 
	phone_cell, 
	division_id,
	comments as descr,
	settings,
	actual,
	NULL as usrcategory_id
from dbo.worker
go
*/
drop table if exists usr;
create table usr(
	 usr_id int GENERATED BY DEFAULT AS IDENTITY(START WITH 11) PRIMARY KEY NOT NULL
	,firstname varchar(255) NULL
	,middlename varchar(255) NULL
	,lastname varchar(255) NOT NULL
	,login varchar(255) NOT NULL 
	,password varchar(255) NULL -- changed from varbinary for postgre and Argon2
	,email varchar(255) NOT NULL
	,phone_cell	varchar(50) NULL
	,descr text NULL
	,settings text NULL
	,locked boolean NOT NULL CONSTRAINT DF_usr_locked DEFAULT(false)	
	,creator_id int NULL
	,updater_id int NULL
	,dt_created timestamptz NOT NULL default CURRENT_TIMESTAMP -- дата записи
	,dt_updated timestamptz NOT NULL default CURRENT_TIMESTAMP -- дата последней модификации	
	
	,fullname varchar GENERATED ALWAYS AS ((lastname||rtrim(' '||coalesce(firstname,'')))||rtrim(' '||coalesce(middlename,''))) STORED
	,shortname varchar GENERATED ALWAYS AS (replace((lastname||rtrim(' '||coalesce(left(firstname,(1))||'.','')))||rtrim(' '||coalesce(left(middlename,(1))||'.','')),' .','')) STORED
);
CREATE UNIQUE INDEX UX_login ON usr(login);

insert into usr (usr_id,firstname,middlename,lastname,login,password,email,phone_cell)
	values (2,'','','Анонимный пользователь','anonymous',null,'',null);
insert into usr (usr_id,firstname,middlename,lastname,login,password,email,phone_cell)
	values (3,'','','Тестовый админ','admin','$argon2id$v=19$m=16000,t=2,p=1$LVGYXF1OER4WhC1LgnwbBQ$HypFQo/Zr1+Bk9vPZU8zLZBslZz+Hecy9xGl3zYDKyQ','',null);
insert into usr (usr_id,firstname,middlename,lastname,login,password,email,phone_cell)
	values (10,'Сергей','Юрьевич','Мищук','msyu','$argon2id$v=19$m=500,t=3,p=4$d37RBdizC3rwQfINGSoQmg$Bwvr1f+RQf9hpXwV58sgUYzYpupp7iUzfUBACGApT80','asdfgh@mail.ru',null);