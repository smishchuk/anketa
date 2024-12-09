insert into enumeration(enumeration_id,enumeration
)values(1,'Соответствие ожиданиям, 6 вариантов'),
(2,'Кем для вас является сотрудник?');
SELECT setval(pg_get_serial_sequence('enumeration', 'enumeration_id'), coalesce(MAX(enumeration_id), 1)) from enumeration;

insert into choice(choice_id, enumeration_id, ord, choice, commented)values(1,1,1,'Не соответствует ожиданиям',0);
insert into choice(choice_id, enumeration_id, ord, choice, commented)values(2,1,2,'Требуются улучшения',0);
insert into choice(choice_id, enumeration_id, ord, choice, commented)values(3,1,3,'Соответствует ожиданиям',0);
insert into choice(choice_id, enumeration_id, ord, choice, commented)values(4,1,4,'Превосходит ожидания',0);
insert into choice(choice_id, enumeration_id, ord, choice, commented)values(5,1,5,'Не могу оценить',0);
insert into choice(choice_id, enumeration_id, ord, choice, commented)values(6,1,6,'Не применимо',0);

insert into choice(choice_id, enumeration_id, ord, choice, commented)values(7,2,1,'Руководитель',0);
insert into choice(choice_id, enumeration_id, ord, choice, commented)values(8,2,2,'Подчиненный',0);
insert into choice(choice_id, enumeration_id, ord, choice, commented)values(9,2,3,'Коллега',0);

SELECT setval(pg_get_serial_sequence('choice', 'choice_id'), coalesce(MAX(choice_id), 1)) from choice;


insert into respondent(respondent_id, login, passwd,firstname,middlename,lastname,gender,descr,dt_lastvisited)
values (1, 'test1', 'test301', 'test:Иван', 'test:Иванович','test:Иванов', 1, 'test: Иванов Иван Иванович', null);

insert into respondent(respondent_id, login, passwd,firstname,middlename,lastname,gender,descr,dt_lastvisited)
values (2, 'test2', 'test302', 'test:Жанна', 'test:Ивановна','test:Иванова', 0, 'test: Иванова Жанна Ивановна', null);

insert into respondent(respondent_id, login, passwd,firstname,middlename,lastname,gender,descr,dt_lastvisited)
values (3, 'test303', 'test303', 'test3:Имя', 'test3:Отчество','test3:Фамилия', 0, 'test3', null);

insert into respondent(respondent_id, login, passwd,firstname,middlename,lastname,gender,descr,dt_lastvisited)
values (4, 'test304', 'test304', 'test4:Имя', 'test4:Отчество','test3:Фамилия', 0, 'test4', null);

insert into respondent(respondent_id, login, passwd,firstname,middlename,lastname,gender,descr,dt_lastvisited)
values (5, 'test305', 'test305', 'test5:Имя', 'test3:Отчество','test5:Фамилия', 1, 'test5', null);

insert into respondent(respondent_id, login, passwd,firstname,middlename,lastname,gender,descr,dt_lastvisited)
values (6, 'test306', 'test306', 'test6:Имя', 'test6:Отчество','test6:Фамилия', 1, 'test6', null);

insert into respondent(respondent_id, login, passwd,firstname,middlename,lastname,gender,descr,dt_lastvisited)
values (7, 'test307', 'test307', 'test7:Имя', 'test7:Отчество','test7:Фамилия', 0, 'test7', null);

insert into respondent(respondent_id, login, passwd,firstname,middlename,lastname,gender,descr,dt_lastvisited)
values (8, 'test308', 'test308', 'test8:Имя', 'test8:Отчество','test8:Фамилия', 1, 'test8', null);

insert into respondent(respondent_id, login, passwd,firstname,middlename,lastname,gender,descr,dt_lastvisited)
values (9, 'test309', 'test309', 'test9:Имя', 'test9:Отчество','test9:Фамилия', 1, 'test9', null);

insert into respondent(respondent_id, login, passwd,firstname,middlename,lastname,gender,descr,dt_lastvisited)
values (10, 'test310', 'test310', 'test10:Имя', 'test10:Отчество','test10:Фамилия', 1, 'test10', null);

