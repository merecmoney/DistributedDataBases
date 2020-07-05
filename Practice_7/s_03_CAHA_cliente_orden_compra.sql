--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 12/Junio/2020
--@Descripción: Creación de la tabla cliente y orden_compra
prompt Conectandose a cahabdd_s1 como usuario caha_particiones_bdd
connect caha_particiones_bdd/caha_particiones_bdd@cahabdd_s1
prompt Creando tabla cliente
create table cliente(
    cliente_id            dummy_number(10, 0)    not null,
    nombre                varchar2(40)     not null,
    ap_paterno            varchar2(40)     not null,
    ap_materno            varchar2(40),
    num_identificacion    varchar2(18)     not null,
    email                 varchar2(500)    not null,
    constraint cliente_pk primary key (cliente_id),
    constraint auto_agencia_id_fk foreign key (agencia_id)
    references agencia(agencia_id),
    constraint auto_cliente_id_fk foreign key (cliente_id)
    references cliente(cliente_id),
    constraint auto_status_id_fk foreign key (status_auto_id)
    references status_auto(status_auto_id)
)
partition by hash(cliente_id)
(
partition cliente_p1 tablespace autos_tbs_1,
partition cliente_p2 tablespace autos_tbs_2,
partition cliente_p3 tablespace autos_tbs_3
)
;

insert into cliente (cliente_id, nombre, ap_paterno, ap_materno, num_identificacion, email)
    values (1, 'Ellswerth', 'Alcide', 'Woodlands', 'FNA352631VLHWG1800', 'ewoodlands0@smugmug.com');
insert into cliente (cliente_id, nombre, ap_paterno, ap_materno, num_identificacion, email)
    values (2, 'Annemarie', 'Jerrom', 'Gooms', 'ORN453116GZIYT2486', 'agooms1@phoca.cz');
insert into cliente (cliente_id, nombre, ap_paterno, ap_materno, num_identificacion, email)
    values (3, 'Brittne', 'Bainton', 'Bartley', 'SZR675651VTCHG7410', 'bbartley2@usa.gov');
insert into cliente (cliente_id, nombre, ap_paterno, ap_materno, num_identificacion, email)
    values (4, 'Virgilio', 'Pettengell', 'Fydo', 'QCA034930EBMNU0145', 'vfydo3@xing.com');
insert into cliente (cliente_id, nombre, ap_paterno, ap_materno, num_identificacion, email)
    values (5, 'Katti', 'Johnes', 'Burgen', 'YRG690743GQNKC4749', 'kburgen4@gmpg.org');
insert into cliente (cliente_id, nombre, ap_paterno, ap_materno, num_identificacion, email)
    values (6, 'Winni', 'Mulvenna', 'Acey', 'IED840901RQFPZ8538', 'wacey5@wisc.edu');

commit;

select a.*,'cliente_p1' as nombre_particion
from cliente partition(cliente_p1) a
union all
select a.*,'cliente_p2' as nombre_particion
from cliente partition(cliente_p2) a
union all
select a.*,'cliente_p3' as nombre_particion
from cliente partition(cliente_p3) a;

prompt Creando tabla orden_compra
create table orden_compra(
    orden_compra_id     dummy_number(10, 0)    not null,
    fecha_compra        date,
    num_cuenta_banco    varchar2(50),
    cliente_id          dummy_number(10, 0)    not null,
    constraint orden_compra_pk primary key (orden_compra_id),
    constraint orden_compra_cliente_id_fk foreign key (cliente_id)
    references cliente(cliente_id)
)
partition by reference(orden_compra_cliente_id_fk);

insert into orden_compra (orden_compra_id, fecha_compra, num_cuenta_banco, cliente_id) values
    (1, to_date('2010-01-01', 'yyyy-mm-dd')+dbms_random.value(1,365*6),
    'PT34 3023 2303 0194 0235 9647 0', 1);
insert into orden_compra (orden_compra_id, fecha_compra, num_cuenta_banco, cliente_id) values
    (2, to_date('2010-01-01', 'yyyy-mm-dd')+dbms_random.value(1,365*6),
    'GE41 OB78 5669 7856 2242 59', 2);
insert into orden_compra (orden_compra_id, fecha_compra, num_cuenta_banco, cliente_id) values
    (3, to_date('2010-01-01', 'yyyy-mm-dd')+dbms_random.value(1,365*6),
    'GR67 1009 413K QDZU TBT7 WMYR OEG', 3);
insert into orden_compra (orden_compra_id, fecha_compra, num_cuenta_banco, cliente_id) values
    (4, to_date('2010-01-01', 'yyyy-mm-dd')+dbms_random.value(1,365*6),
    'FR89 7920 0051 03YD BTZX ABQP L98', 4);
insert into orden_compra (orden_compra_id, fecha_compra, num_cuenta_banco, cliente_id) values
    (5, to_date('2010-01-01', 'yyyy-mm-dd')+dbms_random.value(1,365*6),
    'CH90 2256 6TRJ TYIE NP1P D', 5);
insert into orden_compra (orden_compra_id, fecha_compra, num_cuenta_banco, cliente_id) values
    (6, to_date('2010-01-01', 'yyyy-mm-dd')+dbms_random.value(1,365*6),
    'FR61 0122 8488 919V SZVE 7NQL Y59', 6);

commit;

select a.*,'cliente_p1' as nombre_particion
from orden_compra partition(cliente_p1) a
union all
select a.*,'cliente_p2' as nombre_particion
from orden_compra partition(cliente_p2) a
union all
select a.*,'cliente_p3' as nombre_particion
from orden_compra partition(cliente_p3) a;

exit
