--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 1/Junio/2020
--@Descripción: Consulta de procesos de background

prompt conectando a cahabdd_s2
connect caha_replica_bdd/caha_replica_bdd@cahabdd_s2

prompt Datos del grupo de replicación
select rowner,rname,refgroup,job,implicit_destroy,
next_date,interval,broken
from user_refresh;

prompt Información del último refresh
select * from user_mview_refresh_times;

prompt Información del job que realiza el refresh
select job,log_user,last_date,next_date,total_time
from user_jobs;

select broken,interval,failures, what
from user_jobs;

exit;
