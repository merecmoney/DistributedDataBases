--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 12/Junio/2020
--@Descripción: Creación de la tabla agencia
prompt Conectandose a cahabdd_s1 como usuario caha_particiones_bdd
connect caha_particiones_bdd/caha_particiones_bdd@cahabdd_s1
prompt Creando tabla agencia
create table agencia(
    agencia_id          dummy_number(10, 0)    not null,
    nombre              varchar2(40)     not null,
    clave               varchar2(8)      not null,
    agencia_anexa_id    dummy_number(10, 0),
    constraint agencia_pk primary key (agencia_id),
    constraint agencia_anexa_id_fk foreign key (agencia_anexa_id)
    references agencia(agencia_id)
)
partition by range (clave)
(
partition agencia_p1_ae values less than ('F')
tablespace autos_tbs_1,
partition agencia_p2_fj values less than ('K')
tablespace autos_tbs_2,
partition agencia_p3_ko values less than ('P')
tablespace autos_tbs_3,
partition agencia_p4_pt values less than ('U')
tablespace autos_tbs_4,
partition agencia_p5_uz values less than (maxvalue)
tablespace autos_tbs_5
)
;

insert into AGENCIA (agencia_id, nombre, clave, agencia_anexa_id) values (1, 'Cardguard', 'AR-774-M', null);
insert into AGENCIA (agencia_id, nombre, clave, agencia_anexa_id) values (2, 'Regrant', 'FB-795-F', null);
insert into AGENCIA (agencia_id, nombre, clave, agencia_anexa_id) values (3, 'Stringtough', 'KB-810-J', null);
insert into AGENCIA (agencia_id, nombre, clave, agencia_anexa_id) values (4, 'Bitchip', 'PU-222-W', null);
insert into AGENCIA (agencia_id, nombre, clave, agencia_anexa_id) values (5, 'Konklab', 'UT-925-K', null);

select a.*,'agencia_p1_ae' as nombre_particion
from agencia partition(agencia_p1_ae) a
union all
select a.*,'agencia_p2_fj' as nombre_particion
from agencia partition(agencia_p2_fj) a
union all
select a.*,'agencia_p3_ko' as nombre_particion
from agencia partition(agencia_p3_ko) a
union all
select a.*,'agencia_p4_pt' as nombre_particion
from agencia partition(agencia_p4_pt) a
union all
select a.*,'agencia_p5_uz' as nombre_particion
from agencia partition(agencia_p5_uz) a;

exit
