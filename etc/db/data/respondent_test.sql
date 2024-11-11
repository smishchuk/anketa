-- участник опроса
-- delete from answer
-- delete from response
-- delete from respondent

set identity_insert respondent on
go

insert into respondent(respondent_id, login, passwd,firstname,middlename,lastname,gender,descr,dt_lastvisited)
values (1, 'test1', 'test301', 'test:Иван', 'test:Иванович','test:Иванов', 1, 'test: Иванов Иван Иванович', null)

insert into respondent(respondent_id, login, passwd,firstname,middlename,lastname,gender,descr,dt_lastvisited)
values (2, 'test2', 'test302', 'test:Жанна', 'test:Ивановна','test:Иванова', 0, 'test: Иванова Жанна Ивановна', null)


insert into respondent(respondent_id, login, passwd,firstname,middlename,lastname,gender,descr,dt_lastvisited)
values (3, 'test303', 'test303', 'test3:Имя', 'test3:Отчество','test3:Фамилия', 0, 'test3', null)

insert into respondent(respondent_id, login, passwd,firstname,middlename,lastname,gender,descr,dt_lastvisited)
values (4, 'test304', 'test304', 'test4:Имя', 'test4:Отчество','test3:Фамилия', 0, 'test4', null)

insert into respondent(respondent_id, login, passwd,firstname,middlename,lastname,gender,descr,dt_lastvisited)
values (5, 'test305', 'test305', 'test5:Имя', 'test3:Отчество','test5:Фамилия', 1, 'test5', null)

insert into respondent(respondent_id, login, passwd,firstname,middlename,lastname,gender,descr,dt_lastvisited)
values (6, 'test306', 'test306', 'test6:Имя', 'test6:Отчество','test6:Фамилия', 1, 'test6', null)

insert into respondent(respondent_id, login, passwd,firstname,middlename,lastname,gender,descr,dt_lastvisited)
values (7, 'test307', 'test307', 'test7:Имя', 'test7:Отчество','test7:Фамилия', 0, 'test7', null)

insert into respondent(respondent_id, login, passwd,firstname,middlename,lastname,gender,descr,dt_lastvisited)
values (8, 'test308', 'test308', 'test8:Имя', 'test8:Отчество','test8:Фамилия', 1, 'test8', null)

insert into respondent(respondent_id, login, passwd,firstname,middlename,lastname,gender,descr,dt_lastvisited)
values (9, 'test309', 'test309', 'test9:Имя', 'test9:Отчество','test9:Фамилия', 1, 'test9', null)

insert into respondent(respondent_id, login, passwd,firstname,middlename,lastname,gender,descr,dt_lastvisited)
values (10, 'test310', 'test310', 'test10:Имя', 'test10:Отчество','test10:Фамилия', 1, 'test10', null)

set identity_insert respondent off