SELECT setval(pg_get_serial_sequence('respondent', 'respondent_id'), coalesce(MAX(respondent_id), 1)) from respondent;



insert into usr (firstname,middlename,lastname,login,password,email,phone_cell)	values 
	('test:Иван', 'test:Иванович','test:Иванов','iii','$argon2id$v=19$m=500,t=3,p=4$d37RBdizC3rwQfINGSoQmg$Bwvr1f+RQf9hpXwV58sgUYzYpupp7iUzfUBACGApT80','asdfgh@mail.ru',null),
	('test:Жанна', 'test:Ивановна','test:Иванова','test2','$argon2id$v=19$m=500,t=3,p=4$d37RBdizC3rwQfINGSoQmg$Bwvr1f+RQf9hpXwV58sgUYzYpupp7iUzfUBACGApT80','a2@mail.ru',null),
	('test3:Имя','test3:Отчество','test3:Фамилия','test303','$argon2id$v=19$m=500,t=3,p=4$d37RBdizC3rwQfINGSoQmg$Bwvr1f+RQf9hpXwV58sgUYzYpupp7iUzfUBACGApT80','a3@mail.ru',null),
	('test4:Имя','test4:Отчество','test4:Фамилия','test304','$argon2id$v=19$m=500,t=3,p=4$d37RBdizC3rwQfINGSoQmg$Bwvr1f+RQf9hpXwV58sgUYzYpupp7iUzfUBACGApT80','a4@mail.ru',null),
	('test5:Имя','test3:Отчество','test5:Фамилия','test305','$argon2id$v=19$m=500,t=3,p=4$d37RBdizC3rwQfINGSoQmg$Bwvr1f+RQf9hpXwV58sgUYzYpupp7iUzfUBACGApT80','a5@mail.ru',null),
	('test6:Имя','test6:Отчество','test6:Фамилия','test306','$argon2id$v=19$m=500,t=3,p=4$d37RBdizC3rwQfINGSoQmg$Bwvr1f+RQf9hpXwV58sgUYzYpupp7iUzfUBACGApT80','a6@mail.ru',null)
;



insert into questionary (questionary_id,title,descr)
values(1,'Опрос 360 градусов','Опрос по оценке 360 градусов');

truncate table response RESTART IDENTITY;
insert into response (respondent_id, questionary_id,target_usr_id) values
(1,1,2),
(1,1,3),
(1,1,4),
(2,1,1),
(2,1,3),
(2,1,4),
(2,1,5),
(2,1,6),
(3,1,1),
(3,1,2),
(3,1,4),
(3,1,5),
(3,1,6),
(5,1,1),
(5,1,2),
(5,1,3),
(6,1,1),
(6,1,2),
(6,1,3),
(6,1,4),
(6,1,5),
(6,1,7),
(6,1,8),
(6,1,9),
(6,1,10),
(8,1,1),
(8,1,2),
(8,1,6),
(8,1,7),
(8,1,10)
;



truncate table question RESTART IDENTITY;
--  группы
insert into question(question_id, questionary_id, parent_id, question_type, template, ord, title, annonce, descr, enumeration_id, max_count)
values
(1, 1, null,'group','group_of_questions', 1,'Ориентация на клиента', null, null, null, null),
(2, 1, null,'group','group_of_questions',2,'Развитие бизнеса', null, null, null, null),
(3, 1, null,'group','group_of_questions',3,'Стратегический фокус', null, null, null, null),
(4, 1, null,'group','group_of_questions',4,'Эффективное управление', null, null, null, null),
(5, 1, null,'group','group_of_questions',5,'Мотивация и воодушевление', null, null, null, null),
(6, 1, null,'group','group_of_questions',6,'Развитие себя и других', null, null, null, null),
(7, 1, null,'group','group_of_questions',7,'Коммуникация и влияние', null, null, null, null
),(8, 1, null,'group','group_of_questions',8,'Командная работа и сотрудничество', null, null, null, null
),(9, 1, null,'group','group_of_questions',9,'Управление конфликтами', null, null, null, null
),(10, 1, null,'group','group_of_questions',10,'Нацеленность на результат', null, null, null, null
),(11, 1, null,'group','group_of_questions',11,'Вовлеченность и позитивный настрой', null, null, null, null
) ,(12, 1, null,'group','group_of_questions',12,'Гибкость и адаптивность', null, null, null, null
),(13, 1, null,'group','group_of_questions2',0,'Кем является', null, null, 2, null);
-- вопросы по группам
SELECT setval(pg_get_serial_sequence('question', 'question_id'), coalesce(MAX(question_id), 1)) from question;

