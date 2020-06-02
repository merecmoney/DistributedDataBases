--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 1/Junio/2020
--@Descripción: Definición de mlogs para la base
-- de datos de replicación.

create materialized view log on agencia with primary key(clave);
create materialized view log on auto with primary key(cliente_id, tipo, agencia_id);
create materialized view log on cliente;
