--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 12/Junio/2020
--@Descripción: Creación de la tabla status_auto
prompt Conectandose a cahabdd_s1 como usuario caha_particiones_bdd
connect caha_particiones_bdd/caha_particiones_bdd@cahabdd_s1
prompt Creando tabla status_auto
create table status_auto(
    status_auto_id    dummy_number(2, 0)    not null,
    clave             varchar2(20)    not null,
    descripcion       varchar2(40)    not null,
    constraint status_auto_pk primary key (status_auto_id)
)
;

insert into status_auto (status_auto_id, clave, descripcion) values (1, 'EN TRANSITO', 'EN CAMINO A LA AGENCIA');
insert into status_auto (status_auto_id, clave, descripcion) values (2, 'EN AGENCIA', 'DISPONIBLE EN LA AGENCIA PARA VENTA');
insert into status_auto (status_auto_id, clave, descripcion) values (3, 'APARTADO', 'EL CLIENTE HA REALIZADO UN DEPOSITO');
insert into status_auto (status_auto_id, clave, descripcion) values (4, 'VENDIDO', 'EL CARRO SE HA VENDIDO');
insert into status_auto (status_auto_id, clave, descripcion) values (5, 'DEFECTUOSO', 'AUTOS NUEVOS CON DEFECTOS');
insert into status_auto (status_auto_id, clave, descripcion) values (6, 'EN REPARACION', 'PARA AUTOS VENDIDOS EN REPARACION');
commit;
exit
