--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 12/Junio/2020
--@Descripción: Recolección de Estadísticas y Consulta
-- para mostrar tablas con Particiones
prompt Conectandose a cahabdd_s1 como usuario caha_particiones_bdd
connect caha_particiones_bdd/caha_particiones_bdd@cahabdd_s1

begin
    DBMS_STATS.GATHER_SCHEMA_STATS(
        ownname => 'CAHA_PARTICIONES_BDD'
    );
end;
/
prompt Check Tables and its partitions
SELECT TABLE_NAME,PARTITION_NAME, SUBPARTITION_COUNT,NUM_ROWS
FROM USER_TAB_PARTITIONS ORDER BY TABLE_NAME;
exit
