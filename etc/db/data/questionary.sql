-- анкета
delete from questionary
go
set identity_insert questionary on

insert into questionary (questionary_id,title,descr
)values(1,'Опрос по 360 градусов','Опрос по оценке 360 градусов')

set identity_insert questionary off


