truncate table choice

set identity_insert choice on

insert into choice(choice_id, enumeration_id, ord, choice, commented)values(1,1,1,'Не соответствует ожиданиям',0)
insert into choice(choice_id, enumeration_id, ord, choice, commented)values(2,1,2,'Требуются улучшения',0)
insert into choice(choice_id, enumeration_id, ord, choice, commented)values(3,1,3,'Соответствует ожиданиям',0)
insert into choice(choice_id, enumeration_id, ord, choice, commented)values(4,1,4,'Превосходит ожидания',0)
insert into choice(choice_id, enumeration_id, ord, choice, commented)values(5,1,5,'Не могу оценить',0)
insert into choice(choice_id, enumeration_id, ord, choice, commented)values(6,1,6,'Не применимо',0)

insert into choice(choice_id, enumeration_id, ord, choice, commented)values(7,2,1,'Руководитель',0)
insert into choice(choice_id, enumeration_id, ord, choice, commented)values(8,2,2,'Подчиненный',0)
insert into choice(choice_id, enumeration_id, ord, choice, commented)values(9,2,3,'Коллега',0)	

set identity_insert choice off
