--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 27/Abril/2020
--@Descripción: Script encargado de realizar consultas con sinónimos
-- en ambas PDBs
prompt conectando a cahabdd_s1
connect bancos_bdd/bancos_bdd@cahabdd_s1
prompt Realizando conteo de registros
set serveroutput on
start s-03-CAHA-consultas-localizacion.sql
prompt conectando a cahabdd_s2
connect bancos_bdd/bancos_bdd@cahabdd_s2
prompt Realizando conteo de registros
set serveroutput on
start s-03-CAHA-consultas-localizacion.sql
exit
