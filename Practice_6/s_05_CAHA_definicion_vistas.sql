--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 1/Junio/2020
--@Descripción: Definición de vistas materializadas para la base
-- de datos de replicación.

-- vista materializada que muestra todos los datos de agencia cuyo primer
-- carácter de su clave esté en el rango [A-F].
create materialized view mv_agencia
refresh fast with primary key as
    select *
    from agencia@cahabdd_s1_master
    where substr(clave, 1,1) between 'A' and 'F';

-- vista materializada mv_auto. Incluir los atributos de auto: auto_id,
-- marca, modelo, anio, num_serie, tipo, precio, descuento, agencia_id,
-- cliente_id. Los autos mostrados deberán pertenecer a las agencias que
-- fueron incluidas en mv_agencia.
-- Adicional a esto, solo incluir a los autos particulares (tipo = P).
create materialized view mv_auto
refresh fast with primary key as
    select auto_id, marca, modelo, anio, num_serie, tipo, precio,
        descuento, agencia_id, cliente_id
    from auto@cahabdd_s1_master master_auto
    where master_auto.tipo = 'P' and
    exists (
        select 1
        from agencia@cahabdd_s1_master master_agencia
        where master_auto.agencia_id = master_agencia.agencia_id
        and substr(clave, 1,1) between 'A' and 'F'
    );


-- vista materializada mv_cliente, sólo para los clientes cuyos autos
-- están en mv_auto o aquellos cuyo correo electrónico sea del dominio .gov
create materialized view mv_cliente
refresh fast with primary key as
    select *
    from cliente@cahabdd_s1_master master_cliente
    where exists (
        select 1
        from auto@cahabdd_s1_master master_auto
        where master_cliente.cliente_id = master_auto.cliente_id
        and master_auto.tipo = 'P' and
        exists (
            select 1
            from agencia@cahabdd_s1_master master_agencia
            where master_auto.agencia_id = master_agencia.agencia_id
            and substr(master_agencia.clave, 1,1) between 'A' and 'F'
        )
    )
    UNION
    select *
    from cliente@cahabdd_s1_master master_cliente
    where master_cliente.email like '%.gov';
