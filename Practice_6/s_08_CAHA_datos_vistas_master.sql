--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 1/Junio/2020
--@Descripción: Información de las vistas materializadas en el nodo master

prompt conectando a cahabdd_s1
connect caha_replica_bdd/caha_replica_bdd@cahabdd_s1

prompt Información de las vistas materializadas
select r.mview_id,r.owner,r.name,r.mview_site,
r.can_use_log,r.refresh_method,
v.master,v.mview_last_refresh_time, l.log_table
from user_registered_mviews r
join user_base_table_mviews v
on r.mview_id = v.mview_id
left join user_mview_logs l
on l.master = v.master;

exit;
