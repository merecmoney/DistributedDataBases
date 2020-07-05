--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 12/Junio/2020
--@Descripción: Creación de la tabla auto
prompt Conectandose a cahabdd_s1 como usuario caha_particiones_bdd
connect caha_particiones_bdd/caha_particiones_bdd@cahabdd_s1
DROP TABLE auto;
prompt Creando tabla auto
create table auto(
    auto_id           dummy_number(10, 0)    not null,
    marca             varchar2(40)     not null,
    modelo            varchar2(40)     not null,
    anio              dummy_number(4, 0)     not null,
    num_serie         varchar2(20)     not null,
    tipo              char(1)          not null,
    precio            dummy_number(9, 2)     not null,
    descuento         dummy_number(9, 2),
    foto              blob             not null,
    fecha_status      timestamp(6)     not null,
    status_auto_id    dummy_number(2, 0)     not null,
    agencia_id        dummy_number(10, 0)    not null,
    cliente_id        dummy_number(10, 0),
    constraint auto_pk primary key (auto_id)
)
partition by list(tipo)
subpartition by hash(cliente_id)
subpartition template (
    subpartition auto_cliente_p1pA tablespace autos_tbs_1,
    subpartition auto_cliente_p1pB tablespace autos_tbs_2,
    subpartition auto_cliente_p2pA tablespace autos_tbs_3,
    subpartition auto_cliente_p2pB tablespace autos_tbs_4
)
(
    partition auto_particular_p1 values('P'),
    partition auto_carga_p2 values('C')
)
;

insert into AUTO (auto_id, modelo, marca, anio, num_serie, tipo, precio, fecha_status, agencia_id, status_auto_id, foto, cliente_id)
    values (1, 'Ceed Sporty Wagon', 'Gmc', 2014, 'NRS322066WERVQ962312', 'C', '623261.17', to_date('2010-01-01', 'yyyy-mm-dd'), 1, 1, empty_blob(), 1);

insert into AUTO (auto_id, modelo, marca, anio, num_serie, tipo, precio, fecha_status, agencia_id, status_auto_id, foto, cliente_id)
    values (2, 'Allroad Quattro', 'Pontiac', 2013, 'UKL338222FDKGH142167', 'P', '609702.73', to_date('2010-01-01', 'yyyy-mm-dd'), 1, 1, empty_blob(), 1);
-- subparticiones
insert into AUTO (auto_id, modelo, marca, anio, num_serie, tipo, precio, fecha_status, agencia_id, status_auto_id, foto, cliente_id)
values (3, 'Splash', 'Hummer', 1981, 'NAQ540534TXHLE268311', 'C', '266389.21', to_date('2010-01-01', 'yyyy-mm-dd'), 1, 1, empty_blob(), null);

insert into AUTO (auto_id, modelo, marca, anio, num_serie, tipo, precio, fecha_status, agencia_id, status_auto_id, foto, cliente_id)
values (4, 'Montego', 'Hummer', 1987, 'USX005475EARLK493964', 'C', '769793.01', to_date('2010-01-01', 'yyyy-mm-dd'), 1, 5, empty_blob(), 2);

insert into AUTO (auto_id, modelo, marca, anio, num_serie, tipo, precio, fecha_status, agencia_id, status_auto_id, foto, cliente_id)
values (5, 'Verso', 'Asia', 1996, 'AGC309361DYSPV126869', 'C', '996233.95', to_date('2010-01-01', 'yyyy-mm-dd'), 1, 3, empty_blob(), 3);

insert into AUTO (auto_id, modelo, marca, anio, num_serie, tipo, precio, fecha_status, agencia_id, status_auto_id, foto, cliente_id)
values (6, 'Panda Classic', 'Iveco-pegaso', 1995, 'XEU264789SNJDM663977', 'C', '386341.61', to_date('2010-01-01', 'yyyy-mm-dd'), 1, 3, empty_blob(), 4);

commit;

select a.*,'auto_particular_p1' as nombre_particion
from auto partition(auto_particular_p1) a
UNION ALL
select a.*,'auto_carga_p2' as nombre_particion
from auto partition(auto_carga_p2) a;

exit
