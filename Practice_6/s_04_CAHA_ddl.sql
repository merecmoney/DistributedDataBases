--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 1/Junio/2020
--@Descripción: DDL para la base de datos master
whenever sqlerror exit rollback;

prompt conectandose a la base de datos master
connect caha_replica_bdd/caha_replica_bdd@cahabdd_s1
prompt Creación de Tablas e Indíces
@s-02-autos-ddl.sql
prompt Carga de Datos para AGENCIA
@s-03-agencia.sql
prompt Carga de Datos para CLIENTE
@s-03-cliente.sql
prompt Carga de Datos para STATUS AUTO
@s-03-status-auto.sql
prompt Carga de Datos para AUTO
@s-03-auto.sql
prompt Carga de Datos para HISTORICO STATUS AUTO
@s-03-historico-status-auto.sql
prompt Carga de Datos para ORDEN COMPRA
@s-03-orden_compra.sql
prompt Carga de Datos para PAGO AUTO
@s-03-pago_auto.sql

commit;
prompt Listo
exit;
