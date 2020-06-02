-- 
-- table: agencia 
--

create table agencia(
    agencia_id          number(10, 0)    not null,
    nombre              varchar2(40)     not null,
    clave               varchar2(8)      not null,
    agencia_anexa_id    number(10, 0),
    constraint agencia_pk primary key (agencia_id), 
    constraint agencia_anexa_id_fk foreign key (agencia_anexa_id)
    references agencia(agencia_id)
)
;



-- 
-- table: cliente 
--

create table cliente(
    cliente_id            number(10, 0)    not null,
    nombre                varchar2(40)     not null,
    ap_paterno            varchar2(40)     not null,
    ap_materno            varchar2(40),
    num_identificacion    varchar2(18)     not null,
    email                 varchar2(500)    not null,
    constraint cliente_pk primary key (cliente_id)
)
;



-- 
-- table: status_auto 
--

create table status_auto(
    status_auto_id    number(2, 0)    not null,
    clave             varchar2(20)    not null,
    descripcion       varchar2(40)    not null,
    constraint status_auto_pk primary key (status_auto_id)
)
;



-- 
-- table: auto 
--

create table auto(
    auto_id           number(10, 0)    not null,
    marca             varchar2(40)     not null,
    modelo            varchar2(40)     not null,
    anio              number(4, 0)     not null,
    num_serie         varchar2(20)     not null,
    tipo              char(1)          not null,
    precio            number(9, 2)     not null,
    descuento         number(9, 2),
    foto              blob             not null,
    fecha_status      timestamp(6)     not null,
    status_auto_id    number(2, 0)     not null,
    agencia_id        number(10, 0)    not null,
    cliente_id        number(10, 0),
    constraint auto_pk primary key (auto_id), 
    constraint auto_agencia_id_fk foreign key (agencia_id)
    references agencia(agencia_id),
    constraint auto_cliente_id_fk foreign key (cliente_id)
    references cliente(cliente_id),
    constraint auto_status_id_fk foreign key (status_auto_id)
    references status_auto(status_auto_id)
)
;



-- 
-- table: historico_status_auto 
--

create table historico_status_auto(
    historico_status_id    number(10, 0)    not null,
    fecha_status           timestamp(6)     not null,
    status_auto_id         number(2, 0)     not null,
    auto_id                number(10, 0)    not null,
    constraint historico_status_auto_pk primary key (historico_status_id), 
    constraint hist_status_auto_status_id_fk foreign key (status_auto_id)
    references status_auto(status_auto_id),
    constraint historico_status_auto_id_fk foreign key (auto_id)
    references auto(auto_id)
)
;



-- 
-- table: orden_compra 
--

create table orden_compra(
    orden_compra_id     number(10, 0)    not null,
    fecha_compra        date,
    num_cuenta_banco    varchar2(50),
    cliente_id          number(10, 0)    not null,
    constraint orden_compra_pk primary key (orden_compra_id), 
    constraint orden_compra_cliente_id_fk foreign key (cliente_id)
    references cliente(cliente_id)
)
;



-- 
-- table: pago_auto 
--

create table pago_auto(
    num_pago           number(3, 0)     not null,
    orden_compra_id    number(10, 0)    not null,
    fecha_pago         date,
    importe            number(10, 2),
    constraint pago_auto_pk primary key (num_pago, orden_compra_id), 
    constraint pago_auto_orden_compra_id_fk foreign key (orden_compra_id)
    references orden_compra(orden_compra_id)
)
;



-- 
-- index: auto_num_serie_uk 
--

create unique index auto_num_serie_uk on auto(num_serie)
;
-- 
-- index: cliente_email_uk 
--

create unique index cliente_email_uk on cliente(num_identificacion, email)
;
