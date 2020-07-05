--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 12/Junio/2020
--@Descripción: Creación de la tabla histórico_status_auto
prompt Conectandose a cahabdd_s1 como usuario caha_particiones_bdd
connect caha_particiones_bdd/caha_particiones_bdd@cahabdd_s1

DROP TABLE historico_status_auto;
prompt Creando tabla historico_status_auto
create table historico_status_auto(
    historico_status_id    dummy_number(10, 0)    not null,
    fecha_status           timestamp(6)     not null,
    status_auto_id         dummy_number(2, 0)     not null,
    auto_id                dummy_number(10, 0)    not null,
    constraint historico_status_auto_pk primary key (historico_status_id),
    constraint hist_status_auto_status_id_fk foreign key (status_auto_id)
    references status_auto(status_auto_id),
    constraint historico_status_auto_id_fk foreign key (auto_id)
    references auto(auto_id)
)
partition by range(fecha_status)
interval(numtoyminterval(1,'YEAR'))
subpartition by hash(historico_status_id)
subpartition template (
subpartition h_1 tablespace autos_tbs_1,
subpartition h_2 tablespace autos_tbs_2,
subpartition h_3 tablespace autos_tbs_3,
subpartition h_4 tablespace autos_tbs_4,
subpartition h_5 tablespace autos_tbs_5
)
(partition h_antigua values less than (to_date('01-01-2010','dd-mm-yyyy')));

insert into historico_status_auto (historico_status_id, fecha_status, status_auto_id, auto_id)
values (1, to_date('2010-01-01', 'yyyy-mm-dd'), 3, 1);
insert into historico_status_auto (historico_status_id, fecha_status, status_auto_id, auto_id)
values (2, to_date('2011-01-01', 'yyyy-mm-dd'), 1, 2);
insert into historico_status_auto (historico_status_id, fecha_status, status_auto_id, auto_id)
values (3, to_date('2012-01-01', 'yyyy-mm-dd'), 3, 3);

-- por subpartición
insert into historico_status_auto (historico_status_id, fecha_status, status_auto_id, auto_id)
values (10, to_date('2009-01-01', 'yyyy-mm-dd'), 6, 4);
insert into historico_status_auto (historico_status_id, fecha_status, status_auto_id, auto_id)
values (100, to_date('2009-01-01', 'yyyy-mm-dd'), 3, 5);
insert into historico_status_auto (historico_status_id, fecha_status, status_auto_id, auto_id)
values (1000, to_date('2009-01-01', 'yyyy-mm-dd'), 6, 6);

commit;

select a.*,'h_antigua' as nombre_particion
from historico_status_auto partition(H_ANTIGUA) a
UNION ALL
select a.*,'h_2010' as nombre_particion
from historico_status_auto partition(SYS_P1226) a
UNION ALL
select a.*,'h_2011' as nombre_particion
from historico_status_auto partition(SYS_P1232) a
UNION ALL
select a.*,'h_2012' as nombre_particion
from historico_status_auto partition(SYS_P1238) a;

exit
