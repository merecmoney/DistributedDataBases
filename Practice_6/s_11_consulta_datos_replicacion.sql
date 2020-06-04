--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 1/Junio/2020
--@Descripción: Consulta datos replicación

prompt conectando a cahabdd_s2
connect caha_replica_bdd/caha_replica_bdd@cahabdd_s2

select * from MV_AGENCIA where AGENCIA_ID = 101;
select * from MV_AUTO where auto_id = 300;
select * from MV_CLIENTE where CLIENTE_ID = 701;

exit;
