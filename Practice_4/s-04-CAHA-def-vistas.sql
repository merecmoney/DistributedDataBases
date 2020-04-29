--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 27/Abril/2020
--@Descripción: Creación de vistas para transparencia de fragmentación

Prompt Creando vista para BANCO
create or replace view banco as
    select banco_id, clave, nombre
        from banco_1
        union all
    select banco_id, clave, nombre
        from banco_2;

Prompt Creando vista para PAIS
create or replace view pais as
    select pais_id, clave, nombre, zona_economica
        from pais_1
        union all
    select pais_id, clave, nombre, zona_economica
        from pais_2;

Prompt Creando vista para SUCURSAL
create or replace view sucursal as
    select sucursal_id, num_sucursal, banco_id, pais_id, gerente_id
        from sucursal_1
        union all
    select sucursal_id, num_sucursal, banco_id, pais_id, gerente_id
        from sucursal_2;

Prompt Creando vista para EMPLEADO
create or replace view empleado as
    select empleado_id, nombre, ap_paterno, ap_materno, folio_certificacion,
    jefe_id
        from empleado_1
    union all
    select empleado_id, nombre, ap_paterno, ap_materno, folio_certificacion,
    jefe_id
        from empleado_2;
