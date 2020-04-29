--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 27/Abril/2020
--@Descripción: Definición de vistas para manejo de BLOBs en la PDB jrcbd_s2
Prompt connectando a cahabdd_s1
connect bancos_bdd/bancos_bdd@cahabdd_s1
prompt ---
Prompt Paso 1. creando vistas con columnas BLOB locales.

Prompt Paso 2 creando objetos type para vistas que involucran BLOBs remotos
prompt ---

create type cuenta_type as object (
    cuenta_id number(10, 0),
    contrato blob
);
/
show errors;

create type movimiento_type as object (
    num_movimiento number(10, 0),
    cuenta_id number(10, 0),
    fecha_movimiento date,
    tipo_movimiento char(1),
    importe number(18, 2),
    descripcion varchar2(2000),
    comprobante blob
);
/
show errors;

prompt ---
Prompt Paso 3 creando objetos table para vistas que involucran BLOBs remotos
prompt ---

create type cuenta_table as table of cuenta_type;
/
show errors;

create type movimiento_table as table of movimiento_type;
/
show errors;

prompt ---
Prompt Paso 4 creando tablas temporales para vistas que involucran BLOBs remotos
prompt ---

create global temporary table t_caha_cuenta_2 (
    cuenta_id number(10, 0) constraint t_caha_cuenta_2_pk primary key,
    contrato blob not null
) on commit preserve rows;

-- Omitimos las constraints de referencia de las tablas originales ya que sería
-- transmitir más datos innecesarios, por cada inserción checar si existe
-- la referencia, además no es necesario ya que sólo queremos copiar
-- y después posteriormente borrar los datos

create global temporary table t_caha_movimiento_1 (
    num_movimiento number(10, 0) not null,
    cuenta_id number(10, 0) not null,
    fecha_movimiento date not null,
    tipo_movimiento char(1) not null,
    importe number(18, 2) not null,
    descripcion varchar2(2000) not null,
    comprobante blob,
    constraint t_caha_movimiento_1_pk primary key (num_movimiento, cuenta_id)
) on commit preserve rows;

create global temporary table t_caha_movimiento_3 (
    num_movimiento number(10, 0) not null,
    cuenta_id number(10, 0) not null,
    fecha_movimiento date not null,
    tipo_movimiento char(1) not null,
    importe number(18, 2) not null,
    descripcion varchar2(2000) not null,
    comprobante blob,
    constraint t_caha_movimiento_3_pk primary key (num_movimiento, cuenta_id)
) on commit preserve rows;

prompt ---
Prompt Paso 5 Creando funcion con estrategia 1 para vistas que involucran BLOBs remotos
prompt ---

create or replace function get_remote_contrato return cuenta_table pipelined is

    pragma autonomous_transaction;
    v_temp_contrato  BLOB;

begin
    --Inicia txn autónoma 1.
    --asegura que no haya registros
    delete from t_caha_cuenta_2;
    --inserta los datos obtenidos del fragmento remoto a la tabla temporal.
    insert into t_caha_cuenta_2 select cuenta_id, contrato from cuenta_2;
    --termina txn autónoma 1 antes de iniciar con la construcción del objeto cuenta_table
    commit;
    --obtiene los registros de la tabla temporal y los regresa como objetos tipo cuenta_type
    for cur in (select cuenta_id, contrato from t_caha_cuenta_2) loop
        pipe row(cuenta_type(cur.cuenta_id, cur.contrato));
    end loop;
    --Inicia txn autónoma 2 para limpiar la tabla
    --elimina los registros de la tabla temporal una vez que han sido obtenidos.
    delete from t_caha_cuenta_2;
    --termina txn autónoma 2
    commit;
    return;

exception
    when others then
    --termina txn autónoma en caso de ocurrir un error
    rollback;
    --reelanza el error para que sea propagado a quien invoque a esta función
    raise;
end;
/
show errors;

create or replace function get_remote_comprobante_m1 return movimiento_table pipelined is

    pragma autonomous_transaction;
    v_temp_comprobante  BLOB;

begin
    --Inicia txn autónoma 1.
    --asegura que no haya registros
    delete from t_caha_movimiento_1;
    --inserta los datos obtenidos del fragmento remoto a la tabla temporal.
    insert into t_caha_movimiento_1
    select num_movimiento, cuenta_id, fecha_movimiento, tipo_movimiento,
    importe, descripcion, comprobante
    from movimiento_1;
    --termina txn autónoma 1 antes de iniciar con la construcción del objeto cuenta_table
    commit;
    --obtiene los registros de la tabla temporal y los regresa como objetos tipo
    for cur in (select num_movimiento, cuenta_id, fecha_movimiento, tipo_movimiento,
    importe, descripcion, comprobante
    from t_caha_movimiento_1)
    loop
        pipe row(movimiento_type(cur.num_movimiento, cur.cuenta_id,
            cur.fecha_movimiento, cur.tipo_movimiento,
            cur.importe, cur.descripcion, cur.comprobante));
    end loop;
    --Inicia txn autónoma 2 para limpiar la tabla
    --elimina los registros de la tabla temporal una vez que han sido obtenidos.
    delete from t_caha_movimiento_1;
    --termina txn autónoma 2
    commit;
    return;

