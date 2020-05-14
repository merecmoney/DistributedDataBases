--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 27/Abril/2020
--@Descripción: Otorgamiento de privilegios para creación de sinónimos
-- creación de vistas y de tipos para el usuario bancos_bdd
-- en cahabdd_s1 y cahabdd_s2
prompt Conectandose a cahabdd_s1 como usuario SYS
connect sys@cahabdd_s1 as sysdba
prompt otorgando nuevos privilegios a bancos_bdd
GRANT create synonym, create view, create type
to bancos_bdd;
prompt conectandose a cahabdd_s2 como usuario SYS
connect sys@cahabdd_s2 as sysdba
prompt otorgando nuevos privilegios a bancos_bdd
GRANT create synonym, create view, create type
to bancos_bdd;
prompt Listo
exit
