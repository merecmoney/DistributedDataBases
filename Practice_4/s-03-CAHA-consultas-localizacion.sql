--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 27/Abril/2020
--@Descripción: Conteo de los registros en cada tabla
-- usando transparencia de Localización.

declare
    v_num_bancos number;
    v_num_paises number;
    v_num_sucursales number;
    v_num_empleados number;
    v_num_cuentas number;
    v_num_movimientos number;
begin
    dbms_output.put_line('Realizando consulta empleando sinonimos');

    -- consultando el número de bancos
    select count(*)
        into v_num_bancos
        from (
            select BANCO_ID
            from BANCO_1
            union all
            select BANCO_ID
            from BANCO_2
        ) BANCO;

    --consultando el número de países
    select count(*)
        into v_num_paises
        from (
            select PAIS_ID
            from PAIS_1
            union all
            select PAIS_ID
            from PAIS_2
        ) PAIS;

    -- consultando el número de sucursales
    select count(*)
        into v_num_sucursales
        from (
            select SUCURSAL_ID
            from SUCURSAL_1
            union all
            select SUCURSAL_ID
            from SUCURSAL_2
        ) SUCURSAL;

    -- consultando el número de empleados
    select count(*)
        into v_num_empleados
        from (
            select EMPLEADO_ID
            from EMPLEADO_1
            union all
            select EMPLEADO_ID
            from EMPLEADO_2
        ) EMPLEADOS;

    -- consultando el número de cuentas
    select count(*)
      into v_num_cuentas
      from (
        select CUENTA_ID
        from CUENTA_3
        union all
        select CUENTA_ID
        from CUENTA_4
      ) CUENTA;

    -- consultando el número de cuentas
    select count(*)
      into v_num_cuentas
      from CUENTA_1;

    -- consultando el número de cuentas
    select count(*)
      into v_num_cuentas
      from (
        select c1.CUENTA_ID
        from CUENTA_1 c1
        join CUENTA_2 c2
        on c1.CUENTA_ID = c2.CUENTA_ID
        join
        (select CUENTA_ID
          from CUENTA_3
          union all
          select CUENTA_ID
          from CUENTA_4
        ) c3
        on c1.CUENTA_ID = c3.CUENTA_ID
      ) CUENTA;

    -- consultando el número de movimientos
    select count(*)
        into v_num_movimientos
        from (
            select NUM_MOVIMIENTO
            from MOVIMIENTO_2
            union all
            select NUM_MOVIMIENTO
            from MOVIMIENTO_1
            union all
            select NUM_MOVIMIENTO
            from MOVIMIENTO_3
        ) MOVIMIENTO;

    dbms_output.put_line('Resultado del conteo de registros');
    dbms_output.put_line('==================================');
    dbms_output.put_line('Paises: ' || v_num_paises);
    dbms_output.put_line('Bancos: ' || v_num_bancos);
    dbms_output.put_line('Sucursales: ' || v_num_sucursales);
    dbms_output.put_line('Empleados: ' || v_num_empleados);
    dbms_output.put_line('Cuentas: ' || v_num_cuentas);
    dbms_output.put_line('Movimientos: ' || v_num_movimientos);
end;
/
Prompt Listo
