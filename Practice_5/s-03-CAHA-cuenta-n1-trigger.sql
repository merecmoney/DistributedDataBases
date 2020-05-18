--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 14/Mayo/2020
--@Descripción: Creación del trigger para la vista CUENTA
-- soporta las operaciones DML INSERT, UPDATE, DELETE
-- para el cahabdd_s1

create or replace trigger t_dml_cuenta
instead of insert or update or delete on cuenta

declare
    v_count number;
begin
    case
        when inserting then
            -- verificación si hay correspondencia local para evitar
            -- acceso remoto
            select count(*)
             into v_count
             from sucursal_1
             where sucursal_id = :new.sucursal_id;
            -- inserción local
            if v_count > 0 then
                insert into cuenta_3 (cuenta_id, num_cuenta, tipo_cuenta,
                 sucursal_id)
                values (:new.cuenta_id, :new.num_cuenta, :new.tipo_cuenta,
                 :new.sucursal_id);
            else
                select count(*)
                 into v_count
                 from sucursal_2
                 where sucursal_id = :new.sucursal_id;
                 -- inserción remota
                if v_count > 0 then
                    insert into cuenta_4 (cuenta_id, num_cuenta, tipo_cuenta,
                     sucursal_id)
                    values (:new.cuenta_id, :new.num_cuenta, :new.tipo_cuenta,
                    :new.sucursal_id);
                else
                    raise_application_error(-20001,
                    'Error de Integridad para el campo SUCURSAL_ID: '
                    || :new.sucursal_id
                    || ' No se encontró el registro padre en los fragmentos');
                end if;
            end if;

            -- sino se mando ningún error entonces significa que podemos
            -- también insertar en los fragmentos verticales

            -- inserción local
            insert into cuenta_1 (cuenta_id, nip, saldo)
            values (:new.cuenta_id, :new.nip, :new.saldo);

            -- inserción remota del BLOB
            -- para insertar el binario se hace uso de la tabla temporal
            insert into t_cuenta_insert (cuenta_id, contrato)
            values (:new.cuenta_id, :new.contrato);

            insert into cuenta_2
                select *
                from t_cuenta_insert
                where cuenta_id = :new.cuenta_id;

            delete from t_cuenta_insert
             where cuenta_id = :new.cuenta_id;

        when deleting then
            -- verificación para saber en que sitio está el registro
            -- que deseamos borrar
            select count(*)
             into v_count
             from sucursal_1
             where sucursal_id = :old.sucursal_id;
            -- delete local
            if v_count > 0 then
                delete from cuenta_3
                 where cuenta_id = :old.cuenta_id;
            else
                select count(*)
                 into v_count
                 from sucursal_2
                 where sucursal_id = :old.sucursal_id;
                -- delete remoto
                if v_count > 0 then
                    delete from cuenta_4
                     where cuenta_id = :old.cuenta_id;
                else
                    raise_application_error(-20001,
                    'Error de Integridad para el campo SUCURSAL_ID: '
                    || :new.sucursal_id
                    || ' No se encontró el registro padre en los fragmentos');
                end if;
            end if;

            delete from cuenta_1
             where cuenta_id = :old.cuenta_id;

            -- borrar el BLOB
            delete from cuenta_2
             where cuenta_id = :old.cuenta_id;

        when updating then
            raise_application_error(-20002,
            'No se puede actualizar en esta tabla');
    end case;
end;
/
