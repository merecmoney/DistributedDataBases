--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 12/Junio/2020
--@Descripción: Creación de usuarios para la máquina carlos.
prompt Conectandose a cahabdd_s1 como usuario SYS
connect sys@cahabdd_s1 as sysdba
prompt creando usuario caha_particiones_bdd
CREATE USER caha_particiones_bdd IDENTIFIED BY caha_particiones_bdd;
prompt Otorgando permisos
GRANT create session, create table, create procedure, create sequence
to caha_particiones_bdd;
prompt Listo
exit
