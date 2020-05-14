-- @Autor: Hernández Arrieta Carlos Alberto
-- @Fecha creación: 27/Abril/2019
-- @Descripción: Script de ejecución para crear de vistas
-- en ambas PDBs
Prompt conectandose a cahabdd_s1
connect bancos_bdd/bancos_bdd@cahabdd_s1
Prompt creando vistas en cahabdd_s1
@s-04-CAHA-def-vistas.sql
Prompt conectandose a cahabdd_s2
connect bancos_bdd/bancos_bdd@cahabdd_s2
Prompt creando vistas en cahabdd_s2
@s-04-CAHA-def-vistas.sql
Prompt Listo!
exit
