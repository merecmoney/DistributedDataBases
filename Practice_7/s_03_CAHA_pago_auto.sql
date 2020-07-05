--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 12/Junio/2020
--@Descripción: Creación de la tabla pago_auto
prompt Conectandose a cahabdd_s1 como usuario caha_particiones_bdd
connect caha_particiones_bdd/caha_particiones_bdd@cahabdd_s1
DROP TABLE pago_auto;
prompt Creando tabla pago_auto
create table pago_auto(
    num_pago           dummy_number(3, 0)     not null,
    orden_compra_id    dummy_number(10, 0)    not null,
    fecha_pago         date,
    importe            dummy_number(10, 2),
    constraint pago_auto_pk primary key (num_pago, orden_compra_id),
    constraint pago_auto_orden_compra_id_fk foreign key (orden_compra_id)
    references orden_compra(orden_compra_id)
)
partition by range (fecha_pago)
interval(numtoyminterval(6,'MONTH'))
subpartition by range (num_pago)
subpartition template (
subpartition pago_auto_num_pago_1 values less than (7),
subpartition pago_auto_num_pago_2 values less than (13),
subpartition pago_auto_num_pago_3 values less than (19),
subpartition pago_auto_num_pago_4 values less than (maxvalue)
)
(partition pago_auto_periodo_ini values less than (to_date('01-01-2011','dd-mm-yyyy')));

-- primeras tres particiones
insert into pago_auto (orden_compra_id, num_pago, fecha_pago, importe) values (1, 1, to_date('2011-01-01', 'yyyy-mm-dd'), '4535.84');
insert into pago_auto (orden_compra_id, num_pago, fecha_pago, importe) values (1, 10, to_date('2011-07-01', 'yyyy-mm-dd'), '19722.64');
insert into pago_auto (orden_compra_id, num_pago, fecha_pago, importe) values (1, 14, to_date('2012-01-01', 'yyyy-mm-dd'), '19722.64');
-- por subpartición
insert into pago_auto (orden_compra_id, num_pago, fecha_pago, importe) values (2, 1, to_date('2010-01-01', 'yyyy-mm-dd'), '19722.64');
insert into pago_auto (orden_compra_id, num_pago, fecha_pago, importe) values (2, 10, to_date('2010-01-01', 'yyyy-mm-dd'), '3938.33');
insert into pago_auto (orden_compra_id, num_pago, fecha_pago, importe) values (2, 14, to_date('2010-01-01', 'yyyy-mm-dd'), '3938.33');
insert into pago_auto (orden_compra_id, num_pago, fecha_pago, importe) values (2, 20, to_date('2010-01-01', 'yyyy-mm-dd'), '3938.33');
commit;

select a.*,'pago_auto_num_pago_1' as nombre_particion
from pago_auto partition(pago_auto_periodo_ini) a
UNION ALL
select a.*,'pago_auto_num_pago_2' as nombre_particion
from pago_auto partition(SYS_P1300) a
UNION ALL
select a.*,'pago_auto_num_pago_3' as nombre_particion
from pago_auto partition(SYS_P1305) a
UNION ALL
select a.*,'pago_auto_num_pago_4' as nombre_particion
from pago_auto partition(SYS_P1310) a;

exit;


