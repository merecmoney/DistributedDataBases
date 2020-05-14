--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 18/Marzo/2019
--@Descripción: Creación de usuarios para la máquina carlos.
prompt Conectandose a cahabdd_s1 como usuario SYS
connect sys@cahabdd_s1 as sysdba
prompt creando usuario bancos_bdd
CREATE USER bancos_bdd IDENTIFIED BY bancos_bdd QUOTA unlimited ON USERS;
prompt Otorgando permisos
GRANT create session, create table, create procedure, create sequence
to bancos_bdd;
prompt conectandose a cahabdd_s2 como usuario SYS
connect sys@cahabdd_s2 as sysdba
prompt creando usuario bancos_bdd
CREATE USER bancos_bdd IDENTIFIED BY bancos_bdd QUOTA unlimited ON USERS;
prompt Otorgando permisos
GRANT create session, create table, create procedure, create sequence
to bancos_bdd;
prompt Listo
exit
