create user dbo nologin;
create user appserver with login password '***change it***';

create dtabase anketa with owner='dbo';

GRANT TEMPORARY, CONNECT ON DATABASE anketa TO appserver;