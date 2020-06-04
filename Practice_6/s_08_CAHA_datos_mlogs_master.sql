--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 1/Junio/2020
--@Descripción: Información de los mlogs nodo master

prompt conectando a cahabdd_s1
connect caha_replica_bdd/caha_replica_bdd@cahabdd_s1

prompt Información de los mlogs
select log_owner,master,log_table,primary_key,
filter_columns,last_purge_date
from user_mview_logs;

exit;
