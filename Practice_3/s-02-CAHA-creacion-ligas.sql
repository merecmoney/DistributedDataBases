--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 9/Abril/2020
--@Descripción: Creación de ligas para la PDB cahabdd_s1 y cahabdd_s2
prompt Creando liga en cahabdd_s1 hacia cahabdd_s2
connect bancos_bdd/bancos_bdd@cahabdd_s1
create database link cahabdd_s2.fi.unam using 'CAHABDD_S2';
prompt Creando liga en cahabdd_s2 hacia cahabdd_s1
connect bancos_bdd/bancos_bdd@cahabdd_s2
create database link cahabdd_s1.fi.unam using 'CAHABDD_S1';
prompt Listo.
exit