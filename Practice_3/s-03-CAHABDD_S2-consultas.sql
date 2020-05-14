--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 9/Abril/2020
--@Descripción: Conteo de los registros en cada tabla
-- usando transparencia de Mapeo Locales.

prompt conectando a cahabdd_s2
connect bancos_bdd/bancos_bdd@cahabdd_s2
prompt Realizando conteo de registros
--La consulta se lanza en cahabdd_s2
set serveroutput on
declare
    v_num_bancos number;
    v_num_paises number;
    v_num_sucursales number;
    v_num_empleados number;
    v_num_cuentas number;
    v_num_movimientos number;
begin
    dbms_output.put_line('Realizando consultas empleando ligas');

    -- consultando el número de bancos
    select count(*)
        into v_num_bancos
        from (
            select BANCO_ID
            from F_CAH_BANCO_2
            union all
            select BANCO_ID
            from F_CAH_BANCO_1@cahabdd_s1.fi.unam
        ) BANCO;

    --consultando el número de países
    select count(*)
        into v_num_paises
        from (
            select PAIS_ID
            from F_CAH_PAIS_2
            union all
            select PAIS_ID
            from F_CAH_PAIS_1@cahabdd_s1.fi.unam
        ) PAIS;

    -- consultando el número de sucursales
    select count(*)
        into v_num_sucursales
        from (
            select SUCURSAL_ID
            from F_CAH_SUCURSAL_2
            union all
            select SUCURSAL_ID
            from F_CAH_SUCURSAL_1@cahabdd_s1.fi.unam
        ) SUCURSAL;

    -- consultando el número de empleados
    select count(*)
        into v_num_empleados
        from (
            select EMPLEADO_ID
            from F_CAH_EMPLEADO_2
            union all
            select EMPLEADO_ID
            from F_CAH_EMPLEADO_1@cahabdd_s1.fi.unam
        ) EMPLEADOS;

    -- consultando el número de cuentas
    select count(*)
      into v_num_cuentas
      from (
        select CUENTA_ID
        from F_CAH_CUENTA_4
        union all
        select CUENTA_ID
        from F_CAH_CUENTA_3@cahabdd_s1.fi.unam
      ) CUENTA;

    -- consultando el número de cuentas
    select count(*)
      into v_num_cuentas
      from F_CAH_CUENTA_2;

    -- consultando el número de cuentas
    select count(*)
      into v_num_cuentas
      from (
        select c1.CUENTA_ID
        from F_CAH_CUENTA_2 c2
        join F_CAH_CUENTA_1@cahabdd_s1.fi.unam c1
        on c2.CUENTA_ID = c1.CUENTA_ID
        join
        (select CUENTA_ID
          from F_CAH_CUENTA_4
          union all
          select CUENTA_ID
          from F_CAH_CUENTA_3@cahabdd_s1.fi.unam
        ) c3
        on c2.CUENTA_ID = c3.CUENTA_ID
      ) CUENTA;

    -- consultando el número de movimientos
    select count(*)
        into v_num_movimientos
        from (
            select NUM_MOVIMIENTO
            from F_CAH_MOVIMIENTO_1
            union all
            select NUM_MOVIMIENTO
            from F_CAH_MOVIMIENTO_3
            union all
            select NUM_MOVIMIENTO
            from F_CAH_MOVIMIENTO_2@cahabdd_s1.fi.unam
        ) MOVIMIENTO;

    dbms_output.put_line('Resultado del conteo de registros');
    dbms_output.put_line('Paises: ' || v_num_paises);
    dbms_output.put_line('Bancos: ' || v_num_bancos);
    dbms_output.put_line('Sucursales: ' || v_num_sucursales);
    dbms_output.put_line('Empleados: ' || v_num_empleados);
    dbms_output.put_line('Cuentas: ' || v_num_cuentas);
    dbms_output.put_line('Movimientos: ' || v_num_movimientos);
end;
/
Prompt Listo
exit
