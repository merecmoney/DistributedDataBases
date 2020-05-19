--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 14/Mayo/2020
--@Descripción: Creación del trigger para la vista MOVIMIENTO
-- soporta las operaciones DML INSERT, UPDATE, DELETE
-- para el cahabdd_s1

create or replace trigger t_dml_movimiento
instead of insert or delete or update on movimiento

declare
    v_count number;
    v_fecha_movimiento char(10);
begin
    case
        when inserting then
            -- checar la fecha para ver en que fragmento se hará la inserción
            v_fecha_movimiento := TO_CHAR(:new.fecha_movimiento, 'YYYY-MM-DD');

            dbms_output.put_line('Fecha del nuevo movimiento ' || v_fecha_movimiento);

            -- movimientos después o igual al 2000
            if v_fecha_movimiento >= '2000-01-01' then
                -- verificación si hay correspondencia local para evitar
                -- acceso remoto
                select count(*)
                into v_count
                from cuenta_3
                where cuenta_id = :new.cuenta_id;

                -- inserción en MOVIMIENTO 2
                if v_count > 0 then
                    insert into movimiento_2 (num_movimiento, cuenta_id,
                     fecha_movimiento, tipo_movimiento, importe, descripcion,
                     comprobante)
                    values (:new.num_movimiento, :new.cuenta_id,
                     :new.fecha_movimiento, :new.tipo_movimiento,
                     :new.importe, :new.descripcion, :new.comprobante);
                else
                    select count(*)
                    into v_count
                    from cuenta_4
                    where cuenta_id = :new.cuenta_id;

                    -- inserción en MOVIMIENTO 3
                    if v_count > 0 then
                        insert into t_movimiento_insert (num_movimiento, cuenta_id,
                        fecha_movimiento, tipo_movimiento, importe, descripcion,
                        comprobante)
                        values (:new.num_movimiento, :new.cuenta_id,
                        :new.fecha_movimiento, :new.tipo_movimiento,
                        :new.importe, :new.descripcion, :new.comprobante);

                        insert into movimiento_3
                        select *
                         from t_movimiento_insert
                         where num_movimiento = :new.num_movimiento
                         and cuenta_id = :new.cuenta_id;

                        delete from t_movimiento_insert
                        where num_movimiento = :new.num_movimiento
                        and cuenta_id = :new.cuenta_id;
                    else
                        raise_application_error(-20001,
                        'Error de Integridad para el campo CUENTA_ID: '
                        || :new.cuenta_id
                        || ' No se encontró el registro padre en los fragmentos');
                    end if;
                end if;
            else
                select count(*)
                into v_count
                from cuenta_2
                where cuenta_id = :new.cuenta_id;

                -- inserción en MOVIMIENTO 1
                if v_count > 0 then
                    insert into t_movimiento_insert (num_movimiento, cuenta_id,
                    fecha_movimiento, tipo_movimiento, importe, descripcion,
                    comprobante)
                    values (:new.num_movimiento, :new.cuenta_id,
                    :new.fecha_movimiento, :new.tipo_movimiento,
                    :new.importe, :new.descripcion, :new.comprobante);

                    insert into movimiento_1
                    select *
                     from t_movimiento_insert
                     where num_movimiento = :new.num_movimiento
                     and cuenta_id = :new.cuenta_id;

                    delete from t_movimiento_insert
                    where num_movimiento = :new.num_movimiento
                    and cuenta_id = :new.cuenta_id;
                else
                    raise_application_error(-20001,
                    'Error de Integridad para el campo CUENTA_ID: '
                    || :new.cuenta_id
                    || ' No se encontró el registro padre en los fragmentos');
                end if;
            end if;
        when deleting then

            -- checar la fecha para ver en que fragmento se hará la inserción
            v_fecha_movimiento := TO_CHAR(:old.fecha_movimiento, 'YYYY-MM-DD');

            dbms_output.put_line('Fecha del movimiento a eliminar '
            || v_fecha_movimiento);

            -- movimientos después o igual al 2000
            if v_fecha_movimiento >= '2000-01-01' then
                -- verificación si hay correspondencia local para evitar
                -- acceso remoto
                select count(*)
                into v_count
                from cuenta_3
                where cuenta_id = :old.cuenta_id;

                -- delete en MOVIMIENTO 2
                if v_count > 0 then
                    delete from movimiento_2
                     where num_movimiento = :old.num_movimiento
                     and cuenta_id = :old.cuenta_id;
                else
                    select count(*)
                    into v_count
                    from cuenta_4
                    where cuenta_id = :old.cuenta_id;

                    -- delete en MOVIMIENTO 3
                    if v_count > 0 then
                        delete from movimiento_3
                        where num_movimiento = :old.num_movimiento
                        and cuenta_id = :old.cuenta_id;
                    else
                        raise_application_error(-20001,
                        'Error de Integridad para el campo CUENTA_ID: '
                        || :old.cuenta_id
                        || ' No se encontró el registro padre en los fragmentos');
                    end if;
                end if;
            else
                select count(*)
                into v_count
                from cuenta_2
                where cuenta_id = :old.cuenta_id;

                -- delete en MOVIMIENTO 1
                if v_count > 0 then
                    delete from movimiento_1
                    where num_movimiento = :old.num_movimiento
                    and cuenta_id = :old.cuenta_id;
                else
                    raise_application_error(-20001,
                    'Error de Integridad para el campo CUENTA_ID: '
                    || :old.cuenta_id
                    || ' No se encontró el registro padre en los fragmentos');
                end if;
            end if;
        when updating then
            raise_application_error(-20002,
            'No se puede actualizar en esta tabla');
    end case;
end;
/
