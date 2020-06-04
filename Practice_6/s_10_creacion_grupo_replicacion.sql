--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 1/Junio/2020
--@Descripción: Creación de grupo de refresh

prompt conectando a cahabdd_s2
connect caha_replica_bdd/caha_replica_bdd@cahabdd_s2

begin
    dbms_refresh.make(
        name => 'pagos_auto_refresh_g1',
        list => 'mv_agencia, mv_auto',
        next_date => sysdate,
        interval => 'sysdate + 10/(24*60)',
        refresh_after_errors => false
    );
end;
/

begin
    dbms_refresh.add(
        name => 'pagos_auto_refresh_g1',
        list => 'mv_cliente',
        lax => false --true si la vista va a realizar cambio de grupo.
    );
end;
/

exit;
