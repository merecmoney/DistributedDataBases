--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 1/Junio/2020
--@Descripción: Ver el DDL a sincronizar para las vistas materializadas


prompt conectando a cahabdd_s1
connect caha_replica_bdd/caha_replica_bdd@cahabdd_s1

select cliente_id,snaptime$$,dmltype$$
from mlog$_cliente;

select auto_id,snaptime$$,dmltype$$
from mlog$_auto;

select agencia_id,snaptime$$,dmltype$$
from mlog$_agencia;

exit;
