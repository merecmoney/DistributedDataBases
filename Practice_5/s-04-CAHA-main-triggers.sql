--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 18/05/2020
--@Descripción: Creación de triggers para transparencia DML
-- con operaciones insert, delete y update
whenever sqlerror exit rollback
Prompt =================================
Prompt creando triggers en S1
connect bancos_bdd/bancos_bdd@cahabdd_s1
Prompt =================================
Prompt creando trigger para pais
@s-03-CAHA-pais-trigger.sql
show errors
Prompt creando trigger para sucursal
@s-03-CAHA-sucursal-n1-trigger.sql
show errors
Prompt creando trigger para cuenta
@s-03-CAHA-cuenta-n1-trigger.sql
show errors
Prompt creando trigger para movimiento
@s-03-CAHA-movimiento-n1-trigger.sql
show errors
Prompt =================================
Prompt creando triggers en S2
connect bancos_bdd/bancos_bdd@cahabdd_s2
Prompt =================================
Prompt creando trigger para pais
@s-03-CAHA-pais-trigger.sql
show errors
Prompt creando trigger para sucursal
@s-03-CAHA-sucursal-n2-trigger.sql
show errors
Prompt creando trigger para cuenta
@s-03-CAHA-cuenta-n2-trigger.sql
show errors
Prompt creando trigger para movimiento
@s-03-CAHA-movimiento-n2-trigger.sql
show errors
Prompt Listo!
exit
