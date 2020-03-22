--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 18/Marzo/2019
--@Descripción: Creación de los fragmentos para el nodo 1 y el nodo 2
prompt Conectandose a cahabdd_s1 como usuario bancos_bdd
connect bancos_bdd/bancos_bdd@cahabdd_s1
prompt creando fragmentos para nodo 1
@s-02-CAHA-n1-ddl.sql
prompt conectandose a cahabdd_s2 como usuario bancos_bdd
connect bancos_bdd/bancos_bdd@cahabdd_s2
prompt creando fragmentos para nodo 2
@s-02-CAHA-n2-ddl.sql
prompt Listo
exit
