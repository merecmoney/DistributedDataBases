--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 14/Mayo/2020
--@Descripción: Definición de las 2 tablas temporales:
-- t_cuenta_insert y t_movimiento_insert que serán empleadas por el trigger que
-- implementará transparencia DML para ambos nodos.
Prompt conectandose a cahabdd_s1
connect bancos_bdd/bancos_bdd@cahabdd_s1
Prompt definción de la tabla temporal t_cuenta_insert

create global temporary table t_cuenta_insert (
    cuenta_id number(10, 0) constraint t_cuenta_insert_pk primary key,
    contrato blob not null
) on commit preserve rows;

Prompt definción de la tabla temporal t_movimiento_insert

create global temporary table t_movimiento_insert (
    num_movimiento number(10, 0) not null,
    cuenta_id number(10, 0) not null,
    fecha_movimiento date not null,
    tipo_movimiento char(1) not null,
    importe number(18, 2) not null,
    descripcion varchar2(2000) not null,
    comprobante blob,
    constraint t_movimiento_insert primary key(num_movimiento, cuenta_id)
) on commit preserve rows;

Prompt conectandose a cahabdd_s2
connect bancos_bdd/bancos_bdd@cahabdd_s2

Prompt definción de la tabla temporal t_movimiento_insert

create global temporary table t_movimiento_insert (
    num_movimiento number(10, 0) not null,
    cuenta_id number(10, 0) not null,
    fecha_movimiento date not null,
    tipo_movimiento char(1) not null,
    importe number(18, 2) not null,
    descripcion varchar2(2000) not null,
    comprobante blob,
    constraint t_movimiento_insert primary key(num_movimiento, cuenta_id)
) on commit preserve rows;

prompt Listo
exit