exception
    when others then
    --termina txn autónoma en caso de ocurrir un error
    rollback;
    --reelanza el error para que sea propagado a quien invoque a esta función
    raise;
end;
/
show errors;

create or replace function get_remote_comprobante_m3 return movimiento_table pipelined is

    pragma autonomous_transaction;
    v_temp_comprobante  BLOB;

begin
    --Inicia txn autónoma 1.
    --asegura que no haya registros
    delete from t_caha_movimiento_3;
    --inserta los datos obtenidos del fragmento remoto a la tabla temporal.
    insert into t_caha_movimiento_3
    select num_movimiento, cuenta_id, fecha_movimiento, tipo_movimiento,
    importe, descripcion, comprobante
    from movimiento_3;
    --termina txn autónoma 1 antes de iniciar con la construcción del objeto cuenta_table
    commit;
    --obtiene los registros de la tabla temporal y los regresa como objetos tipo
    for cur in (select num_movimiento, cuenta_id, fecha_movimiento, tipo_movimiento,
    importe, descripcion, comprobante
    from t_caha_movimiento_3)
    loop
        pipe row(movimiento_type(cur.num_movimiento, cur.cuenta_id,
            cur.fecha_movimiento, cur.tipo_movimiento,
            cur.importe, cur.descripcion, cur.comprobante));
    end loop;
    --Inicia txn autónoma 2 para limpiar la tabla
    --elimina los registros de la tabla temporal una vez que han sido obtenidos.
    delete from t_caha_movimiento_3;
    --termina txn autónoma 2
    commit;
    return;

exception
    when others then
    --termina txn autónoma en caso de ocurrir un error
    rollback;
    --reelanza el error para que sea propagado a quien invoque a esta función
    raise;
end;
/
show errors;

prompt ---
Prompt Paso 6 Creando funcion con estrategia 2 para vistas que involucran BLOBs remotos
prompt ---

create or replace function get_remote_contrato_by_id (
    v_cuenta_id in number
)
return blob is

    pragma autonomous_transaction;
    v_temp_contrato  BLOB;

begin
    --Inicia txn autónoma 1.
    --asegura que no haya registros
    delete from t_caha_cuenta_2;
    --inserta los datos obtenidos del fragmento remoto a la tabla temporal.
    insert into t_caha_cuenta_2 select cuenta_id, contrato
    from cuenta_2 where cuenta_id = v_cuenta_id;
    --termina txn autónoma 1 antes de iniciar con la construcción del objeto cuenta_table
    commit;
    --obtiene los registros de la tabla temporal y los regresa como objetos tipo cuenta_type
    select contrato into v_temp_contrato from t_caha_cuenta_2
    where cuenta_id = v_cuenta_id;
    --Inicia txn autónoma 2 para limpiar la tabla
    --elimina los registros de la tabla temporal una vez que han sido obtenidos.
    delete from t_caha_cuenta_2;
    --termina txn autónoma 2
    commit;
    return v_temp_contrato;

exception
    when others then
    --termina txn autónoma en caso de ocurrir un error
    rollback;
    --reelanza el error para que sea propagado a quien invoque a esta función
    raise;
end;
/
show errors;

create or replace function get_remote_comprobante_1_by_id (
    v_num_movimiento IN NUMBER, v_cuenta_id IN NUMBER
)
return BLOB is

    pragma autonomous_transaction;
    v_temp_comprobante  BLOB;

begin
    --Inicia txn autónoma 1.
    --asegura que no haya registros
    delete from t_caha_movimiento_1;
    --inserta los datos obtenidos del fragmento remoto a la tabla temporal.
    insert into t_caha_movimiento_1
    select num_movimiento, cuenta_id, fecha_movimiento, tipo_movimiento,
    importe, descripcion, comprobante
    from movimiento_1;
    --termina txn autónoma 1 antes de iniciar con la construcción del objeto cuenta_table
    commit;
    --obtiene los registros de la tabla temporal y los regresa como objetos tipo
    select comprobante into v_temp_comprobante from movimiento_1
    where num_movimiento = v_num_movimiento and
    cuenta_id = v_cuenta_id;
    --Inicia txn autónoma 2 para limpiar la tabla
    --elimina los registros de la tabla temporal una vez que han sido obtenidos.
    delete from t_caha_movimiento_1;
    --termina txn autónoma 2
    commit;
    return v_temp_comprobante;

