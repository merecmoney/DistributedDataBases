--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 27/Abril/2020
--@Descripción: Conteo de registros en cada objeto en cada PDB
set linesize 2000
Prompt Conectando a S1 - cahabdd_s1
connect bancos_bdd/bancos_bdd@cahabdd_s1
Prompt Realizando conteo de registros
select (
    select count(*)
    from PAIS) as PAIS,
    (
    select count(*)
    from BANCO) as BANCO,
    (
    select count(*)
    from EMPLEADO) as EMPLEADO,
    (
    select count(*)
    from SUCURSAL) as SUCURSAL,
    (
    select count(*)
    from CUENTA) as CUENTA,
    (
    select count(*)
    from MOVIMIENTO) as MOVIMIENTO
from dual;
Prompt Conectando a S2 - cahabdd_s2
connect bancos_bdd/bancos_bdd@cahabdd_s2
select (
    select count(*)
    from PAIS) as PAIS,
    (
    select count(*)
    from BANCO) as BANCO,
    (
    select count(*)
    from EMPLEADO) as EMPLEADO,
    (
    select count(*)
    from SUCURSAL) as SUCURSAL,
    (
    select count(*)
    from CUENTA) as CUENTA,
    (
    select count(*)
    from MOVIMIENTO) as MOVIMIENTO
from dual;
Prompt Listo
exit