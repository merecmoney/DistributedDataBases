--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 22/March/2020
--@Descripción: Archivo de carga inicial en pc-carlos.fi.unam
set linesize 2000
Prompt Conectando a S1 - cahabdd_s1
connect bancos_bdd/bancos_bdd@cahabdd_s1
Prompt Realizando conteo de registros
select (
    select count(*)
    from F_CAH_PAIS_1) as PAIS_1,
    (
    select count(*)
    from F_CAH_BANCO_1) as BANCO_1,
    (
    select count(*)
    from F_CAH_EMPLEADO_1) as EMPLEADO_1,
    (
    select count(*)
    from F_CAH_SUCURSAL_1) as SUCURSAL_1,
    (
    select count(*)
    from F_CAH_CUENTA_1) as CUENTA_1,
    (
    select count(*)
    from F_CAH_CUENTA_3) as CUENTA_3,
    (
    select count(*)
    from F_CAH_MOVIMIENTO_2) as MOVIMIENTO_2
from dual;
Prompt Conectando a S2 - cahabdd_s2
connect bancos_bdd/bancos_bdd@cahabdd_s2
select (
    select count(*)
    from F_CAH_PAIS_2) as PAIS_2,
    (
    select count(*)
    from F_CAH_BANCO_2) as BANCO_2,
    (
    select count(*)
    from F_CAH_EMPLEADO_2) as EMPLEADO_2,
    (
    select count(*)
    from F_CAH_SUCURSAL_2) as SUCURSAL_2,
    (
    select count(*)
    from F_CAH_CUENTA_2) as CUENTA_2,
    (
    select count(*)
    from F_CAH_CUENTA_4) as CUENTA_4,
    (
    select count(*)
    from F_CAH_MOVIMIENTO_1) as MOVIMIENTO_1,
    (
    select count(*)
    from F_CAH_MOVIMIENTO_3) as MOVIMIENTO_3
from dual;
Prompt Listo
exit