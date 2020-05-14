--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 18/Marzo/2019
--@Descripción: Consulta de los fragmentos creados en pc-carlos.fi.unam
set linesize 2000
Prompt Conectando a S1 - cahabdd_s1
connect bancos_bdd/bancos_bdd@cahabdd_s1
Prompt mostrando lista de fragmentos para s1
select TABLE_NAME from USER_TABLES ORDER BY TABLE_NAME;
Prompt Conectando a S2 - cahabdd_s2
connect bancos_bdd/bancos_bdd@cahabdd_s2
Prompt mostrando lista de fragmentos para s2
select TABLE_NAME from USER_TABLES ORDER BY TABLE_NAME;
Prompt Listo!
exit
