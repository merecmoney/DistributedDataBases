--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 1/Junio/2020
--@Descripción: Información de las vistas materializadas en el nodo replica

prompt conectando a cahabdd_s2
connect caha_replica_bdd/caha_replica_bdd@cahabdd_s2

prompt Información de las vistas materializadas creadas
select owner,mview_name,master_link,updatable,refresh_method,refresh_mode
from user_mviews;

select mview_name,last_refresh_type,last_refresh_date,last_refresh_end_time
from user_mviews;

exit;
