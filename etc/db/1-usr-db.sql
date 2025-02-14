create user dbo nologin;
create user appserver with login password '***change it***';

-- run separately
create database anketa with owner='dbo';
-- run separately

GRANT TEMPORARY, CONNECT ON DATABASE anketa TO appserver;