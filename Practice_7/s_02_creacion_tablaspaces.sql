--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 12/Junio/2020
--@Descripción: Creación de tablespaces
prompt Conectandose a cahabdd_s1 como usuario SYS
connect sys@cahabdd_s1 as sysdba
prompt creando tablespace autos_tbs_0
create tablespace autos_tbs_0
datafile '/u01/app/oracle/oradata/CAHBDD/cahabdd_s1/autos_tbs_0.dbf'
size 100m
autoextend on next 50m
maxsize 5000m;
prompt creando tablespace autos_tbs_1
create tablespace autos_tbs_1
datafile '/u01/app/oracle/oradata/CAHBDD/cahabdd_s1/autos_tbs_1.dbf'
size 10m
autoextend on next 5m
maxsize 50m;
prompt creando tablespace autos_tbs_3
create tablespace autos_tbs_2
datafile '/u01/app/oracle/oradata/CAHBDD/cahabdd_s1/autos_tbs_2.dbf'
size 10m
autoextend on next 5m
maxsize 50m;
prompt creando tablespace autos_tbs_3
create tablespace autos_tbs_3
datafile '/u01/app/oracle/oradata/CAHBDD/cahabdd_s1/autos_tbs_3.dbf'
size 10m
autoextend on next 5m
maxsize 50m;
prompt creando tablespace autos_tbs_4
create tablespace autos_tbs_4
datafile '/u01/app/oracle/oradata/CAHBDD/cahabdd_s1/autos_tbs_4.dbf'
size 10m
autoextend on next 5m
maxsize 50m;
prompt creando tablespace autos_tbs_5
create tablespace autos_tbs_5
datafile '/u01/app/oracle/oradata/CAHBDD/cahabdd_s1/autos_tbs_5.dbf'
size 10m
autoextend on next 5m
maxsize 50m;
prompt asignando como tablespace default autos_tbs_0 a
prompt caha_particiones_bdd
alter user caha_particiones_bdd default tablespace autos_tbs_0
quota unlimited on autos_tbs_0;
prompt asignando cuota ilimitada sobre el tablespace autos_tbs_1 a
prompt caha_particiones_bdd
alter user caha_particiones_bdd quota unlimited on autos_tbs_1;
prompt asignando cuota ilimitada sobre el tablespace autos_tbs_2 a
prompt caha_particiones_bdd
alter user caha_particiones_bdd quota unlimited on autos_tbs_2;
prompt asignando cuota ilimitada sobre el tablespace autos_tbs_3 a
prompt caha_particiones_bdd
alter user caha_particiones_bdd quota unlimited on autos_tbs_3;
prompt asignando cuota ilimitada sobre el tablespace autos_tbs_4 a
prompt caha_particiones_bdd
alter user caha_particiones_bdd quota unlimited on autos_tbs_4;
prompt asignando cuota ilimitada sobre el tablespace autos_tbs_5 a
prompt caha_particiones_bdd
alter user caha_particiones_bdd quota unlimited on autos_tbs_5;
exit
