--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 27/Abril/2020
--@Descripción: Definición de vistas para manejo de BLOBs en la PDB jrcbd_s2
Prompt connectando a cahabdd_s1
connect bancos_bdd/bancos_bdd@cahabdd_s2
prompt ---
Prompt Paso 1. creando vistas con columnas BLOB locales.
prompt ---

create or replace view cuenta as
    select c2.cuenta_id, c3.num_cuenta, c3.tipo_cuenta, c1.nip, c1.saldo, c2.contrato,
    c3.sucursal_id
        from cuenta_2 c2
    join cuenta_1 c1
        on c1.cuenta_id = c2.cuenta_id
    join
    (select cuenta_id, num_cuenta, tipo_cuenta, sucursal_id
        from cuenta_3
        union all
    select cuenta_id, num_cuenta, tipo_cuenta, sucursal_id
        from cuenta_4) c3
        on c2.cuenta_id = c3.cuenta_id;

prompt ---
Prompt Paso 2 creando objetos type para vistas que involucran BLOBs remotos
prompt ---

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

create type movimiento_table as table of movimiento_type;
/
show errors;

prompt ---
Prompt Paso 4 creando tablas temporales para vistas que involucran BLOBs remotos
prompt ---

-- Omitimos las constraints de referencia de las tablas originales ya que sería
-- transmitir más datos innecesarios, por cada inserción checar si existe
-- la referencia, además no es necesario ya que sólo queremos copiar
-- y después posteriormente borrar los datos

create global temporary table t_caha_movimiento_2 (
    num_movimiento number(10, 0) not null,
    cuenta_id number(10, 0) not null,
    fecha_movimiento date not null,
    tipo_movimiento char(1) not null,
    importe number(18, 2) not null,
    descripcion varchar2(2000) not null,
    comprobante blob,
    constraint t_caha_movimiento_2_pk primary key (num_movimiento, cuenta_id)
) on commit preserve rows;

prompt ---
Prompt Paso 5 Creando funcion con estrategia 1 para vistas que involucran BLOBs remotos
prompt ---


create or replace function get_remote_comprobante_m2 return movimiento_table pipelined is

    pragma autonomous_transaction;
    v_temp_comprobante  BLOB;

begin
    --Inicia txn autónoma 1.
    --asegura que no haya registros
    delete from t_caha_movimiento_2;
    --inserta los datos obtenidos del fragmento remoto a la tabla temporal.
    insert into t_caha_movimiento_2
    select num_movimiento, cuenta_id, fecha_movimiento, tipo_movimiento,
    importe, descripcion, comprobante
    from movimiento_2;
    --termina txn autónoma 1 antes de iniciar con la construcción del objeto cuenta_table
    commit;
    --obtiene los registros de la tabla temporal y los regresa como objetos tipo
    for cur in (select num_movimiento, cuenta_id, fecha_movimiento, tipo_movimiento,
    importe, descripcion, comprobante
    from t_caha_movimiento_2)
    loop
        pipe row(movimiento_type(cur.num_movimiento, cur.cuenta_id,
            cur.fecha_movimiento, cur.tipo_movimiento,
            cur.importe, cur.descripcion, cur.comprobante));
    end loop;
    --Inicia txn autónoma 2 para limpiar la tabla
    --elimina los registros de la tabla temporal una vez que han sido obtenidos.
    delete from t_caha_movimiento_2;
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

create or replace function get_remote_comprobante_2_by_id (
    v_num_movimiento IN NUMBER, v_cuenta_id IN NUMBER
)
return BLOB is

    pragma autonomous_transaction;
    v_temp_comprobante  BLOB;

begin
    --Inicia txn autónoma 1.
    --asegura que no haya registros
    delete from t_caha_movimiento_2;
    --inserta los datos obtenidos del fragmento remoto a la tabla temporal.
    insert into t_caha_movimiento_2
    select num_movimiento, cuenta_id, fecha_movimiento, tipo_movimiento,
    importe, descripcion, comprobante
    from movimiento_2;
    --termina txn autónoma 1 antes de iniciar con la construcción del objeto cuenta_table
    commit;
    --obtiene los registros de la tabla temporal y los regresa como objetos tipo
    select comprobante into v_temp_comprobante from movimiento_2
    where num_movimiento = v_num_movimiento and
    cuenta_id = v_cuenta_id;
    --Inicia txn autónoma 2 para limpiar la tabla
    --elimina los registros de la tabla temporal una vez que han sido obtenidos.
    delete from t_caha_movimiento_2;
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

create or replace view movimiento_e1 as
    select num_movimiento, cuenta_id, fecha_movimiento, tipo_movimiento,
    importe, descripcion, comprobante
        from movimiento_1
    union all
    select num_movimiento, cuenta_id, fecha_movimiento, tipo_movimiento,
    importe, descripcion, comprobante
        from table(get_remote_comprobante_m2)
    union all
    select num_movimiento, cuenta_id, fecha_movimiento, tipo_movimiento,
    importe, descripcion, comprobante
        from movimiento_3;

prompt ---
Prompt Paso 8 Crear las vistas con datos BLOB remotos empleando estrategia 2
prompt ---

create or replace view movimiento_e2 as
    select num_movimiento, cuenta_id, fecha_movimiento, tipo_movimiento,
    importe, descripcion, comprobante
        from movimiento_1
    union all
    select num_movimiento, cuenta_id, fecha_movimiento, tipo_movimiento,
    importe, descripcion,
    get_remote_comprobante_2_by_id(num_movimiento, cuenta_id) comprobante
        from movimiento_2
    union all
    select num_movimiento, cuenta_id, fecha_movimiento, tipo_movimiento,
    importe, descripcion, comprobante
        from movimiento_3;

Prompt Paso 9 Crear un sinonimo con el nombre global del fragmento que apunte a la estrategia 2.
prompt ---

create or replace synonym movimiento for movimiento_e2;

Prompt Listo!
exit