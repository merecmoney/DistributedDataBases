--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 1/Junio/2020
--@Descripción: Creación de vistas materializadas para la base
-- de datos de replicación.

prompt conectando a cahabdd_s1
connect caha_replica_bdd/caha_replica_bdd@cahabdd_s1

prompt Creación de mlogs
@s_06_CAHA_definicion_mlogs.sql

prompt conectando a cahabdd_s2
connect caha_replica_bdd/caha_replica_bdd@cahabdd_s2

prompt Creación de vistas materializadas
@s_05_CAHA_definicion_vistas.sql

exit;
