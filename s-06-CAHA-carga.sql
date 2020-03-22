--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 22/March/2020
--@Descripción: Archivo de carga inicial en pc-carlos.fi.unam
Prompt Conectando a S1 - cahabdd_s1
connect bancos_bdd/bancos_bdd@cahabdd_s1
--si ocurre un error, la ejecución se detiene.
whenever sqlerror exit rollback;
Prompt limpiando.
DELETE FROM F_CAH_MOVIMIENTO_2;
DELETE FROM F_CAH_CUENTA_3;
DELETE FROM F_CAH_SUCURSAL_1;
DELETE FROM F_CAH_BANCO_1;
DELETE FROM F_CAH_CUENTA_1;
DELETE FROM F_CAH_EMPLEADO_1;
DELETE FROM F_CAH_PAIS_1;
Prompt Cargando datos
Prompt Insertando en PAIS
insert into F_CAH_PAIS_1 (PAIS_ID, CLAVE, NOMBRE, ZONA_ECONOMICA)
values (1, 'MX', 'MEXICO', 'A');
Prompt Insertando BANCO
insert into F_CAH_BANCO_1 (BANCO_ID, CLAVE, NOMBRE)
values (1, 'BB003', 'BANCOMER');
Prompt Insertando en EMPLEADO
insert into F_CAH_EMPLEADO_1 (EMPLEADO_ID, NOMBRE, AP_PATERNO, AP_MATERNO, FOLIO_CERTIFICACION, JEFE_ID)
values (1, 'JUAN', 'LOPEZ', 'LARA', NULL, NULL);
Prompt Insertando en Sucursal
insert into F_CAH_SUCURSAL_1 (SUCURSAL_ID, NUM_SUCURSAL, BANCO_ID, PAIS_ID, GERENTE_ID)
values (1, 100, 1, 1, 1);

insert into F_CAH_SUCURSAL_1 (SUCURSAL_ID, NUM_SUCURSAL, BANCO_ID, PAIS_ID, GERENTE_ID)
values (2, 200, 1, 2, 2);
Prompt Insertando Cuenta
insert into F_CAH_CUENTA_1 (CUENTA_ID, NIP, SALDO)
values (1, 1234, 45894.23);

insert into F_CAH_CUENTA_3 (CUENTA_ID, NUM_CUENTA, TIPO_CUENTA, SUCURSAL_ID)
values (1, '800600400', 'D', 1);

insert into F_CAH_CUENTA_1 (CUENTA_ID, NIP, SALDO)
values (2, 4321, 100500.56);
Prompt Insertando Movimientos
insert into F_CAH_MOVIMIENTO_2 (NUM_MOVIMIENTO, CUENTA_ID, FECHA_MOVIMIENTO, TIPO_MOVIMIENTO, IMPORTE, DESCRIPCION, COMPROBANTE)
values (2, 1, TO_DATE('01-01-2015 12:00:15', 'DD-MM-YYYY HH24:MI:SS'), 'D', 500596.25, 'PAGO BONO PRODUCTIVIDAD', empty_blob());
--hacer commit al terminar
commit;
Prompt Conectando a S2 - cahabdd_s2
connect bancos_bdd/bancos_bdd@cahabdd_s2
--si ocurre un error, la ejecución se detiene.
whenever sqlerror exit rollback;
Prompt limpiando.
DELETE FROM F_CAH_MOVIMIENTO_3;
DELETE FROM F_CAH_CUENTA_4;
DELETE FROM F_CAH_SUCURSAL_2;
DELETE FROM F_CAH_BANCO_2;
DELETE FROM F_CAH_CUENTA_2;
DELETE FROM F_CAH_EMPLEADO_2;
DELETE FROM F_CAH_PAIS_2;
DELETE FROM F_CAH_MOVIMIENTO_1;
Prompt Cargando datos
Prompt Insertando en PAIS
insert into F_CAH_PAIS_2 (PAIS_ID, CLAVE, NOMBRE, ZONA_ECONOMICA)
values (2, 'JAP', 'JAPON', 'B');
Prompt Insertando BANCO
insert into F_CAH_BANCO_2 (BANCO_ID, CLAVE, NOMBRE)
values (2, 'SS032', 'BANAMEX');
Prompt Insertando en EMPLEADO
insert into F_CAH_EMPLEADO_2 (EMPLEADO_ID, NOMBRE, AP_PATERNO, AP_MATERNO, FOLIO_CERTIFICACION, JEFE_ID)
values (2, 'CARLOS', 'BAEZ', 'AGUIRRE', 900200, 1);
Prompt Insertando en Sucursal
insert into F_CAH_SUCURSAL_2 (SUCURSAL_ID, NUM_SUCURSAL, BANCO_ID, PAIS_ID, GERENTE_ID)
values (3, 300, 2, 1, 1);

insert into F_CAH_SUCURSAL_2 (SUCURSAL_ID, NUM_SUCURSAL, BANCO_ID, PAIS_ID, GERENTE_ID)
values (4, 400, 2, 2, 2);
Prompt Insertando Cuenta
insert into F_CAH_CUENTA_2 (CUENTA_ID, CONTRATO)
values (1, empty_blob());

insert into F_CAH_CUENTA_2 (CUENTA_ID, CONTRATO)
values (2, empty_blob());

insert into F_CAH_CUENTA_4 (CUENTA_ID, NUM_CUENTA, TIPO_CUENTA, SUCURSAL_ID)
values (2, '900700500', 'V', 4);
Prompt Insertando Movimientos
insert into F_CAH_MOVIMIENTO_1 (NUM_MOVIMIENTO, CUENTA_ID, FECHA_MOVIMIENTO, TIPO_MOVIMIENTO, IMPORTE, DESCRIPCION, COMPROBANTE)
values (1, 1, TO_DATE('01-01-1980 14:55:31', 'DD-MM-YYYY HH24:MI:SS'), 'D', 85745.56, 'PAGO AGUINALDO', empty_blob());

insert into F_CAH_MOVIMIENTO_3 (NUM_MOVIMIENTO, CUENTA_ID, FECHA_MOVIMIENTO, TIPO_MOVIMIENTO, IMPORTE, DESCRIPCION, COMPROBANTE)
values (3, 2, TO_DATE('01-01-2016 19:05:04', 'DD-MM-YYYY HH24:MI:SS'), 'R', 40200.32, 'RETIRO LETRA AUTO', empty_blob());
--hacer commit al terminar
commit;
Prompt Listo!
exit
