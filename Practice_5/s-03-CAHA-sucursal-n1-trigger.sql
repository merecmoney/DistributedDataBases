--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 14/Mayo/2020
--@Descripción: Creación del trigger para la vista SUCURSAL
-- soporta las operaciones DML INSERT, UPDATE, DELETE
-- para el cahabdd_s1

Prompt conectandose a cahabdd_s1
connect bancos_bdd/bancos_bdd@cahabdd_s1
Prompt Creación del Trigger para SUCURSAL en el nodo cahabdd_s1

-- Fragmentación Derivada respecto a BANCO
create or replace trigger t_dml_sucursal
instead of insert or update or delete on sucursal
declare
    v_count number;
begin
    case
        when inserting then
            -- verificación si hay correspondencia local para evitar
            -- acceso remoto
            select count(*)
             into v_count
             from banco_1
             where banco_id = :new.banco_id;
            -- inserción local
            if v_count > 0 then
                insert into sucursal_1(sucursal_id, num_sucursal, banco_id, pais_id, gerente_id)
                 values (:new.sucursal_id, :new.num_sucursal, :new.banco_id,
                 :new.pais_id, :new.gerente_id);
            else
                select count(*)
                 into v_count
                 from banco_2
                 where banco_id = :new.banco_id;

                -- inserción remota
                if v_count > 0 then
                    insert into sucursal_2(sucursal_id, num_sucursal, banco_id, pais_id, gerente_id)
                     values (:new.sucursal_id, :new.num_sucursal, :new.banco_id,
                     :new.pais_id, :new.gerente_id);
                else
                    raise_application_error(-20001,
                    'Error de Integridad para el campo BANCO_ID: '
                    || :new.banco_id
                    || ' No se encontró el registro padre en los fragmentos');
                end if;
            end if;
        when deleting then
            -- verificación para saber en que sitio está el registro
            -- que deseamos borrar
            select count(*)
             into v_count
             from banco_1
             where banco_id = :old.banco_id;
            -- delete local
            if v_count > 0 then
                delete from sucursal_1
                 where sucursal_id = :old.sucursal_id;
            else
                select count(*)
                 into v_count
                 from banco_2
                 where banco_id = :old.banco_id;
                -- delete remoto
                if v_count > 0 then
                    delete from sucursal_2
                     where sucursal_id = :old.sucursal_id;
                else
                    raise_application_error(-20001,
                    'Error de Integridad para el campo BANCO_ID: '
                    || :old.banco_id
                    || ' No se encontró el registro padre en los fragmentos');
                end if;
            end if;
        when updating then
            raise_application_error(-20002,
            'No se puede actualizar en esta tabla');
    end case;
end;
/
show errors;
Prompt Listo
exit