exception
    when others then
    --termina txn autónoma en caso de ocurrir un error
    rollback;
    --reelanza el error para que sea propagado a quien invoque a esta función
    raise;
end;
/
show errors;

create or replace function get_remote_comprobante_3_by_id (
    v_num_movimiento IN NUMBER, v_cuenta_id IN NUMBER
)
return BLOB is

    pragma autonomous_transaction;
    v_temp_comprobante  BLOB;

begin
    --Inicia txn autónoma 1.
    --asegura que no haya registros
    delete from t_caha_movimiento_3;
    --inserta los datos obtenidos del fragmento remoto a la tabla temporal.
    insert into t_caha_movimiento_3
    select num_movimiento, cuenta_id, fecha_movimiento, tipo_movimiento,
    importe, descripcion, comprobante
    from movimiento_3;
    --termina txn autónoma 1 antes de iniciar con la construcción del objeto cuenta_table
    commit;
    --obtiene los registros de la tabla temporal y los regresa como objetos tipo
    select comprobante into v_temp_comprobante from movimiento_3
    where num_movimiento = v_num_movimiento and
    cuenta_id = v_cuenta_id;
    --Inicia txn autónoma 2 para limpiar la tabla
    --elimina los registros de la tabla temporal una vez que han sido obtenidos.
    delete from t_caha_movimiento_3;
    --termina txn autónoma 2
    commit;
    return v_temp_comprobante;

exception
    when others then
    --termina txn autónoma en caso de ocurrir un error
    rollback;
    --reelanza el error para que sea propagado a quien invoque a esta función
    raise;
end;
/
show errors;

prompt ---
Prompt Paso 7 Crear las vistas con datos BLOB remotos empleando estrategia 1
prompt ---

create or replace view cuenta_e1 as
    select c1.cuenta_id, c3.tipo_cuenta, c1.nip, c1.saldo, c2.contrato,
    c3.sucursal_id
        from cuenta_1 c1
    join (
        select cuenta_id, contrato
        from table(get_remote_contrato)
    ) c2
        on c1.cuenta_id = c2.cuenta_id
    join
    (select cuenta_id, num_cuenta, tipo_cuenta, sucursal_id
        from cuenta_3
        union all
    select cuenta_id, num_cuenta, tipo_cuenta, sucursal_id
        from cuenta_4) c3
        on c1.cuenta_id = c3.cuenta_id;

create or replace view movimiento_e1 as
    select num_movimiento, cuenta_id, fecha_movimiento, tipo_movimiento,
    importe, descripcion, comprobante
        from table(get_remote_comprobante_m1)
    union all
    select num_movimiento, cuenta_id, fecha_movimiento, tipo_movimiento,
    importe, descripcion, comprobante
        from movimiento_2
    union all
    select num_movimiento, cuenta_id, fecha_movimiento, tipo_movimiento,
    importe, descripcion, comprobante
        from table(get_remote_comprobante_m3);

prompt ---
Prompt Paso 8 Crear las vistas con datos BLOB remotos empleando estrategia 2
prompt ---

create or replace view cuenta_e2 as
    select c1.cuenta_id, c3.num_cuenta, c3.tipo_cuenta, c1.nip, c1.saldo,
    get_remote_contrato_by_id(c1.cuenta_id) as contrato, c3.sucursal_id
    from cuenta_1 c1
    join
    (select cuenta_id, num_cuenta, tipo_cuenta, sucursal_id
        from cuenta_3
        union all
    select cuenta_id, num_cuenta, tipo_cuenta, sucursal_id
        from cuenta_4) c3
        on c1.cuenta_id = c3.cuenta_id;

create or replace view movimiento_e2 as
    select num_movimiento, cuenta_id, fecha_movimiento, tipo_movimiento,
    importe, descripcion,
    get_remote_comprobante_1_by_id(num_movimiento, cuenta_id) comprobante
        from movimiento_1
    union all
    select num_movimiento, cuenta_id, fecha_movimiento, tipo_movimiento,
    importe, descripcion, comprobante
        from movimiento_2
    union all
    select num_movimiento, cuenta_id, fecha_movimiento, tipo_movimiento,
    importe, descripcion,
    get_remote_comprobante_3_by_id(num_movimiento, cuenta_id) comprobante
        from movimiento_3;

Prompt Paso 9 Crear un sinonimo con el nombre global del fragmento que apunte a la estrategia 2.
prompt ---

create or replace synonym cuenta for cuenta_e2;
create or replace synonym movimiento for movimiento_e2;
Prompt Listo!
exit