--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 14/Mayo/2020
--@Descripción: Otorgamiento de privilegios para creación de triggers
-- en cahabdd_s1 y cahabdd_s2 paraa el usuario bancos_bdd
prompt Conectandose a cahabdd_s1 como usuario SYS
connect sys@cahabdd_s1 as sysdba
prompt otorgando nuevos privilegios a bancos_bdd
GRANT create trigger
to bancos_bdd;
prompt conectandose a cahabdd_s2 como usuario SYS
connect sys@cahabdd_s2 as sysdba
prompt otorgando nuevos privilegios a bancos_bdd
GRANT create trigger
to bancos_bdd;
prompt Listo
exit