--
insert into question(question_id, questionary_id, parent_id, question_type, template, ord, annonce, title, descr, enumeration_id, max_count)values(28,1,1,'single_choice',null,1,'выстраивает личный контакт и продуктивные рабочие отношения с конкретными людьми в клиентской компании на своем уровне',null,null,1,null),(29,1,1,'single_choice',null,2,'целенаправленно изучает потребности клиента, управляет ожиданиями так, чтобы не создавать разочарований: заранее узнает ожидания в рамках своей зоны ответственности, понижает завышенные ожидания',null,null,1,null),(30,1,1,'single_choice',null,3,'четко понимает уровень решений, которые он может самостоятельно принимать в переговорах с клиентом, во взаимодействии с клиентом не берет на себя обязательств и не дает обещаний, выполнение которых противоречит интересам Компании',null,null,1,null),(31,1,1,'single_choice',null,4,'постоянно держит контакт с клиентом, организует регулярный сбор обратной связи, обеспечивает удовлетворенность клиента процессом взаимодействия как со своей стороны, так и со стороны команды',null,null,1,null),(32,1,1,'single_choice',null,5,'при возникновении проблем у клиента берет на себя ответственность за обеспечение  оптимального решения в зоне своей ответственности, отрабатывает возникающие у клиента негативные эмоции, извлекает уроки и стремится предотвратить повторение ситуации в будущее',null,null,1,null),(33,1,1,'single_choice',null,6,'знает стандарты качества, способен самостоятельно отслеживать их соблюдение в своей работе',null,null,1,null),(34,1,2,'single_choice',null,1,'обладает широким спектром знаний, навыков, экспертизой в своей предметной  области: свободно ориентируется в различных методологиях, подходах, инструментах, осваивает новые и эффективно применяет их на практике ',null,null,1,null),(35,1,2,'single_choice',null,2,'следит за новыми технологиями и трендами в своей сфере: читает специализированную литературу, изучает интернет источники, узнает новости у коллег и клиентов',null,null,1,null),(36,1,2,'single_choice',null,3,'мониторит появление новых продуктов и услуг на рынке/у конкурентов, анализирует их с точки зрения возможного применения в Компании',null,null,1,null),(37,1,2,'single_choice',null,4,'целенаправленно собирает информацию по проблемам и потребностям существующих клиентов в своей зоне ответственности, сообщает о результатах руководителю',null,null,1,null),(38,1,2,'single_choice',null,5,'предлагает практические идеи по доработке существующих в компании решений и продуктов',null,null,1,null),(39,1,2,'single_choice',null,6,' по заданию руководства осуществляет проработку новых перспективных идей, умеет превращать идеи в проект, техническое задание ',null,null,1,null),(40,1,2,'single_choice',null,7,'участвует в кросс-функциональных  проектах по разработке новых идей и решений',null,null,1,null),(41,1,2,'single_choice',null,8,'предлагает клиентам перспективные продукты и сервисы компании; при возникновении запросов, требующих более широкой экспертизы или выходящих за рамки его полномочий, переадресует запрос на коллег или передает на более высокий уровень',null,null,1,null),(42,1,3,'single_choice',null,1,'знает/выясняет стратегические цели и приоритеты, перспективы развития компании',null,null,1,null),(43,1,3,'single_choice',null,2,'активно участвует в формировании целей и задач работы своего подразделения, по заданию руководителя готовит аналитику по своему участку, предлагает идеи и варианты развития своего направления  и пр. ',null,null,1,null),(44,1,3,'single_choice',null,3,'интересуется ситуацией в других подразделениях компании, знает, как решение задач в рамках его подразделения отражается на работе других, согласует с ними планы действий',null,null,1,null),(45,1,3,'single_choice',null,4,'планирует свою деятельность в соответствии с наиболее актуальными текущими приоритетами',null,null,1,null),(46,1,4,'single_choice',null,1,'при постановке задачи уточняет у руководителя основные условия, сроки и необходимые результаты, вырабатывает и согласует подход к выполнению задачи, самостоятельно, в срок и с должным качеством решает комплексные задачи в сфере своей профессиональной компетентности',null,null,1,null),(47,1,4,'single_choice',null,2,'планирует и организует свою деятельность исходя из общего плана работы подразделения, объема своих текущих задач и установленных руководителем приоритетов, запрашивает необходимые для выполнения задач ресурсы и полномочия',null,null,1,null),(48,1,4,'single_choice',null,3,'выявляет и анализирует факторы, влияющие на решение, самостоятельно принимает тактические решения, входящие в зону его компетентности, учитывает возможные риски и последствия принимаемых решений',null,null,1,null),(49,1,4,'single_choice',null,4,'предлагает и согласует с руководителем несколько вариантов решений, если вопрос выходит за рамки его ответственности',null,null,1,null),(50,1,4,'single_choice',null,5,'по задаче руководителя ищет, прорабатывает и реализует возможности по локальным улучшениям в существующих процессах и технологических системах с целью их развития и снижения рисков',null,null,1,null),(51,1,5,'single_choice',null,1,'управляет собственной мотивацией: видит и ищет новые для себя перспективы, понимает, чего может и хочет достичь',null,null,1,null),(52,1,5,'single_choice',null,2,'выстраивает позитивные отношения с коллегами',null,null,1,null),(53,1,5,'single_choice',null,3,'разделяет с командой равно успехи и неудачи,  поддерживает других в трудные периоды, подбадривает, заражает энергией, вдохновляет собственным примером   ',null,null,1,null),(54,1,6,'single_choice',null,1,'осознает свои зоны для развития, конструктивно с ними работает, ставит для себя сложные задачи, способствующие личному и профессиональному развитию',null,null,1,null),(55,1,6,'single_choice',null,2,'открыто и конструктивно воспринимает обратную связь в свой адрес, извлекает уроки из успехов и неудач,  наращивает профессиональную экспертизу, формирует успешные модели поведения',null,null,1,null),(56,1,6,'single_choice',null,3,'делится с коллегами опытом, передает свои знания другим,  - может выступать в качестве наставника для младших, неопытных в конкретном вопросе коллег (объясняет, демонстрирует на практике успешные подходы к решению задач)',null,null,1,null),(57,1,6,'single_choice',null,4,'повышает уровень своей профессиональной квалификации за счет участия в специализированных учебных программах ',null,null,1,null),(58,1,7,'single_choice',null,1,'осознает свою роль в общекомандном процессе (понимает, что от него ждет команда, что важно для общего результата), следует выработанным командой договоренностям (согласованным подходам, технологиям, методологиям) ',null,null,1,null),(59,1,7,'single_choice',null,2,'внимателен к проблемам, идеям и эмоциям других, идет навстречу коллегам в их просьбах и потребностях',null,null,1,null),(60,1,7,'single_choice',null,3,'открыто и прямо озвучивает проблемы и сложные вопросы, возникающие в процессе командного взаимодействия, при этом не зацикливается на негативе, предлагает  возможные решения и участвует в их реализации',null,null,1,null),(61,1,7,'single_choice',null,4,'принимает участие в мозговых штурмах и совещаниях в рамках своей экспертизы',null,null,1,null),(62,1,8,'single_choice',null,1,'ясно и точно формулирует свои идеи и мысли, проверяет, правильно ли его поняли',null,null,1,null),(63,1,8,'single_choice',null,2,'слышит других людей, точно понимает смысл их сообщения,  вопросами проясняет точку зрения/идею другого человека, принимает ее во внимание в процессе решения своих рабочих задач',null,null,1,null),(64,1,8,'single_choice',null,3,' аргументированно и конструктивно высказывает свою точку зрения в рамках своей профессиональной экспертизы',null,null,1,null),(65,1,8,'single_choice',null,4,'проявляет уверенность в себе и достоинство при взаимодействии с людьми любого уровня',null,null,1,null),(66,1,8,'single_choice',null,5,'понимает, какое впечатление производит в глазах собеседника, управляет невербальными аспектами взаимодействия (внешний вид, тон, темп речи, интонации, жесты)',null,null,1,null),(67,1,8,'single_choice',null,6,'эффективно проводит презентации и публичные выступления с использованием заранее разработанных материалов, в процессе выступления управляет вниманием аудитории, отвечает на вопросы, управляет дискуссией ',null,null,1,null),(68,1,8,'single_choice',null,7,'использует принятые в компании стандарты создания документов  (отчеты, инструкции, деловые письма, презентации и т.д.), по заданию руководителя формирует новые или дорабатывает существующие',null,null,1,null),(69,1,8,'single_choice',null,8,'владеет основными техниками и подходами к проведению переговоров, базовыми инструментами влияния и убеждения',null,null,1,null),(70,1,9,'single_choice',null,1,'при возникновении конфликтов предпринимает активные действия по их разрешению за счет поиска взаимовыгодных решений в зоне своей ответственности',null,null,1,null),(71,1,9,'single_choice',null,2,'при разрешении конфликтной ситуации фокусируется на решении задачи/проблемы, контролирует эмоции, не переходит на личности',null,null,1,null),(72,1,9,'single_choice',null,3,'своевременно эскалирует конфликты, выходящие за пределы зоны его ответственности',null,null,1,null),(73,1,10,'single_choice',null,1,'при получении задачи от руководителя согласует с ним образ желаемого результата с четкими сроками и критериями необходимого результата ',null,null,1,null),(74,1,10,'single_choice',null,2,'последовательно добивается поставленных целей, доводит дело до конца',null,null,1,null),(75,1,10,'single_choice',null,3,'настойчиво добивается достижения необходимого результата, при столкновении с трудностями не сдается, при необходимости запрашивает поддержку/ресурсы у коллеги и/или руководителя',null,null,1,null),(76,1,10,'single_choice',null,4,'оценивает успех по достигнутому результату, а не по количеству приложенных усилий',null,null,1,null),(77,1,10,'single_choice',null,5,'взвешивает свои возможности, прежде чем взять обязательства, в случае неисполнения берет на себя ответственность за исправление ситуации ',null,null,1,null),(78,1,11,'single_choice',null,1,'верит в успех Компании и транслирует эту веру в своем окружении',null,null,1,null),(79,1,11,'single_choice',null,2,'проявляет неравнодушие в работе: старается сделать лучше / больше, чем от него ожидается (руководителем, коллегами)',null,null,1,null),(80,1,11,'single_choice',null,3,'в сложных ситуациях управляет собственным эмоциональным состоянием, не поддается унынию,  сохраняет фокус на решении задачи, ищет возможности, а не препятствия',null,null,1,null),(81,1,11,'single_choice',null,4,'восстанавливается после неудач, фокусируясь на своих прошлых успехах и/или позитивной стороне вещей, при необходимости запрашивает поддержку и помощь у коллег, продолжает активно работать',null,null,1,null),(82,1,12,'single_choice',null,1,'с интересом и любопытством относится к идеям, мнениям и опыту коллег и руководства, стремится перенимать успешные практики и подходы к работе',null,null,1,null),(83,1,12,'single_choice',null,2,'меняет подход к решению задач в ситуациях, когда прежние методы не дают необходимого результата, ищет и тестирует более эффективные способы действий',null,null,1,null),(84,1,12,'single_choice',null,3,'при столкновении с непредвиденными ситуациями в работе соответствующим образом адаптирует свои планы и перестраивает деятельность',null,null,1,null),(85,1,12,'single_choice',null,4,'быстро переключается с задачи на задачу без существенной потери эффективности ',null,null,1,null),(86,1,12,'single_choice',null,5,'при изменении задачи изыскивает/запрашивает необходимые для ее реализации ресурсы,  предлагает варианты действий при отсутствии необходимых  ресурсов или их ограниченности, согласует их с руководителем',null,null,1,null)
,(87,1,13,'single_choice',null,1,'Кем для вас является оцениваемый сотрудник?',null,null,2,null);



