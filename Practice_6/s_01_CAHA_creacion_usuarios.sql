--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 1/Junio/2020
--@Descripción: Creación de usuarios para la máquina carlos.
prompt Conectandose a cahabdd_s1 como usuario SYS
connect sys@cahabdd_s1 as sysdba
prompt creando usuario caha_replica_bdd
CREATE USER caha_replica_bdd IDENTIFIED BY caha_replica_bdd QUOTA unlimited ON USERS;
prompt Otorgando permisos
GRANT create session, create table, create procedure, create sequence
to caha_replica_bdd;
prompt conectandose a cahabdd_s2 como usuario SYS
connect sys@cahabdd_s2 as sysdba
prompt creando usuario caha_replica_bdd
CREATE USER caha_replica_bdd IDENTIFIED BY caha_replica_bdd QUOTA unlimited ON USERS;
prompt Otorgando permisos
GRANT create session, create table, create procedure, create sequence
to caha_replica_bdd;
prompt Listo
exit
