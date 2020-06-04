--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 1/Junio/2020
--@Descripción: Creación de ligas para la base de replicación
prompt Creando ligas en cahabdd_s2 hacia cahabdd_s1
connect caha_replica_bdd/caha_replica_bdd@cahabdd_s2
--liga administrativa
create public database link cahabdd_s1_master.fi.unam using 'CAHABDD_S1';
--liga privada, no requiere hacer uso de USING
create database link cahabdd_s1_master.fi.unam connect to caha_replica_bdd
identified by caha_replica_bdd;

exit
