--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 1/Junio/2020
--@Descripción: Nuevo DDL para las vistas materializadas

prompt conectando a cahabdd_s1
connect caha_replica_bdd/caha_replica_bdd@cahabdd_s1

--inserción nueva agencia
insert into AGENCIA (agencia_id, nombre, clave, agencia_anexa_id) values (101,
    'BETO', 'AR-110-M', null);

-- inserción de un nuevo cliente
insert into cliente (cliente_id, nombre, ap_paterno, ap_materno,
    num_identificacion, email)
values (701, 'Ellswerth', 'Alcide', 'Woodlands', 'FNA352631VLHWG1800',
    'ewoodlands0@gmail.gov');

-- inserción de un nuevo auto
insert into AUTO (auto_id, modelo, marca, anio, num_serie, tipo, precio,
    fecha_status, agencia_id, status_auto_id, foto, cliente_id)
values (300, 'Ceed Sporty Wagon', 'Gmc', 2014, 'ARS522066WERVQ962312', 'P',
    '623261.17', to_date('2010-01-01', 'yyyy-mm-dd')+dbms_random.value(1,365*6),
    101, 3, empty_blob(), 600);

commit;
exit;
