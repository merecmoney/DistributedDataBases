--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 9/Abril/2019
--@Descripción: Otorgamiento de privilegios
-- para crear ligas y procedimientos al usuario
-- bancos_bdd para cada PDB de la máquina carlos.
prompt Conectandose a cahabdd_s1 como usuario SYS
connect sys@cahabdd_s1 as sysdba
prompt otorgando nuevos privilegios a bancos_bdd
GRANT create database link, create procedure
to bancos_bdd;
prompt conectandose a cahabdd_s2 como usuario SYS
connect sys@cahabdd_s2 as sysdba
prompt otorgando nuevos privilegios a bancos_bdd
GRANT create database link, create procedure
to bancos_bdd;
prompt Listo
exit
