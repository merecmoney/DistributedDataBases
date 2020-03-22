--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 21/Marzo/2019
--@Descripción: Consulta de las restricciones de referencia 
-- de las tablas de los nodos s1 y s2 en pc-carlos.fi.unam
Prompt Conectando a S1 - cahabdd_s1
connect bancos_bdd/bancos_bdd@cahabdd_s1
Prompt Restricciones de referencia en S1
@s-05-CAHA-consulta-restricciones-n1.sql
Prompt Conectando a S2 - jrcbd_s2
connect bancos_bdd/bancos_bdd@cahabdd_s2
Prompt Restricciones de referencia en S2
@s-05-CAHA-consulta-restricciones-n2.sql
Prompt Listo!
exit