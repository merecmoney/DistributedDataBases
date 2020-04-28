--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 27/Abril/2020
--@Descripción: Creación de sinónimos
Prompt conectandose a cahabdd_s1
connect bancos_bdd/bancos_bdd@cahabdd_s1
Prompt creando sinónimos en cahabdd_s1

Prompt creando sinónimos para los fragmentos de BANCO
create or replace synonym banco_1 for F_CAH_BANCO_1;
create or replace synonym banco_2 for F_CAH_BANCO_2@cahabdd_s2;

Prompt creando sinónimos para los fragmentos de PAIS
create or replace synonym pais_1 for F_CAH_PAIS_1;
create or replace synonym pais_2 for F_CAH_PAIS_2@cahabdd_s2;

Prompt creando sinónimos para los fragmentos de SUCURSAL
create or replace synonym sucursal_1 for F_CAH_SUCURSAL_1;
create or replace synonym sucursal_2 for F_CAH_SUCURSAL_2@cahabdd_s2;

Prompt creando sinónimos para los fragmentos de EMPLEADO
create or replace synonym empleado_1 for F_CAH_EMPLEADO_1;
create or replace synonym empleado_2 for F_CAH_EMPLEADO_2@cahabdd_s2;

Prompt creando sinónimos para los fragmentos de CUENTA
create or replace synonym cuenta_1 for F_CAH_CUENTA_1;
create or replace synonym cuenta_2 for F_CAH_CUENTA_2@cahabdd_s2;
create or replace synonym cuenta_3 for F_CAH_CUENTA_3;
create or replace synonym cuenta_4 for F_CAH_CUENTA_4@cahabdd_s2;

Prompt creando sinónimos para los fragmentos de MOVIMIENTO
create or replace synonym movimiento_1 for F_CAH_MOVIMIENTO_1@cahabdd_s2;
create or replace synonym movimiento_2 for F_CAH_MOVIMIENTO_2;
create or replace synonym movimiento_3 for F_CAH_MOVIMIENTO_3@cahabdd_s2;



Prompt conectandose a cahabdd_s2
connect bancos_bdd/bancos_bdd@cahabdd_s2
Prompt creando sinónimos en cahabdd_s2

Prompt creando sinónimos para los fragmentos de BANCO
create or replace synonym banco_1 for F_CAH_BANCO_1@cahabdd_s1;
create or replace synonym banco_2 for F_CAH_BANCO_2;

Prompt creando sinónimos para los fragmentos de PAIS
create or replace synonym pais_1 for F_CAH_PAIS_1@cahabdd_s1;
create or replace synonym pais_2 for F_CAH_PAIS_2;

Prompt creando sinónimos para los fragmentos de SUCURSAL
create or replace synonym sucursal_1 for F_CAH_SUCURSAL_1@cahabdd_s1;
create or replace synonym sucursal_2 for F_CAH_SUCURSAL_2;

Prompt creando sinónimos para los fragmentos de EMPLEADO
create or replace synonym empleado_1 for F_CAH_EMPLEADO_1@cahabdd_s1;
create or replace synonym empleado_2 for F_CAH_EMPLEADO_2;

Prompt creando sinónimos para los fragmentos de CUENTA
create or replace synonym cuenta_1 for F_CAH_CUENTA_1@cahabdd_s1;
create or replace synonym cuenta_2 for F_CAH_CUENTA_2;
create or replace synonym cuenta_3 for F_CAH_CUENTA_3@cahabdd_s1;
create or replace synonym cuenta_4 for F_CAH_CUENTA_4;

Prompt creando sinónimos para los fragmentos de MOVIMIENTO
create or replace synonym movimiento_1 for F_CAH_MOVIMIENTO_1;
create or replace synonym movimiento_2 for F_CAH_MOVIMIENTO_2@cahabdd_s1;
create or replace synonym movimiento_3 for F_CAH_MOVIMIENTO_3;

Prompt Listo!
exit