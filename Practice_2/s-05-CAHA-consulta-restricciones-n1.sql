--@Autor: Hernández Arrieta Carlos Alberto
--@Fecha creación: 21/Marzo/2019
--@Descripción: Consulta de las restricciones de referencia 
-- de las tablas del nodo s1 en pc-carlos.fi.unam
Prompt mostrando lista de restricciones de referencia
col tabla_padre format A30
col tabla_hija format A30
col nombre_restriccion format A30
set linesize 200
select t1.TABLE_NAME as tabla_hija, t1.CONSTRAINT_NAME as nombre_restriccion,
t2.TABLE_NAME as tabla_padre, t1.CONSTRAINT_TYPE as tipo_restriccion
from USER_CONSTRAINTS t1
join USER_CONSTRAINTS t2
on t1.R_CONSTRAINT_NAME = t2.CONSTRAINT_NAME
order by t2.TABLE_NAME;
