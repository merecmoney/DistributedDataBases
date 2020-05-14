--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 14/Mayo/2020
--@Descripción: Creación del trigger para la vista PAIS
-- soporta las operaciones DML INSERT, UPDATE, DELETE
-- para el cahabdd_s1

Prompt conectandose a cahabdd_s2
connect bancos_bdd/bancos_bdd@cahabdd_s2
Prompt Creación del Trigger para PAIS en el nodo cahabdd_s2

create or replace trigger t_dml_pais
instead of insert or update or delete on pais

declare

begin
    case
        when inserting then
            -- checa si está el nuevo registro en la zona económica A
            if :new.zona_economica = 'B' then
                insert into pais_2 (pais_id, clave, nombre, zona_economica)
                 values (:new.pais_id ,:new.clave, :new.nombre, :new.zona_economica);
            -- checa si está el nuevo registro en la zona económica A
            elsif :new.zona_economica = 'A' then
                insert into pais_1 (pais_id, clave, nombre, zona_economica)
                 values (:new.pais_id ,:new.clave, :new.nombre, :new.zona_economica);
            -- si la zona económica es incorrecta
            else
                raise_application_error(-20001,
                'Valor incorrecto para el campo zona económica : '
                || :new.zona_economica
                || ' Solo se permiten los valores A , B ');
            end if;

        when deleting then
            -- checa si está el registro en la zona económica B
            if :old.zona_economica = 'B' then
                delete from pais_2
                 where pais_id = :old.pais_id;
            -- checa si está el registro en la zona económica A
            elsif :old.zona_economica = 'A' then
                delete from pais_1
                 where pais_id = :old.pais_id;
            -- si la zona económica es incorrecta
            else
                raise_application_error(-20001,
                'Valor incorrecto para el campo zona económica : '
                || :old.zona_economica
                || ' Solo se permiten los valores A , B ');
            end if;

        when updating then
            -- el registro se queda en el sitio cahabdd_s2
            if :new.zona_economica = 'B' and :old.zona_economica = 'B' then
                update pais_2
                   set pais_id = :new.pais_id,
                    clave = :new.clave,
                    nombre = :new.nombre,
                    zona_economica = :new.zona_economica
                 where pais_id = :old.pais_id;
            -- el registro cambia de sitio cahabdd_s1 -> cahabdd_s2
            elsif :new.zona_economica = 'B' and :old.zona_economica = 'A' then
                delete from pais_1
                 where pais_id = :old.pais_id;

                insert into pais_2 (pais_id, clave, nombre, zona_economica)
                 values (:new.pais_id ,:new.clave, :new.nombre, :new.zona_economica);
            -- el registro se queda en el sitio cahabdd_s1
            elsif :new.zona_economica = 'A' and :old.zona_economica = 'A' then
                update pais_1
                   set pais_id = :new.pais_id,
                    clave = :new.clave,
                    nombre = :new.nombre,
                    zona_economica = :new.zona_economica
                 where pais_id = :old.pais_id;
            -- el registro cambia de sitio cahabdd_s2 -> cahabdd_s1
            elsif :new.zona_economica = 'A' and :old.zona_economica = 'B' then
                delete from pais_2
                 where pais_id = :old.pais_id;

                insert into pais_1 (pais_id, clave, nombre, zona_economica)
                 values (:new.pais_id ,:new.clave, :new.nombre, :new.zona_economica);
            else
                raise_application_error(-20001,
                'Valor incorrecto para el campo zona económica : '
                || :new.zona_economica
                || ' Solo se permiten los valores A , B ');
            end if;
    end case;
end;
/
show errors;
Prompt Listo
exit;