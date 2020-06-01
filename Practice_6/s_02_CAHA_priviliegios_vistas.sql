--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 1/Junio/2020
--@Descripción: Otorgamiento de privilegios para la creación de vistas
-- Materializadas.
prompt conectandose a cahabdd_s2 como usuario SYS
connect sys@cahabdd_s2 as sysdba
prompt Otorgando permisos para creación de vistas materializadas
GRANT create materialized view to caha_replica_bdd;
prompt Otorgando permisos para realizar refresh
GRANT alter any materialized view to caha_replica_bdd;
prompt Otorgando permisos para creación de liga privada
GRANT create database link to caha_replica_bdd;
prompt Otorgando permisos para creación de liga pública
GRANT create public database link to caha_replica_bdd;

prompt Listo
exit
